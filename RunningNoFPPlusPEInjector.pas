unit RunningNoFPPlusPEInjector;

interface
uses Injector, Sysutils, BankConst, Classes, RunningNoFPInjector;


Type
  TRunningNoFPPlusPEInjector = Class(TRunningNoFPInjector)
  protected
    procedure set_scripting_parameterize; override;
    procedure InitializeVariable; override;
    procedure ShowSettingFP; override;
    procedure generateScriptForSI; override;
    procedure GenerateForSIDataset; override;
    procedure SIBeforePostValidation; override;
    procedure OnTaxFormNumberChange; override;
    procedure CheckStatusIsTaxable; override;
  end;

implementation

{ TRunningNoFPPlusPEInjector }

procedure TRunningNoFPPlusPEInjector.ShowSettingFP;
begin
  CreateFormSetting;
  CreateRadioButton;
  CreateCheckBox;
  ReadOption;
  WriteOption;
  TopPos;
  Script.Add := 'procedure ShowSettingFP; ';
  Script.Add := 'var frmSetting : TForm; ';
  Script.Add := '    com: TComponent;';
  Script.Add := '    rbSalesman : TRadioButton;';
  Script.Add := '    rbCustomer : TRadioButton;';
  Script.Add := '    chkAddInfo : TCheckBox;';
  Script.Add := '    PKP_PE_ADD_INFO_ACTIVE : String;';
  Script.Add := '';
  Script.Add := '  procedure cbPKPPEClicked;';
  Script.Add := '  begin';
  Script.Add := '    rbSalesman.Enabled := TCheckBox(com).Checked;';
  Script.Add := '    rbCustomer.Enabled := TCheckBox(com).Checked;';
  Script.Add := '    TComboBox(ScrollBox.FindComponent(''Combo6'')).Enabled := TCheckBox(com).Checked;';
  Script.Add := '    TComboBox(ScrollBox.FindComponent(''Combo7'')).Enabled := TCheckBox(com).Checked;';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  procedure rbSalesmanClicked;';
  Script.Add := '  begin';
  Script.Add := '    TEdit(ScrollBox.FindComponent(''Combo5'')).Text := ''SALESMAN'';';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  procedure rbCustomerClicked;';
  Script.Add := '  begin';
  Script.Add := '    TEdit(ScrollBox.FindComponent(''Combo5'')).Text := ''CUSTOMER'';';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := '  PKP_PE_ADD_INFO_ACTIVE := ReadOption(''PKP_PE_ADD_INFO_ACTIVE'', ''0'');';
  Script.Add := '  frmSetting := CreateFormSetting(''frmSetting'', ''Setting Faktur Pajak'', 400, 400);';
  Script.Add := '  try ';
  Script.Add := '    AddControl( frmSetting, ''Nomor FP berikutnya (1)'', ''TEXT'', ''NEXT_FP_NO'', ''0001'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Nomor FP Maksimum (1)'',    ''TEXT'', ''MAX_FP'',     ''1001'', ''0'', ''''); ';
  //MMD, BZ 3644
  Script.Add := '    AddControl( frmSetting, ''Nomor FP berikutnya (2)'', ''TEXT'', ''NEXT_FP_NO_2'', ''1001'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Nomor FP Maksimum (2)'',    ''TEXT'', ''MAX_FP_2'',     ''2001'', ''0'', ''''); ';
  
  Script.Add := '    AddControl( frmSetting, ''PKP PE'', ''CHECKBOX'', ''PKP_PE'', ''0'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''PKP PE Berdasarkan:'', ''TEXT'', ''PKP_PE_BY'', ''SALESMAN'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, '''', ''CUSTOMFIELD'', ''PKP_PE_SALESMAN'', '''', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, '''', ''CUSTOMFIELD'', ''PKP_PE_CUSTOMER'', '''', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, '''', ''CUSTOMFIELD'', ''PKP_PE_ADD_INFO_CF'', ''CUSTOMFIELD2'', ''0'', ''''); ';

  Script.Add := '    com := ScrollBox.FindComponent(''Combo6'');';
  Script.Add := '    rbSalesman := CreateRadioButton (10, TComboBox(com).Top '+
                                      ', 70, 25, ''Salesman'', TComboBox(com).Parent);';
  Script.Add := '    com := ScrollBox.FindComponent(''Combo7'');';
  Script.Add := '    rbCustomer := CreateRadioButton (10, TComboBox(com).Top '+
                                      ', 70, 25, ''Customer'', TComboBox(com).Parent);';
  Script.Add := '    com := ScrollBox.FindComponent(''Combo8'');';
  Script.Add := '    chkAddInfo := CreateCheckBox(10, TComboBox(com).Top, 70, 25, ''Add. Info'', TComboBox(com).Parent);';
  Script.Add := '    if PKP_PE_ADD_INFO_ACTIVE = ''1'' then chkAddInfo.Checked := True;';

  Script.Add := '    com := ScrollBox.FindComponent(''Combo5'');';
  Script.Add := '    TEdit(com).Visible := False;';
  Script.Add := '    if TEdit(com).Text = ''CUSTOMER'' then';
  Script.Add := '      rbCustomer.Checked := True';
  Script.Add := '    else';
  Script.Add := '      rbSalesman.Checked := True;';
  Script.Add := '    com := ScrollBox.FindComponent(''CheckBox4'');';

  Script.Add := '    TCheckBox(com).OnClick := @cbPKPPEClicked;';
  Script.Add := '    rbSalesman.OnClick := @rbSalesmanClicked;';
  Script.Add := '    rbCustomer.OnClick := @rbCustomerClicked;';
  Script.Add := '    cbPKPPEClicked;';
  Script.Add := '    if frmSetting.ShowModal = mrOK then begin ';
  Script.Add := '      if chkAddInfo.Checked then';
  Script.Add := '        WriteOption(''PKP_PE_ADD_INFO_ACTIVE'', ''1'')';
  Script.Add := '      else';
  Script.Add := '        WriteOption(''PKP_PE_ADD_INFO_ACTIVE'', ''0'');';
  Script.Add := '      SaveToOptions; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    frmSetting.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoFPPlusPEInjector.SIBeforePostValidation;
