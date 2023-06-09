unit RunningNoFPInjector;

interface
uses Injector, Sysutils, BankConst, Classes;

Type
  TRunningNoFPInjector = Class(TInjector)
  private
    procedure GenerateScriptForMain;
  protected
    procedure set_scripting_parameterize; override;
    procedure InitializeVariable; virtual;
    procedure ShowSettingFP; virtual;
    procedure generateScriptForSI; virtual;
    procedure GenerateForSIDataset; virtual;
    procedure SIBeforePostValidation; virtual;
    procedure TaxRunningNumber; virtual;
    procedure CheckTaxNumber; virtual;
    procedure CustomerStateChange; virtual;
    procedure OnTaxFormNumberChange; virtual;
    procedure cancelTaxNumberWarning;
    procedure tryLock;
    procedure IncrementTaxNo;
    procedure CheckStatusIsTaxable; virtual;
  public
    procedure GenerateScript; override;

  end;

implementation

{ TRunningNoFPInjector }

procedure TRunningNoFPInjector.IncrementTaxNo;
begin
//  Script.Add := 'procedure IncrementTaxNo;                                                                   ';
//  Script.Add := 'var param_next_number : String; ';
//  Script.Add := 'begin                                                                                       ';
//  Script.Add := '  if Dataset.IsMasterNew and (Dataset.State=dsEdit) then begin                               ';
//  Script.Add := '    param_next_number := ''NEXT_FP_NO''; ';
//  Script.Add := '    WriteOption(param_next_number, IncCtlNumber( Dataset.TaxFormNumber.value ) ); ';
//  Script.Add := '  end; ';
//  Script.Add := 'end;                                                                                        ';
//  Script.Add := '';
  Script.Add := 'procedure IncrementTaxNo(updateSql:TjbSQL);';
  Script.Add := 'begin';
  Script.Add := '  RunSQL(updateSql, format(''UPDATE or INSERT INTO Options(ParamOpt, ValueOpt) Values(''''NEXT_FP_NO'''', ''''%s'''')'', [IncCtlNumber(Dataset.TaxFormNumber.AsString)]));';
  Script.Add := '  updateSql.transaction.Commit;';
  Script.Add := '  FP_NO_SAVED := true;';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TRunningNoFPInjector.InitializeVariable;
begin
  Script.Add := 'var ';
  Script.Add := '  MAX_FP           : String; ';
  Script.Add := '  NEXT_FP_NO       : String; ';
  Script.Add := '  increase_tax_number : Boolean = True; ';
  Script.Add := '  isMustChangeTax : Boolean = False; ';
  Script.Add := '  FP_NO_SAVED : Boolean = False; ';
  Script.Add := '';
  Script.Add := 'const dsEdit=2; ';
  Script.Add := '';
  Script.Add := 'procedure getNextTaxNoFromOptionTable; ';
  Script.Add := 'begin ';
  Script.Add := '  NEXT_FP_NO         := ReadOption(''NEXT_FP_NO'',''0001''); ';
  Script.Add := 'end; ';
  Script.Add := 'procedure InitializationVariableFP; ';
  Script.Add := 'begin ';
  Script.Add := '  MAX_FP             := ReadOption(''MAX_FP'',''1000''); ';
  Script.Add := '  getNextTaxNoFromOptionTable; ';
  Script.Add := 'end; ';
  Script.Add := ' ';
end;

