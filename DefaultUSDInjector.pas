unit DefaultUSDInjector;

interface
uses Injector, BankConst, Sysutils, ScriptConst;

type

  TDefaultUSDInjector = class(TInjector)
  private
    procedure GenerateForJVDet;
    procedure AddConst;
    procedure GenerateForAccountDataset;
    procedure GenerateForCOAs;
    procedure GenerateForFA;
    procedure GenerateForFAs;
    procedure DivideValue(tbl, Field: String);
    procedure GenerateForProjects;
    procedure GenerateForGLHist;
    procedure GenerateForIAs;
    procedure GenerateForJCs;
    procedure GenerateForGLBalance;
    procedure GenerateForGLBudget;
    procedure RepStr(tbl:String);
    procedure GenerateForJV;
    procedure GenerateForJVs;
//    procedure GenerateForBankBook;
    procedure GenerateForMain;
    procedure GenerateForSI;
    procedure OnDateChangeSetLookup1;
    procedure GetFiscalRate(FieldName:String);
    procedure GenerateForPI;
    procedure MainProcedure(FieldName: String; AdditionalProcedure:String);
    procedure GenerateForCR;
    procedure AddButtonSetBank(CtlRef, BankAccField:String);
    procedure PaymentCreateJV(DetailTbl, BankAccount, MasterInvTbl, InvoiceFieldName:String; invert:INteger);
    procedure GenerateForVP;
    procedure AddConstFiscalRate;
    procedure GenerateForDeletePayment;
    procedure GetJVID;
    procedure PaymentGetGainLossAccount;
    procedure GenerateForSR;
    procedure GetRateByCurrency;
    procedure OnSetCommercialRate(TblName, DateField, PersonFieldName:String; HasFiscalPayment:Boolean);
    procedure AddVariable;
    procedure GenerateForMemorizedReport;

    procedure GenerateScriptForPI;
  protected
    procedure AddJVDetMain; virtual;
    procedure AddJVDetFunctions; virtual;
    procedure set_scripting_parameterize; override;
  public
    procedure GenerateScript; override;
  end;

implementation

procedure TDefaultUSDInjector.AddConst;
begin
  ReadOption;

  Script.Add := 'Const STANDARDRATE    = StrToInt( ReadOption(''STANDARDRATE'', ''1000'') ); ';
  Script.Add := '      DEFAULT_USD_JV  = ''CustomField1''; ';
  Script.Add := '      DEBIT_USD_JV    = ReadOption(''DEBIT_USD_JV'', ''CUSTOMFIELD2''); ';
  Script.Add := '      CREDIT_USD_JV   = ReadOption(''CREDIT_USD_JV '', ''CUSTOMFIELD3''); ';
  Script.Add := '      ORI_RATE_JV     = ReadOption(''ORI_RATE_JV'', ''LOOKUP1''); ';
  Script.Add := '      ORI_AMOUNT_JV   = ReadOption(''ORI_AMOUNT_JV'', ''CUSTOMFIELD4''); ';
  Script.Add := '      INPUT_AMOUNT_JV   = ReadOption(''INPUT_AMOUNT_JV'', ''CUSTOMFIELD5''); ';
  Script.Add := '      FLAG_MANUAL_JV  = ReadOption(''FLAG_MANUAL_JV'', ''CUSTOMFIELD20''); ';
  Script.Add := '      FieldLookupName = ''Lookup1''; ';
  Script.Add := '      FieldRateUSD    = ''Info2''; ';
  Script.Add := '      FieldRateJYP    = ''Info3''; ';
  Script.Add := '      VALUE_USD_FA    = ReadOption(''VALUE_USD_FA'', ''CUSTOMFIELD1''); ';
  Script.Add := '      ORI_RATE_FA     = ReadOption(''ORI_RATE_FA'', ''CUSTOMFIELD4''); ';
  Script.Add := '      ORI_AMOUNT_FA   = ReadOption(''ORI_AMOUNT_FA'', ''CUSTOMFIELD5''); ';
  Script.Add := EmptyStr;
end;

procedure TDefaultUSDInjector.AddJVDetMain;
begin
//  Script.Add := '  IsSettingCustomField := false; ';
  Script.Add := '  if (UpperCase(Dataset.ClassName) <> ''TJVDETDATASET'') then exit;';
  Script.Add := '  Dataset.OnNewRecordArray       := @AssignExtendedOnChange; ';
  Script.Add := '  Dataset.OnBeforeEditArray      := @AssignExtendedOnChange; ';
  Script.Add := '  Dataset.GLAmount.OnChangeArray := @GLAmountChange; ';
end;

procedure TDefaultUSDInjector.AddJVDetFunctions;
begin
//  Script.Add := 'var IsSettingCustomField:Boolean;';
//  Script.Add := EmptyStr;
//  Script.Add := 'function IsTransTypeJV: Boolean; ';
//  Script.Add := '  var transTypeJV : String; ';
//  Script.Add := 'begin ';
//  Script.Add := '  transTypeJV := ReadOption( format( ''TYPE_JV|%s|%s'', [ IntToStr(UserID), Dataset.FieldByName(''JVID'').AsString ] ) ); ';
//  Script.Add := '  result := (transTypeJV = ''1''); ';
//  Script.Add := 'end; ';
//  Script.Add := EmptyStr;
//  Script.Add := 'procedure CustomField1Change;';
//  Script.Add := 'begin';
////  Script.Add := '  Dataset.GLAmount.value := STANDARDRATE * TExtendedDataset(Dataset.ExtendedID.FieldLookup).CustomField1.asCurrency; ';
//  Script.Add := '  Dataset.GLAmount.value := STANDARDRATE * StrTofloat(TExtendedDataset(Dataset.ExtendedID.FieldLookup).CustomField1.AsString);'; // AA, BZ 2460
//  Script.Add := 'end;';
//  Script.Add := EmptyStr;
//  Script.Add := 'procedure AssignExtendedOnChange; ';
//  Script.Add := 'begin ';
//  Script.Add := '  if IsTransTypeJV then Exit; ';
//  Script.Add := '  IsSettingCustomField := true;';
//  Script.Add := '  try';
//  Script.Add := '    TExtendedDataset(Dataset.ExtendedID.FieldLookup).CustomField1.OnChangeArray := @CustomField1Change; ';
//  Script.Add := '  finally';
//  Script.Add := '    IsSettingCustomField := false;';
//  Script.Add := '  end;';
//  Script.Add := 'end; ';
//  Script.Add := EmptyStr;
//  Script.Add := 'procedure GLAmountChange; ';
//  Script.Add := 'begin';
//  Script.Add := '  if IsTransTypeJV then Exit; ';
//  Script.Add := '  if not IsSettingCustomField then begin';
////  Script.Add := '    TExtendedDataset(Dataset.ExtendedID.FieldLookup).CustomField1.asCurrency := Dataset.GLAmount.value / STANDARDRATE; ';
//  Script.Add := '    TExtendedDataset(Dataset.ExtendedID.FieldLookup).CustomField1.asString := FloatToStr((strToFloat(Dataset.GLAmount.AsString) / STANDARDRATE));'; // AA, BZ 2460
//  Script.Add := '  end; ';
//  Script.Add := 'end;';
//  Script.Add := EmptyStr;
  Script.Add := 'var isAlreadyAssignExtendedOnChange : Boolean = False;';
  Script.Add := 'var isChangeBySystem : Boolean = False;';
  Script.Add := EmptyStr;
  Script.Add := 'function IsTransTypeJV: Boolean; ';
  Script.Add := '  var transTypeJV : String; ';
  Script.Add := 'begin ';
  Script.Add := '  transTypeJV := ReadOption( format( ''TYPE_JV|%s|%s'', [ IntToStr(UserID), Dataset.FieldByName(''JVID'').AsString ] ) ); ';
  Script.Add := '  result := (transTypeJV = ''1''); ';
  Script.Add := 'end; ';
  Script.Add := EmptyStr;
  Script.Add := 'procedure CustomField1Change;';
  Script.Add := 'begin';
  Script.Add := '  if ( Not isChangeBySystem ) then begin';
  Script.Add := '    isChangeBySystem := True;';
  Script.Add := '    Dataset.GLAmount.value := STANDARDRATE * StrTofloat(TExtendedDataset(Dataset.ExtendedID.FieldLookup).CustomField1.AsString);';
  Script.Add := '    isChangeBySystem := False;';
  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  Script.Add := 'procedure AssignExtendedOnChange; ';
  Script.Add := 'begin ';
  Script.Add := '  if IsTransTypeJV then Exit; ';
  Script.Add := '  if ( Not isAlreadyAssignExtendedOnChange ) then begin';
  Script.Add := '    TExtendedDataset(Dataset.ExtendedID.FieldLookup).CustomField1.OnChangeArray := @CustomField1Change; ';
  Script.Add := '    isAlreadyAssignExtendedOnChange := True;';
  Script.Add := '   end;';
  Script.Add := 'end; ';
  Script.Add := EmptyStr;
  Script.Add := 'procedure GLAmountChange; ';
  Script.Add := 'begin';
  Script.Add := '  if IsTransTypeJV then Exit; ';
  Script.Add := '  if ( Not isChangeBySystem ) then begin';
  Script.Add := '    isChangeBySystem := True;';
  Script.Add := '    TExtendedDataset(Dataset.ExtendedID.FieldLookup).CustomField1.asString := FloatToStr((strToFloat(Dataset.GLAmount.AsString) / STANDARDRATE));';
  Script.Add := '    isChangeBySystem := False;';
  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
end;

