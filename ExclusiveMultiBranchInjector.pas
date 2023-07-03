unit ExclusiveMultiBranchInjector;

interface
uses Injector, Sysutils,BankConst, ScriptConst;

const
  personTypeNone = 0;
  personTypeCust = 1;
  personTypeVend = 2;
  UseWarehouse = true;
  NoWarehouse  = false;
  UseBank      = true;
  NoBank       = false;
  UseTemplate  = true;
  NoTemplate   = false;
  UseSalesman  = true;
  NoSalesman   = false;
  UseBeforePost = true;
  NoBeforePost  = false;
  UseDiscInfo   = true;
  NoDiscInfo    = false;
  UseItem       = true;
  NoItem        = false;

  //MMD, BZ 3522
  UseDepositTo  = true;
  NoDepositTo = false;
  UseBank_Receive = true;
  NoBank_Receive = false;

Type
  TExclusiveMultiBranchInjector = class(TInjector)
  private
    procedure add_procedure_HideBtnNextPrevious(formtrans:String);
    procedure GenerateScriptForChooseForm;
    procedure GenerateScriptForCustomers;
    procedure add_procedure_ChangeCustomerQuery;
    procedure SetDeptByUser(IsDiscInfo : Boolean; formname : string);
    procedure SetProjectByUser(IsDiscInfo : Boolean; formname : string);  //SCY BZ 3210
    procedure GenerateScriptDeptbyUser;
    procedure GenerateScriptForSalesman;
    procedure GenerateScriptForSalesmans;
    procedure GenerateScriptForAccount;
    procedure GenerateScriptForDepartements;
    procedure GenerateScriptForDepartement;
    procedure GenerateScriptForProjects;  //SCY BZ 3210
    procedure GenerateScriptForProject;  //SCY BZ 3210
    procedure GenerateScriptForWarehouses;
    procedure GenerateScriptForWarehouse;
    procedure GenerateScriptForFixedAssets;
    procedure GenerateScriptForFixedAsset;
    procedure GenerateScriptForTemplates;
    procedure GenerateScriptForTemplate;
    procedure GenerateScriptForCustomer;
    procedure GenerateScriptSOs;
    procedure GenerateScriptSO;
    procedure GenerateScriptTrans(FieldChangearray,formtrans : String;
              PersonType : Integer;
              IsWareHouse,IsBank,IsTemplate,IsSalesman,IsBeforePost,IsDiskonInfo, IsUseItem, IsDepositTo, IsBank_Receive : boolean);

    procedure GenerateScriptForList2(aliasfield, fieldnosql,fieldbeforeopen, formname,
              fielddateFrom,fielddateTo,fieldnamedate,NameDateReplace : String; IsFilterDate,IscekDate : Boolean);

    procedure GenerateScriptDOs;
    procedure GenerateScriptDO;
    procedure GenerateScriptSI;
    procedure GenerateScriptSRs;
    procedure GenerateScriptSR;
    procedure GenerateScriptCR;

    procedure GenerateScriptPOs;
    procedure GenerateScriptPO;
    procedure GenerateScriptOP;
    procedure GenerateScriptJVs;
    procedure GenerateScriptJV;
    procedure GenerateScriptOR;
    procedure GenerateScriptRIs;
    procedure GenerateScriptRI;
    procedure GenerateScriptPIs;
    procedure GenerateScriptPI;
    procedure GenerateScriptPRs;
    procedure GenerateScriptPR;
    procedure GenerateScriptVPs;
    procedure GenerateScriptVP;
    procedure GenerateScriptIRs;
    procedure GenerateScriptIR;
    procedure GenerateScriptITs;
    procedure GenerateScriptIT;
    procedure GenerateScriptIAs;
    procedure GenerateScriptIA;
    procedure GenerateScriptJCs;
    procedure GenerateScriptJC;
    procedure GenerateScriptIADs;
    procedure add_procedure_ChangeVendorQuery;
    procedure GenerateScriptForVendors;
    procedure GenerateScriptForItems;
    procedure GenerateScriptItemSearchForm;
    procedure AddProcedureValidateItem(IsUseItem: Boolean);
    procedure ValidateItem(IsUseItem: Boolean);
    procedure GenerateScriptForVendor;
    procedure GenerateScriptForItem;
    procedure AddProcedureBeforePostAndNewRecord(AFormName: String;
      AUseBeforePost, AUseWarehouse, AUseTemplate, AUseDiscInfo: Boolean);
    procedure AddProcedureTemplate(AFormName: String; AUseTemplate: Boolean);
    procedure GenerateScriptJCRO;
    procedure GenerateScriptPIDataset;
    procedure GenerateScriptForCreateCollection; //MMD, BZ 3521
    procedure GenerateScriptForChequeControl;  //MMD, BZ 3523
    procedure GenerateScriptForLoading;  //MMD, BZ 3525
  protected
    procedure set_scripting_parameterize; override;
    procedure CreateSettingControl; virtual;
    procedure add_function_getCabang(FormGeneral:String = 'ALL'); virtual;
    procedure add_condition_name_change(formtrans:String); virtual;
    procedure add_before_open_on_script_list(const formname, fieldnosql, aliasfield:String); virtual;
    procedure add_main_before_open_on_script_list(const formname, fieldnosql, aliasfield:String);virtual;
    procedure main_script_for_list(const formname, fieldbeforeopen, datasetname: String); virtual;
    procedure add_validate_cabang_name(const formtrans: String); virtual;
    procedure get_department_id; virtual;
    procedure get_project_id; virtual;  //SCY BZ 3210
    procedure add_change_customer_query(const formtrans: String); virtual;
    procedure DoAssignSOSQL; virtual;
    procedure add_validate_before_post;  virtual;
    procedure add_main_general(const formtrans: String); virtual;
    class procedure add_var_cabang_name(const formname: String; Script: TScriptList); virtual;
    class procedure add_get_where_clause(const formname: String; Script: TScriptList); virtual;
    class procedure add_query_extended(const formname: String; Script: TScriptList); virtual;
    procedure Variables(formname: String='');
    procedure GenerateScriptTrans2(FieldChangearray,FieldNameChange,FieldValidate,formtrans : String;
              IsNewRecord,IsVisibleBtn : Boolean); virtual;
    procedure getUserCabangName;
    function TwoWarehouse(AFormName: String): Boolean; virtual;
    procedure ChangeWarehouseQuery; virtual;
    procedure SetCostCentreQuery (tableName : string); virtual;  //SCY BZ 3210
    procedure SetCostCentre; virtual;  //SCY BZ 3210
    procedure SetAccountQuery (formtrans : string); virtual;  //SCY BZ 3230
    procedure SetAccount; virtual;  //SCY BZ 3230
    procedure add_procedure_ChangeWarehouseQuery( UseWarehouse:Boolean; AFormName:String ); virtual;
    procedure add_procedure_ChangeTemplateQuery(formname : string); virtual;
    procedure add_procedure_ChangeTemplateQueryJournal; virtual;
    procedure add_procedure_ChangeTemplateQueryNonJournal(formname : string); virtual;
    procedure add_procedure_ChangePersonQuery(PersonName, Qry, PersonType:String); virtual;
    procedure add_procedure_ChangeBankQuery( UseBank:Boolean ); virtual;
    procedure add_procedure_ChangeSalesmanQuery(UseSalesman:Boolean); virtual;

   //MMD, BZ 3522
    procedure add_procedure_FilterDepositToQuery(UseDepositTo : Boolean); virtual;
    procedure add_procedure_ChangeBank_ReceiveQuery(UseBank_Receive : Boolean); virtual;

    procedure add_procedure_FilterInvoice(formTrans:String); virtual;
    procedure GetWhereClauseForList2 (FormName : string); virtual;
    procedure GetWarehouseID; virtual;
    procedure GenerateScriptWHSearchForm; virtual;

    procedure GenerateScriptForList(aliasfield, fieldnosql,fieldbeforeopen,formname,datasetname : String); virtual;
    procedure GenerateScriptForMain; virtual;
    procedure GenerateScriptSIs; virtual;
    procedure GenerateScriptCRs; virtual;
    procedure GenerateScriptJVDs; virtual;
    procedure GenerateScriptProjectbyUser(FormName : string = '');  //SCY BZ 3210
  public
    procedure GenerateScript; override;
    function describe_manual_step:String; override;
  end;

implementation
uses Classes;

procedure TExclusiveMultiBranchInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := SCRIPTING_EXCLUSIVE_MULTI_BRANCH;
end;

procedure TExclusiveMultiBranchInjector.add_procedure_HideBtnNextPrevious(formtrans:String);
begin
  if (formtrans='CS') then exit;
  Script.Add := 'procedure HideBtnNextPrevious;';
  Script.Add := 'begin';
  Script.Add := '  Form.BtnNextX.Visible    := false;';
  Script.Add := '  Form.BtnPrevious.Visible := false;';
  Script.Add := 'end;';
  Script.Add := '';;
end;

class procedure TExclusiveMultiBranchInjector.add_query_extended(const formname: String; Script: TScriptList);
begin
  Script.Add := 'result := format('' and ((select Upper(ed.%s) from EXTENDED e '+
                  ' join EXTENDEDDET ed on ed.EXTENDEDDETID=e.%s'+
//                  ' WHERE e.EXTENDEDID=%s.EXTENDEDID) = ''''%s'''')'', '+
//                  ' [BRANCH_NAME, BRANCH_FIELD, aliasfield, getUserCabangName]); ';
                  ' WHERE e.EXTENDEDID=%s.EXTENDEDID) in (''''%s'''', ''''%s''''))'', '+ // AA, BZ 2713
                  ' [BRANCH_NAME, BRANCH_FIELD, aliasfield, getUserCabangName, S_ALL]); ';
end;

procedure TExclusiveMultiBranchInjector.add_validate_before_post;
begin

end;

procedure TExclusiveMultiBranchInjector.add_validate_cabang_name(
  const formtrans: String);
begin
  Script.Add := '    HideBtnNextPrevious; ';
end;

class procedure TExclusiveMultiBranchInjector.add_var_cabang_name(const formname: String; Script: TScriptList);
begin
 //for inherited
end;

function TExclusiveMultiBranchInjector.describe_manual_step: String;
begin
  result := 'FYI : This feature must use minimum FINA version 1.7.2.312';
end;

procedure TExclusiveMultiBranchInjector.DoAssignSOSQL;
begin
  Script.Add := 'procedure DoAssignSOSQL; ';
  Script.Add := 'begin                                                                  ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Clear;                                                         ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Add(''Select Distinct m.SONO, m.SODate, m.PONO, m.Description'');';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Add(''FROM SODET s'');                                                            ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.add(''inner join SO m on s.SOID=m.SOID'');                                        ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Add(''left outer join item i on s.ItemNo = i.ItemNo'');                           ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.add(''left outer join Extended e on e.extendedID=m.ExtendedID'');                 ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Add(''WHERE (s.Closed=0)'');                                                      ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Add(''AND i.Suspended = 0 and m.CustomerID=:CustomerID'');';
  Script.Add := '  if getUserCabangName <> S_ALL then begin ';
//  Script.Add := '    TfrmChooseInvoice(Form).sqlSearch.sql.Add(format(''AND e.%s=%d'', [BRANCH_FIELD, getUserCabangID ])); ';
  Script.Add := '    TfrmChooseInvoice(Form).sqlSearch.sql.Add(format(''AND ((e.%s=%d) or (e.%s=%d))'', [BRANCH_FIELD, getUserCabangID, BRANCH_FIELD, getAllCabangID ])); '; // AA, BZ 2713
  Script.Add := '  end; ';
  //Script.Add := '  Form.sqlSearch.sql.Add(''AND (e.CustomField20=''''1'''')'');                                 ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Add(''order by m.SONo'');                                                         ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.SetParam(0, TFrmChooseInvoice(Form).PersonID);                                            ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.ExecQuery;                                                                                ';
  Script.Add := 'end;                                                                                                       ';
end;

procedure TExclusiveMultiBranchInjector.CreateSettingControl;
begin
  Script.Add := 'procedure ShowMultiBranchSetting; ';
  Script.Add := 'var frm : TForm; ';
  Script.Add := 'begin ';
  Script.Add := format('  frm := CreateFormSetting(''frm'', ''Setting %s'', 400, 400);', [SCRIPTING_EXCLUSIVE_MULTI_BRANCH]);
  Script.Add := '  try ';
  Script.Add := '    AddControl( frm, ''Use EMB for Department'', ''CHECKBOX'', ''EMB_FOR_DEPT'', ''1'', ''0'', ''''); ';
  Script.Add := '    AddControl( frm, ''Branch Field''  , ''LOOKUP''  , ''BRANCH_FIELD'', ''LOOKUP1'', ''0'', ''''); ';
  Script.Add := '    if frm.ShowModal = mrOK then begin ';
  Script.Add := '      SaveToOptions; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    frm.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForMain;
begin
  ClearScript;
  IsAdmin;
  CreateFormSetting;

  CreateSettingControl;

  Script.Add := '';
  Script.Add := 'procedure AddMenuSetting;';
  Script.Add := 'var mnuSetting : TMenuItem; ';
  Script.Add := '    mnuOptionList : TMenuItem; ';
  Script.Add := 'begin ';
  Script.Add := '  if not IsAdmin then exit; ';
  Script.Add := '  mnuSetting := TMenuItem(Form.FindComponent( ''mnuSettingMultiBranch'' )); ';
  Script.Add := '  mnuOptionList := TMenuItem(Form.FindComponent( ''mnuOptionList'' ) ); ';
  Script.Add := '  if mnuSetting <> nil then mnuSetting.Free; ';
  Script.Add := '  if mnuOptionList <> nil then mnuOptionList.Free; ';
  Script.Add := '  mnuSetting := TMenuItem.Create( Form );';
  Script.Add := '  mnuOptionList := TMenuItem.Create( Form ); ';
  Script.Add := '  mnuSetting.Name := ''mnuSettingMultiBranch'';';
  Script.Add := '  mnuOptionList.Name := ''mnuOptionList''; ';
  Script.Add := format('  mnuSetting.Caption := ''Setting %s'';', [SCRIPTING_EXCLUSIVE_MULTI_BRANCH]);
  Script.Add := '  mnuOptionList.Caption := ''Setting Option Transaction List for Multi Branch''; ';
  Script.Add := '  mnuSetting.OnClick := @ShowMultiBranchSetting;';
  Script.Add := '  mnuOptionList.OnClick := @ShowMenuOptionListMultiBranch; ';
  Script.Add := '  mnuSetting.Visible := True;';
  Script.Add := '  Form.AmnuEdit.Add( mnuSetting );';
  Script.Add := '  Form.AmnuEdit.Add( mnuOptionList );';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure ShowMenuOptionListMultiBranch; ';
  Script.Add := 'var frmList : TForm; ';
  Script.Add := 'begin ';
  Script.Add := '  frmList := CreateFormSetting( ''frmList'', ''Option Active Script List Multi Branch'', 400, 400 ); ';
  Script.Add := '  try ';
  Script.Add := '    AddControl(  frmList, ''Transaction List SO'', ''CHECKBOX'', ''SCRIPT_ON_SOs'', ''1'', ''0'', '''' ); ';
  Script.Add := '    AddControl(  frmList, ''Transaction List DO'', ''CHECKBOX'', ''SCRIPT_ON_DOs'', ''1'', ''0'', '''' ); ';
  Script.Add := '    AddControl(  frmList, ''Transaction List SI'', ''CHECKBOX'', ''SCRIPT_ON_SIs'', ''1'', ''0'', '''' ); ';
  Script.Add := '    AddControl(  frmList, ''Transaction List SR'', ''CHECKBOX'', ''SCRIPT_ON_SRs'', ''1'', ''0'', '''' ); ';
  Script.Add := '    AddControl(  frmList, ''Transaction List CR'', ''CHECKBOX'', ''SCRIPT_ON_CRs'', ''1'', ''0'', '''' ); ';
  Script.Add := '    AddControl(  frmList, ''Transaction List PO'', ''CHECKBOX'', ''SCRIPT_ON_POs'', ''1'', ''0'', '''' ); ';
  Script.Add := '    AddControl(  frmList, ''Transaction List JV'', ''CHECKBOX'', ''SCRIPT_ON_JVs'', ''1'', ''0'', '''' ); ';
  Script.Add := '    AddControl(  frmList, ''Transaction List RI'', ''CHECKBOX'', ''SCRIPT_ON_RIs'', ''1'', ''0'', '''' ); ';
  Script.Add := '    AddControl(  frmList, ''Transaction List PI'', ''CHECKBOX'', ''SCRIPT_ON_PIs'', ''1'', ''0'', '''' ); ';
  Script.Add := '    AddControl(  frmList, ''Transaction List PR'', ''CHECKBOX'', ''SCRIPT_ON_PRs'', ''1'', ''0'', '''' ); ';
  Script.Add := '    AddControl(  frmList, ''Transaction List VP'', ''CHECKBOX'', ''SCRIPT_ON_VPs'', ''1'', ''0'', '''' ); ';
  Script.Add := '    AddControl(  frmList, ''Transaction List IR'', ''CHECKBOX'', ''SCRIPT_ON_IRs'', ''1'', ''0'', '''' ); ';
  Script.Add := '    AddControl(  frmList, ''Transaction List IT'', ''CHECKBOX'', ''SCRIPT_ON_ITs'', ''1'', ''0'', '''' ); ';
  Script.Add := '    AddControl(  frmList, ''Transaction List IA'', ''CHECKBOX'', ''SCRIPT_ON_IAs'', ''1'', ''0'', '''' ); ';
  Script.Add := '    AddControl(  frmList, ''Transaction List JC'', ''CHECKBOX'', ''SCRIPT_ON_JCs'', ''1'', ''0'', '''' ); ';
  Script.Add := '    AddControl(  frmList, ''Item List'',           ''CHECKBOX'', ''SCRIPT_ON_ITEM'', ''1'', ''0'', '''' ); ';

  Script.Add := '    if frmList.ShowModal = mrOK then begin ';
  Script.Add := '      SaveToOptions; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    frmList.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := 'begin';
  Script.Add := '  AddMenuSetting; ';
  Script.Add := 'end.';

