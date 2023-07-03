unit RunningNoCashBankInjector;

interface
uses BankConst
     , Injector
     ;
type
  TConst = procedure of object;
  TAFormName = (AFNDIRECTPAYMENT, AFNJV, AFNAPCHEQUE, AFNARPAYMENT);
  TRunningNoCashBankInjector = class(TInjector)
  private
    procedure generateMain;
    procedure generateScriptFormOR;
    procedure generateScriptFormOP;
    procedure generateScriptFormVP;
    procedure generateScriptFormJV;
    procedure generateScriptJVDataset;
    procedure generateScriptFormCR;
    procedure generateScriptCRDataset;

    procedure addConstBankAccnt;
    procedure addCustomVarFormCR;
    procedure addDoChangeBankAccount;
    procedure addVarIsAllowPostCRDataset;
    procedure addSetDeptID;
    procedure addGetDeptIDCustomer;

    procedure addCustomVarJVDataset;
    procedure addCheckAccountBankAndCashJVDataset;
    procedure addDoBeforePost;
    procedure addSetRNGLAccount;
    procedure addCustomVarJV;
    procedure addCheckAccountBankAndCashJV;
    procedure addMasterOnNewRecordJV;
    procedure addMasterOnBeforeSaveJV;
    procedure addIncrementJVNumber(DatasetName:String);
    procedure addMasterOnBeforeEditJV;
    procedure addValidateVPMultiDisc;
    procedure addGLAmountOnChangeJV;
    procedure addIsVPMultiDiscExist;
    procedure addGetValueJV;

    procedure addMasterOnAfterSave(LvState, FormCode, StatusField: String);
    procedure addBankAccountOnChange(AccountName: String; AFormName: TAFormName);
    procedure addCustomVarVP;

    procedure addShowSettingFormatNumber;
    procedure addDecorateFrm;
    procedure addDecorateGrid;
    procedure addFillListNumber;
    procedure addBtnNewEditClick;
    procedure addInitializeVarTableNameCashBank;
    procedure addVarTableNameCashBank;
    procedure addVarTableNameStatusNumber;
    procedure addInitializeVarTableNameStatusNumber;
    procedure addInitializationVarJV_VPID_Field;

    procedure addInitializationVar;
    procedure addInitializationVarCR;
    procedure addInitializationVarVP;
    procedure addInitializationVarJV;
    procedure addInitializationVarJVDataset;
    procedure addConst(addCustomConst:TConst);
    procedure addVar;
    procedure addVarJVP_VPID_Field;
    procedure addConstIN_Field;
    procedure addConstOUT_Field;
    procedure addConstJV;
    procedure addSetValidDateRunningNumber;
    procedure addGetRunningNumberIn;
    procedure addNewNumber(LvState: String; const FieldName:String='JVNumber');
    procedure addIsBankAccount;
    procedure addGLAccountOnChangeOR;
    procedure addGLAccountOnChangeOP;
    procedure addIncrementORNumber;
    procedure addGetRunningNumberOut(LvState: String; AccountName: String='GLAccount');
    procedure addIncrementOPNumber;
    procedure addMasterOnAfterSaveOP;

    procedure addMasterOnAfterSaveOR;
    procedure addIsFormExist(AFormName:TAFormName);
  protected
    procedure set_scripting_parameterize; override;
  public
    procedure GenerateScript; override;
  end;

implementation
uses SysUtils
     ;

{ TRunningNoCashBankInjector }


procedure TRunningNoCashBankInjector.addBankAccountOnChange(AccountName: String; AFormName: TAFormName);
begin
  addIsFormExist( AFormName );
  addIsBankAccount;
  if AFormName = AFNARPAYMENT then begin
    addGetRunningNumberIn;
  end
  else if AFormName = AFNAPCHEQUE then begin
    addGetRunningNumberOut('Master', 'BankAccnt');
  end;
  Script.Add := 'procedure BankAccountOnChange; ';
  Script.Add := 'var number : String; ';
  Script.Add := 'begin ';
  Script.Add := '  if IsFormExist then Exit; ';
  Script.Add := Format('  if Master.%s.AsString <> glAccountTemp then begin ', [AccountName]);
  Script.Add := Format('    glAccountTemp := Master.%s.AsString; ', [AccountName]);
  Script.Add :=        '  end else begin ';
  Script.Add :=        '    Exit; ';
  Script.Add :=        '  end; ';
  Script.Add := Format('  if not IsBankAccount( Master.%s.AsString ) then Exit; ', [AccountName]);
  if AFormName = AFNARPAYMENT then begin
    Script.Add := Format('  number := GetRunningNumberIn(Master.%s.AsString); ', [AccountName]);
  end
  else if AFormName = AFNAPCHEQUE then begin
    Script.Add := '  number := GetRunningNumberOut; ';
  end;
  Script.Add := '  if number = '''' then RaiseException(''Please register account that ''+ ';
  Script.Add := '    Format(''used in table "%s" '',[TABLE_NAME_CASHBANK]) ); ';
//  Script.Add := '  if CountToken( number, ''/'' ) <> COUNT_TOKEN then ' +
//                             'RaiseException( Format(''Please follow %s of feature request'',[TABLE_NAME_CASHBANK]) ); ';
  // AA, BZ 3029
  Script.Add := '  if (CountToken( number, ''/'' )<>COUNT_TOKEN) And (ReadOption(''INCLUDE_DATE_IN_RUNNING_NO'', ''1'')=''1'') then begin ';
  Script.Add := '    RaiseException( Format(''Please follow %s of feature request'',[TABLE_NAME_CASHBANK]) );';
  Script.Add := '  end;';
  Script.Add := '  Form.AedtSequenceNo.Text := number;';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addBtnNewEditClick;
begin
  Script.Add := 'procedure btnNewEditClick(Sender:TButton); ';
  Script.Add := 'var frmNew  : TForm; ';
  Script.Add := '    lbl     : TLabel; ';
  Script.Add := '    edtbank : TEdit; ';
  Script.Add := '    edtIn   : TEdit; ';
  Script.Add := '    edtOut  : TEdit; ';
  Script.Add := '    btnOKNew: TButton; ';
  Script.Add := '    edtbank_temp : String = ''''; ';
  Script.Add := '    edtIn_temp   : String = ''''; ';
  Script.Add := '    edtOut_temp  : String = ''''; ';
  Script.Add := '  function InsertIntoExtendedDet:String; ';
  Script.Add := '  var extendeddet_id  : Integer; ';
  Script.Add := '      extendedtype_id : Integer; ';
  Script.Add := '      guid : String; ';
  Script.Add := '      sql : TjbSQL; ';
  Script.Add := '    function GetExtendedID:Integer; ';
  Script.Add := '    begin ';
  Script.Add := '      RunSQL( sql, ''Select ExtendedDetID from GetExtendedDetID''); ';
  Script.Add := '      result := sql.FieldByName(''ExtendedDetID''); ';
  Script.Add := '    end; ';
  Script.Add := '  ';
  Script.Add := '  function GetExtendedTypeID:Integer; ';
  Script.Add := '  begin ';
  Script.Add := '    RunSQL( sql, Format(''SELECT et.EXTENDEDTYPEID FROM EXTENDEDTYPE ET '+
                             'WHERE ET.EXTENDEDNAME = ''''%s'''' '',[TABLE_NAME_CASHBANK])); ';