procedure TDefaultUSDInjector.GenerateForJV;
begin
  ClearScript;
  AddConst;
  WriteOption;

  Script.Add := 'function IsTransTypeJV: Boolean; ';
  Script.Add := 'begin ';
  //Script.Add := '  result := ( TjbStringField(Master.TransType).AsString = ''JV'' ); ';
  Script.Add := '  result := (Master.ExtendedID.FieldLookup.FieldByName(FLAG_MANUAL_JV).AsString = ''1''); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure SetVisibleColumn; ';
  Script.Add := '  var idx : Integer = 0; ';
  Script.Add := 'begin ';
  Script.Add := '  if IsTransTypeJV then begin ';
  Script.Add := '    for idx := 0 to Form.DBGrid1.Columns.Count -1 do begin ';
  Script.Add := '      if ( Uppercase( Trim( Form.DBGrid1.Columns[idx].FieldName ) ) = ''DEBIT'' ) or ';
  Script.Add := '         ( Uppercase( Trim( Form.DBGrid1.Columns[idx].FieldName ) ) = ''CREDIT'' ) or ';
  Script.Add := '         ( Uppercase( Trim( Form.DBGrid1.Columns[idx].FieldName ) ) = ''RATE'' ) or ';
  Script.Add := '         ( Uppercase( Trim( Form.DBGrid1.Columns[idx].FieldName ) ) = ''PRIMEAMOUNT'' ) ';
  Script.Add := '      then begin ';
  Script.Add := '        Form.DBGrid1.Columns[idx].Visible := False; ';
  Script.Add := '      end; ';
  Script.Add := '    end; ';
  Script.Add := '  end else begin ';
  Script.Add := '    for idx := 0 to Form.DBGrid1.Columns.Count -1 do begin ';
  Script.Add := '      if ( Uppercase( Trim( Form.DBGrid1.Columns[idx].FieldName ) ) = Uppercase( ''JVDET'' + DEBIT_USD_JV ) ) or ';
  Script.Add := '         ( Uppercase( Trim( Form.DBGrid1.Columns[idx].FieldName ) ) = Uppercase( ''JVDET'' + CREDIT_USD_JV ) ) or ';
  Script.Add := '         ( Uppercase( Trim( Form.DBGrid1.Columns[idx].FieldName ) ) = Uppercase( ''JVDET'' + ORI_RATE_JV ) ) or ';
  Script.Add := '         ( Uppercase( Trim( Form.DBGrid1.Columns[idx].FieldName ) ) = Uppercase( ''JVDET'' + ORI_AMOUNT_JV ) ) ';
  Script.Add := '      then begin ';
  Script.Add := '        Form.DBGrid1.Columns[idx].Visible := False; ';
  Script.Add := '      end; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure SetReadOnlyColumn; ';
  Script.Add := '  var idx : Integer = 0; ';
  Script.Add := 'begin ';
  Script.Add := '  if not IsTransTypeJV then Exit; ';
  Script.Add := '  for idx := 0 to Form.DBGrid1.Columns.Count -1 do begin ';
  Script.Add := '    if ( Uppercase( Trim( Form.DBGrid1.Columns[idx].FieldName ) ) = Uppercase( ''JVDET'' + DEFAULT_USD_JV ) ) or ';
  Script.Add := '       ( Uppercase( Trim( Form.DBGrid1.Columns[idx].FieldName ) ) = Uppercase( ''JVDET'' + DEBIT_USD_JV ) ) or ';
  Script.Add := '       ( Uppercase( Trim( Form.DBGrid1.Columns[idx].FieldName ) ) = Uppercase( ''JVDET'' + CREDIT_USD_JV ) ) ';
  Script.Add := '    then begin ';
  Script.Add := '      Form.DBGrid1.Columns[idx].ReadOnly := True; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'var timer  : TTimer; ';
  Script.Add := '';
  Script.Add := 'procedure DestroyTimer; ';
  Script.Add := 'begin';
  Script.Add := '  if timer <> nil then begin ';
  Script.Add := '    timer.Free; ';
  Script.Add := '    timer := nil; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure CreateTimer; ';
  Script.Add := '  var second : Integer = 0; ';
  Script.Add := '  ';
  Script.Add := '  procedure ProcessHideColumn; ';
  Script.Add := '  begin ';
  Script.Add := '    SetVisibleColumn; ';
  Script.Add := '    DestroyTimer; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := 'begin ';
  Script.Add := '  DestroyTimer; ';
  Script.Add := '  timer := TTimer.Create( nil ); ';
  Script.Add := '  timer.Interval := 1; ';
  Script.Add := '  timer.OnTimer  := @ProcessHideColumn; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure WriteOptionTypeJV; ';
  Script.Add := '  function IsExistJV: Boolean; ';
  Script.Add := '    var sqlJV    : TjbSQL; ';
  Script.Add := '        txtSQLJV : String; ';
  Script.Add := '  begin';
  Script.Add := '    result   := False; ';
  Script.Add := '    sqlJV    := CreateSQL( TIBTransaction(Tx) ); ';
  Script.Add := '    txtSQLJV := Format( ''select 1 from jv where jvid = %d '', [ Master.FieldByName(''JVID'').AsInteger ] ); ';
  Script.Add := '    try ';
  Script.Add := '      RunSQL(sqlJV, txtSQLJV); ';
  Script.Add := '      if not sqlJV.EOF then result := True; ';
  Script.Add := '    finally ';
  Script.Add := '      sqlJV.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := 'begin';
  Script.Add := '  if IsExistJV then Exit; ';
  Script.Add := '  WriteOption( format( ''TYPE_JV|%s|%s'', [ IntToStr(UserID), Master.FieldByName(''JVID'').AsString ] ), ''1'' ); ';
  Script.Add := '  Master.ExtendedID.FieldLookup.FieldByName(FLAG_MANUAL_JV).AsString := ''1''; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure CheckOriRate; ';
  Script.Add := 'begin';
  Script.Add := '  if not IsTransTypeJV then Exit; ';
  Script.Add := '  if Detail.ExtendedID.FieldLookup.FieldByName(ORI_RATE_JV).IsNull then RaiseException(''Please fill original rate field''); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure RecalcDetailJV;';
  Script.Add := '  var oriRate     : Currency = 0; ';
  Script.Add := '      oriAmount   : Currency = 0; ';
  Script.Add := '      defaultRate : Currency = 0; ';
  Script.Add := '  ';
  Script.Add := '  function IsDebet: Boolean; ';
  Script.Add := '  begin ';
  Script.Add := '    result := ( Detail.GLAmount.AsCurrency > 0 ); ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  function GetOriRate: Currency; ';
  Script.Add := '    var sqlExt       : TjbSQL; ';
  Script.Add := '        txtSQLExt    : String; ';
  Script.Add := '  begin ';
  Script.Add := '    result       := 0; ';
  Script.Add := '    if Detail.ExtendedID.FieldLookup.FieldByName(ORI_RATE_JV).IsNull then Exit; ';
  Script.Add := '    sqlExt    := CreateSQL( TIBTransaction(Tx) ); ';
  Script.Add := '    txtSQLExt := format( ''SELECT %s RATEUSD '' + ';
  Script.Add := '                         ''  FROM EXTENDEDDET '' + ';
  Script.Add := '                         '' WHERE EXTENDEDDETID = %d '', [ FieldRateUSD, Detail.ExtendedID.FieldLookup.FieldByName(ORI_RATE_JV).AsInteger ] ); ';
  Script.Add := '    try ';
  Script.Add := '      RunSQL( sqlExt, txtSQLExt ); ';
  Script.Add := '      if not sqlExt.EOF then begin ';
  Script.Add := '        result := StrToFloat( sqlExt.FieldByName(''RATEUSD'') ); ';
  Script.Add := '      end; ';
  Script.Add := '    finally ';
  Script.Add := '      sqlExt.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  function GetDefaultRate: Currency; ';
  Script.Add := '  begin ';
  Script.Add := '    if oriRate = 0 then begin ';
  Script.Add := '      result := 0; ';
  Script.Add := '    end else begin ';
//  Script.Add := '      result := ( STANDARDRATE / oriRate ); ';
//  Script.Add := '      result := trunc(( STANDARDRATE / oriRate ) * 10000)/10000;'; // AA, BZ 2460, trunc to 4 decimal
  Script.Add := '      result := round(( STANDARDRATE / oriRate ) * 10000)/10000;'; // AA, BZ 2460, round to 4 decimal
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  procedure SetDefaultRate; ';
  Script.Add := '    var sqlAccnt    : TjbSQL; ';
  Script.Add := '        txtSQLAccnt : String; ';
  Script.Add := '  begin';
  Script.Add := '    Detail.Rate.AsCurrency := 1; ';
  Script.Add := '    if defaultRate = 0 then Exit; ';
  Script.Add := '    sqlAccnt    := CreateSQL( TIBTransaction(Tx) ); ';
  Script.Add := '    txtSQLAccnt := format( ''SELECT COALESCE(CURRENCYID, 1) CURRENCYID '' + ';
  Script.Add := '                           ''  FROM GLACCNT '' + ';
  Script.Add := '                           '' WHERE GLACCOUNT = ''''%s'''' '', [Detail.GLAccount.AsString] ); ';
  Script.Add := '    try ';
  Script.Add := '      RunSQL(sqlAccnt, txtSQLAccnt); ';
  Script.Add := '      if not sqlAccnt.EOF then begin ';
  Script.Add := '        if sqlAccnt.FieldByName(''CURRENCYID'') <> 1 then begin ';
  Script.Add := '          Detail.Rate.AsCurrency := defaultRate; ';
  Script.Add := '        end; ';
  Script.Add := '      end; ';
  Script.Add := '    finally ';
  Script.Add := '      sqlAccnt.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := 'begin';
  Script.Add := '  if not IsTransTypeJV then Exit; ';
  Script.Add := '  oriRate     := GetOriRate; ';
  Script.Add := '  oriAmount   := Detail.ExtendedID.FieldLookup.FieldByName(ORI_AMOUNT_JV).AsCurrency; ';
  Script.Add := '  defaultRate := GetDefaultRate; ';
  Script.Add := '  SetDefaultRate; ';
  Script.Add := '  Detail.GLAmount.AsCurrency := ( defaultRate * oriAmount ); ';
