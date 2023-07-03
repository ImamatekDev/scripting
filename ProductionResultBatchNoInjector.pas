unit ProductionResultBatchNoInjector;

interface
uses Injector, BankConst, SysUtils;

type
  TProductionResultBatchNoInjector = Class (TInjector)
  private
    procedure SetConst;
    procedure MainCreateMenuSetting;
//    Procedure GenerateForSOList; // MMD, BZ 3352 (Moved to OF Create DO/SI from List SO)
    procedure GenerateScriptForIADetDataset;
    procedure GenerateScriptForMain;
    procedure GenerateScriptForItemDataset;  //SCY BZ 2864
  public
    procedure GenerateScript; override;
  protected
    procedure set_scripting_parameterize; override;
  End;

implementation
uses ScriptConst;

{ TProductionResultBatchNoInjector }

procedure TProductionResultBatchNoInjector.SetConst;
begin
  ReadOption;
  Script.Add := 'const';
  Script.Add := '  TOKEN = '';''; ';
  Script.Add := 'var ';
  Script.Add := '  IA_NEXT_BATCH_FN        : String; ';
  Script.Add := '  ITEM_BATCH_NO_FIELD     : String; ';
  Script.Add := '  ITEM_EXPIRED_DATE_FIELD : String; ';
  Script.Add := '  IA_SCHEDULEID_FIELD     : String; ';
  Script.Add := '  IA_LOTNO_FIELD          : String;';
  Script.Add := '  MASA_EXPIRED            : String;';
  Script.Add := '  REQUIRED_BATCH_FIELD    : String;';
  Script.Add := '';
  Script.Add := 'procedure Initialize_Param; ';
  Script.Add := 'begin';
  Script.Add := '  IA_NEXT_BATCH_FN        := ReadOption(''IA_NEXT_BATCH_FN''       , ''CUSTOMFIELD1''); ';
  Script.Add := '  ITEM_BATCH_NO_FIELD     := ReadOption(''ITEM_BATCH_NO_FIELD''    , ''ItemReserved2'');';
  Script.Add := '  ITEM_EXPIRED_DATE_FIELD := ReadOption(''ITEM_EXPIRED_DATE_FIELD'', ''ItemReserved3'');';
  Script.Add := '  IA_SCHEDULEID_FIELD     := ReadOption(''IA_SCHEDULEID_FIELD''    , ''CUSTOMFIELD1'');';
  Script.Add := '  IA_LOTNO_FIELD          := ReadOption(''IA_LOTNO_FIELD''         , ''CUSTOMFIELD2'');';
  Script.Add := '  MASA_EXPIRED            := ReadOption(''MASA_EXPIRED''           , ''ItemReserved7'');';
  Script.Add := Format('  REQUIRED_BATCH_FIELD := ReadOption(''%s'', ''CUSTOMFIELD20''); ',[OPTIONS_PARAM_NAME_REQUIRED_BATCH_NO_FIELD ]);
  Script.Add := 'end; ';
  Script.Add := '';