//  Script.Add := '    if sql.Eof then RaiseException( Format(''Please fix table name of "%s" according FR'',[TABLE_NAME_CASHBANK]) ); ';
  Script.Add := '    if sql.Eof then RaiseException( Format(''Please make sure Extended Type named: "%s" exists.'',[TABLE_NAME_CASHBANK]) ); '; // AA, BZ 3127
  Script.Add := '    result := sql.FieldByName(''ExtendedTypeID''); ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := '  begin ';
  Script.Add := '    sql := CreateSQL(TIBTransaction(ATx)); ';
  Script.Add := '    try ';
  Script.Add := '      extendeddet_id  := GetExtendedID; ';
  Script.Add := '      extendedtype_id := GetExtendedTypeID; ';
  Script.Add := '    finally ';
  Script.Add := '      sql.Free; ';
  Script.Add := '    end; ';
  Script.Add := '    guid            := CreateClassID; ';
  Script.Add := '    result := Format(''Insert Into ExtendedDet (ExtendedDetID, ExtendedTypeID, %s, %s, %s, GUID) ''+ ';
  Script.Add := '                ''values( %d, %d, ''''%s'''', ''''%s'''', ''''%s'''', ''''%s'''')'', ';
  Script.Add := '                [BANK_ACCNT_FIELD, IN_FIELD, OUT_FIELD, extendeddet_id, extendedtype_id, ';
  Script.Add := '                edtbank.Text, edtIn.Text, edtOut.Text, guid] ); ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  function UpdateExtendedDet:String; ';
  Script.Add := '  begin ';
  Script.Add := '    result := Format(''Update ExtendedDet ed set ed.%s = ''''%s'''', ed.%s = ''''%s'''', ed.%s = ''''%s'''' ''+ ';
  Script.Add := '      ''Where ed.ExtendedDetID = %s'', [ BANK_ACCNT_FIELD, edtbank.Text, IN_FIELD, edtIn.Text, OUT_FIELD, ';
  Script.Add := '       edtOut.Text, DescSelected(listNumber) ]); ';
  Script.Add := '  end; ';
  Script.Add := ' ';
  Script.Add := '  procedure SetRNBankAccnt(Status:String); ';
  Script.Add := '  var sql : TjbSQL; ';
  Script.Add := '      QuerySQL : String; ';
  Script.Add := '  begin ';
  Script.Add := '    sql := CreateSQL( TIBTransaction(ATx) );';
  Script.Add := '    try ';
  Script.Add := '      if Status = ''INSERT'' then begin ';
  Script.Add := '        QuerySQL := InsertIntoExtendedDet; ';
  Script.Add := '      end ';
  Script.Add := '      else begin ';
  Script.Add := '        QuerySQL := UpdateExtendedDet; ';
  Script.Add := '      end; ';
  Script.Add := '      RunSQL( sql, QuerySQL); ';
  Script.Add := '    finally ';
  Script.Add := '      sql.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  function IsCompleteForInput:Boolean; ';
  Script.Add := '  begin ';
  Script.Add := '    result := True; ';
  Script.Add := '    if (edtIn.Text = '''') or (edtOut.Text = '''') or (edtBank.Text = '''') then begin ';
  Script.Add := '      result := False; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  procedure GetDataSelected; ';
  Script.Add := '  var sql : TjbSQL; ';
  Script.Add := '  begin ';
  Script.Add := '    sql := CreateSQL(TIBTransaction(ATx)); ';
  Script.Add := '    try ';
  Script.Add := '      RunSQL( sql, Format(''Select ed.%s, ed.%s, ed.%s From ExtendedDet ed where ed.ExtendedDetID = %s'', ';
  Script.Add := '      [ BANK_ACCNT_FIELD, IN_FIELD, OUT_FIELD, DescSelected(listNumber)]) ); ';
  Script.Add := '      edtBank.Text := sql.FieldByName(BANK_ACCNT_FIELD); ';
  Script.Add := '      edtIn.Text   := sql.FieldByName(IN_FIELD); ';
  Script.Add := '      edtOut.Text  := sql.FieldByName(OUT_FIELD); ';
  Script.Add := '      edtbank_temp := edtBank.Text; ';
  Script.Add := '      edtIn_temp   := edtIn.Text; ';
  Script.Add := '      edtOut_temp  := edtOut.Text; ';
  Script.Add := '    finally ';
  Script.Add := '      sql.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  procedure CheckValueNumber(Sender: TEdit); ';
  Script.Add := '    procedure CheckExistNumber(ObjectDetermined, Value: String); ';
  Script.Add := '    var sql : TjbSQL; ';
  Script.Add := '    begin ';
  Script.Add := '      sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '      try ';
  Script.Add := '        RunSQL( sql, Format(''Select ed.%s From ExtendedDet ed, ExtendedType et '+
                                 'where ET.EXTENDEDTYPEID = ED.EXTENDEDTYPEID and '+
                                 'et.EXTENDEDNAME = ''''%s'''' and ed.%s = ''''%s'''' '', ';
  Script.Add := '          [ObjectDetermined, TABLE_NAME_CASHBANK, ObjectDetermined, Value] ) ); ';
  Script.Add := '        if not sql.Eof then RaiseException (''This value already exist''); ';
  Script.Add := '      finally ';
  Script.Add := '        sql.Free; ';
  Script.Add := '      end; ';
  Script.Add := '    end; ';
  Script.Add := '    ';
  Script.Add := '  begin ';
  Script.Add := '    if Sender = edtBank then begin ';
  Script.Add := '      if (edtBank_temp = edtBank.Text) then Exit; ';
  script.Add := '      CheckExistNumber( BANK_ACCNT_FIELD, edtBank.Text ); ';
  Script.Add := '    end ';
  Script.Add := '    else if Sender = edtIn then begin ';
  Script.Add := '      if (edtIn_temp = edtIn.Text) then Exit; ';
  script.Add := '      CheckExistNumber( IN_FIELD, edtIn.Text ); ';
  Script.Add := '    end ';
  Script.Add := '    else begin ';
  Script.Add := '      if (edtOut_temp = edtOut.Text) then Exit; ';
  script.Add := '      CheckExistNumber( OUT_FIELD, edtOut.Text ); ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := 'begin ';
  Script.Add := '  if Sender = btnEdit then begin ';
  Script.Add := '    if CountSelected(listNumber) = 0 then RaiseException(''Please choose your account that want to edit''); ';
  Script.Add := '    if DescSelected(listNumber) = ''-1'' then RaiseException(''There are no data that can be edited''); ';
  Script.Add := '  end; ';
  Script.Add := '  frmNew := CreateForm( ''frmNew'', ''New'', 170, 230); ';
  Script.Add := '  try ';
  Script.Add := '    frmNew.BorderStyle := bsToolWindow; ';
  Script.Add := '    lbl      := CreateLabel( 10, 10, 80, 20, ''BANK ACCOUNT'', frmNew); ';
  Script.Add := '    edtbank  := CreateEdit( 10, lbl.Top + lbl.Height, 100, 25, frmNew); ';
  Script.Add := '    lbl      := CreateLabel( edtBank.Left, edtBank.Top + edtBank.Height +5, 80, 20, ''IN'', frmNew); ';
  Script.Add := '    edtIn    := CreateEdit( edtBank.Left, lbl.Top + lbl.Height, 100, 25, frmNew); ';
  Script.Add := '    lbl      := CreateLabel( edtBank.Left, edtIn.Top + edtIn.Height +5, 80, 20, ''OUT'', frmNew); ';
  Script.Add := '    edtOut   := CreateEdit( edtBank.Left, lbl.Top + lbl.Height, 100, 25, frmNew); ';
  Script.Add := '    btnOKNew := CreateBtn( edtBank.Left, edtOut.Top + edtOut.Height + 10, 80, 25, 0, ''&OK'', frmNew ); ';
  Script.Add := '    edtBank.OnExit := @CheckValueNumber; ';
  Script.Add := '    edtIn.OnExit   := @CheckValueNumber; ';
  Script.Add := '    edtOut.OnExit  := @CheckValueNumber; ';
  Script.Add := '    btnOKNew.ModalResult := mrOK; ';
  Script.Add := '    edtbank_temp := ''-''; ';
  Script.Add := '    edtIn_temp   := ''-''; ';
  Script.Add := '    edtOut_temp  := ''-''; ';
  Script.Add := '    if Sender = btnEdit then begin ';
  Script.Add := '      GetDataSelected; ';
  Script.Add := '    end; ';
  Script.Add := '    if frmNew.ShowModal = mrOK then begin ';
  Script.Add := '      if not IsCompleteForInput then RaiseException(''Please fill all blank''); ';
  Script.Add := '      if Sender = btnNew then begin ';
  Script.Add := '        SetRNBankAccnt(''INSERT''); '; //RN = Running Number
  Script.Add := '      end ';
  Script.Add := '      else begin ';
  Script.Add := '        SetRNBankAccnt(''UPDATE''); ';
  Script.Add := '      end; ';
  Script.Add := '      FillListNumber; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    frmNew.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addCheckAccountBankAndCashJV;
begin
  addIsBankAccount;
  Script.Add := 'procedure CheckAccountBankAndCashJV; ';
  Script.Add := 'begin ';
  Script.Add := '  count_bank_account := 0; ';
  Script.Add := '  Detail.First; ';
  Script.Add := '  while not Detail.Eof do begin ';
  Script.Add := '    if IsBankAccount(Detail.GLAccount.Value) then begin ';
  Script.Add := '      if Detail.GLAmount.Value > 0 then begin ';
  Script.Add := '        current_status := ''DEBIT''; ';
  Script.Add := '      end else begin ';
  Script.Add := '        current_status := ''CREDIT''; ';
  Script.Add := '      end; ';
  Script.Add := '      Inc(count_bank_account); ';
  Script.Add := '      if count_bank_account > 1 then RaiseException(''Account Bank / Cash tidak bisa lebih dari 1''); ';
  Script.Add := '    end; ';
  Script.Add := '    Detail.Next; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addCheckAccountBankAndCashJVDataset;
begin
  addIsBankAccount;
  Script.Add := 'procedure CheckAccountBankAndCashJVDataset; ';
  Script.Add := '  var count_bank_account : Integer; ';
  Script.Add := '      current_status     : String; ';
  Script.Add := '      sql         : TjbSQL; ';
  Script.Add := '      textSQL     : String; ';
  Script.Add := 'begin ';
  Script.Add := '  count_bank_account := 0; ';
  Script.Add := '  bankAccount := ''''; ';
  Script.Add := '  sql     := CreateSQL(TIBTransaction(dataset.Tx)); ';
  Script.Add := '  textSQL := format(''select glaccount, glamount from jvdet where jvid = %d '', [dataset.FieldByName(''JVID'').Value]); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sql, textSQL); ';
  Script.Add := '    while not sql.EOF do begin ';
  Script.Add := '      if IsBankAccount( sql.FieldByName(''glaccount'') ) then begin ';
  Script.Add := '        if sql.FieldByName(''glamount'') > 0 then begin ';
  Script.Add := '          current_status := ''DEBIT''; ';
  Script.Add := '        end else begin ';
  Script.Add := '          current_status := ''CREDIT''; ';
  Script.Add := '        end; ';
  Script.Add := '        if current_status = ''DEBIT'' then begin ';
  Script.Add := '          Inc(count_bank_account); ';
  Script.Add := '          if count_bank_account > 1 then RaiseException(''Account Bank / Cash tidak bisa lebih dari 1''); ';
  Script.Add := '          bankAccount := sql.FieldByName(''glaccount''); ';
  Script.Add := '        end; ';
  Script.Add := '      end; ';
  Script.Add := '      sql.Next; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addConst(addCustomConst:TConst);
