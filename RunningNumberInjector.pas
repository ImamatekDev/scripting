unit RunningNumberInjector;

interface
uses Injector, System.SysUtils, ScriptConst, BankConst, Classes;

type
  TRunningNumberInjector = class(TInjector)
  private
    procedure GenerateScriptForDO;
    procedure CreateRunningNoScript(const FormCode, InvNoField, IDField, TableName:String;
      transactionIdentifier:string='');
    procedure AddConstAndVar(const FormCode:String);
    procedure GenerateForMain;
    procedure addIncrementNumber(const FormCode:String);
    procedure GenerateScriptForSO;
    procedure GenerateScriptForIR;
    procedure GenerateScriptForSR;
    procedure GenerateScriptForPR;
    procedure GenerateScriptForSI;
    procedure GenerateScriptForCR;
    procedure GenerateScriptForIT;
//    procedure GenerateScriptForTxCR;
    procedure GenerateScriptForPO;
    procedure GenerateScriptForRI;
    procedure GenerateScriptForPI;
    procedure GenerateScriptForVP;
    procedure GenerateScriptForJC;
    procedure GenerateScriptForIA;
    procedure get_save_next_number_script(const FormCode: String);
    procedure GetFieldName(FormCode, DatasetName : String);
//    procedure GetInvoiceNo;
    procedure AddVarRunningNoForTx(const FormCode:String);
//    procedure CreateRunningNumberForTxCR(const FormCode:String);
    procedure generateScriptUpdateSequenceNo(const FormCode: String); // AA, BZ 3113, 3114
    procedure createRunningNoJV(const FormCode: String);
    procedure GenerateScriptForJV;
    procedure addisSameFormatNumber(fieldName, IncrementHeading:String); //JR, BZ 2992
    procedure addIncrementNo(fieldName:String);
    procedure addNewRecordLast(fieldName:String);
  protected
    procedure set_scripting_parameterize; override;
    procedure AddMenuForm(const FormCode: String); virtual;
    procedure MainCreateMenuSetting; virtual;
    procedure addTemplateChange(fieldName:String); virtual;
    procedure MainSection; virtual;
  public
    procedure GenerateScript; override;

  end;

implementation

{ TRunningNumberInjector }
procedure TRunningNumberInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := SCRIPTING_RUNNING_NUMBER;
end;

procedure TRunningNumberInjector.AddConstAndVar(const FormCode:String);
begin
  ReadOption;
  Script.Add := 'const dsEdit = 2; ';
  Script.Add := 'var ';
  Script.Add := format('  RunningNo%s_ON    : String; ', [FormCode]); //menentukan apakah running number jalan atau tidak
  Script.Add := format('  IncrementHeading%s: String; ', [FormCode]); //Menentukan increment di depan atau di belakang
  Script.Add := '';
  Script.Add := 'procedure InitializeFieldName; ';
  Script.Add := 'begin ';
  Script.Add := format('  RunningNo%s_ON     := ReadOption(''RunningNo%s_ON'', ''0''); ', [FormCode, FormCode]);
  Script.Add := format('  IncrementHeading%s := ReadOption(''IncrementHeading%s'', ''0''); ', [FormCode, FormCode]);
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNumberInjector.AddVarRunningNoForTx(const FormCode:String);
begin
  ReadOption;
  Script.Add := 'var ';
  Script.Add := format('  RunningNo%s_ON    : String; ', [FormCode]); //menentukan apakah running number jalan atau tidak
  Script.Add := '';
  Script.Add := 'procedure InitializeFieldName; ';
  Script.Add := 'begin ';
  Script.Add := format('  RunningNo%s_ON     := ReadOption(''RunningNo%s_ON'', ''0''); ', [FormCode, FormCode]);
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNumberInjector.MainSection;
begin
  Script.Add := 'begin';
  Script.Add := '  InitializeFieldName;';
  Script.Add := '  if RunningNoJV_ON <> ''1'' then exit; ';
  Script.Add := '  Dataset.OnBeforePostArray := @BeforePost;          ';
  Script.Add := '  Dataset.OnNewRecordLastArray  := @NewRecordLast;       ';
  Script.Add := '  Dataset.TemplateID.OnChangeArray := @TemplateChange; ';
  Script.Add := '  Dataset.OnBeforePostValidationArray := @DoValidateNumber; ';
  Script.Add := '  NewRecordLast; ';
  Script.Add := 'end.';
