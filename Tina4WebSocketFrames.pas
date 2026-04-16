unit Tina4WebSocketFrames;

{
  Tina4WebSocketFrames

  Shared WebSocket frame encoder, decoder, and constants used by both
  Tina4WebSocketClient and Tina4WebSocketServer. RFC 6455.

  Both sides need the same opcodes, the same close-code parsing, and the
  same wire format — they only differ in masking direction:
    * client -> server frames MUST be masked
    * server -> client frames MUST NOT be masked

  EncodeFrame takes an explicit AMask flag so it serves both callers
  without duplicating the bit-twiddling logic.
}

interface

uses
  System.SysUtils, System.Classes;

const
  // RFC 6455 opcodes
  WS_OP_CONTINUATION = $00;
  WS_OP_TEXT         = $01;
  WS_OP_BINARY       = $02;
  WS_OP_CLOSE        = $08;
  WS_OP_PING         = $09;
  WS_OP_PONG         = $0A;

  WS_FIN_BIT         = $80;
  WS_MASK_BIT        = $80;

  // Magic GUID concatenated with Sec-WebSocket-Key during handshake
  // and SHA1+base64'd to produce Sec-WebSocket-Accept.
  WS_GUID = '258EAFA5-E914-47DA-95CA-C5AB0DC85B11';

  // Standard close codes
  WS_CLOSE_NORMAL          = 1000;
  WS_CLOSE_GOING_AWAY      = 1001;
  WS_CLOSE_PROTOCOL_ERROR  = 1002;
  WS_CLOSE_UNSUPPORTED     = 1003;
  WS_CLOSE_ABNORMAL        = 1006;  // never sent on the wire
  WS_CLOSE_INVALID_PAYLOAD = 1007;
  WS_CLOSE_POLICY          = 1008;
  WS_CLOSE_TOO_LARGE       = 1009;
  WS_CLOSE_INTERNAL_ERROR  = 1011;

type
  /// <summary>
  /// A single decoded WebSocket frame. Used as the return value of
  /// ReadFrame so callers don't juggle a half-dozen out-params.
  /// </summary>
  TTina4WSFrame = record
    Fin: Boolean;
    Opcode: Byte;
    Payload: TBytes;
  end;

  /// <summary>
  /// Function the frame reader uses to pull bytes off the wire. Both
  /// the client (TCP socket / TLS) and server (raw TCP) supply their
  /// own byte source.
  /// </summary>
  TWSReadBytesFunc = reference to function(ALen: Integer): TBytes;

/// <summary>
/// Generates a 4-byte mask key. Plain Random() — fine for masking
/// purposes (the mask isn't a security feature, it's just there to
/// thwart broken proxies confusing WS traffic for HTTP).
/// </summary>
function GenerateMaskKey: TBytes;

/// <summary>
/// Encodes a single WebSocket frame.
/// AMask = True for client->server (masks payload, sets MASK bit).
/// AMask = False for server->client (no mask, MASK bit clear).
/// </summary>
function EncodeFrame(AOpcode: Byte; const APayload: TBytes;
  AMask: Boolean): TBytes;

/// <summary>
/// Reads exactly one raw frame off the wire using AReadBytes for I/O.
/// Reassembles fragmented messages by accumulating CONTINUATION frames
/// until FIN — caller gets back a single coherent message.
/// Throws on protocol violations or short reads.
/// </summary>
function ReadFrame(AReadBytes: TWSReadBytesFunc): TTina4WSFrame;

/// <summary>
/// Builds a CLOSE frame payload: 2-byte big-endian code + UTF-8 reason.
/// Pass to EncodeFrame with WS_OP_CLOSE.
/// </summary>
function BuildClosePayload(ACode: Integer; const AReason: string): TBytes;

/// <summary>
/// Parses a CLOSE frame payload. Returns 1005 (no status) if the
/// payload is empty, per RFC 6455.
/// </summary>
procedure ParseClosePayload(const APayload: TBytes;
  out ACode: Integer; out AReason: string);

implementation

function GenerateMaskKey: TBytes;
begin
  SetLength(Result, 4);
  Result[0] := Byte(Random(256));
  Result[1] := Byte(Random(256));
  Result[2] := Byte(Random(256));
  Result[3] := Byte(Random(256));
end;

function EncodeFrame(AOpcode: Byte; const APayload: TBytes;
  AMask: Boolean): TBytes;
var
  Header: TBytes;
  MaskKey: TBytes;
  PayloadLen: Int64;
  I, Offset: Integer;
  MaskBit: Byte;