begin
  Script.Add := 'const ';
  Script.Add := '      COUNT_TOKEN = 3; ';
  addConstBankAccnt;
  addCustomConst;
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addConstBankAccnt;
begin
  Script.Add := '      BANK_ACCNT_FIELD = ''INFO1''; ';
end;

procedure TRunningNoCashBankInjector.addConstOUT_Field;
begin
  Script.Add := '      OUT_FIELD        = ''INFO3''; ';
end;

procedure TRunningNoCashBankInjector.addConstIN_Field;
begin
  Script.Add := '      IN_FIELD         = ''INFO2''; ';
end;

procedure TRunningNoCashBankInjector.addConstJV;
begin
  addConstOUT_Field;
  addConstIN_Field;
  Script.Add := '      JVNUMBER_FIELD   = ''INFO1''; ';
end;

procedure TRunningNoCashBankInjector.addCustomVarFormCR;
begin
  Script.Add := '    DEPARTMENT_CUSTOMER : String; ';
end;

procedure TRunningNoCashBankInjector.addCustomVarJV;
begin
  Script.Add := '   count_bank_account : Integer; ';
  Script.Add := '   bank_account_temp  : String; ';
  Script.Add := '   bank_account_RN_temp : String; ';
  Script.Add := '   current_status       : String; ';
  Script.Add := '   previous_status      : String; ';
  addVarJVP_VPID_Field;
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addCustomVarJVDataset;
begin
  Script.Add := '   bankAccount : String; ';
  addVarTableNameStatusNumber;
end;

procedure TRunningNoCashBankInjector.addCustomVarVP;
begin
  addVarJVP_VPID_Field;
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addDecorateFrm;
begin
  addDecorateGrid;
  addFillListNumber;
  addBtnNewEditClick;
  Script.Add := 'procedure DecorateFrm; ';
  Script.Add := 'begin ';
  Script.Add := '  frm.BorderStyle := bsToolWindow;';
  Script.Add := '  listNumber := CreateListView(  frm, 5, 5, frm.ClientWidth -10, frm.ClientHeight -50, False); ';
  Script.Add := '  listNumber.ViewStyle := vsReport; ';
  Script.Add := '  listNumber.RowSelect := True; ';
  Script.Add := '  DecorateGrid; ';
  Script.Add := '  FillListNumber; ';
  Script.Add := '  btnOK := CreateBtn( (frm.ClientWidth - (70*4 + 100) ) div 2 , ';
  Script.Add := '    listNumber.Top + listNumber.Height + 10, 80, 25, 0, ''&OK'', frm); ';
  Script.Add := '  btnCancel := CreateBtn( LeftPos(btnOK, 20) , ';
  Script.Add := '    btnOk.Top , btnOk.Width, btnOK.Height, 0, ''&Cancel'', frm); ';
  Script.Add := '  btnNew := CreateBtn( LeftPos(btnCancel, 20) , ';
  Script.Add := '    btnOk.Top , btnOk.Width, btnOK.Height, 0, ''&New'', frm); ';
  Script.Add := '  btnEdit  := CreateBtn( LeftPos(btnNew, 20), btnOk.Top, 80, 25, 0, ''&Edit'', frm ); ';
  Script.Add := '  btnOK.ModalResult := mrOK; ';
  Script.Add := '  btnCancel.ModalResult := mrCancel; ';
  Script.Add := '  btnNew.OnClick  := @btnNewEditClick; ';
  Script.Add := '  btnEdit.OnClick := @btnNewEditClick; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addDecorateGrid;
begin
  Script.Add := 'procedure DecorateGrid; ';
  Script.Add := 'var Col : TListColumn; ';
  Script.Add := 'begin ';
  Script.Add := '  CreateListViewCol( listNumber, '''', 0 ); ';
  Script.Add := '  CreateListViewCol( listNumber, '''', 0 ); '; //for extendedid
  Script.Add := '  Col := CreateListViewCol( listNumber, ''BANK ACCOUNT'', (listNumber.Width -20) div 3  ); ';
  Script.Add := '  CreateListViewCol( listNumber, ''IN'', Col.Width ); ';
  Script.Add := '  CreateListViewCol( listNumber, ''OUT'', Col.Width ); ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addDoBeforePost;
begin
  addCheckAccountBankAndCashJVDataset;
  addSetRNGLAccount;
  addIncrementJVNumber('Dataset');
  Script.Add := 'procedure DoBeforePost; ';
  Script.Add := 'begin ';
  Script.Add := '  if TjbStringField(dataset.Transtype).AsString <> ''CC'' then Exit; ';
  Script.Add := '  if dataset.TransDate.AsString = '''' then Exit; ';
  Script.Add := '  CheckAccountBankAndCashJVDataset; ';
  Script.Add := '  SetRNGLAccount; ';
  Script.Add := '  IncrementJVNumber; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addDoChangeBankAccount;
begin
  addIsBankAccount;
  addGetRunningNumberIn;
  Script.Add := 'procedure DoChangeBankAccount; ';
  Script.Add := 'var number : String; ';
  Script.Add := 'begin ';
  Script.Add := '  if isAllowPostCRDataset then begin ';
  Script.Add := '    if not IsBankAccount( dataset.BankAccount.AsString ) then Exit; ';
  Script.Add := '    number := GetRunningNumberIn(Dataset.BankAccount.AsString); ';
  Script.Add := '    if number = '''' then RaiseException( Format(''Please register account '+
                        'that used in table "%s" '',[TABLE_NAME_CASHBANK]) ); ';
//  Script.Add := '    if CountToken( number, ''/'' ) <> COUNT_TOKEN then RaiseException '+
//                            ' ( Format(''Please follow %s of feature request'',[TABLE_NAME_CASHBANK]) ); ';
  // AA, BZ 3029
  Script.Add := '    if (CountToken( number, ''/'' )<>COUNT_TOKEN) And (ReadOption(''INCLUDE_DATE_IN_RUNNING_NO'', ''1'')=''1'') then begin ';
  Script.Add := '      RaiseException( Format(''Please follow %s of feature request'',[TABLE_NAME_CASHBANK]) );';
  Script.Add := '    end;';
  Script.Add := '    dataset.SequenceNo.AsString := number; ';
  Script.Add := '  end; ';
  Script.Add := '  isAllowPostCRDataset := True; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addFillListNumber;
begin
  Script.Add := 'procedure FillListNumber; ';
  Script.Add := 'var                                                                                                                     ';
  Script.Add := '  listItem : TListItem;                                                                                                 ';
  Script.Add := '  sql : TjbSQL; ';
  Script.Add := 'begin                                                                                                                   ';
  Script.Add := '  listNumber.Items.Clear;                                                                                            ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(ATx));                                                                                          ';
  Script.Add := '  try                                                                                                                   ';
  Script.Add := '    RunSQL(sql, format(''SELECT Coalesce(ed.ExtendedDetID, -1)ExtendedDetID, Coalesce(ed.%s, '''''''')%s, ''+ ';
  Script.Add := '      ''Coalesce(ed.%s,  '''''''')%s, Coalesce(ed.%s, '''''''')%s ''+ ';
  Script.Add := '      ''FROM EXTENDEDTYPE ET LEFT JOIN '' + ';
  Script.Add := '      ''EXTENDEDDET ED ON ET.EXTENDEDTYPEID = ED.EXTENDEDTYPEID ''+ ';
  Script.Add := '      ''WHERE ET.EXTENDEDNAME = ''''%s'''' '', ';
  Script.Add := '      [BANK_ACCNT_FIELD, BANK_ACCNT_FIELD, IN_FIELD, IN_FIELD, OUT_FIELD, OUT_FIELD, TABLE_NAME_CASHBANK ])); ';
  Script.Add := '    while not sql.EOF do begin                                                                                 ';
  Script.Add := '      listItem := listNumber.Items.Add; ';
  Script.Add := '      listItem.SubItems.Add( sql.FieldByName( ''ExtendedDetID'' )); ';
  Script.Add := '      listItem.SubItems.Add( sql.FieldByName( BANK_ACCNT_FIELD )); ';
  Script.Add := '      listItem.SubItems.Add( sql.FieldByName( IN_FIELD )); ';
  Script.Add := '      listItem.SubItems.Add( sql.FieldByName( OUT_FIELD )); ';
  Script.Add := '      sql.Next;                                                                                                ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free;                                                                                                  ';
  Script.Add := '  end;                                                                                                         ';
  Script.Add := 'end;                                                                                                           ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addGetDeptIDCustomer;