//  Script.Add := '  Detail.ExtendedID.FieldLookup.FieldByName(DEFAULT_USD_JV).AsCurrency := (Detail.GLAmount.AsCurrency / STANDARDRATE); ';
  Script.Add := '  Detail.ExtendedID.FieldLookup.FieldByName(DEFAULT_USD_JV).AsString := FloatToStr(StrToFloat(Detail.GLAmount.AsString) / STANDARDRATE);'; // AA, BZ 2460
  Script.Add := '  if IsDebet then begin ';
  Script.Add := '    Detail.ExtendedID.FieldLookup.FieldByName(DEBIT_USD_JV).AsCurrency  := ( Abs(Detail.GLAmount.AsCurrency) / STANDARDRATE ); ';
  Script.Add := '    Detail.ExtendedID.FieldLookup.FieldByName(CREDIT_USD_JV).AsCurrency := 0; ';
  Script.Add := '  end else begin ';
  Script.Add := '    Detail.ExtendedID.FieldLookup.FieldByName(DEBIT_USD_JV).AsCurrency  := 0; ';
  Script.Add := '    Detail.ExtendedID.FieldLookup.FieldByName(CREDIT_USD_JV).AsCurrency := ( Abs(Detail.GLAmount.AsCurrency) / STANDARDRATE ); ';
  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure SetupNewRecord; ';
  Script.Add := 'begin';
  Script.Add := '  WriteOptionTypeJV; ';
  Script.Add := '  CreateTimer; ';
  Script.Add := '  SetReadOnlyColumn; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'function GetAutoRecalcRate: String; ';
  Script.Add := '  var sqlExt    : TjbSQL; ';
  Script.Add := '      txtSQLExt : String; ';
  Script.Add := 'begin ';
  Script.Add := '  result    := ''''; ';
  Script.Add := '  sqlExt    := CreateSQL( TIBTransaction(Tx) ); ';
  Script.Add := '  txtSQLExt := Format( ''SELECT FIRST 1 ED.EXTENDEDDETID '' + ';
  Script.Add := '                       ''  FROM EXTENDEDTYPE ET, EXTENDEDDET ED '' + ';
  Script.Add := '                       '' WHERE UPPER(ET.EXTENDEDNAME) = UPPER(''''COMMERCIAL RATE'''') '' + ';
  Script.Add := '                       ''   AND ET.EXTENDEDTYPEID = ED.EXTENDEDTYPEID '' + ';
  Script.Add := '                       ''   AND ED.%s = ''''1'''' '', [FieldRateUSD] ); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sqlExt, txtSQLExt); ';
  Script.Add := '    if not sqlExt.EOF then result := sqlExt.FieldByName(''EXTENDEDDETID''); ';
  Script.Add := '  finally ';
  Script.Add := '    sqlExt.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'Var';
  Script.Add := '  doingAutoRecalc : boolean = false;';
  Script.Add := '';
  Script.Add := 'procedure FillAutoRecalc; ';
  Script.Add := '  var sqlJV    : TjbSQL; ';
  Script.Add := '      txtSQLJV : String; ';
  Script.Add := '      oriRate  : String; ';
  Script.Add := 'begin ';
  Script.Add := '  if Detail.GLAccount.IsNull then Exit; ';
  Script.Add := '  if Detail.RecordCount = 0 then Exit; ';
  Script.Add := '  if Detail.GLAmount.AsCurrency <> 0 then Exit; ';
  Script.Add := '  oriRate  := GetAutoRecalcRate; ';
  Script.Add := '  if oriRate = '''' then Exit; ';
  Script.Add := '  sqlJV    := CreateSQL( TIBTransaction(Detail.Tx) ); ';
  Script.Add := '  txtSQLJV := Format( ''SELECT ( COALESCE(SUM(GLAMOUNT), 0) * -1 ) GLAMOUNT '' + ';
  Script.Add := '                      ''  FROM JVDET '' + ';
  Script.Add := '                      '' WHERE JVID = %d '', [ Master.FieldByName(''JVID'').AsInteger ] ); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sqlJV, txtSQLJV); ';
  Script.Add := '    if not sqlJV.EOF then begin ';
  Script.Add := '    doingAutoRecalc := True;';
  Script.Add := '      Detail.ExtendedID.FieldLookup.FieldByName(ORI_AMOUNT_JV).AsString := CurrToStrSQL( sqlJV.FieldByName(''GLAMOUNT'') / STANDARDRATE ); ';
  Script.Add := '      Detail.ExtendedID.FieldLookup.FieldByName(ORI_RATE_JV).AsString   := oriRate; ';
  Script.Add := '    doingAutoRecalc := False;';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    sqlJV.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure DoGLAccountChange; ';
  Script.Add := 'begin ';
  Script.Add := '  CreateTimer; ';
  Script.Add := '  FillAutoRecalc; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure updateInputAmount;';
  Script.Add := 'begin';
  Script.Add := '  if IsTransTypeJV And (Not doingAutoRecalc) then begin';
  Script.Add := '    TExtendedDetLookupField( Detail.ExtendedID.FieldLookup.FieldByName(INPUT_AMOUNT_JV) ).value := TExtendedDetLookupField( Detail.ExtendedID.FieldLookup.FieldByName(ORI_AMOUNT_JV) ).value;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure DoGLAccountEdited;';
  Script.Add := 'begin';
  Script.Add := '  if Detail.GLAccount.IsNull then Exit;';
  Script.Add := '  if Detail.RecordCount = 0 then Exit;';
  Script.Add := '  if Detail.GLAmount.AsCurrency <> 0 then begin';
  Script.Add := '    recalcDetailJV;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure setTolerance;';
  Script.Add := 'begin';
  Script.Add := '  TdmJV(dataModule).AmountDiffTolerance := StrSqlToCurr(ReadOption(''DIFFTOLERANCE'', ''0.0005''));'; // AA, BZ 2797
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure setTotalOfJV;';
  Script.Add := 'begin';
  Script.Add := '  form.AlblTotals.caption := format(''%s: %s   %s: %s'', ';
  Script.Add := '                 [form.debitCaption, formatCurr(''#,##0.##'', (dataModule.ATotalDebits/STANDARDRATE)),';
  Script.Add := '                  form.creditCaption, formatCurr(''#,##0.##'', (-dataModule.ATotalCredits/STANDARDRATE))]);';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure setTotalDebitCredit;';
  Script.Add := 'var sqlJV    : TjbSQL; ';
  Script.Add := '    txtSQLJV : String; ';
  Script.Add := '    amount : extended;';
  Script.Add := '    totalDebits : extended;';
  Script.Add := '    totalCredits : extended;';
  Script.Add := 'begin';
  Script.Add := '  if not IsTransTypeJV then Exit; ';
  Script.Add := '  sqlJV := CreateSQL( TIBTransaction(master.Tx) ); ';
  Script.Add := '  try ';
  Script.Add := '    totalDebits := 0;';
  Script.Add := '    totalCredits := 0;';
  Script.Add := '    runSQL(sqlJv, format(''select coalesce(d.primeAmount,0) as primeAmount, coalesce(d.rate,0) as rate from JVDET d where d.JVID=%d'', [master.jvid.asInteger]));';
  Script.Add := '    while not sqlJV.eof do begin';
  Script.Add := '      amount := sqlJV.fieldByName(''primeAmount'') * sqlJV.fieldByName(''rate'');';
  Script.Add := '      if (amount>0) then begin';
  Script.Add := '        totalDebits := totalDebits + amount;';
  Script.Add := '      end';
  Script.Add := '      else begin';
//  Script.Add := '        totalCredits := totalCredits + Abs(amount);';
  Script.Add := '        totalCredits := totalCredits - Abs(amount);'; // AA, BZ 2858
  Script.Add := '      end;';
  Script.Add := '      sqlJV.next;';
  Script.Add := '    end;';
  Script.Add := '    dataModule.ATotalDebits := totalDebits;';
  Script.Add := '    dataModule.ATotalCredits := totalCredits;';
  Script.Add := '  finally ';
  Script.Add := '    sqlJV.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  CreateTimer; ';
  Script.Add := '  Master.OnNewRecordArray  := @SetupNewRecord; ';
  Script.Add := '  Master.OnAfterCloseArray := @DestroyTimer; ';
  //Script.Add := '  Detail.GLAccount.OnValidateArray   := @CheckOriRate; ';
  Script.Add := '  Detail.OnBeforePostValidationArray := @CheckOriRate; ';
  Script.Add := '  Detail.GLAccount.OnValidateArray   := @DoGLAccountChange; ';
  Script.Add := '  Detail.GLAmount.OnValidateArray    := @CreateTimer; ';
  Script.Add := '  Detail.Rate.OnValidateArray        := @CreateTimer; ';
  Script.Add := '  Detail.PrimeAmount.OnValidateArray := @CreateTimer; ';
  Script.Add := '  Detail.GLAccount.OnChangeArray := @DoGLAccountEdited;'; // AA, BZ 2786
  Script.Add := '  TExtendedDetLookupField( Detail.ExtendedID.FieldLookup.FieldByName(DEFAULT_USD_JV) ).OnChangeArray := @RecalcDetailJV; ';
  Script.Add := '  TExtendedDetLookupField( Detail.ExtendedID.FieldLookup.FieldByName(ORI_RATE_JV) ).OnChangeArray    := @RecalcDetailJV; ';
  Script.Add := '  TExtendedDetLookupField( Detail.ExtendedID.FieldLookup.FieldByName(ORI_AMOUNT_JV) ).OnChangeArray  := @RecalcDetailJV; ';
  Script.Add := '  TExtendedDetLookupField( Detail.ExtendedID.FieldLookup.FieldByName(ORI_AMOUNT_JV) ).OnChangeArray  := @updateInputAmount;'; // AA, BZ 2404
  Script.Add := '  Master.on_before_save_array := @setTolerance; '; // AA, BZ 2797
  Script.Add := '  Master.onAfterOpenArray := @setTotalDebitCredit;'; // AA, BZ 2797
  Script.Add := '  TfrmJV(form).onSetTotalFromScript := @setTotalOfJV;'; // AA, BZ 2797
  Script.Add := 'end.';
end;

procedure TDefaultUSDInjector.GenerateForJVDet;
begin
  Script.clear;
  AddConst;
  AddJVDetFunctions;
  Script.Add := 'begin';
  AddJVDetMain;
  Script.Add := 'end.';
end;

