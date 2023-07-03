unit MCRPInjector;

interface
uses Injector, BankConst, SysUtils, DateUtils, PurchaseRequestInjector;

type
  TMCRPCustomInjector = class(TInjector)
  private
    procedure WhiteSpace;
  end;

  TListAllJournalCashBank = class(TMCRPCustomInjector)  // MMD, BZ 3284
  private
    procedure Vars;
    procedure Consts;
    procedure Models;
    procedure GenerateScriptForMain;
  protected
    procedure set_scripting_parameterize; override;
  public
    procedure GenerateScript; override;
  end;

  TPRDistroUnit1 = class(TPurchaseRequestInjector)  // MMD, BZ 3285
  private
    procedure WhiteSpace;
    //  SCY BZ 3762  Code From Sibalec Kemas
    procedure VarAndConst;
    procedure BeforePostValidation;
    procedure AddProjectFunction; //
  protected
    procedure set_scripting_parameterize; override;
    procedure addGetPRDataForPO; override;
    procedure addMainEventFormPR; override;

    // MMD, BZ 3381
    procedure addFillListPRForPO; override;
    procedure addFillListPRForPOColumn; override;
    procedure addDecorateFrmChooseAdditionalProcedure; override;
    procedure addDecorateFrmChooseAdditionalScript; override;
    procedure addDecorateFrmChooseCreateListViewCol; override;

    procedure addPostClosedPR; override;
    procedure AddConstVar; override;
    procedure generateScriptMainAdditionalOptions; override;  // MMD, BZ 3381
    procedure addConstVarPRList; override;
    procedure addMainListPR; override;
    procedure DoBeforeOpenListPR; override;
    procedure DoClickCboxPR; override;
    procedure addMainFormPO; override;
  end;

  TSearchingCashBankContaining = class(TMCRPCustomInjector)  // MMD, BZ 3302
  private
    procedure GenerateScriptJV;
    procedure GenerateScriptARPmt;
    procedure GenerateScriptAPChq;
    procedure GenerateScriptGLAccSearch;
    procedure GenerateScriptBB;
    procedure GenerateScriptJVs; //MMD, BZ 3303
  protected
    procedure set_scripting_parameterize; override;
  public
    procedure GenerateScript; override;
  end;

  TItemTransferGetRequestRM = class(TMCRPCustomInjector)
  private
    procedure GenerateScriptMain;
    procedure GenerateScriptIT;
  protected
    procedure set_scripting_parameterize; override;
  public
    procedure GenerateScript; override;
  end;


implementation

procedure TListAllJournalCashBank.Vars;
begin
  Script.Add := 'var';
  Script.Add := '  miListAllJournalCashBank  : TMenuItem;';
  Script.Add := '  frmListAllJournalCashBank : TForm;';
  Script.Add := '  pnlFilter                 : TPanel;';
  Script.Add := '  lblFilter                 : TLabel;';
  Script.Add := '  btnFilter                 : TButton;';
  Script.Add := '  lblCashBank               : TLabel;';
  Script.Add := '  cboCashBank               : TComboBox;';
  Script.Add := '  cboBuffCashBank           : TComboBox;';
  Script.Add := '  chkFilterByDate           : TCheckBox;';
  Script.Add := '  lblFromDate               : TLabel;';
  Script.Add := '  dtpFromDate               : TDateTimePicker;';
  Script.Add := '  lblToDate                 : TLabel;';
  Script.Add := '  dtpToDate                 : TDateTimePicker;';
  Script.Add := '  lblSourceNo               : TLabel;';
  Script.Add := '  edtSourceNo               : TEdit;';
  Script.Add := '  dSetList                  : TjvMemoryData;';
  Script.Add := '  dSrcList                  : TDataSource;';
  Script.Add := '  grdList                   : TjbGrid;';
  Script.Add := '  srcList                   : TStringList;';
  WhiteSpace;
end;

procedure TListAllJournalCashBank.Consts;
begin
  Script.Add := 'const';
  Script.Add := '  FORM_CAP     = ''All Journal'';';
  Script.Add := '  CTRL_SPC     = 6;';
  Script.Add := '  CTRL_WIDTH   = 80;';
  Script.Add := '  CTRL_HEIGHT  = 25;';
  Script.Add := '  DATE_FIELD   = ''Date'';';
  Script.Add := '  SOURCE_NO    = ''Source No.'';';
  Script.Add := '  ACCOUNT_NO   = ''Account No.'';';
  Script.Add := '  ACCOUNT_NAME = ''Account Name'';';
  Script.Add := '  DESCRIPTION  = ''Description'';';
  Script.Add := '  DEBET        = ''Debet'';';
  Script.Add := '  CREDIT       = ''Credit'';';
  Script.Add := '  DEPARTMENT   = ''Department'';';
  Script.Add := '  SOURCE       = ''Source'';';
  Script.Add := '  TRANSTYPE    = ''Trans Type'';';
  Script.Add := '  INVOICEID    = ''Invoice ID'';';
  WhiteSpace;
end;

