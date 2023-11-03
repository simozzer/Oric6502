unit MazeDrawGrid;

interface

uses
  Vcl.Grids, Vcl.Controls, System.Classes;

type
 TMazeDrawGrid = class(TCustomDrawGrid)
 protected



  published
    property Align;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    property BevelWidth;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property ColCount;
    property Constraints;
    property Ctl3D;
    property DefaultColWidth;
    property DefaultColAlignment;
    property DefaultRowHeight;
    property DefaultDrawing;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DrawingStyle;
    property Enabled;
    property FixedColor;
    property FixedCols;
    property RowCount;
    property FixedRows;
    property Font;
    property GradientEndColor;
    property GradientStartColor;
    property GridLineWidth;
    property Options;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property Touch;
    property Visible;
    property StyleElements;
    property StyleName;
    property VisibleColCount;
    property VisibleRowCount;

    property OnColumnMoved;
    property OnDrawCell;
    property OnGetEditMask;
    property OnGetEditText;
    property OnRowMoved;
    property OnSelectCell;
    property OnSetEditText;
    property OnTopLeftChanged;

    property OnMouseLeave;
    property OnMouseEnter;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseDown;




 end;


implementation

end.