begin
tryLock;
  Script.Add := 'procedure SIBeforePostValidation;';
  Script.Add := 'var';
  Script.Add := '  shall_save_no_faktur : Boolean;';
  Script.Add := '  is_taxable : Boolean = False;';
  Script.Add := '  updateTx : TIBTransaction;';
  Script.Add := '  updateSql : TjbSQL;';
  Script.Add := 'begin';
  Script.Add := '  if Dataset.InvFromSR.value = 1 then Exit;'; //MMD, BZ 3651
  Script.Add := '  if (((PKP_PE = ''1'') AND (((PKP_PE_BY = ''CUSTOMER'') AND isCustomerPKPPE) OR ((PKP_PE_BY = ''SALESMAN'') AND isSalesmanPKPPE))) ' +
                      'OR ((PKP_PE_ADD_INFO_ACTIVE = ''1'') AND ((GetCustomerField(''Tax1ExemptionNo'') = '''') AND (GetCustomerField(''Tax2ExemptionNo'') = '''')))) then begin';
  Script.Add := '    exit;';
  Script.Add := '  end;';
  Script.Add := '  shall_save_no_faktur := not Dataset.IsFirstPost;';
  Script.Add := '  is_taxable := ( (Dataset.Tax1Amount.Value>0) or (Dataset.Tax2Amount.Value>0) );';
  Script.Add := '  if ( shall_save_no_faktur And Dataset.IsMasterNew and (Dataset.State=dsEdit) ) then begin';
  Script.Add := '    if (Dataset.CustomerIsTaxable.value = 1) then begin';
//  Script.Add := '    if (Dataset.CustomerIsTaxable.value = 1) and is_taxable then begin';
  Script.Add := '      updateTx := CreateATx;';
  Script.Add := '      updateSql := CreateSQL(updateTx);';
  Script.Add := '      Try';
  Script.Add := '        if tryLock(updateSql) then begin';
  Script.Add := '          CheckStatusIsTaxable(updateTx); //baca ulang nilai terakhir';
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
//  Script.Add := '  if (NOT is_taxable) and shall_save_no_faktur then begin ';
//  Script.Add := '    isMustChangeTax := True; ';
//  Script.Add := '    Dataset.TaxFormNumber.Value := GetNumberThatDoesNotExist(GetNextNotTaxNumber);';
//  Script.Add := '  end; ';
  Script.Add := '  increase_tax_number := True;';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TRunningNoFPPlusPEInjector.CheckStatusIsTaxable;