end;

procedure TRunningNumberInjector.createRunningNoJV(const FormCode: String);
begin
  ClearScript;
  WriteOption;
  ReadOption;
  Script.Add := 'const dsEdit = 2; ';
  Script.Add := 'var RunningNoJV_ON    : String; ';
  Script.Add := '    IncrementHeadingJV: String; ';
  Script.Add := '    tempNumber        : String; '; //JR, BZ 2887
  Script.Add := '    isIncrementThusSameNum : Boolean; ';
  Script.Add := '';
  Script.Add := 'procedure InitializeFieldName; ';
  Script.Add := 'begin ';
  Script.Add := '  if Dataset.ClassName = ''TJVDataset'' then begin ';
  Script.Add := '    RunningNoJV_ON     := ReadOption(''RunningNoJV_ON'', ''0''); ';
  Script.Add := '    IncrementHeadingJV := ReadOption(''IncrementHeadingJV'', ''0''); ';
  Script.Add := '  end ';
  Script.Add := '  else if Dataset.ClassName = ''TOPDataset'' then begin ';
  Script.Add := '    RunningNoJV_ON     := ReadOption(''RunningNoOP_ON'', ''0''); ';
  Script.Add := '    IncrementHeadingJV := ReadOption(''IncrementHeadingOP'', ''0''); ';
  Script.Add := '  end ';
  Script.Add := '  else begin ';
  Script.Add := '    RunningNoJV_ON     := ReadOption(''RunningNoOR_ON'', ''0''); ';
  Script.Add := '    IncrementHeadingJV := ReadOption(''IncrementHeadingOR'', ''0''); ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function GetFieldName:String; ';
  Script.Add := 'begin                         ';
  Script.Add := '  if Dataset.ClassName = ''TJVDataset'' then begin ';
  Script.Add := '    result := format(''JVCounter_%d'', [Dataset.TemplateID.value] );';
  Script.Add := '  end ';
  Script.Add := '  else if Dataset.ClassName = ''TOPDataset'' then begin ';
  Script.Add := '    result := format(''OPCounter_%d'', [Dataset.TemplateID.value] );';
  Script.Add := '  end ';
  Script.Add := '  else begin ';
  Script.Add := '    result := format(''ORCounter_%d'', [Dataset.TemplateID.value] );';
  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'function GetLastTemplateParam:String; ';
  Script.Add := 'begin';
