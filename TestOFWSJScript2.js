get = function() {
  return 
{
    name: 'TEST',
    GenerateScript: function() {
      return `
injectToDb(getFormName('fnSalesOrder'), GenerateScriptShowMessage());
injectToDb(getFormName('fnARInvoice'), GenerateScriptShowMessage());
injectToDb(getFormName('fnDeliveryOrder'), GenerateScriptShowMessage2('SCY'));
injectToDb(getFormName('fnARPayment'), GenerateScriptShowMessage2('YCS'));`
    },
    GenerateScriptShowMessage: function() {
      RunOtherProcedure("ExtFn")
        return `
begin
  ShowMessage('test');
  RunOtherProcedure('IntFn');
end.`
},
    GenerateScriptShowMessage2: function(name, DefName = 'test') {
      return `
begin
//  ShowMessage('Test Script Comment');
  ShowMessage('''" + name + "'' SCY ''" + DefName + "''');
  ShowMessage('''" + name + "'' " + "V" + "" + 1 + " ''" + DefName + "''');
  ShowMessage(Format('Test Curly %s Comment', [{'2'} '1']) );
  ShowMessage(Format('Test Curly %s Comment', [(*'2'*) '1']) );
  ShowMessage('Curly Comment');
  ShowMessage('ParenthesesStar');
{
  ShowMessage('Comment Row 1 Curly Comment Script');
  ShowMessage('Comment Row 2 Curly Comment Script');
}
(*
  ShowMessage('Comment Row 1 ParenthesesStar Comment Script');
  ShowMessage('Comment Row 2 ParenthesesStar Comment Script');
*)
end.`
},
    RunOtherProcedure: function(fnName) {
      RunSubProcedure()
      return `
  procedure RunOtherProcedure(fnName: string);
  begin
    ShowMessage('Run " + fnName + " and ' + fnName);
    ShowMessage(Format('%s', [GetSubProcedure]) );
  end;`
},
    RunSubProcedure: function() {
      return `
  function GetSubProcedure: string;
  
    function GetFirstVersion: Integer;
    begin
      Result := 1;
    end;
  
  begin
    Result := 'SubProcedure' + IntToStr(GetFirstVersion);
  end;`
}
}