end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForCreateCollection;
begin
  ClearScript;
  Variables;
  AddFunction_CreateSQL;
  add_procedure_runsql;
  LoadCombo;
  getUserCabangName;
  Script.Add := 'function GetCustomerBranchIndex : Integer;';
  Script.Add := 'var';
  Script.Add := '  idx : Integer;';
  Script.Add := 'begin';
  Script.Add := '  for idx := 0 to Form.qrySI.CustExtended.Count - 1 do begin';
  Script.Add := '    if Form.qrySI.CustExtended.Items(idx).Caption = BRANCH_EXT_TYPE_NAME then begin';
  Script.Add := '      Result := idx;';
  Script.Add := '      exit;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure FilterCustomerBranch;';
  Script.Add := 'var';
  Script.Add := '  ComboCustExtIndex : Integer;';
  Script.Add := '  ComboCustExtObject : TObject;';

  Script.Add := '  procedure LoadCustomerBranch;';
  Script.Add := '  var';
  Script.Add := '    sql : TjbSQL;';
  Script.Add := '    qry : String;';
  Script.Add := '  begin';
  Script.Add := '    sql := Nil;';
  Script.Add := '    qry := Format(''SELECT e.extendeddetid id, ' +
                                           'e.%s code ' +
                                    'FROM   extendeddet e ' +
                                    'WHERE  e.extendedtypeid = %d ' +
                                           'AND e.%s IN (''''%s'''', ''''%s'''');'', ' +
                                    '[Form.qrySI.CustExtended.Items(GetCustomerBranchIndex).MapFieldList, ' +
                                     'Form.qrySI.CustExtended.Items(GetCustomerBranchIndex).ExtTypeId, ' +
                                     'Form.qrySI.CustExtended.Items(GetCustomerBranchIndex).MapFieldList, ' +
                                     'getUserCabangName, S_ALL]);';
  Script.Add := '    try';
  Script.Add := '      sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '      RunSQL(sql, qry);';
  Script.Add := '      while not sql.EOF do begin';
  Script.Add := '        TComboBox(Form.ComboCustExt.Items(GetCustomerBranchIndex)).Items.AddObject(sql.FieldByName(''code''), sql.FieldByName(''ID''));';
  Script.Add := '        sql.Next;';
  Script.Add := '      end;';
  Script.Add := '    finally';
  Script.Add := '      sql.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  TComboBox(Form.ComboCustExt.Items(GetCustomerBranchIndex)).Items.Clear;';
  Script.Add := '  TComboBox(Form.ComboCustExt.Items(GetCustomerBranchIndex)).Items.AddObject(''<All>'', TObject(-1));';
  Script.Add := '  LoadCustomerBranch;';
  Script.Add := '  ComboCustExtIndex := TComboBox(Form.ComboCustExt.Items(GetCustomerBranchIndex)).Items.IndexOf(getUserCabangName);';
  Script.Add := '  TComboBox(Form.ComboCustExt.Items(GetCustomerBranchIndex)).ItemIndex := ComboCustExtIndex;';
  Script.Add := '  ComboCustExtObject := TComboBox(Form.ComboCustExt.Items(GetCustomerBranchIndex)).Items.Objects(ComboCustExtIndex);';
  Script.Add := '  Form.qrySI.CustExtended.Items(GetCustomerBranchIndex).SetValue(ComboCustExtObject);';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure FilterCollector;';
  Script.Add := '';
  Script.Add := '  procedure LoadCollector;';
  Script.Add := '  var';
  Script.Add := '    sql : TjbSQL;';
  Script.Add := '    qry : String;';
  Script.Add := '  begin';
  Script.Add := '    sql := Nil;';
  Script.Add := '    qry := Format(''SELECT d.extendeddetid id, d.info1 code FROM   extendeddet d JOIN extendedtype t ON t.extendedtypeid = d.extendedtypeid JOIN extendeddet ld ON d.linkedextendeddetid = ld.extendeddetid ' +
                                    'WHERE  UPPER(t.extendedname) = ''''COLLECTOR'''' AND (ld.info1 = ''''%s'''' OR ld.info1 = ''''%s'''');'' ' +
                                    ', [getUserCabangName, S_ALL]);';
  Script.Add := '    try';
  Script.Add := '      sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '      LoadCombo(sql, TComboBox(Form.ComboCollector), qry, true);';
  Script.Add := '     finally';
  Script.Add := '      sql.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  TComboBox(Form.ComboCollector).Items.Clear;';
  Script.Add := '  LoadCollector;';
  Script.Add := '  TComboBox(Form.ComboCollector).Items.Delete(0);';
  Script.Add := '  TComboBox(Form.ComboCollector).ItemIndex := 0;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure FilterSalesman;';
  Script.Add := '';
  Script.Add := '  procedure LoadSalesman;';
  Script.Add := '  var';
  Script.Add := '    sql : TjbSQL;';
  Script.Add := '    qry : String;';
  Script.Add := '  begin';
  Script.Add := '    sql := Nil;';
  Script.Add := '    qry := Format(''Select s.SalesmanID id, s.FirstName || '''' '''' ||s.LastName code from Salesman s join extended e on s.EXTENDEDID = e.EXTENDEDID join EXTENDEDDET ed on e.%s = ed.EXTENDEDdetID where info1 in (''''%s'''', ''''%s'''') order by s.FirstName;'' ' +
                                    ', [BRANCH_FIELD, getUserCabangName, S_ALL]);';
  Script.Add := '    try';
  Script.Add := '      sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '      LoadCombo(sql, TComboBox(Form.ComboSales), qry, true);';
  Script.Add := '    finally';
  Script.Add := '      sql.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  TComboBox(Form.ComboSales).Items.Clear;';
  Script.Add := '  LoadSalesman;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure FilterSIBranch;';
  Script.Add := 'const';
  Script.Add := '  SI_JOIN_QUERY = '' JOIN extended eb ON arinv.extendedid = eb.extendedid ' +
                                    ' JOIN extendeddet ebd ON eb.%s = ebd.extendeddetid '';';
  Script.Add := '  SI_FILTER1_QUERY = '' AND ebd.%s in (''''%s'''', ''''%s'''') '';';
  Script.Add := '  SI_FILTER2_QUERY = '' AND eb.%s = %d '';';
  Script.Add := 'begin';
  Script.Add := '  if (Pos(''JOIN extendeddet ebd'', Form.qrySI.SQL.Text) = 0) then begin';
  Script.Add := '    Insert(Format(SI_JOIN_QUERY, [BRANCH_FIELD]), Form.qrySI.SQL.Text, Pos (''Where'', Form.qrySI.SQL.Text));';
  Script.Add := '  end;';
  Script.Add := '  Delete(Form.qrySI.SQL[5], '+
                         'Pos(Format(''and (e.%s = %d)'', [BRANCH_FIELD, Form.qrySI.CustExtended.Items(GetCustomerBranchIndex).Value]), Form.qrySI.SQL[5]), ' +
                         'Length(Format(''and (e.%s = %d)'', [BRANCH_FIELD, Form.qrySI.CustExtended.Items(GetCustomerBranchIndex).Value])));';
  Script.Add := '  Insert(Format(SI_FILTER1_QUERY, [BRANCH_NAME, getUserCabangName, S_ALL]), Form.qrySI.SQL[6], Pos (''Where'', Form.qrySI.SQL[6]));';
  Script.Add := '  if Form.qrySI.CustExtended.Items(GetCustomerBranchIndex).Value > -1 then begin';
  Script.Add := '    Insert(Format(SI_FILTER2_QUERY, [BRANCH_FIELD, Form.qrySI.CustExtended.Items(GetCustomerBranchIndex).Value]), Form.qrySI.SQL[6], Pos (''Where'', Form.qrySI.SQL[6]));';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  if getUserCabangName = S_ALL then exit;';
  Script.Add := '  InitializeVar;';
  Script.Add := '  Form.qrySI.OnBeforeOpenArray := @FilterSIBranch;';
  Script.Add := '  FilterCustomerBranch;';
  Script.Add := '  FilterSalesman;';
  Script.Add := '  FilterCollector;';
  Script.Add := 'end.';
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForChequeControl;
begin
  ClearScript;
  Variables;
  getUserCabangName;
  Script.Add := '';
  Script.Add := 'procedure LoadBankQueryAll;';
  Script.Add := 'const';
  Script.Add := '  BANK_FILTER_QUERY = '' AND g.glaccount NOT IN (SELECT parentaccount FROM glaccnt WHERE accounttype = 7 AND parentaccount IS NOT NULL) ' +
                                        'AND g.suspended = 0 '';';
  Script.Add := 'begin';
  Script.Add := '  if (Pos(''NOT IN (SELECT parentaccount FROM glaccnt WHERE accounttype = 7 AND parentaccount IS NOT NULL)'', Form.ACCUnit.BankQuery) = 0) then begin';
  Script.Add := '    Insert (BANK_FILTER_QUERY '+
                     ', Form.ACCUnit.BankQuery '+
                     ', Pos(''order'', Form.ACCUnit.BankQuery) );';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure LoadBankQuery;';
  Script.Add := 'const';
  Script.Add := '  BANK_FILTER_QUERY = '' AND (UPPER(G.MEMO) = ''''%s'''' OR UPPER(G.MEMO) = ''''%s'''') ' +
                                        'AND g.glaccount NOT IN (SELECT parentaccount FROM glaccnt WHERE accounttype = 7 AND parentaccount IS NOT NULL) ' +
                                        'AND g.suspended = 0 '';';
  Script.Add := 'begin';
  Script.Add := '  if (Pos(''UPPER(G.MEMO)'', Form.ACCUnit.BankQuery) = 0) then begin';
  Script.Add := '    Insert (Format(BANK_FILTER_QUERY, [getUserCabangName, S_ALL]) '+
                     ', Form.ACCUnit.BankQuery '+
                     ', Pos(''order'', Form.ACCUnit.BankQuery) );';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure FilterCRList;';
  Script.Add := 'const';
  Script.Add := '  CRLIST_JOIN_QUERY = '' JOIN persondata cust on cust.id = arpmt.billtoid ' +
                                        ' JOIN extended e ON cust.extendedid = e.extendedid ' +
                                        ' JOIN extendeddet ed ON e.%s = ed.extendeddetid '';';
  Script.Add := '  CRLIST_FILTER_QUERY = '' AND (UPPER(ed.%s) = ''''%s'''' OR UPPER(ed.%s) = ''''%s'''') '';';
  Script.Add := 'begin';
  Script.Add := '  if (Pos(''JOIN persondata cust on cust.id = arpmt.billtoid'', Form.ACCUnit.DtCRList.SelectSQL[0]) = 0) then begin';
  Script.Add := '    Form.ACCUnit.DtCRList.SelectSQL[0] := '  +
                   ' Form.ACCUnit.DtCRList.SelectSQL[0] + Format(CRLIST_JOIN_QUERY, [BRANCH_FIELD]);';
  Script.Add := '  end;';
  Script.Add := '  if (Pos(''AND (UPPER(ed.'', Form.ACCUnit.DtCRList.SelectSQL[1]) = 0) then begin';
  Script.Add := '    Form.ACCUnit.DtCRList.SelectSQL[1] := Form.ACCUnit.DtCRList.SelectSQL[1] + '+
                                                          'Format(CRLIST_FILTER_QUERY, [BRANCH_NAME, getUserCabangName, BRANCH_NAME, S_ALL]);';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  InitializeVar;';
  Script.Add := '  if getUserCabangName = S_ALL then begin';
  Script.Add := '    Form.ACCUnit.OnBeforeLoadBank := @LoadBankQueryAll;';
  Script.Add := '  end';
  Script.Add := '  else begin';
  Script.Add := '    Form.ACCUnit.OnBeforeLoadBank := @LoadBankQuery;';
  Script.Add := '    TJBDataset(Form.ACCUnit.DtCRList).OnBeforeOpenArray := @FilterCRList;';
  Script.Add := '  end';
  Script.Add := 'end.';
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForChooseForm;
begin
  Script.Clear;
  CreateQuery;
  Variables;
  add_function_getCabang;

  Script.Add := 'procedure ITAssignIRSQL; ';
  Script.Add := 'begin ';
  Script.Add := '  TfrmChooseFormFilter(Form).sqlSearch.Close;  ';
  Script.Add := '  TfrmChooseFormFilter(Form).sqlSearch.sql.Clear;  ';
  Script.Add := '  TfrmChooseFormFilter(Form).sqlSearch.sql.Add(''Select Distinct m.TRANSFERNO, m. TRANSFERDATE, '');';
  Script.Add := '  TfrmChooseFormFilter(Form).sqlSearch.sql.Add(''(select name from warehs w where w.warehouseid = m.FROMWHID)WarehouseFrom, ''); ';
  Script.Add := '  TfrmChooseFormFilter(Form).sqlSearch.sql.Add(''(select name from warehs w where w.warehouseid = m.TOWHID)WarehouseTo, '');';
  Script.Add := '  TfrmChooseFormFilter(Form).sqlSearch.sql.Add('' m.DESCRIPTION, m.DESCRIPTION '');  ';
  Script.Add := '  TfrmChooseFormFilter(Form).sqlSearch.sql.Add(''FROM IREQDET s inner join IREQ m on s.TRANSFERID = m.TRANSFERID'');  ';
  Script.Add := '  TfrmChooseFormFilter(Form).sqlSearch.sql.Add(''left outer join item i on s.ItemNo = i.ItemNo''); ';
  Script.Add := '  TfrmChooseFormFilter(Form).sqlSearch.sql.add(''left outer join Extended e on e.extendedID=m.ExtendedID''); ';
  Script.Add := '  TfrmChooseFormFilter(Form).sqlSearch.sql.Add(''WHERE (s.Closed=0) ''); ';
  Script.Add := '  TfrmChooseFormFilter(Form).sqlSearch.sql.Add(''AND i.Suspended = 0 '');';
  Script.Add := '  TfrmChooseFormFilter(Form).sqlSearch.sql.Add(format('' AND m.FromWHID=%d '', [TfrmChooseFormFilter(Form).FWHID])); ';
  Script.Add := '  TfrmChooseFormFilter(Form).sqlSearch.sql.Add(format('' AND m.ToWHID=%d '', [TfrmChooseFormFilter(Form).TWHID]));';
  Script.Add := '  if getUserCabangName <> S_ALL then begin ';
//  Script.Add := '    TfrmChooseFormFilter(Form).sqlSearch.sql.Add(format('' AND e.%s=%d'', [BRANCH_FIELD, getUserCabangID ])); ';
  Script.Add := '    TfrmChooseFormFilter(Form).sqlSearch.sql.Add(format('' AND ((e.%s=%d) or (e.%s=%d))'', [BRANCH_FIELD, getUserCabangID, BRANCH_FIELD, getAllCabangID])); '; // AA, BZ 2713
  Script.Add := '  end; ';
  Script.Add := '  TfrmChooseFormFilter(Form).sqlSearch.ExecQuery;  ';
  Script.Add := 'end; ';
  Script.Add := '';

  Script.Add := 'procedure RIAssignPOSQL; ';
  Script.Add := 'begin                                                                  ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Clear;                                                         ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Add(''Select P.PONo, P.PODate, P.POID, P.InclusiveTax, P.Description '');';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Add(''from PO P''); ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.add(''left outer join Extended e on e.extendedID=P.ExtendedID''); ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Add(''WHERE (P.Closed = 0 or P.Closed is NULL)'');                                                      ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Add(''and (P.Proceed = 0 or P.Proceed is null) and P.VendorID=:VendorID '');';
  Script.Add := '  if getUserCabangName <> S_ALL then begin ';
//  Script.Add := '    TfrmChooseInvoice(Form).sqlSearch.sql.Add(format(''AND e.%s=%d'', [BRANCH_FIELD, getUserCabangID ])); ';
  Script.Add := '    TfrmChooseInvoice(Form).sqlSearch.sql.Add(format(''AND ((e.%s=%d) or (e.%s=%d))'', [BRANCH_FIELD, getUserCabangID, BRANCH_FIELD, getAllCabangId ])); '; // AA, BZ 2713
  Script.Add := '  end; ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Add('' order by P.PONo, P.PODate ''); ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.SetParam(0, TFrmChooseInvoice(Form).PersonID);  ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.ExecQuery;  ';
  Script.Add := 'end; ';
  Script.Add := '';

  Script.Add := 'procedure DoAssignDOSQL;  ';
  Script.Add := ' const sqlReturnQty = ''Select sum(C.Quantity*C.UnitRatio) from ARRefDet C, ARRefund D '+
                '      where C.ARRefundID=D.ARRefundID and D.ARInvoiceID=B.ARInvoiceID '+
                '      and C.ItemNo=A.ItemNo and C.InvoiceSeq=A.Seq''; ';
  Script.Add := 'begin';
  Script.Add := '  TfrmChooseInvoice(Form).SqlSearch.sql.Clear; ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Add(''Select Distinct B.InvoiceNo, B.InvoiceDate, B.PurchaseOrderNo, B.Description,''); ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Add(''A.ARInvoiceID from ARInvDet A, ARInv B''); ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.add(''left outer join Extended e on e.extendedID=B.ExtendedID''); ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Add(''Where B.CustomerID=:CustomerID and B.DeliveryOrder=1 and A.UsedInSIID is null and''); ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Add(''B.ARInvoiceID = A.ARInvoiceID and''); ';
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Add(''((''+sqlReturnQty+'') is null or (A.Quantity * A.UnitRatio) > (''+sqlReturnQty+'') )''); ';
  Script.Add := '  if getUserCabangName <> S_ALL then begin ';