procedure TListAllJournalCashBank.Models;
begin
  Script.Add := 'function GetAllJournal: TjbSQL;';
  Script.Add := 'var';
  Script.Add := '  query : String;';
  Script.Add := '  fromDate : String;';
  Script.Add := '  toDate : String;';
  Script.Add := 'begin';
  Script.Add := '  fromDate := '''';';
  Script.Add := '  toDate   := '''';';
  Script.Add := '  if chkFilterByDate.Checked then begin';
  Script.Add := '    fromDate := DateToStrSQL(dtpFromDate.Date);';
  Script.Add := '    toDate   := DateToStrSQL(dtpToDate.Date);';
  Script.Add := '  end';
  Script.Add := '  else begin';
  Script.Add := '    fromDate := ''01/01/1970'';';
  Script.Add := '    toDate   := DateToStrSQL(Now);';
  Script.Add := '  end;';
  Script.Add := '  Result := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '  query  := Format(''SELECT gh.glaccount nobank, gl.accountname akunbank, ' +
                                            'gh.transdate, gs.sourceno, ' +
                                            'gh2.glaccount nobeban, gl2.accountname akunbeban, gl2.accounttype, ' +
                                            'gh2.transdescription, p.name, gh2.seq, ' +
                                            'gh2.baseamount, COALESCE(dpt.deptname, '''''''') deptname, ' +
                                            'gh.source, gh.transtype, gh.invoiceid ' +
                                     'FROM glhist gh ' +
                                     'LEFT OUTER JOIN glaccnt gl ON gl.glaccount = gh.glaccount ' +
                                     'LEFT OUTER JOIN get_sourceno(gh.glhistid, gh.invoiceid, ' +
                                                                  'gh.fassetid, gh.transtype, ' +
                                                                  'gh.source, gh.seq, 1) gs ' +
                                                     'ON gs.glhistid = gh.glhistid ' +
                                     'LEFT OUTER JOIN glhist gh2 ON gh2.glhistid = gh.glhistid ' +
                                     'LEFT OUTER JOIN glaccnt gl2 ON gl2.glaccount = gh2.glaccount ' +
                                     'LEFT OUTER JOIN persondata p ON p.id = gh2.personid ' +
                                     'LEFT OUTER JOIN department dpt ON dpt.deptid = gh2.deptid ' +
                                     'WHERE gh.transdate BETWEEN ''''%s'''' AND ''''%s'''' ' +
                                           'AND gl.glaccount like ''''%s%s%s'''' ' +
                                           'AND gs.sourceno CONTAINING ''''%s'''' and gl.accounttype = 7 ' +
                                           'AND ((gh.transdescription NOT CONTAINING ''''Proses akhir'''' ) ' +
                                               'OR (gh2.glhistid = gh.glhistid ' +
                                                  'AND (gh2.seq = gh.seq OR gh2.seq = ((CAST((gh.seq + 1) / 3 AS INTEGER) + 1) * 3) - 1) ' +
                                                  'AND (gh2.transdescription CONTAINING ''''Proses akhir'''' ) ' +
                                               ')) ' +
                                           'AND ((gh.transdescription NOT CONTAINING ''''Period End'''' ) ' +
                                               'OR (gh2.glhistid = gh.glhistid ' +
                                                  'AND (gh2.seq = gh.seq or gh2.seq = ((CAST((gh.seq + 1) / 3 AS INTEGER) + 1) * 3) - 1) ' +
                                                  'AND (gh2.transdescription CONTAINING ''''Period End'''' ) ' +
                                               ')) ' +
                                    'GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ' +
                                    'ORDER BY 1, 3, 4, 10'', [fromDate, toDate, ''%'', cboBuffCashBank.Text, ''%'', edtSourceNo.Text]);';
  Script.Add := '  RunSQL(Result, query);';
  Script.Add := 'end;';
  WhiteSpace;
end;

procedure TListAllJournalCashBank.GenerateScriptForMain;
begin
  ClearScript;
  CreateTx;
  AddFunction_CreateSQL;
  add_procedure_runsql;
  CreateMenu;
  CreateForm;
  CreatePanel;
  CreateLabel;
  CreateButton;
  CreateComboBox;
  CreateCheckBox;
  CreatePickDate;
  CreateEditBox;
  CreateGrid;
  TopPos;
  LeftPos;
  LoadCombo;
  Vars;
  Consts;
  Models;
  Script.Add := 'procedure FillData;';
  Script.Add := 'var';
  Script.Add := '  sql       : TjbSQL;';
  Script.Add := '  srcList   : TStringList;';
  Script.Add := '  idxList   : Integer;';
  Script.Add := '  curSrcNo  : String;';
  Script.Add := '  curDesc   : String;';
  Script.Add := '  curDebet  : Currency;';
  Script.Add := '  curCredit : Currency;';
  WhiteSpace;
  Script.Add := '  procedure FormatNumber;';
  Script.Add := '  var ';
  Script.Add := '    idxField : Integer;';
  Script.Add := '  begin';
  Script.Add := '    for idxField := 0 to (dSetList.FieldCount - 1) do begin';
  Script.Add := '      if (dSetList.Fields[idxField] is TFloatField) then begin';
  Script.Add := '        TFloatField (dSetList.Fields[idxField]).DisplayFormat := ''#,##0.##'';';
  Script.Add := '      end;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := '  procedure FillList;';
  Script.Add := '  begin';
  Script.Add := '    sql      := Nil;';
  Script.Add := '    curSrcNo := '''';';
  Script.Add := '    try';
  Script.Add := '      srcList := TStringList.Create;';
  Script.Add := '      sql := GetAllJournal;';
  Script.Add := '      while not sql.EoF do begin';
  Script.Add := '          if (curSrcNo <> sql.FieldByName(''SOURCENO'')) then begin';
  Script.Add := '            srcList.Add(sql.FieldByName(''SOURCENO''));';
  Script.Add := '            curSrcNo := sql.FieldByName(''SOURCENO'');';
  Script.Add := '          end;';
  Script.Add := '        sql.Next;';
  Script.Add := '      end;';
  Script.Add := '    finally';
  Script.Add := '      sql.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := '  procedure AppendInfo;';
  Script.Add := '  begin';
  Script.Add := '    dSetList.Append;';
  Script.Add := '    dSetList.FieldByName(ACCOUNT_NAME).AsString := ''Total of '' + curSrcNo;';
  Script.Add := '    dSetList.FieldByName(DESCRIPTION).AsString  := curDesc;';
  Script.Add := '    dSetList.FieldByName(DEBET).AsCurrency      := curDebet;';
  Script.Add := '    dSetList.FieldByName(CREDIT).AsCurrency     := curCredit;';
  Script.Add := '    dSetList.Post;';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := '  procedure AppendData;';
  Script.Add := '  begin';
  Script.Add := '    dSetList.Append;';
  Script.Add := '    dSetList.FieldByName(DATE_FIELD).AsDateTime := sql.FieldByName(''TRANSDATE'');';
  Script.Add := '    dSetList.FieldByName(SOURCE_NO).AsString    := sql.FieldByName(''SOURCENO'');';
  Script.Add := '    dSetList.FieldByName(ACCOUNT_NO).AsString   := sql.FieldByName(''NoBeban'');';
  Script.Add := '    dSetList.FieldByName(ACCOUNT_NAME).AsString := sql.FieldByName(''AkunBeban'');';
  Script.Add := '    dSetList.FieldByName(DESCRIPTION).AsString  := sql.FieldByName(''TRANSDESCRIPTION'');';
  Script.Add := '    if sql.FieldByName(''BASEAMOUNT'') > 0 then begin';
  Script.Add := '      dSetList.FieldByName(DEBET).AsCurrency    := sql.FieldByName(''BASEAMOUNT'');';
  Script.Add := '      curDebet                                  := curDebet + dSetList.FieldByName(DEBET).AsCurrency;';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      dSetList.FieldByName(CREDIT).AsCurrency   := -1 * sql.FieldByName(''BASEAMOUNT'');';
  Script.Add := '      curCredit                                 := curCredit + dSetList.FieldByName(CREDIT).AsCurrency;';
  Script.Add := '    end;';
  Script.Add := '    dSetList.FieldByName(DEPARTMENT).AsString   := sql.FieldByName(''DEPTNAME'');';
  Script.Add := '    dSetList.FieldByName(SOURCE).AsString       := sql.FieldByName(''SOURCE'');';
  Script.Add := '    dSetList.FieldByName(TRANSTYPE).AsString    := sql.FieldByName(''TRANSTYPE'');';
  Script.Add := '    dSetList.FieldByName(INVOICEID).AsString    := sql.FieldByName(''INVOICEID'');';
  Script.Add := '    dSetList.Post;';
  Script.Add := '    curSrcNo := dSetList.FieldByName(SOURCE_NO).AsString;';
  Script.Add := '    curDesc  := dSetList.FieldByName(DESCRIPTION).AsString;';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := 'begin';
  Script.Add := '  sql       := Nil;';
  Script.Add := '  idxList   := 0;';
  Script.Add := '  curDebet  := 0;';
  Script.Add := '  curCredit := 0;';
  Script.Add := '  FillList;';
  Script.Add := '  try';
  Script.Add := '    sql := GetAllJournal;';
  Script.Add := '    while not sql.EoF do begin';
  Script.Add := '      if srcList[idxList] <> sql.FieldByName(''SOURCENO'') then begin';
  Script.Add := '        AppendInfo;';
  Script.Add := '        dSetList.Append;';
  Script.Add := '        dSetList.Post;';
  Script.Add := '        curDebet  := 0;';
  Script.Add := '        curCredit := 0;';
  Script.Add := '        idxList   := idxList + 1;';
  Script.Add := '      end;';
  Script.Add := '      AppendData;';
  Script.Add := '      sql.Next;';
  Script.Add := '    end;';
  Script.Add := '    if sql.RecordCount > 0 then begin';
  Script.Add := '      AppendInfo';
  Script.Add := '    end;';
  Script.Add := '    FormatNumber;';
  Script.Add := '  finally';
  Script.Add := '    dSetList.First;';
  Script.Add := '    sql.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure CreateFilterListAllJournalCashBank;';
  Script.Add := 'var';
  Script.Add := '  yy, mm, dd  : Word;';
  WhiteSpace;
  Script.Add := '  procedure FilterCashBankChanged;';
  Script.Add := '  begin';
  Script.Add := '    cboBuffCashBank.ItemIndex := cboCashBank.ItemIndex;';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := '  function GetCashBank: TjbSQL;';
  Script.Add := '  var';
  Script.Add := '    query : String;';
  Script.Add := '  begin';
  Script.Add := '    Result := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '    query  := ''SELECT gl.glaccount id, gl.accountname code FROM glaccnt gl WHERE gl.accounttype = 7'';';
  Script.Add := '    RunSQL(Result, query);';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := '  procedure FillFilter;';
  Script.Add := '  var';
  Script.Add := '    sql   : TjbSQL;';
  Script.Add := '  begin';
  Script.Add := '    sql := Nil;';
  Script.Add := '    try';
  Script.Add := '      sql := GetCashBank;';
  WhiteSpace;
  Script.Add := '      cboCashBank.Items.Clear;';
  Script.Add := '      cboCashBank.Items.Add(''<ALL>'');';
  Script.Add := '      cboCashBank.ItemIndex := 0;';
  WhiteSpace;
  Script.Add := '      cboBuffCashBank.Items.Clear;';
  Script.Add := '      cboBuffCashBank.Items.Add(''_'');';
  Script.Add := '      cboBuffCashBank.ItemIndex := 0;';
  WhiteSpace;
  Script.Add := '      while not sql.EoF do begin';
  Script.Add := '        cboCashBank.Items.Add(sql.FieldByName(''code'')); ';
  Script.Add := '        cboBuffCashBank.Items.Add(sql.FieldByName(''id'')); ';
  Script.Add := '        sql.Next;';
  Script.Add := '      end;';
  Script.Add := '    finally';
  Script.Add := '      sql.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := '  procedure FilterData;';
  Script.Add := '  begin';
  Script.Add := '    dSetList.First; ';
  Script.Add := '    while not dSetList.Eof do begin ';
  Script.Add := '      dSetList.Delete; ';
  Script.Add := '    end; ';
  Script.Add := '    FillData;';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := 'begin';
  Script.Add := '  pnlFilter := CreatePanel(CTRL_SPC, CTRL_SPC, frmListAllJournalCashBank.ClientWidth div 6, frmListAllJournalCashBank.ClientHeight - (CTRL_SPC * 3), frmListAllJournalCashBank);';
  Script.Add := '  lblFilter := CreateLabel(CTRL_SPC, (CTRL_SPC * 2), 100, CTRL_HEIGHT, ''FILTER'', pnlFilter);';
  Script.Add := '  lblFilter.Font.Style := fsBold;';
  Script.Add := '  btnFilter := CreateBtn(LeftPos(lblFilter), ' +
                                    'lblFilter.Top - CTRL_SPC, CTRL_WIDTH, CTRL_HEIGHT, ' +
                                    '1, ''&OK'', pnlFilter);';
  WhiteSpace;
  Script.Add := '  lblCashBank             := CreateLabel(CTRL_SPC, TopPos(lblFilter, CTRL_SPC), 100, CTRL_HEIGHT, ''Cash Bank : '', pnlFilter);';
  Script.Add := '  lblCashBank.Font.Style  := fsBold;';
  Script.Add := '  cboCashBank             := CreateComboBox((CTRL_SPC * 2), TopPos(lblCashBank, CTRL_SPC), pnlFilter.Width - (CTRL_SPC * 2), CTRL_HEIGHT, csDropDownList, frmListAllJournalCashBank);';
  Script.Add := '  cboBuffCashBank         := CreateComboBox((CTRL_SPC * 2), TopPos(cboCashBank, CTRL_SPC), pnlFilter.Width - (CTRL_SPC * 2), CTRL_HEIGHT, csDropDownList, frmListAllJournalCashBank);';
  Script.Add := '  cboBuffCashBank.Visible := False;';
  WhiteSpace;
  Script.Add := '  chkFilterByDate         := CreateCheckBox(CTRL_SPC, TopPos(cboCashBank, CTRL_SPC), '+
                                             '100, CTRL_HEIGHT, '+
                                             '''Filter By Date'', pnlFilter);';
  Script.Add := '  chkFilterByDate.Font.Style := fsBold;';
  Script.Add := '  chkFilterByDate.Checked    := True;';
  WhiteSpace;
  Script.Add := '  lblFromDate        := CreateLabel(CTRL_SPC, TopPos(chkFilterByDate, CTRL_SPC), 24, CTRL_HEIGHT, ''From'', pnlFilter);';
  Script.Add := '  dtpFromDate        := CreatePickDate(LeftPos(lblFromDate, CTRL_SPC), lblFromDate.Top - CTRL_SPC, pnlFilter.Width - lblFromDate.Width, CTRL_HEIGHT, pnlFilter);';
  Script.Add := '  dtpFromDate.Format := ''MM/dd/yyyy''; ';
  WhiteSpace;
  Script.Add := '  DecodeDate(Date, yy, mm, dd);';
  Script.Add := '  dtpFromDate.Date := EncodeDate(yy, mm, 1);';
  Script.Add := '  lblToDate        := CreateLabel(CTRL_SPC, TopPos(lblFromDate, CTRL_SPC), 24, CTRL_HEIGHT, ''To'', pnlFilter);';
  Script.Add := '  dtpToDate        := CreatePickDate(LeftPos(lblToDate, CTRL_SPC), lblToDate.Top - CTRL_SPC, pnlFilter.Width - lblToDate.Width, CTRL_HEIGHT, pnlFilter);';
  Script.Add := '  dtpToDate.Format := ''MM/dd/yyyy'';';
  Script.Add := '  dtpToDate.Date   := Now;';
  WhiteSpace;
  Script.Add := '  lblSourceNo  := CreateLabel(CTRL_SPC, TopPos(dtpToDate, (CTRL_SPC * 2)), 100, CTRL_HEIGHT, ''Source No : '', pnlFilter);';
  Script.Add := '  edtSourceNo  := CreateEdit(LeftPos(lblSourceNo, CTRL_SPC), lblSourceNo.Top - CTRL_SPC, CTRL_WIDTH, CTRL_HEIGHT, pnlFilter);';
  Script.Add := '  FillFilter;';
  Script.Add := '  cboCashBank.OnChange := @FilterCashBankChanged;';
  Script.Add := '  btnFilter.OnClick    := @FilterData;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure CreateFormListAllJournalCashBank;';
  Script.Add := 'const';
  Script.Add := '  FORM_WIDTH  = 800;';
  Script.Add := '  FORM_HEIGHT = 600;';
  Script.Add := '  FORM_CAP    = ''List All Journal Cash Bank'';';
  Script.Add := 'begin';
  Script.Add := '  frmListAllJournalCashBank := CreateForm (''frmListAllJournalCashBank'', ' +
                                                             'FORM_CAP, FORM_WIDTH, FORM_HEIGHT);';
  Script.Add := '  frmListAllJournalCashBank.FormStyle := fsMDIChild;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure OpenTransactionForm;';
  Script.Add := 'const';
  Script.Add := '  fnARInvoice     = 3; ';
  Script.Add := '  fnAPCheque      = 8; ';
  Script.Add := '  fnJV            = 16; ';
  Script.Add := '  fnDirectPayment = 17; ';
  Script.Add := '  fnOtherDeposit  = 18; ';

  Script.Add := '  function GetPermission(permissionField : String) : Boolean;';
  Script.Add := '  var';
  Script.Add := '    atx : TIBTransaction;';
  Script.Add := '    sql : TjbSQL;';
  Script.Add := '    qry : String;';
  Script.Add := '  begin';
  Script.Add := '    sql := Nil;';
  Script.Add := '    try';
  Script.Add := '      atx := CreateATx;';
  Script.Add := '      sql := CreateSQL(atx);';
  Script.Add := '      qry := FORMAT(''SELECT %s result FROM users WHERE userid = %d'', [permissionField, UserID]);';
  Script.Add := '      RunSQL(sql, qry);';
  Script.Add := '      if(sql.FieldByName(''result'') = 1) then begin ';
  Script.Add := '        Result := true;';
  Script.Add := '      end;';
  Script.Add := '    finally';
  Script.Add := '      atx.Free;';
  Script.Add := '      sql.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := '  procedure ShowForm(formNumber : Integer ; PermissionField : String);';
  Script.Add := '  begin';
  Script.Add := '    if GetPermission(PermissionField) then begin ';
  Script.Add := '      ShowPybl(formNumber, dSetList.FieldByName(INVOICEID).AsInteger, UserID);';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      RaiseException(''Maaf anda tidak memiliki hak akses untuk membuka form ini.'');';
  Script.Add := '    end;';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := 'begin';
  Script.Add := '  if dSetList.FieldByName(SOURCE).AsString = ''AR'' then begin';
  Script.Add := '    if dSetList.FieldByName(TRANSTYPE).AsString = ''PMT'' then begin';
  Script.Add := '      ShowForm(fnARInvoice, ''cashreceiver'')';
  Script.Add := '    end;';
  Script.Add := '  end';
  Script.Add := '  else if dSetList.FieldByName(SOURCE).AsString = ''AP'' then begin';
  Script.Add := '    if dSetList.FieldByName(TRANSTYPE).AsString = ''CHQ'' then begin';
  Script.Add := '      ShowForm(fnAPCheque, ''makepaymentr'');';
  Script.Add := '    end;';
  Script.Add := '  end';
  Script.Add := '  else if dSetList.FieldByName(SOURCE).AsString = ''GL'' then begin';
  Script.Add := '    if (dSetList.FieldByName(TRANSTYPE).AsString = ''JV'') then begin';
  Script.Add := '      ShowForm(fnJV, ''jvr'');';
  Script.Add := '    end';
  Script.Add := '    else if dSetList.FieldByName(TRANSTYPE).AsString = ''PMT'' then begin';
  Script.Add := '      ShowForm(fnDirectPayment, ''opr'');';
  Script.Add := '    end';
  Script.Add := '    else if dSetList.FieldByName(TRANSTYPE).AsString = ''DPT'' then begin';
  Script.Add := '      ShowForm(fnOtherDeposit, ''odr'');';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure CreateGridListAllJournalCashBank;';
  WhiteSpace;
  Script.Add := '  function IsExtraColumn(ColumnIdx : Integer) : Boolean;';
  Script.Add := '  begin';
  Script.Add := '    Result := (grdList.Columns[ColumnIdx].FieldName = SOURCE) '+
                               'OR (grdList.Columns[ColumnIdx].FieldName = TRANSTYPE) '+
                               'OR (grdList.Columns[ColumnIdx].FieldName = INVOICEID);';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := '  procedure HideExtraCol(grid : TjbGrid; Hide : Boolean);';
  Script.Add := '  var';
  Script.Add := '    ColumnIdx : Integer;';
  Script.Add := '  begin';
  Script.Add := '    for ColumnIdx := 0 to (grid.Columns.Count - 1) do begin';
  Script.Add := '      if Hide then begin';
  Script.Add := '        grid.Columns[ColumnIdx].Visible := NOT IsExtraColumn(ColumnIdx);';
  Script.Add := '      end';
  Script.Add := '      else begin';
  Script.Add := '        grid.Columns[ColumnIdx].Visible := False;';
  Script.Add := '      end;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := 'begin';
  Script.Add := '  dSetList := TJvMemoryData.Create(frmListAllJournalCashBank);';
  Script.Add := '  dSetList.FieldDefs.Add(DATE_FIELD  , ftDate  ,  0, False);';
  Script.Add := '  dSetList.FieldDefs.Add(SOURCE_NO   , ftString, 40, False);';
  Script.Add := '  dSetList.FieldDefs.Add(ACCOUNT_NO  , ftString, 20, False);';
  Script.Add := '  dSetList.FieldDefs.Add(ACCOUNT_NAME, ftString, 60, False);';
  Script.Add := '  dSetList.FieldDefs.Add(DESCRIPTION , ftString, 80, False);';
  Script.Add := '  dSetList.FieldDefs.Add(DEBET       , ftFloat ,  0, False);';
  Script.Add := '  dSetList.FieldDefs.Add(CREDIT      , ftFloat ,  0, False);';
  Script.Add := '  dSetList.FieldDefs.Add(DEPARTMENT  , ftString, 80, False);';
  Script.Add := '  dSetList.FieldDefs.Add(SOURCE      , ftString,  2, False);';
  Script.Add := '  dSetList.FieldDefs.Add(TRANSTYPE   , ftString,  3, False);';
  Script.Add := '  dSetList.FieldDefs.Add(INVOICEID   , ftInteger, 0, False);';
  Script.Add := '  dSetList.Open;';
  WhiteSpace;
  Script.Add := '  dSrcList              := TDataSource.Create(frmListAllJournalCashBank);';
  Script.Add := '  dSrcList.Dataset      := dSetList;';
  Script.Add := '  grdList               := CreateGrid(LeftPos(pnlFilter), CTRL_SPC, frmListAllJournalCashBank.ClientWidth - pnlFilter.Width - (CTRL_SPC * 3), ' +
                                                       'frmListAllJournalCashBank.ClientHeight - (CTRL_SPC * 2), frmListAllJournalCashBank, dSrcList);';
  Script.Add := '  HideExtraCol(grdList, True);';
  Script.Add := '  grdList.OnDblClick    := @OpenTransactionForm;';
  Script.Add := '  grdList.ReadOnly      := True;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure main;';
  WhiteSpace;
  Script.Add := '  procedure FormListAllJournalCashBankResize;';
  Script.Add := '  const';
  Script.Add := '    MIN_WIDTH = 200;';
  Script.Add := '  begin';
  Script.Add := '    pnlFilter.Width  := frmListAllJournalCashBank.ClientWidth div 6;';
  Script.Add := '    if pnlFilter.Width < MIN_WIDTH then begin';
  Script.Add := '      pnlFilter.Width  := MIN_WIDTH;';
  Script.Add := '    end;';
  Script.Add := '    pnlFilter.Height  := frmListAllJournalCashBank.ClientHeight - (CTRL_SPC * 2);';
  Script.Add := '    btnFilter.Width   := pnlFilter.Width - (lblFilter.Width + CTRL_SPC) - (CTRL_SPC * 2);';
  Script.Add := '    cboCashBank.Width := pnlFilter.Width - (CTRL_SPC * 2);';
  Script.Add := '    dtpFromDate.Width := pnlFilter.Width - (lblFromDate.Width + CTRL_SPC) - (CTRL_SPC * 2);';
  Script.Add := '    dtpToDate.Width   := pnlFilter.Width - (lblToDate.Width + CTRL_SPC) - (CTRL_SPC * 2);';
  Script.Add := '    edtSourceNo.Width := pnlFilter.Width - (lblSourceNo.Width + CTRL_SPC) - (CTRL_SPC * 2);';
  Script.Add := '    grdList.Left      := LeftPos(pnlFilter, CTRL_SPC);';
  Script.Add := '    grdList.Width     := frmListAllJournalCashBank.ClientWidth - pnlFilter.Width - (CTRL_SPC * 3);';
  Script.Add := '    grdList.Height    := frmListAllJournalCashBank.ClientHeight - (CTRL_SPC * 2);';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := '  procedure FormListAllJournalCashBankClose(sender:TObject; var Action:TCloseAction);';
  Script.Add := '  begin';
  Script.Add := '    Action := caFree;';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := 'begin';
  Script.Add := '  CreateFormListAllJournalCashBank;';
  Script.Add := '  CreateFilterListAllJournalCashBank;';
  Script.Add := '  CreateGridListAllJournalCashBank;';
  Script.Add := '  frmListAllJournalCashBank.OnResize    := @FormListAllJournalCashBankResize;';
  Script.Add := '  frmListAllJournalCashBank.OnClose     := @FormListAllJournalCashBankClose;';
