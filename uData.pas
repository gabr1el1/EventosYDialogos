unit uData;

interface

uses
  System.SysUtils, System.Types,System.IOUtils, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.DialogService,
  FMX.Platform;

type
  TfrmData = class(TForm)
    memLog: TMemo;
    ToolBar1: TToolBar;
    backBtn: TButton;
    fileNameLbl: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure backBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    function AppEvent(AAppEvent: TApplicationEvent;
AContext: TObject): Boolean;
  public
    { Public declarations }
    nombre:string;
    ruta:String;
    archOriginal:String;
  end;

var
  frmData: TfrmData;
var modificado: boolean;
var CloseOk:boolean;
var wait:boolean;
var archOriginal:string;
var archTemporal:string;


implementation

{$R *.fmx}

uses uMain;

procedure TfrmData.backBtnClick(Sender: TObject);
begin
  Close;
end;




function TfrmData.AppEvent(AAppEvent: TApplicationEvent;
AContext: TObject): Boolean;
begin
  if AAppEvent = TApplicationEvent.WillTerminate then
  begin
    memLog.Lines.SaveToFile('.\temp.txt');
  end;
  Result := true;
end;


procedure TfrmData.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if(not CloseOk) then
    begin
      if(archOriginal<>memLog.Lines.Text) then
        begin
         TDialogService.MessageDialog('¿Desea guardar los cambios?' // mensaje del dialogo
            , TMsgDlgType.mtConfirmation // tipo de dialogo
            , [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo, TMsgDlgBtn.mbCancel] // botones
            , TMsgDlgBtn.mbNo // default button
            , 0 // help context
            ,  procedure(const AResult: TModalResult)
              begin
                case AResult of
                  mrYes:
                  begin
                    memLog.Lines.SaveToFile(ruta);
                    archOriginal:=memLog.Lines.Text;
                  end;
                  mrNo: memLog.Lines.Clear;
                end; // case
              if AResult<> mrCancel then
              begin
                CloseOk:=true;
                Close;
              end;

            end); // fn
         end
         else CloseOk:=true;
    end;
  CanClose:=CloseOk;

end;

procedure TfrmData.FormDestroy(Sender: TObject);
begin
  memLog.Lines.SaveToFile('temporal.txt');
end;

procedure TfrmData.FormShow(Sender: TObject);
begin
  CloseOk:=false;
  modificado:=false;
  archOriginal:=memLog.Lines.Text;
end;
end.