end;
//
//procedure TProductionResultBatchNoInjector.GenerateForSOList;
//begin
//  ClearScript;
//  add_procedure_runsql;
//  AddFunction_CreateSQL;
//  Script.add := 'Var ';
//  Script.add := '  Com   : TComponent; ';
//  Script.add := '  MnuDO : TMenuItem; ';
//  Script.add := '  MnuSI : TMenuItem; ';
//  Script.add := ' ';
//  Script.add := 'Function HasRightToCreateDO: Boolean; ';
//  Script.add := 'Var Sql:TjbSQL; ';
//  Script.add := 'Begin ';
//  Script.add := '  Sql := CreateSQL(TIBTransaction(Tx)); ';
//  Script.add := '  Try ';
//  Script.add := '    RunSQL(Sql, Format(''SELECT DOC FROM Users WHERE UserID=%d'', [UserID])); ';
//  Script.add := '    Result := (Sql.FieldByName(''DOC'') = 1); ';
//  Script.add := '  Finally ';
//  Script.add := '    Sql.Free; ';
//  Script.add := '  End; ';
//  Script.add := 'End; ';
//  Script.add := ' ';
//  Script.add := 'Function HasRightToCreateSI: Boolean; ';
//  Script.add := 'Var Sql:TjbSQL; ';
//  Script.add := 'Begin ';
//  Script.add := '  Sql := CreateSQL(TIBTransaction(Tx)); ';
//  Script.add := '  Try ';
//  Script.add := '    RunSQL(Sql, Format(''SELECT SALESC FROM Users WHERE UserID=%d'', [UserID])); ';
//  Script.add := '    Result := (Sql.FieldByName(''SALESC'') = 1); ';
//  Script.add := '  Finally ';
//  Script.add := '    Sql.Free; ';
//  Script.add := '  End; ';
//  Script.add := 'End; ';
//  Script.add := ' ';
//  Script.add := 'Procedure MnuSIClick; ';
//  Script.add := 'Var frm : TFrmArinvoice; ';
//  Script.add := 'Begin ';
//  Script.add := '  If Datamodule.tabelSO.FieldByName(''SOID'').IsNull Then RaiseException(''Pilih SO dulu''); ';
//  Script.add := '  If Not HasRightToCreateSI Then RaiseException(''Anda tidak memiliki hak akses untuk membuat Sales Invoice''); ';
//  Script.add := ' ';
//  Script.add := '  frm := Create_arinvoice_form(TIBDatabase(DB), -1, false, UserID); ';
//  Script.add := '  frm.dmARinvoice.tblarinv.customerid.value  := DataModule.tabelSO.FieldByName(''ID'').value; ';
//  Script.add := '  frm.dmARInvoice.tblARInv.InvoiceDate.value := Date; ';
//  Script.add := '  frm.dmARInvoice.GetFromSO(DataModule.tabelSO.FieldByName(''SoNo'').value, true); ';
//  Script.add := '  frm.Show; ';
//  Script.add := 'End; ';
//  Script.add := ' ';
//  Script.add := 'Procedure MnuDOClick; ';
//  Script.add := 'Var frm : TFrmArinvoice; ';
//  Script.add := 'Begin ';
//  Script.add := '  If Datamodule.tabelSO.FieldByName(''SOID'').IsNull Then RaiseException(''Pilih SO dulu''); ';
//  Script.add := '  If Not HasRightToCreateDO Then RaiseException(''Anda tidak memiliki hak akses untuk membuat Delivery Order''); ';
//  Script.add := ' ';
//  Script.add := '  frm := Create_arinvoice_form(TIBDatabase(DB), -1, True, UserID); ';
//  Script.add := '  frm.dmARinvoice.tblarinv.customerid.value  := DataModule.tabelSO.FieldByName(''ID'').value; ';
//  Script.add := '  frm.dmARInvoice.tblARInv.InvoiceDate.value := Date; ';
//  Script.add := '  frm.dmARInvoice.GetFromSO(DataModule.tabelSO.FieldByName(''SoNo'').value, true); ';
//  Script.add := '  frm.Show; ';
//  Script.add := 'End; ';
//  Script.add := ' ';
//  Script.add := 'Begin ';
//  Script.add := '  Com := Form.APopupMenu.FindComponent(''CreateDO''); ';
//  Script.add := '  If Com <> Nil Then Com.Free; ';
//  Script.add := '  MnuDO         := TMenuItem.Create(Form.APopupMenu); ';
//  Script.add := '  MnuDO.Name    := ''CreateDO''; ';
//  Script.add := '  MnuDO.Caption := ''Create Delivery Order''; ';
//  Script.add := '  MnuDO.Visible := True; ';
//  Script.add := '  MnuDO.OnClick := @MnuDOClick; ';
//  Script.add := '  Form.APopupMenu.Items.Add(MnuDO); ';
//  Script.add := ' ';
//  Script.add := '  Com := Form.APopupMenu.FindComponent(''CreateSI''); ';
//  Script.add := '  If Com <> Nil Then Com.Free; ';
//  Script.add := '  MnuSI         := TMenuItem.Create(Form.APopupMenu); ';
//  Script.add := '  MnuSI.Name    := ''CreateSI''; ';
//  Script.add := '  MnuSI.Caption := ''Create Sales Invoice''; ';
//  Script.add := '  MnuSI.OnClick := @MnuSIClick; ';
//  Script.add := '  MnuSI.Visible := True; ';
//  Script.add := '  Form.APopupMenu.Items.Add(MnuSI); ';
//  Script.add := 'end. ';
//end;

procedure TProductionResultBatchNoInjector.GenerateScript;
begin
  GenerateScriptForMain;
  InjectToDB(fnMain);