begin
  Script.Add := 'procedure CheckStatusIsTaxable(outerTx: TIBTransaction=nil); ';
  Script.Add := 'var ';
  Script.Add := '  validTaxFormNumber : string; ';
  Script.Add := '';
  Script.Add := '  procedure CheckRunningNo;'; //MMD, BZ 3644
  Script.Add := '  var';
  Script.Add := '    updateCmd : String;';
  Script.Add := '    updateSql : TjbSQL;';
  Script.Add := '    innerTx : TIBTransaction;';
  Script.Add := '  begin';
  Script.Add := '    if StrToFloat(LastTaxNumber(GetOptionsValue(''NEXT_FP_NO''))) > StrToFloat(LastTaxNumber(GetOptionsValue(''MAX_FP''))) then begin';
  Script.Add := '      if (GetOptionsValue(''NEXT_FP_NO_2'') <> '''') AND (GetOptionsValue(''MAX_FP_2'') <> '''') then begin';
//  Script.Add := '        SetOptionsValue(''NEXT_FP_NO'', GetOptionsValue(''NEXT_FP_NO_2''));';
//  Script.Add := '        SetOptionsValue(''MAX_FP'', GetOptionsValue(''MAX_FP_2''));';
//  Script.Add := '        SetOptionsValue(''NEXT_FP_NO_2'', '''');';
//  Script.Add := '        SetOptionsValue(''MAX_FP_2'', '''');';
// AA, BZ 3752
  Script.Add := '        Try';
  Script.Add := '          if (outerTx=nil) then begin';
  Script.Add := '            innerTx := CreateATx;';
  Script.Add := '            updateSql := CreateSQL(innerTx);';
  Script.Add := '          end';
  Script.Add := '          else begin';
  Script.Add := '            updateSql := CreateSQL(outerTx);';
  Script.Add := '          end;';
  Script.Add := '          updateCmd := ''UPDATE options SET valueOpt = ''''%s'''' WHERE  paramopt = ''''%s'''';'';';
  Script.Add := '          RunSQL(updateSql, Format(updateCmd, [GetOptionsValue(''NEXT_FP_NO_2''), ''NEXT_FP_NO'']));';
  Script.Add := '          RunSQL(updateSql, Format(updateCmd, [GetOptionsValue(''MAX_FP_2''), ''MAX_FP'']));';
  Script.Add := '          RunSQL(updateSql, Format(updateCmd, ['''', ''NEXT_FP_NO_2'']));';
  Script.Add := '          RunSQL(updateSql, Format(updateCmd, ['''', ''MAX_FP_2'']));';
  Script.Add := '          updateSql.transaction.commit;';
  Script.Add := '        Finally';
  Script.Add := '          updateSql.Free;';
  Script.Add := '          if (outerTx=nil) then begin';
  Script.Add := '            innerTx.Free;';
  Script.Add := '          end';
  Script.Add := '        End;';
  Script.Add := '        OnTaxFormNumberChange;';
  Script.Add := '      end;';
  Script.Add := '      RaiseException(''Saat ini tidak bisa save SI karena No.FP habis'');';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := 'begin ';
                   //MMD, BZ 3651
  Script.Add := '  if Dataset.InvFromSR.value = 1 then Exit; ';
  Script.Add := '  if Dataset.CustomerID.Value = null then Exit; ';
  Script.Add := '  if (((PKP_PE = ''1'') AND (((PKP_PE_BY = ''CUSTOMER'') AND isCustomerPKPPE) OR ((PKP_PE_BY = ''SALESMAN'') AND isSalesmanPKPPE))) ' +
                      'OR ((PKP_PE_ADD_INFO_ACTIVE = ''1'') AND ((GetCustomerField(''Tax1ExemptionNo'') = '''') AND (GetCustomerField(''Tax2ExemptionNo'') = '''')))) then begin';
  Script.Add := '    exit;';
  Script.Add := '  end;';
  Script.Add := ' ';                                        //MMD, BZ 3638
  Script.Add := '  if (Dataset.CustomerIsTaxable.Value = 0) AND (Not Dataset.GetFromDO.AsBoolean) then begin ';
