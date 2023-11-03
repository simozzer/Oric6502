program OricMazeBuilder;

uses
  Vcl.Forms,
  frmMazeDeigner in 'frmMazeDeigner.pas' {Form1},
  MazeDrawGrid in 'MazeDrawGrid.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
