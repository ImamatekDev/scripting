unit TestOFWSTahap2;

interface
uses
  Injector, BankConst, System.SysUtils;
type
  TTestOFInjector = class(TInjector)
  private
    procedure RunSubProcedure;
    procedure RunOtherProcedure(fnName: string);
    procedure GenerateScriptShowMessage;
    procedure GenerateScriptShowMessage2
    (name: string;
    DefName: string = 'test')
    ;
  protected
    procedure set_scripting_parameterize; override;
  public
    procedure GenerateScript; override;
  end;

implementation


{ TTestOFInjector }

procedure TTestOFInjector.RunOtherProcedure;
begin
  RunSubProcedure;

  Script.Add := EmptyStr;
  Script.Add := 'procedure RunOtherProcedure(fnName: string);';
  Script.Add := 'begin';
  Script.Add := Format('  ShowMessage(''Run %s and '' + fnName);', [fnName]);
  Script.Add := '  ShowMessage(Format(''%s'', [GetSubProcedure]) );';
  Script.Add := 'end;';
end;

procedure TTestOFInjector.RunSubProcedure;
begin
  Script.Add := EmptyStr;
  Script.Add := 'function GetSubProcedure: string;';
  Script.Add := EmptyStr;
  Script.Add := '  function GetFirstVersion: Integer;';
  Script.Add := '  begin';
  Script.Add := '    Result := 1;';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := 'begin';
  Script.Add := '  Result := ''SubProcedure'' + IntToStr(GetFirstVersion);';
  Script.Add := 'end;';
end;

procedure TTestOFInjector.GenerateScriptShowMessage;
begin
  ClearScript;
  RunOtherProcedure('ExtFn');

  Script.Add := EmptyStr;
  Script.Add := 'begin';
  Script.Add := '  ShowMessage(''test'');';
  Script.Add := '  RunOtherProcedure(''IntFn'');';
  Script.Add := 'end.';
end;

procedure TTestOFInjector.GenerateScriptShowMessage2(name: string; DefName: string = 'test');
begin
  ClearScript;

  Script.Add := EmptyStr;
  Script.Add := 'begin';
  // Test Row Comment
  Script.Add := '//  ShowMessage(''Test Script Comment'');';
  Script.Add := '  ShowMessage(''''''' + name + ''''' SCY ''''' + DefName + ''''''');';  //Test Comment After Script
  Script.Add := Format('  ShowMessage(''''''%s'''' %s%d ''''' + DefName + ''''''');', [name, 'V', 1]);

  Script.Add := '  ShowMessage(Format(''Test Curly %s Comment'', [{''2''} ''1'']) );';
  Script.Add := '  ShowMessage(Format(''Test Curly %s Comment'', [(*''2''*) ''1'']) );';
  Script.Add := {Curly Comment}'  ShowMessage(''Curly Comment'');';
  Script.Add := (*ParenthesesStar Comment*)'  ShowMessage(''ParenthesesStar'');';
  Script.Add := '{';
  Script.Add := '  ShowMessage(''Comment Row 1 Curly Comment Script'');';
  Script.Add := '  ShowMessage(''Comment Row 2 Curly Comment Script'');';
  Script.Add := '}';
{
  Script.Add := '  ShowMessage(''Comment Row 1 Curly Comment Function'');';
  Script.Add := '  ShowMessage(''Comment Row 2 Curly Comment Function'');';
}
  Script.Add := '(*';
  Script.Add := '  ShowMessage(''Comment Row 1 ParenthesesStar Comment Script'');';
  Script.Add := '  ShowMessage(''Comment Row 2 ParenthesesStar Comment Script'');';
  Script.Add := '*)';
(*
  Script.Add := '  ShowMessage(''Comment Row 1 ParenthesesStar Comment Function'');';
  Script.Add := '  ShowMessage(''Comment Row 2 ParenthesesStar Comment Function'');';
*)
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