//  Script.Add := '    Dataset.TaxFormNumber.Value := GetNumberThatDoesNotExist(GetNextNotTaxNumber); ';
  Script.Add := '    validTaxFormNumber := GetNumberThatDoesNotExist(GetNextNotTaxNumber); ';
  Script.Add := '  end ';
  Script.Add := '  else if ( Dataset.CustomerIsTaxable.Value = 1 ) and increase_tax_number then begin ';
//  Script.Add := '    Dataset.TaxFormNumber.Value := GetNumberThatDoesNotExist(GetNextTaxNumber); ';
//  Script.Add := '    if StrToFloat( LastTaxNumber(Dataset.TaxFormNumber.Value) ) > StrToFloat( LastTaxNumber( MaxFPNo ) ) then begin ';
  Script.Add := '    validTaxFormNumber := GetNumberThatDoesNotExist(GetNextTaxNumber); ';
  Script.Add := '    if StrToFloat( LastTaxNumber(validTaxFormNumber) ) > StrToFloat( LastTaxNumber( MaxFPNo ) ) then begin ';
  Script.Add := '      CheckRunningNo;'; //MMD, BZ 3644
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

procedure TRunningNoFPPlusPEInjector.GenerateForSIDataset;
begin
  ClearScript;
  ReadOption;
  InitializeVariable;
  TaxRunningNumber;
  IncrementTaxNo;
  CheckTaxNumber;
  CustomerStateChange;
  SIBeforePostValidation;
  CheckStatusIsTaxable;
  OnTaxFormNumberChange;
  Script.Add := 'function isSalesmanPKPPE : Boolean;';
  Script.Add := 'begin';
  Script.Add := '  if Dataset.SalesmanID.IsNull then exit;';
  Script.Add := '  Result := TExtendedLookupField(Dataset.SalesmanID.FieldLookUp.FieldByName(''ExtendedID'')).FieldLookUp.FieldByName(PKP_PE_SALESMAN).AsBoolean;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'function isCustomerPKPPE : Boolean;';
  Script.Add := 'begin';
  Script.Add := '  if Dataset.CustomerID.IsNull then exit;';
  Script.Add := '  Result := TExtendedLookupField(Dataset.CustomerID.FieldLookUp.FieldByName(''ExtendedID'')).FieldLookUp.FieldByName(PKP_PE_CUSTOMER).AsBoolean;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'function GetCustomerField(fieldname : String): String;';
  Script.Add := 'var';
  Script.Add := '  sql : TjbSQL;';
  Script.Add := '  qry : String;';
  Script.Add := 'begin';
  Script.Add := '  sql := nil;';
  Script.Add := '  try';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '    qry := Format(''SELECT COALESCE(%s, '''''''') %s ' +
                                    'FROM   persondata c ' +
                                           'JOIN custtype ct ' +
                                             'ON c.customertypeid = ct.customertypeid ' +
                                           'JOIN extended e ' +
                                             'ON c.extendedid = e.extendedid ' +
                                    'WHERE c.id = %d;'', [fieldname, fieldname, Dataset.CustomerID.Value]);';
  Script.Add := '    RunSQL(sql, qry);';
  Script.Add := '    Result := sql.FieldByName(fieldname);';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'function GetOptionsValue(paramopt : String) : String;';  //MMD, BZ 3644
  Script.Add := 'var';
  Script.Add := '  sql : TjbSQL;';
  Script.Add := '  qry : String;';
  Script.Add := 'begin';
  Script.Add := '  sql := nil;';
  Script.Add := '  try';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '    qry := Format(''SELECT valueopt ' +
                                    'FROM   options ' +
                                    'WHERE  paramopt = ''''%s'''';'', [paramopt]);';
  Script.Add := '    RunSQL(sql, qry);';
  Script.Add := '    Result := sql.FieldByName(''valueopt'');';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