//  Script.Add := '    TfrmChooseInvoice(Form).sqlSearch.sql.Add(format(''AND e.%s=%d'', [BRANCH_FIELD, getUserCabangID ])); ';
  Script.Add := '    TfrmChooseInvoice(Form).sqlSearch.sql.Add(format(''AND ((e.%s=%d) or (e.%s=%d))'', [BRANCH_FIELD, getUserCabangID, BRANCH_FIELD, getAllCabangID ])); '; // AA, BZ 2713
  Script.Add := '  end; ';
//    sqlSearch.sql.Add(sStrOrder);
  Script.Add := '  TfrmChooseInvoice(Form).sqlSearch.sql.Add(''Order By 1 ''); ';
  Script.Add := '  TfrmChooseInvoice(Form).SqlSearch.SetParam(0,TFrmChooseInvoice(Form).PersonID); ';
  Script.Add := '  TfrmChooseInvoice(Form).SqlSearch.ExecQuery; ';
  Script.Add := 'end;';
  Script.Add := '';
  DoAssignSOSQL;
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := '  InitializeVar; ';
  Script.Add := '  TfrmChooseInvoice(Form).OnAssignIRSQL := @ITAssignIRSQL; ';
  Script.Add := '  TfrmChooseInvoice(Form).OnAssignPOSQL := @RIAssignPOSQL; ';
  Script.Add := '  TfrmChooseInvoice(Form).OnAssignSOSQL := @DoAssignSOSQL; ';
  Script.Add := '  TfrmChooseInvoice(Form).OnAssignDOSQL := @DoAssignDOSQL; ';
  Script.Add := 'end. ';
end;

procedure TExclusiveMultiBranchInjector.Variables(formname: String='');
begin
  ReadOption;
  Script.Add := 'Const BRANCH_NAME          = ''Info1''; ';
  Script.Add := '      BRANCH_EXT_TYPE_NAME =''CABANG''; ';
  Script.Add := '      S_ALL                =''ALL'';';
  Script.Add := '      CUSTOMER_MAPTABLENAME  = ''CUSTOMER''; '; //MMD, BZ 3521
  Script.Add := 'var ';
  Script.Add := '  BRANCH_FIELD : String; ';
  Script.Add := '  SCRIPT_ON    : Boolean; ';
  Script.Add := '';
  Script.Add := 'procedure InitializeVar; ';
  Script.Add := 'begin';
  Script.Add := '  BRANCH_FIELD := ReadOption(''BRANCH_FIELD'', ''LOOKUP1''); ';
  Script.Add := Format('  SCRIPT_ON    := StrToInt( ReadOption(''SCRIPT_ON_%s'', ''1'') ) = 1; ',[ formname ]);
  Script.Add := 'end;';
  Script.Add := '';
end;

class procedure TExclusiveMultiBranchInjector.add_get_where_clause(const formname: String; Script: TScriptList);
begin
  Script.Add := '  function GetWhereClause(aliasfield : string ):String; ';
  add_var_cabang_name(formname, Script);
  Script.Add := '  begin';
  if (formname='FA') then begin
//    Script.Add := '    result := format('' and Upper(%s.NOTES)=''''%s'''' '', '+
//                      ' [aliasfield, getUserCabangName]); ';
    Script.Add := '    result := format('' and Upper(%s.NOTES) in (''''%s'''', ''''%s'''') '', '+ // AA, BZ 2713
                      ' [aliasfield, getUserCabangName, S_ALL]); ';
  end
  else if (formname='TEMPLATE') then begin
//    Script.Add := '    result := format('' and Upper(%s.Name) like ''''%s%s%s'''' '', '+
//                      ' [aliasfield,''%'', getUserCabangName,''%'']); ';
    Script.Add := '    result := format('' and ((Upper(%s.Name) like ''''%s%s%s'''') or (Upper(%s.Name) like ''''%s%s%s'''')) '', '+ // AA, BZ 2713
                      ' [aliasfield,''%'', getUserCabangName,''%'', aliasfield,''%'', S_ALL,''%'']); ';
  end
  else if (formname='DEPT') then begin
    Script.Add := '    result := format('' and Upper(DEPTNO)=''''%s'''' '', '+
                      ' [getUserCabangName]); ';
  end
  else if (formname='PROJECT') then begin  //SCY BZ 3210
    Script.Add := '    result := format('' and Upper(PROJECTNO)=''''%s'''' '', '+
                      ' [getUserCabangName]); ';
  end
  else begin
    add_query_extended(formname, Script);
  end;
  Script.Add := '  end;';
end;


procedure TExclusiveMultiBranchInjector.add_before_open_on_script_list(const formname, fieldnosql, aliasfield:String);
begin
  Script.Add := 'procedure BeforeOpen;                                 ';
  add_get_where_clause(formname, Self.Script);
  Script.Add := 'begin                                                         ';
  add_main_before_open_on_script_list(formname, fieldnosql, aliasfield);
  Script.Add := 'end;                                                          ';
  Script.Add := '';
end;

procedure TExclusiveMultiBranchInjector.add_function_getCabang(FormGeneral:String = 'ALL');
begin
  getUserCabangName;
  Script.Add := 'function getUserCabangID: variant;';
  Script.Add := 'var sql : TjbSQL;';
  Script.Add := 'begin';
  Script.Add := '  result := null;';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '  try';
  Script.Add := '    RunSQL(sql, format(''select ed.EXTENDEDDETID from EXTENDEDDET ed '+
                     'where ed.EXTENDEDTYPEID=(select ET.EXTENDEDTYPEID from EXTENDEDTYPE et '+
                                               ' where et.EXTENDEDNAME=''''%s'''') '+
                     ' and Upper(ed.%s)=''''%s'''' '', [BRANCH_EXT_TYPE_NAME, BRANCH_NAME, getUserCabangName]));';
  Script.Add := '    if sql.RecordCount=0 then exit; ';
  Script.Add := '    result := sql.FieldByName(''EXTENDEDDETID'');';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'function getAllCabangID: variant;'; // AA, BZ 2713
  Script.Add := 'var sql : TjbSQL;';
  Script.Add := 'begin';
  Script.Add := '  result := null;';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '  try';
  Script.Add := '    RunSQL(sql, format(''select ed.EXTENDEDDETID from EXTENDEDDET ed '+
                     'where ed.EXTENDEDTYPEID=(select ET.EXTENDEDTYPEID from EXTENDEDTYPE et '+
                                               ' where et.EXTENDEDNAME=''''%s'''') '+
                     ' and Upper(ed.%s)=''''%s'''' '', [BRANCH_EXT_TYPE_NAME, BRANCH_NAME, S_ALL]));';
  Script.Add := '    if sql.RecordCount=0 then exit; ';
  Script.Add := '    result := sql.FieldByName(''EXTENDEDDETID'');';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TExclusiveMultiBranchInjector.add_main_before_open_on_script_list(
  const formname, fieldnosql, aliasfield: String);
  procedure AddWhereWord;
  begin
    Script.Add := format('    if (Pos (''Where'', %s) = 0) then begin', [fieldnosql]);
    Script.Add := format('      %s := %s + '' Where 1=1 ''; ',[fieldnosql,fieldnosql]);
    Script.Add := '    end;';
  end;

begin
  Script.Add := '  if getUserCabangName = S_ALL then exit;';
  if ((formname='TEMPLATE') or (formname='PROJECT') or (formname='ITEM')) then begin
    AddWhereWord;
  end;

  Script.Add := format('  %s := %s + GetWhereClause(''%s''); ',[fieldnosql,fieldnosql,aliasfield]);
  if (formname='DEPT') then begin
    Script.Add := '  Datamodule.Master.SelectSQL.Text := ReplaceStr(Datamodule.Master.SelectSQL.Text,'':DEPTID'',''null''); ';
  end;
  if (formname='PROJECT') then begin  //SCY BZ 3210
    Script.Add := '  Datamodule.TblProject.SelectSQL.Text := ReplaceStr(Datamodule.TblProject.SelectSQL.Text,'':PROJECTID'',''null''); ';
  end;
end;

procedure TExclusiveMultiBranchInjector.add_main_general(const formtrans: String);
begin

end;

procedure TExclusiveMultiBranchInjector.add_procedure_ChangeWarehouseQuery( UseWarehouse:Boolean; AFormName:String );
begin
  if not UseWarehouse then exit;
  if not TwoWarehouse(AFormName) then begin
    Script.Add := 'function CheckWareHouseID : variant;';
    Script.Add := '  var sql : TjbSQL; ';
    Script.Add := 'begin ';
    Script.Add := '  result := null; ';
    Script.Add := '  sql := CreateSQL(TIBTransaction(Tx)); ';
    Script.Add := '  try ';
    Script.Add := '    RunSQL(sql, format(''select first 1 w.WAREHOUSEID, w.NAME from WAREHS w ''+#13+';
//    Script.Add := '         ''where Upper(w.description)=''''%s'''' and  w.WAREHOUSEID=%d order by w.Name Asc'', [getUserCabangName,Master.WAREHOUSEID.value])); ';
    Script.Add := '         ''where Upper(w.description) in (''''%s'''', ''''%s'''') and  w.WAREHOUSEID=%d order by w.Name Asc'', [getUserCabangName, S_ALL, Master.WAREHOUSEID.value])); '; // AA, BZ 2713
    Script.Add := '    if sql.RecordCount=0 then exit; ';
    Script.Add := '    result := sql.FieldByName(''WAREHOUSEID''); ';
    Script.Add := '  finally ';
    Script.Add := '    sql.Free; ';
    Script.Add := '  end; ';
    Script.Add := 'end; ';
    Script.Add := '';
    Script.Add := 'function GetDefaultWareHouseID : variant;';
    Script.Add := '  var sql : TjbSQL; ';
    Script.Add := 'begin ';
    Script.Add := '  result := null; ';
    Script.Add := '  sql := CreateSQL(TIBTransaction(Tx)); ';
    Script.Add := '  try ';
    Script.Add := '    RunSQL(sql, format(''select WAREHOUSEID, NAME from WAREHS w ''+#13+';
//    Script.Add := '         ''where Upper(w.description)=''''%s'''' order by Name'', [getUserCabangName])); ';
    Script.Add := '         ''where Upper(w.description) in (''''%s'''', ''''%s'''') order by Name'', [getUserCabangName, S_ALL])); '; // AA, BZ 2713
    Script.Add := '    if sql.RecordCount=0 then exit; ';
    Script.Add := '    result := sql.FieldByName(''WAREHOUSEID''); ';
    Script.Add := '  finally ';
    Script.Add := '    sql.Free; ';
    Script.Add := '  end; ';
    Script.Add := 'end; ';
    Script.Add := '';
    Script.Add := 'procedure SetWarehouseID; ';
    Script.Add := 'begin ';
    Script.Add := '  if (GetDefaultWareHouseID)= null then exit; ';
    Script.Add := '  Master.WAREHOUSEID.value := GetDefaultWareHouseID; ';
    Script.Add := 'end; ';
    Script.Add := '';
  end;
  ChangeWarehouseQuery;
end;

procedure TExclusiveMultiBranchInjector.ChangeWarehouseQuery;
begin
  Script.Add := 'procedure ChangeWarehouseQuery;';
  Script.Add := 'begin';
  Script.Add := '  if getUserCabangName=S_ALL then exit; ';
  Script.Add := '  DataModule.qryWareHS.Active := False;';
  Script.Add := '  DataModule.qryWareHS.SQL.Text := format(''select WAREHOUSEID, NAME from WAREHS w''+#13+';
//  Script.Add := '                                   ''where Upper(w.description)=''''%s'''' order by Name'', [getUserCabangName]);';
  Script.Add := '                                   ''where Upper(w.description) in (''''%s'''', ''''%s'''') order by Name'', [getUserCabangName, S_ALL]);'; // AA, BZ 2713
  Script.Add := '  DataModule.qryWareHS.Active := True;';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TExclusiveMultiBranchInjector.add_procedure_ChangeTemplateQuery(formname : string);
begin
  Script.Add := 'function getTemplateType : variant; ';
  Script.Add := '  var sql : TjbSQL; ';
  Script.Add := 'begin ';
  Script.Add := '  result := null;  ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sql, format(''select first 1 T.TEMPLATEID, T.TEMPLATETYPE From TEMPLATE T''+#13+ ';
  if ((formname='IADS') or (formname='JVDS')) then begin
    Script.Add := '                     ''where  T.TEMPLATEID=%d '', [Dataset.TEMPLATEID.value])); ';
  end
  else begin
    Script.Add := '                     ''where  T.TEMPLATEID=%d '', [Master.TEMPLATEID.value])); ';
  end;
  Script.Add := '    if sql.RecordCount=0 then exit; ';
  Script.Add := '    result := sql.FieldByName(''TEMPLATETYPE''); ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function GetDefaultTemplateID : variant; ';
  Script.Add := '  var sql : TjbSQL; ';
  Script.Add := 'begin ';
  Script.Add := '  result := null; ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sql, format(''Select first 1 T.TEMPLATEID, T.TEMPLATETYPE, T.NAME From TEMPLATE T''+#13+ ';
//  Script.Add := '                '' where T.TEMPLATETYPE=%d and Upper(T.NAME) like  ''''%s%s%s'''' ''+#13+ ';
//  Script.Add := '                '' Order by T.Name'', [getTemplateType,''%'',getUserCabangName,''%''])); ';
  Script.Add := '                '' where T.TEMPLATETYPE=%d and ( (Upper(T.NAME) like  ''''%s%s%s'''') or (Upper(T.NAME) like  ''''%s%s%s'''') ) ''+#13+ '; // AA, BZ 2713
  Script.Add := '                '' Order by T.Name'', [getTemplateType, ''%'', getUserCabangName, ''%'', ''%'', S_ALL, ''%''])); ';
  Script.Add := '    if sql.RecordCount=0 then exit; ';
  Script.Add := '    result := sql.FieldByName(''TEMPLATEID''); ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';

  if ((formname ='IADS') or (formname ='JVDS')) then begin
    Script.Add := '';
  end
  else begin
  Script.Add := 'function CheckTemplateID : variant; ';
  Script.Add := '  var sql : TjbSQL; ';
  Script.Add := 'begin ';
  Script.Add := '  result := null; ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sql, format(''Select first 1 T.TEMPLATEID, T.TEMPLATETYPE, T.NAME From TEMPLATE T''+#13+ ';
//  Script.Add := '                '' where T.TEMPLATETYPE=%d and Upper(T.NAME) like  ''''%s%s%s'''' ''+#13+ ';
//  Script.Add := '                '' and T.TEMPLATEID=%d Order by T.Name'', [getTemplateType,''%'',getUserCabangName,''%'',Master.TEMPLATEID.value])); ';
  Script.Add := '                '' where T.TEMPLATETYPE=%d and ((Upper(T.NAME) like  ''''%s%s%s'''') or (Upper(T.NAME) like  ''''%s%s%s'''') ) ''+#13+ '; // AA, BZ 2713
  Script.Add := '                '' and T.TEMPLATEID=%d Order by T.Name'', [getTemplateType,''%'',getUserCabangName,''%'',''%'',S_ALL,''%'',Master.TEMPLATEID.value])); ';
  Script.Add := '    if sql.RecordCount=0 then exit; ';
  Script.Add := '    result := sql.FieldByName(''TEMPLATEID''); ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure SetTemplateID; ';
  Script.Add := 'begin ';
  Script.Add := '  if (GetDefaultTemplateID)= null then exit; ';
  Script.Add := '  Master.TEMPLATEID.value := GetDefaultTemplateID; ';
  Script.Add := 'end; ';
  Script.Add := '';
  end;
end;

procedure TExclusiveMultiBranchInjector.add_procedure_ChangeTemplateQueryJournal;
begin
  Script.Add := 'procedure ChangeTemplateQuery; ';
  Script.Add := '  var template_qry : TjbQuery; ';
  Script.Add := 'begin ';
  Script.Add := '  if getUserCabangName=S_ALL then exit; ';
  Script.Add := '  template_qry := TjbQuery(TDataSource(form.dstemplate).dataset); ';
  Script.Add := '  template_qry.active := False; ';
  Script.Add := '  template_qry.SQL.Text := format(''Select T.TEMPLATEID, T.TEMPLATETYPE, T.NAME From TEMPLATE T''+#13+ ';
