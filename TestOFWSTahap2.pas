unit TestOFWSTahap2;

interface
uses
  Injector, BankConst, System.SysUtils;
type
  TTestOFInjector = class(TInjector)
  private
    procedure GenerateScriptShowMessage;
  protected
    procedure set_scripting_parameterize; override;
  public
    procedure GenerateScript; override;
  end;

implementation


{ TTestOFInjector }

procedure TTestOFInjector.GenerateScriptShowMessage;
begin
  ClearScript;

  Script.Add := EmptyStr;
  Script.Add := 'begin';
  Script.Add := '  ShowMessage(''test'');';
  Script.Add := 'end.';
end;

procedure TTestOFInjector.GenerateScript;
begin
  inherited;

  GenerateScriptShowMessage;
  InjectToDB( fnSalesOrder );
  InjectToDB(fnARInvoice);
end;

procedure TTestOFInjector . set_scripting_parameterize;
begin
  inherited;
  feature_name := 'test';
end;

end.