procedure TDefaultUSDInjector.GenerateForAccountDataset;
begin
  Script.Clear;
  AddConst;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  Script.Add := 'procedure CurrencyChange; ';
  Script.Add := 'var sql:TjbSQL; ';
  Script.Add := 'begin ';
  Script.Add := '  if Dataset.CurrencyID.isNull then exit;';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sql, ''Select first 1 DefaultCurrencyID from Company''); ';
  Script.Add := '    if Dataset.CurrencyID.asString = sql.FieldByName(''DefaultCurrencyID'') then begin';
  //Script.Add := '      ShowMessage(''Tidak boleh assign ke Default Currency!''); ';
  Script.Add := '      Dataset.CurrencyID.value := GetDefaultCurrency;';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  Script.Add := 'function GetDefaultCurrency:Integer;';
  Script.Add := 'var sql:TjbSQL;';
  Script.Add := 'begin';
  Script.Add := '  result := -1;';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '  try';
  Script.Add := '    RunSQL(sql, format(''Select CurrencyID from Currency where ExchangeRate=%d'', [STANDARDRATE]));';
  Script.Add := '    if sql.EOF then RaiseException(format(''Currency dengan kurs %d belum ada'', [STANDARDRATE])) ';
  Script.Add := '      else result := sql.FieldByName(''CurrencyID'');';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  Script.Add := 'Begin';
  Script.Add := '  Dataset.CurrencyID.OnChangeArray := @CurrencyChange; ';
  Script.add := 'end.';
end;

procedure TDefaultUSDInjector.DivideValue(tbl,Field:String);
begin
  Script.Add := format('  Datamodule.%s.FieldByName(''%s'').asCurrency := Datamodule.%s.FieldByName(''%s'').asCurrency/STANDARDRATE;',
    [tbl, Field, tbl, Field]);
end;

procedure TDefaultUSDInjector.GenerateForCOAs;
begin
  Script.Clear;
  AddConst;
  Script.Add := 'begin';
  Script.Add := '  Datamodule.tblGLAccnt.SelectSQL.Text := '+
    'InsertBefore(''Balance'', Datamodule.tblGLAccnt.SelectSQL.Text, format(''/%d'', [STANDARDRATE])); ';
  Script.Add := 'end.';
end;

procedure TDefaultUSDInjector.GenerateForFA;
begin
  ClearScript;
  AddConst;

  Script.Add := 'procedure SetVisibleColumn; ';
  Script.Add := '  var idx : Integer = 0; ';
  Script.Add := 'begin ';
  Script.Add := '  for idx := 0 to Form.DBGrid1.Columns.Count -1 do begin ';
  Script.Add := '    if ( Uppercase( Trim( Form.DBGrid1.Columns[idx].FieldName ) ) = ''GLAMOUNT'' ) ';
  Script.Add := '    then begin ';
  Script.Add := '      Form.DBGrid1.Columns[idx].Visible := False; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'var timer  : TTimer; ';
  Script.Add := '';
  Script.Add := 'procedure DestroyTimer; ';
  Script.Add := 'begin';
  Script.Add := '  if timer <> nil then begin ';
  Script.Add := '    timer.Free; ';
  Script.Add := '    timer := nil; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure CreateTimer; ';
  Script.Add := '  var second : Integer = 0; ';
  Script.Add := '  ';
  Script.Add := '  procedure ProcessHideColumn; ';
  Script.Add := '  begin ';
  Script.Add := '    SetVisibleColumn; ';
  Script.Add := '    DestroyTimer; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := 'begin ';
  Script.Add := '  DestroyTimer; ';
  Script.Add := '  timer := TTimer.Create( nil ); ';
  Script.Add := '  timer.Interval := 1; ';
  Script.Add := '  timer.OnTimer  := @ProcessHideColumn; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure RecalcDetailFA; ';
  Script.Add := '  var oriRate     : Currency = 0; ';
  Script.Add := '      oriAmount   : Currency = 0; ';
  Script.Add := '      defaultRate : Currency = 0; ';
  Script.Add := '  ';
  Script.Add := '  function GetDefaultRate: Currency; ';
  Script.Add := '  begin ';
  Script.Add := '    if oriRate = 0 then begin ';
  Script.Add := '      result := 0; ';
  Script.Add := '    end else begin ';
//  Script.Add := '      result := ( STANDARDRATE / oriRate ); ';
  Script.Add := '      result := round(( STANDARDRATE / oriRate ) * 10000)/10000;'; // AA, BZ 2471, round to 4 decimal
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := 'begin ';
  Script.Add := '  oriRate     := Detail.ExtendedID.FieldLookup.FieldByName(ORI_RATE_FA).AsCurrency; ';
  Script.Add := '  oriAmount   := Detail.ExtendedID.FieldLookup.FieldByName(ORI_AMOUNT_FA).AsCurrency; ';
  Script.Add := '  defaultRate := GetDefaultRate; ';
  Script.Add := '  ';
  Script.Add := '  Detail.GLAmount.AsCurrency := ( defaultRate * oriAmount ); ';
  Script.Add := '  Detail.ExtendedID.FieldLookup.FieldByName(VALUE_USD_FA).AsCurrency  := ( Detail.GLAmount.AsCurrency / STANDARDRATE ); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := '  CreateTimer; ';
  Script.Add := '  Master.OnNewRecordArray  := @CreateTimer; ';
  Script.Add := '  Master.OnAfterCloseArray := @DestroyTimer; ';
  Script.Add := '  TExtendedDetLookupField( Detail.ExtendedID.FieldLookup.FieldByName(VALUE_USD_FA) ).OnChangeArray  := @RecalcDetailFA; ';
  Script.Add := '  TExtendedDetLookupField( Detail.ExtendedID.FieldLookup.FieldByName(ORI_RATE_FA) ).OnChangeArray   := @RecalcDetailFA; ';
  Script.Add := '  TExtendedDetLookupField( Detail.ExtendedID.FieldLookup.FieldByName(ORI_AMOUNT_FA) ).OnChangeArray := @RecalcDetailFA; ';
  Script.Add := 'end. ';
end;

procedure TDefaultUSDInjector.GenerateForFAs;
begin
  ClearScript;
  AddFunction_CreateSQL;
  add_procedure_runsql;
  AddConst;
  Script.Add := 'procedure OnCalcField;';

  Script.Add := '  function GetAssetCost : Currency;';
  Script.Add := '  var';
  Script.Add := '    assetCostSQL : TjbSQL;';
  Script.Add := '  begin';
  Script.Add := '    assetCostSQL := CreateSQL (TIBTransaction (Tx) );';
  Script.Add := '    try';
  Script.Add := '      RunSQL (assetCostSQL, Format (''SELECT ASSETCOST FROM FIXASSET '+
                       'WHERE ASSETID = %d'', [DataModule.tblFixAsset.AssetID.AsInteger]) );';
  Script.Add := '      result := assetCostSQL.FieldByName (''ASSETCOST'');';
  Script.Add := '    finally';
  Script.Add := '      assetCostSQL.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := 'begin';
  Script.Add := '  if GetAssetCost = Datamodule.tblFixAsset.FieldByName(''ASSETCOST'').asCurrency then begin';  //SCY BZ 2740
  DivideValue('tblFixAsset', 'AssetCost');
  Script.Add := '  end;';

  //DivideValue('tblFixAsset', 'Residu');
  Script.Add := 'end;';

  Script.Add := EmptyStr;
  Script.Add := 'begin';
  Script.Add := '  Datamodule.tblFixAsset.OnCalcFieldsArray := @OnCalcField; ';
  Script.Add := 'end.';
end;

procedure TDefaultUSDInjector.GenerateForProjects;
begin
  Script.Clear;
  AddConst;
  Script.Add := 'procedure OnCalcField;';
  Script.Add := 'begin';
  DivideValue('tblProject', 'PROFITLOSS');
  DivideValue('tblProject', 'REVENUE');
  DivideValue('tblProject', 'EXPENSE');
  DivideValue('tblProject', 'COGS');
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  Script.Add := 'begin';
  Script.Add := '  Datamodule.tblProject.OnCalcFieldsArray := @OnCalcField; ';
  Script.Add := 'end.';
end;

procedure TDefaultUSDInjector.GenerateForMemorizedReport;
begin
  Script.Clear;
  ReadOption;
  Script.Add := '';
  Script.Add := 'var';
  script.Add := '  EXT_TYPE_NAME : String;';
  Script.Add := '';
  Script.Add := 'Procedure setMemorizedReportDivideNum(rpt:TCPReport);';
  Script.Add := 'var';
  Script.Add := '  rptName : string;';
  Script.Add := '  jTx : TIBTransaction;';
  Script.Add := '  sql : TjbSQL;';
  Script.Add := '  extTypeId : integer;';
  Script.Add := 'begin';
  Script.Add := '  rptName := rpt.MemReportName;';
  Script.Add := '  if (rptName<>'''') then begin';
  Script.Add := '    jTx := CreateATx;';
  Script.Add := '    sql := CreateSQL(jTx);';
  Script.Add := '    Try';
  Script.Add := '      RunSQL(sql, Format(''select et.extendedTypeId from extendedType et where et.extendedName=''''%s'''' '', [ext_type_name]) ); ';
  Script.Add := '      extTypeId :=  sql.FieldByName(''extendedTypeId'');';
  Script.Add := '      RunSQL(sql, Format(''select cast(ed.info2 as numeric(18,4)) as divNum from extendedDet ed where ed.extendedTypeId=%d and ed.info1=''''%s'''' '', [extTypeId, rptName]));';
  Script.Add := '      if not sql.eof then begin';
  Script.Add := '        rpt.Master.NumDivider := sql.fieldByName(''divNum'');';
  Script.Add := '      end;';
  Script.Add := '    Finally';
  Script.Add := '      sql.free;';
  Script.Add := '      jTx.free;';
  Script.Add := '    End;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'Begin';
  script.Add := '  ext_type_name := ReadOption(''DEVIDEDBY_EXT_TYPE'', ''DEVIDED BY'');';
  Script.Add := '  form.onManageReportFormat := @setMemorizedReportDivideNum;';
  Script.Add := 'End.';
end;

procedure TDefaultUSDInjector.GenerateForGLHist;
begin
  Script.Clear;
  AddConst;
  Script.Add := 'begin';
  Script.Add := '  Datamodule.TblGLAccnt.SelectSQL.Text := ReplaceStr(Datamodule.TblGLAccnt.SelectSQL.Text, '+
    ' ''A.BASEAMOUNT'', format(''cast(A.BaseAmount/%d as numeric(18,4)) BaseAmount'', [STANDARDRATE])); ';
  Script.Add := '  Datamodule.TblGLAccnt.Close;';
  Script.Add := '  Datamodule.TblGLAccnt.Open;';
  Script.Add := 'end.';
end;

procedure TDefaultUSDInjector.GenerateForIAs;
begin
  Script.Clear;
  AddConst;
  Script.Add := 'begin';
  Script.Add := '  Datamodule.tblItemAdj.SelectSQL.Text := ReplaceStr(Datamodule.tblItemAdj.SelectSQL.Text, '+
    '''(Select TotalValue from Get_ItemAdjTotalValue (A.ItemAdjID) ) TOTALVALUE'', '+
    'format(''(Select TotalValue from Get_ItemAdjTotalValue (A.ItemAdjID) )/%d TOTALVALUE'', [STANDARDRATE]) ); ';
  Script.Add := '  Datamodule.tblItemAdj.Close;';
  Script.Add := '  Datamodule.tblItemAdj.Open; ';
  Script.Add := 'end.';