//  Script.Add := '                                '' where T.TEMPLATETYPE=:TEMPLATETYPE and Upper(T.NAME) like  ''''%s%s%s'''' ''+#13+ ';
//  Script.Add := '                                '' Order by T.Name'', [''%'',getUserCabangName,''%'']); ';
  Script.Add := '                                '' where T.TEMPLATETYPE=:TEMPLATETYPE and ((Upper(T.NAME) like  ''''%s%s%s'''') or (Upper(T.NAME) like  ''''%s%s%s'''')) ''+#13+ '; // AA, BZ 2713
  Script.Add := '                                '' Order by T.Name'', [''%'',getUserCabangName,''%'', ''%'', S_ALL, ''%'']); ';
  Script.Add := '  template_qry.Active := True; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TExclusiveMultiBranchInjector.add_procedure_ChangeTemplateQueryNonJournal(formname : string);
begin
  Script.Add := 'procedure ChangeTemplateQuery; ';
  Script.Add := '  var template_qry : TjbQuery; ';
  Script.Add := 'begin ';
  Script.Add := '  if getUserCabangName=S_ALL then exit; ';
  Script.Add := '  template_qry := TjbQuery(TDataSource(form.dstemplate).dataset); ';
  Script.Add := '  template_qry.active := False; ';
  Script.Add := '  template_qry.SQL.Text := format(''Select T.TEMPLATEID, T.TEMPLATETYPE, T.NAME From TEMPLATE T''+#13+ ';
//  Script.Add := '                                '' where T.TEMPLATETYPE=%d and Upper(T.NAME) like  ''''%s%s%s'''' ''+#13+ ';
  Script.Add := '                                '' where T.TEMPLATETYPE=%d and ((Upper(T.NAME) like  ''''%s%s%s'''') or (Upper(T.NAME) like  ''''%s%s%s'''')) ''+#13+ '; // AA, BZ 2713
  if(formname='RI') then begin
//    Script.Add := '                                '' Order by T.Name'', [5,''%'',getUserCabangName,''%'']); ';
    Script.Add := '                                '' Order by T.Name'', [5,''%'',getUserCabangName,''%'', ''%'', S_ALL, ''%'']); '; // AA, BZ 2713
  end
  else if(formname='PI') then begin
//    Script.Add := '                                '' Order by T.Name'', [4,''%'',getUserCabangName,''%'']); ';
    Script.Add := '                                '' Order by T.Name'', [4,''%'',getUserCabangName,''%'', ''%'', S_ALL, ''%'']); '; // AA, BZ 2713
  end
  else begin
//    Script.Add := '                                '' Order by T.Name'', [getTemplateType,''%'',getUserCabangName,''%'']); ';
    Script.Add := '                                '' Order by T.Name'', [getTemplateType,''%'',getUserCabangName,''%'', ''%'', S_ALL, ''%'']); '; // AA, BZ 2713
  end;

  Script.Add := '  template_qry.Active := True; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TExclusiveMultiBranchInjector.add_procedure_ChangePersonQuery(PersonName, Qry, PersonType:String);
begin
  Script.Add := 'procedure Change' + PersonName + 'Query;';
  Script.Add := 'begin';
  Script.Add := '  if getUserCabangName=S_ALL then exit; ';
  Script.Add := '  DataModule.'+ Qry + '.Active := False;';
  Script.Add := '  DataModule.'+ Qry + '.SQL.Text := format(''Select ID, Name, PersonNo, AddressLine1 From PERSONDATA p''+#13+';
  Script.Add := '                                  ''Where p.PersonType=' + PersonType + ' ''+#13+';  //must have line break. Otherwise it will replaced by FINA Dataset.SQL[1]. BZ 2486
  Script.Add := '                                  ''and p.EXTENDEDID in ''+';
  Script.Add := '                                  ''(select e.EXTENDEDID from EXTENDED e join EXTENDEDDET ed on ed.EXTENDEDDETID=e.%s''+#13+';
//  Script.Add := '                                  '' where Upper(ed.%s)=''''%s'''')''+#13+';
//  Script.Add := '                                  ''Order by Name, PersonNo'', [BRANCH_FIELD, BRANCH_NAME, getUserCabangName]);';
  Script.Add := '                                  '' where Upper(ed.%s) in (''''%s'''', ''''%s''''))''+#13+'; // AA, BZ 2713
  Script.Add := '                                  ''Order by Name, PersonNo'', [BRANCH_FIELD, BRANCH_NAME, getUserCabangName, S_ALL]);';
  Script.Add := '  DataModule.'+ Qry + '.Active := True;';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TExclusiveMultiBranchInjector.add_procedure_ChangeCustomerQuery;
begin
  add_procedure_ChangePersonQuery( 'Customer', 'qryCustomer', '0');
end;

procedure TExclusiveMultiBranchInjector.add_procedure_FilterDepositToQuery(UseDepositTo : Boolean);

  procedure depositToSql(filtered:Boolean);
  begin
    Script.Add := 'begin';
    Script.Add := '  if getUserCabangName = S_ALL then exit;';
    Script.Add := '  DataModule.qryDepositTo.Active := False;';
    Script.Add := '  DataModule.qryDepositTo.SQL.Clear;';
    Script.Add := '  DataModule.qryDepositTo.SQL.Add(''SELECT qb.glaccount, qb.accountname, gl.memo FROM querybank( :personid ) qb '');';
    Script.Add := '  DataModule.qryDepositTo.SQL.Add(''JOIN glaccnt gl ON gl.glaccount = qb.glaccount '');';
    Script.Add := '  DataModule.qryDepositTo.SQL.Add(''WHERE (qb.suspended = 0 OR qb.glaccount = :glaccount ) '');';
    if (filtered) then begin
      Script.Add := '  DataModule.qryDepositTo.SQL.Add(Format(''AND (gl.memo = ''''%s'''' OR gl.memo = ''''%s'''')'', [getUserCabangName, S_ALL]));';
    end;
    Script.Add := '  DataModule.qryDepositTo.Active := True;';
    // AA, BZ 4070
    Script.Add := '  if ((Master.DepositTo.AsString<>'''') AND (NOT DataModule.qryDepositTo.locate(''GLACCOUNT'', [Master.DepositTo.AsString], 0))) then begin';
    Script.Add := '    Master.DepositTo.AsString := '''';';
    Script.Add := '  end;';
    Script.Add := 'end;';
    Script.Add := '';
  end;

begin
  if not UseDepositTo then exit;
  Script.Add := 'procedure filterDepositToQuery;';
  depositToSql(True);
  Script.Add := 'procedure unFilterDepositToQuery;'; // AA, BZ 4070
  depositToSql(False);
end;

procedure TExclusiveMultiBranchInjector.add_procedure_ChangeVendorQuery;
begin
  add_procedure_ChangePersonQuery( 'Vendor', 'qryAVendor', '1');
end;


procedure TExclusiveMultiBranchInjector.add_change_customer_query(
  const formtrans: String);
begin
  Script.Add := '  ChangeCustomerQuery; ';
end;

procedure TExclusiveMultiBranchInjector.add_condition_name_change(formtrans:String);
begin

end;

procedure TExclusiveMultiBranchInjector.add_procedure_ChangeBankQuery( UseBank: Boolean );
begin
  if not UseBank  then exit;
  Script.Add := 'procedure ChangeBankQuery;';
  Script.Add := 'begin';
  Script.Add := '  if getUserCabangName=S_ALL then exit; ';
  Script.Add := '  DataModule.QryBank.Active := False;';
  Script.Add := '  DataModule.QryBank.SQL.Text := format(''SELECT G.ACCOUNTNAME,G.GLACCOUNT from GLACCNT G ''+#13+';
  Script.Add := '                                ''WHERE not exists(select glaccount from glaccnt where ''+#13+';
  Script.Add := '                                ''parentaccount=g.glaccount) and  G.ACCOUNTTYPE=7 and ''+#13+';
//  Script.Add := '                                ''Suspended =0 and Trim(Upper(g.MEMO))=''''%s'''' union select g.AccountName,g.GLAccount from ''+#13+';
  Script.Add := '                                ''Suspended =0 and Trim(Upper(g.MEMO)) in (''''%s'''', ''''%s'''') union select g.AccountName,g.GLAccount from ''+#13+'; // AA, BZ 2750
  Script.Add := '                                ''GLAccnt g inner join JVDet j on g.GLAccount = j. GLAccount and ''+#13+';
//  Script.Add := '                                ''g.accounttype=7 and j.JVID = :Id and Trim(Upper(g.MEMO))=''''%s''''  order by 1'', [getUserCabangName,getUserCabangName]);';
  Script.Add := '                                ''g.accounttype=7 and j.JVID = :Id and Trim(Upper(g.MEMO)) in (''''%s'''', ''''%s'''')  order by 1'', [getUserCabangName, S_ALL, getUserCabangName, S_ALL]);'; // AA, BZ 2713
  Script.Add := '  DataModule.QryBank.Active := True;';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TExclusiveMultiBranchInjector.add_procedure_ChangeBank_ReceiveQuery(
  UseBank_Receive: Boolean);
begin
  if not UseBank_Receive then exit;
  Script.Add := 'procedure ChangeBank_ReceiveQuery;';
  Script.Add := 'begin';
  Script.Add := '  if getUserCabangName = S_ALL then exit;; ';
  Script.Add := '  DataModule.qryBank.Active := False;';
  Script.Add := '  DataModule.qryBank.SQL.Clear;';
  Script.Add := '  DataModule.qryBank.SQL.Add(''SELECT qb.glaccount, qb.currencyid, qb.accountname, qb.currencyname, qb.exchangerate, qb.suspended, gl.memo FROM querybank( :billtoid ) qb '');';
  Script.Add := '  DataModule.qryBank.SQL.Add(''JOIN glaccnt gl ON qb.glaccount = gl.glaccount '');';
  Script.Add := '  DataModule.qryBank.SQL.Add(Format(''WHERE 1 = 1 AND (gl.memo = ''''%s'''' OR gl.memo = ''''%s'''')'', [getUserCabangName, S_ALL]));';
  Script.Add := '  DataModule.qryBank.SQL.Add(''UNION SELECT g.glaccount, g.currencyid, g.accountname, c.currencyname, c.exchangerate, g.suspended, g.memo FROM glaccnt g '');';
  Script.Add := '  DataModule.qryBank.SQL.Add(''INNER JOIN arpmt a ON g.glaccount = a.bankaccount AND g.accounttype = 7 AND a.paymentid = :Id '');';
  Script.Add := '  DataModule.qryBank.SQL.Add(''INNER JOIN currency c ON g.currencyid = c.currencyid ORDER BY 3'');';
  Script.Add := '  DataModule.qryBank.Active := True;';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TExclusiveMultiBranchInjector.add_procedure_ChangeSalesmanQuery(UseSalesman:Boolean);
begin
  if not UseSalesman then exit;
  Script.Add := 'procedure ChangeSalesmanQuery; ';
  Script.Add := '    var salesman_qry : TjbQuery; ';
  Script.Add := 'begin';
  Script.Add := '  if getUserCabangName=S_ALL then exit; ';
  Script.Add := '  salesman_qry := TjbQuery(TDataSource(form.dsSalesman).dataset); ';
  Script.Add := '  salesman_qry.Active := False;';
//  Script.Add := '  salesman_qry.SQL.Text := format(''select s.SalesmanID,(Coalesce(s.Firstname,'''''''')||'''' ''''||Coalesce(s.Lastname,'''''''')) Salesmanname ''+#13+';
//  Script.Add := '                                ''from Salesman s Where s.EXTENDEDID in ''+#13+';
//  Script.Add := '                                  ''(select e.EXTENDEDID from EXTENDED e join EXTENDEDDET ed on ed.EXTENDEDDETID=e.%s''+#13+';
////  Script.Add := '                                  ''where Upper(ed.%s)=''''%s'''') ''+#13+';
////  Script.Add := '                                  ''Order by s.Firstname'', [BRANCH_FIELD,BRANCH_NAME,getUserCabangName]);';
//  Script.Add := '                                  ''where Upper(ed.%s) in (''''%s'''', ''''%s'''')) ''+#13+'; // AA, BZ 2713
//  Script.Add := '                                  ''Order by s.Firstname'', [BRANCH_FIELD,BRANCH_NAME,getUserCabangName, S_ALL]);';
  Script.Add := '  salesman_qry.SQL.Text := format(''select s.SalesmanID,(Coalesce(s.Firstname,'''''''')||'''' ''''||Coalesce(s.Lastname,'''''''')) Salesmanname ''+';
  Script.Add := '                                ''from Salesman s Where s.EXTENDEDID in ''+ ';
  Script.Add := '                                ''(select e.EXTENDEDID from EXTENDED e join EXTENDEDDET ed on ed.EXTENDEDDETID=e.%s ''+ ';
  Script.Add := '                                ''where Upper(ed.%s) in (''''%s'''', ''''%s'''')) ''+#13+ '; // AA, BZ 2713
  Script.Add := '                                ''Order by s.Firstname'', [BRANCH_FIELD,BRANCH_NAME,getUserCabangName, S_ALL]);';
  Script.Add := '  salesman_qry.Active := True;';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TExclusiveMultiBranchInjector.SetDeptByUser(IsDiscInfo : Boolean; formname : string);
begin

  if (IsDiscInfo) then begin
    Script.Add := '';
  end
  else begin
    ClearScript;
    add_procedure_runsql;
    AddFunction_CreateSQL;
    IsAdmin;
    Variables;
    add_function_getCabang;
  end;

  Script.Add := 'var isSettingDept,isvalidatedept:Boolean;';
  get_department_id;
  Script.Add := 'procedure SetDept; ';
  Script.Add := 'var DeptID : Variant; ';
  Script.Add := 'begin ';
  Script.Add := '  DeptID := GetDeptID; ';
  Script.Add := '  if DeptID = null then exit; ';
  Script.Add := '  IsSettingDept := true; ';
  if (IsDiscInfo) then begin
    if (formname='VP') then begin
      Script.Add := '  DataModule.AtblAPInvChq.DeptID.value := DeptID; ';
    end
    else begin
      Script.Add := '  DataModule.tblPmtDisc.DeptID.value := DeptID; ';
    end;
  end
  else begin
    Script.Add := '  Dataset.DeptID.value := DeptID; ';
  end;
  Script.Add := '  IsSettingDept := false; ';
  Script.Add := 'end; ';
  Script.Add := '';
  if (formname='VP') then begin
    Script.Add := 'procedure BeforePostDept; ';
    Script.Add := 'begin ';
    Script.Add := '  if DataModule.AtblAPInvChq.DeptID.value  <> GetDeptID  then begin ';
    Script.Add := '    isvalidatedept := True; ';
    Script.Add := '  end ';
    Script.Add := '  else begin ';
    Script.Add := '    isvalidatedept := False; ';
    Script.Add := '  end; ';
    Script.Add := 'end; ';
  end
  else begin
    Script.Add := 'procedure DeptValidate;';
    Script.Add := 'var DeptID : Variant; ';
    Script.Add := 'begin';
    Script.Add := '  if IsSettingDept then exit; ';
    Script.Add := '  DeptID := GetDeptID; ';
    if (IsDiscInfo) then begin
      Script.Add := '  if getUserCabangName=S_ALL then exit; ';
      Script.Add := '  if DataModule.tblPmtDisc.DeptID.value <> DeptID then RaiseException(''Department Should Not Be Changed''); ';
    end
    else begin
      Script.Add := '  if Dataset.DeptID.value <> DeptID then RaiseException(''Department Should Not Be Changed''); ';
    end;
    Script.Add := 'end; ';
    Script.Add := '';
  end;


  if (IsDiscInfo) then begin
    Script.Add := '';
  end
  else begin
    Script.Add := 'procedure ValidateDeptMustExist; ';
    Script.Add := 'begin';
    Script.Add := '  if getUserCabangName=S_ALL then exit; ';
    Script.Add := '  if Dataset.DeptID.isNull then RaiseException(''Department Is Empty''); ';
    Script.Add := 'end;';
    Script.Add := '';
    Script.Add := 'begin';
    Script.Add := '  if ReadOption (''EMB_FOR_DEPT'', ''1'') = ''1'' then begin';
    Script.Add := '    IsSettingDept := false; ';
    Script.Add := '    dataset.OnBeforePostValidationArray := @ValidateDeptMustExist; ';
    //Script.Add := '    if IsAdmin then exit; ';
    Script.Add := '    if getUserCabangName=S_ALL then exit; ';
    Script.Add := '    dataset.OnNewRecordArray := @SetDept; ';
    Script.Add := '    dataset.DeptID.OnValidateArray := @DeptValidate; ';
    Script.Add := '  end;';
    Script.Add := 'end.';
  end;

end;