//  GenerateForSOList;
//  InjectToDB(fnSalesOrders);

  GenerateScriptForIADetDataset; // AA, BZ 1981
  InjectToDB(dnIADet);

  GenerateScriptForItemDataset;
  InjectToDB(dnItem);
end;

procedure TProductionResultBatchNoInjector.GenerateScriptForIADetDataset;
begin
  ClearScript;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  SetConst;
  Script.Add := 'var ';
  Script.Add := '  sql     : TjbSQL; ';
  Script.Add := '  BatchNO : String;';
  Script.Add := '  Expired : TDateTime;';
  Script.Add := '';
  {Script.Add := 'function GetNextBatchNo:String;';
  Script.Add := '  var';
  Script.Add := '    counter_tx : TIBTransaction;';
  Script.Add := '    counter_sql : TjbSQL;';
  Script.Add := '';
  Script.Add := '  function ItemBNValue:TField;';
  Script.Add := '  begin';
  Script.Add := '    result := TItemDataset(Dataset.ItemNo.FieldLookup).ExtendedID.FieldLookup.FieldByName( IA_NEXT_BATCH_FN );';
  Script.Add := '  end;';
  Script.add := '';
  Script.Add := 'begin';
  Script.Add := '  counter_tx := CreateATx;';
  Script.Add := '  counter_sql := CreateSQL( counter_tx );';
  Script.Add := '  Try';
  Script.Add := '    if ItemBNValue.isNull or (ItemBNValue.asString='''') then begin';
  Script.Add := '      result := ''0001'';';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      result := IncCtlNumber(ItemBNValue.value); ';
  Script.Add := '    end;';
  Script.Add := '';
  Script.Add := '    RunSQL(counter_sql, format(''Update Extended set %s=''''%s'''' '+
                'where ExtendedID=(select i.ExtendedID from Item i where i.ItemNo=''''%s'''')'', '+
                '[IA_NEXT_BATCH_FN, result, Dataset.ItemNo.Value]));';
  Script.Add := '  Finally';
  Script.Add := '    counter_tx.commit;';
  Script.Add := '    counter_sql.Free;';
  Script.Add := '    counter_tx.Free;';
  Script.Add := '  End;';
  Script.Add := 'end;';
  Script.Add := ''; }
  Script.Add := 'function IsProduction:Boolean;';
  Script.Add := 'begin';
  Script.Add := '  result := false; ';
  Script.Add := '  RunSQL(sql, format(''Select coalesce(ia.Production, 0) production from ItemAdj ia '+
    'where ia.ItemAdjID=%d'', [Dataset.FieldByName(''ItemAdjID'').asInteger])); ';
  Script.Add := '  if sql.RecordCount=0 then exit; ';
  Script.Add := '  result := sql.FieldByName(''Production'') = 1; ';
  Script.Add := 'end;';
  Script.Add := '';
  {Script.Add := 'function schedule_shift_sql:String; ';
  Script.Add := 'begin';
  Script.Add := '  result := format(''select s.shift '+
                    'from ItemAdj ia '+
                    'join EXTENDED e on e.EXTENDEDID=ia.EXTENDEDID '+
                    'join SCHEDULE s on s.ID=e.%s '+
                    'where ia.ItemAdjID=%d'', [IA_SCHEDULEID_FIELD, Dataset.FieldByName(''ItemAdjID'').asInteger]);';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'function location_sql:String; ';
  Script.Add := 'begin';
  Script.Add := '  result := format(''select u.fullname '+
                    'from users u '+
                    'where u.userid=%d'', [Dataset.Userid]);';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'function get_batch_number:string; ';
  Script.Add := 'var';
  Script.Add := '  day, month, year : word;';
  Script.Add := '  location : string;';
  Script.Add := '  shift : integer;';
  Script.Add := 'begin';
  Script.Add := '  RunSQL( sql, schedule_shift_sql );';
  Script.Add := '  if ( sql.RecordCount=0 ) then begin ';
  Script.Add := '    result := '''';';
  Script.Add := '  end ';
  Script.Add := '  else begin ';
  Script.Add := '    shift := sql.fieldByName(''shift'');';
  Script.Add := '    RunSQL( sql, location_sql );';
  Script.Add := '    location := sql.fieldByName(''fullname'');';
  Script.Add := '    decodeDate( Date, year, month, day );';
  Script.Add := '    result := Format( ''%s%d%s%s%d'', [location, day, chr(64+month), copy(inttostr(year),3,2), shift]);';
  Script.Add := '    result := result + GetNextBatchNo;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure DoFillBatchNo; ';
  Script.Add := 'begin';
  Script.Add := '  sql := CreateSQL( TIBTransaction( Dataset.Tx ) );';
  Script.Add := '  Try';
  Script.Add := '    if ( ( Dataset.QtyDifference.Value <= 0 ) or ';
  Script.Add := '         ( Dataset.ItemNO.isNull ) or ';
  Script.Add := '         ( not isProduction ) ) then begin ';
  Script.Add := '      exit;';
  Script.Add := '    end;';
  Script.Add := '';
  Script.Add := '    Dataset.FieldByName( ITEM_BATCH_NO_FIELD ).value := get_batch_number;';
  Script.Add := '    Dataset.FieldByName( ITEM_EXPIRED_DATE_FIELD ).value := Date;';
  Script.Add := '  Finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  End;';
  Script.Add := 'end;';
  Script.Add := ''; }
  Script.Add := 'procedure get_batch_number; ';
  Script.Add := 'var SCHEDULEID, LOTNO : String;';
  Script.Add := '    day, month, year  : word; ';
  Script.Add := ' ';
  Script.Add := '  function str_note_production: String;';
  Script.Add := '  begin ';
  Script.Add := '    Result := format(''SELECT pr.SCHEDULE_ID, pr.LOTNO, pr.NOTES ''+ ';
  Script.Add := '                     ''FROM ITEMADJ ia ''+   ';
  Script.Add := '                     ''JOIN EXTENDED ex on ex.EXTENDEDID = ia.EXTENDEDID ''+ ';
  Script.Add := '                     ''JOIN SCHEDULE sc on sc.ID = ex.%s ''+ ';
  Script.Add := '                     ''JOIN PRODUCTION_RESULT pr on pr.SCHEDULE_ID = sc.ID AND pr.LOTNO = ex.%s ''+ ';
  Script.Add := '                     ''WHERE ia.ITEMADJID = %d '' + ';
  Script.Add := '                     ,[IA_SCHEDULEID_FIELD, IA_LOTNO_FIELD, Dataset.FieldByName(''ItemAdjID'').asInteger]); ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := '  function setExpireDate(StrDate: String):String;';
  Script.Add := '  var ddStr, mmStr, yyStr: String; ';
  Script.Add := '  begin ';
  Script.Add := '    ddStr  := GetToken(StrDate, ''/'', 1); ';
  Script.Add := '    mmStr  := GetToken(StrDate, ''/'', 2);';
  Script.Add := '    yyStr  := GetToken(StrDate, ''/'', 3);';
  Script.Add := '    Result := mmStr+''/''+ ddStr+''/''+yyStr;';
  Script.Add := '  end;';
  Script.Add := '  ';
  Script.Add := '  function ConvertDate(StrDate: String): TDateTime; ';
  Script.Add := '  begin ';
  Script.Add := '    try ';
  Script.Add := '      Result := StrToDate(setExpireDate(StrDate));';
  Script.Add := '    except';
  Script.Add := '      Result := StrToDate(StrDate); ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';

  Script.Add := ' ';
  Script.Add := '  procedure validate_bn(bn: String); ';
  Script.Add := '  var StrDate : String;';
  Script.Add := '  begin ';
  Script.Add := '    if (bn = '''') then ';
  Script.Add := '      RaiseException(''Mohon isi Note di Production Result '+
                       'dengan format #DD/MM/YYYY#BatchNumber pada Schedule ''+SCHEDULEID+'' dan Lot No ''+LOTNO);  ';

  Script.Add := '    if ((GetToken(bn, ''#'', 2)) = '''') then ';
  Script.Add := '      RaiseException(''Mohon isi Expired Date dikolom Note di Production Result '+
                       'dengan format #DD/MM/YYYY#BatchNumber pada Schedule ''+SCHEDULEID+'' dan Lot No ''+LOTNO) ';
  Script.Add := '    else begin ';
  Script.Add := '      StrDate := GetToken(bn, ''#'', 2);';