begin
  Script.Add := 'function GetDeptIDCustomer(ACustomerID: Integer): Integer;';
  Script.Add := '  var SQL     : TjbSQL; ';
  Script.Add := '      TextSQL : String; ';
  Script.Add := 'begin ';
  Script.Add := '  result  := nil; ';
  Script.Add := '  SQL     := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  TextSQL := format(''SELECT D.DEPTID '' + ';
  Script.Add := '                    ''  FROM PERSONDATA A, EXTENDED B, EXTENDEDDET C, DEPARTMENT D '' + ';
  Script.Add := '                    '' WHERE A.PERSONTYPE = 0 '' + ';
  Script.Add := '                    ''   AND A.ID = %d '' + ';
  Script.Add := '                    ''   AND A.EXTENDEDID = B.EXTENDEDID '' + ';
  Script.Add := '                    ''   AND B.%s = C.EXTENDEDDETID '' + ';
  Script.Add := '                    ''   AND C.INFO1 = D.DEPTNO '', [ACustomerID, DEPARTMENT_CUSTOMER]); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(SQL, TextSQL); ';
  Script.Add := '    if not SQL.EOF then result := SQL.FieldByName(''DEPTID''); ';
  Script.Add := '  finally ';
  Script.Add := '    SQL.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addGetRunningNumberIn;
begin
  addSetValidDateRunningNumber;
  Script.Add := 'function GetRunningNumberIn(Value:String):String; ';
  Script.Add := 'var Number : String;';
  Script.Add := '    sql    : TjbSQL; ';
  Script.Add := 'begin ';
  Script.Add := '  if Value = '''' then Exit; ';
  Script.Add := '  result := ''''; ';
  Script.Add := '  Number := ''''; ';
  Script.Add := '  sql    := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sql, format(''SELECT ed.%s ''+ ';
  Script.Add := '      ''FROM EXTENDEDTYPE ET LEFT JOIN '' + ';
  Script.Add := '      ''EXTENDEDDET ED ON ET.EXTENDEDTYPEID = ED.EXTENDEDTYPEID ''+ ';
  Script.Add := '      ''WHERE ET.EXTENDEDNAME = ''''%s'''' and ed.%s = ''''%s'''' '', ';
  Script.Add := '      [ IN_FIELD, TABLE_NAME_CASHBANK, BANK_ACCNT_FIELD, Value ])); ';
  Script.Add := '    if sql.Eof then Exit; ';
  Script.Add := '    Number := sql.FieldByName(IN_FIELD);';
  Script.Add := '    SetValidDateRunningNumber( IN_FIELD, Number ); ';
  Script.Add := '    result := Number; ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addGetRunningNumberOut(LvState,
  AccountName: String);
begin
  addSetValidDateRunningNumber;
  Script.Add := 'function GetRunningNumberOut:String; ';
  Script.Add := 'var Number: String;';
  Script.Add := '    sql : TjbSQL; ';
  Script.Add := 'begin ';
  Script.Add := Format('  if %s.%s.IsNull then Exit; ', [ LvState, AccountName ]);
  Script.Add := '  result := ''''; ';
  Script.Add := '  Number := ''''; ';
  Script.Add := '  sql    := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sql, format(''SELECT ed.%s ''+ ';
  Script.Add := '      ''FROM EXTENDEDTYPE ET LEFT JOIN '' + ';
  Script.Add := '      ''EXTENDEDDET ED ON ET.EXTENDEDTYPEID = ED.EXTENDEDTYPEID ''+ ';
  Script.Add := '      ''WHERE ET.EXTENDEDNAME = ''''%s'''' and ed.%s = ''''%s'''' '', ';
  Script.Add := Format('      [ OUT_FIELD, TABLE_NAME_CASHBANK, BANK_ACCNT_FIELD, %s.%s.AsString ])); ', [LvState, AccountName] );
  Script.Add := '    if sql.Eof then Exit; ';
  Script.Add := '    Number := sql.FieldByName(OUT_FIELD);';
  Script.Add := '    SetValidDateRunningNumber( OUT_FIELD, Number ); ';
  Script.Add := '    result := Number; ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addGetValueJV;
begin
  Script.Add := 'function GetValueJV(const StatusNumber: String):String; ';
  Script.Add := 'var sql : TjbSQL;';
  Script.Add := 'begin ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  result := ''''; ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sql, format(''SELECT Coalesce(ed.%s, '''''''')%s ''+ ';
  Script.Add := '      ''FROM EXTENDEDTYPE ET LEFT JOIN '' + ';
  Script.Add := '      ''EXTENDEDDET ED ON ET.EXTENDEDTYPEID = ED.EXTENDEDTYPEID ''+ ';
  Script.Add := '      ''WHERE ET.EXTENDEDNAME = ''''%s'''' '', ';
  Script.Add := '      [ StatusNumber, StatusNumber, TABLE_NAME_STATUSNUMBER ])); ';
//  Script.Add := '    if sql.Eof then RaiseException( Format(''Please fix table name of "%s" according FR'',[TABLE_NAME_STATUSNUMBER]) ); ';
  Script.Add := '    if sql.Eof then RaiseException( Format(''Please make sure Extended Type named: "%s" exists.'',[TABLE_NAME_CASHBANK]) ); '; // AA, BZ 3127
  Script.Add := '    if (sql.FieldByName(StatusNumber) = '''') then begin ';
  Script.Add := '      RaiseException( Format(''Please fill all Extended Custom Field from table %s in Extended Type'',[TABLE_NAME_STATUSNUMBER]) );  ';
  Script.Add := '    end; ';
  Script.Add := '    result := sql.FieldByName(StatusNumber);';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addGLAccountOnChangeOP;
begin
  addGetRunningNumberOut('Master');
  addIsBankAccount;
  Script.Add := 'procedure GLAccountOnChangeOP; ';
  Script.Add := 'begin ';
  Script.Add := '  if Master.GLAccount.AsString <> glAccountTemp then begin ';
  Script.Add := '    glAccountTemp := Master.GLAccount.AsString; ';
  Script.Add := '  end else begin ';
  Script.Add := '    Exit; ';
  Script.Add := '  end; ';
  Script.Add := '  if not IsBankAccount( Master.GLAccount.AsString ) then Exit; ';
  Script.Add := '  if GetRunningNumberOut = '''' then RaiseException( Format(''Please register account that ''+ ';
  Script.Add := '    ''used in table "%s" '',[TABLE_NAME_CASHBANK]) ); ';
//  Script.Add := '  if CountToken( GetRunningNumberOut, ''/'' ) <> COUNT_TOKEN then RaiseException '+
//                          ' (Format(''Please follow %s of feature request'',[TABLE_NAME_CASHBANK]) ); ';
  // AA, BZ 3029
  Script.Add := '  if (CountToken( GetRunningNumberOut, ''/'' )<>COUNT_TOKEN) And (ReadOption(''INCLUDE_DATE_IN_RUNNING_NO'', ''1'')=''1'') then begin ';
  Script.Add := '    RaiseException( Format(''Please follow %s of feature request'',[TABLE_NAME_CASHBANK]) );';
  Script.Add := '  end;';
  Script.Add := '  Master.JVNumber.Value := GetRunningNumberOut;';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addGLAccountOnChangeOR;
