unit frmMazeDeigner;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, System.Actions, Vcl.ActnList,
  Vcl.StdCtrls, Vcl.ExtCtrls, MazeDrawGrid;

type
  TForm1 = class(TForm)
    ActionList1: TActionList;
    actGetData: TAction;
    pnlGrid: TPanel;
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
    FbMazeArray: Array [0 .. 247, 0 .. 79] of byte;
    FGrid: TMazeDrawGrid;
    FbDrawing : Boolean;

    function GetCellFromMouseCoordinates(X, Y : Integer): TPoint;

    procedure DoGridMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);

    procedure DoGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure DoGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  protected

    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.actGetDataExecute(Sender: TObject);
var
  X, Y, i: Integer;
  aByte: byte;
  aBit: byte;
  sLine: String;
begin
  Memo1.Lines.Clear;
  for Y := 0 to 79 do
  begin
    sLine := '.byt ';
    X := 0;
    repeat
      aByte := 0;
      if (X > 0) then
        sLine := sLine + ',';

      if FbMazeArray[X, Y] = 0 then
        aByte := aByte + 128;

      if FbMazeArray[X + 1, Y] = 0 then
        aByte := aByte + 64;

      if FbMazeArray[X + 2, Y] = 0 then
        aByte := aByte + 32;

      if FbMazeArray[X + 3, Y] = 0 then
        aByte := aByte + 16;

      if FbMazeArray[X + 4, Y] = 0 then
        aByte := aByte + 8;

      if FbMazeArray[X + 5, Y] = 0 then
        aByte := aByte + 4;

      if FbMazeArray[X + 6, Y] = 0 then
        aByte := aByte + 2;

      if FbMazeArray[X + 7, Y] = 0 then
        aByte := aByte + 1;

      sLine := sLine + '$' + IntToHex(aByte, 2);

      X := X + 8;
    until X >= 247;
    Memo1.Lines.Add(sLine + ',$FF');

  end;

end;

procedure TForm1.actZoomInExecute(Sender: TObject);
begin
  FGrid.DefaultRowHeight := FGrid.DefaultRowHeight + 1;
  FGrid.DefaultColWidth := FGrid.DefaultColWidth + 1;

end;

procedure TForm1.actZoomOutExecute(Sender: TObject);
begin
  if FGrid.DefaultRowHeight > 2 then
  begin

    FGrid.DefaultRowHeight := FGrid.DefaultRowHeight - 1;
    FGrid.DefaultColWidth := FGrid.DefaultColWidth - 1;
  end;

end;

procedure TForm1.AfterConstruction;
begin
  inherited;
  FbDrawing := False;

  FGrid := TMazeDrawGrid.Create(Self);
  pnlGrid.InsertControl(FGrid);
  FGrid.Align := alClient;

  FGrid.OnDrawCell := DrawGrid1DrawCell;
  FGrid.OnSelectCell := DrawGrid1SelectCell;

  FGrid.ColCount := 248;
  FGrid.RowCount := 80;
  FGrid.DefaultColWidth := 7;
  FGrid.DefaultRowHeight := 7;
  FGrid.GridLineWidth := 0;
  FGrid.OnMouseMove := DoGridMouseMove;
  FGrid.OnMouseUp := DoGridMouseUp;
  FGrid.OnMouseDown := DoGridMouseDown;
end;

procedure TForm1.BeforeDestruction;
begin
  inherited;
  pnlGrid.RemoveControl(FGrid);
  FGrid.Free;
end;

procedure TForm1.DoGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  APoint: TPoint;
begin
  if Button = TMouseButton.mbLeft then
  begin
    FbDrawing := True;
    APoint := GetCellFromMouseCoordinates(X,Y);
    FbMazeArray[APoint.X,APoint.Y] := 1;
    FGrid.Invalidate;
  end;

end;

procedure TForm1.DoGridMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  APoint: TPoint;
begin
  if FbDrawing  then
  begin
    APoint := GetCellFromMouseCoordinates(X,Y);
    FbMazeArray[APoint.X,APoint.Y] := 0;
    FGrid.Invalidate;
  end;
end;

procedure TForm1.DoGridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = TMouseButton.mbLeft then
  begin
    FbDrawing := False;
  end;
end;

procedure TForm1.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  AColor: TColor;
begin
  AColor := clWhite;
  if FbMazeArray[ACol, ARow] = 0 then
    AColor := clBlack;

  FGrid.Canvas.Brush.Color := AColor;
  FGrid.Canvas.FillRect(Rect);

end;

procedure TForm1.DrawGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if  FbMazeArray[ACol, ARow] = 0 then
    FbMazeArray[ACol, ARow] := 1
  else
    FbMazeArray[ACol, ARow] := 0;
  FGrid.Invalidate;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
  X, Y: Integer;
begin
  X := 1;

  repeat
    for i := X to (247 - X) do
    begin
      FbMazeArray[i, X] := 1;
      FbMazeArray[i, 79 - X] := 1;
    end;

    for i := X to (79 - X) do
    begin
      FbMazeArray[247 - X, i] := 1;
      FbMazeArray[X, i] := 1;
    end;
    X := X + 2;
  until (X >= 79);
end;

function TForm1.GetCellFromMouseCoordinates(X, Y: Integer): TPoint;
begin
  RESULT.X := (X div FGrid.DefaultColWidth) + FGrid.LeftCol;
  RESULT.Y := (Y div FGrid.DefaultRowHeight) + FGrid.TopRow;
  Memo1.Lines.Add(format('%d,%d',[RESULT.X,RESULT.Y]));
end;

end.