begin
  PayloadLen := Length(APayload);
  if AMask then
    MaskBit := WS_MASK_BIT
  else
    MaskBit := 0;

  // Header size depends on payload length encoding.
  if PayloadLen <= 125 then
    SetLength(Header, 2)
  else if PayloadLen <= 65535 then
    SetLength(Header, 4)
  else
    SetLength(Header, 10);

  // FIN + opcode (single-frame messages only — fragmentation is a
  // higher-layer concern; senders here always ship one full message).
  Header[0] := WS_FIN_BIT or AOpcode;

  // Payload length + optional MASK bit
  if PayloadLen <= 125 then
    Header[1] := MaskBit or Byte(PayloadLen)
  else if PayloadLen <= 65535 then
  begin
    Header[1] := MaskBit or 126;
    Header[2] := Byte(PayloadLen shr 8);
    Header[3] := Byte(PayloadLen);
  end
  else
  begin
    Header[1] := MaskBit or 127;
    for I := 0 to 7 do
      Header[2 + I] := Byte(PayloadLen shr ((7 - I) * 8));
  end;

  if AMask then
  begin
    MaskKey := GenerateMaskKey;
    SetLength(Result, Length(Header) + 4 + Length(APayload));
    Move(Header[0], Result[0], Length(Header));
    Move(MaskKey[0], Result[Length(Header)], 4);
    Offset := Length(Header) + 4;
    for I := 0 to Length(APayload) - 1 do
      Result[Offset + I] := APayload[I] xor MaskKey[I mod 4];
  end
  else
  begin
    SetLength(Result, Length(Header) + Length(APayload));
    Move(Header[0], Result[0], Length(Header));
    if Length(APayload) > 0 then
      Move(APayload[0], Result[Length(Header)], Length(APayload));
  end;
end;

function ReadFrame(AReadBytes: TWSReadBytesFunc): TTina4WSFrame;
var
  Header: TBytes;
  B0, B1: Byte;
  Opcode, FinalOpcode: Byte;
  Fin, Masked: Boolean;
  PayloadLen: UInt64;
  MaskKey, FramePayload, MessageBuf, Ext: TBytes;
  I: Integer;
begin
  MessageBuf := nil;
  FinalOpcode := 0;

  // Each iteration reads exactly one frame off the wire. If FIN=1 on
  // a non-control frame (or any control frame), we return; otherwise
  // we accumulate and read the next CONTINUATION frame.
  while True do
  begin
    Header := AReadBytes(2);
    if Length(Header) < 2 then
      raise Exception.Create('Short frame header');
    B0 := Header[0];
    B1 := Header[1];

    Fin := (B0 and WS_FIN_BIT) <> 0;
    Opcode := B0 and $0F;
    Masked := (B1 and WS_MASK_BIT) <> 0;
    PayloadLen := B1 and $7F;

    // Extended payload length
    if PayloadLen = 126 then
    begin
      Ext := AReadBytes(2);
      PayloadLen := (UInt64(Ext[0]) shl 8) or UInt64(Ext[1]);
    end
    else if PayloadLen = 127 then
    begin
      Ext := AReadBytes(8);
      PayloadLen := 0;
      for I := 0 to 7 do
        PayloadLen := (PayloadLen shl 8) or UInt64(Ext[I]);
    end;

    if Masked then
      MaskKey := AReadBytes(4)
    else
      MaskKey := nil;

    if PayloadLen > 0 then
    begin
      FramePayload := AReadBytes(Integer(PayloadLen));
      if Masked and (Length(MaskKey) = 4) then
        for I := 0 to Length(FramePayload) - 1 do
          FramePayload[I] := FramePayload[I] xor MaskKey[I mod 4];
    end
    else
      FramePayload := nil;

    // Control frames (opcode >= 0x08) cannot be fragmented and must
    // not interrupt a fragmented data message — return them straight
    // away so the caller can react (close, ping, pong).
    if Opcode >= $08 then
    begin
      Result.Fin := Fin;
      Result.Opcode := Opcode;
      Result.Payload := FramePayload;
      Exit;
    end;

    // Data frame
    if Opcode <> WS_OP_CONTINUATION then
    begin
      FinalOpcode := Opcode;
      MessageBuf := FramePayload;
    end
    else if (MessageBuf <> nil) and (FramePayload <> nil) then
    begin
      var OldLen := Length(MessageBuf);
      SetLength(MessageBuf, OldLen + Length(FramePayload));
      Move(FramePayload[0], MessageBuf[OldLen], Length(FramePayload));
    end;

    if Fin then
    begin
      Result.Fin := True;
      Result.Opcode := FinalOpcode;
      Result.Payload := MessageBuf;
      Exit;
    end;
    // Else loop and read the next CONTINUATION frame.
  end;
end;

function BuildClosePayload(ACode: Integer; const AReason: string): TBytes;
var
  ReasonBytes: TBytes;
begin
  ReasonBytes := TEncoding.UTF8.GetBytes(AReason);
  SetLength(Result, 2 + Length(ReasonBytes));
  Result[0] := Byte(ACode shr 8);
  Result[1] := Byte(ACode);
  if Length(ReasonBytes) > 0 then
    Move(ReasonBytes[0], Result[2], Length(ReasonBytes));
end;

procedure ParseClosePayload(const APayload: TBytes;
  out ACode: Integer; out AReason: string);
var
  ReasonBytes: TBytes;
begin
  // RFC 6455: empty CLOSE = 1005 "no status received"
  if (APayload = nil) or (Length(APayload) < 2) then
  begin
    ACode := 1005;
    AReason := '';
    Exit;
  end;
  ACode := (Integer(APayload[0]) shl 8) or Integer(APayload[1]);
  if Length(APayload) > 2 then
  begin
    SetLength(ReasonBytes, Length(APayload) - 2);
    Move(APayload[2], ReasonBytes[0], Length(ReasonBytes));
    AReason := TEncoding.UTF8.GetString(ReasonBytes);
  end
  else
    AReason := '';
end;

end.