// AA, BZ 3752
//  Script.Add := 'procedure SetOptionsValue(paramopt, valueopt : String);'; //MMD, BZ 3644
//  Script.Add := 'var';
//  Script.Add := '  setTx : TIBTransaction;';
//  Script.Add := '  setSql : TjbSQL;';
//  Script.Add := '  setQry : String;';
//  Script.Add := 'begin';
//  Script.Add := '  setTx := Nil;';
//  Script.Add := '  setSql := Nil;';
//  Script.Add := '  try';
//  Script.Add := '    setTx := CreateATx;';
//  Script.Add := '    setSql := CreateSQL(setTx);';
//  Script.Add := '    setQry := Format(''UPDATE options ' +
//                                       'SET    valueopt = ''''%s'''' ' +
//                                       'WHERE  paramopt = ''''%s'''';'', [valueopt, paramopt]);';
//  Script.Add := '    RunSQL(setSql, setQry);';
//  Script.Add := '    RunSQL(setSql, setQry);';
//  Script.Add := '  finally';
//  Script.Add := '    setSql.Free;';
//  Script.Add := '    setTx.Free;';
//  Script.Add := '  end;';
//  Script.Add := 'end;';
//  Script.Add := '';
  Script.Add := 'Procedure CheckTaxable;';
  Script.Add := 'Begin';
  Script.Add := '  CheckStatusIsTaxable;';
  Script.Add := 'End;';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := '  InitializationVariableFP; ';
//  Script.Add := '  Dataset.TaxFormNumber.OnChangeArray     := @CustomerStateChange; //menimpa taxnumber bawaan default FINA';
  Script.Add := '  Dataset.OnBeforePostValidationArray := @SIBeforePostValidation; ';
//  Script.Add := '  Dataset.CustomerIsTaxable.OnChangeArray := @CustomerStateChange; // mencegah ketika customer yang taxable statusnya di uncheck scr manual maka no FP akan menyesuaikan ';
  Script.Add := '  Dataset.TaxFormNumber.OnChangeArray := @OnTaxFormNumberChange;';
  Script.Add := '  Dataset.add_runtime_procedure := @CheckTaxable;';
  Script.Add := 'end. ';
end;

procedure TRunningNoFPPlusPEInjector.generateScriptForSI;
begin
  ClearScript;
  CreateTx;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  ReadOption;
  LeftPos;
  TopPos;
  CreateLabel;
  CreateEditBox;
  CreatePickDate;
  InitializeVariable;
  Script.Add := 'var';
  Script.Add := '  lblAddInfo : TLabel;';
  Script.Add := '  edtNPWP : TEdit;';
  Script.Add := '  edtNIK : TEdit;';
  Script.Add := '  dtpRegist : TDateTimePicker;';
  Script.Add := '  edtCustType : TEdit;';
  Script.Add := '  edtOwing : TEdit;';
  Script.Add := '';
  Script.Add := 'procedure triggerRunningNoFP;';
  Script.Add := 'var ';
  Script.Add := '  sql:TjbSQL; ';
  Script.Add := '  jTx : TIBTransaction; ';
  Script.Add := '  oldIsTaxable : integer; ';
  Script.Add := '  oldTaxNo : string; ';
  Script.Add := 'begin ';
  Script.Add := '  if (((PKP_PE = ''1'') AND (((PKP_PE_BY = ''CUSTOMER'') AND isCustomerPKPPE) OR ((PKP_PE_BY = ''SALESMAN'') AND isSalesmanPKPPE))) ' +
                     'OR ((PKP_PE_ADD_INFO_ACTIVE = ''1'') AND ((GetCustomerField(''Tax1ExemptionNo'') = '''') AND (GetCustomerField(''Tax2ExemptionNo'') = '''')))) then begin';
  Script.Add := '    exit;';
  Script.Add := '  end; ';
