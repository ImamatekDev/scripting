unit RunningNumberbyFormInjector;

interface
uses BankConst, System.SysUtils, Injector, Language;
type
  TRunningNumberbyFormInjector = class(TInjector)
  private
    procedure InitializationVar;
    procedure FillListNumberTemplate;
    procedure SettingFormatTemplate;
    procedure UpdateSQL;
    procedure GenerateScriptForRI;
    procedure GenerateScriptForMain;
  protected
    procedure AddFunction_IsFormExist(AFormName: string);
    procedure SetRunningNumberTemplate(Table: String; FieldNumber: String);
    procedure ApplyRunningNumberInForm (form, table, fieldNo : string); virtual;
	  procedure GetTextSQL (AFormName: string); virtual;
    procedure GetTemplateTypeIndex; virtual;
	  procedure FillTemplateType; virtual;
    procedure GetRNTemplate(Table ,FieldNumber: String); virtual;
    procedure set_scripting_parameterize; override;
  public
    procedure GenerateScript; override;
  end;

implementation

{ TRunningNumberbyFormInjector }

procedure TRunningNumberbyFormInjector.InitializationVar;
begin
  Script.Add := 'var';
  Script.Add := '  numberDefault : String = ''''; ';
  Script.Add := 'const';
  Script.Add := '  TEMPLATE_TYPE = ''INFO1''; ';
  Script.Add := '  TEMPLATE_NAME = ''INFO2''; ';
  Script.Add := '  TEMPLATE_CODE = ''INFO3''; ';
  Script.Add := '  TEMPLATE_RN   = ''INFO4''; ';
end;

procedure TRunningNumberbyFormInjector.GetTextSQL (AFormName: string);
begin
  Script.Add := 'function GetTextSQL : string;';
  Script.Add := 'begin';
  if (AFormName='FNSALESORDER') then begin
    Script.Add := '  Result := format(''SELECT 1 FROM SO WHERE SOID = %d '', [Master.SOID.AsInteger]); ';
  end else if ( (AFormName='FNDELIVERYORDER') or (AFormName='FNARINVOICE') ) then begin
    Script.Add := '  Result := format(''SELECT 1 FROM ARINV WHERE ARINVOICEID = %d '', [Master.ARINVOICEID.AsInteger]); ';
  end else if (AFormName='FNARREFUND') then begin
    Script.Add := '  Result := format(''SELECT 1 FROM ARREFUND WHERE ARREFUNDID = %d '', [Master.ARREFUNDID.AsInteger]); ';
  end else if (AFormName='FNPURCHASEORDER') then begin
    Script.Add := '  Result := format(''SELECT 1 FROM PO WHERE POID = %d '', [Master.POID.AsInteger]); ';
  end else if (AFormName='FNRECEIVEITEM') then begin
    Script.Add := '  Result := format(''SELECT 1 FROM APINV WHERE APINVOICEID = %d '', [Master.APINVOICEID.AsInteger]); ';
  end else if (AFormName='FNDM') then begin
    Script.Add := '  Result := format(''SELECT 1 FROM APRETURN WHERE APRETURNID = %d '', [Master.APRETURNID.AsInteger]); ';
  end else if (AFormName='FNTRANSFERFORM') then begin
    Script.Add := '  Result := format(''SELECT 1 FROM WTRAN WHERE TRANSFERID =  %d '', [Master.TRANSFERID.AsInteger]); ';
  end else if (AFormName='FNINVADJUSTMENT') then begin
    Script.Add := '  Result := format(''SELECT 1 FROM ITEMADJ WHERE ITEMADJID =  %d '', [Master.ITEMADJID.AsInteger]); ';
  end else if (AFormName='FNARPAYMENT') then begin
    Script.Add := '  Result := format(''SELECT 1 FROM ARPMT WHERE PAYMENTID = %d '', [Master.PaymentID.AsInteger]); ';
  end else if (AFormName='FNAPCHEQUE') then begin
    Script.Add := '  Result := format(''SELECT 1 FROM APCHEQ WHERE CHEQUEID = %d '', [Master.CHEQUEID.AsInteger]); ';
  end else begin
    Script.Add := '  Result := ''''; ';
  end;
  Script.Add := 'end;';
end;