end;

procedure TDefaultUSDInjector.GenerateForJCs;
begin
  Script.Clear;
  AddConst;
  Script.Add := 'begin';
  Script.Add := '  Datamodule.tblMfSht.SelectSQL.Text := '+
    'ReplaceStr( Datamodule.tblMfSht.SelectSQL.Text, '+
    '''A.AmountItem ItemAmount'', '+
    'format(''A.AmountItem/%d ItemAmount'', [STANDARDRATE]) ); ';
  Script.Add := '  Datamodule.tblMfSht.SelectSQL.Text := '+
    'ReplaceStr( Datamodule.tblMfSht.SelectSQL.Text, '+
    '''m.AccountAmount'', '+
    'format(''m.AccountAmount/%d AccountAmount'', [STANDARDRATE]) ); ';

  Script.Add := '  Datamodule.tblMfSht.Close;';
  Script.Add := '  Datamodule.tblMfSht.Open; ';
  Script.Add := 'end.';
end;
procedure TDefaultUSDInjector.RepStr(tbl:String);
begin
  Script.Add := 'procedure RepStr(Field:String);';
  Script.Add := 'begin';
  Script.Add := format('  Form.%s.SelectSQL.Text := ReplaceStr(Form.%s.SelectSQL.Text, ', [tbl, tbl]);
  Script.Add := '    format(''%s'', [Field]), ';
  Script.Add := '    format(''%s/%d %s'', [Field, STANDARDRATE, Field]) ); ';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
end;

procedure TDefaultUSDInjector.GenerateForGLBalance;
begin
  Script.Clear;
  AddConst;
  RepStr('tblGLBalance');
  Script.Add := 'var i:Integer; ';
  Script.Add := '    x: Integer;';
  Script.Add := '    fn: String;';
  Script.Add := 'begin';
  Script.Add := '  for x:= 0 to 1 do begin ';
  Script.Add := '    if x=0 then fn := ''Base'' else fn := ''Prime''; ';
  Script.Add := '    for i:=0 to 12 do begin';
  Script.Add := '      if i=0 then RepStr(format(''%sAmountOpBal'', [fn])) ';
  Script.Add := '        else RepStr(format(''%sAmount%d'', [fn, i])); ';
  Script.Add := '    end;';
  Script.Add := '  end; ';
  Script.Add := '  Form.tblGLBalance.Close;';
  Script.Add := '  Form.tblGLBalance.Open;';
  Script.Add := 'end.';
end;

procedure TDefaultUSDInjector.GenerateForGLBudget;
begin
  Script.Clear;
  AddConst;
  RepStr('TblGLAccnt');
  Script.Add := 'var i:Integer; ';
  Script.Add := 'begin';
  Script.Add := '  for i:=0 to 12 do begin';
  Script.Add := '    if i=0 then RepStr(''BUDGETAMOUNTOPBAL'') ';
  Script.Add := '      else RepStr(format(''BUDGETAMOUNT%d'', [i])); ';
  Script.Add := '  end;';
  //Script.Add := '  ShowMessage(Form.TblGLAccnt.SelectSQL.Text);';
  Script.Add := '  Form.TblGLAccnt.Close;';
  Script.Add := '  Form.TblGLAccnt.Open;';
  Script.Add := 'end.';
end;

procedure TDefaultUSDInjector.GenerateForJVs;
begin
  Script.Clear;
  AddConst;
  Script.Add := 'begin ';
  Script.Add := '  if Datamodule.FormType=1 then begin ';
  Script.Add := '    Datamodule.qryJV.SelectSQL.Text := ReplaceStr(Datamodule.qryJV.SelectSQL.Text, '+
    ' ''JVAmount'', format(''JVAmount/%d JVAmount'', [STANDARDRATE]));';
  Script.Add := '  end;';
  Script.Add := 'end.';
end;

{procedure TDefaultUSDInjector.GenerateForBankBook;
begin
  Script.Clear;
  AddConst;
  Script.Add := 'begin';
  Script.Add := '  Form.qryGLHist.sql.Text := ReplaceStr(Form.qryGLHist.sql.Text, ''*'', ';
  Script.Add := '    format(''GLACCOUNT, TXDATE, REFNO, DESCRIPTION, AMOUNT/%d AMOUNT, DEBIT/%d DEBIT, CREDIT/%d CREDIT,'', [STANDARDRATE, STANDARDRATE, STANDARDRATE]) + ';
  Script.Add := '    ''SOURCE, TXTYPE, PERSID, INVID, GLYEAR, GLPERIOD, GLHISTID, FASSETID, RECONCILEDDATE, CHQNO, SORTBY'');';
  Script.Add := '  Form.qryGLHist.Close; ';
  Script.Add := '  Form.qryGLHist.Open; ';
  Script.Add := 'end.';

end; }