begin
  addGetRunningNumberIn;
  addIsBankAccount;
  Script.Add := 'procedure GLAccountOnChangeOR; ';
  Script.Add := 'var number : String; ';
  Script.Add := 'begin ';
  Script.Add := '  if Master.GLAccount.AsString <> glAccountTemp then begin ';
  Script.Add := '    glAccountTemp := Master.GLAccount.AsString; ';
  Script.Add := '  end else begin ';
  Script.Add := '    Exit; ';
  Script.Add := '  end; ';
  Script.Add := '  if not IsBankAccount( Master.GLAccount.AsString ) then Exit; ';
  Script.Add := '  number := GetRunningNumberIn(Master.GLAccount.AsString); ';
  Script.Add := '  if number = '''' then '+
                     'RaiseException( Format(''Please register account that ''+ ';
  Script.Add := '    ''used in table "%s" '',[TABLE_NAME_CASHBANK]) ); ';
//  Script.Add := '  if CountToken( number, ''/'' ) <> COUNT_TOKEN then RaiseException '+
//                          ' ( Format(''Please follow %s of feature request'',[TABLE_NAME_CASHBANK])); ';
  // AA, BZ 3029
  Script.Add := '  if (CountToken( number, ''/'' )<>COUNT_TOKEN) And (ReadOption(''INCLUDE_DATE_IN_RUNNING_NO'', ''1'')=''1'') then begin ';
  Script.Add := '    RaiseException( Format(''Please follow %s of feature request'',[TABLE_NAME_CASHBANK]) );';
  Script.Add := '  end;';
  Script.Add := '  Master.JVNumber.Value := number;';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addGLAmountOnChangeJV;
begin
  addIsVPMultiDiscExist;
  addGetRunningNumberIn;
  addGetRunningNumberOut('Detail');
  addGetValueJV;
  Script.Add := 'procedure GLAmountOnChangeJV; ';
  Script.Add := 'var currentSeq : String; ';
  Script.Add := '    number : String; ';
  Script.Add := '  ';
  Script.Add := '  procedure CheckBankAccount; ';
  Script.Add := '  var sql : TjbSQL; ';
  Script.Add := '  begin ';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Detail.Tx)); ';
  Script.Add := '    try ';
  Script.Add := '      RunSQL( sql, format(''Select First 1 jd.GLACCOUNT, jd.GLAmount from jvdet jd left join GLACCNT g '' + ';
  Script.Add := '        ''on g.GLACCOUNT = jd.GLACCOUNT where g.ACCOUNTTYPE = 7 and jd.JVID = %d'', [Master.JVID.AsInteger]) ); ';
  Script.Add := '      if sql.Eof then Exit; ';
  Script.Add := '      Detail.Locate(''GLACCOUNT'', sql.FieldByName(''GLAccount''), 0); ';
  Script.Add := '    finally ';
  Script.Add := '      sql.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := 'begin ';
  Script.Add := '  currentSeq := Detail.FieldByName(''Seq'').AsString; ';
  Script.Add := '  CheckBankAccount; ';
  Script.Add := '  if IsVPMultiDiscExist( Master.JVID.AsInteger ) then Exit; ';
  Script.Add := '  if Detail.GLAmount.Value > 0 then begin ';
  Script.Add := '    current_status := ''DEBIT''; ';
  Script.Add := '    number := GetRunningNumberIn(Detail.GLAccount.AsString); ';
  Script.Add := '    if Length( number ) > 20 then begin ';
  Script.Add := '      Master.JVNumber.Value := '' ''; ';
  Script.Add := '      RaiseException(''Number of character cannot more than 20''); ';
  Script.Add := '    end; ';
  Script.Add := '    if number = '''' then begin ';
  Script.Add := '      Master.JVNumber.Value := GetValueJV(JVNUMBER_FIELD); ';
  Script.Add := '      if IsBankAccount(Detail.GLAccount.Value) then begin ';
  Script.Add := '        RaiseException(Format(''Please register account that used in table "%s" '',[TABLE_NAME_CASHBANK]) ); ';
  Script.Add := '      end ';
  Script.Add := '    end ';
  Script.Add := '    else begin ';
  Script.Add := '      Master.JVNumber.Value := number; ';
  Script.Add := '    end; ';
  Script.Add := '  end ';
  Script.Add := '  else begin ';
  Script.Add := '    current_status := ''CREDIT''; ';
  Script.Add := '    if Length( GetRunningNumberOut ) > 20 then begin ';
  Script.Add := '      Master.JVNumber.Value := '' ''; ';
  Script.Add := '      RaiseException(''Number of character cannot more than 20''); ';
  Script.Add := '    end; ';
  Script.Add := '    if GetRunningNumberOut = '''' then begin ';
  Script.Add := '      Master.JVNumber.Value := GetValueJV(JVNUMBER_FIELD); ';
  Script.Add := '      if IsBankAccount(Detail.GLAccount.Value) then begin ';
  Script.Add := '        RaiseException(Format(''Please register account that used in table "%s" '',[TABLE_NAME_CASHBANK]) ); ';
  Script.Add := '      end; ';
  Script.Add := '    end ';
  Script.Add := '    else begin ';
  Script.Add := '      Master.JVNumber.Value := GetRunningNumberOut; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  if (bank_account_temp = Detail.GLAccount.AsString) and ';
  Script.Add := '    ( current_status = previous_status ) then begin ';
  Script.Add := '    Master.JVNumber.AsString := bank_account_RN_temp; ';
  Script.Add := '  end; ';
  Script.Add := '  if currentSeq <> ''0'' then Detail.Locate(''SEQ'', currentSeq, 0); ';
  Script.Add := 'end; ';
  Script.Add := ' ';
end;

procedure TRunningNoCashBankInjector.addIncrementJVNumber(DatasetName:String);
begin
  addNewNumber(DatasetName);
  Script.Add := 'procedure IncrementJVNumber; ';
  Script.Add := 'var sql : TjbSQL; ';
  Script.Add := '    ATx : TIBTransaction; ';
  Script.Add := '  ';
  Script.Add := '  function IsNumberFromIN:Boolean; ';
  Script.Add := '  begin ';
  script.Add := '    result := False; ';
  Script.Add := '    RunSQL( sql, format(''SELECT ed.%s ''+ ';
  Script.Add := '      ''FROM EXTENDEDTYPE ET LEFT JOIN '' + ';
  Script.Add := '      ''EXTENDEDDET ED ON ET.EXTENDEDTYPEID = ED.EXTENDEDTYPEID ''+ ';
  Script.Add := '      ''WHERE ET.EXTENDEDNAME = ''''%s'''' and ed.%s = ''''%s'''' '', ';
  Script.Add := Format('      [ IN_FIELD, TABLE_NAME_CASHBANK, IN_FIELD, %s.JVNumber.Value ])); ',[DatasetName]);
  Script.Add := '    result := not sql.Eof; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  function IsNumberFromOUT:Boolean; ';
  Script.Add := '  begin ';
  script.Add := '    result := False; ';
  Script.Add := '    RunSQL( sql, format(''SELECT ed.%s ''+ ';
  Script.Add := '      ''FROM EXTENDEDTYPE ET LEFT JOIN '' + ';
  Script.Add := '      ''EXTENDEDDET ED ON ET.EXTENDEDTYPEID = ED.EXTENDEDTYPEID ''+ ';
  Script.Add := '      ''WHERE ET.EXTENDEDNAME = ''''%s'''' and ed.%s = ''''%s'''' '', ';
  Script.Add := Format('      [ OUT_FIELD, TABLE_NAME_CASHBANK, OUT_FIELD, %s.JVNumber.Value ])); ',[(DatasetName)]);
  Script.Add := '    result := not sql.Eof; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  function IsNumberFromJVNumber:Boolean; ';
  Script.Add := '  begin ';
  script.Add := '    result := False; ';
  Script.Add := '    RunSQL( sql, format(''SELECT ed.%s ''+ ';
  Script.Add := '      ''FROM EXTENDEDTYPE ET LEFT JOIN '' + ';
  Script.Add := '      ''EXTENDEDDET ED ON ET.EXTENDEDTYPEID = ED.EXTENDEDTYPEID ''+ ';
  Script.Add := '      ''WHERE ET.EXTENDEDNAME = ''''%s'''' and ed.%s = ''''%s'''' '', ';
  Script.Add := Format('      [ JVNUMBER_FIELD, TABLE_NAME_STATUSNUMBER, JVNUMBER_FIELD, %s.JVNumber.Value ])); ',[DatasetName]);
  Script.Add := '    result := not sql.Eof; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := 'var NewJvNumber : String; ';
  Script.Add := 'begin ';
  Script.Add := '  ATx := CreateATx; ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(ATx)); ';
  Script.Add := '  try ';
  Script.Add := '    if IsNumberFromIN then begin ';
  Script.Add := Format('      %s.JVNumber.Value := sql.FieldByName(IN_FIELD); ',[DatasetName]);
  Script.Add := '      RunSQL( sql, Format( ''Update ExtendedDet ed set ed.%s = ''''%s'''' where ed.%s = ''''%s'''' '', ';
  Script.Add := Format('      [ IN_FIELD, NewNumber, IN_FIELD, %s.JVNumber.Value ]) ); ',[DatasetName]);
  Script.Add := '      Exit; ';
  Script.Add := '    end ';
  Script.Add := '    else if IsNumberFromOUT then begin ';
  Script.Add := Format('      %s.JVNumber.Value := sql.FieldByName(OUT_FIELD); ',[DatasetName]);
  Script.Add := '      RunSQL( sql, Format( ''Update ExtendedDet ed set ed.%s = ''''%s'''' where ed.%s = ''''%s'''' '', ';
  Script.Add := Format('      [ OUT_FIELD, NewNumber, OUT_FIELD, %s.JVNumber.Value ]) ); ',[DatasetName]);
  Script.Add := '      Exit; ';
  Script.Add := '    end ';
  Script.Add := '    else if IsNumberFromJVNumber then begin ';
  Script.Add := Format('      %s.JVNumber.Value := sql.FieldByName(JVNUMBER_FIELD); ',[DatasetName]);
  Script.Add := Format('      NewJvNumber := IncCtlNumber( %s.JVNumber.Value ); ',[DatasetName]);
  Script.Add := '      RunSQL( sql, Format( ''Update ExtendedDet ed set ed.%s = ''''%s'''' where ed.%s = ''''%s'''' '', ';
  Script.Add := Format('      [ JVNUMBER_FIELD, NewJvNumber, JVNUMBER_FIELD, %s.JVNumber.Value ]) ); ',[DatasetName]);
  Script.Add := '      Exit; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '    ATx.Commit; ';
  Script.Add := '    ATx.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addIncrementOPNumber;
begin
  addNewNumber('Master');
  Script.Add := 'procedure IncrementOPNumber; ';
  Script.Add := 'var sql : TjbSQL; ';
  Script.Add := '    ATx : TIBTransaction; ';
  Script.Add := 'begin ';
  Script.Add := '  ATx := CreateATx; ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(ATx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sql, Format( ''Update ExtendedDet ed set ed.%s = ''''%s'''' where ed.%s = ''''%s'''' '', ';
  Script.Add := '    [ OUT_FIELD, NewNumber, OUT_FIELD, Master.JVNumber.Value ]) ); ';
  Script.Add := '  finally ';
  Script.Add := '    ATx.Commit; ';
  Script.Add := '    ATx.Free; ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addIncrementORNumber;
begin
  addNewNumber('Master');
  Script.Add := 'procedure IncrementORNumber; ';
  Script.Add := 'var sql : TjbSQL; ';
  Script.Add := '    ATx : TIBTransaction; ';
  Script.Add := 'begin ';
  Script.Add := '  ATx := CreateATx; ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(ATx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sql, Format( ''Update ExtendedDet ed set ed.%s = ''''%s'''' where ed.%s = ''''%s'''' '', ';
  Script.Add := '    [ IN_FIELD, NewNumber, IN_FIELD, Master.JVNumber.Value ]) ); ';
  Script.Add := '  finally ';
  Script.Add := '    ATx.Commit; ';
  Script.Add := '    ATx.Free; ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addInitializationVar;
begin
  ReadOption;
  Script.Add := 'procedure InitializationVar; ';
  Script.Add := 'begin ';
  addInitializeVarTableNameCashBank;
  Script.Add := 'end; ';
  Script.Add := ' ';
end;

procedure TRunningNoCashBankInjector.addInitializationVarCR;
begin
  ReadOption;
  Script.Add := 'procedure InitializationVarCR; ';
  Script.Add := 'begin ';
  Script.Add := '  DEPARTMENT_CUSTOMER := ReadOption(''DEPARTMENT_CUSTOMER'', ''LOOKUP11''); ';
  addInitializeVarTableNameCashBank;
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addInitializationVarJV;
begin
  ReadOption;
  Script.Add := 'procedure InitializationVarJV; ';
  Script.Add := 'begin ';
  addInitializeVarTableNameCashBank;
  addInitializeVarTableNameStatusNumber;
  addInitializationVarJV_VPID_Field;
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addInitializationVarJVDataset;
begin
  ReadOption;
  Script.Add := 'procedure InitializationVarJVDataset; ';
  Script.Add := 'begin ';
  addInitializeVarTableNameCashBank;
  addInitializeVarTableNameStatusNumber;
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addInitializationVarJV_VPID_Field;
begin
  Script.Add := '  JV_VPID_FIELD       := ReadOption(''JV_VPID_FIELD'', ''CustomField1''); ';
end;

procedure TRunningNoCashBankInjector.addInitializationVarVP;
begin
  ReadOption;
  Script.Add := 'procedure InitializationVarVP; ';
  Script.Add := 'begin ';
  addInitializationVarJV_VPID_Field;
  addInitializeVarTableNameCashBank;
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addInitializeVarTableNameCashBank;
begin
  Script.Add := '  TABLE_NAME_CASHBANK := ReadOption( ''TABLE_NAME_CASHBANK'', ''Format Number'' ); ';
end;

procedure TRunningNoCashBankInjector.addInitializeVarTableNameStatusNumber;
begin
  Script.Add := '  TABLE_NAME_STATUSNUMBER := ReadOption( ''TABLE_NAME_STATUSNUMBER'', ''Status Number'' ); ';
end;

procedure TRunningNoCashBankInjector.addIsBankAccount;
begin
  Script.Add := 'function IsBankAccount(GLAccount: String):Boolean; ';
  Script.Add := '  const Bank_Cash = 7; ';
  Script.Add := '  var sql : TjbSQL; ';
  Script.Add := 'begin ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  result := False; ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sql, Format(''Select GLAccount From GLAccnt where GLAccount = ''''%s'''' and '' + ';
  Script.Add := '    ''AccountType = %d '', ';
  Script.Add := '    [GLAccount, Bank_Cash ] ) ); ';
  Script.Add := '    result := not sql.Eof; ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addIsFormExist(AFormName:TAFormName);
begin
  Script.Add := 'function IsFormExist: Boolean; ';
  Script.Add := '  var sql     : TjbSQL; ';
  Script.Add := '      textSQL : String; ';
  Script.Add := 'begin ';
  Script.Add := '  result  := False; ';
  Script.Add := '  sql     := CreateSQL(TIBTransaction(Tx)); ';
  if AFormName = AFNAPCHEQUE then begin
    Script.Add := '  textSQL := format(''SELECT 1 FROM APCHEQ WHERE CHEQUEID = %d '', [Master.CHEQUEID.AsInteger]); ';
  end
  else if AFormName = AFNARPAYMENT then begin
    Script.Add := '  textSQL := format(''SELECT 1 FROM ARPMT WHERE PAYMENTID = %d '', [Master.PaymentID.AsInteger]); ';
  end;
  Script.Add := '  try ';
  Script.Add := '    if textSQL = '''' then Exit; ';
  Script.Add := '    RunSQL(sql, textSQL); ';
  Script.Add := '    if not sql.EOF then result := True; ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