procedure TRunningNumberbyFormInjector.AddFunction_IsFormExist(AFormName: string);
begin
  GetTextSQL (AFormName);

  Script.Add := 'function IsFormExist: Boolean; ';
  Script.Add := '  var sql : TjbSQL; ';
  Script.Add := 'begin ';
  Script.Add := '  result  := False; ';
  Script.Add := '  sql     := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    if GetTextSQL = '''' then begin';
  Script.Add := '      Exit; ';
  Script.Add := '    end;';
  Script.Add := '    RunSQL(sql, GetTextSQL); ';
  Script.Add := '    result := NOT sql.EOF; ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
end;

procedure TRunningNumberbyFormInjector.UpdateSQL;
begin
  RunQuery;

  Script.Add := 'procedure UpdateSQL(ATx: TIBTransaction; AQuery: TIBQuery; sql:String); ';
  Script.Add := 'begin ';
  Script.Add := '  RunQuery( AQuery, sql ); ';
  Script.Add := '  AQuery.Close; ';
  Script.Add := '  ATx.Commit; ';
  Script.Add := 'end; ';
  Script.Add := EmptyStr;
end;

procedure TRunningNumberbyFormInjector.GetRNTemplate(Table ,FieldNumber: String);
begin

  Script.Add := 'function GetRNTemplate : String; ';
  Script.Add := 'var trxCode    : String; ';
  Script.Add := '    sqlCode    : TjbSQL; ';
  Script.Add := '    sqlNumber  : TjbSQL; ';
  Script.Add := '    textSQL    : String; ';
  Script.Add := '    number     : String = ''''; ';
  Script.Add := '    numberTemp : String = ''''; ';
  Script.Add := 'begin ';
  Script.Add := '  result := ''''; ';
  Script.Add := '  if Master.TemplateID.IsNull then begin';
  Script.Add := '    Exit; ';
  Script.Add := '  end;';

  Script.Add := '  trxCode    := ''''; ';
  Script.Add := '  numberTemp := ''''; ';
  Script.Add := '  number     := ''''; ';

  Script.Add := '  sqlCode := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  textSQL := format(''SELECT ed.%s FROM EXTENDEDTYPE ET '+
                              'LEFT JOIN EXTENDEDDET ED ON ET.EXTENDEDTYPEID = ED.EXTENDEDTYPEID '+
                              'WHERE ET.EXTENDEDNAME = ''''Format No. Template'''' '+
                              'AND ed.%s = ''''%s'''' '' '+
                              ',[TEMPLATE_CODE, TEMPLATE_NAME '+
                              ', Master.TemplateID.FieldLookup.FieldByName(''Name'').AsString]); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sqlCode, textSQL); ';
  Script.Add := '    if sqlCode.Eof then begin';
  Script.Add := '      Exit; ';
  Script.Add := '    end;';

  Script.Add := '    trxCode := sqlCode.FieldByName(TEMPLATE_CODE);';
  Script.Add := '  finally ';
  Script.Add := '    sqlCode.Free; ';
  Script.Add := '  end; ';

  Script.Add := '  if trxCode = '''' then begin';
  Script.Add := '    Exit; ';
  Script.Add := '  end;';

  Script.Add := '  numberTemp := trxCode + FormatDateTime(''yymm'', Now); ';
  Script.Add := '  sqlNumber  := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  textSQL    := ''SELECT COALESCE(MAX(' + FieldNumber + '), '''''''') NUMBER FROM ' + Table + ' WHERE ' + FieldNumber + ' LIKE '''''' + numberTemp + ''%'''' ''; ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sqlNumber, textSQL); ';
  Script.Add := '    if ((not sqlNumber.Eof) and (sqlNumber.FieldByName(''NUMBER'') <> '''')) then begin ';
  Script.Add := '      number := sqlNumber.FieldByName(''NUMBER''); ';
  Script.Add := '      number := IncCtlNumber(number); ';
  Script.Add := '    end';
  Script.Add := '    else begin ';
  Script.Add := '      number := numberTemp + ''000001''; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.add := '    sqlNumber.Free; ';
  Script.Add := '  end; ';

  Script.Add := '  result := number; ';
  Script.Add := 'end; ';
end;

procedure TRunningNumberbyFormInjector.SetRunningNumberTemplate(Table,
  FieldNumber: String);
begin
  UpdateSQL;
  InitializationVar;
  AddFunction_CreateSQL;
  add_procedure_runsql;
  CreateTx;

  GetRNTemplate (Table ,FieldNumber);

  Script.Add := EmptyStr;
  Script.Add := 'function IsTemplTypeExist: Boolean; ';
  Script.Add := 'var sqlTempl     : TjbSQL; ';
  Script.Add := '    textSQLTempl : String; ';
  Script.Add := 'begin ';
  Script.Add := '  result       := False; ';
  Script.Add := '  sqlTempl     := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  textSQLTempl := format(''SELECT 1 '' + ';
  Script.Add := '                         ''  FROM EXTENDEDTYPE ET LEFT JOIN '' + ';
  Script.Add := '                         ''       EXTENDEDDET ED ON ET.EXTENDEDTYPEID = ED.EXTENDEDTYPEID, '' + ';
  Script.Add := '                         ''       TEMPLATE T '' + ';
  Script.Add := '                         '' WHERE ET.EXTENDEDNAME = ''''Format No. Template'''' '' + ';
  Script.Add := '                         ''   AND ED.%s = T.NAME '' + ';
  Script.Add := '                         ''   AND T.TEMPLATETYPE = (SELECT T.TEMPLATETYPE FROM TEMPLATE T WHERE T.NAME = ''''%s'''') '', ';
  Script.Add := '                         [TEMPLATE_NAME, Master.TemplateID.FieldLookup.FieldByName(''Name'').AsString]); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sqlTempl, textSQLTempl); ';
  Script.Add := '    result := NOT sqlTempl.EOF; ';
  Script.Add := '  finally ';
  Script.Add := '    sqlTempl.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';

  Script.Add := EmptyStr;
  Script.Add := 'var rnTemplate : String = ''''; ';

  Script.Add := EmptyStr;
  Script.Add := 'procedure SetRNTemplate; ';
  Script.Add := 'begin ';
  Script.Add := '  if (IsFormExist) or (not Master.IsMasterNew) then begin';
  Script.Add := '    Exit; ';
  Script.Add := '  end;';

  Script.Add := '  if numberDefault = '''' then begin ';
  Script.Add := '    numberDefault := Master.' + FieldNumber + '.AsString; ';
  Script.Add := '  end; ';

  Script.Add := '  rnTemplate := ''''; ';
  Script.Add := '  rnTemplate := GetRNTemplate; ';
  Script.Add := '  Master.Edit; ';

  Script.Add := '  if rnTemplate = '''' then begin ';
  Script.Add := '    if numberDefault <> '''' then begin ';
  Script.Add := '      Master.' + FieldNumber + '.AsString := numberDefault; ';
  Script.Add := '    end; ';
  Script.Add := '    if IsTemplTypeExist then begin ';
  Script.Add := '      ShowMessage(''Jika salah satu Template Type sudah di setting "Format No. Template" '+
                       ', untuk semua template dengan jenis yang sama harus di setting semua'');';
  Script.Add := '    end; ';
  Script.Add := '  end';
  Script.Add := '  else begin ';
  Script.Add := '    Master.' + FieldNumber + '.AsString := rnTemplate; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';

  Script.Add := EmptyStr;
  Script.Add := 'procedure UpdateRNTemplate; ';
  Script.Add := 'var ATx       : TIBTransaction; ';
  Script.Add := '    qryUpdate : TIBQuery; ';
  Script.Add := 'begin ';
  Script.Add := '  if rnTemplate = '''' then begin';
  Script.Add := '    Exit; ';
  Script.Add := '  end;';

  Script.Add := '  aTx                   := CreateATx; ';
  Script.Add := '  qryUpdate             := TIBQuery.Create(nil); ';
  Script.Add := '  qryUpdate.Database    := TIBDatabase(db); ';
  Script.Add := '  qryUpdate.Transaction := aTx; ';
  Script.Add := '  try ';
  Script.Add := '    UpdateSQL(aTx, qryUpdate, format(''UPDATE ExtendedDet ed '+
                     'SET ed.%s = ''''%s'''' WHERE %s = ''''%s'''' '' '+
                     ',[TEMPLATE_RN, rnTemplate, TEMPLATE_NAME '+
                     ', Master.TemplateID.FieldLookup.FieldByName(''Name'').AsString])); ';
  Script.Add := '  finally ';
  Script.Add := '    qryUpdate.Free; ';
  Script.Add := '    aTx.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';

  Script.Add := EmptyStr;
  Script.Add := 'procedure PrepareRNFormEvent; ';
  Script.Add := 'begin';
  Script.Add := '  Master.TemplateID.OnChangeArray := @SetRNTemplate; ';
  Script.Add := '  Master.on_after_save_array      := @UpdateRNTemplate; ';
  Script.Add := 'end;';
end;

procedure TRunningNumberbyFormInjector.FillListNumberTemplate;
begin
  Script.Add := 'procedure FillListNumberTemplate; ';
  Script.Add := 'var                                                                                                                     ';
  Script.Add := '  listItem : TListItem;                                                                                                 ';
  Script.Add := '  sql      : TjbSQL; ';
  Script.Add := 'begin                                                                                                                   ';
  Script.Add := '  listNumberTemplate.Items.Clear;                                                                                            ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(ATxTemplate));                                                                                          ';
  Script.Add := '  try                                                                                                                   ';
  Script.Add := '    RunSQL(sql, format(''SELECT Coalesce(ed.ExtendedDetID, -1)ExtendedDetID, Coalesce(ed.%s, '''''''')%s, ''+ ';
  Script.Add := '      ''Coalesce(ed.%s,  '''''''')%s, Coalesce(ed.%s, '''''''')%s, Coalesce(ed.%s, '''''''')%s ''+ ';
  Script.Add := '      ''FROM EXTENDEDTYPE ET LEFT JOIN '' + ';
  Script.Add := '      ''EXTENDEDDET ED ON ET.EXTENDEDTYPEID = ED.EXTENDEDTYPEID ''+ ';
  Script.Add := '      ''WHERE ET.EXTENDEDNAME = ''''Format No. Template'''' '', ';
  Script.Add := '      [TEMPLATE_TYPE, TEMPLATE_TYPE, TEMPLATE_NAME, TEMPLATE_NAME, TEMPLATE_CODE, TEMPLATE_CODE, TEMPLATE_RN, TEMPLATE_RN ])); ';

  Script.Add := '    while not sql.EOF do begin                                                                                 ';
  Script.Add := '      listItem := listNumberTemplate.Items.Add; ';
  Script.Add := '      listItem.SubItems.Add( sql.FieldByName( ''ExtendedDetID'' )); ';
  Script.Add := '      listItem.SubItems.Add( sql.FieldByName( TEMPLATE_TYPE )); ';
  Script.Add := '      listItem.SubItems.Add( sql.FieldByName( TEMPLATE_NAME )); ';
  Script.Add := '      listItem.SubItems.Add( sql.FieldByName( TEMPLATE_CODE )); ';
  Script.Add := '      listItem.SubItems.Add( sql.FieldByName( TEMPLATE_RN )); ';
  Script.Add := '      sql.Next;                                                                                                ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free;                                                                                                  ';
  Script.Add := '  end;                                                                                                         ';
  Script.Add := 'end;                                                                                                           ';
  Script.Add := '';
end;

procedure TRunningNumberbyFormInjector.GetTemplateTypeIndex;
begin
  Script.Add := 'function GetTemplateTypeIndex(TemplType: String): Integer; ';
  Script.Add := 'begin ';
  Script.Add := '  result := -1; ';
  Script.Add := '  Case TemplType of ';
  Script.Add := Format('   ''%s'': result := 0; ', [TypeSalesInvoice]);
  Script.Add := Format('   ''%s'': result := 1; ', [TypeSalesOrder]);
  Script.Add := Format('   ''%s'': result := 3; ', [TypeSalesReturn]);
  Script.Add := Format('   ''%s'': result := 5; ', [TypeReceiveItem]);
  Script.Add := Format('   ''%s'': result := 6; ', [TypePurchaseOrder]);
  Script.Add := Format('   ''%s'': result := 7; ', [TypePurchaseReturn]);
  Script.Add := Format('   ''%s'': result := 8; ', [TypeItemTransfer]);
  Script.Add := Format('   ''%s'': result := 13; ', [TypeItemAdjustment]);
  Script.Add := '  end; ';
  Script.Add := 'end; ';
end;

procedure TRunningNumberbyFormInjector.FillTemplateType;
begin
  Script.Add := '';
  Script.Add := 'procedure FillTemplateType (cbTemplType : TComboBox); ';
  Script.Add := 'begin';
  Script.Add := '  cbTemplType.Items.Clear; ';
  Script.Add := Format('  cbTemplType.Items.Add( ''%s'' ); ', [TypeSalesInvoice]);
  Script.Add := Format('  cbTemplType.Items.Add( ''%s'' ); ', [TypeSalesOrder]);
  Script.Add := Format('  cbTemplType.Items.Add( ''%s'' ); ', [TypeSalesReturn]);
  Script.Add := Format('  cbTemplType.Items.Add( ''%s'' ); ', [TypeReceiveItem]);
  Script.Add := Format('  cbTemplType.Items.Add( ''%s'' ); ', [TypePurchaseOrder]);
  Script.Add := Format('  cbTemplType.Items.Add( ''%s'' ); ', [TypePurchaseReturn]);
  Script.Add := Format('  cbTemplType.Items.Add( ''%s'' ); ', [TypeItemTransfer]);
  Script.Add := Format('  cbTemplType.Items.Add( ''%s'' ); ', [TypeItemAdjustment]);
  Script.Add := 'end;';
end;

procedure TRunningNumberbyFormInjector.SettingFormatTemplate;
begin
  CreateListView;
  CreateLabel;
  CreateComboBox;
  CreateEditBox;
  LeftPos;
  GetTemplateTypeIndex;
  AddFunction_CreateSQL;
  add_procedure_runsql;
  FillTemplateType;

  Script.Add := 'var frmTemplate        : TForm; ';
  Script.Add := '    listNumberTemplate : TListView; ';
  Script.Add := '    btnOKTemplate      : TButton; ';
  Script.Add := '    btnCancelTemplate  : TButton; ';
  Script.Add := '    btnEditTemplate    : TButton; ';
  Script.Add := '    btnNewTemplate     : TButton; ';
  Script.Add := '    ATxTemplate        : TIBTransaction; ';
  Script.Add := '';
  Script.Add := 'procedure DecorateGridTemplate; ';
  Script.Add := 'var Col : TListColumn; ';
  Script.Add := 'begin ';
  Script.Add := '  CreateListViewCol( listNumberTemplate, '''', 0 ); ';
  Script.Add := '  CreateListViewCol( listNumberTemplate, '''', 0 ); '; //for extendedid
  Script.Add := '  Col := CreateListViewCol( listNumberTemplate, ''Template Type'', (listNumberTemplate.Width -20) div 4  ); ';
  Script.Add := '  CreateListViewCol( listNumberTemplate, ''Nama Template'', Col.Width ); ';
  Script.Add := '  CreateListViewCol( listNumberTemplate, ''Kode Transaksi'', Col.Width ); ';
  Script.Add := '  CreateListViewCol( listNumberTemplate, ''No.'', Col.Width ); ';
  Script.Add := 'end; ';
  Script.Add := '';
  FillListNumberTemplate;
  Script.Add := 'procedure btnNewEditClickTemplate(Sender:TButton); ';
  Script.Add := 'var frmNew           : TForm; ';
  Script.Add := '    lbl              : TLabel; ';
  Script.Add := '    cbTemplType      : TComboBox; ';
  Script.Add := '    cbTemplName      : TComboBox; ';
  Script.Add := '    edtCode          : TEdit; ';
  Script.Add := '    btnOKNew         : TButton; ';
  Script.Add := '    cbTemplType_temp : String = ''''; ';
  Script.Add := '    cbTemplName_temp : String = ''''; ';
  Script.Add := '    edtCode_temp     : String = ''''; ';

  Script.Add := '  function InsertIntoExtendedDet:String; ';
  Script.Add := '  var extendeddet_id  : Integer; ';
  Script.Add := '      extendedtype_id : Integer; ';
  Script.Add := '      guid            : String; ';
  Script.Add := '      sql             : TjbSQL; ';

  Script.Add := '    function GetExtendedID:Integer; ';
  Script.Add := '    begin ';
  Script.Add := '      RunSQL( sql, ''Select ExtendedDetID from GetExtendedDetID''); ';
  Script.Add := '      result := sql.FieldByName(''ExtendedDetID''); ';
  Script.Add := '    end; ';
  Script.Add := '    ';
  Script.Add := '    function GetExtendedTypeID:Integer; ';
  Script.Add := '    begin ';
  Script.Add := '      RunSQL( sql, ''SELECT et.EXTENDEDTYPEID FROM EXTENDEDTYPE ET '+
                       'WHERE ET.EXTENDEDNAME = ''''Format No. Template'''' ''); ';

  Script.Add := '      if sql.Eof then begin';