procedure TExclusiveMultiBranchInjector.SetProjectByUser(IsDiscInfo : Boolean; formname : string);
begin
  if (IsDiscInfo) then begin
    Script.Add := '';
  end
  else begin
    ClearScript;
    add_procedure_runsql;
    AddFunction_CreateSQL;
    IsAdmin;
    Variables;
    add_function_getCabang;
  end;

  Script.Add := 'var isSettingProject,isValidateProject:Boolean;';
  get_project_id;
  Script.Add := 'procedure SetProject; ';
  Script.Add := 'var ProjectID : Variant; ';
  Script.Add := 'begin ';
  Script.Add := '  ProjectID := GetProjectID; ';
  Script.Add := '  if ProjectID = null then exit; ';
  Script.Add := '  isSettingProject := true; ';
  if (IsDiscInfo) then begin
    if (formname='VP') then begin
      Script.Add := '  DataModule.AtblAPInvChq.ProjectID.value := ProjectID; ';
    end
    else begin
      Script.Add := '  DataModule.tblPmtDisc.ProjectID.value := ProjectID; ';
    end;
  end
  else if (formname <> 'FA') then begin
    Script.Add := '  Dataset.ProjectID.value := ProjectID; ';
  end;

  Script.Add := '  isSettingProject := false; ';
  Script.Add := 'end; ';
  Script.Add := '';
  if (formname='VP') then begin
    Script.Add := 'procedure BeforePostProject; ';
    Script.Add := 'begin ';
    Script.Add := '  isValidateProject := DataModule.AtblAPInvChq.ProjectID.value <> GetProjectID;';
    Script.Add := 'end; ';
  end
  else begin
    Script.Add := 'procedure ProjectValidate;';
    Script.Add := 'var ProjectID : Variant; ';
    Script.Add := 'begin';
    Script.Add := '  if isSettingProject then exit; ';
    Script.Add := '  ProjectID := GetProjectID; ';
    if (IsDiscInfo) then begin
      Script.Add := '  if getUserCabangName=S_ALL then exit; ';
      Script.Add := '  if DataModule.tblPmtDisc.ProjectID.value <> ProjectID then RaiseException(''Project Should Not Be Changed''); ';
    end
    else if (formname <> 'FA') then begin
      Script.Add := '  if Dataset.ProjectID.value <> ProjectID then RaiseException(''Project Should Not Be Changed''); ';
    end;
    Script.Add := 'end; ';
    Script.Add := '';
  end;

  if (IsDiscInfo) then begin
    Script.Add := '';
  end
  else begin
    Script.Add := 'procedure ValidateProjectMustExist; ';
    Script.Add := 'begin';
    Script.Add := '  if getUserCabangName=S_ALL then exit; ';
    if (formname <> 'FA') then begin
      Script.Add := '  if Dataset.ProjectID.isNull then RaiseException(''Project Is Empty''); ';
    end;

    Script.Add := 'end;';
    Script.Add := '';
    Script.Add := 'begin';
    Script.Add := '  if ReadOption (''EMB_FOR_PROJ'', ''1'') = ''1'' then begin';
    Script.Add := '    isSettingProject := false; ';
    Script.Add := '    dataset.OnBeforePostValidationArray := @ValidateProjectMustExist; ';
    //Script.Add := '    if IsAdmin then exit; ';
    Script.Add := '    if getUserCabangName=S_ALL then exit; ';
    Script.Add := '    dataset.OnNewRecordArray := @SetProject; ';
    if (formname <> 'FA') then begin
      Script.Add := '    dataset.ProjectID.OnValidateArray := @ProjectValidate; ';
    end;
    Script.Add := '  end;';
    Script.Add := 'end.';
  end;
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptDeptbyUser;
begin
  SetDeptByUser(False,'');
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptProjectbyUser(FormName : string = '');
begin
  SetProjectByUser(False, FormName);
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForSalesman;
begin
  ClearScript;
  Variables;
  add_function_getCabang;

  Script.Add := 'function GetField:TField;';
  Script.Add := 'begin';
  Script.Add := '  result := Dataset.ExtendedID.FieldLookup.FieldByName(BRANCH_FIELD); ';
  Script.Add := 'end;';
  Script.Add := 'procedure NameChange; ';
  Script.Add := 'begin';
  Script.Add := '  if (GetField.isnull) then begin ';
  Script.Add := '    GetField.value := getUserCabangID; ';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := 'procedure CabangValidate(sender:TField); ';
  Script.Add := 'Begin ';
  Script.Add := '  if getUserCabangName=S_ALL then exit; ';
  Script.Add := '  if TExtendedLookupField(sender).value=getAllCabangId then exit;'; // AA, BZ 2713
  Script.Add := '  if TExtendedLookupField(sender).value <> getUserCabangID then raiseException(''Branches Must Not Be Altered''); ';
  Script.Add := 'end;  ';
  Script.Add := '';
  Script.add := 'begin';
  Script.Add := '  InitializeVar; ';
  Script.Add := '  Dataset.FIRSTNAME.OnChangeArray := @NameChange;';
  Script.Add := '  TExtendedLookupField(GetField).OnValidateArray := @CabangValidate; ';
  Script.Add := 'end.';
end;

procedure TExclusiveMultiBranchInjector.add_procedure_FilterInvoice(formTrans:String);
begin
  if (formtrans <> 'PR') then exit;
  Script.Add := 'procedure FilterInvoiceQuery; ';
  Script.Add := '  function GetWhereClause(aliasfield : string ):String; ';
  Script.Add := '  begin';
  add_query_extended(formTrans, Script);
  Script.Add := '  end;';
  Script.Add := 'begin ';
  Script.Add := '  if getUserCabangName=S_ALL then exit; ';
  Script.Add := '  DataModule.QryAPInv.Active := False; ';
  Script.Add := '  DataModule.QryAPInv.SQL[2] := DataModule.QryAPInv.SQL[2] +  GetWhereClause(''M''); ';
  Script.Add := '  DataModule.QryAPInv.Active := True; ';
  Script.Add := 'end; ';
end;


procedure TExclusiveMultiBranchInjector.GenerateScriptForList(aliasfield, fieldnosql,
          fieldbeforeopen,formname,datasetname : String);
Begin
  ClearScript;
  Variables( formName );
  add_function_getCabang(formname);
  add_before_open_on_script_list(formname, fieldnosql, aliasfield);
  if (formname='DEPT') then begin
//    Script.Add := 'procedure AfterClose; ';
    Script.Add := 'procedure revertSQLParam; ';
    Script.Add := 'begin' ;
    Script.Add := '  Datamodule.Master.SelectSQL.Text := ReplaceStr(Datamodule.Master.SelectSQL.Text,''null'','':DEPTID''); ';
    Script.Add := 'end;';
    Script.Add := '';
  end;
  if (formname='PROJECT') then begin  //SCY BZ 3210
    Script.Add := 'procedure revertSQLParam; ';
    Script.Add := 'begin' ;
    Script.Add := '  Datamodule.tblProject.SelectSQL.Text := ReplaceStr(Datamodule.tblProject.SelectSQL.Text,''null'','':PROJECTID''); ';
    Script.Add := 'end;';
    Script.Add := '';
  end;
  Script.Add := 'begin';
  main_script_for_list(formname, fieldbeforeopen, datasetname);
  Script.Add := 'end.';
End;

procedure TExclusiveMultiBranchInjector.GetWhereClauseForList2 (FormName : string);
begin
  Script.Add := '  function GetWhereQueryExtended (aliasfield : string) : string;';
  Script.Add := '  begin';
  add_query_extended(FormName, Script);
  Script.Add := '  end;';

  Script.Add := '  function GetWhereClause(aliasfield : string ):String; ';
  Script.Add := '  begin';
  if (FormName='SALESMAN') then begin
    Script.Add := '    result := ''where 1=1 '' + GetWhereQueryExtended (aliasfield);';
  end
  else if (FormName='WH') then begin
//    Script.Add := '    result := format('' where Upper(DESCRIPTION) = ''''%s'''' '', '+
//                      ' [getUserCabangName]); ';
    Script.Add := '    result := format('' where Upper(DESCRIPTION) in (''''%s'''', ''''%s'''') '', '+ // AA, BZ 2713
                      ' [getUserCabangName, S_ALL]); ';
  end
  else begin
    add_query_extended(FormName, Script);
  end;
  Script.Add := '  end;';
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForList2(aliasfield, fieldnosql,
          fieldbeforeopen, formname,fielddateFrom,fielddateTo,fieldnamedate,NameDateReplace : String;
          IsFilterDate, IscekDate : Boolean);
Begin
  ClearScript;
  Variables(formname);
  add_function_getCabang;

  Script.Add := 'procedure BeforeOpen; ';
  Script.Add := '  var tempsql,tempsql2 : string; ';
  Script.Add := '      count_sql   : integer; ';
  if (IsFilterDate) then begin
    Script.Add := '      TempDateFrom,TempDateTo : TDateTime; ';
    Script.Add := '      tgldari, tglke : string; ';
    Script.Add := '      filter_Date : Boolean; ';
    Script.Add := '  function FilterParamDate(datefrom,dateto,fielddate :String) : String; ';
    Script.Add := '  Begin ';
    Script.Add := '    result := format('' and (%s between ''''%s'''' and ''''%s'''' )'',[fielddate,datefrom,dateto]); ';
    Script.Add := '  End;';
  end;

  GetWhereClauseForList2(FormName);

  Script.Add := 'begin ';
  if (IsFilterDate) then begin
    Script.Add := format('  TempDateFrom := StrTodate(Form.%s.Text); ',[fielddateFrom]);
    Script.Add := format('  TempDateTo   := StrTodate(Form.%s.Text); ',[fielddateTo]);
    Script.Add := '  tgldari := FormatDateTime(''mm/dd/yyyy'', TempDateFrom); ';
    Script.Add := '  tglke := FormatDateTime(''mm/dd/yyyy'', TempDateTo); ';
    Script.Add := '';
    if (IscekDate) then begin
      Script.Add := '  filter_Date  := Form.AchkDate.Checked; ';
      Script.Add := '';
      Script.Add := '  if (filter_Date) then begin';
      Script.Add := format('    %s := ReplaceStr(%s,''%s'','''') + ',[fieldnosql,fieldnosql,NameDateReplace]);
      Script.Add := format('    FilterParamDate(tgldari,tglke,''%s''); ' ,[fieldnamedate]);
      Script.Add := '  end';
      Script.Add := '  else begin ';
      Script.Add := format('    %s := ReplaceStr(%s,''%s'',''''); ',[fieldnosql,fieldnosql,NameDateReplace]);
      Script.Add := '  end;';
      Script.Add := '';
    end;
  end;

  if(formname='SRS') then begin
//    Script.Add := '  if getUserCabangName=S_ALL then exit; ';
    Script.Add := format('  %s := ReplaceStr(%s,''and R.INVOICEDATE between :From and  :To'','''') + ',[fieldnosql,fieldnosql]);
    Script.Add := format('                                          GetWhereClause(''%s'')+ FilterParamDate(tgldari,tglke,''%s''); ',[aliasfield,fieldnamedate]);
  end
  else begin
    Script.Add := '  if (count_sql<1) then begin ';
    Script.Add := format('    tempsql := GetWhereClause(''%s''); ',[aliasfield]);
    Script.Add := format('    tempsql2 := GetWhereClause(''%s''); ',[aliasfield]);
    Script.Add := '  end; ';
    Script.Add := '';
    Script.Add := '  if getUserCabangName=S_ALL then begin ';
    if (formname='VPS') then begin
      Script.Add := format('    %s := ReplaceStr(%s, tempsql + FilterParamDate(tgldari,tglke,''%s''),'''');',[fieldnosql,fieldnosql,fieldnamedate]);
    end
    else begin
      Script.Add := format('    %s := ReplaceStr(%s, tempsql,''''); ',[fieldnosql,fieldnosql]);
    end;
    Script.Add := '  end ';
    Script.Add := '  else begin ';
    Script.Add := format('    if(trim(tempsql)<> trim(GetWhereClause(''%s''))) then begin ',[aliasfield]);
    Script.Add := format('      tempsql := GetWhereClause(''%s''); ',[aliasfield]);
    Script.Add := '    end; ';
    if (formname='VPS') then begin
      Script.Add := format('    %s := ReplaceStr(%s, tempsql2 + FilterParamDate(tgldari,tglke,''%s''),'''') + GetWhereClause(''%s''); ',[fieldnosql,fieldnosql,fieldnamedate,aliasfield]);
    end
    else begin
      Script.Add := format('    %s := ReplaceStr(%s, tempsql2,'''') + GetWhereClause(''%s''); ',[fieldnosql,fieldnosql,aliasfield]);
    end;
    Script.Add := format('    tempsql2 := GetWhereClause(''%s''); ',[aliasfield]);
    Script.Add := '    count_sql := count_sql + 1; ';
    Script.Add := '  end; ';
  end;

  Script.Add := 'end; ';
  Script.Add := ' ';
  Script.Add := 'begin';
  Script.Add := '  InitializeVar; ';
  Script.Add := '  if not SCRIPT_ON then Exit; ';
  Script.Add := format('  %s  := @BeforeOpen; ',[fieldbeforeopen]);
  if (formname='WH') then begin
    Script.Add := '  Datamodule.Master.Close; ';
    Script.Add := '  Datamodule.Master.Open; ';
  end;
  Script.Add := 'end.';
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptForLoading;
begin
  ClearScript;
  Variables;
  getUserCabangName;
  Script.Add := 'procedure FilterDSWareList;';
  Script.Add := 'const';
  Script.Add := '  WARELIST_FILTER_QUERY = '' WHERE UPPER(description) in (''''%s'''', ''''%s'''') '';';
  Script.Add := 'begin';
  Script.Add := '  Datamodule.AdsWareList.Close;';
  Script.Add := '  if (Pos(''WHERE UPPER(description)'', Datamodule.AdsWareList.SQL.Text) = 0) then begin';
  Script.Add := '    Insert(Format(WARELIST_FILTER_QUERY, [getUserCabangName, S_ALL]) '+
                     ', Datamodule.AdsWareList.SQL.Text '+
                     ', Pos(''order'', Datamodule.AdsWareList.SQL.Text));';
  Script.Add := '  end;';
  Script.Add := '  Datamodule.AdsWareList.Open;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure FilterQuery(Query : TjbExtendedQuery);';
  Script.Add := 'const';
  Script.Add := '  JOIN_QUERY = '' JOIN extendeddet led ON ed.linkedextendeddetid = led.extendeddetid '';';
  Script.Add := '  FILTER_QUERY = '' AND led.info1 IN (''''%s'''', ''''%s'''') '';';
  Script.Add := 'begin';
  Script.Add := '  Query.Close;';
  Script.Add := '  if (Pos(JOIN_QUERY, Query.SQL.Text) = 0) then begin';
  Script.Add := '    Insert(JOIN_QUERY '+
                     ', Query.SQL.Text '+
                     ', Pos(''Where'', Query.SQL.Text));';
  Script.Add := '  end;';
  Script.Add := '  if (Pos(''AND led.info1 IN'', Query.SQL.Text) = 0) then begin';
  Script.Add := '    Insert(Format(FILTER_QUERY, [getUserCabangName, S_ALL]) '+
                     ', Query.SQL.Text '+
                     ', Pos(''order'', Query.SQL.Text));';
  Script.Add := '  end;';
  Script.Add := '  Query.Open;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure FilterSalesmanQuery;';
  Script.Add := 'const';
  Script.Add := '  SALESMAN_JOIN_QUERY = '' JOIN extended e ON salesman.extendedid = e.extendedid ' +
                                          ' JOIN extendeddet ed ON e.%s = ed.extendeddetid '';';
  Script.Add := '  SALESMAN_FILTER_QUERY = '' WHERE ed.%s IN (''''%s'''', ''''%s'''') '';';
  Script.Add := 'begin';
  Script.Add := '  DataModule.ARitaseDS.SalesmanQuery.Close;';
  Script.Add := '  if (Pos(''JOIN extendeddet ed ON e.'', DataModule.ARitaseDS.SalesmanQuery.SQL.Text) = 0) then begin';
  Script.Add := '    Insert(Format(SALESMAN_JOIN_QUERY, [BRANCH_FIELD]) '+
                     ', DataModule.ARitaseDS.SalesmanQuery.SQL.Text '+
                     ', Pos(''Order'', DataModule.ARitaseDS.SalesmanQuery.SQL.Text));';
  Script.Add := '  end;';
  Script.Add := '  if (Pos(''AND (UPPER(ed.'', DataModule.ARitaseDS.SalesmanQuery.SQL.Text) = 0) then begin';
  Script.Add := '    Insert(Format(SALESMAN_FILTER_QUERY, [BRANCH_NAME, getUserCabangName, S_ALL]) '+
                     ', DataModule.ARitaseDS.SalesmanQuery.SQL.Text '+
                     ', Pos(''Order'', DataModule.ARitaseDS.SalesmanQuery.SQL.Text));';
  Script.Add := '  end;';
  Script.Add := '  DataModule.ARitaseDS.SalesmanQuery.Open;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure FilterSelectSOQuery;';
  Script.Add := 'const';
  Script.Add := '  SO_JOIN_QUERY = '' LEFT OUTER JOIN extendeddet ed ' +
                                    ' ON e.%s = ed.extendeddetid '';';
  Script.Add := '  SO_FILTER_QUERY = '' AND ed.%s IN (''''%s'''', ''''%s'''') '';';
  Script.Add := 'begin';
  Script.Add := '  if (Pos(''LEFT OUTER JOIN extendeddet ed'', DataModule.SelectSOQuery) = 0) then begin';
  Script.Add := '    Insert(Format(SO_JOIN_QUERY, [BRANCH_FIELD]) '+
                     ', DataModule.SelectSOQuery '+
                     ', Pos(''WHERE'', DataModule.SelectSOQuery));';
  Script.Add := '  end;';
  Script.Add := '  if (Pos(Format(''AND ed.%s IN'', [BRANCH_NAME]), DataModule.SelectSOQuery) = 0) then begin';
  Script.Add := '    DataModule.SelectSOQuery := DataModule.SelectSOQuery + Format(SO_FILTER_QUERY, [BRANCH_NAME, getUserCabangName, S_ALL]);';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  InitializeVar;';
  Script.Add := '  if getUserCabangName = S_ALL then exit;';
  Script.Add := '  FilterDSWareList;';
  Script.Add := '  FilterQuery(Datamodule.ARitaseDS.TransportQuery);';
  Script.Add := '  FilterQuery(Datamodule.ARitaseDS.DropperQuery);';
  Script.Add := '  FilterQuery(Datamodule.ARitaseDS.DropperAssistantQuery);';
  Script.Add := '  FilterQuery(Datamodule.ARitaseDS.DeliveredAreaQuery);';
  Script.Add := '  FilterSalesmanQuery;';
  Script.Add := '  FilterSelectSOQuery;';
  Script.Add := '  Form.editFromDate.Date := Nil;';
  Script.Add := '  Form.editFromDate.Date := Date;';
  Script.Add := 'end.';
end;

procedure TExclusiveMultiBranchInjector.AddProcedureValidateItem( IsUseItem:Boolean );
begin
  if not IsUseItem then exit;
  Script.Add := 'procedure ValidateItem(item:TjbItemLookupField);';
  CreateSQLTryFinally('SearchItemExtended',
                      'RunSQL(sql, format(''select first 1 ed.%s cabang from Item i '+
                        'join Extended e on e.extendedID=i.ExtendedID '+
                        'join ExtendedDet ed on ed.ExtendedDetID=e.%s '+
                        'where i.ItemNo=''''%s'''''', [BRANCH_NAME, BRANCH_FIELD, item.value])); '+
                      'result := sql.FieldByName(''cabang''); ');
  Script.Add := 'var itemBranchName : string;';
  Script.Add := 'begin';
  Script.Add := '  if item.isNull or (item.value = '''') then exit;';
  Script.Add := '  if getUserCabangName = S_ALL then Exit; ';
//  Script.Add := '  if SearchItemExtended( TIBTransaction(Tx) ) <> getUserCabangName then RaiseException(''Can not select this Item'');';
  Script.Add := '  itemBranchName := SearchItemExtended( TIBTransaction(Tx) );';
  Script.Add := '  if ((itemBranchName<>S_ALL) And (itemBranchName<>getUserCabangName)) then begin';
  Script.Add := '    RaiseException(''Can not select this Item'');'; // AA, BZ 2713
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TExclusiveMultiBranchInjector.ValidateItem( IsUseItem:Boolean );
begin
  if not IsUseItem then exit;
  Script.Add := '  if SCRIPT_ON then Detail.ItemNo.OnValidateArray := @ValidateItem;';
end;

function TExclusiveMultiBranchInjector.TwoWarehouse(AFormName:String):Boolean;
begin
  result := (AFormName = 'IR') or (AFormName = 'IT');
end;

procedure TExclusiveMultiBranchInjector.AddProcedureBeforePostAndNewRecord( AFormName:String;
  AUseBeforePost, AUseWarehouse, AUseTemplate, AUseDiscInfo:Boolean);
begin
  if not AUseBeforePost then exit;

  Script.Add := 'procedure MasterBeforePost; ';
  Script.Add := 'begin ';
  Script.Add := '  if Master.IsFirstPost then exit;';
  add_validate_before_post;
  Script.Add := '  if (GetField.isnull) then begin ';
  Script.Add := '    if MessageDlg( ''Branch has not been entered, Do you want Continue ?'', mtWarning, mbYes + mbNo, 0)=mrNo then begin ';
  Script.Add := '      raiseException(''Process has been canceled'')';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '  if getUserCabangName=S_ALL then exit; ';
  //Script.Add := '  if (GetField.isnull) then raiseException(''Branch Is Empty''); ';

  if AUseWareHouse and not TwoWarehouse(AFormName) then begin
    Script.Add := '  if Master.WAREHOUSEID.Value <> CheckWareHouseID then raiseException(''Warehouse Is Empty''); ';
  end;
  if AUseTemplate then begin
    Script.Add := '  if Master.TEMPLATEID.Value <> CheckTemplateID then raiseException(''Template Is Empty''); ';
  end;
  if((AUseDiscInfo) and (AFormName='VP')) then begin
    Script.Add := '  if ReadOption (''EMB_FOR_DEPT'', ''1'') = ''1'' then begin';  //SCY BZ 3210
    Script.Add := '    if isvalidatedept then begin ';
    Script.Add := '      RaiseException(''Department at Discount Info Form Should Not Be Changed'');';
    Script.Add := '    end; ';
    Script.Add := '  end';
    Script.Add := '  else if ReadOption (''EMB_FOR_PROJ'', ''1'') = ''1'' then begin';
    Script.Add := '    if isValidateProject then begin ';
    Script.Add := '      RaiseException(''Project at Discount Info Form Should Not Be Changed'');';
    Script.Add := '    end; ';
    Script.Add := '  end;';
  end;

  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure MasterNewRecord; ';
  Script.Add := 'begin ';
  Script.Add := '  if not Master.IsMasterNew then exit; ';
  if (AUseTemplate) then begin
    Script.Add := '  SetTemplateID; ';
  end;
  if (AUseWarehouse and not TwoWarehouse(AFormName)) then begin
    Script.Add := '  SetWarehouseID; ';
  end;
  if ((AFormName='IA') or (AFormName='JC')) then begin
    Script.Add := '  NameChange; ';
  end;
  Script.Add := 'end; ';
end;

procedure TExclusiveMultiBranchInjector.SetAccount;
begin
  // for inherited
end;

procedure TExclusiveMultiBranchInjector.SetAccountQuery (formtrans : string);
begin
  // for inherited
end;

procedure TExclusiveMultiBranchInjector.SetCostCentre;
begin
  // for inherited
end;

procedure TExclusiveMultiBranchInjector.SetCostCentreQuery (tableName : string);
begin
  // for inherited
end;

procedure TExclusiveMultiBranchInjector.AddProcedureTemplate(AFormName:String; AUseTemplate:Boolean);
begin
  if not AUseTemplate then exit;
  add_procedure_ChangeTemplateQuery('');
  if (AFormName='JOURNAL') then begin
    add_procedure_ChangeTemplateQueryJournal
  end
  else begin
    add_procedure_ChangeTemplateQueryNonJournal(AFormName);
  end;
end;

procedure TExclusiveMultiBranchInjector.GetWarehouseID;
begin
  Script.Add := 'function GetWHID:Integer; ';
  Script.Add := 'var sql_wh : TjbSQL;   ';
  Script.Add := 'begin ';
  Script.Add := '  sql_wh := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  result := -1; ';
  Script.Add := '  try ';
//  Script.Add := '    RunSQL( sql_wh, Format(''Select WarehouseID from WareHS where Upper(Description) = ''''%s'''' '', [getUserCabangName]) ); ';
  Script.Add := '    RunSQL( sql_wh, Format(''Select WarehouseID from WareHS '+
                     'where Upper(Description) in (''''%s'''', ''''%s'''') '' '+
                     ', [getUserCabangName, S_ALL]) ); '; // AA, BZ 2713
  Script.Add := '    if sql_wh.Eof then RaiseException(''Warehouse ID not found according full name account user''); ';
  Script.Add := '    result := sql_wh.FieldByName(''WarehouseID''); ';
  Script.Add := '  finally ';
  Script.Add := '    sql_wh.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptTrans(FieldChangearray,formtrans : String;
          PersonType : Integer;
          IsWareHouse, IsBank, IsTemplate, IsSalesman, IsBeforePost, IsDiskonInfo, IsUseItem, IsDepositTo, IsBank_Receive : boolean);