//  Script.Add := '  Form.mnuRefreshScript.OnClick         := @FormListAllJournalCashBankClose;';
  Script.Add := '  frmListAllJournalCashBank.WindowState := wsMaximized;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'begin';
  Script.Add := '  miListAllJournalCashBank := CreateMenu (0, Form.mnuListGL, ' +
                                                          '''miListAllJournalCashBank'', ' +
                                                          'FORM_CAP, ' +
                                                          '@main);';
  Script.Add := 'end.';
end;

procedure TListAllJournalCashBank.GenerateScript;
begin
  GenerateScriptForMain;
  InjectToDB(fnMain);
end;

procedure TListAllJournalCashBank.set_scripting_parameterize;
begin
  inherited;
  feature_name := 'MCRP Injector';
end;

{ TPRDistroUnit1 }

procedure TPRDistroUnit1.AddConstVar;
begin
  getOptionDistro;
  Script.Add := 'const';
  Script.Add := '  DEFAULT_FROM = ''INFO1'';';
  Script.Add := '  DEFAULT_TO   = ''INFO2'';';
  Script.Add := '  TEMPL_PR     = ''PURCHASE REQUEST'';';
  Script.Add := '  PR_APPROVAL  = ReadOption(''PR_APPROVAL'',  ''CUSTOMFIELD1'');';
  Script.Add := '  PRDET_QTY_PO = ReadOption(''PRDET_QTY_PO'', ''CUSTOMFIELD1'');';
  Script.Add := '  PRDET_CLOSED = ReadOption(''PRDET_CLOSED'', ''CUSTOMFIELD11'');';
  Script.Add := '  PO_APPROVAL  = ''CUSTOMFIELD1'';';
  Script.Add := '  SPACE        = 10;';
  Script.Add := '  BTN_WIDTH    = 100;';
  Script.Add := '  BTN_HEIGHT   = 25;';
  Script.Add := '  USER_PR_APPROVAL_IDENTIFIER = ''APPROVAL PR'';';
  Script.Add := '  USER_PO_APPROVAL_IDENTIFIER = ''APPROVAL PO'';';
  Script.Add := '  UOM_QTY1 = getOptionDistro(1);';
//  Script.Add := '  UOM_QTY1 = ReadOption(''UOM_QTY1'', ''CUSTOMFIELD2'');';
  Script.Add := '  PR_LIST_DETAIL = ReadOption(''PR_LIST_DETAIL'', ''0'');';
  Script.Add := 'var';
  Script.Add := '  PODET_PRNO   : String;';
  Script.Add := '  PODET_PRID   : String;';
  Script.Add := '  PODET_PRSEQ  : String;';
  Script.Add := '  isRecurring  : Boolean;';
  Script.Add := '  DescSort     : Boolean;';
  Script.Add := '  SortedColumn : Integer;';
  WhiteSpace;
end;

procedure TPRDistroUnit1.addDecorateFrmChooseAdditionalProcedure;
begin
  Script.Add := '  procedure FrmChooseShow;';
  Script.Add := '  begin';
  Script.Add := '    FrmChoose.Width  := 800;';
  Script.Add := '    FrmChoose.Height := 600;';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := '  procedure ComparePR(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);';
  Script.Add := '  begin';
  Script.Add := '     case SortedColumn of';
  Script.Add := '      0 : Compare := CompareText (Item1.Caption,Item2.Caption);';
  Script.Add := '      1 : Compare := CompareDateTime (StrSQLToDate (Item1.SubItems[(SortedColumn - 1)]) '+
                                      ', StrSQLToDate (Item2.SubItems[(SortedColumn - 1)]) );';
  Script.Add := '      else Compare := CompareText(Item1.SubItems[(SortedColumn - 1)], Item2.SubItems[(SortedColumn - 1)]);';
  Script.Add := '    end;';
  WhiteSpace;
  Script.Add := '    if DescSort then begin';
  Script.Add := '      Compare := -Compare;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := '  procedure SortPRList(Sender: TObject; Column: TListColumn);';
  Script.Add := '  begin';
  Script.Add := '    TListView(Sender).SortType := stNone;';
  Script.Add := '    if (Column.Index = SortedColumn) then begin';
  Script.Add := '      DescSort := NOT DescSort;';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      SortedColumn := Column.Index;';
  Script.Add := '      DescSort     := False;';
  Script.Add := '    end;';
  Script.Add := '    TListView(Sender).SortType := stText;';
  Script.Add := '  end;';
  WhiteSpace;
end;

procedure TPRDistroUnit1.addDecorateFrmChooseAdditionalScript;
begin
  Script.Add := '  listPR.OnColumnClick := @SortPRList;';
  Script.Add := '  listPR.OnCompare     := @ComparePR;';
  Script.Add := '  if PR_LIST_DETAIL = ''1'' then begin';
  Script.Add := '    FrmChoose.OnShow := @FrmChooseShow;';
  Script.Add := '  end;';
end;

procedure TPRDistroUnit1.addDecorateFrmChooseCreateListViewCol;
begin
  Script.Add := 'if PR_LIST_DETAIL = ''1'' then begin';
  Script.Add := '  CreateListViewCol(listPR, ''PR No'', -1);';
  Script.Add := '  CreateListViewCol(listPR, ''Date'', -1);';
  Script.Add := '  CreateListViewCol(listPR, ''Item No '', -1);';
  Script.Add := '  CreateListViewCol(listPR, ''Seq '', -2);';
  Script.Add := '  CreateListViewCol(listPR, ''Item Desc'', 200);';
  Script.Add := '  CreateListViewCol(listPR, ''Qty Outstanding'', -2);';
  Script.Add := '  CreateListViewCol(listPR, ''Description'', 200);';
  Script.Add := 'end';
  Script.Add := 'else begin';
  Script.Add := '  CreateListViewCol(listPR, ''PR No'', 150);';
  Script.Add := '  CreateListViewCol(listPR, ''Date'', 200);';
  Script.Add := '  CreateListViewCol(listPR, ''Description'', 200);';
  Script.Add := 'end; ';
  WhiteSpace;
end;

procedure TPRDistroUnit1.addFillListPRForPO;
begin
  Script.Add := 'procedure FillListPRForPO;';
  Script.Add := 'var';
  Script.Add := '  listItem : TListItem;';
  Script.Add := '  sql      : TjbSQL; ';
  Script.Add := '  txtSQL   : String; ';
  WhiteSpace;

  Script.Add := 'function GetJoinQuery: string;';  //SCY BZ 3765
  Script.Add := 'begin';
  Script.Add := '  Result := ''JOIN Extended E on E.ExtendedID = W.ExtendedID '+
                             'JOIN Template Tem on Tem.TemplateID = W.TemplateID '+
                             'JOIN ireqdet ird ON w.transferid = ird.transferid '+
                             'JOIN extended eirq ON eirq.EXTENDEDID = ird.extendedid '';';
  Script.Add := 'end;';
  WhiteSpace;

  Script.Add := 'function GetQueryFilter: string;';  //SCY BZ 3765
  Script.Add := 'begin';
  Script.Add := '  Result := Format('' WHERE COALESCE(E.%s, ''''0'''') = ''''1'''' '' + ';
  Script.Add := '            Format(''   AND Tem.Name containing ''''%s'''' '', [TEMPL_PR]) + ';
  //SCY BZ 3765 Change GET QTY Method from on-the-fly calculation to Accumulator Field Comparison.
//  Script.Add := '            ''AND W.TRANSFERID IN ( '+
//                              'Select Distinct WDCOM.TransferID FROM '+
//                              '(Select WD.TRANSFERID, WD.SEQ, WD.QUANTITY '+
//                              'from IREQDET wd left join EXTENDED ewd on ewd.EXTENDEDID=wd.EXTENDEDID '+
//                              'where COALESCE(ewd.%s, ''''0'''') <> ''''1'''') wdcom '+
//                              'LEFT JOIN '+
//                              '(select pd.%s PRID, pd.%s PRSeq, pd.QUANTITY from PODET pd '+
//                              'where pd.%s is not NULL '+
//                              'and pd.%s is not NULL) COM '+
//                              'ON (COM.PRID=WDCOM.TransferID and COM.PRSEQ=WDCOM.SEQ) '+
//                              'where WDCOM.Quantity-Coalesce(COM.Quantity, 0) > 0 '+
//                             ') ''+';
//  Script.Add := '            '' ORDER BY W.TRANSFERID DESC'' '+
//                             ', [PR_APPROVAL, PRDET_CLOSED, PODET_PRID, PODET_PRSEQ, PODET_PRID, PODET_PRSEQ]); ';

  Script.Add := '            ''AND (EIRQ.%s = 0 OR EIRQ.%s IS NULL) '+
                             'AND IRD.QUANTITY > IIF(EIRQ.%s IS NULL, 0, CAST(EIRQ.%s AS numeric (18,4) ) ) '' +';
  Script.Add := '            '' ORDER BY W.TRANSFERDATE, W.TRANSFERNO, IRD.SEQ'' '+
                             ', [PR_APPROVAL, PRDET_CLOSED, PRDET_CLOSED, PRDET_QTY_PO, PRDET_QTY_PO]); ';
  Script.Add := 'end;';
  WhiteSpace;

  Script.Add := 'begin';
  Script.Add := '  listPR.Items.Clear; ';
  Script.Add := '  sql    := CreateSQL(TIBTransaction(Detail.Tx)); ';
  Script.Add := '  if PR_LIST_DETAIL = ''1'' then begin';
  Script.Add := '    txtSQL := Format( ''SELECT DISTINCT W.TRANSFERNO, W.TRANSFERDATE, COALESCE(W.DESCRIPTION, '''''''') DESCRIPTION, '' + ';
  Script.Add := '                      ''W.TRANSFERID, ird.itemno, ird.seq, ird.itemdescription, ird.quantity, '' + ';
  Script.Add := '                      ''COALESCE(eirq.%s, ''''0'''') %s, COALESCE(eirq.%s, ''''0'''') %s '' + ';
  Script.Add := '                      ''  FROM IREQ W '' + ';
  Script.Add := '                      GetJoinQuery + ';
  Script.Add := '                      GetQueryFilter '+
                                       ', [PRDET_QTY_PO, PRDET_QTY_PO, PRDET_CLOSED, PRDET_CLOSED]);';
  Script.Add := '  end';
  Script.Add := '  else begin';
  Script.Add := '    txtSQL :=         ''SELECT DISTINCT W.TRANSFERNO, W.TRANSFERDATE, COALESCE(W.DESCRIPTION, '''''''') DESCRIPTION '' + ';
  Script.Add := '                      ''  FROM IREQ W '' + ';
  Script.Add := '                      GetJoinQuery + ';
  Script.Add := '                      GetQueryFilter;';
  Script.Add := '  end;';
  Script.Add := '  try';
  Script.Add := '    RunSQL(sql, txtSQL);';
  Script.Add := '    listPR.Items.BeginUpdate;';  //SCY BZ 3765
  Script.Add := '    while not sql.EOF do begin';
  addFillListPRForPOColumn;
  Script.Add := '      sql.Next;';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '    listPR.Items.EndUpdate;';  //SCY BZ 3765
  Script.Add := '  end;';
  Script.Add := 'end;';
  WhiteSpace;
end;

procedure TPRDistroUnit1.addFillListPRForPOColumn;
begin
  Script.Add := '      if PR_LIST_DETAIL = ''1'' then begin';
  Script.Add := '        if sql.FieldByName(PRDET_CLOSED) = ''0'' then begin';
  Script.Add := '          listItem         := listPR.Items.Add;';
  Script.Add := '          listItem.Caption := sql.FieldByName(''TransferNo'');';
  Script.Add := '          listItem.SubItems.Add( sql.FieldByName(''TransferDate''));';
  Script.Add := '          listItem.SubItems.Add(sql.FieldByName(''ItemNo''));';
  Script.Add := '          listItem.SubItems.Add(sql.FieldByName(''Seq''));';
  Script.Add := '          listItem.SubItems.Add(sql.FieldByName(''ItemDescription''));';
  Script.Add := '          listItem.SubItems.Add(sql.FieldByName(''Quantity'') - sql.FieldByName(PRDET_QTY_PO));';
  Script.Add := '          listItem.SubItems.Add(sql.FieldByName(''Description''));';
  Script.Add := '        end;';
  Script.Add := '      end';
  Script.Add := '      else begin';
  Script.Add := '        listItem         := listPR.Items.Add;';
  Script.Add := '        listItem.Caption := sql.FieldByName(''TransferNo'');';
  Script.Add := '        listItem.SubItems.Add(sql.FieldByName(''TransferDate''));';
  Script.Add := '        listItem.SubItems.Add(sql.FieldByName(''Description''));';
  Script.Add := '      end;';
end;

procedure TPRDistroUnit1.addGetPRDataForPO;
begin
  Script.Add := 'procedure GetPRDataForPO; ';
  Script.Add := '  const';
  Script.Add := '      IDX_SEQ     = 2; ';
  WhiteSpace;
  Script.Add := '  var i           : Integer; ';
  Script.Add := '      SelectedPR  : String; ';
  Script.Add := '      SelectedSeq : Integer; ';
  Script.Add := '      sql         : TjbSQL; ';
  Script.Add := '      ItemResv1   : String; ';
  WhiteSpace;
  Script.Add := '  function GetSQL:String; ';
  Script.Add := '  begin';
  Script.Add := '    result := Format( ''SELECT A.*, (QUANTITY-QTY_RCV) QTY_REMAIN '' + ';
  Script.Add := '                      ''  FROM ( '' + ';
  Script.Add := '                      ''        select W.TRANSFERID, W.TRANSFERNO, WD.ITEMNO, WD.Seq, WD.ITEMUNIT, '' + ';
  Script.Add := '                      ''               WD.UnitPrice, WD.ItemDescription, WD.QUANTITY, '' + ';
  Script.Add := '                      ''               COALESCE(SUM(PD.QUANTITY), 0) QTY_RCV '' + ';
  Script.Add := '                      ''             , COALESCE(CAST(WD.ITEMRESERVED1 AS VARCHAR(1000) ), '''''''') ITEMRESERVED1 '' + ';
  Script.Add := '                      ''          from IREQ W '' + ';
  Script.Add := '                      ''               join IREQDET WD on WD.TRANSFERID = W.TRANSFERID '' + ';
  Script.Add := '                      ''               LEFT JOIN EXTENDED EWD on EWD.EXTENDEDID = WD.EXTENDEDID '' + ';
  Script.Add := '                      ''               LEFT JOIN '' + ';
  Script.Add := '                      ''               ( '' + ';
  Script.Add := '                      ''                SELECT PD.%s PRID, PD.%s PRSEQ, PD.QUANTITY '' + ';
  Script.Add := '                      ''                  FROM PODET PD '' + ';
  Script.Add := '                      ''                 WHERE PD.%s IS NOT NULL '' + ';
  Script.Add := '                      ''                   AND PD.%s IS NOT NULL '' + ';
  Script.Add := '                      ''               ) PD ON (WD.TRANSFERID = PD.PRID AND WD.SEQ = PD.PRSEQ) '' + ';
  Script.Add := '                      ''         where W.TRANSFERNO in (%s) '' + ';
  Script.Add := '                      ''           AND COALESCE(EWD.%s, ''''0'''') <> ''''1'''' '' + ';
  Script.Add := '                      ''         GROUP BY W.TRANSFERID, W.TRANSFERNO, WD.ITEMNO, WD.Seq, WD.ITEMUNIT, '' + ';
  Script.Add := '                      ''                  WD.UnitPrice, WD.ItemDescription, WD.QUANTITY '' + ';
  Script.Add := '                      ''                , WD.ITEMRESERVED1 '' + ';
  Script.Add := '                      ''       ) A '' + ';
  Script.Add := '                      '' WHERE ((QUANTITY - QTY_RCV) > 0) Order by A.TRANSFERID, A.Seq'', '+
                                       '[PODET_PRID, PODET_PRSEQ, PODET_PRID, PODET_PRSEQ, SelectedPR, PRDET_CLOSED] ); ';
  Script.Add := '  end; ';
  WhiteSpace;
  Script.Add := '  function GetSQLDetail : String;';
  Script.Add := '  begin';
  Script.Add := '    result := Format( ''SELECT A.*, (QUANTITY-QTY_RCV) QTY_REMAIN '' + ';
  Script.Add := '                      ''  FROM ( '' + ';
  Script.Add := '                      ''        select W.TRANSFERID, W.TRANSFERNO, WD.ITEMNO, WD.Seq, WD.ITEMUNIT, '' + ';
  Script.Add := '                      ''               WD.UnitPrice, WD.ItemDescription, WD.QUANTITY, '' + ';
  Script.Add := '                      ''               COALESCE(SUM(PD.QUANTITY), 0) QTY_RCV '' + ';
  Script.Add := '                      ''             , COALESCE(CAST(WD.ITEMRESERVED1 AS VARCHAR(1000) ), '''''''') ITEMRESERVED1 '' + ';
  Script.Add := '                      ''          from IREQ W '' + ';
  Script.Add := '                      ''               join IREQDET WD on WD.TRANSFERID = W.TRANSFERID '' + ';
  Script.Add := '                      ''               LEFT JOIN EXTENDED EWD on EWD.EXTENDEDID = WD.EXTENDEDID '' + ';
  Script.Add := '                      ''               LEFT JOIN '' + ';
  Script.Add := '                      ''               ( '' + ';
  Script.Add := '                      ''                SELECT PD.%s PRID, PD.%s PRSEQ, PD.QUANTITY '' + ';
  Script.Add := '                      ''                  FROM PODET PD '' + ';
  Script.Add := '                      ''                 WHERE PD.%s IS NOT NULL '' + ';
  Script.Add := '                      ''                   AND PD.%s IS NOT NULL '' + ';
  Script.Add := '                      ''               ) PD ON (WD.TRANSFERID = PD.PRID AND WD.SEQ = PD.PRSEQ) '' + ';
  Script.Add := '                      ''         where W.TRANSFERNO = ''''%s'''' '' + ';
  Script.Add := '                      ''           AND WD.Seq = %d '' + ';
  Script.Add := '                      ''           AND COALESCE(EWD.%s, ''''0'''') <> ''''1'''' '' + ';
  Script.Add := '                      ''         GROUP BY W.TRANSFERID, W.TRANSFERNO, WD.ITEMNO, WD.Seq, WD.ITEMUNIT, '' + ';
  Script.Add := '                      ''                  WD.UnitPrice, WD.ItemDescription, WD.QUANTITY '' + ';
  Script.Add := '                      ''                , WD.ITEMRESERVED1 '' + ';
  Script.Add := '                      ''       ) A '' + ';
  Script.Add := '                      '' WHERE ((QUANTITY - QTY_RCV) > 0) Order by A.TRANSFERID, A.Seq'', '+
                                       '[PODET_PRID, PODET_PRSEQ, PODET_PRID, PODET_PRSEQ, SelectedPR, SelectedSeq, PRDET_CLOSED] ); ';
  Script.Add := '  end; ';
  WhiteSpace;
  Script.Add := '  function FormatItemResv1(ItemResv1String : String) : String;';
  Script.Add := '  begin';
  Script.Add := '    while Copy(ItemResv1String, 1, Pos(#13, ItemResv1String) -1) <> '''' do begin';
  Script.Add := '      Result := Result + Copy(ItemResv1String, 1, Pos(#13, ItemResv1String) - 1) + #13#10;';
  Script.Add := '      Delete(ItemResv1String, 1, Pos(#13, ItemResv1String) + Length(#13) - 1);';
  Script.Add := '    end;';
  Script.Add := '    Result := Result + ItemResv1String;';
  Script.Add := '  end; ';
  WhiteSpace;
  Script.Add := '  procedure AppendPODetail;';
  Script.Add := '  begin';
  Script.Add := '    Detail.Append; ';
  Script.Add := '    Detail.ItemNO.value         := sql.FieldByName(''ItemNo''); ';
  Script.Add := '    Detail.ItemOvDesc.value     := sql.FieldByName(''ItemDescription''); ';
  Script.Add := '    Detail.Quantity.value       := sql.FieldByName(''Qty_Remain''); ';
  Script.Add := '    Detail.ItemUnit.value       := sql.FieldByName(''ItemUnit''); ';
  Script.Add := '    Detail.BrutoUnitPrice.value := sql.FieldByName(''UnitPrice''); ';
  Script.Add := '    Detail.FieldByName(PODET_PRID).value  := sql.FieldByName(''TransferID''); ';
  Script.Add := '    Detail.FieldByName(PODET_PRSEQ).value := sql.FieldByName(''Seq''); ';
  Script.Add := '    Detail.ExtendedID.FieldLookup.FieldByName(PODET_PRNO).value    := sql.FieldByName(''TransferNo'');';
  Script.Add := '    if Detail.ExtendedID.FieldLookup.FieldByName(UOM_QTY1).IsNull then begin';  //MMD, BZ 3383, Fix BZ 3390
  Script.Add := '      Detail.ExtendedID.FieldLookup.FieldByName(UOM_QTY1).AsCurrency := sql.FieldByName(''QTY_REMAIN'');';
  Script.Add := '    end;';
  Script.Add := '    Detail.ItemReserved1.AsString := FormatItemResv1(sql.FieldByName(''ITEMRESERVED1''));';
  Script.Add := '    Detail.Post;';
  Script.Add := '  end; ';
  WhiteSpace;
  Script.Add := 'begin ';
  Script.Add := '  SelectedPR := ''''; ';
  Script.Add := '  SelectedSeq := 0; ';
  Script.Add := '  ItemResv1 := ''''; ';
  Script.Add := '  for i:= 0 to listPR.Items.Count-1 do begin';
  Script.Add := '    if listPR.Items[i].Checked then begin ';
  Script.Add := '      if PR_LIST_DETAIL = ''1'' then begin';
  Script.Add := '        SelectedPR  := listPR.Items[i].Caption;';
  Script.Add := '        SelectedSeq := StrToInt(listPR.Items[i].SubItems[IDX_SEQ]);';
  WhiteSpace;
  Script.Add := '        if SelectedPR = '''' then exit; ';
  Script.Add := '        sql := CreateSQL(TIBTransaction(Detail.Tx));';
  Script.Add := '        try';
  Script.Add := '          RunSQL(sql, GetSQLDetail);';
  Script.Add := '          while not sql.EOF do begin';
  Script.Add := '            AppendPODetail;';
  Script.Add := '            sql.Next;';
  Script.Add := '          end;';
  Script.Add := '        finally';
  Script.Add := '          sql.Free;';
  Script.Add := '        end; ';
  Script.Add := '      end';
  Script.Add := '      else begin';
  Script.Add := '        if SelectedPR <> '''' then SelectedPR := SelectedPR + '','';';
  Script.Add := '        SelectedPR := SelectedPR + '''''''' + listPR.Items[i].Caption + '''''''';';
  Script.Add := '      end;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := '  if PR_LIST_DETAIL = ''0'' then begin';
  Script.Add := '    if SelectedPR = '''' then exit;';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Detail.Tx));';
  Script.Add := '    try';
  Script.Add := '      RunSQL(sql, GetSQL);';
  Script.Add := '      while not sql.EOF do begin';
  Script.Add := '        AppendPODetail;';
  Script.Add := '        sql.Next;';
  Script.Add := '      end; ';
  Script.Add := '    finally';
  Script.Add := '      sql.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  WhiteSpace;
end;

procedure TPRDistroUnit1.AddProjectFunction;
begin
  AddFunction_CreateSQL;
  add_procedure_runsql;
  CreateForm;
  CreateButton;
  CreateListView;
  DetailExtended;
  ReadOption;
  VarAndConst;

  Script.Add := 'function GetProjectGridIndex : Integer;';
  Script.Add := 'var';
  Script.Add := '  idxGrid : Integer;';
  Script.Add := 'const';
  Script.Add := '  PROJECT_NAME = ''PROJECT'';';
  Script.Add := 'begin';
  Script.Add := '  Result := -1;';
  Script.Add := '  for idxGrid := 0 to (Form.DBGrid1.Columns.Count - 1) do begin';
  Script.Add := '    if (UpperCase(Form.DBGrid1.columns[idxGrid].Title.Caption) = PROJECT_NAME) then begin';
  Script.Add := '      Result := idxGrid;';
  Script.Add := '      Break;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  WhiteSpace;

  Script.Add := 'procedure ShowSearchProject;';
  Script.Add := 'begin';
  Script.Add := '  if (Form.DBGrid1.SelectedIndex = GetProjectGridIndex) then begin';
  Script.Add := '    SearchProject(TIBTransaction(Tx), Detail, DetailExtended(GetProjectNOField), DetailExtended(GetProjectIDField) );';
  Script.Add := '  end;';
  Script.Add := 'end;';
  WhiteSpace;

  Script.Add := 'procedure CreateProjectComboBox;';
  Script.Add := 'begin';
  Script.Add := '  Form.DBGrid1.Columns[GetProjectGridIndex].ButtonStyle := cbsEllipsis;';
  Script.Add := '  Form.DBGrid1.OnEditButtonClickArray                   := @ShowSearchProject;';
  Script.Add := 'end;';
  WhiteSpace;
end;

procedure TPRDistroUnit1.addMainEventFormPR;
begin
  AddProjectFunction;

  Script.Add := 'procedure SetRecurringTrue; ';
  Script.Add := 'begin ';
  Script.Add := '  isRecurring := True;';
  Script.Add := 'end; ';
  WhiteSpace;
  Script.Add := 'procedure SetRecurringFalse; ';
  Script.Add := 'begin ';
  Script.Add := '  isRecurring := False;';
  Script.Add := 'end; ';
  WhiteSpace;
  Script.Add := 'procedure FillUOMQTY; ';
  Script.Add := 'begin ';
  Script.Add := '  Detail.ExtendedID.FieldLookup.FieldByName(UOM_QTY1).AsCurrency := 0;';
  Script.Add := 'end; ';
  WhiteSpace;
  Script.Add := 'function NeedToLockUsedPRMaster(IRSeq: Integer = -1): Boolean;';
  Script.Add := 'var';
  Script.Add := '  sql   : TjbSQL;';
  Script.Add := '  query : String;';
  Script.Add := 'begin ';
  Script.Add := '  sql := Nil;';
  Script.Add := '  try';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '    query := Format(''SELECT COALESCE(extended.%s, 0) %s ' +
                                      'FROM   ireq ' +
                                             'JOIN ireqdet ' +
                                               'ON ireq.transferid = ireqdet.transferid ' +
                                             'JOIN extended ' +
                                               'ON ireqdet.extendedid = extended.extendedid ' +
                                      'WHERE  ireq.transferid = %d '', [PRDET_QTY_PO, PRDET_QTY_PO, Master.TRANSFERID.AsInteger]);';
  Script.Add := '    if (IRSeq > -1) then begin';  //SCY BZ 3795
  Script.Add := '      query := query + Format(''and ireqdet.seq = %d'', [IRSeq]);';
  Script.Add := '    end;';
  Script.Add := '    RunSQL(sql, query);';

  Script.Add := '    if NOT sql.EOF then begin';  //SCY BZ 3795
  Script.Add := '      if (IRSeq > -1) then begin';  //SCY BZ 3795
  Script.Add := '        if (sql.FieldByName(PRDET_QTY_PO) >= Detail.Quantity.AsCurrency) then begin';
  Script.Add := '          Result := True;';
  Script.Add := '        end;';
  Script.Add := '      end';
  Script.Add := '      else begin';
  Script.Add := '        while not sql.EoF do begin';
  Script.Add := '          if (sql.FieldByName(PRDET_QTY_PO) > 0) then begin';
  Script.Add := '            Result := True;';
  Script.Add := '            Break;';
  Script.Add := '          end;';
  Script.Add := '          sql.Next;';
  Script.Add := '        end;';
  Script.Add := '      end;';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  end;';
  Script.Add := 'end; ';

  WhiteSpace;
  Script.Add := 'procedure ValidateClosedPRDetail;';
  Script.Add := 'begin';
  Script.Add := '  if NeedToLockUsedPRMaster(Detail.Seq.AsInteger) then begin';
  Script.Add := '    RaiseException(''Can not modify purchase order'');';
  Script.Add := '  end;';
  Script.Add := 'end;';

  WhiteSpace;
  Script.Add := 'procedure LockMasterPanel;';
  Script.Add := 'var';
  Script.Add := '  CanEdit: Boolean;';
  Script.Add := 'begin';
  Script.Add := '  CanEdit := NOT NeedToLockUsedPRMaster;';
  Script.Add := '  Form.pnlHeader.Enabled     := CanEdit;';
  Script.Add := '  Form.pnlFooterLeft.Enabled := CanEdit;';
  Script.Add := '  Form.pnlRightTop.Enabled   := CanEdit;';
  Script.Add := 'end;';

  WhiteSpace;
  Script.Add := 'begin ';
  Script.Add := '  SetRecurringTrue;';
  Script.Add := '  loadSetting; ';
  Script.Add := '  ResetStatus; ';
  Script.Add := '  AddBtn_Approve; ';
  Script.Add := '  SetWarehouseID; ';
  Script.Add := '  CreateTimer; ';
  Script.Add := '  SetLocking; ';
  Script.Add := '  Master.OnAfterOpenArray         := @SetLocking; ';
  Script.Add := '  Master.OnNewRecordArray         := @CreateTimer; ';
  Script.Add := '  Master.TemplateID.OnChangeArray := @SetWarehouseID; ';
  Script.Add := '  Master.OnAfterCloseArray        := @ResetStatus; ';
  Script.Add := '  Detail.OnBeforeEditArray        := @SetRecurringFalse; ';
  Script.Add := '  Detail.OnAfterInsertArray       := @FillUOMQTY; ';
  Script.Add := '  Detail.OnAfterPostArray         := @SetRecurringTrue; ';

//  Script.Add := '  Master.OnBeforeEditArray        := @LockUsedPRMaster;';  //SCY BZ 3795
  Script.Add := '  Form.layout_from_script         := @LockMasterPanel;';  //SCY BZ 3795
  Script.Add := '  Detail.OnBeforeEditArray        := @ValidateClosedPRDetail;';  //SCY BZ 3795

  Script.Add := '  Form.DBGrid1.OnEnter            := @CreateProjectComboBox;';  //  SCY BZ 3762
  Script.Add := '  TExtendedDetLookupField( Detail.ExtendedID.FieldLookup.FieldByName(PRDET_CLOSED) ).OnChangeArray := @PostClosedPR; ';
  Script.Add := '  TExtendedDetLookupField( Master.ExtendedID.FieldLookup.FieldByName(PR_APPROVAL) ).OnChangeArray  := @DenyChangeApprovalPR; ';
  Script.Add := 'end. ';
end;

procedure TPRDistroUnit1.addPostClosedPR;
begin
  Script.Add := 'procedure PostClosedPR; ';
  Script.Add := 'begin ';
  Script.Add := '  if isRecurring then exit;';
  Script.Add := '  Detail.Post; ';
  Script.Add := 'end; ';
  WhiteSpace;
end;

procedure TPRDistroUnit1.generateScriptMainAdditionalOptions;
begin
  Script.Add := '    AddControl(frm, ''PR Approval''        , ''CUSTOMFIELD'', ''PR_APPROVAL''        , ''CUSTOMFIELD1'' , ''0'', '''');';
  Script.Add := '    AddControl(frm, ''PR Det QTY PO''      , ''CUSTOMFIELD'', ''PRDET_QTY_PO''       , ''CUSTOMFIELD1'' , ''0'', '''');';
  Script.Add := '    AddControl(frm, ''PR Det Closed''      , ''CUSTOMFIELD'', ''PRDET_CLOSED''       , ''CUSTOMFIELD11'', ''0'', '''');';
  Script.Add := '    AddControl(frm, ''List Detail''        , ''CHECKBOX''   , ''PR_LIST_DETAIL''     , ''0''            , ''0'', '''');';
  Script.Add := '    AddControl(frm, ''IR Project ID Field'', ''CUSTOMFIELD'', ''IR_PROJECT_ID_FIELD'', ''CUSTOMFIELD3'', ''0'', '''');';  //  SCY BZ 3762
  Script.Add := '    AddControl(frm, ''IR Project NO Field'', ''CUSTOMFIELD'', ''IR_PROJECT_NO_FIELD'', ''CUSTOMFIELD4'', ''0'', '''');';  //  SCY BZ 3762
  WhiteSpace;
end;

procedure TPRDistroUnit1.WhiteSpace;
begin
  Script.Add := '';
end;

procedure TPRDistroUnit1.VarAndConst;
begin
  Script.Add := 'function GetProjectIDField: string;';
  Script.Add := 'begin';
  Script.Add := '  Result := ReadOption(''IR_PROJECT_ID_FIELD'', ''CUSTOMFIELD3'');';
  Script.Add := 'end;';
  WhiteSpace;

  Script.Add := 'function GetProjectNOField: string;';
  Script.Add := 'begin';
  Script.Add := '  Result := ReadOption(''IR_PROJECT_NO_FIELD'', ''CUSTOMFIELD4'');';
  Script.Add := 'end;';
  WhiteSpace;
end;

procedure TPRDistroUnit1.BeforePostValidation;
begin
  AddFunction_CreateSQL;
  add_procedure_runsql;
  ReadOption;
  VarAndConst;
  DetailExtended;

  Script.Add := 'procedure LockPRProperties;';
  Script.Add := 'var';
  Script.Add := '  UnitSQL: TjbSQL;';
  Script.Add := 'const';
  Script.Add := '  CANNOT_CHANGE = ''cannot be changed.'';';
  Script.Add := 'begin';
  Script.Add := '  if ( (Detail.FieldByName(PODET_PRID).AsString <> '''') '+
                   'AND (Detail.FieldByName(PODET_PRSEQ).AsString <> '''') ) then begin';
  Script.Add := '    UnitSQL := CreateSQL(TIBTransaction(Tx) );';
  Script.Add := '    try';
  Script.Add := '      RunSQL(UnitSQL, Format(''SELECT COALESCE(ID.ITEMUNIT, '''''''') ITEMUNIT, I.TRANSFERNO FROM IREQDET ID '+
                       'JOIN IREQ I ON ID.TRANSFERID = I.TRANSFERID '+
                       'WHERE ID.TRANSFERID = %d AND ID.SEQ = %d '' '+
                       ', [Detail.FieldByName(PODET_PRID).AsInteger, Detail.FieldByName(PODET_PRSEQ).AsInteger]) );';

  Script.Add := '      if NOT UnitSQL.Eof then begin';
  Script.Add := '        if (Detail.ItemUnit.AsString <> UnitSQL.FieldByName(''ITEMUNIT'') ) then begin';  //SCY BZ 3768
  Script.Add := '          RaiseException(''Item Unit '' + CANNOT_CHANGE);';
  Script.Add := '        end;';
  Script.Add := '        if (DetailExtended(PODET_PRNO).AsString <> UnitSQL.FieldByName(''TRANSFERNO'') ) then begin';  //SCY BZ 3769
  Script.Add := '          RaiseException(''PR No. '' + CANNOT_CHANGE);';
  Script.Add := '        end;';
  Script.Add := '      end;';
  Script.Add := '    finally';
  Script.Add := '      UnitSQL.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  WhiteSpace;

  Script.Add := 'procedure SetProjectInDetail;';
  Script.Add := 'var';
  Script.Add := '  projSQL     : TjbSQL;';
  Script.Add := '  PODET_PRID  : String = ReadOption( ''PODET_PRID'', ''ITEMRESERVED5'');';
  Script.Add := '  PODET_PRSEQ : String = ReadOption( ''PODET_PRSEQ'', ''ITEMRESERVED6'');';
  Script.Add := 'begin';
  Script.Add := '  projSQL := CreateSQL (TIBTransaction(Tx) );';
  Script.Add := '  try';
  Script.Add := '    if NOT (Detail.FieldByName(PODET_PRID).IsNull OR Detail.FieldByName(PODET_PRSEQ).IsNull) then begin';
  Script.Add := '      RunSQL (projSQL, Format (''SELECT COALESCE (E.%s, 0) %s FROM IREQDET ID '+
                       'JOIN EXTENDED E ON E.EXTENDEDID = ID.EXTENDEDID '+
                       'WHERE ID.TRANSFERID = %d AND ID.SEQ = %d'' '+
                       ', [GetProjectIDField, GetProjectIDField '+
                       ', Detail.FieldByName(PODET_PRID).AsInteger, Detail.FieldByName(PODET_PRSEQ).AsInteger]) );';
  Script.Add := '      Detail.FieldByName (''PROJECTID'').AsInteger := projSQL.FieldByName (GetProjectIDField);';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    projSQL.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  WhiteSpace;

  Script.Add := 'procedure BeforePostValidation;';
  Script.Add := 'begin';
  Script.Add := '  SetProjectInDetail;';
  Script.Add := '  LockPRProperties;';
  Script.Add := 'end;';
  WhiteSpace;
end;

procedure TPRDistroUnit1.addMainFormPO;
begin
  BeforePostValidation;

  Script.Add := 'begin';
  Script.Add := '  loadSetting;';
  Script.Add := '  AddBtn_GetPR;';
  Script.Add := '  Detail.Quantity.OnChangeArray      := @ValidateQtyPRForPO;';
  Script.Add := '  Master.on_before_save_array        := @SetListCollectPR;';
  Script.Add := '  Master.on_after_save_array         := @SetListUpdatePR;';
  Script.Add := '  Detail.OnBeforePostValidationArray := @BeforePostValidation;';
  Script.Add := 'end. ';
end;

procedure TPRDistroUnit1.addConstVarPRList;
begin
  Script.Add := 'var cboxPR          : TCheckBox; ';
  Script.Add := '    cboxOutstanding : TCheckBox; ';
  Script.Add := '    btnApprovalPR   : TButton; ';
  Script.Add := '    rbYesApprovalPR : TRadioButton; ';
  Script.Add := '    rbNoApprovalPR  : TRadioButton; ';
  Script.Add := '    cboProjectFilter: TComboBox; ';
end;

procedure TPRDistroUnit1.DoBeforeOpenListPR;
begin
  Script.Add := 'procedure DoBeforeOpenListPR; ';
  Script.Add := '  function WhereCondition:String; ';
  Script.Add := '  begin ';
  Script.Add := '    result := ''''; ';
  Script.Add := '    if cboxPR.Checked then begin ';
