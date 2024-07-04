unit Tina4InterposerClasses;

interface

uses
   FMX.ListBox;

type

  TCustomComboBox = class(FMX.ListBox.TCustomComboBox)
    private
      FSelectedItemValue: String;
    published
      property SelectedItemValue: String read FSelectedItemValue write FSelectedItemValue;

  end;



implementation

end.
