unit uMain;

interface

uses
 System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
 FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,FMX.DialogService,
 FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation,
 FMX.StdCtrls,System.IOUtils;

type
  TfrmMain = class(TForm)
    lblMain: TLabel;
    btnOpen: TButton;
    btnExit: TButton;
    procedure btnExitClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
var rutaLoc:String; //Guarda la ruta al preguntar con el InputBox

implementation

{$R *.fmx}

uses uData;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
Close;
end;



procedure TfrmMain.btnOpenClick(Sender: TObject);
begin
//Pregunta por la ruta del archivo
   InputBox(
 'Abrir el archivo: :' // titulo del dialogo
 , 'Name' // label
 , '' // valores por defecto
 , // accion a realizar despues de cerrar el dialogo
 procedure(const AResult: TModalResult; const AValue: string)
 begin
 //Las rutas dependen del SO
    {$IFDEF MSWINDOWS OR MACOS}
    rutaLoc:=TPath.Combine('.\',AValue);
    {$ENDIF}
    {$IFDEF ANDROID OR IOS}
    rutaLoc:=TPath.Combine(TPath.GetTempPath,AValue);
    {$ENDIF}
  case AResult of
  mrOk:
  begin
    //Si existe solamente abrirlo
    if(FileExists(rutaLoc)) then
    begin
      {$IFDEF MSWINDOWS OR MACOS}
      rutaLoc:=TPath.Combine('.\',AValue);
      {$ENDIF}
      {$IFDEF ANDROID OR IOS}
      rutaLoc:=TPath.Combine(TPath.GetTempPath,AValue);
      {$ENDIF}

      frmData.ruta:=rutaLoc;
      frmData.fileNameLbl.Text:=rutaLoc;
      frmData.memLog.Lines.Clear;
      frmData.memLog.Lines.LoadFromFile(rutaLoc);

      {$IFDEF MSWINDOWS OR MACOS}
      frmData.ShowModal;
      {$ENDIF}
      {$IFDEF ANDROID OR IOS}
      frmData.Show;
      {$ENDIF}

    end
    else  //Si no existe preguntar si quiere crearlo
    begin
     TDialogService.MessageDialog(
     'No existe el archivo'+rutaLoc+'¿Desea crearlo?' // mensaje del dialogo
     , TMsgDlgType.mtConfirmation // tipo de dialogo
     , [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo] // botones
     , TMsgDlgBtn.mbNo // default button
     , 0 // help context
     , procedure(const AResult: TModalResult)
     begin

     case AResult of
     mrYes:
       begin
        //Crear el archivo y cargarlo
        {$IFDEF MSWINDOWS OR MACOS}
        rutaLoc:=TPath.Combine('.\',AValue);
        {$ENDIF}
        {$IFDEF ANDROID OR IOS}
        rutaLoc:=TPath.Combine(TPath.GetTempPath,AValue);
        {$ENDIF}

        frmData.ruta:=rutaLoc;
        frmData.fileNameLbl.Text:=rutaLoc;
        frmData.memLog.Lines.Clear;
        frmData.memLog.Lines.SaveToFile(rutaLoc);
        frmData.memLog.Lines.LoadFromFile(rutaLoc);

        {$IFDEF MSWINDOWS OR MACOS}
        frmData.ShowModal;
        {$ENDIF}
        {$IFDEF ANDROID OR IOS}
        frmData.Show;
        {$ENDIF}
       end;
     mrNo: ;
     end; // case
     end); // f

    end;
  end;
  mrCancel: ;
  end;
 end);
end;

end.