//  Script.Add := '      result := result + '' and upper(Tem.Name) = upper(''''PURCHASE REQUEST'''') ''; ';
  Script.Add := '      result := result + Format('' and upper(Tem.Name) containing ''''%s'''' '', [TEMPL_PR]); '; // AA, BZ 2473
  Script.Add := '      if cboxOutstanding.Checked then begin ';
  Script.Add := '        result := result + Format( '' and W.TRANSFERID IN (SELECT DISTINCT TRANSFERID '' + ';
  Script.Add := '                                   ''                        FROM ( '' + ';
  Script.Add := '                                   ''                              SELECT WD.TRANSFERID, ( WD.QUANTITY-COALESCE(CAST(ED.%s AS FLOAT), 0) ) QTY_REMAIN '' + ';
  Script.Add := '                                   ''                                FROM IREQDET WD, EXTENDED ED '' + ';
  Script.Add := '                                   ''                               WHERE WD.EXTENDEDID = ED.EXTENDEDID '' + ';
  Script.Add := '                                   ''                                 AND COALESCE(ED.%s, ''''0'''') <> ''''1'''' '' + ';
  Script.Add := '                                   ''                             ) '' + ';
  Script.Add := '                                   ''                       WHERE QTY_REMAIN > 0) '', [PRDET_QTY_PO, PRDET_CLOSED] ); ';
  Script.Add := '      end; ';
  Script.Add := '      if rbYesApprovalPR.Checked then begin ';
  Script.Add := '        result := result + Format( '' and COALESCE(E.%s, ''''0'''') = ''''1'''' '', [PR_APPROVAL] ); ';
  Script.Add := '      end else if rbNoApprovalPR.Checked then begin ';
  Script.Add := '        result := result + Format( '' and COALESCE(E.%s, ''''0'''') <> ''''1'''' '', [PR_APPROVAL] ); ';
  Script.Add := '      end; ';

  Script.Add := '      if cboProjectFilter.ItemIndex > 0 then begin ';  //  SCY BZ 3763
  Script.Add := '        result := result + format('' AND EXISTS (SELECT ID.TRANSFERID FROM IREQDET ID '+
                                   'JOIN EXTENDED E ON E.EXTENDEDID = ID.EXTENDEDID '+
                                   'WHERE ID.TRANSFERID = W.TRANSFERID AND E.CUSTOMFIELD3 = %d) '' '+
                                   ',[cboProjectFilter.Items.Objects[cboProjectFilter.ItemIndex]]);';
  Script.Add := '      end; ';

  Script.Add := '    end else begin ';
  Script.Add := '      if cboxOutstanding.Checked then begin ';
  Script.Add := '        result := result + '' and W.TRANSFERID IN (SELECT DISTINCT TRANSFERID '' + ';
  Script.Add := '                           ''                        FROM ( '' + ';
  Script.Add := '                           ''                              SELECT WD.TRANSFERID, ( WD.QUANTITY-WD.QTYTRANSFERED ) QTY_REMAIN '' + ';
  Script.Add := '                           ''                                FROM IREQDET WD '' + ';
  Script.Add := '                           ''                               WHERE WD.CLOSED = 0 '' + ';
  Script.Add := '                           ''                             ) '' + ';
  Script.Add := '                           ''                       WHERE QTY_REMAIN > 0) ''; ';
  Script.Add := '      end; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';

  Script.Add := 'begin ';
  Script.Add := '  if pos(''Extended'', DataModule.AtblIReq.SelectSQL.text) = 0 then begin';
  Script.Add := '    DataModule.AtblIReq.SelectSQL[0] := DataModule.AtblIReq.SelectSQL[0] + '' left outer join Extended E on E.ExtendedID = W.ExtendedID'';';
  Script.Add := '  end;';
  Script.Add := '  if pos(''Template'', DataModule.AtblIReq.SelectSQL.text) = 0 then begin';
  Script.Add := '    DataModule.AtblIReq.SelectSQL[0] := DataModule.AtblIReq.SelectSQL[0] + '' left outer join Template Tem on Tem.TemplateID = W.TemplateID'';';
  Script.Add := '  end;';
  Script.Add := '  Datamodule.AtblIReq.SelectSQL[1] := Datamodule.AtblIReq.SelectSQL[1] + WhereCondition; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TPRDistroUnit1.DoClickCboxPR;