//  Script.Add := '        RaiseException(''Please fix table name of "Format No. Template" according FR''); ';
  Script.Add := '        RaiseException(''Please make sure Extended Type named: "Format No. Template" exists.''); '; // AA, BZ 3126
  Script.Add := '      end;';
  Script.Add := '      result := sql.FieldByName(''ExtendedTypeID''); ';
  Script.Add := '    end; ';
  Script.Add := '';
  Script.Add := '  begin ';
  Script.Add := '    sql := CreateSQL(TIBTransaction(ATxTemplate)); ';
  Script.Add := '    try ';
  Script.Add := '      extendeddet_id  := GetExtendedID; ';
  Script.Add := '      extendedtype_id := GetExtendedTypeID; ';
  Script.Add := '    finally ';
  Script.Add := '      sql.Free; ';
  Script.Add := '    end; ';

  Script.Add := '    guid   := CreateClassID; ';
  Script.Add := '    result := Format(''Insert Into ExtendedDet (ExtendedDetID, ExtendedTypeID, %s, %s, %s, GUID) ''+ ';
  Script.Add := '                ''values( %d, %d, ''''%s'''', ''''%s'''', ''''%s'''', ''''%s'''')'', ';
  Script.Add := '                [TEMPLATE_TYPE, TEMPLATE_NAME, TEMPLATE_CODE, extendeddet_id, extendedtype_id, ';
  Script.Add := '                cbTemplType.Text, cbTemplName.Text, edtCode.Text, guid] ); ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  function UpdateExtendedDet:String; ';
  Script.Add := '  begin ';
  Script.Add := '    result := Format(''Update ExtendedDet ed set ed.%s = ''''%s'''', ed.%s = ''''%s'''', ed.%s = ''''%s'''' ''+ ';
  Script.Add := '      ''Where ed.ExtendedDetID = %s'', [ TEMPLATE_TYPE, cbTemplType.Text, TEMPLATE_NAME, cbTemplName.Text, TEMPLATE_CODE, ';
  Script.Add := '       edtCode.Text, DescSelected(listNumberTemplate) ]); ';
  Script.Add := '  end; ';
  Script.Add := ' ';
  Script.Add := '  procedure SetRNTemplate(Status:String); ';
  Script.Add := '  var sql      : TjbSQL; ';
  Script.Add := '      QuerySQL : String; ';
  Script.Add := '  begin ';
  Script.Add := '    sql := CreateSQL( TIBTransaction(ATxTemplate) );';
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
  Script.Add := '    if (cbTemplName.Text = '''') or (edtCode.Text = '''') or (cbTemplType.Text = '''') then begin ';
  Script.Add := '      result := False; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  var isFillTemplName : Boolean = True; ';
  Script.Add := '  ';
  Script.Add := '  procedure GetDataSelected; ';
  Script.Add := '  var sql : TjbSQL; ';
  Script.Add := '  begin ';
  Script.Add := '    sql := CreateSQL(TIBTransaction(ATxTemplate)); ';
  Script.Add := '    try ';
  Script.Add := '      RunSQL( sql, Format(''Select ed.%s, ed.%s, ed.%s From ExtendedDet ed where ed.ExtendedDetID = %s'', ';
  Script.Add := '      [ TEMPLATE_TYPE, TEMPLATE_NAME, TEMPLATE_CODE, DescSelected(listNumberTemplate)]) ); ';
  Script.Add := '      cbTemplType.ItemIndex := cbTemplType.Items.IndexOf( sql.FieldByName(TEMPLATE_TYPE) ); ';

  Script.Add := '      FillTemplateName; ';
  Script.Add := '      isFillTemplName := False; ';
  Script.Add := '      cbTemplName.ItemIndex := cbTemplName.Items.IndexOf( sql.FieldByName(TEMPLATE_NAME) ); ';
  Script.Add := '      edtCode.Text     := sql.FieldByName(TEMPLATE_CODE); ';
  Script.Add := '      cbTemplType_temp := cbTemplType.Text; ';
  Script.Add := '      cbTemplName_temp := cbTemplName.Text; ';
  Script.Add := '      edtCode_temp     := edtCode.Text; ';
  Script.Add := '    finally ';
  Script.Add := '      sql.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  procedure CheckValueNumber(Sender: TComponent); ';
  Script.Add := '    procedure CheckExistNumber(TemplType, TemplName: String); ';
  Script.Add := '    var sql : TjbSQL; ';
  Script.Add := '    begin ';
  Script.Add := '      sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '      try ';
  Script.Add := '        RunSQL( sql, Format(''Select 1 From ExtendedDet ed where ed.%s = ''''%s'''' and ed.%s = ''''%s'''' '', ';
  Script.Add := '          [TEMPLATE_TYPE, TemplType, TEMPLATE_NAME, TemplName] ) ); ';
  Script.Add := '        if not sql.Eof then begin';
  Script.Add := '          RaiseException (''This value already exist''); ';
  Script.Add := '        end;';
  Script.Add := '      finally ';
  Script.Add := '        sql.Free; ';
  Script.Add := '      end; ';
  Script.Add := '    end; ';
  Script.Add := '    ';
  Script.Add := '  begin ';
  Script.Add := '    if ((Sender = cbTemplType) or (Sender = cbTemplName)) then begin ';
  Script.Add := '      if ((cbTemplType_temp = cbTemplType.Text) and (cbTemplName_temp = cbTemplName.Text)) then Exit; ';
  Script.Add := '      CheckExistNumber( cbTemplType.Text, cbTemplName.Text ); ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  procedure FillTemplateName; ';
  Script.Add := '    var ';
  Script.Add := '      TextSQL : String;';
  Script.Add := '      SQL     : TjbSQL;';
  Script.Add := '  begin';
  Script.Add := '    cbTemplName.Items.Clear; ';
  Script.Add := '    SQL := TjbSQL.Create(TIBTransaction(Tx));';
  Script.Add := '    try';
  Script.Add := '      TextSQL := format(''SELECT NAME FROM TEMPLATE WHERE TEMPLATETYPE = %d ORDER BY TEMPLATEID'', [GetTemplateTypeIndex( cbTemplType.Text )]); ';
  Script.Add := '      RunSQL(SQL, TextSQL); ';
  Script.Add := '      while not SQL.eof do begin ';
  Script.Add := '        cbTemplName.Items.Add(SQL.FieldByName(''NAME''));';
  Script.Add := '      SQL.Next;';
  Script.Add := '      end;';
  Script.Add := '    finally';
  Script.Add := '      SQL.Free;';
  Script.Add := '    end;';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  procedure DoExitTemplType(sender: TComponent); ';
  Script.Add := '  begin ';
  Script.Add := '    if isFillTemplName then begin ';
  Script.Add := '      FillTemplateName; ';
  Script.Add := '    end; ';
  Script.Add := '    isFillTemplName := True; ';
  Script.Add := '    CheckValueNumber(sender); ';
  Script.Add := '  end; ';
  Script.Add := 'begin ';
  Script.Add := '  if Sender = btnEditTemplate then begin ';
  Script.Add := '    if CountSelected(listNumberTemplate) = 0 then begin';
  Script.Add := '      RaiseException(''Please choose your account that want to edit''); ';
  Script.Add := '    end;';
  Script.Add := '    if DescSelected(listNumberTemplate) = ''-1'' then begin';
  Script.Add := '      RaiseException(''There are no data that can be edited''); ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';

  Script.Add := '  frmNew := CreateForm( ''frmNew'', ''New'', 170, 230); ';
  Script.Add := '  try ';
  Script.Add := '    isFillTemplName := True; ';
  Script.Add := '    frmNew.BorderStyle := bsToolWindow; ';
  Script.Add := '    lbl         := CreateLabel( 10, 10, 80, 20, ''Template Type'', frmNew); ';
  Script.Add := '    cbTemplType := CreateComboBox( 10, lbl.Top + lbl.Height, 125, 25, csDropDownList, frmNew ); ';
  Script.Add := '    FillTemplateType (cbTemplType); ';
  Script.Add := '    lbl         := CreateLabel( cbTemplType.Left, cbTemplType.Top + cbTemplType.Height +5, 80, 20, ''Nama Template'', frmNew); ';
  Script.Add := '    cbTemplName := CreateComboBox( cbTemplType.Left, lbl.Top + lbl.Height, 125, 25, csDropDownList, frmNew); ';
  Script.Add := '    FillTemplateName; ';
  Script.Add := '    lbl      := CreateLabel( cbTemplType.Left, cbTemplName.Top + cbTemplName.Height +5, 80, 20, ''Kode Transaksi'', frmNew); ';
  Script.Add := '    edtCode  := CreateEdit( cbTemplType.Left, lbl.Top + lbl.Height, 125, 25, frmNew); ';
  Script.Add := '    btnOKNew := CreateBtn( cbTemplType.Left, edtCode.Top + edtCode.Height + 10, 80, 25, 0, ''&OK'', frmNew ); ';
  Script.Add := '    cbTemplType.OnExit := @DoExitTemplType; ';
  Script.Add := '    cbTemplName.OnExit := @CheckValueNumber; ';
  Script.Add := '    edtCode.OnExit     := @CheckValueNumber; ';
  Script.Add := '    btnOKNew.ModalResult := mrOK; ';
  Script.Add := '    cbTemplType_temp := ''-''; ';
  Script.Add := '    cbTemplName_temp := ''-''; ';
  Script.Add := '    edtCode_temp     := ''-''; ';
  Script.Add := '    if Sender = btnEditTemplate then begin ';
  Script.Add := '      GetDataSelected; ';
  Script.Add := '    end; ';
  Script.Add := '    if frmNew.ShowModal = mrOK then begin ';
  Script.Add := '      if not IsCompleteForInput then RaiseException(''Please fill all blank''); ';
  Script.Add := '      if Sender = btnNewTemplate then begin ';
  Script.Add := '        SetRNTemplate(''INSERT''); '; //RN = Running Number
  Script.Add := '      end ';
  Script.Add := '      else begin ';
  Script.Add := '        SetRNTemplate(''UPDATE''); ';
  Script.Add := '      end; ';
  Script.Add := '      FillListNumberTemplate; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    frmNew.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure DecorateFrmTemplate; ';
  Script.Add := 'begin ';
  Script.Add := '  frmTemplate.BorderStyle := bsToolWindow;';
  Script.Add := '  listNumberTemplate := CreateListView(  frmTemplate, 5, 5, frmTemplate.ClientWidth -10, frmTemplate.ClientHeight -50, False); ';
  Script.Add := '  listNumberTemplate.ViewStyle := vsReport; ';
  Script.Add := '  listNumberTemplate.RowSelect := True; ';
  Script.Add := '  DecorateGridTemplate; ';
  Script.Add := '  FillListNumberTemplate; ';
  Script.Add := '  btnOKTemplate := CreateBtn( (frmTemplate.ClientWidth - (70*4 + 100) ) div 2 , ';
  Script.Add := '    listNumberTemplate.Top + listNumberTemplate.Height + 10, 80, 25, 0, ''&OK'', frmTemplate); ';
  Script.Add := '  btnCancelTemplate := CreateBtn( LeftPos(btnOKTemplate, 20) , ';
  Script.Add := '    btnOKTemplate.Top , btnOKTemplate.Width, btnOKTemplate.Height, 0, ''&Cancel'', frmTemplate); ';
  Script.Add := '  btnNewTemplate := CreateBtn( LeftPos(btnCancelTemplate, 20) , ';
  Script.Add := '    btnOKTemplate.Top , btnOKTemplate.Width, btnOKTemplate.Height, 0, ''&New'', frmTemplate); ';
  Script.Add := '  btnEditTemplate  := CreateBtn( LeftPos(btnNewTemplate, 20), btnOKTemplate.Top, 80, 25, 0, ''&Edit'', frmTemplate ); ';
  Script.Add := '  btnOKTemplate.ModalResult := mrOK; ';
  Script.Add := '  btnCancelTemplate.ModalResult := mrCancel; ';
  Script.Add := '  btnNewTemplate.OnClick  := @btnNewEditClickTemplate; ';
  Script.Add := '  btnEditTemplate.OnClick := @btnNewEditClickTemplate; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure ShowSettingFormatTemplate; ';
  Script.Add := 'begin ';
  Script.Add := '  frmTemplate := CreateForm( ''frmTemplate'', ''Setting Format No. Template'', 450, 400); ';
  Script.Add := '  ATxTemplate := CreateATx; ';
  Script.Add := '  try ';
  Script.Add := '    DecorateFrmTemplate; ';
  Script.Add := '    if frmTemplate.ShowModal = mrOk then begin ';
  Script.Add := '      ATxTemplate.Commit; ';
  Script.Add := '    end ';
  Script.Add := '    else begin ';
  Script.Add := '      ATxTemplate.RollBack; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    frmTemplate.Free; ';
  Script.Add := '    ATxTemplate.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNumberbyFormInjector.GenerateScriptForMain;
begin
  ClearScript;
  InitializationVar;
  SettingFormatTemplate;
  CreateFormSetting;

  Script.Add := 'begin';
  Script.Add := '  AddCustomMenuSetting(''mnuSettingFormatTemplate'' '+
                   ', ''Setting Format No. Template'', ''ShowSettingFormatTemplate''); ';
  Script.Add := 'end.';
end;

procedure TRunningNumberbyFormInjector.GenerateScriptForRI;
const FORM_NAME = 'FNRECEIVEITEM';
begin
  ClearScript;
  AddFunction_IsFormExist(FORM_NAME);
  SetRunningNumberTemplate('APINV', 'SEQUENCENO');

  Script.Add := 'var';
  Script.Add := '  IsFirstRNPost : Boolean = True; ';

  Script.Add := EmptyStr;
  Script.Add := 'procedure SetFirstRNTemplate; ';
  Script.Add := 'begin ';
  Script.Add := '  if IsFirstRNPost then begin ';
  Script.Add := '    SetRNTemplate; ';
  Script.Add := '    IsFirstRNPost := False; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';

  Script.Add := EmptyStr;
  Script.Add := 'begin';
  Script.Add := '  PrepareRNFormEvent; ';
  Script.Add := '  Master.OnAfterScrollArray := @SetFirstRNTemplate; ';
  Script.Add := 'end.';
end;

procedure TRunningNumberbyFormInjector.ApplyRunningNumberInForm(form, table,
  fieldNo: string);
begin
  ClearScript;
  AddFunction_IsFormExist(form);
  SetRunningNumberTemplate(table, fieldNo);

  Script.Add := 'begin';
  Script.Add := '  SetRNTemplate;';
  Script.Add := '  PrepareRNFormEvent;';
  Script.Add := 'end.';
end;

procedure TRunningNumberbyFormInjector.GenerateScript;
begin
  inherited;

  ApplyRunningNumberInForm('FNSALESORDER', 'SO', 'SONO');
  InjectToDB(fnSalesOrder);

  ApplyRunningNumberInForm('FNARINVOICE', 'ARINV', 'INVOICENO');
  InjectToDB(fnARInvoice);

  ApplyRunningNumberInForm('FNARREFUND', 'ARREFUND', 'INVOICENO');
  InjectToDB(fnARRefund);

  ApplyRunningNumberInForm('FNPURCHASEORDER', 'PO', 'PONO');
  InjectToDB(fnPurchaseOrder);

  GenerateScriptForRI;
  InjectToDB(fnReceiveItem);

  ApplyRunningNumberInForm('FNDM', 'APRETURN', 'INVOICENO');
  InjectToDB(fnDM);

  ApplyRunningNumberInForm('FNINVADJUSTMENT', 'ITEMADJ', 'ADJNO');
  InjectToDB(fnInvAdjustment);

  ApplyRunningNumberInForm('FNTRANSFERFORM', 'WTRAN', 'TRANSFERNO');
  InjectToDB(fnTransferForm);

  GenerateScriptForMain;
  InjectToDB(fnMain);
end;

procedure TRunningNumberbyFormInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := 'Running Number by Form';
end;

end.