//  Script.Add := '  if Dataset.ClassName = ''TJVDataset'' then begin ';
//  Script.Add := '    result := ''LAST_JV_TEMPLATE_USER_'' + IntToStr(UserID);';
//  Script.Add := '  end ';
//  Script.Add := '  else if Dataset.ClassName = ''TOPDataset'' then begin ';
//  Script.Add := '    result := ''LAST_OP_TEMPLATE_USER_'' + IntToStr(UserID);';
//  Script.Add := '  end ';
//  Script.Add := '  else begin ';
//  Script.Add := '    result := ''LAST_OR_TEMPLATE_USER_'' + IntToStr(UserID);';
//  Script.Add := '  end; ';
  // AA, BZ 2830
  Script.Add := '  if Dataset.ClassName = ''TODDataset'' then begin ';
  Script.Add := '    result := ''LAST_OR_TEMPLATE_USER_'' + IntToStr(UserID);';
  Script.Add := '  end ';
  Script.Add := '  else if Dataset.ClassName = ''TOPDataset'' then begin ';
  Script.Add := '    result := ''LAST_OP_TEMPLATE_USER_'' + IntToStr(UserID);';
  Script.Add := '  end ';
  Script.Add := '  else begin ';
  // GL JV, PE UGL, PE DPR, GL CD, GL CC, GL CR consider as journal voucher type
  Script.Add := '    result := ''LAST_JV_TEMPLATE_USER_'' + IntToStr(UserID);';
  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := '';
  addIncrementNumber( FormCode );
  addisSameFormatNumber('JVNumber', 'IncrementHeadingJV'); //JR, BZ 2992
  addIncrementNo('JVNumber');
  get_save_next_number_script(FormCode);
  addNewRecordLast('JVNumber');
  addTemplateChange('JVNumber');
  Script.Add := 'procedure DoValidateNumber; ';
  Script.Add := '  function IsNumberAlready:Boolean; ';
  Script.Add := '  const';
  Script.Add := '    WHERE_SQL = ''((source=''''%s'''') And (transtype=''''%s'''')) ''; ';
  Script.Add := '  var ';
  Script.Add := '    sql_number : TjbSQL; ';
  Script.Add := '    transactionFilter : string; ';
  Script.Add := '  begin ';
  Script.Add := '    sql_number := CreateSQL( TIBTransaction(Tx) );';
  Script.Add := '    try ';
  Script.Add := '      if Dataset.ClassName = ''TODDataset'' then begin ';
  Script.Add := '        transactionFilter := Format(WHERE_SQL, [''GL'', ''DPT'']);';
  Script.Add := '      end ';
  Script.Add := '      else if Dataset.ClassName = ''TOPDataset'' then begin ';
  Script.Add := '        transactionFilter := Format(WHERE_SQL, [''GL'', ''PMT'']);';
  Script.Add := '      end ';
  Script.Add := '      else begin ';
  // GL JV, PE UGL, PE DPR, GL CD, GL CC, GL CR consider as journal voucher type
  Script.Add := '        transactionFilter := ''('';';
  Script.Add := '        transactionFilter := transactionFilter + Format('' Not ''+WHERE_SQL, [''GL'', ''PMT'']);';
  Script.Add := '        transactionFilter := transactionFilter + Format('' And Not ''+WHERE_SQL, [''GL'', ''DPT'']);';
  Script.Add := '        transactionFilter := transactionFilter + '')'';';
  Script.Add := '      end; ';
  Script.Add := '';
  Script.Add := '      RunSQL( sql_number, Format(''Select JVID from JV where JVNumber=''''%s''''' +
//                         'and JVID <> %d '', ';
//  Script.Add := '       [ Dataset.JVNumber.AsString, Dataset.JVID.AsInteger ]) ); ';
                         'and (JVID<>%d) And %s'', '; // AA, BZ 2830
  Script.Add := '       [ Dataset.JVNumber.AsString, Dataset.JVID.AsInteger, transactionFilter ]) ); ';
  Script.Add := '      result := not sql_number.Eof; ';
  Script.Add := '    finally ';
  Script.Add := '      sql_number.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := 'begin ';
//  Script.Add := '  if Dataset.IsFirstPost then Exit; '; // AA, BZ 2811
  Script.Add := '  if Dataset.IsSynchronization then exit;';
  Script.Add := '  while IsNumberAlready do begin ';
  Script.Add := '    Dataset.JVNumber.AsString := IncrementNumber( Dataset.JVNumber.AsString ); ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  MainSection;
end;

procedure TRunningNumberInjector.addIncrementNumber(const FormCode:String);
begin
  Script.Add := 'function IncrementNumber(const Number:String):String; ';
  Script.Add := 'var Heading:String;';
  Script.Add := '    idx:Integer; ';
  Script.add := 'begin';
  Script.Add := format('  if (IncrementHeading%s = ''1'') then begin ', [FormCode]);
  Script.Add := '    idx := 1;';
  Script.Add := '    Heading := ''''; ';
  Script.Add := '    while (copy(Number,idx,1) in [''0''..''9'']) and (idx <= length(Number)) do begin ';
  Script.Add := '      Heading := Heading + copy(Number,idx,1);';
  Script.Add := '      inc(idx); ';
  Script.Add := '    end; ';
  Script.Add := '    if Heading = '''' then Heading := ''0''; ';
  Script.Add := '    result := IncCtlNumber(Heading);';
  Script.Add := '    if idx < Length(Number) then begin ';
  Script.Add := '      result := result + Copy(Number, idx, Length(Number) - idx + 1);';
  Script.Add := '    end; ';
  Script.Add := '  end ';
  Script.Add := '  else begin ';
  Script.Add := '    result := IncCtlNumber(Number); ';
  Script.Add := '  end; ';
  Script.add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNumberInjector.GetFieldName(FormCode, DatasetName : String);