//  Script.Add := '      Expired := ConvertDate(StrDate); ';
//  Script.Add := '      decodeDate( Expired, year, month, day );';
//  //Script.Add := '      //Karena format DD/MM/YYYY jadi month = hari dan day = bulan';
//  Script.Add := '      month := month + Dataset.FieldByName(MASA_EXPIRED).AsInteger; ';
//  Script.Add := '      if month > 12 then begin ';
//  Script.Add := '        month := month - 12; ';
//  Script.Add := '        Year  := Year + 1;';
//  Script.Add := '      end; ';
//  Script.Add := '      Expired := EncodeDate(Year, Month, day); ';

  Script.Add := '      if Dataset.FieldByName(MASA_EXPIRED).AsString = '''' then begin';  //SCY BZ 2863
  Script.Add := '        Dataset.FieldByName(MASA_EXPIRED).AsString := ''0'';';
  Script.Add := '      end;';

  Script.Add := '      Expired := IncMonth(convertDate(StrDate), Dataset.FieldByName(MASA_EXPIRED).AsInteger);'; // AA, BZ 2809
  Script.Add := '    end;';
  Script.Add := '    if (GetToken(bn, ''#'', 3) = '''') then ';
  Script.Add := '      RaiseException(''Mohon isi Batch Number dikolom Note di Production Result '+
                       'dengan format #DD/MM/YYYY#BatchNumber pada Schedule ''+SCHEDULEID+'' dan Lot No ''+LOTNO) ';
  Script.Add := '    else begin ';
  Script.Add := '      BatchNO := GetToken(bn, ''#'', 3); ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := ' ';
  Script.Add := 'begin';
  Script.Add := '  RunSQL( sql, str_note_production ); ';
  Script.Add := '  if not (sql.Eof) then begin ';
  Script.Add := '    SCHEDULEID := sql.FieldByName(''SCHEDULE_ID''); ';
  Script.Add := '    LOTNO      := sql.FieldByName(''LOTNO'');  ';
  Script.Add := '    validate_bn(sql.FieldByName(''NOTES'')); ';
  Script.Add := ' end; ';
  Script.Add := 'end; ';
  Script.Add := ' ';
  Script.Add := 'function hasSchedule: Boolean;';
  Script.Add := 'var sql : TjbSQL; ';
  Script.Add := 'begin ';
  Script.Add := '  result := false;';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '  try';
  Script.Add := '    RunSQL( sql, format(''SELECT coalesce(sc.ID, 0) as ID ''+ ';
  Script.Add := '                     ''FROM ITEMADJ ia ''+   ';
  Script.Add := '                     ''JOIN EXTENDED ex on ex.EXTENDEDID = ia.EXTENDEDID ''+ ';
  Script.Add := '                     ''JOIN SCHEDULE sc on sc.ID = ex.%s ''+ ';
  Script.Add := '                     ''WHERE ia.ITEMADJID = %d '' + ';
  Script.Add := '                     ,[IA_SCHEDULEID_FIELD, Dataset.FieldByName(''ItemAdjID'').asInteger])); ';
  Script.Add := '    if sql.EOF then exit;';
  Script.Add := '    result := sql.FieldByName(''ID'') <> 0;';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  end;';
  Script.Add := 'end; ';

  Script.Add := 'procedure DoFillBatchNo; ';
  Script.Add := '  function isRequiredBatchNo:Boolean; '; //JR, BZ 2688
  Script.Add := '  var sqlReqBN : TjbSQL; ';
  Script.Add := '  begin ';
  Script.Add := '    sqlReqBN := createSQL(TIBTransaction(Tx)); ';
  Script.Add := '    try ';
  Script.Add := '      RunSQL( sqlReqBN, Format(''Select 1 from Item i left join Extended e on '+
                         'e.ExtendedID=i.ExtendedID where e.%s=1 and '+
                         'i.ItemNo=''''%s'''' '',[REQUIRED_BATCH_FIELD, Dataset.ItemNo.AsString]) ); ';
  Script.Add := '      result := NOT sqlReqBN.Eof; ';
  Script.Add := '    finally ';
  Script.Add := '      sqlReqBN.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := 'begin ';
  Script.Add := '  sql := CreateSQL( TIBTransaction( Dataset.Tx ) ); ';
  Script.Add := '  Try ';
  Script.Add := '    if ( ( Dataset.QtyDifference.Value <= 0 ) or ';
  Script.Add := '         ( Dataset.ItemNO.isNull ) or';
  Script.Add := '         ( not isProduction ) or';
  Script.Add := '         ( not hasSchedule) ) then ';
  Script.Add := '    begin ';
  Script.Add := '      exit; ';
  Script.Add := '    end; ';
  Script.Add := '    if isRequiredBatchNo then begin ';
  Script.Add := '      get_batch_number; ';
  Script.Add := '      Dataset.FieldByName( ITEM_BATCH_NO_FIELD ).value := BatchNO;';
  Script.Add := '      Dataset.FieldByName( ITEM_EXPIRED_DATE_FIELD ).AsString :=  FormatDateTime(''MM/DD/YYYY'',Expired);';
  Script.Add := '    end; ';
  Script.Add := '  Finally ';
  Script.Add := '    sql.Free;';
  Script.Add := '  End;';
  Script.Add := 'end;';
  Script.Add := 'begin';
  Script.Add := '  Initialize_Param; ';
  Script.Add := '  Dataset.OnBeforePostValidationArray := @DoFillBatchNo;'; // AA, BZ 1981
  Script.Add := 'end.';