begin
  Script.Add := '  procedure DoClickCboxPR;';
  Script.Add := '  begin';
  Script.Add := '    if cboxPR.Checked then begin';
  Script.Add := '      rbYesApprovalPR.Enabled  := True;';
  Script.Add := '      rbNoApprovalPR.Enabled   := True;';
  Script.Add := '      cboProjectFilter.Enabled := True;';  //  SCY BZ 3763
  Script.Add := '    end else begin';
  Script.Add := '      rbYesApprovalPR.Checked  := False;';
  Script.Add := '      rbNoApprovalPR.Checked   := False;';
  Script.Add := '      rbYesApprovalPR.Enabled  := False;';
  Script.Add := '      rbNoApprovalPR.Enabled   := False;';
  Script.Add := '      cboProjectFilter.Enabled := False;';  //  SCY BZ 3763
  Script.Add := '    end;';
  Script.Add := '    DoFilter;';
  Script.Add := '  end;';
end;

procedure TPRDistroUnit1.addMainListPR;
begin
  CreateLabel;
  CreateComboBox;
  TopPos;
  LoadCombo;

  Script.Add := 'procedure AddProjectFilterComboBox;';
  Script.Add := 'var';
  Script.Add := '  lblApprovalStatus: TLabel;';
  Script.Add := '  lblProjectFilter : TLabel;';
  Script.Add := '  ProjectSQL       : TjbSQL;';
  Script.Add := 'begin';
  Script.Add := '  lblApprovalStatus := CreateLabel (cboxOutstanding.Left, TopPos(cboxOutstanding, 20) '+
                                       ', cboxOutstanding.Width, 20, ''Approval Status :'', Form.AFilterBox);';  //  SCY BZ 3764

  Script.Add := '  lblProjectFilter := CreateLabel (rbNoApprovalPR.Left, TopPos(rbNoApprovalPR, 10) '+
                                       ', rbNoApprovalPR.Width, 20, ''Project No :'', Form.AFilterBox);';
  Script.Add := '  cboProjectFilter := CreateComboBox(lblProjectFilter.Left, TopPos(lblProjectFilter) '+
                                       ', lblProjectFilter.Width, 25, csDropDownList, Form.AFilterBox);';
  Script.Add := '  cboProjectFilter.Anchors := akLeft + akTop + akRight;';
  Script.Add := '  cboProjectFilter.Enabled := cboxPR.Checked;';

  Script.Add := '  ProjectSQL := CreateSQL(TIBTransaction(Tx) );';
  Script.Add := '  try';
  Script.Add := '    LoadCombo (ProjectSQL, cboProjectFilter '+
                     ', ''SELECT P.PROJECTNO CODE, P.PROJECTID ID FROM PROJECT P ORDER BY P.PROJECTNO '', True);';
  Script.Add := '  finally';
  Script.Add := '    ProjectSQL.Free;';
  Script.Add := '  end;';
  Script.Add := '  cboProjectFilter.OnChange := @DoFilter;';
  Script.Add := 'end;';
  WhiteSpace;

  Script.Add := 'begin ';
  Script.Add := '  loadSetting; ';
  Script.Add := '  AddCboxPR; ';
  Script.Add := '  AddCboxOutstanding; ';
  Script.Add := '  AddBtnApprovalListPR; ';
  Script.Add := '  AddOptionApprovalPR; ';
  Script.Add := '  btnApprovalPR.Enabled := False;';  //  SCY BZ 3764
  Script.Add := '  btnApprovalPR.Visible := False;';  //  SCY BZ 3764