procedure TDefaultUSDInjector.GenerateForMain;
begin
  ClearScript;
  CreateMenu;
  CreateLabel;
  MainAddCustomReport;
  IsAdmin;
  CreateFormSetting;
  Script.Add := 'procedure ShowSettingRate; ';
  Script.Add := '  var frmSetting : TForm; ';
  Script.Add := '      lblJVDet   : TLabel; ';
  Script.Add := '      lblFADet   : TLabel; ';
  Script.Add := 'begin ';
  Script.Add := '  if not IsAdmin then Exit; ';
  Script.Add := '  frmSetting := CreateFormSetting(''frmSetting'', ''Setting Default USD'', 400, 400);';
  Script.Add := '  try ';
  Script.Add := '    ListCtrl.Add('' ; ; ''); ';
  Script.Add := '    AddControl( frmSetting, ''Div. Default USD'', ''TEXT'', ''STANDARDRATE'', ''1000'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Mem. Rpt. Ext. Type Name'', ''TEXT'', ''DEVIDEDBY_EXT_TYPE'', ''DEVIDED BY'', ''0'', ''''); ';
  Script.Add := '    lblJVDet := CreateLabel( 10, 25 * ListCtrl.Count + 10, 150, 20, ''Journal Voucher Detail'', ScrollBox);';
  Script.Add := '    lblJVDet.Font.Style := fsBold; ';
  Script.Add := '    ListCtrl.Add('' ; ; ; ''); ';
  Script.Add := '    AddControl( frmSetting, ''Debit USD'', ''CUSTOMFIELD'', ''DEBIT_USD_JV'', ''CustomField2'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Kredit USD'', ''CUSTOMFIELD'', ''CREDIT_USD_JV'', ''CustomField3'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Original Rate'', ''LOOKUP'', ''ORI_RATE_JV'', ''Lookup1'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Original Amount'', ''CUSTOMFIELD'', ''ORI_AMOUNT_JV'', ''CustomField4'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Input Amount'', ''CUSTOMFIELD'', ''INPUT_AMOUNT_JV'', ''CustomField5'', ''0'', ''''); ';
  Script.Add := '    lblFADet := CreateLabel( 10, 25 * ListCtrl.Count + 10, 150, 20, ''Fixed Asset Detail'', ScrollBox);';
  Script.Add := '    lblFADet.Font.Style := fsBold; ';
  Script.Add := '    ListCtrl.Add('' ; ; ; ''); ';
  Script.Add := '    AddControl( frmSetting, ''Nilai USD'', ''CUSTOMFIELD'', ''VALUE_USD_FA'', ''CustomField1'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Original Rate'', ''CUSTOMFIELD'', ''ORI_RATE_FA'', ''CustomField4'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Original Amount'', ''CUSTOMFIELD'', ''ORI_AMOUNT_FA'', ''CustomField5'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''JV different tolerance'', ''TEXT'', ''DIFFTOLERANCE'', ''0.0005'', ''0'', ''''); '; // AA, BZ 2797
  Script.Add := '    if frmSetting.ShowModal = mrOK then begin ';
  Script.Add := '      SaveToOptions; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    frmSetting.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure DeleteOptionTypeJV; ';
  Script.Add := '  var ATxOpt    : TIBTransaction; ';
  Script.Add := '      sqlOpt    : TjbSQL; ';
  Script.Add := '      txtSQLOpt : String; ';
  Script.Add := 'begin ';
  Script.Add := '  ATxOpt    := CreateATx; ';
  Script.Add := '  sqlOpt    := CreateSQL( ATxOpt ); ';
  Script.Add := '  txtSQLOpt := format( ''DELETE FROM OPTIONS WHERE PARAMOPT CONTAINING ''''TYPE_JV|%s|'''' '', [ IntToStr(UserID) ] ); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sqlOpt, txtSQLOpt ); ';
  Script.Add := '  finally ';
  Script.Add := '    ATxOpt.Commit; ';
  Script.Add := '    sqlOpt.Free; ';
  Script.Add := '    ATxOpt.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := '  DeleteOptionTypeJV; ';
  Script.Add := '  AddCustomReport; ';
  Script.Add := '  AddCustomMenuSetting(''mnuSettingRate'', ''Setting Default USD'', ''ShowSettingRate''); ';
  Script.Add := 'end. ';
end;

procedure TDefaultUSDInjector.OnDateChangeSetLookup1;
begin
  Script.Add := 'procedure OnAssignLookup1;                                       ';
  Script.Add := 'var SQL:TjbSQL;                                                ';
  Script.Add := 'begin                                                          ';
  Script.Add := '  if Dataset.ExtendedID.isNull then exit;                      ';
  Script.Add := '  sql := CreateSQL( TIBTransaction(Tx) );                      ';
  Script.Add := '  try                                                          ';
  Script.Add := '    RunSQL(sql, ''select first 1 ed.ExtendedDetID from EXTENDEDDET ed join EXTENDEDTYPE et on et.EXTENDEDTYPEID=ed.EXTENDEDTYPEID ''+ ';
  Script.Add := '      format(''where (et.EXTENDEDNAME=''''%s'''') and (ed.INFO1 <= '''''', [FISCALRATE]) '
    + '+ formatDateTime(''yyyy-mm-dd'', Dataset.InvoiceDate.value) + '''''')'' +';
  Script.Add := '      ''order by ed.INFO1 desc '');';
  Script.Add := '    if sql.EOF then begin';
  Script.Add := '      RaiseException(''Fiscal Rate di ExtendedType belum diisi'');';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      dataset.ExtendedID.FieldLookup.FieldByName(FieldLookupName).value := sql.FieldByName(''ExtendedDetID'');';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  end;       ';
  Script.Add := 'end;         ';
  Script.Add := EmptyStr;
end;

procedure TDefaultUSDInjector.GetRateByCurrency;
begin
  Script.Add := 'function GetRateByCurrency(Tgl:TDateTime; Curr, ExtendedTypeName:String):Currency; ';
  Script.Add := 'var StrSQL : String; ';
  Script.Add := '    sql : TjbSQL; ';
  Script.Add := '    cnt, idx : Integer; ';
  Script.Add := 'begin ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sql, ''Select count(*) CurCount from Currency''); ';
  Script.Add := '    cnt := sql.FieldByName(''CurCount'') - 1; ';
  Script.Add := '    idx := 2; ';
  Script.Add := '    StrSQL := format(''select first 1 ed.%s USD, case'', [FieldRateUSD]); ';
  Script.Add := '    while Cnt > 0 do begin ';
  Script.Add := '      StrSQL := StrSQL + #13#10 + format('' when et.INFOCAPTION%d = ''''%s'''' then ed.info%d'', [idx, Curr, idx]);';
  Script.Add := '      inc(idx); ';
  Script.Add := '      Dec(cnt); ';
  Script.Add := '    end; ';
  Script.Add := '    StrSQL := StrSQL + #13#10 + '' end Rate''; ';
  Script.Add := '    StrSQL := StrSQL + #13#10 + format('' from EXTENDEDDET ed, EXTENDEDTYPE et where et.EXTENDEDNAME=''''%s'''' '', [ExtendedTypeName]); ';
  Script.Add := '    StrSQL := StrSQL + #13#10 + '' and ed.EXTENDEDTYPEID = et.EXTENDEDTYPEID''; ';
  Script.Add := '    StrSQL := StrSQL + #13#10 + format('' and ed.INFO1 <= ''''%s'''' '', [formatDateTime(''yyyy-mm-dd'', Tgl)]); ';
  Script.Add := '    StrSQL := StrSQL + #13#10 + '' order by ed.INFO1 desc''; ';
  Script.Add := '    RunSQL( sql, StrSQL );';
  Script.Add := '    if sql.EOF then result := -1 else result := sql.FieldByName(''USD'') / sql.FieldByName(''Rate''); ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
end;

procedure TDefaultUSDInjector.GetFiscalRate(FieldName:String);
begin
  Script.Add := 'function GetFiscalRate:Currency;';
  Script.Add := 'var sql:TjbSQL;';
  Script.Add := '    RateUSD, RateYEN : Currency; ';
  Script.Add := '    FieldLookupToFiscalRate : TExtendedDetLookupField; ';
  Script.Add := '    Curr : String; ';
  Script.Add := 'begin';
  Script.Add := '  result := STANDARDRATE; ';
  Script.Add := format('  if Dataset.%s.isNull then exit; ', [FieldName]);
  Script.Add := '  if Dataset.Rate.value = STANDARDRATE then exit; ';
  Script.Add := '  if dataset.ExtendedID.FieldLookup.FieldByName(FieldLookupName).isNull then OnAssignLookup1; ';
  Script.Add := '  FieldLookupToFiscalRate := TExtendedDetLookupField(TExtendedDataset(Dataset.ExtendedID.FieldLookup).FieldByName(FieldLookupName)); ';
  Script.Add := '  RateUSD := FieldLookupToFiscalRate.FieldLookup.FieldByName(FieldRateUSD).asCurrency; ';
  Script.Add := '  RateYEN := FieldLookupToFiscalRate.FieldLookup.FieldByName(FieldRateJYP).asCurrency; ';
  Script.Add := format('  Curr := GetCurrencyNameByPersonID( Dataset.%s.asString ); ', [FieldName]);
  {Script.Add := '  sql := CreateSQL( TIBTransaction(Tx) ); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sql, ''Select cu.CurrencyName from PersonData c join Currency cu on cu.CurrencyID=c.CurrencyID ''+ '+
    format(' ''where c.ID='' + Dataset.%s.asString);', [FieldName]);}
  Script.Add := '    if Curr=''IDR'' then result := STANDARDRATE / RateUSD; ';
  Script.Add := '    if Curr=''JPY'' then result := STANDARDRATE / (RateUSD / RateYEN); ';
  {Script.Add := '  finally                                                   ';
  Script.Add := '    sql.Free;                                               ';
  Script.Add := '  end;                                                      ';}
  Script.Add := 'end;                                                        ';
  Script.Add := EmptyStr;
end;

procedure TDefaultUSDInjector.OnSetCommercialRate(TblName, DateField, PersonFieldName:String; HasFiscalPayment:Boolean);
begin
  Script.Add := 'function GetCurrencyNameByPersonID(ID:String):String; ';
  Script.Add := 'var sql:TjbSQL; ';
  Script.add := 'begin ';
  Script.Add := '  sql := CreateSQL( TIBTransaction(Tx) ); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sql, format(''Select cu.CurrencyName from PersonData c join Currency cu on cu.CurrencyID=c.CurrencyID where c.ID=%s'', [ID]));';
  Script.Add := '    result := sql.FieldByName(''CurrencyName''); ';
  Script.Add := '  finally                                                   ';
  Script.Add := '    sql.Free;                                               ';
  Script.Add := '  end;                                                      ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure OnSetCommercialRate; ';
  Script.Add := '  function RateTableName:String ; ';
  Script.Add := '  begin ';
  Script.Add := '    result := COMMRATE; ';
  if HasFiscalPayment then begin
    Script.Add := format('    if %s.FiscalPmt.value = 1 then result := FISCALRATE; ', [TblName]);
  end;
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := format('  if %s.%s.isNull then exit; ', [TblName, PersonFieldName]);
  Script.Add := format('  %s.Rate.value := STANDARDRATE / GetRateByCurrency(%s.%s.value, GetCurrencyNameByPersonID( %s.%s.asString ), RateTableName); ',
    [TblName, TblName, DateField, TblName, PersonFieldName]);
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TDefaultUSDInjector.MainProcedure(FieldName:String; AdditionalProcedure:String);
begin
  Script.Add := 'procedure Lookup1Changed;';
  Script.Add := 'begin';
  Script.Add := format('  %sChanged;', [FieldName]);
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  Script.Add := 'procedure AssignExtendedEvent; ';
  Script.Add := 'begin';
  Script.Add := '  TExtendedDetLookupField(TExtendedDataset(Dataset.ExtendedID.FieldLookup).FieldByName(FieldLookupName)).OnChangeArray := @Lookup1Changed; ';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  Script.Add := format('procedure %sChanged;', [FieldName]);
  Script.Add := 'begin';
  Script.Add := format('  if Dataset.%s.isNull then exit; ', [FieldName]);
  Script.Add := '  Dataset.FiscalRate.value := GetFiscalRate; ';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  Script.Add := 'procedure FiscalRateChanged;';
  Script.Add := 'begin';
  Script.Add := '  if Dataset.FiscalRate.value <> GetFiscalRate then begin';
  Script.Add := '    Dataset.FiscalRate.value := GetFiscalRate; ';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  OnSetCommercialRate('Dataset', 'InvoiceDate', FieldName, false);
  Script.Add := 'Begin';
  Script.Add := '  dataset.InvoiceDate.OnChangeArray := @OnAssignLookup1; ';
  Script.Add := format('  dataset.%s.OnChangeArray  := @%sChanged; ', [FieldName, FieldName]);
  Script.Add := '  Dataset.OnNewRecordArray          := @AssignExtendedEvent;';
  Script.Add := '  Dataset.OnAfterEditArray          := @AssignExtendedEvent;';
  Script.Add := '  Dataset.FiscalRate.OnChangeArray  := @FiscalRateChanged; ';
  Script.Add := format('  Dataset.%s.OnChangeArray := @OnSetCommercialRate; ', [FieldName]);
  Script.Add := '  Dataset.Rate.OnChangeArray        := @OnSetCommercialRate; ';
  Script.Add := '  Dataset.InvoiceDate.OnChangeArray := @OnSetCommercialRate; ';
  Script.Add := AdditionalProcedure;
  Script.Add := 'end.';
end;

procedure TDefaultUSDInjector.AddConstFiscalRate;
begin
  Script.Add := 'const FISCALRATE=''FISCAL RATE''; ';
  Script.Add := '      COMMRATE  =''COMMERCIAL RATE''; ';
end;

procedure TDefaultUSDInjector.GenerateForSI;
begin
  ClearScript;
  AddConstFiscalRate;
  AddConst;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  GetRateByCurrency;
  OnDateChangeSetLookup1;
  GetFiscalRate('CustomerID');
  MainProcedure('CustomerID', '');
end;

procedure TDefaultUSDInjector.GenerateForSR;
begin
  ClearScript;
  AddConstFiscalRate;
  AddConst;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  GetRateByCurrency;
  OnDateChangeSetLookup1;
  GetFiscalRate('CustomerID');
  MainProcedure('CustomerID', '');
end;


procedure TDefaultUSDInjector.GenerateForPI;
begin
  ClearScript;
  AddConstFiscalRate;
  AddConst;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  GetRateByCurrency;
  OnDateChangeSetLookup1;
  GetFiscalRate('VendorID');
  MainProcedure('VendorID', '');
end;

procedure TDefaultUSDInjector.AddButtonSetBank(CtlRef, BankAccField:String);
begin
  Script.Add := 'var lbox : TListBox; ';
  Script.Add := 'procedure IsiListBox;';
  Script.Add := 'var sql:TjbSQL;';
  Script.Add := 'begin';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  try';
  Script.Add := '    RunSQL(sql, ''Select g.GLAccount, g.AccountName from GLAccnt g '+
  //  'join Currency c on c.CurrencyID=g.CurrencyID where g.AccountType=7 and c.CurrencyName=''''IDR'''' '');';
    'join Currency c on c.CurrencyID=g.CurrencyID where g.AccountType=7 '+
    'and not exists (select * from GLAccnt g1 where g1.ParentAccount=g.GLAccount) '+
    'order by g.GLAccount'');';
  Script.Add := '    lbox.Items.clear;';
  Script.Add := '    while not sql.EOF do begin';
  Script.Add := '      lbox.Items.Add( sql.FieldByName(''GLAccount'') + ''-'' + sql.FieldByName(''AccountName'') );';
  Script.Add := '      if sql.FieldByName(''GLAccount'') = FieldBank.asString then begin ';
  Script.Add := '        lbox.ItemIndex := lbox.Items.Count-1; ';
  Script.Add := '      end;';
  Script.Add := '      sql.Next; ';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.add := '    sql.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  Script.Add := 'function FieldBank:TField;';
  Script.Add := 'begin';
  Script.Add := '  result := Master.ExtendedID.FieldLookup.FieldByName(''CustomField1''); ';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  Script.Add := 'procedure BtnSetBankClick;';
  Script.Add := 'begin';
  Script.Add := '  if lbox <> nil then begin';
  Script.Add := '    if lbox.ItemIndex >= 0 then begin';
  Script.Add := '      FieldBank.asString := GetToken(lbox.Items[lbox.ItemIndex], ''-'', 1);';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      FieldBank.asVariant := null;';
  Script.Add := '    end;';
  Script.Add := '    lbox.Free;';
  Script.Add := '    lbox := nil;';
  Script.Add := '  end';
  Script.Add := '  else begin';
  Script.Add := '    lbox := TListBox.Create(Form);';
  Script.Add := '    lbox.Setbounds(btnSetBank.Left + btnSetBank.Width - 300, btnSetBank.Top + btnSetBank.Height, 300, 100 );';
  Script.Add := '    lbox.Parent := Form.pnlJbHeader;';
  Script.Add := '    IsiListBox;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure AddButton;';
  Script.Add := 'begin';
  Script.Add := format('  BtnSetBank := CreateBtn(Form.%s.Left+Form.%s.Width - 80, Form.%s.Top + Form.%s.Height, 80, 20, 9, '+
    ' ''Select Bank'', Form.pnlJbHeader);', [CtlRef, CtlRef, CtlRef, CtlRef]);
  Script.Add := '  BtnSetBank.OnClick := @BtnSetBankClick;';
  Script.Add := '  BtnSetBank.visible := false;'; // AA, BZ 2380
  //Script.Add := '  editBankAmount := CreateEdit(BtnSetBank.Left - 100, BtnSetBank.Top, 100, BtnSetBank.Height, btnSetBank.Parent); ';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  Script.Add := 'procedure SetCtlVisible(vis:Boolean); ';
  Script.Add := 'begin ';
  Script.Add := '  btnSetBank.visible     := vis;';
  //Script.Add := '  editBankAmount.visible := vis; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure BankAccountChange; ';
  Script.Add := 'var sql:TjbSQL; ';
  Script.Add := 'begin';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sql, format(''Select c.ExchangeRate from Currency c, GLAccnt g where g.GLAccount=''''%s'''' and g.CurrencyID=c.CurrencyID'', '+
    format(' [Master.%s.value] ));', [BankAccField]);
  Script.Add := '    SetCtlVisible( (sql.FieldByName(''ExchangeRate'') = 1) );';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TDefaultUSDInjector.GetJVID;
begin
  Script.Add := '  function GetJVID(JVNo:String):Integer; ';
  Script.Add := '  var sql : TjbSQL;';
  Script.Add := '  begin';
  Script.Add := '    sql := CreateSQL( TIBTransaction(Tx) ); ';
  Script.Add := '    try';
  Script.Add := '      RunSQL(sql, format(''Select JVID from JV where JVNumber=''''%s'''' '', [JVNo]));';
  Script.Add := '      if sql.EOF then result := -1 else result := sql.FieldByName(''JVID''); ';
  Script.Add := '    finally';
  Script.Add := '      sql.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';
end;

procedure TDefaultUSDInjector.PaymentGetGainLossAccount;
begin
  Script.Add := 'function GetGainOrLossAccount:String;';
  Script.Add := 'var sql:TjbSQL;';
  Script.Add := 'begin';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '  try';
  Script.Add := '    RunSQL(sql, ''select GLAccount from DefAccnt where Name='+
    '(select c.CurrencyID||'''' Realize Gain or Loss'''' from Currency c where c.CurrencyName=''''IDR'''') ''); ';
  Script.Add := '    result := sql.FieldByName(''GLAccount''); ';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
end;

procedure TDefaultUSDInjector.PaymentCreateJV(DetailTbl, BankAccount, MasterInvTbl, InvoiceFieldName:String; invert:INteger);
begin
  PaymentGetGainLossAccount;
  Script.Add := 'function FieldJVNo:TField;';
  Script.Add := 'begin';
  Script.Add := '  result := Master.ExtendedID.FieldLookup.FieldByName(''CustomField2''); ';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  Script.Add := 'procedure MasterBeforePost;';
  Script.Add := 'var jv:TdmJV;';
  Script.Add := '    Delta:Currency; ';
  Script.Add := EmptyStr;
  Script.Add := '  procedure AddDetail(acc:String; amt, Rate:Currency);';
  Script.Add := '  begin';
  Script.Add := '    jv.AtblJVDet.Append; ';
  Script.Add := '    jv.AtblJvDet.GLAccount.value := acc; ';
  Script.Add := '    jv.AtblJvDet.GLAmount.value  := amt; ';
  Script.Add := '    if Rate <> -1 then jv.AtblJvDet.Rate.value := Rate; ';
  Script.Add := '    jv.AtblJVDet.DeptID.asVariant := Master.DeptID.asVariant; ';
  Script.Add := '    jv.AtblJVDet.Post; ';
  Script.Add := '  end; ';
  Script.Add := EmptyStr;
  Script.Add := '  procedure AddDetailBank(acc:String; amt, Rate:Currency);';
  Script.Add := '  begin';
  Script.Add := '    jv.AtblJVDet.Append; ';
  Script.Add := '    jv.AtblJvDet.GLAccount.value := acc; ';
  Script.Add := '    jv.AtblJvDet.Rate.value := STANDARDRATE / Rate; ';
  //Script.Add := '    jv.AtblJvDet.PrimeAmount.value  := amt * Rate / STANDARDRATE; ';
  Script.Add := '    jv.AtblJvDet.PrimeAmount.value  := amt / jv.AtblJvDet.Rate.value; ';
  Script.Add := '    jv.AtblJVDet.DeptID.asVariant   := Master.DeptID.asVariant; ';
  Script.Add := '    jv.AtblJVDet.Post; ';
  Script.Add := '  end; ';
  Script.Add := EmptyStr;
  Script.Add := '  function InvertValue:Currency;';
  Script.Add := '  begin';
  Script.Add := '    result := -Master.ChequeAmount.value {* Master.Rate.value}; ';
  Script.Add := '  end;';
  Script.Add := EmptyStr;
  GetJVID;
  Script.Add := '  procedure UpdateJVNoInPayment;';
  Script.Add := '  begin';
  Script.Add := '    Master.ExtendedID.FieldLookup.Edit;                   ';
  Script.Add := '    FieldJVNo.asString := jv.AtblJV.JVNumber.value;       ';
  Script.Add := '    Master.ExtendedID.FieldLookup.Post;                   ';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  function GetSIDate:TDateTime; ';
  Script.Add := '  var sql:TjbSQL;';
  Script.Add := '  begin';
  Script.add := '    sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '    try';
  Script.Add := format('      RunSQL(sql, ''Select i.InvoiceDate from %s i ''+ ', [MasterInvTbl]);
  if DetailTbl = 'tblARInvPmt2' then begin //JR, BZ 2509
    Script.Add := format('        ''where i.%s='' + Datamodule.tblARInvPmt.FieldByName(''%s'').asString); ', [InvoiceFieldName, InvoiceFieldName]);
  end
  else begin
    Script.Add := format('        ''where i.%s='' + Datamodule.%s.FieldByName(''%s'').asString); ', [InvoiceFieldName, DetailTbl, InvoiceFieldName]);
  end;
  Script.Add := '      if sql.EOF then result := 0 else result := sql.FieldByName(''InvoiceDate''); ';
  Script.Add := '    finally';
  Script.Add := '      sql.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  function CurrNameByBank(Bank:String):String; ';
  Script.Add := '  var sql : TjbSQL; ';
  Script.Add := '  begin';
  Script.Add := '    result := ''''; ';
  Script.Add := '    if Bank='''' then exit; ';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '    try ';
  Script.Add := '      RunSQL(sql, format(''select c.CURRENCYNAME from GLACCNT g join CURRENCY c on c.CURRENCYID=g.CURRENCYID where g.GLAccount=''''%s'''' '', [Bank]));';
  Script.Add := '      result := sql.FieldByName(''CurrencyName''); ';
  Script.Add := '    finally';
  Script.Add := '      sql.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  function GetRate:Currency; ';
  Script.Add := '  begin ';
  Script.Add := '    if Master.FiscalPmt.value = 1 then begin ';
  Script.Add := '      result := GetRateByCurrency(GetSIDate, CurrNameByBank(FieldBank.asString), FISCALRATE); ';
  Script.Add := '    end ';
  Script.Add := '    else begin ';
  Script.Add := '      result := GetRateByCurrency( Master.PaymentDate.value, CurrNameByBank(FieldBank.asString), COMMRATE);';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := 'var ExceptionRaised:Boolean; ';
  Script.Add := 'begin';
  Script.Add := format('  if Datamodule.%s.RecordCount=0 then exit;  ', [DetailTbl]);
  Script.Add := '  if not BtnSetBank.visible then exit; ';
  Script.Add := '  if (FieldBank.asString = '''') then begin';
  Script.Add := '    BtnSetBank.Setfocus; ';
  Script.Add := '    RaiseException(''Bank belum diisi''); ';
  Script.Add := '  end; ';
  //Script.Add := '  if (editBankAmount.Text = '''') or (editBankAmount.Text = ''0'') then begin ';
  //Script.Add := '    editBankAmount.Setfocus; ';
  //Script.Add := '    RaiseException(''Nilai Bank dalam mata uang asli belum diisi''); ';
  //Script.Add := '  end;';
  Script.Add := '  jv := TdmJV.ACreate(TIBDatabase( DB ), TIBTransaction(Master.Tx), GetJVID(FieldJVNo.asString), UserID, 1); ';
  Script.Add := '  try';
  Script.Add := '    jv.DMStartDatabase; ';
  Script.Add := '    ExceptionRaised := true; ';
  Script.Add := '    if jv.AtblJVDet.RecordCount=0 then begin ';
  Script.add := '      jv.AtblJV.Append; ';
  Script.Add := '      jv.AtblJV.JVNumber.value  := Master.SequenceNo.value; ';
  Script.Add := '      jv.AtblJV.TransDate.value := Master.ChequeDate.value; ';
  Script.Add := '      UpdateJVNoInPayment; ';
  Script.Add := '    end                                                     ';
  Script.Add := '    else begin                                              ';
  Script.Add := '       Jv.AtblJVdet.First;                                  ';
  Script.Add := '       while not Jv.AtblJVDet.EOF do jv.AtblJvDet.Delete;   ';
  Script.Add := '    end;';

  if DetailTbl = 'tblARInvPmt2' then begin //JR, BZ 2509
    Script.Add := '    while not Datamodule.tblARInvPmt.EOF do begin ';
    Script.Add := '      if (not Datamodule.tblARInvPmt.PaymentAmount.IsNull) then begin ';
    Script.Add := '        if (Datamodule.tblARInvPmt.PaymentAmount.Value <> 0) then begin ';
    Script.Add := '        AddDetailBank( FieldBank.asString, 1 * Datamodule.tblARInvPmt.PaymentAmount.value * Master.Rate.value, GetRate); ';
    Script.Add := '        Delta := Delta + jv.AtblJvDet.GLAmount.value; ';
    Script.Add := '        end; ';
    Script.Add := '      end; ';
    Script.Add := '      Datamodule.tblARInvPmt.Next; ';
    Script.Add := '    end; ';
  end
  else begin
    Script.Add := format('    DataModule.%s.First;', [DetailTbl]);
    Script.Add :=        '    Delta := 0;';
    Script.Add := format('    while not Datamodule.%s.EOF do begin', [DetailTbl]);
    Script.Add := format('      AddDetailBank( FieldBank.asString, %d * Datamodule.%s.PaymentAmount.value * Master.Rate.value, GetRate);', [Invert, DetailTbl]);
    Script.Add :=        '      Delta := Delta + jv.AtblJvDet.GLAmount.value;';
    Script.Add := format('      Datamodule.%s.Next;', [DetailTbl]);
    Script.Add :=        '    end; ';
  end;
  Script.Add := format('    AddDetail( Master.%s.asString, %d * InvertValue, 1);', [BankAccount, Invert]); //Bank Default
  Script.Add :=        '    Delta := Delta + jv.AtblJvDet.GLAmount.value; ';
  Script.Add :=        '    if Delta <> 0 then begin';
  Script.Add :=        '      AddDetail( GetGainOrLossAccount, -Delta, -1 ); ';
  Script.Add :=        '    end;';
  Script.Add :=        '    jv.PostData(false);';
  Script.Add :=        '    ExceptionRaised := false; ';
  Script.Add :=        '  finally';
  Script.Add :=        '    if ExceptionRaised then begin ';
  Script.Add :=        '      FieldJVNo.value := ''''; ';
  Script.Add :=        '    end; ';
  Script.Add :=        '    jv.Free;';
  Script.Add :=        '  end;';
  Script.Add :=        'end;';
  Script.Add := EmptyStr;
end;

procedure TDefaultUSDInjector.AddVariable;
begin
  Script.Add := 'var BtnSetBank:TButton;';
  //Script.Add := '    editBankAmount : TEdit; ';
end;

procedure TDefaultUSDInjector.GenerateForCR;
begin
  ClearScript;
  AddConst;
  AddConstFiscalRate;
  AddVariable;
  CreateButton;
  CreateEditBox;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  GetRateByCurrency;
  AddButtonSetBank('AcboBillTo', 'BankAccount');
  PaymentCreateJV('tblARInvPmt2', 'BankAccount', 'ARInv', 'ARInvoiceID', 1);
  OnSetCommercialRate('Master', 'PaymentDate', 'BillToID', true);
  Script.Add := 'begin';
  Script.Add := '  AddButton;';
  Script.Add := '  Master.OnBeforePostValidationArray := @MasterBeforePost; ';
  Script.Add := '  Master.BankAccount.OnChangeArray := @BankAccountChange; ';
  Script.Add := '  Master.BillToID.OnChangeArray    := @OnSetCommercialRate; ';
  //Script.Add := '  Master.Rate.OnChangeArray        := @OnSetCommercialRate; ';
  Script.Add := '  Master.PaymentDate.OnChangeArray := @OnSetCommercialRate; ';
  Script.Add := 'end.';
end;

procedure TDefaultUSDInjector.GenerateForVP;
begin
  ClearScript;
  AddConst;
  AddConstFiscalRate;
  AddVariable;
  CreateButton;
  CreateEditBox;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  GetRateByCurrency;
  AddButtonSetBank('AcboVendor', 'BankAccnt');
  PaymentCreateJV('AtblAPInvChq2', 'BankAccnt', 'APInv', 'APInvoiceID', -1);
  OnSetCommercialRate('Master', 'PaymentDate', 'VendorID', true);
  Script.Add := 'begin';
  Script.Add := '  AddButton;';
  Script.Add := '  Form.height := Form.height - 1; ';
  Script.Add := '  Master.OnBeforePostArray := @MasterBeforePost; ';
  Script.Add := '  Master.BankAccnt.OnChangeArray := @BankAccountChange; ';
  Script.Add := '  Master.VendorID.OnChangeArray    := @OnSetCommercialRate; ';
  //Script.Add := '  Master.Rate.OnChangeArray        := @OnSetCommercialRate; ';
  Script.Add := '  Master.PaymentDate.OnChangeArray := @OnSetCommercialRate; ';
  Script.Add := 'end.';
end;

procedure TDefaultUSDInjector.GenerateForDeletePayment;
begin
  ClearScript;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  GetJVID;
  Script.Add := 'procedure BeforeDelete;';
  Script.Add := 'var jv:TdmJV;';
  Script.Add := '    JVID : Integer; ';
  Script.Add := 'begin';
  Script.Add := '  JVID := GetJVID(Dataset.ExtendedID.FieldLookup.FieldByName(''CustomField2'').asString); ';
  Script.Add := '  if JVID=-1 then exit;';
  Script.Add := '  jv := TdmJV.ACreate(TIBDatabase( DB ), TIBTransaction(Dataset.Tx), JVID, UserID, 1); ';
  Script.Add := '  try';
  Script.Add := '    jv.DMStartDatabase; ';
  Script.Add := '    jv.AtblJV.Delete;';
  Script.Add := '    jv.PostData(false);';
  Script.Add := '  finally';
  Script.Add := '    jv.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  Script.Add := 'begin';
  Script.Add := '  Dataset.OnBeforeDeleteArray := @BeforeDelete; ';
  Script.Add := 'end.';
end;

procedure TDefaultUSDInjector.GenerateScript;
begin
  GenerateForAccountDataset;
  InjectToDB( dnAccount );
  InjectToDB( dnCustomer );
  InjectToDB( dnVendor );

  GenerateForJVDet;
  InjectToDB( dnJVDet );

  GenerateForCOAs;
  InjectToDB( fnGLAccounts );
  GenerateForFA;
  InjectToDB( fnFixAsset );
  GenerateForFAs;
  InjectToDB( fnFixAssets );
  GenerateForProjects;
  InjectToDB( fnProjects );
  GenerateForGLHist;
  InjectToDB( fnGLHistory );
  GenerateForIAs;
  InjectToDB( fnAdjInventories );
  GenerateForJCs;
  InjectToDB( fnJobCosts );
  GenerateForGLBalance;
  InjectToDB( fnGLBalancesForm );
  GenerateForGLBudget;
  InjectToDB( fnGLBudgets );
  GenerateForJV;
  InjectToDB( fnJV );
  GenerateForJVs;
  InjectToDB( fnJVs );

  //GenerateForBankBook;
  //InjectToDB( fnBankBook );
  GenerateForMain;
  InjectToDB( fnMain );


  GenerateForSI;
  InjectToDB( dnSI );
  GenerateForPI;
  InjectToDB( dnPI );
  GenerateForSR;
  InjectToDB( dnSR );
  GenerateForCR;
  InjectToDB( fnARPayment );
  GenerateForVP;
  InjectToDB( fnAPCheque );
  GenerateForDeletePayment;
  InjectToDB( dnCR );
  InjectToDB( dnVP );

  GenerateForMemorizedReport;
  InjectToDB( fnIndexToReport );

  GenerateScriptForPI;
  InjectToDB( fnAPInvoice );
end;


procedure TDefaultUSDInjector.GenerateScriptForPI;
begin
  Script.Clear;
  Script.Add := 'procedure changeTaxFields;';
  Script.Add := 'var';
  Script.Add := '  ds : TPIdataset;';
  Script.Add := 'begin';
  Script.Add := '  ds := TPIDataset(master);';
  Script.Add := '  if (ds.fiscalRate.AsCurrency>1) then begin';
  Script.Add := '    form.AtxtTax1.dataField := ''Tax1Amount'';';
  Script.Add := '    form.AtxtTax2.dataField := ''Tax2Amount'';';
  Script.Add := '  end';
  Script.Add := '  else begin';
  Script.Add := '    form.AtxtTax1.dataField := ''RoundedTax1Amount'';';
  Script.Add := '    form.AtxtTax2.dataField := ''RoundedTax2Amount'';';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'begin';
  // AA, BZ 2747
  Script.Add := '  TPIDataset(master).fiscalRate.onChangeArray := @changeTaxFields;';
  Script.Add := '  TPIDataset(master).onAfterOpenArray := @changeTaxFields;';
  Script.Add := '  changeTaxFields;'; // AA, BZ 2784
  Script.Add := 'end.';
end;

procedure TDefaultUSDInjector.set_scripting_parameterize;
begin
  feature_name := SCRIPTING_DEFAULT_USD;
end;

end.