procedure TRunningNoFPInjector.OnTaxFormNumberChange;
begin
  Script.Add := 'procedure OnTaxFormNumberChange; ';
  Script.Add := 'var ';
  Script.Add := '  validTaxFormNumber : string; ';
  Script.Add := 'begin ';
  Script.Add := '  if Dataset.InvFromSR.value = 1 then Exit; ';
  Script.Add := '  if Dataset.CustomerID.Value = null then Exit; ';
  Script.Add := ' ';
  Script.Add := '  if (Not Dataset.isMasterNew) then Exit; ';
  Script.Add := ' ';
  Script.Add := '  if Dataset.CustomerIsTaxable.Value = 0 then begin ';
  Script.Add := '    validTaxFormNumber := GetNextNotTaxNumber; ';
  Script.Add := '  end ';
  Script.Add := '  else begin ';
  Script.Add := '    getNextTaxNoFromOptionTable; ';
  Script.Add := '    validTaxFormNumber := NEXT_FP_NO; ';
  Script.Add := '    if (Dataset.Tax1Amount.Value=0) and (Dataset.Tax2Amount.Value=0) and isMustChangeTax then begin ';
  Script.Add := '      validTaxFormNumber := GetNextNotTaxNumber; ';
  Script.Add := '      isMustChangeTax := False; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := ' ';
  Script.Add := '  if (validTaxFormNumber<>dataset.TaxFormNumber.AsString) then begin ';
  Script.Add := '    dataset.TaxFormNumber.AsString := validTaxFormNumber; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := ' ';
end;