//  Script.Add := '  SetAttrBtnApprovalPR; ';
  Script.Add := '  AddProjectFilterComboBox;';  //  SCY BZ 3763
  Script.Add := '  DataModule.AtblIREQ.OnBeforeOpenArray  := @DoBeforeOpenListPR; ';
//  Script.Add := '  DataModule.AtblIREQ.OnAfterScrollArray := @SetAttrBtnApprovalPR; ';  //  SCY BZ 3764
  Script.Add := 'end. ';
end;

procedure TPRDistroUnit1.set_scripting_parameterize;
begin
  inherited;
  feature_name := 'PRDistroUnit1';
end;

{ TSearchingCashBankContaining }

procedure TSearchingCashBankContaining.GenerateScript;
begin
  GenerateScriptJV;
  InjectToDB(fnDirectPayment);

  GenerateScriptJV;
  InjectToDB(fnOtherDeposit);

  GenerateScriptARPmt;
  InjectToDB(fnARPayment);

  GenerateScriptAPChq;
  InjectToDB(fnAPCheque);

  GenerateScriptBB;
  InjectToDB(fnBankBook);

  GenerateScriptGLAccSearch;
  InjectToDB(fnGLAccountSearch);

  GenerateScriptJVs;
  InjectToDB(fnJVs);
