unit frmMazeDeigner;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, System.Actions, Vcl.ActnList,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    ActionList1: TActionList;
    actGetData: TAction;
    Panel2: TPanel;
    DrawGrid1: TDrawGrid;
    spltGridAndData: TSplitter;
    pnlData: TPanel;
    Memo1: TMemo;
    pnlButtons: TPanel;
    btnGetData: TButton;
    actZoomIn: TAction;
    actZoomOut: TAction;
    btnZoomIn: TButton;
    btnZoomOut: TButton;
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DrawGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure actGetDataExecute(Sender: TObject);
    procedure actZoomInExecute(Sender: TObject);
    procedure actZoomOutExecute(Sender: TObject);
  private
    { Private declarations }
    FbMazeArray: Array[0..247,0..79] of byte;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.actGetDataExecute(Sender: TObject);
var
  x,y,i : Integer;
  aByte : Byte;
  aBit : byte;
  sLine : String;
begin
  Memo1.Lines.Clear;
  for y := 0 to 79 do
  begin
    sLine := '.byt ';
    x := 0;
    repeat
       aByte := 0;
       if (x >0) then sLine := sLine + ',';



       if FbMazeArray[x,y] = 0 then
         aByte := aByte + 128;

       if FbMazeArray[x+1,y] = 0 then
         aByte := aByte + 64;

       if FbMazeArray[x+2,y] = 0 then
         aByte := aByte + 32;

       if FbMazeArray[x+3,y] = 0 then
         aByte := aByte + 16;

       if FbMazeArray[x+4,y] = 0 then
         aByte := aByte + 8;

       if FbMazeArray[x+5,y] = 0 then
         aByte := aByte + 4;

       if FbMazeArray[x+6,y] = 0 then
         aByte := aByte + 2;

       if FbMazeArray[x+7,y] = 0 then
         aByte := aByte + 1;

       sLine := sLine + '$' + IntToHex(aByte,2);



       x := x + 8;
    until x >= 247;
    Memo1.Lines.Add(sLine);

  end;


end;

procedure TForm1.actZoomInExecute(Sender: TObject);
begin
  DrawGrid1.DefaultRowHeight := DrawGrid1.DefaultRowHeight +1;
  DrawGrid1.DefaultColWidth := DrawGrid1.DefaultColWidth +1;

end;

procedure TForm1.actZoomOutExecute(Sender: TObject);
begin
if DrawGrid1.DefaultRowHeight> 2 then
begin

  DrawGrid1.DefaultRowHeight := DrawGrid1.DefaultRowHeight -1;
  DrawGrid1.DefaultColWidth := DrawGrid1.DefaultColWidth -1;
end;

end;

procedure TForm1.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  AColor : TColor;
begin
  AColor := clWhite;
  if FbMazeArray[ACol,ARow] = 0 then AColor := clBlack;

  DrawGrid1.Canvas.Brush.Color := AColor;
  DrawGrid1.Canvas.FillRect(Rect);



end;

procedure TForm1.DrawGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
FbMazeArray[ACol,ARow] := not FbMazeArray[ACol,ARow];
DrawGrid1.Invalidate;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i : Integer;
  x,y : Integer;
begin
  x := 1;

  repeat
  for i := x to (247-x) do
    begin
      FbMazeArray[i,x] := 1;
      FbMazeArray[i,79-x] := 1;
    end;

    for i := x to (79-x) do
    begin
      FbMazeArray[247-x,i] := 1;
      FbMazeArray[x,i] := 1;
    end;
   x := x + 2;
  until (x >= 79);
end;

end.