procedure TRunningNoFPInjector.TaxRunningNumber;
begin
  ReadOption;
  WriteOption;
  Script.Add := 'function GetNextTaxNumber: String; ';
  Script.Add := 'begin                             ';
  Script.Add := '  InitializationVariableFP; ';
  Script.Add := '  result := NEXT_FP_NO; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function GetNextNotTaxNumber: String; ';
  Script.Add := 'begin ';
  Script.Add := '  result := Dataset.InvoiceNo.Value; ';
  Script.Add := 'end; ';
  Script.Add := ' ';
  Script.Add := 'function MaxFPNo:String; ';
  Script.Add := 'begin ';
  Script.Add := '  InitializationVariableFP; ';
  Script.Add := '  result := MAX_FP; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function IsTaxNoExist(TaxNo: String): Boolean;                                              ';
  Script.Add := 'var qryValidate : TjbSQL;                                                                   ';
  Script.Add := 'begin                                                                                       ';
  Script.Add := '  result := false;                                                                          ';
  Script.Add := '  if TaxNo='''' then exit;                                                                    ';
  Script.Add := '  qryValidate := CreateSQL(TIBTransaction(Dataset.Tx));                                      ';
  Script.Add := '  try                                                                                       ';
  Script.Add := '    RunSQL(qryValidate, format(''Select first 1 a.ARInvoiceID from arinv a where a.taxformnumber=''''%s'''' '+
    'and a.ARInvoiceID<>%d and a.DELIVERYORDER = 0'', [TaxNo, Dataset.ARInvoiceID.value]));';
  Script.Add := '    result := qryValidate.RecordCount>0;                                                       ';
  Script.Add := '  finally                                                                                      ';
  Script.Add := '    qryValidate.Free;                                                                          ';
  Script.Add := '  end;                                                                                         ';
  Script.Add := 'end;                                                                                           ';
  Script.Add := '';
end;



procedure TRunningNoFPInjector.tryLock;
begin
  Script.Add := 'function tryLock(lockSql:TjbSQL):boolean;';
  Script.Add := 'Const';
  Script.Add := '  MAX_WAIT_MS = 5000;';
  Script.Add := '  SLEEP_INTERVAL_MS = 1000;';
  Script.Add := 'var';
  Script.Add := '  canLock : boolean;';
  Script.Add := '  tryCount : integer;';
  Script.Add := '';
  Script.Add := '  procedure tryLockDatabase;';
  Script.Add := '  begin';
  Script.Add := '    Try';
  Script.Add := '      runSQL(lockSql, ''Update options set valueOpt=valueOpt where paramOpt=''''NEXT_FP_NO'''''');';
  Script.Add := '      canLock := true;';
  Script.Add := '    Except';
  Script.Add := '      canLock := false;';
  Script.Add := '    End;';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  canLock := false;';
  Script.Add := '  tryCount := 0;';
  Script.Add := '  Repeat';
  Script.Add := '    tryLockDatabase;';
  Script.Add := '    if (Not canLock) then begin';
  Script.Add := '      tryCount := tryCount + 1;';
  Script.Add := '      sleep(SLEEP_INTERVAL_MS);';
  Script.Add := '    end;';
  Script.Add := '  Until';
  Script.Add := '    ( canLock or ((tryCount*SLEEP_INTERVAL_MS)>=MAX_WAIT_MS) );';
  Script.Add := '';
  Script.Add := '  if (canLock) then begin';
  Script.Add := '    result := true;';
  Script.Add := '  end';
  Script.Add := '  else begin';
  Script.Add := '    result := false;';
  Script.Add := '    RaiseException(''Tax number system in used. Please try again.'');';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TRunningNoFPInjector.GenerateForSIDataset;
begin
  ClearScript;
  InitializeVariable;
  TaxRunningNumber;
  IncrementTaxNo;
  CheckTaxNumber;
  CustomerStateChange;
  SIBeforePostValidation;
  CheckStatusIsTaxable;
  OnTaxFormNumberChange;
  cancelTaxNumberWarning;
  Script.Add := 'begin ';
  Script.Add := '  InitializationVariableFP; ';
//  Script.Add := '  Dataset.TaxFormNumber.OnChangeArray     := @CustomerStateChange; //menimpa taxnumber bawaan default FINA';
  Script.Add := '  Dataset.OnBeforePostValidationArray := @SIBeforePostValidation; ';
//  Script.Add := '  Dataset.CustomerIsTaxable.OnChangeArray := @CustomerStateChange; // mencegah ketika customer yang taxable statusnya di uncheck scr manual maka no FP akan menyesuaikan ';
  Script.Add := '  Dataset.TaxFormNumber.OnChangeArray := @OnTaxFormNumberChange;';
  Script.Add := '  Dataset.add_runtime_procedure := @CheckStatusIsTaxable;';
  Script.Add := '  Dataset.add_runtime_procedure := @cancelTaxNumberWarning;';
  Script.Add := 'end. ';
end;

procedure TRunningNoFPInjector.GenerateScriptForMain;
begin
  ClearScript;
  IsSupervisor;
  ShowSettingFP;
  Script.Add := 'var com : TMenuItem; ';
  Script.Add := 'BEGIN';
  Script.Add := '  com := TMenuItem(Form.FindComponent( ''mnuFPSetting'' )); ';
  Script.Add := '  if com <> nil then com.Free; ';
  Script.Add := '  if not IsSupervisor then Exit; ';
  Script.Add := '  AddCustomMenuSetting(''mnuFPSetting'', ''Setting Faktur Pajak'', ''ShowSettingFP''); ';
  Script.Add := 'END.';

end;

procedure TRunningNoFPInjector.generateScriptForSI;
begin
  ClearScript;
  CreateTx;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  Script.Add := 'procedure triggerRunningNoFP;';
  Script.Add := 'var ';
  Script.Add := '  sql:TjbSQL; ';
  Script.Add := '  jTx : TIBTransaction; ';
  Script.Add := '  oldIsTaxable : integer; ';
  Script.Add := '  oldTaxNo : string; ';
  Script.Add := 'begin ';
  Script.Add := '  if master.isMasterNew then exit; ';
  Script.Add := '  jTx := CreateATx; ';
  Script.Add := '  sql := CreateSQL(jTx); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sql, Format(''Select a.customerIsTaxable, a.taxFormNumber '+
                     'from arinv a where a.arinvoiceid=%d'', '+
                     '[master.ARInvoiceId.AsInteger])); ';
  Script.Add := '    oldIsTaxable := sql.FieldByName(''customerIsTaxable''); ';
  Script.Add := '    oldTaxNo := sql.FieldByName(''taxFormNumber''); ';
  Script.Add := '    if (master.customerIsTaxable.asInteger=oldIsTaxable) then begin ';
  Script.Add := '      master.taxFormNumber.AsString := oldTaxNo; ';
  Script.Add := '    end ';
  Script.Add := '    else begin ';
  Script.Add := '      master.execute_runtime_procedure(''CheckStatusIsTaxable''); ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '    jTx.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure changeTaxNumber; ';
  Script.Add := 'begin ';
  Script.Add := '  if master.isMasterNew then begin ';
  Script.Add := '    master.execute_runtime_procedure(''checkStatusIsTaxable''); ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure cancelTaxNumber;';
  Script.Add := 'begin';
  Script.Add := '  master.execute_runtime_procedure(''cancelTaxNumberWarning'');';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := '  form.DODecorator.cbCustTaxable.onExit := @triggerRunningNoFP; ';
  Script.Add := '  master.customerID.onChangeArray := @changeTaxNumber; '; //JR, BZ 2615
  Script.Add := '  form.OnAfterFormCancel := @cancelTaxNumber;'; // AA, BZ 3658
  Script.Add := 'end. ';
end;

procedure TRunningNoFPInjector.cancelTaxNumberWarning;
begin
  Script.Add := 'procedure cancelTaxNumberWarning;';
  Script.Add := 'begin';
  Script.Add := '  if (dataset.isMasterNew And FP_NO_SAVED) then begin';
  Script.Add := '    showMessage(Format(msgByLanguage(''MSG_FP_NO_CANCEL''), [dataset.TaxFormNumber.AsString]));';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TRunningNoFPInjector.CheckStatusIsTaxable;
begin
  Script.Add := 'procedure CheckStatusIsTaxable; ';
  Script.Add := 'var ';
  Script.Add := '  validTaxFormNumber : string; ';
  Script.Add := 'begin ';
  Script.Add := '  if Dataset.InvFromSR.value = 1 then Exit; ';
  Script.Add := '  if Dataset.CustomerID.Value = null then Exit; ';
  Script.Add := ' ';
  Script.Add := '  if Dataset.CustomerIsTaxable.Value = 0 then begin ';
//  Script.Add := '    Dataset.TaxFormNumber.Value := GetNumberThatDoesNotExist(GetNextNotTaxNumber); ';
  Script.Add := '    validTaxFormNumber := GetNumberThatDoesNotExist(GetNextNotTaxNumber); ';
  Script.Add := '  end ';
  Script.Add := '  else if ( Dataset.CustomerIsTaxable.Value = 1 ) and increase_tax_number then begin ';
//  Script.Add := '    Dataset.TaxFormNumber.Value := GetNumberThatDoesNotExist(GetNextTaxNumber); ';
//  Script.Add := '    if StrToFloat( LastTaxNumber(Dataset.TaxFormNumber.Value) ) > StrToFloat( LastTaxNumber( MaxFPNo ) ) then begin ';
  Script.Add := '    validTaxFormNumber := GetNumberThatDoesNotExist(GetNextTaxNumber); ';
  Script.Add := '    if StrToFloat( LastTaxNumber(validTaxFormNumber) ) > StrToFloat( LastTaxNumber( MaxFPNo ) ) then begin ';
  Script.Add := '      RaiseException(''Nomor Faktur Pajak sudah terlewati batas ''+ ';
  Script.Add := '        ''maksimum''#13#10''Silakan hubungi kantor Pajak Anda untuk ''+ ';
  Script.Add := '        ''mendapatkan''#13#10''Nomor Faktur Pajak yang baru.''); ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  if (validTaxFormNumber<>dataset.TaxFormNumber.AsString) then begin ';
  Script.Add := '    dataset.TaxFormNumber.AsString := validTaxFormNumber; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
end;

procedure TRunningNoFPInjector.CheckTaxNumber;
begin
//  Script.Add := 'function IsNumberAlreadyExist(value: String):Boolean; ';
//  Script.Add := 'var sql : TjbSQL; ';
//  Script.Add := 'begin ';
//  Script.Add := '  result := False; ';
//  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx)); ';
//  Script.Add := '  try ';
//  Script.Add := '    RunSQL( sql, Format(''SELECT TAXFORMNUMBER FROM ARINV WHERE TAXFORMNUMBER = ''''%s'''' '',[value]) ); ';
//  Script.Add := '    if not sql.Eof then begin ';
//  Script.Add := '      result := True; ';
//  Script.Add := '    end; ';
//  Script.Add := '  finally ';
//  Script.Add := '    sql.Free; ';
//  Script.Add := '  end; ';
//  Script.Add := 'end; ';
//  Script.Add := ' ';
//  Script.Add := 'function GetNumberThatDoesNotExist(TaxNumber: String):String; ';
//  Script.Add := 'begin ';
//  Script.Add := '  repeat ';
//  Script.Add := '    if IsNumberAlreadyExist(TaxNumber) then begin ';
//  Script.Add := '      TaxNumber := IncCtlNumber(TaxNumber); ';
//  Script.Add := '    end; ';
//  Script.Add := '  until IsNumberAlreadyExist(TaxNumber) = False; ';
//  Script.Add := '  result := TaxNumber; ';
//  Script.Add := 'end;';
//  Script.Add := '';
  Script.Add := 'function GetNumberThatDoesNotExist(TaxNumber: String):String; ';
  Script.Add := 'var';
  Script.Add := '  isExist : boolean;';
  Script.Add := 'begin ';
  Script.Add := '  isExist := false;';
  Script.Add := '  repeat ';
  Script.Add := '    isExist := IsTaxNoExist(TaxNumber);';
  Script.Add := '    if isExist then begin ';
  Script.Add := '      TaxNumber := IncCtlNumber(TaxNumber); ';
  Script.Add := '    end; ';
  Script.Add := '  until (not isExist); ';
  Script.Add := '  result := TaxNumber; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'function LastTaxNumber(TaxNumber: String):String; ';
  Script.Add := 'var idx : Integer; ';
  Script.Add := '    tax_number : String; ';
  Script.Add := 'begin ';
  Script.Add := '  result := ''''; ';
  Script.Add := '  tax_number := TaxNumber; ';
  Script.Add := '  for idx := Length(tax_number) downto 0 do begin ';
  Script.Add := '    if tax_number[idx] in [''0''..''9''] then begin ';
  Script.Add := '      result := tax_number[idx] + result; ';
  Script.Add := '    end ';
  Script.Add := '    else begin ';
  Script.Add := '      if result = '''' then RaiseException(''Format nomor faktur pajak tidak sesuai''); ';
  Script.Add := '      Break; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoFPInjector.CustomerStateChange;
begin
  Script.Add := 'procedure CustomerStateChange; ';
  Script.Add := 'begin ';
  Script.Add := '  if Dataset.InvFromSR.value = 1 then Exit; ';
  Script.Add := '  if Dataset.CustomerID.Value = null then Exit; ';
  Script.Add := '  if ( Dataset.IsMasterNew ) then begin';
  Script.Add := '    CheckStatusIsTaxable; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := ' ';
end;

procedure TRunningNoFPInjector.GenerateScript;
begin
  GenerateForSIDataset;
  InjectToDB( dnSI );

  GenerateScriptForMain;
  InjectToDB( fnMain );

  generateScriptForSI;
  InjectToDB( fnARInvoice );
end;

procedure TRunningNoFPInjector.set_scripting_parameterize;
begin
  feature_name := 'Running No FP ';
end;


procedure TRunningNoFPInjector.ShowSettingFP;
begin
  CreateFormSetting;
  Script.Add := 'procedure ShowSettingFP; ';
  Script.Add := 'var frmSetting : TForm; ';
  Script.Add := 'begin ';
  Script.Add := '  frmSetting := CreateFormSetting(''frmSetting'', ''Setting Faktur Pajak'', 400, 400);';
  Script.Add := '  try ';
  Script.Add := '    AddControl( frmSetting, ''Nomor FP berikutnya'', ''TEXT'', ''NEXT_FP_NO'', ''0001'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Nomor FP Maksimum'',    ''TEXT'', ''MAX_FP'',     ''1001'', ''0'', ''''); ';
  Script.Add := '    if frmSetting.ShowModal = mrOK then begin ';
  Script.Add := '      SaveToOptions; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    frmSetting.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoFPInjector.SIBeforePostValidation;