end;

procedure TSearchingCashBankContaining.GenerateScriptGLAccSearch;
begin
  ClearScript;
  CreateEditBox;
  Script.Add := 'var';
  Script.Add := '  editFindGLAccount   : TEdit;';
  Script.Add := '  editFindAccountName : TEdit;';
  Script.Add := '  GetFromAndWhereClause : String;';
  WhiteSpace;
  Script.Add := 'function GetContaining : String;';
  Script.Add := 'begin;';
  Script.Add := '  result := Format('' AND glaccount CONTAINING ''''%s'''' ' +
                                     ' AND accountname CONTAINING ''''%s'''' '', ' +
                                     '[editFindGLAccount.Text, editFindAccountName.Text]);';
  Script.Add := 'end;';
  WhiteSpace;
//  Script.Add := 'function GetFromAndWhereClause : String;';
//  Script.Add := 'begin;';
//  Script.Add := '  result := ''from glaccnt G '';';
//  Script.Add := '  result := result + ''where (Suspended is null or Suspended=0) '';';
//  Script.Add := '  if not Form.ShowParent then begin';
//  Script.Add := '    result := format(''%s  and (select count(i.ParentAccount) from GLAccnt i ' +
//                     ' ''where i.ParentAccount=G.GLAccount) = 0'', [Result]);';
//  Script.Add := '  if not Form.IncludedType <> '''' then begin';
//  Script.Add := '    result := format(''%s and g.AccountType in (%s)'', [result, Form.IncludedType]);';
//  Script.Add := '  if not Form.ExcludedType <> '''' then begin';
//  Script.Add := '    result := format(''%s and g.AccountType not in (%s)'', [result, Form.ExcludedType]);';
//  Script.Add := '  if not Form.AdditionalCondition <> '''' then begin';
//  Script.Add := '    result := format(''%s and %s'', [result, Form.AdditionalCondition]);';
//  Script.Add := '  result := result + GetContaining;';
//  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure DoFilter;';
  Script.Add := 'begin;';
  Script.Add := '  Form.tblGLAccnt.Close;';
  Script.Add := '  Form.tblGLAccnt.SQL[1] := GetFromAndWhereClause + GetContaining;';
  Script.Add := '  Form.tblGLAccnt.Open;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'begin';
  Script.Add := '  GetFromAndWhereClause := Form.tblGLAccnt.SQL[1];';
  Script.Add := '  editFindGLAccount     := CreateEdit(Form.editFindGLAccount.Left, Form.editFindGLAccount.Top, Form.editFindGLAccount.Width, Form.editFindGLAccount.Height, Form);';
  Script.Add := '  editFindAccountName   := CreateEdit(Form.editFindAccountName.Left, Form.editFindAccountName.Top, Form.editFindAccountName.Width, Form.editFindAccountName.Height, Form);';
  Script.Add := '  editFindGLAccount.OnChange   := @DoFilter;';
  Script.Add := '  editFindAccountName.OnChange := @DoFilter;';
  Script.Add := 'end.';
end;

procedure TSearchingCashBankContaining.GenerateScriptAPChq;
begin
  ClearScript;
  Script.Add := 'var';
  Script.Add := '  SearchingCboBank : TSearchingContainCboBankAccountDecorator;';
  WhiteSpace;
  Script.Add := 'procedure onShow;';
  Script.Add := 'begin';
  Script.Add := '  SearchingCboBank := TSearchingContainCboBankAccountDecorator.Create(Form.AcboBank, DataModule.qrybank);';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure onDestroy;';
  Script.Add := 'begin';
  Script.Add := '  SearchingCboBank.Free;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure ResetCbBankSearch;';
  Script.Add := 'begin';
  Script.Add := '  SearchingCboBank.ResetSearching;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'begin';
  Script.Add := '  Form.layout_from_script := @onShow;';
  Script.Add := '  Form.onFormDestroyArray := @onDestroy;';
  Script.Add := '  Datamodule.AtblAPCheq.OnBeforeOpenArray := @ResetCbBankSearch;';
  Script.Add := 'end.';
  WhiteSpace;
end;

procedure TSearchingCashBankContaining.GenerateScriptARPmt;
begin
  ClearScript;
  Script.Add := 'var';
  Script.Add := '  SearchingCboBank : TSearchingContainCboBankAccountDecorator;';
  WhiteSpace;
  Script.Add := 'procedure onShow;';
  Script.Add := 'begin';
  Script.Add := '  SearchingCboBank := TSearchingContainCboBankAccountDecorator.Create(Form.AcboBank, DataModule.qryBank);';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure onDestroy;';
  Script.Add := 'begin';
  Script.Add := '  SearchingCboBank.Free;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure ResetCbBankSearch;';
  Script.Add := 'begin';
  Script.Add := '  SearchingCboBank.ResetSearching;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'begin';
  Script.Add := '  Form.layout_from_script := @onShow;';
  Script.Add := '  Form.onFormDestroyArray := @onDestroy;';
  Script.Add := '  Datamodule.tblARPmt.OnBeforeOpenArray := @ResetCbBankSearch;';
  Script.Add := 'end.';
  WhiteSpace;
end;

procedure TSearchingCashBankContaining.GenerateScriptBB;
begin
  ClearScript;
  Script.Add := 'var';
  Script.Add := '  SearchingCboBank : TSearchingContainCboBankAccountDecorator;';
  WhiteSpace;
  Script.Add := 'procedure onShow;';
  Script.Add := 'begin';
//  Script.Add := '  ShowMessage(Form.AcboBank);';
//  Script.Add := '  SearchingCboBank := TSearchingContainCboBankAccountDecorator.Create(Form.AcboBank, DataModule.qryBank);';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure onDestroy;';
  Script.Add := 'begin';
  Script.Add := '  SearchingCboBank.Free;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure ResetCbBankSearch;';
  Script.Add := 'begin';
  Script.Add := '  SearchingCboBank.ResetSearching;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'begin';
//  Script.Add := '  Form.layout_from_script := @onShow;';
//  Script.Add := '  Form.onFormDestroyArray := @onDestroy;';
//  Script.Add := '  Datamodule.AtblARPmt.OnBeforeOpenArray := @ResetCbBankSearch;';
  Script.Add := 'end.';
  WhiteSpace;
end;

