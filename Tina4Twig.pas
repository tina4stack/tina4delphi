/// <summary>
/// Backwards-compatibility shim. The Twig engine has been renamed to Frond
/// for feature-parity with the tina4-python project. Existing code that
/// `uses Tina4Twig;` continues to work — this unit just re-exports the
/// class under its old name via a type alias in Tina4Frond.pas.
///
/// New code should `uses Tina4Frond;` directly.
/// </summary>
unit Tina4Twig;

interface

uses
  Tina4Frond;

type
  /// <summary>Alias retained for source-compatibility. Prefer TTina4Frond.</summary>
  TTina4Twig = Tina4Frond.TTina4Twig;

implementation

end.