begin
//  Script.Add := 'procedure SIBeforePostValidation; ';
//  Script.Add := 'var shall_save_no_faktur : Boolean; ';
//  Script.Add := '    is_taxable : Boolean = False; ';
//  Script.Add := 'begin ';
//  Script.Add := '  shall_save_no_faktur := not Dataset.IsFirstPost; ';
//  Script.Add := '  if ( Dataset.Tax1Amount.Value > 0 ) or ( Dataset.Tax2Amount.Value > 0 ) then begin ';
//  Script.Add := '    is_taxable := True; ';
//  Script.Add := '  end; ';
//  Script.Add := '  if shall_save_no_faktur then begin ';
//  Script.Add := '    if (Dataset.CustomerIsTaxable.value = 1) and not is_taxable then begin ';
//  Script.Add := '      increase_tax_number := False; ';
//  Script.Add := '      Dataset.TaxFormNumber.Value := GetNumberThatDoesNotExist(GetNextNotTaxNumber); ';
//  Script.Add := '    end; ';
//  Script.Add := '    if IsTaxNoExist(Dataset.TaxFormNumber.Value) then begin ';
//  Script.Add := '      CheckStatusIsTaxable; //baca ulang nilai terakhir ';
//  Script.Add := '    end; ';
//  Script.Add := '  end; ';
//  Script.Add := '  if shall_save_no_faktur and Dataset.IsMasterNew then begin ';
//  Script.Add := '    if (Dataset.CustomerIsTaxable.value = 1) and is_taxable then begin ';
//  Script.Add := '      IncrementTaxNo; ';
//  Script.Add := '    end; ';
//  Script.Add := '  end; ';
//  Script.Add := '  increase_tax_number := True; ';
//  Script.Add := 'end; ';
//  Script.Add := ' ';
  tryLock;
  Script.Add := 'procedure SIBeforePostValidation;';
  Script.Add := 'var';
  Script.Add := '  shall_save_no_faktur : Boolean;';
  Script.Add := '  is_taxable : Boolean = False;';
  Script.Add := '  updateTx : TIBTransaction;';
  Script.Add := '  updateSql : TjbSQL;';
  Script.Add := 'begin';
  Script.Add := '  shall_save_no_faktur := not Dataset.IsFirstPost;';
  Script.Add := '  is_taxable := ( (Dataset.Tax1Amount.Value>0) or (Dataset.Tax2Amount.Value>0) );';
  Script.Add := '  if ( shall_save_no_faktur And Dataset.IsMasterNew and (Dataset.State=dsEdit) ) then begin';
  Script.Add := '    if (Dataset.CustomerIsTaxable.value = 1) and is_taxable then begin';
  Script.Add := '      updateTx := CreateATx;';
  Script.Add := '      updateSql := CreateSQL(updateTx);';
  Script.Add := '      Try';
  Script.Add := '        if tryLock(updateSql) then begin';
  Script.Add := '          CheckStatusIsTaxable; //baca ulang nilai terakhir';
  Script.Add := '          IncrementTaxNo(updateSql);';
  Script.Add := '        end;';
  Script.Add := '      Finally';
  Script.Add := '        updateSql.Free;';
  Script.Add := '        updateTx.Free;';
  Script.Add := '      End;';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      increase_tax_number := False;';
  Script.Add := '      Dataset.TaxFormNumber.Value := GetNumberThatDoesNotExist(GetNextNotTaxNumber);';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '  if (NOT is_taxable) and shall_save_no_faktur then begin ';
  Script.Add := '    isMustChangeTax := True; ';
  Script.Add := '    Dataset.TaxFormNumber.Value := GetNumberThatDoesNotExist(GetNextNotTaxNumber);';
  Script.Add := '  end; ';
  Script.Add := '  increase_tax_number := True;';
  Script.Add := 'end;';
  Script.Add := '';
end;

initialization
  Classes.RegisterClass( TRunningNoFPInjector );
end.