procedure TSearchingCashBankContaining.GenerateScriptJV;
begin
  ClearScript;
  Script.Add := 'var';
  Script.Add := '  SearchingCboBankAccount : TSearchingContainCboBankAccountDecorator;';
  WhiteSpace;
  Script.Add := 'procedure onShow;';
  Script.Add := 'begin';
  Script.Add := '  SearchingCboBankAccount := TSearchingContainCboBankAccountDecorator.Create(Form.AcboBankAccount, DataModule.qryBank);';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure onDestroy;';
  Script.Add := 'begin';
  Script.Add := '  SearchingCboBankAccount.Free;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure ResetCbBankAccountSearch;';
  Script.Add := 'begin';
  Script.Add := '  SearchingCboBankAccount.ResetSearching;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'begin';
  Script.Add := '  Form.layout_from_script := @onShow;';
  Script.Add := '  Form.onFormDestroyArray := @onDestroy;';
  Script.Add := '  Datamodule.AtblJV.OnBeforeOpenArray := @ResetCbBankAccountSearch;';
  Script.Add := 'end.';
  WhiteSpace;
end;

procedure TSearchingCashBankContaining.GenerateScriptJVs;
begin
  ClearScript;
  CreateEditBox;
  Script.Add := 'const';
  Script.Add := '  SPACING = 4;';
  Script.Add := 'var';
  Script.Add := '  edtFindCode : TEdit;';
  Script.Add := '  edtFindDesc : TEdit;';
  WhiteSpace;
  Script.Add := 'function GetFilterContaining : String;';
  Script.Add := 'begin;';
  Script.Add := '  result := Format(''AND jvnumber CONTAINING ''''%s'''' ' +
                                    ' AND transdescription CONTAINING ''''%s'''' '', [edtFindCode.Text, edtFindDesc.Text]);';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure DoFilter;';
  Script.Add := 'begin;';
  Script.Add := '  Form.SetFilterAndRun;';
  Script.Add := '  Form.dmJVs.QryJV.Close;';
  Script.Add := '  Form.dmJVs.QryJV.SelectSQL[2] := Form.dmJVs.QryJV.SelectSQL[2] + GetFilterContaining;';
  Script.Add := '  Form.dmJVs.QryJV.Open;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure FormResize;';
  Script.Add := 'begin;';
  Script.Add := '  edtFindCode.Left := Form.edtFindCode.Left + SPACING;';
  Script.Add := '  edtFindCode.Top := Form.edtFindCode.Top + SPACING;';
  Script.Add := '  edtFindDesc.Left := Form.edtFindDesc.Left + SPACING;';
  Script.Add := '  edtFindDesc.Top := Form.edtFindDesc.Top + SPACING;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'begin';
  Script.Add := '  edtFindCode := CreateEdit(Form.edtFindCode.Left + SPACING, Form.edtFindCode.Top + SPACING, Form.edtFindCode.Width, Form.edtFindCode.Height, Form);';
  Script.Add := '  edtFindDesc := CreateEdit(Form.edtFindDesc.Left + SPACING, Form.edtFindDesc.Top + SPACING, Form.edtFindDesc.Width, Form.edtFindDesc.Height, Form);';
  Script.Add := '  edtFindCode.OnChange := @DoFilter;';
  Script.Add := '  edtFindDesc.OnChange := @DoFilter;';
  Script.Add := '  Form.OnResize := @FormResize;';
  Script.Add := 'end.';
end;

procedure TSearchingCashBankContaining.set_scripting_parameterize;
begin
  inherited;
  feature_name := 'Searching Cash Bank : Containing';
end;

{ TItemTransferGetRequestRM }

procedure TItemTransferGetRequestRM.GenerateScript;
begin
  GenerateScriptMain;
  InjectToDB(fnMain);
  GenerateScriptIT;
  InjectToDB(fnTransferForm);
end;

procedure TItemTransferGetRequestRM.GenerateScriptIT;
begin
  ClearScript;
  CreateLabel;
  CreateEditBox;
  CreateButton;
  TopPos;
  AddFunction_CreateSQL;
  add_procedure_runsql;
  getOptionDistro;
  DetailExtended;
  ReadOption;
  Script.Add := 'var';
  Script.Add := '  SCHEDULEID : String = ReadOption(''ITGetReqRM_ScheduleID'', ''customfield11'');';
  Script.Add := '  FromReqRM : Boolean;';
  Script.Add := '  lblSchedule : TLabel;';
  Script.Add := '  edtSchedule : TEdit;';
//  Script.Add := '  btnSchedule : TButton;';
  Script.Add := '  UOM_QTY1 : String;';
  WhiteSpace;
  Script.Add := 'procedure SetUOMField;';
  Script.Add := 'begin';
  Script.Add := '  UOM_QTY1 := getOptionDistro(1);';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure FormResize;';
  Script.Add := 'begin';
  Script.Add := '  lblSchedule.Top := TopPos(Form.btnResv3);';
  Script.Add := '  edtSchedule.Top := TopPos(lblSchedule);';
//  Script.Add := '  btnSchedule.Top := TopPos(edtSchedule);';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure DoFillDetailWithReqRM;';
  Script.Add := '  procedure ClearDetail;';
  Script.Add := '  begin';
  Script.Add := '    if not Detail.IsEmpty then begin';
  Script.Add := '      Detail.First;';
  Script.Add := '      While NOT Detail.EOF do begin';
  Script.Add := '        if DetailExtended(SCHEDULEID).IsNull then begin';
  Script.Add := '          Detail.Delete;';
  Script.Add := '        end';
  Script.Add := '        else begin';
  Script.Add := '          Detail.Next;';
  Script.Add := '        end; ';
  Script.Add := '      end; ';
  Script.Add := '    end; ';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := '  procedure FillDetail;';
  Script.Add := '  var';
  Script.Add := '    sql : TjbSQL;';
  Script.Add := '    query : String;';
  Script.Add := '  begin';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '    try';
  Script.Add := '      query := Format(''SELECT * ' +
                                        'FROM   requestrm ' +
                                        'WHERE  scheduleid = %s '', [edtSchedule.Text]);';
  Script.Add := '      RunSQL(sql, query); ';
  Script.Add := '      while not sql.EoF do begin';
  Script.Add := '        Detail.Append;';
  Script.Add := '        Detail.ITEMNO.AsString := sql.FieldByName(''RMNO'');';
  Script.Add := '        Detail.QUANTITY.AsString := sql.FieldByName(''QUANTITY'');';
  Script.Add := '        DetailExtended(UOM_QTY1).AsCurrency := sql.FieldByName(''QUANTITY'');';
  Script.Add := '        DetailExtended(SCHEDULEID).AsInteger := sql.FieldByName(''SCHEDULEID'');';
  Script.Add := '        Detail.Post;';
  Script.Add := '        sql.Next;';
  Script.Add := '      end;';
  Script.Add := '    finally';
  Script.Add := '      if not DetailExtended(SCHEDULEID).IsNull then FromReqRM := true;';
  Script.Add := '      sql.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := 'begin';
  Script.Add := '  if not isNumeric(edtSchedule.Text) then exit;';
  Script.Add := '  Form.btnResv3.Enabled := False;';
  Script.Add := '  FromReqRM := False;';
  Script.Add := '  ClearDetail;';
  Script.Add := '  FillDetail;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure CreateException;';
  Script.Add := 'begin';
  Script.Add := '  Detail.Cancel;';
  Script.Add := '  RaiseException(''Not Allowed!'');';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure ValidateDetailInput;';
  Script.Add := '  function isItemFromReqRM : Boolean;';
  Script.Add := '  const';
  Script.Add := '    ITEMNO = ''ITEMNO'';';
  Script.Add := '  begin';
  Script.Add := '    if DetailExtended(SCHEDULEID).IsNull then exit;';
  Script.Add := '    Result := Form.DBGrid1.CurrentSelectedField.FieldName in [ITEMNO];';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := 'begin';
  Script.Add := '  if isItemFromReqRM then begin';
  Script.Add := '    CreateException;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure ValidateCanInsert;';
  Script.Add := '  procedure LockScheduleIDColumn;';
  Script.Add := '  const';
  Script.Add := '    DBGRID1_FIELDNAME_PREFIX = ''wtrandet'';';
  Script.Add := '  begin';
  Script.Add := '    Form.DBGrid1.Columns[Form.DBGrid1.GetColIndex (DBGRID1_FIELDNAME_PREFIX + SCHEDULEID)].ReadOnly := true;';
  Script.Add := '  end;';
  WhiteSpace;
  Script.Add := 'begin';
  Script.Add := '  LockScheduleIDColumn;';
  Script.Add := '  if FromReqRM then begin';
  Script.Add := '    CreateException;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure ValidateDetailEmpty;';
  Script.Add := 'begin';
  Script.Add := '  if Detail.EoF then begin';
  Script.Add := '    Form.btnResv3.Enabled := True;';
  Script.Add := '    FromReqRM := False;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure ResetVar;';
  Script.Add := 'begin';
  Script.Add := '  FromReqRM := false;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'procedure FillDetailWithReqRM(sender : TObject; var key : Word);';
  Script.Add := 'const';
  Script.Add := '  ENTER_KEY = 13;';
  Script.Add := 'begin';;
  Script.Add := '  if (Key = ENTER_KEY) then begin';
  Script.Add := '    DoFillDetailWithReqRM;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'begin';
  Script.Add := '  SetUOMField;';
  Script.Add := '  lblSchedule := CreateLabel(0, TopPos(Form.btnResv3, 30), Form.pnlJbButtons.Width - 5, 15, ''Schedule:'', Form.pnlJBButtons);';
  Script.Add := '  edtSchedule := CreateEdit(lblSchedule.Left, TopPos(lblSchedule), lblSchedule.Width, 20, Form.pnlJBButtons);';
//  Script.Add := '  btnSchedule := CreateBtn(edtSchedule.Left, TopPos(edtSchedule), edtSchedule.Width, 20, 0, ''ENTER'', Form.pnlJBButtons);';
//  Script.Add := '  btnSchedule.OnClick := @DoFillDetailWithReqRM;';
  Script.Add := '  edtSchedule.OnKeyDown := @FillDetailWithReqRM;';
  Script.Add := '  Detail.OnBeforeInsertArray := @ValidateCanInsert;';
  Script.Add := '  Detail.OnBeforeEditArray := @ValidateDetailInput;';
  Script.Add := '  Detail.OnAfterDeleteArray := @ValidateDetailEmpty;';
  Script.Add := '  Master.on_after_save_array  := @ResetVar; ';
  Script.Add := '  Form.OnResize := @FormResize;';
  Script.Add := 'end.';
end;

procedure TItemTransferGetRequestRM.GenerateScriptMain;
begin
  ClearScript;
  CreateMenu;
  CreateFormSetting;
  CreateForm;
  Script.Add := 'var';
  Script.Add := '  frmITGetReqRMSetting : TForm;';
  WhiteSpace;
  Script.Add := 'procedure ShowITGetReqRMSettingForm;';
  Script.Add := 'begin';
  Script.Add := '  frmITGetReqRMSetting := CreateFormSetting(''frmITGetReqRMSetting'', ''IT Get ReqRM Setting'', 380, 160);';
  Script.Add := '  try';
  Script.Add := '    AddControl (frmITGetReqRMSetting, ''Schedule ID Field'', ''CUSTOMFIELD'', ''ITGetReqRM_ScheduleID'', ''CUSTOMFIELD11'', ''0'', '''');';
  Script.Add := '    if (frmITGetReqRMSetting.ShowModal = mrOK) then begin';
  Script.Add := '      SaveToOptions;';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    frmITGetReqRMSetting.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  WhiteSpace;
  Script.Add := 'begin';
  Script.Add := '  CreateMenu ( (Form.mnuAddOn.Count - 1), Form.mnuAddOn, ''mnuITGetReqRMSetting'' '+
                   ', ''IT Get ReqRM Setting'', ''ShowITGetReqRMSettingForm'');';
  Script.Add := 'end.';
end;

procedure TItemTransferGetRequestRM.set_scripting_parameterize;
begin
  inherited;
  feature_name := 'IT Get ReqRM';
end;

{ TMCRPCustomInjector }

procedure TMCRPCustomInjector.WhiteSpace;
begin
  Script.Add := '';
end;

end.