end;

procedure TRunningNoCashBankInjector.addIsVPMultiDiscExist;
begin
  Script.Add := 'function IsVPMultiDiscExist(AJVID: Integer): Boolean; ';
  Script.Add := '  var sqlJV     : TjbSQL; ';
  Script.Add := '      textSQLJV : String; ';
  Script.Add := 'begin ';
  Script.Add := '  result    := False; ';
  Script.Add := '  sqlJV     := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  textSQLJV := format(''SELECT A.JVID '' + ';
  Script.Add := '                      ''  FROM JV A, EXTENDED B, APCHEQ C '' + ';
  Script.Add := '                      '' WHERE A.EXTENDEDID = B.EXTENDEDID '' + ';
  Script.Add := '                      ''   AND B.%s = C.CHEQUEID '' + ';
  Script.Add := '                      ''   AND A.JVID = %d'', [JV_VPID_FIELD, AJVID]); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sqlJV, textSQLJV); ';
  Script.Add := '    if not sqlJV.EOF then result := True; ';
  Script.Add := '  finally ';
  Script.Add := '    sqlJV.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addMasterOnAfterSave(LvState, FormCode,
  StatusField: String);
begin
  addNewNumber( LvState, 'SequenceNo');
  Script.Add := 'procedure MasterOnAfterSave; ';
  Script.Add := 'begin ';
  Script.Add := Format('  Increment%sNumber;', [FormCode]);
  Script.Add := '  glAccountTemp := ''''; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := Format('procedure Increment%sNumber; ', [FormCode] );
  Script.Add := 'var sql : TjbSQL; ';
  Script.Add := '    ATx : TIBTransaction; ';
  Script.Add := 'begin ';
  Script.Add := '  ATx := CreateATx; ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(ATx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sql, Format( ''Update ExtendedDet ed set ed.%s = ''''%s'''' where ed.%s = ''''%s'''' '', ';
  Script.Add := Format('    [ %s_FIELD, NewNumber, %s_FIELD, %s.SequenceNo.Value ]) ); ', [StatusField, StatusField, LvState ]);
  Script.Add := '  finally ';
  Script.Add := '    ATx.Commit; ';
  Script.Add := '    ATx.Free; ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addMasterOnAfterSaveOP;
begin
  addIncrementOPNumber;
  Script.Add := 'procedure MasterOnAfterSaveOP; ';
  Script.Add := 'begin ';
  Script.Add := '  IncrementOPNumber;';
  Script.Add := '  glAccountTemp := ''''; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addMasterOnAfterSaveOR;
