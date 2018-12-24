unit uLeafJs;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.WebBrowser, FMX.Controls.Presentation, SG.Scriptgate
  {$IFDEF MSWINDOWS}
  ,System.Win.Registry
  {$ENDIF}
   ;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    WebBrowser1: TWebBrowser;
    btnedit: TButton;
    procedure btneditClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FScriptgate:TScriptgate;
    {$IFDEF MSWINDOWS}
    procedure SetPermissions;
    {$ENDIF}
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

uses System.IOUtils;
 //android js webbrowser devuelve "nombres" con doble comilla
function FixQuotes(text:string):string;
begin
  result :=  StringReplace(text,'"','',[rfReplaceAll]);
end;

procedure TForm2.btneditClick(Sender: TObject);
begin
  if btnedit.text = 'ReadOnly' then
  begin
    FScriptGate.CallScript('toggle("read")',
    procedure(const iResult:string)
    begin
      btnedit.Text:= FixQuotes(iResult);
    end
    );
  end
  else
  if btnedit.text = 'Editing' then
  begin
    FScriptGate.CallScript('toggle("edit")',
    procedure(const iResult:string)
    begin
       btnedit.Text:= FixQuotes(iResult);
    end
    );
  end;
end;

{$IFDEF MSWINDOWS}
procedure TForm2.SetPermissions;
const
  cHomePath = 'SOFTWARE';
  cFeatureBrowserEmulation =
    'Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION\';
  cIE11 = 11001;

var
  Reg: TRegIniFile;
  sKey: string;
begin

  sKey := ExtractFileName(ParamStr(0));
  Reg := TRegIniFile.Create(cHomePath);
  try
    if Reg.OpenKey(cFeatureBrowserEmulation, True) and
      not(TRegistry(Reg).KeyExists(sKey) and (TRegistry(Reg).ReadInteger(sKey)
      = cIE11)) then
      TRegistry(Reg).WriteInteger(sKey, cIE11);
  finally
    Reg.Free;
  end;

  end;
  {$ENDIF}
procedure TForm2.FormCreate(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
    SetPermissions;
    WebBrowser1.URL := 'file://' + GetCurrentDir + '/../../src_js/plotter.html';
  {$ENDIF}
 {$IFDEF ANDROID}
    WebBrowser1.URL := 'file://' + TPath.GetDocumentsPath + PathDelim + 'plotter.html';
 {$ENDIF}

  btnedit.text := 'ReadOnly'   ;
  Fscriptgate:= TScriptgate.create(self,Webbrowser1,'yourorgScheme');
end;

end.