begin
  ClearScript;
  Variables;
  add_function_getCabang(formtrans);
  add_procedure_HideBtnNextPrevious( formTrans );
  case PersonType of
    personTypeCust : add_procedure_ChangeCustomerQuery;
    personTypeVend : add_procedure_ChangeVendorQuery;
  end;
  add_procedure_ChangeWarehouseQuery(IsWareHouse, formtrans);
  AddProcedureTemplate( formtrans, IsTemplate );
  add_procedure_ChangeSalesmanQuery(IsSalesman);
  add_procedure_ChangeBankQuery( IsBank );

  //MMD, BZ 3522
  add_procedure_FilterDepositToQuery(IsDepositTo);
  add_procedure_ChangeBank_ReceiveQuery(IsBank_Receive);

  if(IsDiskonInfo) then begin
    SetDeptByUser(True,formtrans);
    SetProjectByUser(True,formtrans);  //SCY BZ 3210
  end;
  add_procedure_FilterInvoice( formTrans );
  AddProcedureValidateItem( IsUseItem );
  AddProcedureBeforePostAndNewRecord(formtrans, IsBeforePost, IsWareHouse, IsTemplate, IsDiskonInfo);
  if (formtrans = 'JC') then begin
    SetCostCentreQuery ('DataModule.AtblMFSht');
  end
  else if (formtrans = 'CR') then begin
    SetCostCentreQuery ('DataModule.tblARPmt');
    SetAccountQuery (formtrans);
  end
  else if (formtrans = 'VP') then begin
    SetCostCentreQuery ('DataModule.AtblAPCheq');
    SetAccountQuery (formtrans);
  end;

  Script.Add := 'function GetField:TField;';
  Script.Add := 'begin';
  Script.Add := '  result := Master.ExtendedID.FieldLookup.FieldByName(BRANCH_FIELD); ';
  Script.Add := 'end;';
  Script.Add := 'procedure NameChange; ';
  Script.Add := 'begin';
  Script.Add := '  if (GetField.isnull) then begin ';
  Script.Add := '    GetField.value := getUserCabangID; ';
  add_condition_name_change(formtrans);
  Script.Add := '  end;';
  if(formtrans='PR') then begin
    Script.Add := '  FilterInvoiceQuery; ';
  end;
  if (IsDepositTo) then begin
    Script.Add := '  filterDepositToQuery;'; // AA, BZ 4070
  end;
  Script.Add := 'end;';
  Script.Add := '';
  if formtrans <> 'CS' then begin
    Script.Add := 'procedure SetWarehouseReadOnly; ';
    Script.Add := 'var idx : Integer; ';
    Script.Add := 'begin ';
    Script.Add := '  for idx := 0 to ItemGrid.Columns.Count -1 do begin ';
    Script.Add := '    if ItemGrid.Columns[idx].FieldName = ''Name'' then begin ';
    Script.Add := '      ItemGrid.Columns[idx].ReadOnly := True; ';
    Script.Add := '    end; ';
    Script.Add := '  end; ';
    Script.Add := 'end; ';
    Script.Add := '';
  end;
  Script.Add := 'procedure CabangValidate(sender:TField); ';
  Script.Add := 'Begin ';
  if formtrans <> 'CS' then begin
    Script.Add := '  SetWarehouseReadOnly; ';
  end;
  Script.Add := '  if getUserCabangName=S_ALL then exit; ';
  Script.Add := '  if TExtendedLookupField(sender).value <> getUserCabangID then raiseException(''Branches Must Not Be Altered''); ';
  Script.Add := 'end;  ';
  Script.Add := '';
  if IsTemplate then begin
    if (formtrans <> 'SO') and (formtrans <> 'PO') and (formtrans <> 'CR') and (formtrans <> 'VP') and
      (formtrans <> 'JOURNAL') and (formtrans <> 'IT') and (formtrans <> 'IR') then begin
      addIsWarehousePerItem;
      GetWarehouseID;

      Script.Add := '';
      Script.Add := 'procedure ItemNoOnChange; ';
      Script.Add := 'begin ';
      Script.Add := '  if getUserCabangName=S_ALL then exit; ';
      Script.Add := '  if IsWarehousePerItem then begin ';
      Script.Add := '    Detail.WarehouseID.Value := GetWHID; ';
      Script.Add := '  end; ';
      Script.Add := 'end; ';
      Script.Add := '';
      if (formtrans = 'DO') or (formtrans = 'SI') then begin
        Script.Add := 'var only_once_change : Boolean = False;';
        Script.Add := 'procedure WarehouseIDOnChange; ';
        Script.Add := 'begin ';
        Script.Add := '  if IsWarehousePerItem then begin ';
        Script.Add := '    if only_once_change then begin '; //used for DO get SO transaction
        Script.Add := '      only_once_change := False; '; // AA, BZ 4040
        Script.Add := '      Detail.WarehouseID.Value := GetWHID; ';
//        Script.Add := '      only_once_change := False; ';
        Script.Add := '    end; ';
        Script.Add := '  end; ';
        Script.Add := 'end; ';
        Script.Add := '';
        Script.Add := 'procedure DetailSOIDOnChange; ';
        Script.Add := 'begin ';
        Script.Add := '  only_once_change := True; ';
        Script.Add := 'end; ';
        Script.Add := '';
      end;
    end;
  end;
  Script.Add := 'begin';
  Script.Add := '  InitializeVar; ';
  if (formtrans = 'CR') OR (formtrans = 'VP') then begin
    SetCostCentre;
    SetAccount;
  end;

  if (formtrans = 'JC') then begin
    SetCostCentre;
  end;

  if(formtrans<>'CS') then begin
    Script.Add := '  if getUserCabangName<>S_ALL then begin ';
    add_validate_cabang_name(formtrans);
    Script.Add := '  end; ';
  end;

  case PersonType of
    personTypeCust : add_change_customer_query(formtrans);
    personTypeVend : Script.Add := '  ChangeVendorQuery;';
  end;

  if(IsBeforePost) then begin
    Script.Add := '  Master.OnBeforePostArray := @MasterBeforePost; ';
    Script.Add := '  Master.OnNewRecordArray  := @MasterNewRecord; ';
    if (formtrans='VP') then begin
      Script.Add := '    MasterNewRecord;  ';
    end
    else if (formtrans <> 'PR') then begin
      Script.Add := '  if Master.IsFirstPost then begin';
      Script.Add := '    MasterNewRecord;';
      Script.Add := '  end;';
    end;
  end;
  if (IsWareHouse) then begin
    Script.Add := '  ChangeWarehouseQuery; ';
  end;
  if (IsTemplate) then begin
    Script.Add := '  ChangeTemplateQuery; ';
    if (formtrans <> 'SO') and (formtrans <> 'PO') and (formtrans <> 'CR') and (formtrans <> 'VP') and
      (formtrans <> 'JOURNAL') and (formtrans <> 'IT') and (formtrans <> 'IR') then begin
      Script.Add := '  Detail.ItemNo.OnChangeArray := @ItemNoOnChange; ';
    end;
  end;
  if (IsSalesman) then begin
    Script.Add := '  ChangeSalesmanQuery; ';
  end;
  if (IsBank) then begin
    Script.Add := '  ChangeBankQuery; ';
  end;

  //MMD, BZ 3522
  if (IsDepositTo) then begin
    Script.Add := '  FilterDepositToQuery;';
    Script.Add := '  Master.CUSTOMERID.OnValidateArray := @unFilterDepositToQuery;'; // AA, BZ 4070
  end;
  if (IsBank_Receive) then begin
    Script.Add := '  ChangeBank_ReceiveQuery;';
  end;

  if (IsDiskonInfo) then begin
    if(formtrans='VP') then begin
      Script.Add := '  if ReadOption (''EMB_FOR_DEPT'', ''1'') = ''1'' then begin';  //SCY BZ 3210
      Script.Add := '    DataModule.AtblAPInvChq2.OnNewRecordArray := @SetDept; ';
      Script.Add := '    DataModule.AtblAPInvChq2.OnBeforePostArray := @BeforePostDept; ';
      Script.Add := '  end';
      Script.Add := '  else if ReadOption (''EMB_FOR_PROJ'', ''1'') = ''1'' then begin';
      Script.Add := '    DataModule.AtblAPInvChq2.OnNewRecordArray := @SetProject; ';
      Script.Add := '    DataModule.AtblAPInvChq2.OnBeforePostArray := @BeforePostProject; ';
      Script.Add := '  end;';
    end
    else begin
      Script.Add := '  if ReadOption (''EMB_FOR_DEPT'', ''1'') = ''1'' then begin';  //SCY BZ 3210
      Script.Add := '    DataModule.tblPmtDisc.OnNewRecordArray := @SetDept; ';
      Script.Add := '    DataModule.tblPmtDisc.DeptID.OnValidateArray := @DeptValidate; ';
      Script.Add := '  end';
      Script.Add := '  else if ReadOption (''EMB_FOR_PROJ'', ''1'') = ''1'' then begin';
      Script.Add := '    DataModule.tblPmtDisc.OnNewRecordArray := @SetProject; ';
      Script.Add := '    DataModule.tblPmtDisc.ProjectID.OnValidateArray := @ProjectValidate; ';
      Script.Add := '  end;';
    end;
  end;
  Script.Add := format('  %s := @NameChange; ',[FieldChangearray]);
  if (formtrans = 'DO') or (formtrans = 'SI') then begin
    Script.Add := '  Detail.WarehouseID.OnChangeArray  := @WarehouseIDOnChange; ';
    Script.Add := '  Detail.SOID.OnChangeArray         := @DetailSOIDOnChange; ';
  end;
  Script.Add := '  TExtendedLookupField(GetField).OnValidateArray := @CabangValidate; ';
  add_main_general(formtrans);
  ValidateItem( IsUseItem );
  Script.Add := 'end.';
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptTrans2(FieldChangearray,FieldNameChange,FieldValidate,formtrans : String;
          IsNewRecord,IsVisibleBtn : Boolean);
Begin
  ClearScript;
  Variables;
  add_function_getCabang;

  if (formtrans='GL') then begin
    Script.Add := 'var tempMemo : string; ';
    Script.Add := '';
  end;
  Script.Add := 'procedure NameChange; ';
  Script.Add := 'begin';
  Script.Add := '  if getUserCabangName=S_ALL then exit; ';
  Script.Add := format('  %s := getUserCabangName; ',[FieldNameChange]);
  if (formtrans='FA') then begin
    Script.Add := '   Form.DBMemo.ReadOnly := True;';
  end;
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure CabangValidate; ';
  Script.Add := 'Begin ';
  Script.Add := '  if getUserCabangName=S_ALL then exit; ';
  if (formtrans='GL') then begin
