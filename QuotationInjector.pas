unit QuotationInjector;

interface
uses Injector, BankConst, Sysutils, ScriptConst
  , Classes;

type
  TState = (SODataset, SO, SOList);
  TQuotationInjector = class(TInjector)
  private
    procedure GenerateMain;
    procedure GenerateSO;
    procedure GenerateSOList;
    procedure GenerateSODataset;
    procedure GetQuotationTemplateID;
    procedure SOIsQuotation(State: String='Master');
    procedure SOArrayOfIntToStr;
    procedure SOGetQuotation;
    procedure InitializeVariable(const State: TState);
    procedure MainCreateMenuSetting;
    procedure SORunningNumber;
    procedure SOFormChooseQuotation;
    procedure SOGetQuotationData;
    procedure GenerateForChooseForm;
    procedure RecreateOnExit;
    procedure MasterOnBeforeSave;
    procedure DatasetOnBeforeDeleteSO;
    procedure QueryTemplateID;
  protected
    procedure GenerateCustomField(Alias, Dataset:String);
    procedure GenerateItemReservedField;
    procedure ProceedQuotationData; virtual;
    procedure DoClickOKButton; virtual;
    procedure DoExecuteDetail; virtual;
    procedure ShowSetting; virtual;
    procedure set_scripting_parameterize; override;
    procedure MasterOnBeforePostAudit; virtual;
    procedure AddFilterSOList; virtual;
    procedure SOsFilterQuotation; virtual;
    procedure create_rb; virtual;
    procedure AddMainSOList; virtual;
    procedure SOFillListQuotation; virtual;
  public
    procedure GenerateScript; override;
    function describe_manual_step:string; override;
  end;

implementation

{ TQuotationInjector }

procedure TQuotationInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := SCRIPTING_QUOTATION;
end;