end;

procedure TProductionResultBatchNoInjector.GenerateScriptForItemDataset;
begin
  ClearScript;
  SetConst;
  DatasetExtended;

  Script.Add := '';
  Script.Add := 'procedure ValidateMasaExpired;';
  Script.Add := 'var';
  Script.Add := '  MasaExpiredItemField : String;';
  Script.Add := 'begin';
  Script.Add := '  if DatasetExtended(REQUIRED_BATCH_FIELD).AsBoolean then begin';
  Script.Add := '    MasaExpiredItemField := Copy (MASA_EXPIRED, 5, (Length (MASA_EXPIRED) - 1) );';
  Script.Add := '    if (Dataset.FieldByName(MasaExpiredItemField).AsString = '''') then begin';
  Script.Add := '      RaiseException (''Masa Expired belum diisi'');';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  Initialize_Param;';
  Script.Add := '  Dataset.OnBeforePostValidationArray := @ValidateMasaExpired;';
  Script.Add := 'end.';
end;

procedure TProductionResultBatchNoInjector.GenerateScriptForMain;
begin
  ClearScript;
  MainCreateMenuSetting;
  Script.Add := 'begin';
  Script.Add := '  AddMenuSettingProductionResult; ';
  Script.Add := 'end.';
end;

procedure TProductionResultBatchNoInjector.MainCreateMenuSetting;
begin
  IsAdmin;
  CreateFormSetting;
  Script.Add := 'procedure ShowProductionResultSetting; ';
  Script.Add := 'var frmSetting : TForm; ';
  Script.Add := 'begin ';
  Script.Add := '  frmSetting := CreateFormSetting(''frmSetting'', ''Production Result Batch No Setting'', 400, 400);';
  Script.Add := '  try ';
  Script.Add := '    AddControl( frmSetting, ''Item-Next Batch No Field Name'', ''CUSTOMFIELD'' , ''IA_NEXT_BATCH_FN''   , ''CUSTOMFIELD1'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''IA-Schedule ID Field Name''    , ''CUSTOMFIELD'' , ''IA_SCHEDULEID_FIELD'', ''CUSTOMFIELD1'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''IA-Lot No. Field Name''        , ''CUSTOMFIELD'' , ''IA_LOTNO_FIELD''     , ''CUSTOMFIELD2'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Masa Expired''                 , ''ITEMRESERVED'', ''MASA_EXPIRED''       , ReadOption(''MASA_EXPIRED'',''ItemReserved7''), ''0'', '''');';
  Script.Add := '    if frmSetting.ShowModal = mrOK then begin ';
  Script.Add := '      SaveToOptions; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    frmSetting.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure AddMenuSettingProductionResult;';
  Script.Add := 'var mnuProductionResultSetting : TMenuItem; ';
  Script.Add := 'begin ';
  Script.Add := '  if not IsAdmin then exit; ';
  SCript.Add := '  AddCustomMenuSetting(''mnuProductionResultSetting'', ''Setting Production Result Batch No'', @ShowProductionResultSetting);';
  Script.Add := 'end; ';
  Script.Add := '';

end;

procedure TProductionResultBatchNoInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := 'Production Result Batch No';
end;

end.
