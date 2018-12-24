program leaflef_fmx_js;

uses
  System.StartUpCopy,
  FMX.Forms,
  uLeafJs in 'uLeafJs.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