//    Script.Add := '  if (UpperCase(Trim(tempMemo))=S_ALL) then exit;'; // AA, BZ 2713
    Script.Add := '  if (Trim(tempMemo)<>'''') and (Trim(Uppercase(tempMemo))<>Trim(Uppercase(getUserCabangName)))  then begin';
    Script.Add := '    if (Dataset.MEMO.Value) = null then raiseException(''You Do Not Have Access To Delete This Branch''); ';
    Script.Add := '    if Trim(Uppercase(Dataset.MEMO.Value)) <> Trim(Uppercase(tempMemo)) then raiseException(''You Do Not Have Access To Change This Branch''); ';
    Script.Add := '  end ';
    Script.Add := '  else begin ';
    Script.Add := '    if (Dataset.MEMO.Value) = null then exit; ';
    Script.Add := '    if Trim(Uppercase(Dataset.MEMO.Value)) <> Trim(Uppercase(getUserCabangName)) then raiseException(''Branches Must Not Be Altered''); ';
    Script.Add := '  end; ';
  end
  else begin
//    Script.Add := format('  if (Trim(Uppercase(%s))=S_ALL) then exit;', [FieldNameChange]); // AA, BZ 2713
    Script.Add := format('    if Trim(Uppercase(%s)) <> Trim(Uppercase(getUserCabangName)) then raiseException(''Branches Must Not Be Altered''); ',[FieldNameChange]);
  end;

  Script.Add := 'end;  ';
  Script.Add := '';
  if (formtrans='GL') then begin
    Script.Add := 'procedure DatasetAfterOpen; ';
    Script.Add := 'begin ';
    Script.Add := '  if (Dataset.MEMO.Value) <> null then begin ';
    Script.Add := '    tempMemo := Dataset.MEMO.Value; ';
    Script.Add := '  end;';
    Script.Add := 'end; ';
    Script.Add := '';
  end;
  Script.add := 'begin';
  Script.Add := '  InitializeVar; ';
  if (IsVisibleBtn) then begin
    Script.Add := '  if getUserCabangName <> S_ALL then begin ';
    if (formtrans='WH') then begin
      Script.Add := '    Form.btnNext.Visible  := false; ';
      Script.Add := '    Form.bntPrior.Visible := false; ';
    end
    else begin
      Script.Add := '    Form.btnNextX.Visible  := false; ';
      Script.Add := '    Form.btnPrevious.Visible := false; ';
    end;
    Script.Add := '  end;';
  end;
  Script.Add := format('  %s := @NameChange; ',[FieldChangearray]);
  Script.Add := format('  %s := @CabangValidate; ',[FieldValidate]);
  if (formtrans='GL') then begin
    Script.Add := '  Dataset.OnAfterOpenArray := @DatasetAfterOpen; ';
  end;
  if(IsNewRecord) then begin
     Script.Add := format('  if( %s )= Null then begin ',[FieldNameChange]);
     Script.Add := '    NameChange; ';
     Script.Add := '  end; ';
  end;
  Script.Add := 'end.';
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptForAccount;
begin
  GenerateScriptTrans2('Dataset.ACCOUNTTYPE.OnChangeArray','Dataset.MEMO.Value','Dataset.MEMO.OnValidateArray','GL',False,False);
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForDepartements;
begin
  GenerateScriptForList('d','Datamodule.Master.SelectSQL[1]','Datamodule.Master.OnBeforeOpenArray','DEPT','');
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForDepartement;
begin
  GenerateScriptTrans2('Dataset.OnAfterInsertArray','Dataset.DEPTNO.Value',' Dataset.OnBeforePostValidationArray','',False,False);
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForProjects;
begin
  GenerateScriptForList('Project','Datamodule.TblProject.SelectSQL[1]','Datamodule.TblProject.OnBeforeOpenArray','PROJECT','TblProject');
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForProject;
begin
  GenerateScriptTrans2('Dataset.OnAfterInsertArray','Dataset.PROJECTNO.Value',' Dataset.OnBeforePostValidationArray','',False,False);
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForWarehouses;
begin
  GenerateScriptForList2('w','Datamodule.Master.SelectSQL[0]','Datamodule.Master.OnBeforeOpenArray','WH','','','','',False,False);
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForWarehouse;
Begin
  //GenerateScriptTrans2('Dataset.OnNewRecordArray','Dataset.DESCRIPTION.Value','Dataset.DESCRIPTION.OnValidateArray','');
  GenerateScriptTrans2('Master.OnNewRecordArray','Master.DESCRIPTION.Value','Master.DESCRIPTION.OnValidateArray','WH',True,True);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptForFixedAssets;
begin
  GenerateScriptForList('FIXASSET','Datamodule.tblFixAsset.SelectSQL[1]','Datamodule.tblFixAsset.OnBeforeOpenArray','FA','');
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForFixedAsset;
begin
  GenerateScriptTrans2('Master.OnNewRecordArray','Master.NOTES.value','Master.NOTES.OnValidateArray','FA',True,True);
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForTemplates;
begin
  GenerateScriptForList('Template','Datamodule.tblTemplates.SelectSQL[1]','Datamodule.OnAssignTemplateSQL','TEMPLATE','tblTemplates');
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForTemplate;
begin
  ClearScript;
  Variables;
  add_function_getCabang;

  Script.Add := 'procedure CabangValidate; ';
  Script.Add := '  var tempTemplateName : string; ';
  Script.Add := 'begin ';
  Script.Add := '  if getUserCabangName=S_ALL then exit; ';
  Script.Add := '  tempTemplateName := GetToken(Dataset.TemplateName.value, ''-'', 2); ';
  Script.Add := '  if Trim(Uppercase(tempTemplateName)) <> Trim(Uppercase(getUserCabangName)) then raiseException(''Branches Must Not Be Altered''); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := '  InitializeVar; ';
  Script.Add := '  Dataset.OnBeforePostArray := @CabangValidate; ';
  Script.Add := 'end. ';
  //GenerateScriptTrans2('Master.OnNewRecordArray','Master.Name.value','Master.Name.OnValidateArray','',False,False);
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForSalesmans;
begin
  GenerateScriptForList2('Salesman','Datamodule.Master.SelectSQL[0]','Datamodule.Master.OnBeforeOpenArray','SALESMAN','','','','',False,False);
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForCustomers;
Begin
  GenerateScriptForList('c','Datamodule.Master.SelectSQL[1]','Datamodule.Master.OnBeforeOpenArray','','');
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptForVendors;
begin
  GenerateScriptForList('v','Datamodule.Master.SelectSQL[1]','Datamodule.Master.OnBeforeOpenArray','','');
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForItems;
begin
  GenerateScriptForList('Item','Datamodule.Master.SelectSQL[1]','Datamodule.Master.OnBeforeOpenArray', 'ITEM', 'Master');
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForCustomer;
Begin
  GenerateScriptTrans('Master.PersonName.OnChangeArray','CS', personTypeNone, NoWarehouse, NoBank, NoTemplate, NoSalesman,
    NoBeforePost, NoDiscInfo, NoItem, NoDepositTo, NoBank_Receive);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptForVendor;
begin
  GenerateScriptTrans('Master.PersonName.OnChangeArray','CS', personTypeNone, NoWarehouse, NoBank, NoTemplate, NoSalesman,
    NoBeforePost, NoDiscInfo, NoItem, NoDepositTo, NoBank_Receive);
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptForItem;
begin
  GenerateScriptTrans('Master.ItemNo.OnChangeArray','CS', personTypeNone, NoWarehouse, NoBank, NoTemplate, NoSalesman,
    NoBeforePost, NoDiscInfo, NoItem, NoDepositTo, NoBank_Receive);
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptSOs;
begin
  GenerateScriptForList('a','DataModule.tabelSO.SelectSQL[2]','Datamodule.tabelSO.BeforeOpen','SOs','');
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptSO;
Begin
  GenerateScriptTrans('Master.CUSTOMERID.OnChangeArray','SO', personTypeCust, NoWarehouse, NoBank, UseTemplate, UseSalesman,
    UseBeforePost, NoDiscInfo, UseItem, NoDepositTo, NoBank_Receive);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptDOs;
Begin
  GenerateScriptForList('R','DataModule.qryARInv.SelectSQL[4]','DataModule.qryARInv.BeforeOpen','','');
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptDO;
Begin
  GenerateScriptTrans('Master.CUSTOMERID.OnChangeArray','DO', personTypeCust, UseWarehouse, NoBank, UseTemplate, NoSalesman,
    UseBeforePost, NoDiscInfo, UseItem, NoDepositTo, NoBank_Receive);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptSIs;
Begin
  GenerateScriptForList('R','Datamodule.qryARInv.SelectSQL[4]','DataModule.qryARInv.BeforeOpen','SIs','');
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptSI;
Begin
  GenerateScriptTrans('Master.CUSTOMERID.OnChangeArray','SI', personTypeCust, UseWarehouse, NoBank, UseTemplate, UseSalesman,
    UseBeforePost, NoDiscInfo, UseItem, UseDepositTo, NoBank_Receive); //MMD, BZ 3522
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptSRs;
Begin
//  GenerateScriptForList2('R','DataModule.qryARRefund.SelectSQL[16]','Datamodule.qryARRefund.BeforeOpen','SRS','ADateFrom','ADateTo','R.InvoiceDate','',True,False);
  GenerateScriptForList2('R','DataModule.qryARRefund.SelectSQL[16]','Datamodule.qryARRefund.BeforeOpen','SRS','ADateFrom','ADateTo','R.InvoiceDate','',True ,True); //SCY BZ 3210

  {Script.Add := 'procedure AfterClose; ';
  Script.Add := '  function GetWhereClause:String; ';
  Script.Add := '  begin';
  Script.Add := '    result := format('' and ((select ed.%s from EXTENDED e '+
                      ' join EXTENDEDDET ed on ed.EXTENDEDDETID=e.%s'+
                      ' WHERE e.EXTENDEDID=R.EXTENDEDID) = ''''%s'''')'', '+
                      ' [BRANCH_NAME, BRANCH_FIELD, getUserCabangName]); ';
  Script.Add := '  end;';
  Script.Add := 'begin ';
  Script.Add := '  if getUserCabangName=S_ALL then begin ';
  Script.Add := '    TDMCreditMemos(DataModule).SqlWhereFromScript := ''''; ';
  Script.Add := '    exit ;';
  Script.Add := '  end';
  Script.Add := '  else begin ';
  Script.Add := '    TDMCreditMemos(DataModule).SqlWhereFromScript := GetWhereClause; ';
  Script.Add := '  end; ';
  Script.Add := 'end; '; ///
  Script.Add := ' ';
  Script.Add := 'begin';
  Script.Add := '  InitializeVar; ';
  Script.Add := '  Datamodule.qryARRefund.BeforeOpen  := @BeforeOpen; ';
  //Script.Add := '  Datamodule.qryARRefund.AfterClose  := @AfterClose; ';
  Script.Add := 'end.'; }
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptSR;
Begin
  GenerateScriptTrans('Master.CUSTOMERID.OnChangeArray','', personTypeCust, UseWarehouse, NoBank, UseTemplate, UseSalesman,
    UseBeforePost, NoDiscInfo, UseItem, NoDepositTo, NoBank_Receive);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptCRs;
Begin
  //GenerateScriptForList('A','Datamodule.AtblARPayments.SelectSQL[5]','Datamodule.BeforeOpenFromScript','CRS');
  ClearScript;
  Variables;
  add_function_getCabang;
  Script.Add := 'procedure BeforeOpen; ';
  Script.Add := '  var filter_sql,tempsql : string; ';
  Script.Add := '      count_sql   : integer; ';
  Script.Add := '      filter_Date : Boolean; ';
  Script.Add := '  function GetWhereClause:String; ';
  Script.Add := '  begin';
  Script.Add := '    result := format('' and ((select Upper(ed.%s) from EXTENDED e '+
                      ' join EXTENDEDDET ed on ed.EXTENDEDDETID=e.%s'+
                      ' WHERE e.EXTENDEDID=A.EXTENDEDID) = ''''%s'''')'', '+
                      ' [BRANCH_NAME, BRANCH_FIELD, getUserCabangName]); ';
  Script.Add := '  end;';
  Script.Add := '  function is_shall_sql_added:boolean; ';
  Script.Add := '  Begin ';
  Script.Add := '    result := (pos(filter_sql, Datamodule.AtblARPayments.SelectSQL.Text)=0); ';
  Script.Add := '  End;';
  Script.Add := 'begin ';
  Script.Add := '  filter_Date := Form.AchkDate.Checked; ';
  Script.Add := '  if (count_sql<1) then begin ';
  Script.Add := '    tempsql := Datamodule.AtblARPayments.SelectSQL[5]; ';
  Script.Add := '  end;  ';

  Script.Add := '  if getUserCabangName=S_ALL then begin ';  //SCY BZ 3210
  Script.Add := '    if (filter_Date) then begin';
  Script.Add := '      Datamodule.AtblARPayments.SelectSQL[5] := tempsql; ';
  Script.Add := '    end ';
  Script.Add := '    else begin ';
  Script.Add := '      Datamodule.AtblARPayments.SelectSQL[5] := ''''; ';
  Script.Add := '    end;';
  Script.Add := '  end ';
  Script.Add := '  else begin ';
  Script.Add := '    filter_sql := GetWhereClause; ';
  Script.Add := '    if is_shall_sql_added then begin ';
  Script.Add := '      if(count_sql>0) then begin ';
  Script.Add := '        Datamodule.AtblARPayments.SelectSQL[5] := ''''; ';
  Script.Add := '        if (filter_Date) then begin ';
  Script.Add := '          Datamodule.AtblARPayments.SelectSQL[5] := tempsql + filter_sql ;  ';
  Script.Add := '        end ';
  Script.Add := '        else begin ';
  Script.Add := '           Datamodule.AtblARPayments.SelectSQL[5] := filter_sql ; ';
  Script.Add := '        end; ';
  Script.Add := '      end ';
  Script.Add := '      else begin ';
  Script.Add := '        Datamodule.AtblARPayments.SelectSQL[5] := Datamodule.AtblARPayments.SelectSQL[5] + filter_sql ; ';
  Script.Add := '      end;';
  Script.Add := '      count_sql := count_sql + 1; ';
  Script.Add := '    end; ';
  Script.Add := '  end;';
  Script.Add := 'end; ';
  Script.Add := ' ';
  Script.Add := 'begin';
  Script.Add := '  InitializeVar; ';
  Script.Add := '  Datamodule.BeforeOpenFromScript := @BeforeOpen; ';
  Script.Add := 'end.';
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptCR;
Begin
  GenerateScriptTrans('Master.BANKACCOUNT.OnChangeArray','CR', personTypeCust, NoWarehouse, NoBank, UseTemplate, NoSalesman,
    UseBeforePost, UseDiscInfo, NoItem, NoDepositTo, UseBank_Receive); //MMD, BZ 3522
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptOP;
Begin
  GenerateScriptTrans('Master.JVNUMBER.OnChangeArray','JOURNAL', personTypeNone, NoWarehouse, UseBank, UseTemplate, NoSalesman,
    UseBeforePost, NoDiscInfo, NoItem, NoDepositTo, NoBank_Receive);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptJVs;
Begin
  GenerateScriptForList('j','Datamodule.AqryJV.SelectSQL[2]','Datamodule.AqryJV.BeforeOpen','JVs','');
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptJV;
Begin
  GenerateScriptTrans('Master.JVNUMBER.OnChangeArray','JOURNAL', personTypeNone, NoWarehouse, NoBank, UseTemplate, NoSalesman,
    UseBeforePost, NoDiscInfo, NoItem, NoDepositTo, NoBank_Receive);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptOR;
Begin
  GenerateScriptTrans('Master.JVNUMBER.OnChangeArray','JOURNAL', personTypeNone, NoWarehouse, UseBank, UseTemplate, NoSalesman,
    UseBeforePost, NoDiscInfo, NoItem, NoDepositTo, NoBank_Receive);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptPOs;
Begin
  GenerateScriptForList('po','Datamodule.ATblPo.SelectSQL[2]','Datamodule.ATblPo.OnBeforeOpenArray','POs','');
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptPO;
Begin
  GenerateScriptTrans('Master.VENDORID.OnChangeArray','PO', personTypeVend, NoWarehouse, NoBank, UseTemplate, NoSalesman,
    UseBeforePost, NoDiscInfo, UseItem, NoDepositTo, NoBank_Receive);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptRIs;
Begin
  GenerateScriptForList('R','Datamodule.qryAPInv.SelectSQL[7]','Datamodule.qryAPInv.BeforeOpen','RIs','');
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptRI;
Begin
  GenerateScriptTrans('Master.VENDORID.OnChangeArray','RI', personTypeVend, UseWarehouse, NoBank, UseTemplate, NoSalesman,
    UseBeforePost, NoDiscInfo, UseItem, NoDepositTo, NoBank_Receive);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptPIs;