begin
  addIncrementORNumber;
  Script.Add := 'procedure MasterOnAfterSaveOR; ';
  Script.Add := 'begin ';
  Script.Add := '  IncrementORNumber;';
  Script.Add := '  glAccountTemp := ''''; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addMasterOnBeforeEditJV;
begin
  Script.Add := 'procedure MasterOnBeforeEditJV; ';
  Script.Add := 'begin ';
  Script.Add := '  if not Master.IsMasterNew then begin ';
  Script.Add := '    GetGLAccountTemp; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure GetGLAccountTemp; ';
  Script.Add := 'var sql : TjbSQL; ';
  Script.Add := 'begin ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sql, Format(''Select j.JVNUMBER, jd.GLACCOUNT, jd.GLAMOUNT, jd.SEQ From JV j left join JVDET jd '' + ';
  Script.Add := '      ''on j.JVID = jd.JVID left join GLACCNT gl on gl.GLACCOUNT = jd.GLACCOUNT ''+ ';
  Script.Add := '      ''where j.JVID = %d and j.SOURCE = ''''GL'''' and j.TRANSTYPE = ''''JV'''' and gl.ACCOUNTTYPE = 7'', [Master.JVID.AsInteger]) ); ';
  Script.Add := '    if sql.Eof then Exit; ';
  Script.Add := '    bank_account_temp := sql.FieldByName(''GLACCOUNT''); ';
  Script.Add := '    bank_account_RN_temp := sql.FieldByName(''JVNUMBER''); ';
  Script.Add := '    previous_status := ''CREDIT''; ';
  Script.Add := '    if sql.FieldByName(''GLAMOUNT'') > 0 then begin ';
  Script.Add := '      previous_status := ''DEBIT''; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addMasterOnBeforeSaveJV;
begin
  addCheckAccountBankAndCashJV;
  addIncrementJVNumber('Master');
  Script.Add := 'procedure MasterOnBeforeSaveJV; ';
  Script.Add := 'begin ';
  Script.Add := '  CheckAccountBankAndCashJV; ';
  Script.Add := '  IncrementJVNumber; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addMasterOnNewRecordJV;
begin
  Script.Add := 'procedure MasterOnNewRecordJV; ';
  Script.Add := 'begin ';
  Script.Add := '  if IsVPMultiDiscExist( Master.JVID.AsInteger ) then Exit; ';
  Script.Add := '  bank_account_temp    := ''-''; ';
  Script.Add := '  bank_account_RN_temp := ''-''; ';
  Script.Add := '  previous_status := ''-''; ';
  Script.Add := '  Master.JVNumber.Value := GetValueJV(JVNUMBER_FIELD);';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addNewNumber(LvState: String; const FieldName:String='JVNumber');
begin
  Script.Add := 'function NewNumber:String; ';
  Script.Add := 'var Number : String; ';
  Script.Add := '    no_rek : String; ';
  Script.Add := '    month  : String; ';
  Script.Add := '    year   : String; ';
  Script.Add := 'begin ';
  Script.Add := '  if (ReadOption(''INCLUDE_DATE_IN_RUNNING_NO'', ''1'')=''1'') then begin;';
  Script.Add := Format('    no_rek := GetToken(%s.%s.Value, ''/'', 1); ', [LvState, FieldName]);
  Script.Add := Format('    year   := GetToken(%s.%s.Value, ''/'', 2); ', [LvState, FieldName]);
  Script.Add := Format('    month  := GetToken(%s.%s.Value, ''/'', 3); ', [LvState, FieldName]);
  Script.Add := Format('    Number := IncCtlNumber( GetToken(%s.%s.Value, ''/'', 4) ); ', [LvState, FieldName]);
  Script.Add := '    result := no_rek + ''/'' + year + ''/'' + month + ''/'' + Number; ';
  Script.Add := '  end ';
  Script.Add := '  else begin '; // AA BZ 3029
  Script.Add := Format('    result := IncCtlNumber(%s.%s.Value); ', [LvState, FieldName]);
  Script.Add := '  end;';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addSetDeptID;
begin
  addGetDeptIDCustomer;
  Script.Add := 'procedure SetDeptID; ';
  Script.Add := '  var deptID : Integer; ';
  Script.Add := 'begin ';
  Script.Add := '  deptID := GetDeptIDCustomer(Master.BillToID.Value); ';
  Script.Add := '  if deptID = nil then Exit; ';
  Script.Add := '  Master.DeptID.AsInteger := deptID; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addSetRNGLAccount;
begin
  addGetValueJV;
  addGetRunningNumberIn;
  Script.Add := 'procedure SetRNGLAccount; ';
  Script.Add := 'var number : String; ';
  Script.Add := 'begin ';
  Script.Add := '  if bankAccount = '''' then Exit; ';
  Script.Add := '  number := GetRunningNumberIn(bankAccount); ';
  Script.Add := '  if Length( number ) > 20 then begin ';
  Script.Add := '    dataset.JVNumber.Value := '' ''; ';
  Script.Add := '    RaiseException(''Number of character cannot more than 20''); ';
  Script.Add := '  end; ';
  Script.Add := '  if number = '''' then begin ';
  Script.Add := '    dataset.JVNumber.Value := GetValueJV(JVNUMBER_FIELD); ';
  Script.Add := '    RaiseException( Format(''Please register account that used in table "%s" '',[TABLE_NAME_CASHBANK])); ';
  Script.Add := '  end ';
  Script.Add := '  else begin ';
  Script.Add := '    dataset.JVNumber.Value := number; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := ' ';
end;

procedure TRunningNoCashBankInjector.addSetValidDateRunningNumber;
begin
  if not Script.IsProcedureExist('procedure SetValidDateRunningNumber(StatusField: String; var Number: String);') then begin
    Script.Add := '  var validNumber : String; ';
    Script.Add := '      no_rek  : String; ';
    Script.Add := '      month   : String; ';
    Script.Add := '      year    : String; ';
    Script.Add := '      oldDate : String; ';
    Script.Add := '      newDate : String; ';
    Script.Add := '  ';
    Script.Add := '  procedure UpdateValidNumber; ';
    Script.Add := '  var sql : TjbSQL; ';
    Script.Add := '      ATx : TIBTransaction; ';
    Script.Add := '  begin ';
    Script.Add := '    if validNumber = '''' then Exit; ';
    Script.Add := '    ATx := CreateATx; ';
    Script.Add := '    sql := CreateSQL(TIBTransaction(ATx)); ';
    Script.Add := '    try ';
    Script.Add := '      RunSQL( sql, Format( ''Update ExtendedDet ed set ed.%s = ''''%s'''' where ed.%s = ''''%s'''' '', ';
    Script.Add := '    [ StatusField, validNumber, StatusField, Number ]) ); ';
    Script.Add := '    finally ';
    Script.Add := '      ATx.Commit; ';
    Script.Add := '      ATx.Free; ';
    Script.Add := '      sql.Free; ';
    Script.Add := '    end; ';
    Script.Add := '  end; ';
    Script.Add := 'begin ';
    Script.Add := '  if (ReadOption(''INCLUDE_DATE_IN_RUNNING_NO'', ''1'')=''0'') then Exit;'; // AA BZ 3029
    Script.Add := '  if Number = '''' then Exit; ';
    Script.Add := '  validNumber := ''''; ';
    Script.Add := '  if CountToken( Number, ''/'' ) <> COUNT_TOKEN then Exit; ';
    Script.Add := '  no_rek := GetToken(Number, ''/'', 1); ';
    Script.Add := '  year   := GetToken(Number, ''/'', 2); ';
    Script.Add := '  month  := GetToken(Number, ''/'', 3); ';
    Script.Add := '  oldDate := year + ''/'' + month; ';
    Script.Add := '  newDate := FormatDateTime(''yy'', Now) + ''/'' + FormatDateTime(''mm'', Now); ';
    Script.Add := '  if oldDate <> newDate then begin ';
    Script.Add := '    validNumber := no_rek + ''/'' + newDate + ''/'' + ''0001''; ';
    Script.Add := '    UpdateValidNumber; ';
    Script.Add := '    Number := validNumber; ';
    Script.Add := '  end; ';
    Script.Add := 'end; ';
    Script.Add := '';
  end;
end;

procedure TRunningNoCashBankInjector.addShowSettingFormatNumber;
begin
  addDecorateFrm;
  Script.Add := 'procedure ShowSettingFormatNumber; ';
  Script.Add := 'begin ';
  Script.Add := '  frm := CreateForm( ''frm'', ''Setting Format No. Cash/Bank'', 450, 400); ';
  Script.Add := '  ATx := CreateATx; ';
  Script.Add := '  try ';
  Script.Add := '    DecorateFrm; ';
  Script.Add := '    if frm.ShowModal = mrOk then begin ';
  Script.Add := '      ATx.Commit; ';
  Script.Add := '    end ';
  Script.Add := '    else begin ';
  Script.Add := '      ATx.RollBack; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    frm.Free; ';
  Script.Add := '    ATx.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addValidateVPMultiDisc;
begin
  Script.Add := 'procedure ValidateVPMultiDisc; ';
  Script.Add := '  var sqlJV     : TjbSQL; ';
  Script.Add := '      textSQLJV : String; ';
  Script.Add := 'begin ';
  Script.Add := '  sqlJV     := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  textSQLJV := format(''SELECT A.JVNumber, A.TransDate '' + ';
  Script.Add := '                      ''  FROM JV A, EXTENDED B, APCHEQ C '' + ';
  Script.Add := '                      '' WHERE A.EXTENDEDID = B.EXTENDEDID '' + ';
  Script.Add := '                      ''   AND B.%s = C.CHEQUEID '' + ';
  Script.Add := '                      ''   AND A.JVID = %d'', [JV_VPID_FIELD, Master.JVID.Value]); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sqlJV, textSQLJV); ';
  Script.Add := '    if not sqlJV.EOF then begin ';
  Script.Add := '      Master.JVNumber.Value  := sqlJV.FieldByName(''JVNumber''); ';
  Script.Add := '      Master.TransDate.Value := sqlJV.FieldByName(''TransDate''); ';
  Script.Add := '      ShowMessage(''Multi discount JV can not be edited''); ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    sqlJV.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNoCashBankInjector.addVar;
