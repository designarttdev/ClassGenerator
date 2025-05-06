program ClasseGenerator;

uses
  Vcl.Forms,
  Principal in 'Principal.pas' {FormClassGenerator};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormClassGenerator, FormClassGenerator);
  Application.Run;
end.