Begin
  GenerateScriptForList('R','Datamodule.AqryAPInv.SelectSQL[7]','Datamodule.AqryAPInv.BeforeOpen','PIs','');
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptPI;
Begin
  GenerateScriptTrans('Master.VENDORID.OnChangeArray','PI', personTypeVend, UseWarehouse, NoBank, UseTemplate, NoSalesman,
    UseBeforePost, NoDiscInfo, UseItem, NoDepositTo, NoBank_Receive);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptPRs;
Begin
  GenerateScriptForList2('R','DataModule.AqryAPReturn.SelectSQL[8]','Datamodule.AqryAPReturn.BeforeOpen','PRs','','','','',False,False);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptPR;
Begin
  GenerateScriptTrans('Master.VENDORID.OnChangeArray','PR', personTypeVend, UseWarehouse, NoBank, UseTemplate, NoSalesman,
    UseBeforePost, NoDiscInfo, UseItem, NoDepositTo, NoBank_Receive);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptVPs;
Begin
  GenerateScriptForList2('C','Datamodule.AtblAPCheq.SelectSQL[5]','Datamodule.AtblAPCheq.BeforeOpen','VPs',
         'AedtStartDate','AedtEndDate','C.PaymentDate','and (PaymentDate between :StartDate and :EndDate)',True,True);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptWHSearchForm;
begin
  ClearScript;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  Variables;
  addIsWarehousePerItem;
  getUserCabangName;
  Script.Add := 'begin ';
  Script.Add := '  InitializeVar; ';
  Script.Add := '  if getUserCabangName = S_ALL then Exit; ';
  Script.Add := '  if IsWarehousePerItem then begin ';
//  Script.Add := '    Form.SetFilterAndOpen( Format('' where Upper(Description) = Upper(''''%s'''') '', [ getUserCabangName ] ) ); ';
  Script.Add := '    Form.SetFilterAndOpen( Format('' where Upper(Description) in (Upper(''''%s''''), ''''%s'''' ) '' '+
                     ', [getUserCabangName, S_ALL] ) ); '; // AA, BZ 2713
  Script.Add := '  end; ';
  Script.Add := 'end. ';
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptItemSearchForm;
begin
  ClearScript;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  Variables('ITEM');
  getUserCabangName;
  add_get_where_clause('', Script);
  Script.Add := 'begin';
  Script.Add := '  InitializeVar; ';
  Script.Add := '  if not SCRIPT_ON then exit;';
  Script.Add := '  if getUserCabangName = S_ALL then Exit; ';
  Script.Add := '  Form.QueryFilter := Form.QueryFilter + GetWhereClause(''l'');';
  Script.Add := 'end.';
end;

procedure TExclusiveMultiBranchInjector.getUserCabangName;
begin
  Script.Add := 'function getUserCabangName: String;';
  Script.Add := 'const TOKEN = ''-'';';
  Script.Add := '      EQUAL = ''='';';
  Script.Add := '      IDENTIFIER = ''D'' + EQUAL;';
  Script.Add := 'var';
  Script.Add := '    count : Integer;';
  Script.Add := '    idx   : Integer;';
  Script.Add := '    strElement : String;';
  Script.Add := '';
  CreateSQLTryFinally('getUser',
    'RunSQL(sql, format(''select u.fullname from users u where u.userid=%d'', [UserID])); '+
    'result := Uppercase(sql.FieldByName(''fullname'')); '
  );
  Script.Add := 'begin';
  Script.Add := '  result := getUser( TIBTransaction(Tx) );';
  Script.Add := '  count := CountToken( result, TOKEN );';
  Script.Add := '  if count = 0 then exit;';
  Script.Add := '  for idx := 1 to count do begin';
  Script.Add := '    strElement := GetToken( result, TOKEN, idx );';
  Script.Add := '    if Pos( IDENTIFIER, strElement ) = 0 then continue;';
  Script.Add := '    result := Trim(getToken(strElement, EQUAL, 2));';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TExclusiveMultiBranchInjector.get_department_id;
begin
  Script.Add := 'function GetDeptID:variant;';
  CreateSQLTryFinally('getDeptID',
    'result := null; '+
    'RunSQL(sql, format(''Select d.DeptID from Department d where d.DeptNo=''''%s'''''', [getUserCabangName])); '+
    'if (sql.RecordCount=0) then exit; '+
    'result := sql.FieldByName(''DeptID''); '
  );
  Script.Add := 'begin';
  Script.Add := '  result := getDeptID(TIBTransaction(Tx));';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TExclusiveMultiBranchInjector.get_project_id;
begin
  Script.Add := 'function GetProjectID:variant;';
  CreateSQLTryFinally('getProjectID',
    'result := null; '+
    'RunSQL(sql, format(''SELECT P.PROJECTID FROM PROJECT P WHERE P.PROJECTNO = ''''%s'''''', [getUserCabangName])); '+
    'if (sql.RecordCount=0) then exit; '+
    'result := sql.FieldByName(''PROJECTID''); '
  );
  Script.Add := 'begin';
  Script.Add := '  result := getProjectID(TIBTransaction(Tx));';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TExclusiveMultiBranchInjector.main_script_for_list(const formname, fieldbeforeopen, datasetname: String);
begin
  Script.Add := '  InitializeVar; ';
  Script.Add := '  if not SCRIPT_ON then Exit; ';
  Script.Add := format('  %s := @BeforeOpen; ',[fieldbeforeopen]);
  if (formname='DEPT') then begin
//    Script.Add := '  Datamodule.Master.OnAfterCloseArray := @AfterClose; ';
//    Script.Add := '  Datamodule.Master.OnBeforeCloseArray := @revertSQLParam; ';
    Script.Add := '  Datamodule.Master.OnAfterCloseArray := @revertSQLParam; '; // AA, BZ 3989
  end;
  if (formname='PROJECT') then begin  //SCY BZ 3210
//    Script.Add := '  Datamodule.TblProject.OnBeforeCloseArray := @revertSQLParam; ';
    Script.Add := '  Datamodule.TblProject.OnAfterCloseArray := @revertSQLParam; '; // AA, BZ 3990
  end;
  if ((formname='IRs') or (formname='ITs') or (formname='IAs') or (formname='TEMPLATE')
  or (formname='PROJECT') or (formname='ITEM')) then begin
    Script.Add := format('  Datamodule.%s.Close; ',[datasetname]);
    Script.Add := format('  Datamodule.%s.Open; ',[datasetname]);
  end;
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptVP;
Begin
  GenerateScriptTrans('Master.VENDORID.OnChangeArray','VP', personTypeVend, NoWarehouse, NoBank, UseTemplate, NoSalesman,
    UseBeforePost, UseDiscInfo, NoItem, NoDepositTo, NoBank_Receive);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptIRs;
Begin
  GenerateScriptForList('W','Datamodule.Atblireq.SelectSQL[1]','Datamodule.Atblireq.OnBeforeOpenArray','IRs','Atblireq');
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptIR;
Begin
  GenerateScriptTrans('Master.FROMWHID.OnChangeArray','IR', personTypeNone, UseWarehouse, NoBank, UseTemplate, NoSalesman,
    UseBeforePost, NoDiscInfo, UseItem, NoDepositTo, NoBank_Receive);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptITs;
Begin
  GenerateScriptForList('W','Datamodule.AtblWTran.SelectSQL[1]','Datamodule.AtblWTran.BeforeOpen','ITs','AtblWTran');
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptIT;
Begin
  GenerateScriptTrans('Master.FROMWHID.OnChangeArray','IT', personTypeNone, UseWarehouse, NoBank, UseTemplate, NoSalesman,
    UseBeforePost, NoDiscInfo, UseItem, NoDepositTo, NoBank_Receive);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptIAs;
Begin
  GenerateScriptForList('A','Datamodule.AtblItemAdj.SelectSQL[3]','Datamodule.AtblItemAdj.BeforeOpen','IAs','AtblItemAdj');
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptIA;
Begin
  GenerateScriptTrans('Master.ADJACCOUNT.OnChangeArray','IA', personTypeNone, UseWarehouse, NoBank, UseTemplate, NoSalesman,
    UseBeforePost, NoDiscInfo, UseItem, NoDepositTo, NoBank_Receive);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptJCs;
Begin
  GenerateScriptForList2('M','Datamodule.tblMfsht.SelectSQL[6]','Datamodule.tblMfsht.AfterClose','JCs','','','','',False,False);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptJC;
Begin
  GenerateScriptTrans('Master.WIPACCOUNT.OnChangeArray','JC', personTypeNone, UseWarehouse, NoBank, UseTemplate, NoSalesman,
    UseBeforePost, NoDiscInfo, UseItem, NoDepositTo, NoBank_Receive);
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptJCRO;
begin
  ClearScript;
  Variables;
  add_function_getCabang;
  ChangeWarehouseQuery;
  Script.Add := 'begin';
  Script.Add := '  InitializeVar; ';
  Script.Add := '  ChangeWarehouseQuery; ';
  Script.Add := 'end.';
end;

procedure TExclusiveMultiBranchInjector.GenerateScriptPIDataset;
begin
  ClearScript;
  Variables;
  add_function_getCabang;
  Script.Add := 'procedure SetCabangID;';
  Script.Add := 'begin';
  Script.Add := '  if Dataset.IsFirstPost or (Dataset.InvFromPR.value <> 1) then exit;';
  Script.Add := '  if getUserCabangName=S_ALL then exit; ';
  Script.Add := '  Dataset.ExtendedID.FieldLookup.FieldByName(BRANCH_FIELD).value := getUserCabangID; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  InitializeVar; ';
  Script.Add := '  Dataset.OnBeforePostValidationArray := @SetCabangID;';
  Script.Add := 'end.';
end;



procedure TExclusiveMultiBranchInjector.GenerateScriptIADs;
Begin
  ClearScript;
  Variables;
  add_function_getCabang;
  add_procedure_ChangeTemplateQuery('IADS');

  Script.Add := 'function GetField:TField;';
  Script.Add := 'begin';
  Script.Add := '  result := Dataset.ExtendedID.FieldLookup.FieldByName(BRANCH_FIELD); ';
  Script.Add := 'end;';
  Script.Add := 'procedure NameChange; ';
  Script.Add := 'begin';
  Script.Add := '  if getUserCabangName=S_ALL then exit; ';
  Script.Add := '  if (GetField.isnull) then begin ';
  Script.Add := '     if Dataset.DESCRIPTION.Value <> null then begin ';
  Script.Add := '       GetField.value := getUserCabangID; ';
  Script.Add := '     end; ';
  Script.Add := '     if (GetDefaultTemplateID)<> null then begin ';
  Script.Add := '       Dataset.TEMPLATEID.value := GetDefaultTemplateID; ';
  Script.Add := '     end; ';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.add := 'begin';
  Script.Add := '  InitializeVar; ';
  Script.Add := '  Dataset.OnBeforePostArray := @NameChange; ';
  Script.Add := 'end.';
End;

procedure TExclusiveMultiBranchInjector.GenerateScriptJVDs;
Begin
  ClearScript;
  Variables;
  add_function_getCabang;
  add_procedure_ChangeTemplateQuery('JVDS');

  Script.Add := 'function GetField:TField;';
  Script.Add := 'begin';
  Script.Add := '  result := Dataset.ExtendedID.FieldLookup.FieldByName(BRANCH_FIELD); ';
  Script.Add := 'end;';
  Script.Add := 'procedure NameChange; ';
  Script.Add := 'begin';
  Script.Add := '  if getUserCabangName=S_ALL then exit; ';
  Script.Add := '  if (GetField.isnull) then begin ';
  Script.Add := '     if Dataset.TRANSDESCRIPTION.Value <> null then begin ';
  Script.Add := '       GetField.value := getUserCabangID; ';
  Script.Add := '     end; ';
  Script.Add := '     if (GetDefaultTemplateID)<> null then begin ';
  Script.Add := '       Dataset.TEMPLATEID.value := GetDefaultTemplateID; ';
  Script.Add := '     end; ';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.add := 'begin';
  Script.Add := '  InitializeVar; ';
  Script.Add := '  Dataset.OnBeforePostArray := @NameChange; ';
  Script.Add := 'end.';
End;


procedure TExclusiveMultiBranchInjector.GenerateScript;
begin
  GenerateScriptForMain;
  InjectToDB( fnMain );

  GenerateScriptForCustomers;
  InjectToDB( fnCustomers );

  GenerateScriptForVendors;
  InjectToDB( fnVendors );

  GenerateScriptForItems;
  InjectToDB( fnItems );

  GenerateScriptForCustomer;
  InjectToDB( fnCustomer );

  GenerateScriptForVendor;
  InjectToDB( fnVendor );

  GenerateScriptForItem;
  InjectToDB( fnItem );

  GenerateScriptSOs;
  InjectToDB( fnSalesOrders );

  GenerateScriptSO;
  InjectToDB( fnSalesOrder );

  GenerateScriptDOs;
  InjectToDB( fnDOs );

  GenerateScriptDO;
  InjectToDB( fnDeliveryOrder );

  GenerateScriptSIs;
  InjectToDB( fnARInvoices );

  GenerateScriptSI;
  InjectToDB( fnARInvoice );

  GenerateScriptSRs;
  InjectToDB( fnCreditMemos );

  GenerateScriptSR;
  InjectToDB( fnARRefund );

  GenerateScriptCRs;
  InjectToDB( fnARPayments );

  GenerateScriptCR;
  InjectToDB( fnARPayment );

  GenerateScriptOP;
  InjectToDB( fnDirectPayment );

  GenerateScriptJVs;
  InjectToDB( fnJVs );

  GenerateScriptJV;
  InjectToDB( fnJV );

  GenerateScriptOR;
  InjectToDB( fnOtherDeposit );

  GenerateScriptPOs;
  InjectToDB( fnPurchaseOrders );

  GenerateScriptPO;
  InjectToDB( fnPurchaseOrder );

  GenerateScriptRIs;
  InjectToDB( fnRIs );

  GenerateScriptRI;
  InjectToDB( fnReceiveItem );

  GenerateScriptPIs;
  InjectToDB( fnAPInvoices );

  GenerateScriptPI;
  InjectToDB( fnAPInvoice );

  GenerateScriptPRs;
  InjectToDB( fnDebitMemos );

  GenerateScriptPR;
  InjectToDB( fnDM );

  GenerateScriptVPs;
  InjectToDB( fnAPCheques );

  GenerateScriptVP;
  InjectToDB( fnAPCheque );

  GenerateScriptIRs;
  InjectToDB( fnIRs );

  GenerateScriptIR;
  InjectToDB( fnRequestForm );

  GenerateScriptITs;
  InjectToDB( fnItemTransfers );

  GenerateScriptIT;
  InjectToDB( fnTransferForm );

  GenerateScriptIAs;
  InjectToDB( fnAdjInventories );

  GenerateScriptIA;
  InjectToDB( fnInvAdjustment );

  GenerateScriptJCs;
  InjectToDB( fnJobCosts );

  GenerateScriptJC;
  InjectToDB( fnJobCosting );

  GenerateScriptJCRO;
  InjectToDB( fnJCRollOver );

  GenerateScriptIADs;
  InjectToDB( dnIA );

  GenerateScriptJVDs;
  InjectToDB( dnJV );

  GenerateScriptForChooseForm;
  InjectToDB(fnChoose);

  GenerateScriptForSalesman;
  InjectToDB(dnSalesman);

  GenerateScriptForSalesmans;
  InjectToDB(fnSalesmens);

  GenerateScriptForAccount;
  InjectToDB(dnAccount);

  GenerateScriptForDepartements;
  InjectToDB(fnDepts);

  GenerateScriptForDepartement;
  InjectToDB(dnDepartment);

  GenerateScriptForProjects;
  InjectToDB(fnProjects);

  GenerateScriptForProject;
  InjectToDB(dnProject);

  GenerateScriptForWarehouses;
  InjectToDB(fnWarehouses);

  GenerateScriptForWarehouse;
  InjectToDB(fnWarehouse);

  GenerateScriptForFixedAssets;
  InjectToDB( fnFixAssets );

  GenerateScriptForFixedAsset;
  InjectToDB( fnFixAsset );

  GenerateScriptForTemplates;
  InjectToDB( fnTemplates );

  GenerateScriptForTemplate;
  InjectToDB( dnTemplate );

  GenerateScriptDeptbyUser;
  InjectToDB( dnSODet );
  InjectToDB( dnDODet );
  InjectToDB( dnSIDet );
  InjectToDB( dnSRDet );
  InjectToDB( dnCR    );

  InjectToDB( dnJVDet );

  InjectToDB( dnPODet );
  InjectToDB( dnRIItm );
  InjectToDB( dnPIItm );
  InjectToDB( dnPIDet );
  InjectToDB( dnPRDet );
  InjectToDB( dnVP    );

  InjectToDB( dnIADet );
  InjectToDB( dnJC );
  InjectToDB( dnJCDet );
  InjectToDB( dnJCGL  );
  InjectToDB( dnFixedAsset );

  GenerateScriptPIDataset;
  InjectToDB( dnPI );

  GenerateScriptWHSearchForm;
  InjectToDB( fnWarehouseSearch );

  GenerateScriptItemSearchForm;
  InjectToDB( fnItemSearch );

  //MMD, BZ 3521
  GenerateScriptForCreateCollection;
  InjectToDB(fnCreateCollection);

  //MMD, BZ 3523
  GenerateScriptForChequeControl;
  InjectToDB(fnChequeControl);

  //MMD, BZ 3525
  GenerateScriptForLoading;
  InjectToDB(fnLoading);
end;

Initialization
  Classes.RegisterClass( TExclusiveMultiBranchInjector );
end.
