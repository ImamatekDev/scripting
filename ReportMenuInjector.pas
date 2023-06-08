unit ReportMenuInjector;

interface
uses Injector, Sysutils, BankConst, ScriptConst;

type
  TReportInjector = class(TInjector)
  private
    procedure GenerateMain;
  protected
    procedure set_scripting_parameterize; override;
  public
    procedure GenerateScript; override;

  end;

implementation
uses Classes;
{ TReportInjector }

procedure TReportInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := SCRIPTING_REPORT_MENU;
end;

procedure TReportInjector.GenerateMain;
begin
  ClearScript;
  CreateMenu;
  MainAddCustomReport;
  Script.Add := 'begin                                                          ';
  Script.Add := '  AddCustomReport;                                             ';
  Script.Add := 'end.                                                           ';
end;

procedure TReportInjector.GenerateScript;
begin
  GenerateMain;
  InjectToDB( fnMain );
end;

initialization
  Classes.RegisterClass( TReportInjector );
end.