//  Script.Add := '  if master.isMasterNew then exit; ';
  Script.Add := '  jTx := CreateATx; ';
  Script.Add := '  sql := CreateSQL(jTx); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sql, Format(''Select a.customerIsTaxable, COALESCE(a.taxFormNumber, '''''''') taxFormNumber '+
                     'from arinv a where a.arinvoiceid=%d'', '+
                     '[master.ARInvoiceId.AsInteger])); ';
  Script.Add := '    oldIsTaxable := sql.FieldByName(''customerIsTaxable''); ';
  Script.Add := '    oldTaxNo := sql.FieldByName(''taxFormNumber''); ';
  Script.Add := ' ';                                                      //MMD, BZ 3638
  Script.Add := '    if (master.customerIsTaxable.asInteger=oldIsTaxable) AND (Not Master.GetFromDO.AsBoolean) then begin ';
  Script.Add := '      master.taxFormNumber.AsString := oldTaxNo; ';
  Script.Add := '    end ';
  Script.Add := '    else begin ';
  Script.Add := '      master.execute_runtime_procedure(''CheckTaxable''); ';
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
  Script.Add := '    master.execute_runtime_procedure(''CheckTaxable''); ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function isSalesmanPKPPE : Boolean;';
  Script.Add := 'begin';
  Script.Add := '  if Master.SalesmanID.IsNull then exit;';
  Script.Add := '  Result := TExtendedLookupField(Master.SalesmanID.FieldLookUp.FieldByName(''ExtendedID'')).FieldLookUp.FieldByName(PKP_PE_SALESMAN).AsBoolean;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'function isCustomerPKPPE : Boolean;';
  Script.Add := 'begin';
  Script.Add := '  if Master.CustomerID.IsNull then exit;';
  Script.Add := '  Result := TExtendedLookupField(Master.CustomerID.FieldLookUp.FieldByName(''ExtendedID'')).FieldLookUp.FieldByName(PKP_PE_CUSTOMER).AsBoolean;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'function GetCustomerField(fieldname : String): String;';
  Script.Add := 'var';
  Script.Add := '  sql : TjbSQL;';
  Script.Add := '  qry : String;';
  Script.Add := 'begin';
  Script.Add := '  sql := nil;';
  Script.Add := '  try';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '    qry := Format(''SELECT COALESCE(%s, '''''''') %s ' +
                                    'FROM   persondata c ' +
                                           'JOIN custtype ct ' +
                                             'ON c.customertypeid = ct.customertypeid ' +
                                           'JOIN extended e ' +
                                             'ON c.extendedid = e.extendedid ' +
                                    'WHERE c.id = %d;'', [fieldname, fieldname, Master.CustomerID.Value]);';
  Script.Add := '    RunSQL(sql, qry);';
  Script.Add := '    Result := sql.FieldByName(fieldname);';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'function GetCustomerOwing : Currency;';
  Script.Add := 'var';
  Script.Add := '  sql : TjbSQL;';
  Script.Add := '  qry : String;';
  Script.Add := 'begin';
  Script.Add := '  sql := nil;';
  Script.Add := '  try';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '    qry := Format(''SELECT COALESCE(Sum(o.owing), 0) owing ' +
                                    'FROM   arinv i ' +
                                           'LEFT OUTER JOIN Owing_si(''''%s'''', i.arinvoiceid) o ' +
                                                        'ON o.arinvoiceid = I.arinvoiceid ' +
                                           'WHERE  ( ( o.owing <> 0 OR o.owingdc <> 0 ) ' +
                                             'AND ( i.invoicedate <= ''''%s'''') )' +
                                             'AND ( i.customerid IN ( %d ) );'', [DateToStrSQL(Master.InvoiceDate.Value), DateToStrSQL(Master.InvoiceDate.Value), Master.CustomerID.Value]);';
  Script.Add := '    RunSQL(sql, qry);';
  Script.Add := '    Result := sql.FieldByName(''owing'');';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure PKPPEChanged;';
  Script.Add := 'begin ';
  Script.Add := '  master.taxFormNumber.ReadOnly := False;';
  Script.Add := '  if (((PKP_PE = ''1'') AND (((PKP_PE_BY = ''CUSTOMER'') AND isCustomerPKPPE) OR ((PKP_PE_BY = ''SALESMAN'') AND isSalesmanPKPPE))) ' +
                      'OR ((PKP_PE_ADD_INFO_ACTIVE = ''1'') AND ((GetCustomerField(''Tax1ExemptionNo'') = '''') AND (GetCustomerField(''Tax2ExemptionNo'') = '''')))) then begin';
  Script.Add := '    if (master.taxFormNumber.AsString<>'''') then begin'; // AA, BZ 4069
  Script.Add := '      master.Edit;';
  Script.Add := '      master.taxFormNumber.Value := '''';';
  Script.Add := '    end;';
  Script.Add := '    master.taxFormNumber.ReadOnly := True;';
  Script.Add := '  end';
  Script.Add := '  else begin';
  Script.Add := '    master.Edit;';
  Script.Add := '    triggerRunningNoFP;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure CheckPKP;';
  Script.Add := 'begin ';
  Script.Add := '  master.taxFormNumber.ReadOnly := False;';
  Script.Add := '  if (((PKP_PE = ''1'') AND (((PKP_PE_BY = ''CUSTOMER'') AND isCustomerPKPPE) OR ((PKP_PE_BY = ''SALESMAN'') AND isSalesmanPKPPE))) ' +
                      'OR ((PKP_PE_ADD_INFO_ACTIVE = ''1'') AND ((GetCustomerField(''Tax1ExemptionNo'') = '''') AND (GetCustomerField(''Tax2ExemptionNo'') = '''')))) then begin';
  Script.Add := '    master.taxFormNumber.ReadOnly := True;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure CreateAddInfoControls;';
  Script.Add := 'begin ';
  Script.Add := '  lblAddInfo  := CreateLabel(TLabel(Form.pnlFooterLeft.FindComponent(''lblDescription'')).Left, TopPos(TJbDBMemo(Form.pnlJbFooterLeft.FindComponent(''memDescription''))) '+
                                 ', 80, 25, ''Add. Info : '', Form.pnlFooterLeft);';
  Script.Add := '  edtNPWP     := CreateEdit(LeftPos(lblAddInfo), lblAddInfo.Top, 150, 25, Form.pnlFooterLeft);';
  Script.Add := '  edtNIK      := CreateEdit(LeftPos(edtNPWP), edtNPWP.Top, 150, 25, Form.pnlFooterLeft);';
  Script.Add := '  dtpRegist   := CreatePickDate(LeftPos(edtNIK), edtNIK.Top '+
                                 ', 150, 25, Form.pnlFooterLeft);';
  Script.Add := '  edtCustType := CreateEdit(LeftPos(dtpRegist), dtpRegist.Top, 150, 25, Form.pnlFooterLeft);';
  Script.Add := '  edtOwing := CreateEdit(LeftPos(edtCustType), edtCustType.Top, 150, 25, Form.pnlFooterLeft);';
  Script.Add := '  edtNPWP.Enabled := False;';
  Script.Add := '  edtNIK.Enabled := False;';
  Script.Add := '  dtpRegist.Enabled := False;';
  Script.Add := '  edtCustType.Enabled := False;';
  Script.Add := '  edtOwing.Enabled := False;';
  Script.Add := '  if (PKP_PE_ADD_INFO_ACTIVE = ''1'') then exit;';
  Script.Add := '  lblAddInfo.Visible := False;';
  Script.Add := '  edtNPWP.Visible := False;';
  Script.Add := '  edtNIK.Visible := False;';
  Script.Add := '  dtpRegist.Visible := False;';
  Script.Add := '  edtCustType.Visible := False;';
  Script.Add := '  edtOwing.Visible := False;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure LoadAddInfo;';
  Script.Add := 'begin ';
  Script.Add := '  edtNPWP.Text := GetCustomerField(''Tax1ExemptionNo'');';
  Script.Add := '  edtNIK.Text := GetCustomerField(''Tax2ExemptionNo'');';
  Script.Add := '  if GetCustomerField(PKP_PE_ADD_INFO_CF) <> '''' then begin';
  Script.Add := '    dtpRegist.Date := StrSQLToDate(GetCustomerField(PKP_PE_ADD_INFO_CF));';
  Script.Add := '  end';
  Script.Add := '  else begin';
  Script.Add := '    dtpRegist.Date := Date;'; //MMD, BZ 3639
  Script.Add := '  end;';
  Script.Add := '  edtCustType.Text := GetCustomerField(''typename'');';
  Script.Add := '  edtOwing.Text := FormatFloat(''#,##0.########'', GetCustomerOwing);';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure DetailAfterInsert;';
  Script.Add := 'begin ';
  Script.Add := '  if Master.GetFromSO.Value then triggerRunningNoFP;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure MasterAfterOpen;';
  Script.Add := 'begin ';
  Script.Add := '  LoadAddInfo;';
  Script.Add := '  CheckPKP;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := '  form.DODecorator.cbCustTaxable.onExit := @triggerRunningNoFP; //AA ';
  Script.Add := '  master.customerID.onChangeArray := @changeTaxNumber; '; //JR, BZ 2615
  Script.Add := '  master.CustomerID.onChangeArray := @PKPPEChanged;';
  Script.Add := '  master.CustomerID.onChangeArray := @LoadAddInfo;';
  Script.Add := '  master.SalesmanID.onChangeArray := @PKPPEChanged;';
  Script.Add := '  Detail.OnAfterInsertArray := @DetailAfterInsert;';
  Script.Add := '  Master.OnAfterOpenArray := @CheckPKP;';
  Script.Add := '  Master.on_after_save_array := @CheckPKP;';
  Script.Add := '  Form.layout_from_script := @CheckPKP;';
  Script.Add := '  CreateAddInfoControls;';
  Script.Add := '  LoadAddInfo;';
  Script.Add := 'end. ';
end;

procedure TRunningNoFPPlusPEInjector.InitializeVariable;
begin
  inherited;
  Script.Add := 'const';
  Script.Add := '  PKP_PE = ReadOption(''PKP_PE'', ''0'');';
  Script.Add := '  PKP_PE_BY = ReadOption(''PKP_PE_BY'', ''SALESMAN'');';
  Script.Add := '  PKP_PE_SALESMAN = ReadOption(''PKP_PE_SALESMAN'', '''');';
  Script.Add := '  PKP_PE_CUSTOMER = ReadOption(''PKP_PE_CUSTOMER'', '''');';
  Script.Add := '  PKP_PE_ADD_INFO_ACTIVE = ReadOption(''PKP_PE_ADD_INFO_ACTIVE'', ''0'');';
  Script.Add := '  PKP_PE_ADD_INFO_CF = ReadOption(''PKP_PE_ADD_INFO_CF'', ''CUSTOMFIELD2'');';
  Script.Add := '';
end;

procedure TRunningNoFPPlusPEInjector.OnTaxFormNumberChange;
begin
  Script.Add := 'procedure OnTaxFormNumberChange; ';
  Script.Add := 'var ';
  Script.Add := '  validTaxFormNumber : string; ';
  Script.Add := 'begin ';
                   //MMD, BZ 3651
  Script.Add := '  if Dataset.InvFromSR.value = 1 then Exit;';
  Script.Add := '  if Dataset.CustomerID.Value = null then Exit;';
  Script.Add := '  if (((PKP_PE = ''1'') AND (((PKP_PE_BY = ''CUSTOMER'') AND isCustomerPKPPE) OR ((PKP_PE_BY = ''SALESMAN'') AND isSalesmanPKPPE))) ' +
                      'OR ((PKP_PE_ADD_INFO_ACTIVE = ''1'') AND ((GetCustomerField(''Tax1ExemptionNo'') = '''') AND (GetCustomerField(''Tax2ExemptionNo'') = '''')))) then begin';
//  Script.Add := '    getNextTaxNoFromOptionTable; ';
//  Script.Add := '    validTaxFormNumber := NEXT_FP_NO; ';
//  Script.Add := '    if (validTaxFormNumber<>dataset.TaxFormNumber.AsString) then begin ';
  Script.Add := '    if (dataset.TaxFormNumber.AsString<>'''') then begin '; // AA, BZ 4069
  Script.Add := '      dataset.TaxFormNumber.AsString := ''''; ';
  Script.Add := '    end; ';
  Script.Add := '    exit;';
  Script.Add := '  end;';
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

procedure TRunningNoFPPlusPEInjector.set_scripting_parameterize;
begin
  feature_name := 'Running No FP + PE';
end;

end.