begin
  Script.Add := 'var ';
  Script.Add := '    glAccountTemp      : String = ''''; ';
  addVarTableNameCashBank;
end;

procedure TRunningNoCashBankInjector.addVarIsAllowPostCRDataset;
begin
  Script.Add := '    isAllowPostCRDataset : Boolean; ';
end;

procedure TRunningNoCashBankInjector.addVarJVP_VPID_Field;
begin
  Script.Add := '    JV_VPID_FIELD : String; ';
end;

procedure TRunningNoCashBankInjector.addVarTableNameCashBank;
begin
  Script.Add := '    TABLE_NAME_CASHBANK : String; ';
end;

procedure TRunningNoCashBankInjector.addVarTableNameStatusNumber;
begin
  Script.Add := '    TABLE_NAME_STATUSNUMBER : String; ';
end;

procedure TRunningNoCashBankInjector.generateMain;
begin
  ClearScript;
  CreateListView;
  CreateEditBox;
  CreateFormSetting;
  CreateCustomMenuSetting;
  LeftPos;
  Script.Add := 'var frm : TForm; ';
  Script.Add := '    listNumber : TListView; ';
  Script.Add := '    btnOK      : TButton; ';
  Script.Add := '    btnCancel  : TButton; ';
  Script.Add := '    btnEdit    : TButton; ';
  Script.Add := '    btnNew     : TButton; ';
  Script.Add := '    ATx        : TIBTransaction; ';
  addVarTableNameCashBank;
  Script.Add := 'const ';
  addConstBankAccnt;
  addConstIN_Field;
  addConstOUT_Field;
  Script.Add := '';
  Script.Add := 'procedure ShowSettingFeatureCashBank; ';
  Script.Add := 'var frmSetting : TForm; ';
  Script.Add := 'begin ';
  Script.Add := '  frmSetting := CreateFormSetting(''frmSetting'', ''Setting Feature Cash/Bank'', 400, 250);';
  Script.Add := '  try ';
  Script.Add := '    AddControl( frmSetting, ''Table Name Cash/Bank'', ''TEXT'', ''TABLE_NAME_CASHBANK'', ''Format Number'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Table Name Status Number JV'', ''TEXT'', ''TABLE_NAME_STATUSNUMBER'', ''Status Number'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Include date in running number'', ''CHECKBOX'', ''INCLUDE_DATE_IN_RUNNING_NO'', ''1'', ''0'', ''''); ';
  Script.Add := '    if frmSetting.ShowModal = mrOK then begin ';
  Script.Add := '      SaveToOptions; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    frmSetting.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure initializeVarMain; ';
  Script.Add := 'begin ';
  addInitializeVarTableNameCashBank;
  Script.Add := 'end; ';
  Script.Add := '';
  addShowSettingFormatNumber;
  Script.Add := 'begin ';
  Script.Add := '  initializeVarMain; ';
  Script.Add := '  AddCustomMenuSetting(''mnuSettingFormatBank'', ''Setting Format No. Cash/Bank'', ''ShowSettingFormatNumber''); ';
  Script.Add := '  AddCustomMenuSetting(''mnuSettingFeatureCashBank'', ''Setting Feature Cash/Bank'', ''ShowSettingFeatureCashBank''); ';
  Script.Add := 'end. ';
end;

procedure TRunningNoCashBankInjector.GenerateScript;
begin
  generateMain;
  InjectToDB( fnMain );

  generateScriptFormOR;
  InjectToDB( fnOtherDeposit );

  generateScriptFormOP;
  InjectToDB( fnDirectPayment );

  generateScriptFormVP;
  InjectToDB( fnAPCheque );

  generateScriptFormJV;
  InjectToDB( fnJV );

  generateScriptJVDataset;
  InjectToDB( dnJV );

  generateScriptFormCR;
  InjectToDB( fnARPayment );

  generateScriptCRDataset;
  InjectToDB( dnCR );
end;

procedure TRunningNoCashBankInjector.generateScriptCRDataset;
begin
  ClearScript;
  AddConst( addConstIN_Field );
  addVar;
  addVarIsAllowPostCRDataset;
  addInitializationVar;
  addDoChangeBankAccount;
  addMasterOnAfterSave( 'dataset', 'CR', 'IN' );
  Script.Add := 'begin ';
  Script.Add := '  InitializationVar; ';
  Script.Add := '  isAllowPostCRDataset   := False; ';
  Script.Add := '  glAccountTemp := ''''; ';
  Script.Add := '  dataset.BankAccount.OnValidateArray := @DoChangeBankAccount; ';
  Script.Add := '  dataset.on_after_save_array := @MasterOnAfterSave; ';
  Script.Add := 'end. ';
end;

procedure TRunningNoCashBankInjector.generateScriptFormCR;
begin
  ClearScript;
  AddConst( addConstIN_Field );
  addVar;
  addCustomVarFormCR;
  addInitializationVarCR;
  addSetDeptID;
  addBankAccountOnChange( 'BankAccount', AFNARPAYMENT );
  addMasterOnAfterSave('Master', 'CR', 'IN');
  Script.Add := 'begin ';
  Script.Add := '  InitializationVarCR; ';
  Script.Add := '  glAccountTemp := ''''; ';
  Script.Add := '  Master.BillToID.OnChangeArray    := @SetDeptID; ';
  Script.Add := '  Master.BankAccount.OnChangeArray := @BankAccountOnChange; ';
  Script.Add := '  Master.on_after_save_array       := @MasterOnAfterSave; ';
  Script.Add := 'end. ';
end;

procedure TRunningNoCashBankInjector.generateScriptFormJV;
begin
  ClearScript;
  CreateLabel;
  IsAdmin;
  IsSupervisor;
  AddConst( addConstJV );
  addVar;
  addCustomVarJV;
  addVarTableNameStatusNumber;
  addInitializationVarJV;
  addValidateVPMultiDisc;
  addMasterOnNewRecordJV;
  addGLAmountOnChangeJV;
  addMasterOnBeforeSaveJV;
  addMasterOnBeforeEditJV;
  Script.Add := 'begin ';
  Script.Add := '  InitializationVarJV; ';
  Script.Add := '  Master.JVNumber.OnChangeArray  := @ValidateVPMultiDisc; ';
  Script.Add := '  Master.TransDate.OnChangeArray := @ValidateVPMultiDisc; ';
  Script.Add := '  Master.OnNewRecordArray        := @MasterOnNewRecordJV; ';
  Script.Add := '  Detail.GLAmount.OnChangeArray  := @GLAmountOnChangeJV; ';
  Script.Add := '  Detail.GLAccount.OnChangeArray := @GLAmountOnChangeJV; ';
  Script.Add := '  Master.on_before_save_array    := @MasterOnBeforeSaveJV; ';
  Script.Add := '  Master.OnBeforeEditArray       := @MasterOnBeforeEditJV; ';
  Script.Add := 'end. ';
end;

procedure TRunningNoCashBankInjector.generateScriptFormOP;
begin
  ClearScript;
  IsAdmin;
  IsSupervisor;
  CreateLabel;
  addConst( addConstOUT_Field );
  addVar;
  addInitializationVar;
  addGLAccountOnChangeOP;
  addMasterOnAfterSaveOP;
  Script.Add := 'begin ';
  Script.Add := '  InitializationVar; ';
  Script.Add := '  glAccountTemp := ''''; ';
  Script.Add := '  Master.GLAccount.OnChangeArray     := @GLAccountOnChangeOP; ';
  Script.Add := '  Master.on_after_save_array         := @MasterOnAfterSaveOP; ';
  Script.Add := 'end. ';
end;

procedure TRunningNoCashBankInjector.generateScriptFormOR;
begin
  ClearScript;
  addConst( addConstIN_Field );
  addVar;
  addInitializationVar;
  addGLAccountOnChangeOR;
  addMasterOnAfterSaveOR;
  Script.Add := 'begin ';
  Script.Add := '  InitializationVar; ';
  Script.Add := '  glAccountTemp := ''''; ';
  Script.Add := '  Master.GLAccount.OnChangeArray := @GLAccountOnChangeOR; ';
  Script.Add := '  Master.on_after_save_array     := @MasterOnAfterSaveOR; ';
  Script.Add := 'end. ';
end;

procedure TRunningNoCashBankInjector.generateScriptFormVP;
begin
  ClearScript;
  IsAdmin;
  IsSupervisor;
  CreateLabel;
  RunQuery;
  AddConst( addConstOUT_Field );

  addVar;
  addCustomVarVP;
  addInitializationVarVP;

  addBankAccountOnChange( 'BankAccnt', AFNAPCHEQUE );
  addMasterOnAfterSave('Master', 'VP', 'OUT');

  Script.Add := 'begin';
  Script.Add := '  InitializationVarVP; ';
  Script.Add := '  glAccountTemp := ''''; ';
  Script.Add := '  Master.BankAccnt.OnChangeArray     := @BankAccountOnChange; ';
  Script.Add := '  Master.on_after_save_array         := @MasterOnAfterSave; ';
  Script.Add := 'end.';
end;

procedure TRunningNoCashBankInjector.generateScriptJVDataset;
begin
  ClearScript;
  AddConst( addConstJV );
  addVar;
  addCustomVarJVDataset;
  addInitializationVarJVDataset;
  addDoBeforePost;
  Script.Add := 'begin ';
  Script.Add := '  InitializationVarJVDataset; ';
  Script.Add := '  dataset.OnBeforePostArray := @DoBeforePost;';
  Script.Add := 'end. ';
end;

procedure TRunningNoCashBankInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := 'Running No Cash/Bank';
end;

end.