procedure TQuotationInjector.AddFilterSOList;
begin
  Script.Add := 'procedure AddFilterSO;                                                    ';
  Script.Add := 'begin                                                                       ';
  Script.Add := '  if ArrayOfIntToStr = '''' then Exit; ';
  Script.Add := '  DataModule.tabelSO.SelectSQL[2] := DataModule.tabelSO.SelectSQL[2] + GetSQL;';
  Script.Add := 'end;                                                                        ';
  Script.Add := '';
end;

procedure TQuotationInjector.AddMainSOList;
begin
  Script.Add := '  InitializeVariable; ';
  Script.Add := '  create_rb;            ';
  Script.Add := '  GetQuoTemplateID;';
  Script.Add := '  rbSO.Checked := true; ';
  Script.Add := '  DataModule.tabelSO.BeforeOpen := @AddFilterSO; ';
end;

procedure TQuotationInjector.create_rb;
begin
  Script.Add := 'procedure create_rb;                                                                  ';
  Script.Add := 'begin                                                                                 ';
  Script.Add := '  rbQuotation := CreateRadioButton(4, 250, 150, 21, ''Quotation'', Form.AFilterBox);  ';
  Script.Add := '  rbSO        := CreateRadioButton(4, TopPos(rbQuotation, 0), 150, 21, ''Sales Order'', Form.AFilterBox);';
  Script.Add := '  rbQuotation.OnClick := @rbFilterClick;                                              ';
  Script.Add := '  rbSO.OnClick        := @rbFilterClick;                                              ';
  Script.Add := 'end;                                                                                  ';
  Script.Add := '';
end;

procedure TQuotationInjector.DatasetOnBeforeDeleteSO;
begin
  Script.Add := 'procedure DatasetOnBeforeDeleteSO; ';
  Script.Add := 'begin ';
  Script.Add := '  SetQuotationActiveAgain;  ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function GetSameQuoNoFromOtherSO(QuoNo: String):Boolean; ';
  Script.Add := 'var sql  : TjbSQL; ';
  Script.Add := 'begin ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sql, Format(''Select s.SONO From SO s left join Extended e on e.ExtendedID = s.ExtendedID ''+ ';
  Script.Add := '      ''where e.%s = ''''%s'''' ''+ ';
  Script.Add := '      ''and SOID <> %d'',[ QUOTATIONNO_FIELD, QuoNo, Dataset.SOID.Value ]) ); ';
  Script.Add := '    result := not sql.Eof; ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function IsQuotationCanDelete(QuoNo: String):Boolean; ';
  Script.Add := 'begin ';
  Script.Add := '  result := not GetSameQuoNoFromOtherSO(QuoNo); ';
  Script.Add := 'end; ';
  Script.Add := ' ';
  DatasetExtended;
  Script.Add := 'procedure SetQuotationActiveAgain; ';
  Script.Add := 'var sql   : TjbSQL; ';
  Script.Add := '    ATx   : TIBTransaction; ';
  Script.Add := '    QuoNo : String; ';
  Script.Add := '  procedure set_not_proceed; ';
  Script.Add := '  begin ';
  Script.Add := '    RunSQL( sql, format(''Update SO set Proceed = 0 where SONo = ''''%s'''' '', ';
  Script.Add := '      [ DatasetExtended(QUOTATIONNO_FIELD).Value ] ) ); ';
  Script.Add := '  end; ';
  Script.Add := ' ';
  Script.Add := '  procedure set_status; ';
  Script.Add := '  begin ';
  Script.Add := '    set_not_proceed; // to accomodate SProc GET_VALUE_SO, call at before update SO Table ';
  Script.Add := '  end; ';
  Script.Add := ' ';
  Script.Add := 'begin ';
  Script.Add := '  if DatasetExtended(QUOTATIONNO_FIELD).IsNull then begin ';
  Script.Add := '    if IsQuotation then begin ';
  Script.Add := '      QuoNo := Dataset.SONO.Value; ';
  Script.Add := '    end ';
  Script.Add := '    else begin ';
  Script.Add := '      Exit; ';
  Script.Add := '    end; ';
  Script.Add := '  end ';
  Script.Add := '  else begin ';
  Script.Add := '    QuoNo := DatasetExtended(QUOTATIONNO_FIELD).AsString; ';
  Script.Add := '  end; ';
  Script.Add := '  if IsQuotation then begin ';
  Script.Add := '    if not IsQuotationCanDelete( QuoNo ) then begin ';
  Script.Add := '      RaiseException(''Unable to delete, It is Used in transaction(s)''); ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  if Dataset.ExtendedID.FieldLookup.FieldByName(QUOTATIONNO_FIELD).Value = NULL then Exit; ';
  Script.Add := '  ATx := CreateATx; ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(ATx)); ';
  Script.Add := '  try ';
  Script.Add := '    set_not_proceed; ';
  Script.Add := '    set_status; ';
  Script.Add := '    ATx.Commit; ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

function TQuotationInjector.describe_manual_step: string;
begin
  result := 'Cara Setting: '#13#10+
            '1. Buat template Quotation. Nama-nya harus mengandung kata ''Quotation''.'#13#10 +
            '2. Perhatikan menu Setting Quotation pada Essential Data pada bagian Sequence Item kolom tersebut ' +
            'jangan sampai terbentur oleh FR lain dengan menggunakan kolom yang sama.'#13#10 +
            '4. Template Quotation hanya bisa dibuat 1 saja.'#13#10 +
            '3. Gunakan FINA versi 1.9.0.632 keatas.';
end;

procedure TQuotationInjector.DoClickOKButton;
begin
  Script.Add := EmptyStr;
  Script.Add := 'procedure DoClickOKButton;';
  Script.Add := 'begin';
  //for inherited
  Script.Add := 'end;';
end;

procedure TQuotationInjector.GenerateForChooseForm;
begin
  ClearScript;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  QueryTemplateID;
  ReadOption;

  DoClickOKButton;

  Script.Add := 'var CustomerID : Integer; ';
  Script.Add := 'procedure DoAssignSOSQL; ';
  Script.Add := '  procedure DoSQLSearch; ';
  Script.Add := '  begin ';
  Script.Add := '    Form.SqlSearch.sql.Clear; ';
  Script.Add := '    Form.sqlSearch.sql.Add(''Select Distinct m.SONO, m.SODate, m.PONO, m.Description''); ';
  Script.Add := '    Form.sqlSearch.sql.Add(''FROM SODET s inner join SO m on s.SOID=m.SOID''); ';
  Script.Add := '    Form.sqlSearch.sql.Add(''left outer join item i on s.ItemNo = i.ItemNo''); ';
  Script.Add := '    Form.sqlSearch.sql.Add(''WHERE (s.Closed=0)''); ';
  Script.Add := '    Form.sqlSearch.sql.Add(''AND i.Suspended = 0 and m.CustomerID=:CustomerID and TemplateID ''); ';
  Script.Add := '    Form.sqlSearch.sql.Add( Format(''not in (%s)'', [QueryTemplateID]) ); ';
  Script.Add := '    Form.sqlSearch.sql.Add( Form.OrderBySQL ); ';
  Script.Add := '  end; ';
  Script.Add := '     ';
  Script.Add := '  function GetQuotationTemplateID:Integer; ';
  Script.Add := '  var sql:TjbSQL; ';
  Script.Add := '  begin ';
  Script.Add := '    result := -1; ';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '    try ';
  Script.Add := '      RunSQL(sql, QueryTemplateID ); ';
  Script.Add := '      if not sql.Eof then begin ';
  Script.Add := '        result := sql.FieldByName(''TemplateID''); ';
  Script.Add := '      end; ';
  Script.Add := '      if result = -1 then RaiseException(''Template Quotation pada SO tidak ada!''); ';
  Script.Add := '    finally ';
  Script.Add := '      sql.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '       ';
  Script.Add := 'begin ';
  Script.Add := '  CustomerID := TFrmChooseInvoice(Form).PersonID; ';
  Script.Add := '  DoSQLSearch; ';
  Script.Add := '  Form.SqlSearch.SetParam(0, CustomerID); ';
  Script.Add := '  Form.SqlSearch.ExecQuery; ';
  Script.Add := 'end; ';
  Script.Add := ' ';
  Script.Add := 'var SCRIPT_ON_QUO : Boolean; ';
  Script.Add := 'procedure InitializeVar; ';
  Script.Add := 'begin ';
  Script.Add := '  SCRIPT_ON_QUO := ReadOption( ''SCRIPT_ON_QUO'', ''1'' ) = ''1''; ';
  Script.Add := 'end; ';
  Script.Add := 'begin ';
  Script.Add := '  InitializeVar; ';
  Script.Add := '  if not SCRIPT_ON_QUO then Exit; ';
  Script.Add := '  TfrmChooseInvoice(Form).OnAssignSOSQL    := @DoAssignSOSQL; ';
  Script.Add := '  TfrmChooseInvoice(Form).ABitBtn1.OnClick := @DoClickOKButton;';  //SCY BZ 3223
  Script.Add := 'end. ';
end;

procedure TQuotationInjector.GetQuotationTemplateID;
begin
  Script.Add := 'procedure GetQuoTemplateID; ';
  Script.Add := 'var sql:TjbSQL; ';
  Script.Add := 'begin ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sql, ''Select t.TemplateID from Template t where t.TemplateType=1 and t.NAME containing ''''quotation'''' ''); ';
  Script.Add := '    SetLength(TEMPLATE_QUOTATION, 0); ';
  Script.Add := '    while not sql.EOF do begin ';
  Script.Add := '      SetLength( TEMPLATE_QUOTATION, Length(TEMPLATE_QUOTATION) + 1); ';
  Script.Add := '      TEMPLATE_QUOTATION[ Length(TEMPLATE_QUOTATION) - 1 ] := sql.FieldByName(''TemplateID''); ';
  Script.Add := '      sql.Next; ';
  Script.Add := '    end; ';
  Script.Add := '    if Length(TEMPLATE_QUOTATION)=0 then ShowMessage(''Template Quotation tidak ada''); ';
  Script.Add := '  finally; ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TQuotationInjector.SOIsQuotation(State: String='Master');
begin
  Script.Add := 'function IsQuotation:Boolean; ';
  Script.Add := 'begin ';
  Script.Add := Format('  result := %s.TemplateID.value in TEMPLATE_QUOTATION; ', [State]);
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TQuotationInjector.SORunningNumber;
begin
  Script.Add := 'function GetFieldName:String; ';
  Script.Add := 'begin ';
  Script.Add := '  if IsQuotation then result := ''QUOTATION_RUNNING_NO'' else result := ''SO_RUNNING_NO''; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function GetSoNo(IsQuotation:Boolean):String; ';
  Script.Add := 'var sql:TjbSQL; ';
  Script.Add := '    iTx : TIBTransaction; ';
  Script.Add := 'begin';
  Script.Add := '  iTx := CreateATx; ';
  Script.Add := '  sql := CreateSQL(iTx); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sql, format(''select ValueOpt from Options where ParamOpt=''''%s'''' '',[GetFieldName]) ); ';
  Script.Add := '    if sql.EOF then begin ';
  Script.Add := '      RunSQL(sql, format(''Insert into Options (ParamOpt, ValueOpt) values (''''%s'''', ''''%s'''')'', '+
    '[GetFieldName, ''1001'']) );';
  Script.Add := '      iTx.Commit; ';
  Script.Add := '      iTx.StartTransaction; ';
  Script.Add := '      RunSQL(sql, format(''select ValueOpt from Options where ParamOpt=''''%s'''' '',[GetFieldName]) ); ';
  Script.Add := '    end; ';
  Script.Add := '    result := sql.FieldByName(''ValueOpt''); ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '    iTx.Free; ';
  Script.add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure DoGetSONo; ';
  Script.Add := 'begin';
  Script.Add := '  if not Master.IsMasterNew then exit;                                                                                ';
  Script.Add := '  Master.SONO.value := GetSoNo( IsQuotation ); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure DoIncrementSoNo;                                                                                                 ';
  Script.Add := 'var sql:TjbSQL; ';
  Script.Add := '    iTx : TIBTransaction; ';
  Script.Add := 'begin                                                                                                                   ';
  Script.Add := '  if Master.IsMasterNew and (Master.State =2 {dsEdit}) then begin                                      ';
  Script.Add := '    iTx := CreateATx; ';
  Script.Add := '    sql := CreateSQL(iTx); ';
  Script.Add := '    try ';
  Script.Add := '      RunSQL(sql, format(''Update Options Set ValueOpt=''''%s'''' where ParamOpt=''''%s'''' '', '+
    '[IncCtlNumber(Master.SONO.Value), GetFieldName]) ); ';
  Script.Add := '    finally ';
  Script.Add := '      sql.Free; ';
  Script.Add := '      iTx.Free; ';
  Script.add := '    end; ';
  Script.Add := '  end;                                                                                                                  ';
  Script.Add := 'end;                                                                                                                    ';
  Script.Add := '';
end;

procedure TQuotationInjector.SOArrayOfIntToStr;
begin
  Script.Add := 'function ArrayOfIntToStr:String; ';
  Script.Add := 'var idx:Integer; ';
  Script.Add := 'begin ';
  Script.Add := '  Result := ''''; ';
  Script.Add := '  for idx:=0 to Length(TEMPLATE_QUOTATION) - 1 do begin ';
  Script.Add := '    if result <> '''' then result := result + '',''; ';
  Script.Add := '    result := result + IntToStr(TEMPLATE_QUOTATION[idx]); ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TQuotationInjector.SOFillListQuotation;
begin
  Script.Add := 'procedure FillListQuotation;                                                                                            ';
  Script.Add := 'var                                                                                                                     ';
  Script.Add := '  listItem : TListItem;                                                                                                 ';
  Script.Add := '  sql : TjbSQL; ';
  Script.Add := 'begin                                                                                                                   ';
  Script.Add := '  listQuotation.Items.Clear;                                                                                            ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx));                                                                                          ';
  Script.Add := '  try                                                                                                                   ';
  Script.Add := '    RunSQL(sql, format(''select m.SOID, m.SONO from SO m ''+                                                         ';
  Script.Add := '      ''where (m.templateid in (%s)) and (m.customerid=%d) and (m.Proceed=0) and (m.Closed=0) order by SONO'',  ';
  Script.Add := '      [ArrayOfIntToStr, Master.CustomerID.value]));                                                             ';
  Script.Add := '    while not sql.EOF do begin                                                                                 ';
  Script.Add := '      listItem         := listQuotation.Items.Add;                                                           ';
  Script.Add := '      listItem.Caption := sql.FieldByName(''SONO'');';
  Script.Add := '      listItem.SubItems.Add( sql.FieldByName(''SOID''));                                            ';
  Script.Add := '      sql.Next;                                                                                                ';
  Script.Add := '    end;                                                                                                       ';
  Script.Add := '  finally                                                                                                      ';
  Script.Add := '    sql.Free;                                                                                                  ';
  Script.Add := '  end;                                                                                                         ';
  Script.Add := 'end;                                                                                                           ';
  Script.Add := '';
end;

procedure TQuotationInjector.GenerateCustomField(Alias, Dataset:String);
var j:Integer;
begin
  for j := 1 to 20 do begin
    Script.Add := format('    '', %s.CustomField%d %sCustomField%d ''+ ', [Alias, j, Dataset, j]);
  end;
end;

procedure TQuotationInjector.GenerateItemReservedField;
var j:Integer;
begin
  for j := 1 to 10 do begin
    Script.Add := format('    '', d.ItemReserved%d ''+ ', [j]);
  end;
end;

procedure TQuotationInjector.ProceedQuotationData;
begin
  Script.Add := '';
  Script.Add := 'procedure GetQuotationData;                                                                                             ';
  Script.Add := 'var                                                                                                                     ';
  Script.Add := '  idx, QuotationID, CheckedCount : Integer; ';
//  Script.Add := '  uom_qty_1 : Currency; ';
//  Script.Add := '  uom_qty_2 : Currency; ';
//  Script.Add := '  uom_qty_3 : Currency; ';
//  Script.Add := '  current_qty : Currency; ';
//  Script.Add := '  ratio2      : currency; ';
//  Script.Add := '  ratio3      : currency; ';
  Script.Add := '  sql : TjbSQL; ';
  Script.Add := '  ';
  Script.Add := 'begin                                                                                                                   ';
  Script.Add := '  CheckedCount := 0;                                                                                                    ';
  Script.Add := '  for idx:=0 to listQuotation.Items.Count-1 do begin                                                                      ';
  Script.Add := '    if listQuotation.Items[idx].Checked then begin                                                                        ';
  Script.Add := '      Inc(CheckedCount);                                                                                                ';
  Script.Add := '      QuotationID := StrToInt(listQuotation.Items[idx].SubItems[0]);                                                      ';
  Script.Add := '      if CheckedCount>1 then begin                                                                                      ';
  Script.Add := '        RaiseException(''You can only select one quotation!'');                                                           ';
  Script.Add := '      end;                                                                                                              ';
  Script.Add := '    end;                                                                                                                ';
  Script.Add := '  end;                                                                                                                  ';
  Script.Add := '                                                                                                                        ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx));                                                                                               ';
  Script.Add := '  try                                                                                                                   ';
  Script.Add := '    RunSQL(sql, ''select m.soid, d.seq, m.sono, m.salesmanid, m.Pono, d.itemno, d.quantity, d.taxcodes, em.Lookup1, ''+ ';
  Script.Add := '      Format(''d.unitprice, d.itemunit, d.unitratio, d.%s, coalesce (d.itemovdesc, '''''''') itemovdesc '', [SEQ_ITEM])+';  //SCY BZ 2884
  GenerateCustomField('em', 'Master');
  GenerateCustomField('ed', 'Detail');
  GenerateItemReservedField;
  Script.Add := '      ''from SODET d ''+ ';
  Script.Add := '      ''inner join SO m on m.SOID=d.SOID ''+';
  Script.Add := '      ''left outer join extended em on em.extendedid=m.extendedid ''+          ';
  Script.Add := '      ''left outer join extended ed on ed.extendedid=d.extendedid ''+ ';
  Script.Add := '      format(''where d.soid=%d and LEFT(coalesce (d.ITEMOVDESC, ''''''''), 2) <> ''''--'''' '', [QuotationID]) + ';  //SCY BZ 2884
  Script.Add := '      '' order by d.soid, d.seq'');'; // AA, BZ 2770
  Script.Add := '                                                                                                                        ';
  Script.Add := '    TIntegerField(Master.SalesmanID).Value := sql.FieldByName(''salesmanid'');                               ';
  Script.Add := '    Master.PONO.Value                      := sql.FieldByName(''PONO''); ';
  Script.Add := '    for idx:=1 to 10 do AssignMaster(sql, idx); ';
  Script.Add := '    GetFromQuotationField.Value := sql.FieldByName(''sono'');           ';
  Script.Add := '    Master.ExtendedID.FieldLookup.FieldByName(''Lookup1'').Value := sql.FieldByName(''Lookup1'');                 ';
  Script.Add := '    while not sql.EOF do begin                                                                                      ';
//  Script.Add := '      ratio2 := GetRatio(sql, ''Ratio2''); ';
//  Script.Add := '      ratio3 := GetRatio(sql, ''Ratio3''); ';
  Script.Add := '      if is_distribution_variant then begin ';
  Script.Add := '        if (GetDifferenceQuantity( sql.FieldByName(''itemno''), UOM_QTY1, sql.FieldByName(''Seq'') ) <> 0) ';
  Script.Add := '          or (GetDifferenceQuantity( sql.FieldByName(''itemno''), UOM_QTY2, sql.FieldByName(''Seq'') ) <> 0) ';
  Script.Add := '          or (GetDifferenceQuantity( sql.FieldByName(''itemno''), UOM_QTY3, sql.FieldByName(''Seq'') ) <> 0) then begin ';
  Script.Add := '          AddToDetailSO (sql); ';
  Script.Add := '        end; ';
  Script.Add := '      end ';
  Script.Add := '      else begin ';
  Script.Add := '        if (GetDifferenceQuantity( sql.FieldByName(''itemno''), ''Quantity'', sql.FieldByName(''Seq'') ) <> 0) then begin ';
  Script.Add := '          AddToDetailSO (sql); ';
  Script.Add := '        end; ';
  Script.Add := '      end; ';
  Script.Add := '      sql.Next; ';
  Script.Add := '    end;                                                                                                                ';
  Script.Add := '  finally                                                                                                               ';
  Script.Add := '    sql.Free;                                                                                                       ';
  Script.Add := '  end;                                                                                                                  ';
  Script.Add := 'end;                                                                                                                    ';

  Script.Add := '';
  Script.Add := 'function GetDifferenceQuantity(const ItemNo, InfoField: String; Seq: Integer):Currency; ';
  Script.Add := 'var sql : TjbSQL;';
  Script.Add := '    ATx : TIBTransaction; ';
  Script.Add := '  function TotQuantity:String; ';
  Script.Add := '  begin ';
  Script.Add := '    result := Format(''( CAST(COALESCE(ed.%s, 0) as Money) - (Select COALESCE(Sum( CAST(COALESCE(edi.%s, 0) as Money) ), 0)'', ';
  Script.Add := '      [ InfoField, InfoField ]); ';
  Script.Add := '    if InfoField = ''Quantity'' then begin ';
  Script.Add := '      result := ''( COALESCE(sd.Quantity, 0) - (Select COALESCE(Sum( sdi.Quantity ), 0)''; ';
  Script.Add := '    end; ';
  Script.Add := '    result := result + ';
  Script.Add := '      '' from SO soi left join SODET sdi on soi.SOID = sdi.SOID ''+ ';
  Script.Add := '      ''left join Extended ei on ei.EXTENDEDID = soi.EXTENDEDID ''+ ';
  Script.Add := '      ''left join Extended edi on edi.EXTENDEDID = sdi.EXTENDEDID ''+ ';
  Script.Add := '      Format(''where ei.%s = ''''%s'''' and sdi.%s = sd.SEQ ) )'', ';
  Script.Add := '      [ QUOTATIONNO_FIELD, GetFromQuotationField.Value, SEQ_ITEM ]); ';
  Script.Add := '  end; ';
  Script.Add := 'begin ';
  Script.Add := '  result  := 0; ';
  Script.Add := '  ATx := CreateATx; ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(ATx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sql, ''Select '' + TotQuantity + '' as Quantity ''+ ';
  Script.Add := '      ''from SO s left join SODET sd on s.SOID = sd.SOID '' + ';
  Script.Add := '      ''left join Extended ed on ed.ExtendedID = sd.ExtendedID ''+ ';
  Script.Add := '      Format(''where s.SONO = ''''%s'''' and sd.ItemNo = ''''%s'''' and ''+ ';
  Script.Add := '      ''sd.Seq = %d and '', ';
  Script.Add := '      [ GetFromQuotationField.Value, ItemNo, Seq ] ) + TotQuantity + '' > 0'' ); ';
  Script.Add := '    result := sql.FieldByName(''Quantity''); ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TQuotationInjector.SOGetQuotationData;
begin
  DetailExtended;
  MasterExtended;
  is_distro_variant;
  Script.Add := 'function GetCurrentQty(ItemNo: String; Seq:Integer; ATx: TIBTransaction ):Currency; ';
  Script.Add := 'var sql_qty : TjbSQL; ';
  Script.Add := '  function QtyfromGetQuotation : String;';
  Script.Add := '  begin ';
//  Script.Add := '    result := Format( ''(select Coalesce(Sum(sd1.QUANTITY), 0) from so s1 left join sodet sd1 on sd1.SOID=s1.SOID left join EXTENDED e on e.EXTENDEDID=s1.EXTENDEDID '' + ';
  Script.Add := '    result := Format( ''(select Coalesce(Sum(sd1.QUANTITY*sd1.unitRatio), 0) from so s1 left join sodet sd1 on sd1.SOID=s1.SOID left join EXTENDED e on e.EXTENDEDID=s1.EXTENDEDID '' + '; // AA, BZ 2915
  Script.Add := '      ''where e.%s = ''''%s'''' and sd1.%s=%d and sd1.ITEMNO=''''%s'''')'', [ QUOTATIONNO_FIELD, GetFromQuotationField.Value, SEQ_ITEM, Seq, ItemNo ]); ';
  Script.Add := '  end; ';

  Script.Add :=  EmptyStr;
  Script.Add := '  function GetCurrentQtyQuery : String;';  //SCY BZ 3225
  Script.Add := '  begin ';
  Script.Add := '    Result := ''select CAST(((sd.QUANTITY*sd.unitRatio) -'';';  // AA, BZ 2915
  Script.Add := '    Result := Result + QtyfromGetQuotation + Format('') as Money) CurrentQty from so s '+
                               'left join sodet sd on sd.SOID=s.SOID '+
                               'where s.QUATATION=1 and sd.ITEMNO = ''''%s'''' '+
                               'and sd.SEQ=%d and s.SONO = ''''%s'''' '' '+
                               ', [ItemNo, Seq, GetFromQuotationField.Value]);';
  Script.Add := '  end; ';

  Script.Add := 'begin ';
  Script.Add := '  result := 0; ';
  Script.Add := '  sql_qty := CreateSQL(TIBTransaction(ATx)); ';
  Script.Add := '  try ';
//  Script.Add := '    RunSQL( sql_qty, Format( ''select CAST(sd.QUANTITY - %s as Money) CurrentQty from so s left join sodet sd on sd.SOID=s.SOID ''+ ';
  Script.Add := '    RunSQL(sql_qty, GetCurrentQtyQuery);';

  Script.Add := '    if not sql_qty.Eof then begin ';
  Script.Add := '      result := sql_qty.FieldByName(''CurrentQty''); ';
  Script.Add := '      if result < 0 then result := 0; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    sql_qty.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';

  Script.Add := EmptyStr;
  Script.Add := 'function GetRatio(SQL : TjbSQL; FieldName:String):currency; ';
  Script.Add := 'var sql_ratio : TjbSQL; ';
  Script.Add := 'begin ';
  Script.Add := '  sql_ratio := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sql_ratio, Format( ''Select Coalesce(%s, 0) Ratio from Item '+
                     'where ItemNo = ''''%s'''' '', [ FieldName, sql.FieldByName(''ItemNo'') ] ) ); ';
  Script.Add := '    result := sql_ratio.FieldByName(''Ratio''); ';
  Script.Add := '  finally ';
  Script.Add := '    sql_ratio.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';

{  Script.Add := '  procedure AssignDetail(SQL : TjbSQL; idx:Integer);';
  Script.Add := 'var tot_qty : Currency; ';
  Script.Add := 'begin ';
  Script.Add := '  if is_distribution_variant then begin ';
  Script.Add := '    if (''CUSTOMFIELD''+ IntToStr(idx) = UpperCase(UOM_QTY1)) then begin ';
  Script.Add := '      DetailExtended(UOM_QTY1).Value := uom_qty_1; ';
  Script.Add := '    end; ';
  Script.Add := '    if (''CUSTOMFIELD''+ IntToStr(idx) = UpperCase(UOM_QTY2)) then begin ';
  Script.Add := '      tot_qty := current_qty - uom_qty_1 - (uom_qty_3 * ratio3); ';
  Script.Add := '      if uom_qty_2 > 0 then begin ';
  Script.Add := '        DetailExtended(UOM_QTY2).Value := uom_qty_2; ';
  Script.Add := '        if ratio2 > 0 then begin ';
  Script.Add := '          DetailExtended(UOM_QTY2).Value := tot_qty div ratio2; ';
  Script.Add := '          if tot_qty >= ratio2 then begin ';
  Script.Add := '            DetailExtended(UOM_QTY1).Value := (tot_qty mod ratio2) + uom_qty_1; ';
  Script.Add := '          end; ';
  Script.Add := '          uom_qty_2 := DetailExtended(UOM_QTY2).Value; ';
  Script.Add := '        end; ';
  Script.Add := '      end; ';
  Script.Add := '      if current_qty < ratio2 then begin ';
  Script.Add := '        DetailExtended(UOM_QTY1).Value := current_qty; ';
  Script.Add := '        DetailExtended(UOM_QTY2).Value := 0; ';
  Script.Add := '      end; ';
  Script.Add := '    end; ';
  Script.Add := '    if (''CUSTOMFIELD''+ IntToStr(idx) = UpperCase(UOM_QTY3)) then begin ';
  Script.Add := '      tot_qty := current_qty - uom_qty_1 - (uom_qty_2 * ratio2); ';
  Script.Add := '      DetailExtended(UOM_QTY3).Value := uom_qty_3; ';
  Script.Add := '      if uom_qty_3 > 0 then begin ';
  Script.Add := '        if ratio3 > 0 then begin ';
  Script.Add := '          DetailExtended(UOM_QTY3).Value := tot_qty div ratio3; ';
  Script.Add := '          if tot_qty >= ratio3 then begin ';
  Script.Add := '            DetailExtended(UOM_QTY1).Value := (current_qty - (DetailExtended(UOM_QTY3).Value * ratio3) ) mod ratio3; ';
  Script.Add := '          end; ';
  Script.Add := '          uom_qty_3 := DetailExtended(UOM_QTY3).Value; ';
  Script.Add := '        end; ';
  Script.Add := '      end; ';
  Script.Add := '    end; ';
  Script.Add := '  end ';
  Script.Add := '  else begin ';
  Script.Add := '    Detail.ExtendedID.FieldLookup.FieldByName(''CustomField'' + IntToStr(idx)).Value :=  ';
  Script.Add := '      sql.FieldByName(''DetailCustomfield'' + IntToStr(idx));';
  Script.Add := '  end; ';}

  // AA, BZ 2915
  Script.Add := 'procedure AssignDetail(SQL : TjbSQL; idx:Integer);';
  Script.Add := 'var';
  Script.Add := '  fieldName : string;';
  Script.Add := 'begin';
  Script.Add := '  fieldName := ''CUSTOMFIELD''+ IntToStr(idx);';
  Script.Add := '  if ( ( Not is_distribution_variant )  ';
  Script.Add := '       Or (is_distribution_variant';
  Script.Add := '          And (FieldName<>UpperCase(UOM_QTY1))';
  Script.Add := '          And (FieldName<>UpperCase(UOM_QTY2))';
  Script.Add := '          And (FieldName<>UpperCase(UOM_QTY3))';
  Script.Add := '          )';
  Script.Add := '  ) then begin ';
  Script.Add := '    Detail.ExtendedID.FieldLookup.FieldByName(fieldName).Value := sql.FieldByName(''DetailCustomfield'' + IntToStr(idx));';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure assignQtyFields (SQL : TjbSQL);';
  Script.Add := 'var';
  Script.Add := '  maxFirstQty : currency;';
  Script.Add := '  maxSecondQty : currency;';
  Script.Add := '  maxThirdQty : currency;';
  Script.Add := '  outstandingQty : currency;';
  Script.Add := '  usedQty : currency;';
  Script.Add := '  secondUnitRatio : currency; ';
  Script.Add := '  thirdUnitRatio : currency; ';
  Script.Add := '  itemNo : string;';
  Script.Add := '  itemSeq : integer;';
  Script.Add := '';
  Script.Add := '  procedure fillByMaxValue(fieldName: string; qtyValue: currency; unitRatio: currency);';
  Script.Add := '  begin';
  Script.Add := '    if ( (outstandingQty>0) And (qtyValue>0) ) then begin';
  Script.Add := '      if (qtyValue>(outstandingQty / unitRatio)) then begin';
  Script.Add := '        DetailExtended(fieldName).AsCurrency := trunc(outstandingQty / unitRatio);';
  Script.Add := '      end';
  Script.Add := '      else begin';
  Script.Add := '        DetailExtended(fieldName).AsCurrency := qtyValue;';
  Script.Add := '      end;';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      DetailExtended(fieldName).AsCurrency := 0;';
  Script.Add := '    end;';
  Script.Add := '    outstandingQty := outstandingQty - (DetailExtended(fieldName).AsCurrency*unitRatio);';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  procedure fillWithoutRemainder(fieldName: string; unitRatio: currency);';
  Script.Add := '  var';
  Script.Add := '    nonFractionQty : integer;';
  Script.Add := '  begin';
  Script.Add := '    if (outstandingQty>0) then begin';
  Script.Add := '      nonFractionQty := trunc(outstandingQty / unitRatio);';
  Script.Add := '      if (nonFractionQty>0) then begin';
  Script.Add := '        DetailExtended(fieldName).AsCurrency := DetailExtended(fieldName).AsCurrency + nonFractionQty;';
  Script.Add := '        outstandingQty := outstandingQty - (nonFractionQty*unitRatio);';
  Script.Add := '      end;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  if is_distribution_variant then begin ';
  Script.Add := '    itemNo := sql.FieldByName(''ItemNo'');';
  Script.Add := '    itemSeq := sql.FieldByName(''Seq'');';
  Script.Add := '    DetailExtended(UOM_QTY1).asCurrency := 0;';
  Script.Add := '    DetailExtended(UOM_QTY2).asCurrency := 0;';
  Script.Add := '    DetailExtended(UOM_QTY3).asCurrency := 0;';
  Script.Add := '';
  Script.Add := '    maxFirstQty := GetDifferenceQuantity( itemNo, UOM_QTY1, itemSeq ); ';
  Script.Add := '    maxSecondQty := GetDifferenceQuantity( itemNo, UOM_QTY2, itemSeq ); ';
  Script.Add := '    maxThirdQty := GetDifferenceQuantity( itemNo, UOM_QTY3, itemSeq ); ';
  Script.Add := '    secondUnitRatio := GetRatio(sql, ''Ratio2''); ';
  Script.Add := '    thirdUnitRatio := GetRatio(sql, ''Ratio3''); ';
  Script.Add := '';
  Script.Add := '    outstandingQty := GetCurrentQty( itemNo, itemSeq, TIBTransaction(Tx) );';
  Script.Add := '    fillByMaxValue(UOM_QTY1, maxFirstQty, 1);';
  Script.Add := '    fillByMaxValue(UOM_QTY2, maxSecondQty, secondUnitRatio);';
  Script.Add := '    fillByMaxValue(UOM_QTY3, maxThirdQty, thirdUnitRatio);';
  Script.Add := '';
  Script.Add := '    fillWithoutRemainder(UOM_QTY3, thirdUnitRatio);';
  Script.Add := '    fillWithoutRemainder(UOM_QTY2, secondUnitRatio);';
  Script.Add := '    if (outstandingQty>0) then begin';
  Script.Add := '      DetailExtended(UOM_QTY1).asCurrency := DetailExtended(UOM_QTY1).asCurrency + outstandingQty;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  // AA, end of BZ 2915

  Script.Add := 'procedure AssignMaster(SQL : TjbSQL; idx:Integer); ';
  Script.Add := 'begin ';
  Script.Add := '  try ';
  Script.Add := '    MasterExtended(''CustomField'' + IntToStr(idx)).Value := sql.FieldByName(''MasterCustomfield'' + IntToStr(idx));';
  Script.Add := '  except ';
  Script.Add := '    MasterExtended(''CustomField'' + IntToStr(idx)).Value := DateToStr( StrSQLToDate(sql.FieldByName(''MasterCustomfield'' + IntToStr(idx))) ); ';
//  Script.Add := '    MasterExtended(''CustomField'' + IntToStr(idx)).Value := FormatDateTime( ShortDateFormat, StrSQLToDate(sql.FieldByName(''MasterCustomfield'' + IntToStr(idx))) ); '; //note : opsi mau pilih cara atas atau ini
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure AssignItemReserved(SQL : TjbSQL; idx:Integer); ';
  Script.add := 'begin ';
  Script.Add := '  if ( SEQ_ITEM <> ''ITEMRESERVED'' + IntToStr(idx) ) then begin ';
  Script.Add := '    Detail.FieldByName(''ItemReserved'' + IntToStr(idx)).Value := sql.FieldByName(''ItemReserved'' + IntToStr(idx));';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure AddToDetailSO (SQL : TjbSQL); ';
  Script.Add := 'var';
  Script.Add := '  idx : Integer;';
  Script.Add := 'begin ';
  Script.Add := '  Detail.Append;                                                                                                    ';
  Script.Add := '  Detail.ItemNo.Value      := sql.FieldByName(''itemno'');                                                    ';
  Script.Add := '  Detail.Quantity.Value    := GetDifferenceQuantity( sql.FieldByName(''itemno''), ''Quantity'', sql.FieldByName(''Seq'') ); ';
  Script.Add := '  Detail.TaxCodes.Value    := sql.FieldByName(''TaxCodes''); ';
  Script.Add := '  if is_distribution_variant then begin ';
  Script.Add := '    DetailExtended(UOM_UP1).Value := sql.FieldByName(''Detail'' + UOM_UP1); ';
  Script.Add := '    DetailExtended(UOM_UP2).Value := sql.FieldByName(''Detail'' + UOM_UP2); ';
  Script.Add := '    DetailExtended(UOM_UP3).Value := sql.FieldByName(''Detail'' + UOM_UP3); ';
  Script.Add := '  end ';
  Script.Add := '  else begin ';
  Script.Add := '    Detail.UnitPrice.Value   := sql.FieldByName(''unitprice'');                                            ';
  Script.Add := '  end; ';
  Script.Add := '  if sql.FieldByName(''ItemUnit'') <> Null then begin                                                          ';
  Script.Add := '    Detail.ItemUnit.Value  := sql.FieldByName(''ItemUnit'');                                              ';
  Script.Add := '    Detail.UnitRatio.Value := sql.FieldByName(''UnitRatio'');                                          ';
  Script.Add := '  end;                                                                                                              ';
  Script.Add := '  Detail.ItemOvDesc.Value    := sql.FieldByName(''itemovdesc'');                                            ';
  Script.Add := '  Detail.FieldByName(SEQ_ITEM).Value := sql.FieldByName(''seq''); ';
//  Script.Add := '  if is_distribution_variant then begin ';
//  Script.Add := '    uom_qty_1 := GetDifferenceQuantity( sql.FieldByName(''ItemNo''), UOM_QTY1, sql.FieldByName(''Seq'') ); ';
//  Script.Add := '    uom_qty_2 := GetDifferenceQuantity( sql.FieldByName(''ItemNo''), UOM_QTY2, sql.FieldByName(''Seq'') ); ';
//  Script.Add := '    uom_qty_3 := GetDifferenceQuantity( sql.FieldByName(''ItemNo''), UOM_QTY3, sql.FieldByName(''Seq'') ); ';
//  Script.Add := '  end; ';
//  Script.Add := '  current_qty := GetCurrentQty( sql.FieldByName(''ItemNo''), sql.FieldByName(''Seq''), TIBTransaction(Tx) ); ';
  Script.Add := '  assignQtyFields (sql);'; // AA, BZ 2915
  Script.Add := '  for idx := 1 to 20 do AssignDetail(sql, idx); ';
  Script.Add := '  for idx := 1 to 10 do AssignItemReserved(sql, idx); ';
  Script.Add := '  Detail.Post;  ';
  Script.Add := 'end; ';
  Script.Add := '';

  ProceedQuotationData;
end;



procedure TQuotationInjector.SOFormChooseQuotation;
begin
  Script.Add := 'procedure OnFormClose(Sender : TObject; var Action : TCloseAction);                  ';
  Script.Add := 'begin                                                                             ';
  Script.Add := '  action := caFree;                                                               ';
  Script.Add := 'end;                                                                              ';
  Script.Add := '                                                                                  ';
  Script.Add := 'procedure DecorateFrmChooseQuotation;                                                                                   ';
  Script.Add := 'begin                                                                                                                   ';
  Script.Add := '  BtnOK     := CreateBtn( 5, FrmChooseQuotation.Height-70, 100, 30, 0, ''Ok'', FrmChooseQuotation );                         ';
  Script.Add := '  BtnCancel := CreateBtn( btnOK.Left + btnOK.Width, btnOK.Top, btnOK.Width, btnOK.Height, 0, ''Cancel'', FrmChooseQuotation );               ';
  Script.Add := '  listQuotation := CreateListView(FrmChooseQuotation, 0, 0, FrmChooseQuotation.ClientWidth, 320);                                                  ';
  Script.Add := '  listQuotation.ViewStyle := vsReport;';
  Script.Add := '  CreateListViewCol(listQuotation, ''SOID'', -1); ';
  Script.Add := '  CreateListViewCol(listQuotation, ''SONO'', 0); ';
  Script.Add := '  FillListQuotation;                                                                                                    ';
  Script.Add := '  BtnOK.OnClick         := @BtnOKClick;                                                                                        ';
  Script.Add := '  BtnCancel.ModalResult := mrCancel;                                                                                    ';
  Script.Add := 'end;                                                                                                                    ';
  Script.Add := '';
  Script.Add := 'procedure CreateFrmChooseQuotation;                                                                                     ';
  Script.Add := 'begin                                                                                                                   ';
  Script.Add := '  FrmChooseQuotation          := TForm.Create(Form);                                                                             ';
  Script.Add := '  FrmChooseQuotation.Name     := ''FrmChooseQuotation'';                                                                      ';
  Script.Add := '  FrmChooseQuotation.Width    := 400;                                                                                      ';
  Script.Add := '  FrmChooseQuotation.Height   := 400;                                                                                     ';
  Script.Add := '  FrmChooseQuotation.Position := 6;                                                                                     ';
  Script.Add := '  FrmChooseQuotation.Caption  := ''Select Quotation'';                                                                     ';
  Script.Add := '  FrmChooseQuotation.BorderIcons := biSystemMenu;                                                                       ';
  Script.Add := '  FrmChooseQuotation.OnClose  := @OnFormClose;                                                               ';
  Script.Add := '  DecorateFrmChooseQuotation;   ';
  Script.Add := '  FrmChooseQuotation.ShowModal; ';
  Script.Add := 'end;                                                                                                                    ';
  Script.Add := '';
  SOFillListQuotation;
  SOGetQuotationData;
  Script.Add := 'procedure BtnOKClick;                                                                                                   ';
  Script.Add := 'begin                                                                                                                   ';
  Script.Add := '  GetQuotationData;                                                                                                     ';
  Script.Add := '  FrmChooseQuotation.Close;                                                                                             ';
  Script.Add := '  RefreshBtnQuotation;                                                                                                  ';
  Script.Add := 'end;                                                                                                                    ';
  Script.Add := '';

end;


procedure TQuotationInjector.SOGetQuotation ;
begin
  Script.Add := 'var BtnGetQuotation, BtnOK, BtnCancel : TButton; ';
  Script.Add := '    FrmChooseQuotation : TForm; ';
  Script.Add := '    listQuotation      : TListView;  ';
  Script.Add := '';
  Script.Add := 'function GetFromQuotationField:TField; ';
  Script.Add := 'begin ';
  Script.Add := '  result := Master.ExtendedID.FieldLookup.FieldByName(QUOTATIONNO_FIELD); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'Function IsGetFromQuotation:Boolean; ';
  Script.Add := 'begin ';
  Script.Add := '  result := not GetFromQuotationField.IsNull; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure RefreshBtnQuotation;                                                                                          ';
  Script.Add := 'begin ';
  Script.Add := '  BtnGetQuotation.Visible := not IsQuotation;       ';
  Script.Add := '  BtnGetQuotation.Enabled := not IsGetFromQuotation;';
  Script.Add := '  Form.pnlJbButtons.Width := Form.pnlJbButtons.width + 1; '; //agar posisi tombol bisa diatur ulang
  Script.Add := 'end;                                                                                                                    ';
  Script.Add := '';
  SOFormChooseQuotation;
  Script.Add := 'procedure BtnGetQuotationClick;                                                                                         ';
  Script.Add := 'begin              ';
  Script.Add := '  if not Detail.IsEmpty then RaiseException(''Cannot get Quotation!'');';
  Script.Add := '  if Master.CustomerID.isNull then RaiseException(''Field Customer must have a value'');                                  ';
  Script.Add := '  CreateFrmChooseQuotation;';
  Script.Add := 'end;                                                                                                                    ';
  Script.Add := '';
  Script.Add := 'procedure CreateBtnGetQuotation; ';
  Script.Add := 'begin  ';
  Script.Add := '  Form.pnlRightTop.Height := Form.pnlRightTop.Height + 50; '; //JR, BZ 2524
  Script.Add := '  BtnGetQuotation := CreateBtn( 0, Form.AcboSalesman.Top + Form.AcboSalesman.Height+50, '+
                     'Form.pnlJbButtons.Width, 20, 10, ''Get Quotation'', Form.pnlRightTop);';
  Script.Add := '  BtnGetQuotation.OnClick := @BtnGetQuotationClick;  ';
  Script.Add := '  RefreshBtnQuotation; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function ThereIsDifferenceQuantityPerItem:Boolean; ';
  Script.Add := 'var sql   : TjbSQL; ';
  Script.Add := '    count : Integer; ';
  Script.Add := '  function QuerySODET:String; ';
  Script.Add := '  begin ';
  Script.Add := '    result := Format(''select sd.ItemNo, sd.Seq, sd.Quantity, ed.%s, ed.%s from SO s left join ''+ ';
  Script.Add := '      ''SODET sd on s.SOID = sd.SOID left join Extended ed on ed.ExtendedID = sd.ExtendedID ''+ ';
  Script.Add := '      ''where s.SONO = ''''%s'''' and LEFT(sd.ITEMOVDESC, 2) <> ''''--'''' '', ';
  Script.Add := '      [ UOM_QTY2, UOM_QTY3, GetFromQuotationField.Value ] ); ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := '  result := False; ';
  Script.Add := '  count  := 0; ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Detail.Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sql, QuerySODET ); ';
  Script.Add := '    while not sql.Eof do begin ';
  Script.Add := '      if GetCurrentQty( sql.FieldByName(''ItemNo''), sql.FieldByName(''Seq''), Detail.Tx ) > 0 then begin ';
  Script.Add := '        count := count +1;';
  Script.Add := '      end; ';
  Script.Add := '      sql.Next; ';
  Script.Add := '    end; ';
  Script.Add := '    if count > 0 then result := True; ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure DoSetQuotationStatus; ';
  Script.Add := 'var sql:TjbSQL; ';
  Script.Add := '    proceed : Integer; ';
  Script.Add := '  procedure SetNotProceed; ';
  Script.Add := '  begin ';
  Script.Add := '    RunSQL( sql, format(''Update SO set Proceed=%d where SONo = ''''%s'''' '', ';
  Script.Add := '      [proceed, GetFromQuotationField.Value]) ); ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  procedure SetStatus; ';
  Script.Add := '  begin ';
  Script.Add := '    SetNotProceed;'; // to accomodate SProc GET_VALUE_SO, call at before update SO Table
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := 'begin ';
  Script.Add := '  if not IsGetFromQuotation then exit; ';
  Script.Add := '  if CLOSE_QUO_AFTER_SO = ''0'' then exit; ';
  Script.Add := '  proceed := 0; ';
  Script.Add := '  if not ThereIsDifferenceQuantityPerItem then begin ';
  Script.Add := '    proceed := 1; ';
  Script.Add := '  end; ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Master.Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    case proceed of ';
  Script.Add := '      0 : SetNotProceed; ';
  Script.Add := '      1 : begin ';
  Script.Add := '            SetNotProceed; ';
  Script.Add := '            SetStatus; ';
  Script.Add := '          end; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TQuotationInjector.InitializeVariable(const State: TState);
begin
  ReadOption;
  Script.Add := 'var QUOTATIONNO_FIELD   : String; ';
  Script.Add := '    TEMPLATE_QUOTATION  : Array of Integer; ';
  Script.Add := '    SEQ_ITEM            : String; ';
  if State <> SODataset then begin
    Script.Add := '    NEED_APPROVAL_FIELD : String; ';
    Script.Add := '    APPROVED_FIELD      : String; ';
    Script.Add := '    CLOSE_QUO_AFTER_SO  : String; ';
  end;
  if State = SO then begin
    Script.Add := '    UOM_QTY1 : String; ';
    Script.Add := '    UOM_QTY2 : String; ';
    Script.Add := '    UOM_QTY3 : String; ';
    Script.Add := '    UOM_UP1  : String; ';
    Script.Add := '    UOM_UP2  : String; ';
    Script.Add := '    UOM_UP3  : String; ';
  end;
  Script.Add := '';
  Script.Add := 'procedure InitializeVariable; ';
  Script.Add := 'begin ';
  Script.Add := '  QUOTATIONNO_FIELD   := ReadOption(''QUOTATIONNO_FIELD'', ''CUSTOMFIELD10''); ';
  Script.Add := '  SEQ_ITEM            := ReadOption(''SEQ_ITEM'', ''ITEMRESERVED9''); ';
  if State <> SODataset then begin
    Script.Add := '  NEED_APPROVAL_FIELD := ReadOption(''NEED_APPROVAL_FIELD''); ';
    Script.Add := '  APPROVED_FIELD      := ReadOption(''APPROVED_FIELD''); ';
    Script.Add := '  CLOSE_QUO_AFTER_SO  := ReadOption(''CLOSE_QUO_AFTER_SO''); ';
  end;
  Script.Add := 'end; ';
  Script.Add := '';
  if State = SO then begin
    setOptionsDistro;
  end;
end;


procedure TQuotationInjector.RecreateOnExit;
begin
  Script.Add := 'procedure CheckPONumber; ';
  Script.Add := 'var sql : TjbSQL; ';
  Script.Add := 'begin ';
  Script.Add := '  if Master.PONO.IsNULL then Exit; ';
  Script.Add := '  if not IsQuotation then begin ';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '    try ';
  Script.Add := '      RunSQL( sql, Format(''Select s.PONO From SO s where s.PONO = ''''%s'''''',[Master.PONO.Value]) ); ';
  Script.Add := '      if not sql.Eof then begin ';
  Script.Add := '        if MessageDlg(''PO Number already exist'' + #13 +''Do you want to continue?'', mtConfirmation, mbOK + MbCancel, 0 ) <> 1 then begin ';
  Script.Add := '          Form.edtPONO.SetFocus; ';
  Script.Add := '        end; ';
  Script.Add := '      end; ';
  Script.Add := '    finally ';
  Script.Add := '      sql.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := ' ';
  Script.Add := 'procedure ReCreateOnExit; ';
  Script.Add := 'begin ';
  Script.Add := '  Form.edtPONO.OnExit := @CheckPONumber; ';
  Script.Add := 'end; ';
  Script.Add := ' ';
end;

procedure TQuotationInjector.DoExecuteDetail;
begin
  Script.Add := EmptyStr;
  Script.Add := 'procedure DoBeforeSave;';
  Script.Add := 'begin';
  //for inherited
  Script.Add := 'end;';

  Script.Add := EmptyStr;
  Script.Add := 'procedure DoItemNoOnChange;';
  Script.Add := 'begin';
  //for inherited
  Script.Add := 'end;';  
end;

procedure TQuotationInjector.GenerateSO;
begin
  ClearScript;
  CreateTx;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  InitializeVariable(SO);
  CreateButton;
  CreateListView;
  GetQuotationTemplateID;
  SOIsQuotation;
  SORunningNumber;
  SOArrayOfIntToStr;
  SOGetQuotation;
  RecreateOnExit;
  MasterOnBeforePostAudit;
  MasterOnBeforeSave;

  DoExecuteDetail;
  
  Script.Add := '';
  Script.Add := 'procedure ValidateItemDesc;';
  Script.Add := 'begin';
  Script.Add := '  if (Detail.ItemOvDesc.AsString = '''') then begin';
  Script.Add := '    RaiseException (''Mohon isi item deskripsi dahulu'');';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure ValidateQuotation;';
  Script.Add := 'var';
  Script.Add := '  IsDetailItemQuotationExist : Boolean;';
  Script.Add := 'begin';
  Script.Add := '  Detail.DisableControls;';
  Script.Add := '  try';
  Script.Add := '    Detail.First;';
  Script.Add := '    IsDetailItemQuotationExist := False;';
  Script.Add := '    while NOT Detail.EOF do begin';
  Script.Add := '      if IsNumeric (Detail.FieldByName(SEQ_ITEM).AsString) then begin';
  Script.Add := '        IsDetailItemQuotationExist := True;';
  Script.Add := '        Break;';
  Script.Add := '      end;';
  Script.Add := '      Detail.Next;';
  Script.Add := '    end;';
  Script.Add := '    if NOT IsDetailItemQuotationExist then begin';
  Script.Add := '      MasterExtended(QUOTATIONNO_FIELD).AsString := '''';';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    Detail.EnableControls;';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := 'begin';
  Script.Add := '  setOptionsDistro(UOM_QTY1, UOM_QTY2, UOM_QTY3, UOM_UP1, UOM_UP2, UOM_UP3);';
  Script.Add := '  DataModule.EmptyOnConfirmDuplicatePONo;';
  Script.Add := '  Master.PONO.OnChangeArray       := @ReCreateOnExit;';
  Script.Add := '  InitializeVariable;';
  Script.Add := '  GetQuoTemplateID;';
  Script.Add := '  CreateBtnGetQuotation;';
  Script.Add := '  Master.TemplateID.OnChangeArray    := @DoGetSONo;';
  Script.Add := '  Master.TemplateID.OnChangeArray    := @RefreshBtnQuotation;';
  Script.Add := '  Master.OnNewRecordArray            := @DoGetSoNo;';
  Script.Add := '  Master.OnBeforePostAuditArray      := @MasterOnBeforePostAudit;';
  Script.Add := '  Master.on_before_save_array        := @ValidateQuotation;';  //SCY BZ 2884
  Script.Add := '  Master.on_before_save_array        := @MasterOnBeforeSave;';
  Script.Add := '  Detail.OnBeforePostValidationArray := @ValidateItemDesc;';  //SCY BZ 2884
  Script.Add := '  Master.on_before_save_array        := @DoBeforeSave;';  //SCY BZ 3223
  Script.Add := '  Detail.ItemNo.OnChangeArray        := @DoItemNoOnChange;';  //SCY BZ 3223  
  Script.Add := '  DoGetSoNo;';
  Script.Add := 'end.';
end;

procedure TQuotationInjector.GenerateSODataset;
begin
  ClearScript;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  InitializeVariable(SODataset);
  SOArrayOfIntToStr;
  GetQuotationTemplateID;
  SOIsQuotation('Dataset');
  DatasetOnBeforeDeleteSO;
  Script.Add := 'procedure DoCheckCreditLimit; ';
  Script.Add := 'begin ';
  Script.Add := '  Dataset.ShallDoCheckCreditLimit := True; ';
  Script.Add := '  if IsQuotation then begin ';
  Script.Add := '    Dataset.ShallDoCheckCreditLimit := False; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := '  InitializeVariable; ';
  Script.Add := '  GetQuoTemplateID; ';
  Script.Add := '  Dataset.OnBeforeDeleteArray := @DatasetOnBeforeDeleteSO;      ';
  Script.Add := '  Dataset.on_before_save_array := @DoCheckCreditLimit; ';
  Script.Add := 'end. ';
end;

procedure TQuotationInjector.SOsFilterQuotation;
begin
  Script.Add := 'var';
  Script.Add := '  rbQuotation, rbSO : TRadioButton;';
  Script.Add := '';
  Script.Add := 'function GetSQL:String; ';
  Script.Add := '  function Sign:String; ';
  Script.Add := '  begin ';
  Script.Add := '    if rbQuotation.Checked then result := '''' else result := ''not''; ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := '  result := '' and '' + Sign + '' (A.TemplateID in ('' + ArrayOfIntToStr + ''))''; ';
  Script.Add := 'end; ';
  Script.Add := '';
  AddFilterSOList;
  Script.Add := 'procedure rbFilterClick; ';
  Script.Add := 'begin ';
  Script.Add := '  Form.SetFilterAndRun; ';
  Script.Add := 'end; ';
  Script.Add := '';
  create_rb;
