unit TestOFWSTahap2;

interface
uses
  Injector, BankConst, System.SysUtils;
type
  TTestOFInjector = class(TInjector)
  private
    procedure GenerateScriptShowMessage;
    procedure GenerateScriptShowMessage2(name: string; DefName: string = 'test');
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

procedure TTestOFInjector.GenerateScriptShowMessage2(name: string; DefName: string = 'test');
begin
  ClearScript;

  Script.Add := EmptyStr;
  Script.Add := 'begin';
  Script.Add := '  ShowMessage(''''''' + name + ''''' SCY ''''' + DefName + ''''''');';
  Script.Add := 'end.';
end;

procedure TTestOFInjector.GenerateScript;
begin
  inherited;

  GenerateScriptShowMessage;
  InjectToDB( fnSalesOrder );
  InjectToDB(fnARInvoice);

  GenerateScriptShowMessage2('SCY');
  InjectToDB( fnDeliveryOrder );

  GenerateScriptShowMessage2('YCS');
  InjectToDB(fnARPayment);

end;

procedure TTestOFInjector . set_scripting_parameterize;
begin
  inherited;
  feature_name := 'test';
end;

end.
