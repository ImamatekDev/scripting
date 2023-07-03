unit TaxReportMenuInjector;

interface
uses Injector, Sysutils;

type
  TTaxReportMenuInjector = class(TInjector) //MMD, BZ 3346
  private
    procedure GenerateScriptForMain;
  protected
    procedure set_scripting_parameterize; override;
  public
    procedure GenerateScript; override;
  end;

implementation
uses BankConst;

{ TTaxReportMenuInjector }

procedure TTaxReportMenuInjector.GenerateScriptForMain;
begin
  Script.add := 'procedure EnableTaxReportMenu;';
  Script.add := 'var';
  Script.add := '  comSPT17711   : TComponent;';
  Script.add := '  comMnuPPN1106 : TComponent;';
  Script.add := '  miSPT17711    : TMenuItem;';
  Script.add := '  miMnuPPN1106  : TMenuItem;';
  Script.Add := 'begin';
  Script.Add := '  comSPT17711   := Form.FindComponent(''SPT17711'');';
  Script.Add := '  comMnuPPN1106 := Form.FindComponent(''mnuPPN1106'');';
  Script.Add := '  if comSPT17711 <> nil then begin';
  Script.Add := '    miSPT17711 := TMenuItem(comSPT17711);';
  Script.Add := '    if (miSPT17711<>nil) And (miSPT17711.Visible=False) then begin';
  Script.Add := '      miSPT17711.Visible := True;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '  if comMnuPPN1106 <> nil then begin';
  Script.Add := '    miMnuPPN1106 := TMenuItem(comMnuPPN1106);';
  Script.Add := '    if (miMnuPPN1106<>nil) And (miMnuPPN1106.Visible=False) then begin';
  Script.Add := '      miMnuPPN1106.Visible := True;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := 'begin';
  Script.Add := '  EnableTaxReportMenu;';
  Script.Add := 'end.';
end;

procedure TTaxReportMenuInjector.GenerateScript;
begin
  GenerateScriptForMain;
  InjectToDB( fnMain );
end;

procedure TTaxReportMenuInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := 'Tax Report Menu';
end;

end.