begin
  Script.Add := 'function GetFieldName:String; ';
  Script.Add := 'begin                         ';
  Script.Add := '  result := format(''' + FormCode + 'Counter_%d'', [' + DatasetName + '.TemplateID.value] );';
  Script.Add := 'end;';
  Script.Add := '';
end;

//procedure TRunningNumberInjector.GetInvoiceNo;
//begin
//  Script.Add := 'function GetInvoiceNo:String; ';
//  Script.Add := 'begin ';
//  Script.Add := '  result := ReadOption(GetFieldName, GetFieldName + ''-00001''); ';
//  Script.Add := 'end;   ';
//  Script.Add := '';
//end;

procedure TRunningNumberInjector.CreateRunningNoScript(const FormCode, InvNoField, IDField, TableName:String;
  transactionIdentifier:string);
begin
  ClearScript;
  ReadOption;
  WriteOption;
  AddConstAndVar( FormCode );
  addIncrementNumber( FormCode );
  GetFieldName( FormCode, 'Dataset' );
  Script.Add := 'var tempNumber : String; '; //JR, BZ 2887
  Script.Add := '    isIncrementThusSameNum : Boolean; ';
  Script.Add := 'function GetLastTemplateParam:String; ';
  Script.Add := 'begin';
  Script.Add := format('  result := ''LAST_%s_TEMPLATE_USER_'' + IntToStr(UserID);', [FormCode]);
  Script.Add := 'end;';
  Script.Add := '';
  addisSameFormatNumber(InvNoField, Format('IncrementHeading%s',[FormCode]) ); //JR, BZ 2992
  addIncrementNo(InvNoField);
  get_save_next_number_script(FormCode);
  addNewRecordLast(InvNoField);
  addTemplateChange(InvNoField);
  Script.Add := 'procedure DoValidateNumber; ';
  Script.Add := '  function IsNumberAlready:Boolean; ';
  Script.Add := '  var sql_number : TjbSQL; ';
  Script.Add := '  begin ';
  Script.Add := '    sql_number := CreateSQL( TIBTransaction(Tx) );';
  Script.Add := '    try ';
  Script.Add := '      RunSQL( sql_number, Format('+Format('''Select %s from %s where %s ', [ IDField, TableName, InvNoField ]) + '= ''''%s'''' ''+ ';
  if (transactionIdentifier<>'') then begin
    Script.Add := Format('               ''and %s '' + ', [transactionIdentifier]); // AA, BZ 2827, 2829, 2830
  end;
  Script.Add := Format('        ''and %s ', [IDField]) + '<> %d '', ';
  Script.Add := Format('       [ Dataset.%s.AsString, Dataset.%s.AsInteger ]) ); ', [ InvNoField, IDField ] );
  Script.Add := '      result := not sql_number.Eof; ';
  Script.Add := '    finally ';
  Script.Add := '      sql_number.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := 'begin ';
//  Script.Add := '  if Dataset.IsFirstPost then Exit; '; JR, turn off to handel BZ 2992
  Script.Add := '  while IsNumberAlready do begin ';
  Script.Add := Format('    Dataset.%s.AsString := IncrementNumber( Dataset.%s.AsString ); ', [ InvNoField, InvNoField ]);
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  InitializeFieldName;';
  Script.Add := format('  if RunningNo%s_ON <> ''1'' then exit; ', [FormCode]);
  Script.Add := '  Dataset.OnBeforePostArray := @BeforePost;          ';
  Script.Add := '  Dataset.OnNewRecordLastArray  := @NewRecordLast;       ';
  Script.Add := '  Dataset.TemplateID.OnChangeArray := @TemplateChange; ';
  Script.Add := '  Dataset.OnBeforePostValidationArray := @DoValidateNumber; ';
  Script.Add := '  NewRecordLast; ';
  Script.Add := 'end.';
end;

procedure TRunningNumberInjector.GenerateScriptForSO;
begin
  CreateRunningNoScript('SO', 'SoNo', 'SOID', 'SO');
end;

procedure TRunningNumberInjector.GenerateScriptForDO;
begin
//  CreateRunningNoScript('DO', 'InvoiceNo', 'ARInvoiceID', 'ARINV');
  CreateRunningNoScript('DO', 'InvoiceNo', 'ARInvoiceID', 'ARINV', '(DeliveryOrder=1)'); // AA, BZ 2827
end;

procedure TRunningNumberInjector.GenerateScriptForSI;
begin
//  CreateRunningNoScript('SI', 'InvoiceNo', 'ARInvoiceID', 'ARINV');
  CreateRunningNoScript('SI', 'InvoiceNo', 'ARInvoiceID', 'ARINV', '(DeliveryOrder=0)'); // AA, BZ 2827
end;

procedure TRunningNumberInjector.GenerateScriptForIA;
begin
  CreateRunningNoScript('IA', 'ADJNO', 'ITEMADJID', 'ITEMADJ');
end;

procedure TRunningNumberInjector.GenerateScriptForIR;
begin
  CreateRunningNoScript('IR', 'TransferNo', 'TransferID', 'IReq');
end;

procedure TRunningNumberInjector.GenerateScriptForIT;
begin
  CreateRunningNoScript('IT', 'TransferNo', 'TransferID', 'WTran');
end;

procedure TRunningNumberInjector.GenerateScriptForSR;
begin
  CreateRunningNoScript('SR', 'InvoiceNo', 'ARRefundID', 'ARRefund');
end;

procedure TRunningNumberInjector.GenerateScriptForCR;
begin
  CreateRunningNoScript('CR', 'SequenceNo', 'PaymentID', 'ARPmt');
end;

procedure TRunningNumberInjector.GenerateScriptForPI;
begin
//  CreateRunningNoScript('PI', 'SEQUENCENO', 'APINVOICEID', 'APINV');
  CreateRunningNoScript('PI', 'SEQUENCENO', 'APINVOICEID', 'APINV', '(Posted=1)'); // AA, BZ 2829
end;

procedure TRunningNumberInjector.GenerateScriptForPO;
begin
  CreateRunningNoScript('PO', 'PoNo', 'POID', 'PO');
end;

procedure TRunningNumberInjector.GenerateScriptForPR;
begin
  CreateRunningNoScript('PR', 'InvoiceNo', 'APReturnID', 'APReturn');
end;

procedure TRunningNumberInjector.GenerateScriptForRI;
begin
//  CreateRunningNoScript('RI', 'SEQUENCENO', 'APINVOICEID', 'APINV');
  CreateRunningNoScript('RI', 'SEQUENCENO', 'APINVOICEID', 'APINV', '(Posted<>1)'); // AA, BZ 2829
end;

procedure TRunningNumberInjector.GenerateScriptForJV;
begin
//  CreateRunningNoScript('JV', 'JVNumber', 'JVID', 'JV');
  createRunningNoJV( 'JV' );
end;

//procedure TRunningNumberInjector.CreateRunningNumberForTxCR(const FormCode:String);
//begin
//  ClearScript;
//  AddVarRunningNoForTx( FormCode );
//  GetFieldName( FormCode, 'Master' );
//  GetInvoiceNo;
//  Script.Add := 'procedure TemplateChange; ';
//  Script.Add := 'begin ';
//  Script.Add := '  if not Master.IsMasterNew then exit;  ';
//  Script.Add := '  Form.AedtSequenceNo.Text := GetInvoiceNo; ';
//  Script.Add := 'end; ';
//  Script.Add := ' ';
//  Script.Add := 'begin ';
//  Script.Add := '  InitializeFieldName; ';
//  Script.Add := format('  if RunningNo%s_ON <> ''1'' then exit; ', [ FormCode ]);
//  Script.Add := '  Master.TemplateID.OnChangeArray := @TemplateChange; ';
//  Script.Add := '  TemplateChange; ';
//  Script.Add := 'end. ';
//end;

procedure TRunningNumberInjector.generateScriptUpdateSequenceNo(const FormCode: String);
begin
  ClearScript;
  AddVarRunningNoForTx( FormCode );
  Script.Add := 'procedure updateView;';
  Script.Add := 'begin';
  Script.Add := '  if (Form.AEdtSequenceNo.Text<>master.sequenceNo.AsString) then begin';
  Script.Add := '    Form.AEdtSequenceNo.Text := master.sequenceNo.AsString;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := '  InitializeFieldName; ';
  Script.Add := format('  if RunningNo%s_ON <> ''1'' then exit; ', [ FormCode ]);
  Script.Add := '  Master.sequenceNo.OnChangeArray := @updateView;';
//  Script.Add := '  updateView;';
  Script.Add := '  Master.templateId.AsInteger := Master.templateId.AsInteger;'; // AA, BZ 3766, trigger running no execution
  Script.Add := 'end. ';
end;

//procedure TRunningNumberInjector.GenerateScriptForTxCR;
//begin
//  CreateRunningNumberForTxCR('CR'); //ditambah script ini agar RN bisa jalan di CR
//end;

procedure TRunningNumberInjector.GenerateScriptForVP;
begin
  CreateRunningNoScript('VP', 'SEQUENCENO', 'CHEQUEID', 'APCHEQ');
end;

procedure TRunningNumberInjector.GenerateScriptForJC;
begin
  CreateRunningNoScript('JC', 'MFNO', 'MFID', 'MFSHT');
end;

procedure TRunningNumberInjector.get_save_next_number_script(const FormCode: String);

  function is_sales_invoice:boolean;
  begin
    result := (FormCode='SI');
  end;

begin
  Script.Add := 'procedure BeforePost;';
  Script.Add := 'begin';
  Script.Add := '  if Dataset.IsSynchronization then exit;';
  if is_sales_invoice then begin // AA, BZ 1684
    Script.Add := '  if (Not Dataset.InvFromSR.AsBoolean) then begin';
    Script.Add := '    IncrementNo;';
    Script.Add := '  end;';
  end
  else begin
    Script.Add := '  IncrementNo;';
  end;
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TRunningNumberInjector.addIncrementNo(fieldName: String);
begin
  Script.Add := 'procedure IncrementNo;';
//  Script.Add := 'Var';
//  Script.Add := '  saved_next_number : string;';
//  Script.Add := '  new_next_number : string;';
  Script.Add := 'begin';
  Script.Add := '  if Dataset.IsMasterNew and (Dataset.State =dsEdit) then begin';
//  Script.Add := '    saved_next_number := GetInvoiceNo;';
//  Script.Add := format('    new_next_number := IncrementNumber(Dataset.%s.value);', [fieldName]);
//  Script.Add := '    While (saved_next_number=new_next_number) do begin';
//  Script.Add := '      new_next_number := IncrementNumber(new_next_number);';
//  Script.Add := '    end;';
//  Script.Add := '    WriteOption( GetFieldName, new_next_number);';
  Script.Add := Format('    if (tempNumber = Dataset.%s.value) or '+
                             '(Dataset.IsMasterNew and NOT isSameFormatNumber) or '+
                             'isIncrementThusSameNum then begin ', [fieldName]);
  Script.Add := Format('      WriteOption( GetFieldName, Dataset.%s.value);', [fieldName]); //JR, BZ2887
  Script.Add := '      WriteOption( GetLastTemplateParam, Dataset.TemplateID.asString); ';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TRunningNumberInjector.addisSameFormatNumber(fieldName, IncrementHeading:String);
begin
  Script.Add := 'function isSameFormatNumber:Boolean; ';
  Script.Add := '  function getFormatNum(Number:String):String; ';
  Script.Add := '  var lengthNum : Integer; ';
  Script.Add := '      idxLength : Integer; ';
  Script.Add := '  begin ';
  Script.Add := '    result := ''''; ';
  Script.Add := '    lengthNum := Length( Number ) -1; ';
  Script.Add := Format('    if (%s = ''1'') then begin ',[IncrementHeading] );
  Script.Add := '      for idxLength := 0 to lengthNum do begin ';
  Script.Add := '        if NOT (copy(Number,idxLength,1) in [''0''..''9'']) then begin ';
  Script.Add := '          result := Copy( Number, idxLength, lengthNum ); ';
  Script.Add := '          Break; ';
  Script.Add := '        end; ';
  Script.Add := '      end; ';
  Script.Add := '    end ';
  Script.Add := '    else begin ';
  Script.Add := '      for idxLength := lengthNum +1 downto 1 do begin ';
  Script.Add := '        if NOT (copy(Number,idxLength,1) in [''0''..''9'']) then begin ';
  Script.Add := '          result := Copy( Number, 1, idxLength ); ';
  Script.Add := '          Break; ';
  Script.Add := '        end; ';
  Script.Add := '      end; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := 'begin ';
  Script.Add := Format('  result := getFormatNum(Dataset.%s.AsString) = getFormatNum(tempNumber); ',[fieldName]);
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TRunningNumberInjector.AddMenuForm(const FormCode:String);
begin
  Script.Add := format('    AddControl( frmSetting, ''Running in %s'',    ''CHECKBOX'', ''RunningNo%s_ON'', StrFalse, ''0'', ''''); ',
    [FormCode, FormCode]);
  Script.Add := format('    AddControl( frmSetting, ''Increment Heading %s'',''CHECKBOX'', ''IncrementHeading%s'', StrFalse, ''0'', ''''); ',
    [FormCode, FormCode]);
end;

procedure TRunningNumberInjector.addNewRecordLast(fieldName: String);
begin

  Script.Add := 'procedure NewRecordLast;';
  Script.Add := '  function GetTemplateID:variant;';
  Script.Add := '  begin ';
  Script.Add := '    result := ReadOption(GetLastTemplateParam, Dataset.TemplateID.asString); ';
  Script.Add := '  end;';
  Script.Add := '  ';
  Script.Add := '  function getNextNumber:String; ';
  Script.Add := '  begin ';
  Script.Add := '    result := IncrementNumber(ReadOption(GetFieldName, GetFieldName + ''-00001'')); ';
  Script.Add := '    tempNumber := result; ';
  Script.Add := '  end; ';
  Script.Add := 'begin';
  Script.Add := '  if Dataset.IsSynchronization then exit;';
  Script.Add := '  isIncrementThusSameNum := False; ';
  Script.Add := '  if GetTemplateID = '''' then exit; ';
  Script.add := '  if not (Dataset.State in [2, 3]) then exit; ';
  Script.Add := '  Dataset.TemplateID.asVariant := GetTemplateID;';
  Script.Add := Format('  Dataset.%s.value := getNextNumber;', [fieldName]); //JR, BZ 2887
  Script.Add := '  DoValidateNumber; '; //JR, BZ 2992
  Script.Add := Format('  isIncrementThusSameNum := tempNumber <> Dataset.%s.value; ', [fieldName]);
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TRunningNumberInjector.addTemplateChange(fieldName: String);
begin
//  GetInvoiceNo;
  Script.Add := 'procedure TemplateChange; ';
  Script.Add := 'begin ';
  Script.Add := '  if not Dataset.IsMasterNew then exit; ';
  Script.Add := '  if Dataset.IsSynchronization then exit;';
//  Script.Add := format('  Dataset.%s.Value := GetInvoiceNo; ',[fieldName]);
  // AA, BZ 3113, 3114
  Script.Add := format('  Dataset.%s.Value := IncrementNumber(ReadOption(GetFieldName, GetFieldName + ''-00001'')); ',[fieldName]);
  Script.Add := '  DoValidateNumber; ';
  Script.Add := 'end; ';
  Script.Add := ' ';
end;

procedure TRunningNumberInjector.MainCreateMenuSetting;
begin
  CreateFormSetting;
  Script.Add := 'procedure ShowSetting; ';
  Script.Add := 'var frmSetting : TForm; ';
  Script.Add := 'begin ';
  Script.Add := '  frmSetting := CreateFormSetting(''frmSetting'', ''Running Number Setting'', 400, 400);';
  Script.Add := '  try ';
  AddMenuForm('SO');
  AddMenuForm('DO');
  AddMenuForm('SI');
  AddMenuForm('SR');
  AddMenuForm('CR');
  AddMenuForm('PR');
  AddMenuForm('IR');
  AddMenuForm('IT');
  AddMenuForm('JV');
  AddMenuForm('OP');
  AddMenuForm('OR');
  AddMenuForm('PO');
  AddMenuForm('RI');
  AddMenuForm('PI');
  AddMenuForm('VP');
  AddMenuForm('JC');
  AddMenuForm('IA');
  Script.Add := '    if frmSetting.ShowModal = mrOK then begin ';
  Script.Add := '      SaveToOptions; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    frmSetting.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure AddMenuSetting;';
  Script.Add := 'var mnuRunningNumber : TMenuItem; ';
  Script.Add := 'begin ';
  Script.Add := '  mnuRunningNumber := TMenuItem(Form.FindComponent( ''mnuRunningNumber'' )); ';
  Script.Add := '  if mnuRunningNumber <> nil then mnuRunningNumber.Free; ';
  Script.Add := '  mnuRunningNumber := TMenuItem.Create( Form );';
  Script.Add := '  mnuRunningNumber.Name := ''mnuRunningNumber'';';
  Script.Add := '  mnuRunningNumber.Caption := ''Setting Running Number'';';
  Script.Add := '  mnuRunningNumber.OnClick := @ShowSetting;';
  Script.Add := '  mnuRunningNumber.Visible := True;';
  Script.Add := '  Form.AmnuEdit.Add( mnuRunningNumber );';
  Script.Add := 'end; ';
  Script.Add := '';

end;

procedure TRunningNumberInjector.GenerateForMain;
begin
  ClearScript;
  MainCreateMenuSetting;
  Script.Add := 'BEGIN';
  Script.Add := '  AddMenuSetting; ';
  Script.Add := 'END.';
end;

procedure TRunningNumberInjector.GenerateScript;
begin
  GenerateForMain;
  InjectToDB( fnMain );

  GenerateScriptForSO;
  InjectToDB( dnSO );

  GenerateScriptForDO;
  InjectToDB( dnDO );

  GenerateScriptForSI;
  InjectToDB( dnSI );

  GenerateScriptForSR;
  InjectToDB( dnSR );

  GenerateScriptForCR;
  InjectToDB( dnCR );

  GenerateScriptForJV;
  InjectToDB( dnJV );

  generateScriptUpdateSequenceNo('VP'); // AA, BZ 3113
  InjectToDB( fnAPCheque );

//  GenerateScriptForTxCr;
  generateScriptUpdateSequenceNo('CR'); // AA, BZ 3114
  InjectToDB( fnARPayment );

  GenerateScriptForIR;
  InjectToDB( dnIR );

  GenerateScriptForPR;
  InjectToDB( dnPR );

  GenerateScriptForIT;
  InjectToDB( dnIT );

  GenerateScriptForPO;
  InjectToDB( dnPO );

  GenerateScriptForRI;
  InjectToDB( dnRI );

  GenerateScriptForPI;
  InjectToDB( dnPI );

  GenerateScriptForVP;
  InjectToDB( dnVP );

  GenerateScriptForJC;
  InjectToDB( dnJC );

  GenerateScriptForIA;
  InjectToDB( dnIA );
end;

initialization
  Classes.RegisterClass( TRunningNumberInjector );

end.