end;

procedure TQuotationInjector.GenerateSOList;
begin
  ClearScript;
  CreateTx;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  InitializeVariable(SOList);
  GetQuotationTemplateID;
  CreateRadioButton;
  SOArrayOfIntToStr;
  CreateLabel;
  CreateCheckBox;
  CreateEditBox;
  IsAdmin;
  TopPos;
  SOsFilterQuotation;
  Script.Add := 'begin ';
  AddMainSOList;
  Script.Add := 'end. ';
end;

procedure TQuotationInjector.ShowSetting;
begin
  Script.Add := 'procedure ShowSetting; ';
  Script.Add := 'var frmSetting : TForm; ';
  Script.Add := 'begin ';
  Script.Add := '  frmSetting := CreateFormSetting(''frmSetting'', ''Quotation Setting'', 400, 400);';
  Script.Add := '  try ';
  Script.Add := '    AddControl( frmSetting, ''Quotation No Field'',   ''CUSTOMFIELD'', ''QUOTATIONNO_FIELD'', ''CUSTOMFIELD10'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Close Quotation After SO'',   ''TEXT'', ''CLOSE_QUO_AFTER_SO'', ''1'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Sequence Item Quotation'',   ''TEXT'', ''SEQ_ITEM'', ''ITEMRESERVED9'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Filter Quotation Get From SO'',   ''CHECKBOX'', ''SCRIPT_ON_QUO'', ''1'', ''0'', ''''); ';
  Script.Add := '    if frmSetting.ShowModal = mrOK then begin ';
  Script.Add := '      SaveToOptions; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    frmSetting.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
end;

procedure TQuotationInjector.MainCreateMenuSetting;
begin
  CreateFormSetting;
  ShowSetting;
  Script.Add := '';
  Script.Add := 'procedure AddMenuSetting;';
  Script.Add := 'var mnuQuotationSetting : TMenuItem; ';
  Script.Add := 'begin ';
  Script.Add := '  mnuQuotationSetting := TMenuItem(Form.FindComponent( ''mnuQuotationSetting'' )); ';
  Script.Add := '  if mnuQuotationSetting <> nil then mnuQuotationSetting.Free; ';
  Script.Add := '  mnuQuotationSetting := TMenuItem.Create( Form );';
  Script.Add := '  mnuQuotationSetting.Name := ''mnuQuotationSetting'';';
  Script.Add := '  mnuQuotationSetting.Caption := ''Setting Quotation'';';
  Script.Add := '  mnuQuotationSetting.OnClick := @ShowSetting;';
  Script.Add := '  mnuQuotationSetting.Visible := True;';
  Script.Add := '  Form.AmnuEdit.Add( mnuQuotationSetting );';
  Script.Add := 'end; ';
  Script.Add := '';
end;


procedure TQuotationInjector.MasterOnBeforePostAudit;
begin
  Script.Add := 'procedure MasterOnBeforePostAudit; ';
  Script.Add := 'begin ';
  //Script.Add := '  if ( Master.PONO.Value = NULL ) and IsQuotation then begin ';
  //Script.Add := '    RaiseException(''Please fill fist PONO''); ';
  //Script.Add := '  end; ';
  Script.Add := '  DoIncrementSONo;';
  Script.Add := '  if Master.IsFirstPost then Exit; ';
  Script.Add := '  DoSetQuotationStatus;';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TQuotationInjector.MasterOnBeforeSave;
begin
  QueryTemplateID;
  Script.Add := 'procedure MasterOnBeforeSave; ';
  Script.Add := 'var soid : Integer; ';
  Script.Add := '    item_quo_exist : Boolean; ';
  Script.Add := '  function IsItemFromQuotation:Boolean; ';
  Script.Add := '  var sql : TjbSQL; ';
  Script.Add := '  begin ';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '    try ';
  Script.Add := '      RunSQL( sql, Format(''Select s.SOID From SO s left join SODET sd on ''+ ';
  Script.Add := '        ''sd.SOID = s.SOID where s.SONO = ''''%s'''' ''+ ';
  Script.Add := '        ''and s.TemplateID in (%s) and sd.ItemNo = ''''%s'''' '', ';
  Script.Add := '        [MasterExtended(QUOTATIONNO_FIELD).Value, QueryTemplateID, Detail.ItemNo.AsString] )); ';
  Script.Add := '      result := not sql.Eof; ';
  Script.Add := '    finally ';
  Script.Add := '      sql.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  function IsPONOAlreadyExist:Boolean; ';
  Script.Add := '  var sql : TjbSQL; ';
  Script.Add := '  begin ';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '    try ';
  Script.Add := '      RunSQL(sql, Format(''Select s.PONO from SO s where s.PONO = ''''%s'''' '', ';
  Script.Add := '        [Master.PONO.AsString]) );';
  Script.Add := '      result := not sql.Eof; ';
  Script.Add := '    finally ';
  Script.Add := '      sql.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := 'begin ';
  Script.Add := '  if Master.Proceed.AsInteger = 1 then Exit; ';
  Script.Add := '  if IsQuotation then begin ';
  Script.Add := '    Master.Edit; ';
  Script.Add := '    Master.Quatation.Value := 1; ';
  Script.Add := '    Exit; ';
  Script.Add := '  end; ';
  Script.Add := '  if not IsPONOAlreadyExist then Exit; ';
  Script.Add := '  if MasterExtended(QUOTATIONNO_FIELD).IsNull then Exit; ';
  Script.Add := '  item_quo_exist := False; ';
  Script.Add := '  Detail.First; ';
  Script.Add := '  while not Detail.Eof do begin ';
  Script.Add := '    if IsItemFromQuotation then begin ';
  Script.Add := '      item_quo_exist := True; ';
  Script.Add := '    end; ';
  Script.Add := '    Detail.Next; ';
  Script.Add := '  end; ';
  Script.Add := '  if not item_quo_exist then RaiseException(''Item from Quotation not available, please retry to input''); ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TQuotationInjector.QueryTemplateID;
begin
  Script.Add := 'function QueryTemplateID:String; ';
  Script.Add := 'begin ';
  Script.Add := '  result := ''Select ti.TemplateID from Template ti where ti.TemplateType=1 and ti.NAME containing ''''quotation'''' ''; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TQuotationInjector.GenerateMain;
begin
  ClearScript;
  MainCreateMenuSetting;
  Script.Add := 'BEGIN';
  Script.Add := '  AddMenuSetting; ';
  Script.Add := 'END.';
end;

procedure TQuotationInjector.GenerateScript;
begin
  GenerateSO;
  InjectToDB( fnSalesOrder );

  GenerateSOList;
  InjectToDB( fnSalesOrders );

  GenerateMain;
  InjectToDB( fnMain );

  GenerateForChooseForm;
  InjectToDB( fnChoose );

  GenerateSODataset;
  InjectToDB( dnSO );
end;

initialization
  Classes.RegisterClass( TQuotationInjector );

end.
