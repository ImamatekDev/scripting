unit Injector;

interface

Uses
  Classes
  , jb_DB
  , Bankconst
  , ReadyToUseSQL
  , Sysutils
  , JvMemoryDataset
  ;

Type
  TProc = procedure of object;

  TScriptList = class
  private
    List : TStringList;
    procedure SetAdd(const Value: string);
    function GetItems(index: integer): String;
    function GetCount: Integer;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Text:String;
    function IsProcedureExist(ProcedureLine:String):Boolean;
    property Items[index:integer]:String read GetItems; default;
    property Add:string write SetAdd;
    property Count : Integer read GetCount;
  end;

  TInjectorType = (itNone, itBatchNo, itVipProgram, itTopas, itMGM, itGS_TR,
                   itDefaultUSD, itEPM, itDept, itToyobo, itPAS, itKM, itAttach,
                   itImamatek, itDutaFuji, itMfg, itDagsap, itGree, itQuotation,
                   itRunningFP, itJCInputSN, itTuguMas, itMextracom,
                   itSOOverlimit, itMfgWithMPS, itPKM, itTriSurya
                   ,itImportSN, itReport, itHMU, itBCL, itPolypack, itBJBU
                   ,itRunningNo, itGSRekso, itCBA, itGSSlawi, itJanur, itVPMultiDisc
                   ,itTrias, itDinamika, itGoshen
                   , itDigSense
                   , itExclusiveMultiBranch
                   , itPKMPusat
                   , itBenuaLestari
                   , itItemSalesTarget
                   , itSicmaIntiUtama
                   , itInclusiveTax
                   , itTrijayaAnugrahKreasi
                   , itEPM2
                   , itTritunggal
                   , itBebekKaleyo
                   , itImportXLDeptBudget
                   , itSendEmailSetting
                   , itEraSehat
                   , itKlikEatIndonesia
                   , itProductionResultBatchNo
                   , itPKNagaJaya
                   , itTopindo
                   , itTitianAbadi
                   , itIndocare
                   , itEPM3
                   , itNagoyaDenki
                   , itSuryaMandiri
                   , itSTree
                   , itTriasBatchNo
                   , itMakmurAbadi
                   , itImportTransaksiJV_SI_PI
                   , itSahabatMitra
                   , itFortuna
                   , itGSPabrik
                   , itSinarUsahaNiaga
                   , itSinarSaktiMetalindo
                   , itMitraCiptaKreatika
                   , itPrestasi
                   , itHasdiMustika
                   , itUniversalImporter
                   , itPrestasiPelumas
                   , itSakaIndah
                   , itAstangel
                   , itTotalindo
                   , itUtomo
                   , itSanghiangPerkasa
                   , itTriSamudraAmbon
                   , itSKM
                   , itSanghiangPerkasa2
                   , itSanghiangPerkasa3
                   , itBatchNoEnseval
                   , itInspirasiUtama
                   , itSpikoe
                   , itRapigra
                   , itOpenLockEnseval
                   , itBAI
                   , itExinter
                   , itPanganLestari
                   , itSKI
                   , itSKI2
                   , itSKI3
                   , itTuguMasGroup
                   , itEPMClosing
                   , itPanasonic
                   , itBookingStockSO
                   , itHandara
                   , itVictory
                   , itKPAN
                   , itAgson
                   , itWallpaper
                   , itOnlinePajak
                   , itTwoTaxNumber
                   , itBahana
                   , itSanghiangPerkasa4
                   , itBahanaPR
                   , itAman
                   , itMPO
                   , itDepoCell
                   , itSentralMultimitraGemilang
                   , itUGMandiri
                   , itAPPM
                   , itMobileCom
                   , itGlobalPratamaWijaya
                   , itCBASalesTarget
                   , itSinarMentariJayaAutoCalculate
                   , itSuryaMakmurKreasindo
                   , itSanghiangPerkasa5
                   , itOneClickCutOffMenu
                   , itKotaMinyak2
                   , itLockingTransaction
                   , itJawaPlasindoSentosa
                   , itArconPartamaCipta
                   , itPratamaAbadiSantosa
                   , itLockingBudget
                   , itCBAEditDeleteTrans
                   , itPickList
                   , itAutoClosingDate
                   , itAutoClosingSO
                   , itRoundingCR
                   , itBatangAlum
                   , itTOPValidation
                   , itBudgetProjPO
                   , itLockingOverSR
                   , itSIDOQtyLImitation
                   , itnaketPlace
                   , itSOMinSKULocking
                   , itSIMinSKULocking
                   , itSIWarningMinOrder
                   , itImportCSVBAI
                   , itFiaraUtamaDjaja
                   , itSaranaInjector
                   , itBookingStock
                   , itSP2BInjector
                   , itCustomTemplateCollection
                   , itRefractionFormula
                   , itAutoJCRO
                   , itRunningNoCashBank
                   , itMPP
                   , itSibalecKemas
                   , itIrItSoLink
                   , itItJcSoLink
                   , itPrestigeCargo
                   , itPurchaseRequest
                   , itHasilKarya
                   , itAutoPrice
                   , itCreateDO
                   , itOperationsCalc
                   , itApprovalPO
                   , itOnlineNoValidation
                   , itDescriptionExtension
                   , itDataProcessCSV
                   , itPIRIQtyLimitation
                   , itAttachmentPrestigeInjector
                   , itMajuInteriorInjector
                   , itSIAutoCalculationInjector
                   , itSIEditTemplateInjector
                   , itSOSellingPriceSettingInjector
                   , itIASettingSeparationInjector
                   , itRunningNumberbyFormInjector
                   , itAutomaticLockingPeriodInjector
                   , itUpdateProxyInjector
                   , itItGetRiInjector
                   , itTemplateAuthorization
                   , itRecalculateSOLimitInjector
                   , itSalesForceInjector
                   , itImportDiscPromoInjector
                   , itSearchExtensionInjector
                   , itSkipOverdueInjector
                   , itChequeValidationInjector
                   , itWarningMinOrderByValue
                   , itSkipOverdueUniversalImporterInjector
                   , itGetWarehouseInjector
                   , itBankRegistrationInjector
                   , itLockCustomerExtendedInjector
                   , itInvoiceCrossCheckingInjector
                   , itEMBProjectInjector
                   , itProductionProgressInjector
                   , itRawGoodPurchaseFlowInjector
                   , itPartialTransactionInjector
                   , itSalesPriceInjector
                   , itItemResourcePlanningInjector
                   , itPOAcceptanceInjector
                   , itAutoGenerateSIInjector
                   , itRunningNoAllFormInjector
                   , itAutoWarehouseBatchNoInjector
                   , itBPRInjector
                   , itListAlljournalCashBank
                   , itPRDistroUnit1
                   , itSILimitation
                   , itCRBankFilter
                   , itSearchingCashBankContaining
                   , itItemLatestPrice
                   , itTaxReportMenu
                   , itItemTotalQty
                   , itApprovalOverPrintDO
                   , itAdjustmentSeparation
                   , itTermOfPaymentPIByDueDate
                   , itCreateDOorSIfromListSO
                   , itOpenLockingCompanyInfoDate
                   , itDisablePIColumnsFromOtherTransaction
                   , itUnitPriceAndDiscColumnLockingOnPI
                   , itSalesCommission
                   , itPOGetSO
                   , itItemTransferGetRequestRM
                   , itItemsListCategoryFilter
                   , itItemFormulaAndValidation
                   , itDOAdjustment
                   , itSalesReceipt
                   , itCustomerRunningNoByTemplate
                   , itAllowOverdueSalesInvoicePerUser
                   , itCreateSIFromSO
                   , itSOListDepartmentFilter
                   , itSIListDepartmentFilter
                   , itSalesInvoiceListReceiptNumber
                   , itPurchaseOrderPayment
                   , itDeliveryOrderHandover
                   , itEditPOCustomField
                   , itLockingOverduePerGroupCustomer
                   , itMasterItemAndPersonDataApproval
                   , itSIDatePrevention
                   , itPrintedSILocking
                   , itPIByPassPeriod
                   , itPIByPassPeriodWithClosing
                   , itInputEMOSSO
                   , itWaterConsumption
                   , itPrintMultiTemplates
                   , itUpdateCustomerDataFromCSV
                   , itSalesAutoInclusiveTaxInjector
                   , itTaxRunningNumberByTemplateInjector
                   , itSalesPriceHistoryInjector
                   , itAdminLevelOtoritasInjector
                   , itRunningNoFPPlusPEInjector
                   , itJCROMultiAccountInjector
                   , itLockSIDeleteForUserInjector
//                   , itTukarFakturDSUInjector
                   , itUIDataConverterInjector
                   , itOracleSyncInjector
                   , itPaymentRequestInjector
                   , itPireniaRunningNumberByTemplateInjector
                   , itExportFileAttachmentInjector
                   , itIndoTamaCashBankContainingInjector
                   , itIDOSConverterInjector
                   , itCustomItemSearchInjector
                   , itUncloseWOInjector
                   , itMMIDataProcessInjector
                   , itUniqueSalesmanInjector
                   , itStockOpnameInjector
                   , itITProjectInjector
                   , itIAProjectInjector
                   , itKuncianHargaJualInjector
                   , itCreateWOInjector
                   , itMassDeleteInjector
                   , itJCIAValueFilterInjector
                   , itSIQtyLimitationInjector
                   , itFGProductionRequestInjector
                   , itND6ConverterInjector
                   , itRTUDataProcessInjector
                   , itViewTransactionInjector
                   , itLockOverdueDOInjector
                   , itProjectTypeInjector
                   , itSalesmanProjectTypeInjector
                   , itDetailSOSelectionInjector
                   , itDetailPOSelectionInjector
                   , itSHPSOOverlimitApprovalInjector
                   , itAdditionalDetailSalesDiscountInjector
                   , itLockUserOPInjector
                   , itARMappingInjector
                   , itBrandAndCOAAutoFillInjector
                   , itReportRestrictionInjector
                   , itCSSDataProcessInjector
                   , itITBookingStockInjector
                   , itKNDataProcessInjector
                   , itND6DataProcessInjector
                   , itMBFDataProcessInjector
                   , itPrintToFileInjector
                   , itTestOFInjector

                   // Grouping Injector Type
                   , itScriptCombinationWithClosingFeature
//                   , itScriptCombinationWithoutClosingFeature
);

//  TInjector = class
  TInjector = class(TPersistent)
  private
    Ffeature_name: string;
    Fremote_injection_ds: TJvMemoryData;
    Fremote_database_guid: string;
    FisPlainText: Boolean;
    procedure GetUserLevel(FieldName: String; Level: Integer);
    procedure Setfeature_name(const Value: string);
    procedure Setremote_injection_ds(const Value: TJvMemoryData);
    procedure Setremote_database_guid(const Value: string);
    procedure SetisPlainText(const Value: Boolean);
  protected
    DB : TjbDB;
    Tx : TjbTx;
    Script : TScriptList;
    procedure add_procedure_runsql;
    procedure AddFunction_CreateSQL;
    procedure InjectToDB(form_name: TFormName);
    procedure inject_to_remote_dataset(form_name:TFormName);
    procedure set_scripting_parameterize; virtual;
    procedure ClearScript;
    procedure CreateTx;
    procedure CreateButton;
    procedure CreateLabel;
    procedure CreateEditBox;
    procedure CreatejbEdit;
    procedure CreateQuery;
    procedure RunQuery;
    procedure CreateCheckBox;
    procedure MainAddCustomReport;
    procedure CreateMenu;
    procedure remove_menu;
    procedure GenerateScriptCheckDept;
    procedure AddProcedureRoundingCR;
    procedure AddProcedureAutoSumCR;
    procedure IsAdmin;
    procedure IsSupervisor;

    procedure CreateMemo;
    procedure CallFinaAttachment;
    procedure CreateListView;
    procedure CreateRadioButton;
    procedure ReadOption;
    procedure WriteOption;
    procedure CreateForm;
    procedure CreateFormSetting;
    procedure CreateComboBox;
    procedure AddScriptAttach(FieldName, FormName: String; Proc:TProc; AOwner:string='pnlJbButtons';
      L:String='0'; T:String='0'; W:String='0'; H:String='20');
    procedure GroupingAsBOM;
    procedure CreateFormChoose;
    function is_doing_remote_injection:boolean;
    procedure FillBatchNoBeforePost(const WarehouseField:String = 'detail.WarehouseID');
    procedure GetAuthorization;
    procedure SendEmail;
    procedure CheckCreditLimit(AmountField, TblName, IDField, DateField:String; Tax1AmountField:String=''; Tax2AmountField:String='');
    procedure CreatePickDate;
    procedure PrintTransactionInAllList;
    procedure PrintOneTransaction(TblName, FieldName, ID : String; UseDM : Boolean);
    procedure AddPrintForm(TblName, FieldName, ID, Dataset:String; UseDM:Boolean=false; FromNo:String='edtNoFrom.Text'; ToNo:String='edtNoTo.Text');
    procedure MultiDBConsolFunction;
    procedure AddFilterByNumber(filter, Dataset, Index, DateTo, FilterCaption, BottomCtl, FieldName, btnReset, CheckDate:String; idx:String='');
    procedure GetDateDialog;
    procedure GetDateRangeDialog;
    Procedure is_distro_variant;
    Procedure LeftStr;
    Procedure RightStr;
    procedure LeftPos;
    procedure TopPos;
    procedure DatasetExtended;
    procedure MasterExtended;
    procedure DetailExtended;
    Procedure CreateCustomMenuSetting;
    procedure CreateProgressBar;
    procedure CreatePanel;
    procedure CreateJBLabel;
    procedure WriteToIniFile;
    procedure IsNumber;
    procedure CreateGrid;
    procedure CreateCurrencyEdit;
    procedure set_display_width_dataset;
    procedure LoopInDataset(LoopName, procName: String);
    procedure CreateSQLTryFinally(procName, ExecProcName:String);
    procedure setOptionsDistro;
    procedure getOptionDistro;
    procedure CreateDBCheckBox;
    procedure addMenuAddOn;
    procedure addIsWarehousePerItem;
    procedure CheckFTPAvalibilityLine;
    procedure LoadCombo;
    procedure GetScriptStructure(form_name: TFormName);
    procedure IsFullNameUser;
    procedure IsActiveScriptExist;
    procedure Ceil;
  public
    msg_to_user : TStringList;
    constructor Create(Adb:TjbDB; aTx:TjbTx);
    destructor Destroy; override;
    procedure GenerateScript; virtual; abstract;
    function create_other_script( other_injector_class_name:string ):boolean;
    function describe_manual_step:string; virtual;
    property feature_name:string read Ffeature_name write Setfeature_name;
    property remote_injection_ds:TJvMemoryData read Fremote_injection_ds write Setremote_injection_ds;
    property remote_database_guid:string read Fremote_database_guid write Setremote_database_guid;
    property isPlainText : Boolean read FisPlainText write SetisPlainText;  //SCY BZ 3094
    property AScript : TScriptList read Script;
  end;

  TInjectorClass = class of TInjector;

implementation

Uses
  ScriptConst
  , ScriptUtility
  , DatasetBatchNoInjector
  , VersionUtility
  , Forms
  , IdFTP
  ;

{ TInjector }

procedure TInjector.InjectToDB(form_name:TFormName);

  procedure inject_directly_to_database;
  var
    sql:IReadyToUseSQL;
    script_util : TScriptUtility;
  begin
    sql := TReadyToUseSQL.Create( Tx );
    script_util := TScriptUtility.Create;
    Try
      script_util.UpdateScript(sql.jb_sql, form_name, Script.Text, True, self.feature_name);
    Finally
      FreeAndNil( script_util );
    End;
  end;

begin
  if isPlainText then begin
    GetScriptStructure(form_name);
  end
  else if is_doing_remote_injection then begin
    inject_to_remote_dataset(form_name);
  end
  else begin
    inject_directly_to_database;
  end;
end;

procedure TInjector.inject_to_remote_dataset(form_name: TFormName);
var
  script_util : TScriptUtility;
begin
  remote_injection_ds.Append;
  remote_injection_ds.FieldByName('FormType').AsInteger := Ord(form_name);
  remote_injection_ds.FieldByName('FeatureName').AsString := UpperCase(self.feature_name);
//  remote_injection_ds.FieldByName('Script').AsString := Script.Text;
  script_util := TScriptUtility.Create;
  Try
    remote_injection_ds.FieldByName('Script').AsString := script_util.encrypt_script(nil, Self.remote_database_guid+Script.Text);
  Finally
    FreeAndNil(script_util);
  End;
  remote_injection_ds.post;
end;

procedure TInjector.GetScriptStructure(form_name: TFormName);
begin
  remote_injection_ds.Append;
  remote_injection_ds.FieldByName('FormType').AsInteger   := Ord(form_name);
  remote_injection_ds.FieldByName('FeatureName').AsString := UpperCase(self.feature_name);
  remote_injection_ds.FieldByName('Script').AsString      := Script.Text;
  remote_injection_ds.post;
end;

procedure TInjector.add_procedure_runsql;
begin
  if not Script.IsProcedureExist('procedure RunSQL( qryObj:TjbSQL; sql:string; Execute:Boolean=true );') then begin
    Script.Add := 'begin';
    Script.Add := '  qryObj.close;';
    Script.Add := '  qryObj.sql.text := sql;';
    Script.Add := '  if execute then begin';
    Script.Add := '    qryObj.ExecQuery;';
    Script.Add := '  end;';
    Script.Add := 'end;';
    Script.Add := EmptyStr;
  end;
end;

procedure TInjector.AddFunction_CreateSQL;
begin
  if not Script.IsProcedureExist('function CreateSQL(Trans:TIBTransaction):TjbSQL;') then begin
    Script.Add := 'begin                                                                           ';
    Script.Add := '  result := TjbSQL.Create(nil);                                                 ';
    Script.Add := '  result.database    := TIBDatabase(DB);                                        ';
    Script.Add := '  result.Transaction := Trans;                                                  ';
    Script.Add := 'end;                                                                            ';
    Script.Add := '                                                                                ';
  end;
end;

procedure TInjector.addIsWarehousePerItem;
begin
  if not Script.IsProcedureExist('function IsWarehousePerItem : Boolean;') then begin
    Script.Add := 'var sql_wpi   : TjbSQL; ';
    Script.Add := '    value_wpi : String; ';
    Script.Add := '    idx       : Integer; ';
    Script.Add := 'const WPI_SETTING = 12;';
    Script.Add := 'begin ';
    Script.Add := '  result  := False; ';
    Script.Add := '  sql_wpi := CreateSQL(TIBTransaction(Tx)); ';
    Script.Add := '  try ';
    Script.Add := '    RunSQL( sql_wpi, ''Select Reserved1 from Company'' ); ';
    Script.Add := '    value_wpi := sql_wpi.FieldByName(''Reserved1''); ';
    Script.Add := '    for idx := 1 to Length( value_wpi ) do begin ';
    Script.Add := '      if idx = WPI_SETTING then begin ';
    Script.Add := '        result := value_wpi[idx] = ''1''; ';
    Script.Add := '        Break; ';
    Script.Add := '      end; ';
    Script.Add := '    end; ';
    Script.Add := '  finally ';
    Script.Add := '    sql_wpi.Free; ';
    Script.Add := '  end; ';
    Script.Add := 'end; ';
    Script.Add := '';
  end;
end;

procedure TInjector.addMenuAddOn;
begin
  Script.Add := 'procedure addMenuAddOn(ScriptName, InfoScriptName, ScriptSettingName, InfoSettingName, doEvent:String); ';
  Script.Add := 'var mnuFeatures : TMenuItem; ';
  Script.Add := '    mnuScriptName : TMenuItem; ';
  Script.Add := '    mnuSetting : TMenuItem; ';
  Script.Add := '    idxScript : Integer; ';
  Script.Add := '  function getIdxScript(mnu:TMenuItem):Integer; ';
  Script.Add := '  begin ';
  Script.Add := '    result := mnu.Count; ';
  Script.Add := '    if idxScript <> 0 then begin ';
  Script.Add := '      result := mnu.Count-1; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := 'begin ';
  Script.Add := '  mnuFeatures := TMenuItem(Form.FindComponent(''mnuFeatures'')); ';
  Script.Add := '  if mnuFeatures = nil then begin ';
  Script.Add := '    mnuFeatures := CreateMenu( (Form.mnuAddOn.Count-1), Form.mnuAddOn, '+
                       '''mnuFeatures'', ''Features'', '''');';
  Script.Add := '  end; ';
  Script.Add := '  mnuScriptName := TMenuItem(Form.FindComponent( Format(''mnu%s'',[ScriptName]) )); ';
  Script.Add := '  if mnuScriptName = nil then begin ';
  Script.Add := '    idxScript := getIdxScript(mnuFeatures); ';
  Script.Add := '    mnuScriptName := CreateMenu( idxScript, mnuFeatures, Format(''mnu%s'',[ScriptName]), '+
                       'Format(''%S'',[InfoScriptName]), '''');';
  Script.Add := '  end; ';
  Script.Add := '  mnuSetting := TMenuItem(Form.FindComponent( Format(''mnu%s'',[ScriptSettingName]) )); ';
  Script.Add := '  if mnuSetting = nil then begin ';
  Script.Add := '    idxScript := getIdxScript(mnuScriptName); ';
  Script.Add := '    mnuSetting := CreateMenu( idxScript, mnuScriptName, Format(''mnu%s'',[ScriptSettingName]), '+
                       'Format(''%S'',[InfoSettingName]), doEvent);';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

constructor TInjector.Create(Adb:TjbDB; aTx:TjbTx);
begin
  Fremote_injection_ds := nil;
  Fremote_database_guid := '';
  DB := ADB;
  Tx := ATx;
  msg_to_user := TStringList.Create;
  Script := TScriptList.Create;
  set_scripting_parameterize;
end;

procedure TInjector.CreateSQLTryFinally(procName, ExecProcName: String);
(* Contoh Cara Pakai:

  Script.Add := 'procedure UpdateSI_NoKwitansi(SIID:Integer; KwiNo:String);';
  CreateSQLTryFinally('doSomething',
                      'RunSQL(sql, ''select * from Something''); '+
                      'while not sql.eof do begin '+
                      '  //do_something_with_the_data; '+
                      '  sql.next; '+
                      'end; ');'
  Script.Add := 'begin';
  Script.Add := '  doSomething( TIBTransaction(Tx) );';
  Script.Add := 'end;';
*)
begin
  Script.Add := format('function %s( ATx:TIBTransaction ):Variant;', [procName]);
  Script.Add := 'var sql : TjbSQL;';
  Script.Add := 'begin';
  Script.Add := '  sql := CreateSQL(ATx);';
  Script.Add := '  try';
  Script.Add := format('    %s', [ExecProcName]);
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
end;

destructor TInjector.Destroy;
begin
  msg_to_user.Free;
  Script.Free;
  inherited;
end;

procedure TInjector.FillBatchNoBeforePost(const WarehouseField:String = 'detail.WarehouseID');
begin
  Script.Add := 'var ';
  Script.Add := '  BATCHFIELD           : String; ';
  Script.Add := '  EXPIRED_FIELD        : String; ';
  Script.Add := '  REQUIRED_BATCH_FIELD : String; ';
  Script.Add := '';
  Script.Add := 'procedure InitializeFillBatchNoFieldName; ';
  Script.Add := 'begin ';
  Script.Add := format('  BATCHFIELD            := ReadOption(''%s''); ', [OPTIONS_PARAM_NAME_BATCH_NO_FIELD]);
  Script.Add := format('  EXPIRED_FIELD         := ReadOption(''%s''); ', [OPTIONS_PARAM_NAME_EXPIRED_DATE_FIELD]);
  Script.Add := format('  REQUIRED_BATCH_FIELD  := ReadOption(''%s''); ', [OPTIONS_PARAM_NAME_REQUIRED_BATCH_NO_FIELD]);
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure DetailBeforePost; ';
  Script.Add := 'var sql:TjbSQL; ';
  Script.Add := '    BNForm : TBatchNoSearchForm;';
  Script.Add := '  function GetWHID:Integer; ';
  Script.Add := '  begin ';
  Script.Add := format('    if %s.isNull then begin', [WarehouseField]);
  Script.Add := '      result := -1;';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := format('      result := %s.value;', [WarehouseField]);
  Script.Add := '    end;';
  Script.Add := '  end; ';
  Script.Add := '  function GetItemNo:String; ';
  Script.Add := '  begin ';
  Script.Add := '    if detail.ItemNo.isNull then begin';
  Script.Add := '      result := '''' ;';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      result := detail.ItemNo.AsString;';
  Script.Add := '    end;';
  Script.Add := '  end; ';
  Script.Add := 'begin ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sql, format(''Select e.%s from Item i, Extended e where i.ItemNo=''''%s'''' and i.ExtendedID=e.ExtendedID'', '+
                ' [REQUIRED_BATCH_FIELD, Detail.ItemNo.value])); ';
  Script.Add := '    if sql.FieldByName(REQUIRED_BATCH_FIELD) = ''1'' then begin ';
  Script.Add := '      BNForm := TBatchNoSearchForm.Create( nil );';
  Script.Add := '      Try';
  Script.Add := '        BNForm.Warehouse_id := GetWHID; ';
  Script.Add := '        BNForm.item_no      := GetItemNo;';
  Script.Add := '        if ( BNForm.ShowModal=mrOk ) then begin';
  Script.Add := '          detail.fieldByName( BATCHFIELD    ).AsString := BNForm.selected_batch_no;';
  Script.Add := '          detail.fieldByName( EXPIRED_FIELD ).AsString := BNForm.selected_expired_date;';
  Script.Add := '        end;';
  Script.Add := '      Finally';
  Script.Add := '        BNForm.Free;';
  Script.Add := '      End;';
  Script.Add := '    end; ';
  Script.Add := '  finally';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';

end;

procedure TInjector.set_display_width_dataset;
begin
  if not Script.IsProcedureExist('procedure set_display_width(Dataset:TJvMemoryData; FieldName:String; Width:Integer); ') then begin
    Script.Add := 'begin ';
    Script.Add := '  Dataset.FieldByName(FieldName).DisplayWidth := Width; ';
    Script.Add := 'end; ';
    Script.Add := '';
  end;
end;

procedure TInjector.set_scripting_parameterize;
begin
  // set default value for any parameterize variable for the script that will get injected to database.
  // example, we can change batch no field to any itemreserved field.
  feature_name := SCRIPTING_DEFAULT_FEATURE_NAME;
end;

procedure TInjector.TopPos;
begin
  if not Script.IsProcedureExist('function TopPos(obj: TControl; Spacing:Integer = 5):Integer;') then begin
    Script.Add := 'begin ';
    Script.Add := '  result := obj.Top + obj.Height + Spacing; ';
    Script.Add := 'end; ';
    Script.Add := '';
  end;
end;

function TInjector.describe_manual_step: string;
var V1, V2, V3, V4 : Integer;
begin
  // describe any manual step to users, in order to get the feature working.
  GetFileVersion( Application.ExeName, V1, V2, V3, V4 );
  result := 'Please open FINA with this database to use this new feature.' + #13#10;
  result := result + Format('Script Injector Version : %d.%d.%d.%d', [V1, V2, V3, V4]);
end;

procedure TInjector.ClearScript;
begin
  Script.Clear;
end;

procedure TInjector.CreateTx;
begin
  if not Script.IsProcedureExist('function CreateATx:TIBTransaction;') then begin
    Script.Add := 'begin                                             ';
    Script.Add := '  result := TIBTransaction.Create(nil);           ';
    Script.Add := '  result.DefaultDatabase := TIBDatabase(DB);      ';
    Script.Add := '  result.Params.Add(''read_committed'');      ';
    Script.Add := '  result.Params.Add(''rec_version'');         ';
    Script.Add := '  result.Params.Add(''nowait'');              ';
    Script.Add := '  result.StartTransaction;                        ';
    Script.Add := 'end;                                              ';
    Script.Add := EmptyStr;
  end;
end;

function TInjector.create_other_script(other_injector_class_name: string): boolean;
var
  injector_obj : TInjector;
begin
  injector_obj := TInjectorClass( GetClass( other_injector_class_name ) ).create( self.DB, self.Tx );
  try
    injector_obj.remote_injection_ds := self.remote_injection_ds;
    injector_obj.remote_database_guid := self.remote_database_guid;
    injector_obj.GenerateScript;
    result := True;
  finally
    injector_obj.Free;
  end;
end;

procedure TInjector.CreateButton;
begin
  if not Script.IsProcedureExist('function CreateBtn(L, T, W, H, ATag:Integer; Cap:String; AParent:TWinControl):TButton;') then begin
    Script.Add := 'begin                                                                                         ';
    Script.Add := '  result := TButton.Create(AParent);                                                          ';
    Script.Add := '  result.SetBounds(L, T, W, H);                                                               ';
    Script.Add := '  result.Caption := Cap;                                                                      ';
    Script.Add := '  result.Parent  := AParent;                                                                  ';
    Script.Add := '  result.Tag     := ATag;                                                                     ';
    Script.Add := 'end;                                                                                          ';
    Script.Add := '                                                                                              ';
  end;
end;

procedure TInjector.CreateLabel;
begin
  if not Script.IsProcedureExist('function CreateLabel(L, T, W, H:Integer; Cap:String; AParent:TWinControl):TLabel;') then begin
    Script.Add := 'begin                                                                                         ';
    Script.Add := '  result := TLabel.Create( AParent );                                                         ';
    Script.Add := '  result.Parent   := AParent;                                                                   ';
    Script.Add := '  result.AutoSize := false;                                                                   ';
    Script.Add := '  result.SetBounds( L, T, W, H);                                                            ';
    Script.Add := '  result.Caption  := Cap;                                                                      ';
    Script.Add := 'end;                                                                                          ';
    Script.Add := '                                                                                              ';
  end;
end;

procedure TInjector.CreateEditBox;
begin
  if not Script.IsProcedureExist('function CreateEdit(L, T, W, H:Integer; AParent:TWinControl):TEdit; ') then begin
    Script.Add := 'begin                                                               ';
    Script.Add := '  result := TEdit.Create(AParent);                                  ';
    Script.Add := '  result.Parent := AParent;                                         ';
    Script.Add := '  result.SetBounds(L, T, W, H);                                     ';
    Script.Add := 'end;                                                                ';
    Script.Add := EmptyStr;
  end;
end;

procedure TInjector.CreateQuery;
begin
  if not Script.IsProcedureExist('function CreateQuery(Trans:TIBTransaction) : TIBQuery;') then begin
    Script.Add := 'begin                                        ';
    Script.Add := '   result := TIBQuery.Create(nil);           ';
    Script.Add := '   result.Database    := TIBDatabase(DB);    ';
    Script.Add := '   result.Transaction := Trans;              ';
    Script.Add := 'end;                                         ';
    Script.Add := EmptyStr;
  end;
end;

procedure TInjector.CreatePanel;
begin
  if not Script.IsProcedureExist('function CreatePanel( L, T, W, H : Integer; AParent: TWinControl): TPanel; ') then begin
    Script.Add := 'begin ';
    Script.Add := '  result := TPanel.Create(AParent); ';
    Script.Add := '  result.SetBounds( L, T, W, H ); ';
    Script.Add := '  result.Parent := AParent; ';
    Script.Add := 'end; ';
    Script.Add := '';
  end;
end;

procedure TInjector.CreatePickDate;
begin
  if not Script.IsProcedureExist('function CreatePickDate(L,T,W,H:Integer; AParent:TWinControl):TDateTimePicker;') then begin
    Script.Add := 'begin';
    Script.Add := '  result := TDateTimePicker.Create(AParent); ';
    Script.Add := '  result.Parent := AParent; ';
    Script.Add := '  result.SetBounds(L, T, W, H);';
    Script.Add := 'end;';
    Script.Add := '';
  end;
end;

procedure TInjector.RunQuery;
begin
  if not Script.IsProcedureExist('procedure RunQuery( Query : TIBQuery; text : String ); ') then begin
    Script.Add := 'begin                                                ';
    Script.Add := '  if not Query.Transaction.Active then Query.Transaction.StartTransaction;';
    Script.Add := '  if Query.Active then Query.Close;              ';
    Script.Add := '  Query.SQL.Clear;                                  ';
    Script.Add := '  Query.SQL.Add(text);                              ';
    Script.Add := '  Query.Open;                                       ';
    Script.Add := 'end;                                                 ';
    Script.Add := '	                                              ';
  end;
end;

procedure TInjector.SetisPlainText(const Value: Boolean);
begin
  FisPlainText := Value;
end;

procedure TInjector.Setremote_database_guid(const Value: string);
begin
  Fremote_database_guid := Value;
end;

procedure TInjector.Setremote_injection_ds(const Value: TJvMemoryData);
begin
  Fremote_injection_ds := Value;
end;

procedure TInjector.CreateCheckBox;
begin
  if not Script.IsProcedureExist('function CreateCheckBox(L, T, W, H : Integer; Cap: String; AParent : TWinControl):TCheckBox;') then begin
    Script.Add := 'begin                                                                               ';
    Script.Add := '  result := TCheckBox.Create(AParent);                                              ';
    Script.Add := '  result.Parent := AParent;                                                         ';
    Script.Add := '  result.SetBounds(L, T, W, H);                                                     ';
    Script.Add := '  result.Caption := Cap;                                                            ';
    Script.Add := 'end;                                                                                ';
    Script.Add := EmptyStr;
  end;
end;

procedure TInjector.MainAddCustomReport;
begin
  Script.Add := 'CONST OFFSET = 100; ';
  Script.Add := 'function CreateIni:TInifile;                                   ';
  Script.Add := 'begin                                                          ';
  Script.Add := '  result := TInifile.Create( ExtractFilePath(Application.ExeName ) + ''report.ini'');';
  Script.Add := 'end;                                                           ';
  Script.Add := EmptyStr;
  Script.Add := 'procedure ReportClick(sender:TObject);                         ';
  Script.Add := 'var ini      : TInifile;                                       ';
  Script.Add := '  function GetNameInInteger(isDiv:Boolean):Integer; ';
  Script.Add := '  begin';
  Script.Add := '    result := TMenuItem(sender).Tag; ';
  Script.Add := '    if result > OFFSET then begin';
  Script.Add := '      if IsDiv then begin';
  Script.Add := '        result := result div OFFSET; ';
  Script.Add := '      end';
  Script.Add := '      else begin';
  Script.Add := '        result := result mod OFFSET; ';
  Script.Add := '      end;';
  Script.Add := '    end;';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := '  function GetSectionName:String; ';
  Script.Add := '  begin';
  Script.Add := '    result := IntToStr(GetNameInInteger(true)); ';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  function GetFileName:String; ';
  Script.Add := '  begin';
  Script.Add := '    result := ''FileName'';';
  Script.Add := '    if TMenuItem(sender).Tag > OFFSET then begin';
  Script.Add := '      result := format(''%s%d'', [result, GetNameInInteger(false)]);';
  Script.Add := '    end';
  Script.Add := '  end; ';
  Script.Add := 'begin                                                          ';
  Script.Add := '  if TMenuItem(sender).Tag = 0 then exit;                      ';
  Script.Add := '  ini := CreateIni;                                            ';
  Script.Add := '  try';
  Script.Add := '    OpenFRF( ini.ReadString( GetSectionName, GetFileName, ''C:\report.frf'') );                                       ';
  Script.Add := '  finally                                                      ';
  Script.Add := '    ini.Free;                                                  ';
  Script.Add := '  end;                                                         ';
  Script.Add := 'end;                                                           ';
  Script.Add := EmptyStr;
  Script.Add := 'procedure AddCustomReport;                                     ';
  Script.Add := 'var ini:Tinifile;                                              ';
  Script.Add := '    Count: Integer;                                            ';
  Script.Add := '    mnuRpt : TMenuItem;                                        ';
  Script.Add := '    mnuRptItem : TMenuItem; ';
  Script.Add := '    idx    : Integer;                                          ';
  Script.Add := '    idxSubMenu : Integer;';
  Script.Add := '';
  Script.Add := '  function SubMenuCount:Integer; ';
  Script.Add := '  begin';
  Script.Add := '    result := Ini.ReadInteger(IntToStr(idx), ''Count'', 0); ';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  function GetMenuTag:Integer; ';
  Script.Add := '  begin';
  Script.Add := '    if SubMenuCount > 0 then begin';
  Script.Add := '      result := 0;';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      result := idx; ';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := 'begin                                                          ';
  Script.Add := '  ini := CreateIni;                                            ';
  Script.Add := '  try                                                          ';
  Script.Add := '    count := ini.ReadInteger(''Main'', ''Count'', 0);  ';
  Script.Add := '    mnuRpt := CreateMenu(0, Form.AmnuReport, '+
                '      Ini.ReadString(''Main'', ''MenuName'', ''Report''), '+
                '      ini.ReadString(''Main'', ''MenuCaption'', ''Report''), '+
                '      ''ReportClick'');';
  Script.Add := '    for idx:=1 to Count do begin                               ';
  Script.Add := '      mnuRptItem := CreateMenu(idx-1, mnuRpt, '+
                '                       Ini.ReadString(IntToStr(idx), ''MenuName'', ''Report''), '+
                '                       ini.ReadString(IntToStr(idx), ''MenuCaption'', ''Report''), '+
                '                       ''ReportClick'', GetMenuTag);';
  Script.Add := '      if SubMenuCount = 0 then continue;';
  Script.Add := '      for idxSubMenu := 1 to SubMenuCount do begin';
  Script.Add := '        CreateMenu(idxSubMenu-1, mnuRptItem, format(''mnu%d_%d'', [idx, idxSubMenu]), '+
                '          ini.ReadString(IntToStr(idx), format(''MenuCaption%d'', [idxSubMenu]), ''Report''), '+
                '          ''ReportClick'', idx * OFFSET + idxSubMenu);';
  Script.Add := '      end;';
  Script.Add := '    end;                                                       ';
  Script.Add := '  finally                                                      ';
  Script.Add := '    ini.Free;                                                  ';
  Script.Add := '  end;                                                         ';
  Script.Add := 'end;                                                           ';
end;

procedure TInjector.MasterExtended;
begin
  if not Script.IsProcedureExist('function MasterExtended(FieldName:String):TField; ') then begin
    Script.Add := 'begin ';
    Script.Add := '  result := Master.ExtendedID.FieldLookup.FieldByName(FieldName); ';
    Script.Add := 'end; ';
    Script.Add := ' ';
  end;
end;

procedure TInjector.DetailExtended;
begin
  if not Script.IsProcedureExist('function DetailExtended(FieldName:String):TField; ') then begin;
    Script.Add := 'begin ';
    Script.Add := '  result := Detail.ExtendedID.FieldLookup.FieldByName(FieldName); ';
    Script.Add := 'end; ';
    Script.Add := ' ';
  end;
end;

procedure TInjector.DatasetExtended;
begin
  if not Script.IsProcedureExist('function DatasetExtended(FieldName:String):TField; ') then begin
    Script.Add := 'begin ';
    Script.Add := '  result := Dataset.ExtendedID.FieldLookup.FieldByName(FieldName); ';
    Script.Add := 'end; ';
    Script.Add := ' ';
  end;
end;

procedure TInjector.CreateMenu;
begin
  Script.Add := 'function CreateMenu(idx:Integer; mnuParent:TMenuItem; mnuName, Caption:String; MenuOnClick:String; mnuTag:Integer=0):TMenuItem; ';
  Script.Add := 'var com : TComponent;                                                                                       ';
  Script.Add := 'begin                                                                                                       ';
  Script.Add := '  result := nil;                                                                                            ';
  Script.Add := '  com := Form.FindComponent(mnuName);                                                                       ';
  Script.Add := '  if com <> nil then begin                                                                                  ';
  Script.Add := '    com.Free;                                                                                               ';
  Script.Add := '  end;                                                                                                      ';
  Script.Add := '  result := TMenuItem.Create(Form);                                                                         ';
  Script.Add := '  result.Name    := mnuName;                                                                  ';
  Script.Add := '  result.caption := Caption;                                                                                ';
  Script.Add := '  result.Tag     := mnuTag;                                                                                 ';
  Script.Add := '  if MenuOnClick <> '''' then result.OnClick := MenuOnClick;                                                                       ';
  Script.Add := '  if (mnuParent<>nil) then begin';
  Script.Add := '    if idx = -1 then begin ';
  Script.Add := '      mnuParent.Add(result); ';
  Script.Add := '    end ';
  Script.Add := '    else begin ';
  Script.Add := '      mnuParent.Insert(idx, result);                                                                            ';
  Script.Add := '    end; ';
  Script.Add := '  end;';
  Script.Add := 'end;                                                                                                        ';
  Script.Add := EmptyStr;
End;

procedure TInjector.GenerateScriptCheckDept;
begin
  Script.Clear;
  Script.Add := 'procedure BeforePost;';
  Script.Add := 'begin';
  Script.Add := '  if Dataset.DeptID.isNull then begin';
  Script.Add := '    RaiseException(''Mohon Kode Departemen diisi''); ';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  Script.Add := 'begin';
  Script.Add := '  Dataset.OnBeforePostArray := @BeforePost;';
  Script.Add := 'end.';
end;

procedure TInjector.AddProcedureRoundingCR;
begin
  Script.Add := 'Const STR_DISCOUNT_ACC = ''DISCOUNT_ACC'';';
  Script.Add := 'function DISC_ACC:String; ';
  Script.Add := 'var sql:TjbSQL;';
  Script.Add := 'begin ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Detail.Tx));';
  Script.Add := '  try';
  Script.Add := '    RunSQL(sql, format(''Select ValueOpt from Options where ParamOpt=''''%s'''''', [STR_DISCOUNT_ACC]));';
  Script.Add := '    result := sql.FieldByName(''ValueOpt'');';
  Script.Add := '    if result = '''' then begin';
  Script.Add := '      if InputQuery(''Mohon diisi Account untuk pembulatan'', ''No. Account'', result) then begin';
  Script.Add := '        RunSQL(sql, format(''Insert Into Options (ValueOpt, ParamOpt) values (''''%s'''',''''%s'''')'', [result, STR_DISCOUNT_ACC]));';
  Script.Add := '      end';
  Script.Add := '      else RaiseException(''DISCOUNT_ACC belum di-set di tabel OPTIONS'');';
  Script.Add := '    end; ';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  end;';
  Script.Add := 'end; ';
  Script.Add := EmptyStr;
  Script.Add := 'procedure DetailBeforePost; ';
  Script.Add := 'begin';
  Script.Add := '  DISC_ACC;';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  Script.Add := 'procedure AddDiscountInfo(const value:Currency); ';
  Script.Add := 'begin ';
  Script.Add := '  Datamodule.tblARInvPmt.Edit;                                         ';
  Script.Add := '  Datamodule.tblPmtDisc.Append;                                        ';
  Script.Add := '  Datamodule.tblPmtDisc.DiscAccount.value := DISC_ACC;                 ';
  Script.Add := '  Datamodule.tblPmtDisc.Discount.value    := value; ';
  Script.Add := '  Datamodule.tblPmtDisc.Post;                                          ';
  Script.Add := '  DataModule.tblARInvPmt.Post;';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure DetailAfterPost; ';
  Script.Add := '  function desimal:Currency;';
  Script.Add := '  begin';
  Script.Add := '    result := frac(Detail.PaymentAmount.value);';
  Script.Add := '  end; ';
  Script.Add := 'begin';
  Script.Add := '  if (desimal < 1) and (desimal > 0) then begin';
  Script.Add := '    AddDiscountInfo( desimal ); ';
  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  Script.Add := 'procedure CalcField; ';
  Script.Add := 'begin';
  Script.Add := '  Datamodule.tblARInvPmt.strOwing.value := FormatFloat(''#,##0.00'',Datamodule.tblARInvPmt.Owing.value); ';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  Script.Add := 'procedure RoundingClick; ';
  Script.Add := 'var Diff, Tot : Currency; ';
  Script.Add := 'begin ';
  Script.Add := '  Tot := TotalCRDetail; ';
  Script.Add := '  Diff := Tot - Master.ChequeAmount.value;';
  Script.Add := '  if Diff = 0 then exit; ';
  Script.Add := '  ShowMessage(format(''CR Detail=%f, ChequeAmount=%f, Diff=%f'', [Tot, Master.ChequeAmount.value, Diff])); ';
  Script.Add := '  AddDiscountInfo( Diff ); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function AddPopMenuTotalRounding:TMenuItem; ';
  Script.Add := 'begin ';
  Script.Add := '  result := TMenuItem.Create(Form.PopUpMenu1);         ';
  Script.Add := '  result.Caption := ''Auto Rounding'';            ';
  Script.Add := '  result.OnClick := @RoundingClick;            ';
  Script.Add := '  Form.PopUpMenu1.Items.Add( result );                 ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TInjector.AddProcedureAutoSumCR;
begin
  Script.Add := 'var MenuAutoCalc : TMenuItem;                                ';
  Script.Add := '                                                             ';
  Script.Add := 'function TotalCRDetail:Currency; ';
  Script.Add := 'var InvNo:String; ';
  Script.Add := 'begin ';
  Script.Add := '  result := 0;                                                  ';
  Script.Add := '  InvNo := Detail.INVOICENO.value;';
  Script.Add := '  Detail.First;                                              ';
  Script.Add := '  while not Detail.EOF do begin                              ';
  Script.Add := '    if ( not Detail.PaymentAmount.isNull ) then begin        ';
  Script.Add := '      result := result + Detail.PaymentAmount.value; ';
  Script.Add := '    end;                                                     ';
  Script.Add := '    Detail.Next;                                             ';
  Script.Add := '  end;                                                       ';
  Script.Add := '  Detail.Locate( ''InvoiceNo'', InvNo, 0);';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure CalculateClick;                                    ';
  Script.Add := 'begin                                                        ';
  Script.Add := '  Master.ChequeAmount.value := TotalCRDetail; ';
  Script.Add := 'end;                                                         ';
  Script.Add := '                                                             ';
  Script.Add := 'procedure AddPopMenu;                                        ';
  Script.Add := 'begin                                                        ';
  Script.Add := '  MenuAutoCalc := TMenuItem.Create(Form.PopUpMenu1);         ';
  Script.Add := '  MenuAutoCalc.Caption := ''Auto Calculate'';            ';
  Script.Add := '  MenuAutoCalc.OnClick := ''CalculateClick'';            ';
  Script.Add := '  Form.PopUpMenu1.Items.Add( MenuAutoCalc );                 ';
  Script.Add := 'end;                                                         ';
  Script.Add := '                                                             ';
end;

procedure TInjector.GetAuthorization;
begin
  CreateQuery;
  RunQuery;
  CreateLabel;
  CreateEditBox;
  CreateButton;
  Script.Add := 'function InputPassword(const ACaption: string;  var User, Pass: string): Boolean;                                    ';
  Script.Add := 'var                                                                                                                  ';
  Script.Add := '  Form: TForm;                                                                                                       ';
  Script.Add := '  Prompt: TLabel;                                                                                                    ';
  Script.Add := '  UserLabel : TLabel;                                                                                                ';
  Script.Add := '  PassLabel : TLabel;                                                                                                ';
  Script.Add := '  UserEdit  : TEdit;                                                                                                 ';
  Script.Add := '  PassEdit  : TEdit;                                                                                                 ';
  Script.Add := '  ButtonTop, ButtonWidth, ButtonHeight: Integer;                                                                     ';
  Script.Add := '                                                                                                                     ';
  Script.Add := 'begin                                                                                                                ';
  Script.Add := '  Result := False;                                                                                                   ';
  Script.Add := '  Form := TForm.Create(Application);                                                                                 ';
  Script.Add := '                                                                                                                     ';
  Script.Add := '  try                                                                                                                ';
  Script.Add := '    Form.BorderStyle := bsDialog;                                                                                    ';
  Script.Add := '    Form.Caption := ACaption;                                                                                        ';
  Script.Add := '    Form.ClientWidth  := 250;                                                                                        ';
  Script.Add := '    Form.ClientHeight := 170;                                                                                        ';
  Script.Add := '    Form.Position := poScreenCenter;                                                                                 ';
  Script.Add := '	                                                                                                              ';
  Script.Add := '    UserLabel := CreateLabel(10, 10, 70, 20, ''User Name : '', Form);                                                      ';
  Script.Add := '    UserEdit  := CreateEdit(UserLabel.Left + UserLabel.Width + 20, UserLabel.Top, 140, 25, Form);                              ';
  Script.Add := '    PassLabel := CreateLabel(UserLabel.Left, UserLabel.Top + UserLabel.Height + 20, UserLabel.Width, UserLabel.Height, ''Password : '', Form); ';
  Script.Add := '    PassEdit  := CreateEdit(PassLabel.Left + PassLabel.Width + 20, PassLabel.Top, UserEdit.Width, UserEdit.Height, Form);                   ';
  Script.Add := '    PassEdit.PasswordChar  := ''*'';                                                                             ';
  Script.Add := '                                                                                                                     ';
  Script.Add := '    ButtonTop    := PassLabel.Top + PassLabel.Height + 20;                                                           ';
  Script.Add := '    ButtonWidth  := 50;                                                                                              ';
  Script.Add := '    ButtonHeight := 30;                                                                                              ';
  Script.Add := '    with CreateBtn(20, ButtonTop, ButtonWidth, ButtonHeight, 0, ''&OK'', Form) do begin                           ';
  Script.Add := '      ModalResult := mrOk;                                                                                           ';
  Script.Add := '      Default     := True;                                                                                           ';
  Script.Add := '    end;                                                                                                             ';
  Script.Add := '    with CreateBtn(100, ButtonTop, ButtonWidth, ButtonHeight, 0, ''&Batal'', Form) do begin                                                                               ';
  Script.Add := '      ModalResult := mrCancel;                                                                                       ';
  Script.Add := '      Cancel      := True;                                                                                           ';
  Script.Add := '    end;                                                                                                             ';
  Script.Add := '    if Form.ShowModal = mrOk then begin                                                                              ';
  Script.Add := '      User := UserEdit.Text;                                                                                         ';
  Script.Add := '      Pass := PassEdit.Text;                                                                                      ';
  Script.Add := '      Result := True;                                                                                                ';
  Script.Add := '    end;                                                                                                             ';
  Script.Add := '  finally                                                                                                            ';
  Script.Add := '    Form.Free;                                                                                                       ';
  Script.Add := '  end;                                                                                                               ';
  Script.Add := 'end;                                                                                                                 ';
  Script.Add := '                                                                                                                     ';
  Script.Add := 'function Validate(User, Pass:String):Boolean;                                                                        ';
  Script.Add := 'var EncryptedPass:String;                                                                                            ';
  Script.Add := '    sql3 : TIBQuery;                                                                                                 ';
  Script.Add := 'begin                                                                                                                ';
  Script.Add := '  EncryptedPass := EncryptPassword(User, Pass);                                                                      ';
  Script.Add := '  sql3 := CreateQuery(TIBTransaction(Tx));';
  Script.Add := '  try                                                                                                                ';
  Script.Add := '    RunQuery(sql3, ''Select UserLevel, UserPassword from Users u where u.UserName=''''''+ UpperCase(User) + '''''''' );        ';
  Script.Add := '	   result := (sql3.FieldByName(''UserLevel'').asInteger = 0) and (sql3.FieldByName(''UserPassword'').asString = EncryptedPass);';
  Script.Add := '  finally                                                                                                            ';
  Script.Add := '    sql3.Free;                                                                                                       ';
  Script.Add := '  end;                                                                                                               ';
  Script.Add := 'end;                                                                                                                 ';
  Script.Add := '                                                                                                                     ';
  Script.Add := 'procedure GetAuthorization(const Msg:String);';
  Script.Add := 'var userName, Password:String; ';
  Script.Add := 'begin';
  Script.Add := '  if MessageDlg( Msg, mtWarning, mbYes + mbNo, 0)=mrYes then  ';
  Script.Add := '  begin                                                                                                              ';
  Script.Add := '    if InputPassword(''Diisi oleh yang otorisasi'', UserName, Password) then begin                               ';
  Script.Add := '	     if Validate(UserName, Password) then begin                                                                  ';
  Script.Add := '		     ShowMessage(''Otorisasi berhasil, Transaksi akan disimpan'');                                   ';
  Script.Add := '      end                                                                                                            ';
  Script.Add := '	     else begin                                                                                                  ';
  Script.Add := '	       RaiseException(''Otorisasi gagal. Transaksi tidak bisa disimpan!'');                                  ';
  Script.Add := '	     end;                                                                                                        ';
  Script.Add := '	   end                                                                                                           ';
  Script.Add := '	   else begin                                                                                                    ';
  Script.Add := '	     RaiseException(''Transaksi tidak bisa disimpan!'');                                                     ';
  Script.Add := '	   end;                                                                                                          ';
  Script.Add := '  end                                                                                                                ';
  Script.Add := '  else begin                                                                                                         ';
  Script.Add := '    RaiseException(''Transaksi tidak bisa disimpan!'');                                                          ';
  Script.Add := '  end;                                                                                                               ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TInjector.GetDateDialog;
begin
  CreateForm;
  CreatePickDate;
  CreateButton;
  if not Script.IsProcedureExist('function GetDateDialog(DefaultDate:TDateTime; Caption:String; var SelectedDate:TDateTime):Boolean;') then begin
    Script.Add := 'var frm:TForm; ';
    Script.Add := '    editDate : TDateTimePicker; ';
    Script.Add := '    btnOK    : TButton; ';
    Script.Add := '    btnCancel: TButton; ';
    Script.Add := 'begin';
    Script.Add := '  SelectedDate := DefaultDate; ';
    Script.Add := '  frm := CreateForm(''frmSelectDate'', Caption, 200, 100); ';
    Script.Add := '  try';
    Script.Add := '    editDate := CreatePickDate(10, 10, 100, 25, frm); ';
    Script.Add := '    btnOK    := CreateBtn( editDate.Left, editDate.Top + editDate.Height + 20, 80, 30, 0, ''OK'', frm); ';
    Script.Add := '    btnCancel:= CreateBtn( btnOK.Left + btnOK.Width + 20, btnOK.Top, btnOK.Width, btnOK.Height, 0, ''Cancel'', frm); ';
    Script.Add := '    frm.ClientWidth  := btnCancel.Left + btnCancel.Width + 10; ';
    Script.Add := '    frm.ClientHeight := btnOK.Top + btnOK.Height + 10; ';
    Script.Add := '    editDate.Date := DefaultDate; ';
    Script.Add := '    btnOK.ModalResult     := mrOK; ';
    Script.Add := '    btnCancel.ModalResult := mrCancel; ';
    Script.Add := '    result := (frm.ShowModal = mrOK);';
    Script.Add := '    SelectedDate := editDate.Date; ';
    Script.Add := '  finally';
    Script.Add := '    frm.Free; ';
    Script.Add := '  end; ';
    Script.Add := 'end;';
    Script.Add := '';
  end;
end;

procedure TInjector.GetDateRangeDialog;
begin
  CreateForm;
  CreateLabel;
  CreatePickDate;
  CreateButton;
  if not Script.IsProcedureExist('function GetDateRangeDialog(Caption:String; var selectedFromDate:TDateTime; var selectedToDate:TDateTime):Boolean;') then begin
    Script.Add := 'var frm:TForm; ';
    Script.Add := '    fromLbl : TLabel; ';
    Script.Add := '    fromDate : TDateTimePicker; ';
    Script.Add := '    toDate : TDateTimePicker; ';
    Script.Add := '    btnOK : TButton; ';
    Script.Add := '    btnCancel: TButton; ';
    Script.Add := 'begin';
    Script.Add := '  frm := CreateForm(''frmSelectDateRange'', Caption, 200, 100); ';
    Script.Add := '  try';
    Script.Add := '    fromLbl := createLabel(10, 12, 30, 25, ''From'', frm);';
    Script.Add := '    fromDate := CreatePickDate(45, 10, 80, 25, frm); ';
    Script.Add := '    fromDate.Date := selectedFromDate; ';
    Script.Add := '    createLabel(145, 12, 30, 25, ''To'', frm);';
    Script.Add := '    toDate := CreatePickDate(180, 10, 80, 25, frm); ';
    Script.Add := '    toDate.Date := selectedToDate; ';
    Script.Add := '    btnOK := CreateBtn( fromLbl.Left, fromDate.Top + fromDate.Height + 20, 110, 30, 0, ''OK'', frm); ';
    Script.Add := '    btnCancel:= CreateBtn( btnOK.Left + btnOK.Width + 20, btnOK.Top, btnOK.Width, btnOK.Height, 0, ''Cancel'', frm); ';
    Script.Add := '    frm.ClientWidth  := btnCancel.Left + btnCancel.Width + 10; ';
    Script.Add := '    frm.ClientHeight := btnOK.Top + btnOK.Height + 10; ';
    Script.Add := '    btnOK.ModalResult := mrOK; ';
    Script.Add := '    btnCancel.ModalResult := mrCancel; ';
    Script.Add := '    if (frm.ShowModal = mrOK) then begin';
    Script.Add := '      selectedFromDate := fromDate.Date; ';
    Script.Add := '      selectedToDate := toDate.Date; ';
    Script.Add := '      result := true; ';
    Script.Add := '    end ';
    Script.Add := '    else begin ';
    Script.Add := '      result := false; ';
    Script.Add := '    end; ';
    Script.Add := '  finally';
    Script.Add := '    frm.Free; ';
    Script.Add := '  end; ';
    Script.Add := 'end;';
    Script.Add := '';
  end;
end;

procedure TInjector.getOptionDistro;
begin
  Script.Add := 'function getOptionDistro(const UOMCode :Integer):String; ';
  Script.Add := 'var Option : TOptionsAccess; ';
  Script.Add := 'begin ';
  Script.Add := '  Option := TOptionsAccess.Create( TIBDatabase(DB), TIBTransaction(Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    case UOMCode of ';
  Script.Add := '      1 : result := Option.UOM_QTY1; ';
  Script.Add := '      2 : result := Option.UOM_QTY2; ';
  Script.Add := '      3 : result := Option.UOM_QTY3; ';
  Script.Add := '      4 : result := Option.UOM_UP1; ';
  Script.Add := '      5 : result := Option.UOM_UP2; ';
  Script.Add := '      6 : result := Option.UOM_UP3; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    Option.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
end;

procedure TInjector.setOptionsDistro;
begin
  Script.Add := 'procedure setOptionsDistro(var UOM_QTY1, UOM_QTY2, UOM_QTY3, UOM_UP1, UOM_UP2, UOM_UP3:String); ';
  Script.Add := 'var Option : TOptionsAccess; ';
  Script.Add := 'begin ';
  Script.Add := '  Option := TOptionsAccess.Create( TIBDatabase(DB), TIBTransaction(Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    UOM_QTY1 := Option.UOM_QTY1; ';
  Script.Add := '    UOM_QTY2 := Option.UOM_QTY2; ';
  Script.Add := '    UOM_QTY3 := Option.UOM_QTY3; ';
  Script.Add := '    UOM_UP1  := Option.UOM_UP1; ';
  Script.Add := '    UOM_UP2  := Option.UOM_UP2; ';
  Script.Add := '    UOM_UP3  := Option.UOM_UP3; ';
  Script.Add := '  finally ';
  Script.Add := '    Option.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
end;

procedure TInjector.GetUserLevel(FieldName:String; Level:Integer);
begin
  Script.Add := format('function Is%s:Boolean;', [FieldName]);
  Script.Add := 'var sql1 : TjbSQL;          ';
  Script.Add := 'begin ';
  Script.Add := '  sql1 := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sql1, format(''select u.UserLevel from users u where u.userid=%d'', [UserID]));';
  Script.Add := format('    result := (sql1.FieldByName(''UserLevel'') <= %d); ', [Level]);
  Script.Add := '  finally ';
  Script.Add := '    sql1.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := EmptyStr;
end;

procedure TInjector.IsAdmin;
begin
  GetUserLevel('Admin', 0);
end;

procedure TInjector.IsFullNameUser;
begin
  Script.Add := EmptyStr;
  if not Script.IsProcedureExist('function IsFullNameUser (FullName : string; ActiveUserID : Integer = -1) : Boolean;') then begin
    Script.Add := 'var';
    Script.Add := '  ProfileSQL : TjbSQL;';
    Script.Add := '  UserQuery  : string;';
    Script.Add := 'begin';
    Script.Add := '  ProfileSQL := CreateSQL (TIBTransaction (Tx) );';
    Script.Add := '  try';
    Script.Add := '    UserQuery := Format(''SELECT FULLNAME FROM USERS '+
                                    'WHERE UPPER(FULLNAME) CONTAINING ''''%s'''' '', [FullName]);';
    Script.Add := '    if (ActiveUserID > -1) then begin';
    Script.Add := '      UserQuery := UserQuery + Format(''AND USERID = %d '', [ActiveUserID]);';
    Script.Add := '    end;';
    Script.Add := '    RunSQL (ProfileSQL, UserQuery);';
    Script.Add := '    Result := NOT ProfileSQL.EOF;';
    Script.Add := '  finally';
    Script.Add := '    ProfileSQL.Free;';
    Script.Add := '  end;';
    Script.Add := 'end;';
  end;
end;

procedure TInjector.IsNumber;
begin
  Script.Add := 'function IsNumber(const S: string): Boolean;  ';
  Script.Add := 'begin   ';
  Script.Add := '  Result := True;  ';
  Script.Add := '  try  ';
  Script.Add := '    StrToInt(S); ';
  Script.Add := '  except  ';
  Script.Add := '    Result := False; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
end;

procedure TInjector.IsSupervisor;
begin
  GetUserLevel('Supervisor', 1);
end;

Procedure TInjector.is_distro_variant;
begin
  Script.Add := 'function is_distribution_variant:boolean;';
  Script.Add := 'begin';
  Script.Add := '   result := ( ProductType=6 );';
  Script.Add := 'end;';
  Script.Add := '';
end;

function TInjector.is_doing_remote_injection: boolean;
begin
  result := Assigned(Fremote_injection_ds);
end;

procedure TInjector.CreateMemo;
begin
  Script.Add := 'function CreateMemo(L, T, W, H : Integer; AParent : TWinControl) : TDBMemo; ';
  Script.Add := 'begin                                                                       ';
  Script.Add := '   result := TDBMemo.Create(AParent);                                       ';
  Script.Add := '   result.Parent := AParent;                                                ';
  Script.Add := '   result.SetBounds(L, T, W, H);                                            ';
  Script.Add := 'end;                                                                        ';
  Script.Add := '                                                                            ';
end;

procedure TInjector.CallFinaAttachment;
begin
  Script.Add := 'procedure CallFINAAttachment(TxNo, TxGUID, TxType:String);';
  Script.Add := 'var ini:TInifile;';
  Script.Add := '    exe : String; ';
  Script.Add := 'begin';
  Script.Add := '  ini := TInifile.Create( ExtractFilePath(Application.ExeName) + ''Attachment.ini'' );';
  Script.Add := '  try';
  Script.Add := '    exe := ini.ReadString(''Main'', ''ExeName'', ''c:\FinaAttachment.exe''); ';
  Script.Add := '    if not FileExists(exe) then RaiseException(''FinaAttachment.exe tidak ditemukan''); ';
//  Script.Add := '    ShellExecute(exe, format(''%s %s %s'', [TxNo, TxGUID, TxType]), '''' ); ';
  Script.Add := '    ShellExecute(exe, format(''"%s" "%s" "%s"'', [TxNo, TxGUID, TxType]), '''' ); '; // AA, BZ 2997
  Script.Add := '  finally';
  Script.Add := '    ini.free; ';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := 'procedure FetchFINAAttachment(TxNo, TxDate, TxGUID, TxType, FetchPath: string; Mode: string = ''FETCH'');';  //SCY BZ 3776
  Script.Add := 'var ini:TInifile;';
  Script.Add := '    exe : String; ';
  Script.Add := 'begin';
  Script.Add := '  ini := TInifile.Create( ExtractFilePath(Application.ExeName) + ''Attachment.ini'' );';
  Script.Add := '  try';
  Script.Add := '    exe := ini.ReadString(''Main'', ''ExeName'', ''c:\FinaAttachment.exe''); ';
  Script.Add := '    if not FileExists(exe) then RaiseException(''FinaAttachment.exe tidak ditemukan''); ';
  Script.Add := '    ShellExecute(exe, ''"'' + Mode + ''" "'' + TxNo + ''" "'' + TxDate + ''" "'' '+
                       '+ TxGUID + ''" "'' + TxType + ''" "'' + FetchPath + ''"'', '''');';
  Script.Add := '  finally';
  Script.Add := '    ini.free; ';
  Script.Add := '  end;';
  Script.Add := 'end;';
end;

procedure TInjector.Ceil;
begin
  Script.Add := EmptyStr;
  if not Script.IsProcedureExist('function Ceil(X : Currency) : Integer;') then begin
  Script.Add := 'begin';
  Script.Add := '  Result := Trunc (X);';
  Script.Add := '  if Frac(X) > 0 then begin';
  Script.Add := '    Inc (Result);';
  Script.Add := '  end;';
  Script.Add := 'end;';
  end;
end;

procedure TInjector.CheckCreditLimit(AmountField, TblName, IDField, DateField: String; Tax1AmountField:String; Tax2AmountField:String);
begin
  Script.Add := 'var sql:TjbSQL; ';
  Script.Add := '';
  Script.Add := 'function GetAmount(sqlScript:String):Currency; ';
  Script.Add := 'begin ';
  Script.Add := '  result := 0; ';
  Script.Add := '  RunSQL(sql, sqlScript); ';
  Script.Add := '  if sql.RecordCount=0 then exit; ';
  Script.Add := '  if sql.FieldByName(''Amount'') = null then exit; ';
  Script.Add := '  result := sql.FieldByName(''Amount''); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function ExistingCredit:Currency; ';
  Script.Add := 'begin ';
  Script.Add := '  result := 0;';
  Script.Add := '  if Master.CustomerID.IsNull then exit; ';
  if ( Tax1AmountField<>'' ) then begin
    Script.Add := Format( '  result := GetAmount(format(''select coalesce(Sum(s.InvAmount + s.%s + s.%s), 0) Amount from SO s ', [Tax1AmountField, Tax2AmountField] ) + // AA, BZ 2199
      'where s.CustomerID=%d and s.Proceed<>1 and s.Closed<>1'', [ Master.CustomerID.value ])); ';
  end
  else begin
    Script.Add := '  result := GetAmount(format(''select coalesce(Sum(s.InvAmount), 0) Amount from SO s '+
      'where s.CustomerID=%d and s.Proceed<>1 and s.Closed<>1'', [ Master.CustomerID.value ])); ';
  end;
  Script.Add := '  Result := result + GetAmount(format( ''Select coalesce(Amount, 0) Amount from Get_PersonBalance (%d, ''''%s'''', ''''%s'''')'', '+
    format('[ Master.CustomerID.value, DateToStrSQL( Master.%s.value ), DateToStrSQL( Master.%s.value ) ] )); ', [DateField, DateField]);
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function CreditLimit:Currency; ';
  Script.Add := 'begin ';
  Script.Add := '  result := 0;';
  Script.Add := '  if Master.CustomerID.IsNull then exit; ';
  Script.Add := '  Result := GetAmount( format(''Select coalesce(c.CreditLimit, 0) Amount from PersonData c where c.ID=%d'', [Master.CustomerID.value])); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure DoCheckCreditLimit; ';
  Script.Add := '  function NewAmount:Currency; ';
  Script.Add := '  begin';
  if ( Tax1AmountField<>'' ) then begin
    Script.Add := format('    result := Master.%s.value + Master.%s.value + Master.%s.value; ', [AmountField, Tax1AmountField, Tax2AmountField]); // AA, BZ 2199
  end
  else begin
    Script.Add := format('    result := Master.%s.value; ', [AmountField]);
  end;
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := '  function OldAmount:Currency; ';
  Script.Add := '  begin';
  if ( Tax1AmountField<>'' ) then begin
    Script.Add := format('    result := GetAmount(''Select coalesce((s.%s+s.%s+s.%s), 0) Amount from %s s where s.%s='' + ', [AmountField, Tax1AmountField, Tax2AmountField, TblName, IDField]) // AA, BZ 2199
                  + ' format(''%d'',' + format(' [Master.%s.value])); ', [IDField]);
  end
  else begin
    Script.Add := format('    result := GetAmount(''Select coalesce(s.%s, 0) Amount from %s s where s.%s='' + ', [AmountField, TblName, IDField])
                  + ' format(''%d'',' + format(' [Master.%s.value])); ', [IDField]);
  end;
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := '  if Master.IsFirstPost then exit; ';
  if TblName= 'ARInv' then begin
    Script.Add := '  if Master.GetFromSO.value = 1 then exit; ';
    Script.Add := '  if Master.GetFromDO.value = 1 then exit; ';
  end;
  Script.Add := '  if Master.ExtendedID.FieldLookup.FieldByName(NEED_APPROVAL_FIELD).AsString = ''1'' then exit;   ';
  Script.Add := '  sql := CreateSQL(Master.Tx); ';
  Script.Add := '  try ';
  Script.Add := '    if CreditLimit = 0 then Exit;';
  Script.Add := '    if (NewAmount - OldAmount + ExistingCredit) > CreditLimit then RaiseException(''Credit limit telah terlewati''); ';
  Script.Add := '  finally';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TInjector.CheckFTPAvalibilityLine;
begin
  if not Script.IsProcedureExist('procedure CheckFTPAvalibilityLine (userName, password,host : String; port : Integer = 21;);') then begin
    Script.Add := '  var';
    Script.Add := '    LocalIDFTP : TIdFTP;';
    Script.Add := '  begin';
    Script.Add := '    LocalIDFTP := TIdFTP.Create (nil);';
    Script.Add := '    try';
    Script.Add := '      LocalIDFTP.UserName := userName;';
    Script.Add := '      LocalIDFTP.Password := password;';
    Script.Add := '      LocalIDFTP.Host     := host;';
    Script.Add := '      LocalIDFTP.Port     := port;';
    Script.Add := '      LocalIDFTP.Passive  := True;';
    Script.Add := '      try';
    Script.Add := '        LocalIDFTP.Connect;';
    Script.Add := '        LocalIDFTP.Quit;';
    Script.Add := '      except';
    Script.Add := '        if (LocalIDFTP.GetCode = 0) then begin;';
    Script.Add := '          RaiseException (''Please make sure FTP Server is ready and check your FTP configurations.'');';
    Script.Add := '        end;';
    Script.Add := '      end;';
    Script.Add := '    finally';
    Script.Add := '      if (LocalIDFTP <> nil) then begin';
    Script.Add := '        TObject (LocalIDFTP).Free;';
    Script.Add := '        LocalIDFTP := nil;';
    Script.Add := '      end;';
    Script.Add := '    end;';
    Script.Add := '  end;';
  end;
end;

procedure TInjector.CreateListView;
begin
  if not Script.IsProcedureExist('function CreateListView(Parent:TWinControl; L, T, W, H:Integer; Checkbox:Boolean=true):TListView;') then begin
    Script.Add := 'begin';
    Script.Add := '  result := TListView.Create(Parent);';
    Script.Add := '  result.Parent     := Parent;           ';
    Script.Add := '  result.ViewStyle  := vsList;        ';
    Script.Add := '  result.CheckBoxes := Checkbox; ';
    Script.Add := '  result.SetBounds(L, T, W, H);';
    Script.Add := 'end;';
    Script.Add := EmptyStr;
    Script.Add := 'function CreateListViewCol(List:TListView; ACaption:String; AWidth:Integer):TListColumn;';
    Script.Add := 'begin';
    Script.Add := '  result := list.Columns.Add;';
    Script.Add := '  result.Caption := ACaption;';
    Script.Add := '  result.Width   := AWidth;  ';
    Script.Add := 'end;';
    Script.Add := EmptyStr;
    Script.Add := 'function CountCheck(List:TListView):Integer;';
    Script.Add := 'var i:Integer;';
    Script.Add := 'begin';
    Script.Add := '  result := 0;';
    Script.Add := '  for i:=0 to List.Items.Count-1 do begin';
    Script.Add := '    if List.Items[i].Checked then begin';
    Script.Add := '      Inc(result);';
    Script.Add := '    end;';
    Script.Add := '  end;';
    Script.Add := 'end;';
    Script.Add := EmptyStr;
    Script.Add := 'function CountSelected(List:TListView):Integer; ';
    Script.Add := 'var idx:Integer; ';
    Script.Add := 'begin ';
    Script.Add := '  result := 0; ';
    Script.Add := '  for idx:=0 to List.Items.Count-1 do begin ';
    Script.Add := '    if List.Items[Idx].Selected then inc(result); ';
    Script.Add := '  end; ';
    Script.Add := 'end; ';
    Script.Add := EmptyStr;
    Script.Add := 'function CheckedIndex(List:TListView):Integer;';
    Script.Add := 'var i:Integer;';
    Script.Add := 'begin';
    Script.Add := '  result := 0;';
    Script.Add := '  for i:=0 to List.Items.Count-1 do begin';
    Script.Add := '    if List.Items[i].Checked then begin';
    Script.Add := '      result := i;';
    Script.Add := '      break;';
    Script.Add := '    end;';
    Script.Add := '  end;';
    Script.Add := 'end;';
    Script.Add := EmptyStr;
    Script.Add := 'function DescSelected(List:TListView; lvDesc:Integer=0):String;';
    Script.Add := 'var i:Integer;';
    Script.Add := 'begin';
    Script.Add := '  result := '''';';
    Script.Add := '  for i:=0 to List.Items.Count-1 do begin';
    Script.Add := '    if List.Items[i].Selected then begin';
    Script.Add := '      result := List.Items[i].SubItems[lvDesc];';
    Script.Add := '      break;';
    Script.Add := '    end;';
    Script.Add := '  end;';
    Script.Add := 'end;';
    Script.Add := EmptyStr;
  end;
end;

procedure TInjector.CreateRadioButton;
begin
  Script.Add := 'function CreateRadioButton(L, T, W, H : Integer; Cap : String; AParent : TWinControl): TRadioButton;';
  Script.Add := 'begin                                                                                               ';
  Script.Add := '  result := TRadioButton.Create(AParent);                                                           ';
  Script.Add := '  result.Parent := AParent;                                                                         ';
  Script.Add := '  result.SetBounds(L, T, W, H);                                                                     ';
  Script.Add := '  result.Caption := Cap;                                                                            ';
  Script.Add := 'end;                                                                                                ';
  Script.Add := '                                                                                                    ';
end;

procedure TInjector.CreateComboBox;
begin
  if not Script.IsProcedureExist('function CreateComboBox(L,T,W,H:Integer; AStyle:TComboBoxStyle; AParent:TWinControl):TComboBox;') then begin
    Script.Add := 'begin ';
    Script.Add := '  result := TComboBox.Create(AParent);';
    Script.Add := '  result.Parent := AParent; ';
    Script.Add := '  result.SetBounds(L, T, W, H); ';
    Script.Add := '  result.Style := AStyle; ';
    Script.Add := 'end; ';
    Script.Add := '';
  end;
end;

procedure TInjector.ReadOption;
begin
  CreateTx;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  if not Script.IsProcedureExist('function ReadOption(Param:String; DefaultValue:String=''''):String;') then begin
    Script.Add := 'var sql:TjbSQL; ';
    Script.Add := '    jTx : TIBTransaction;         ';
    Script.Add := 'begin ';
    Script.Add := '  result := ''''; ';
    Script.Add := '  jTx := CreateATx;                ';
    Script.Add := '  sql := CreateSQL(jTx); ';
    Script.Add := '  try ';
    Script.Add := '    RunSQL(sql, ''Select ValueOpt from Options Where ParamOpt=:Param'', false); ';
    Script.Add := '    sql.SetParam(0, Param); ';
    Script.Add := '    sql.ExecQuery; ';
    Script.Add := '    if (sql.RecordCount > 0) then begin ';
    Script.Add := '      if (sql.FieldByName(''ValueOpt'') <> null) then result := sql.FieldByName(''ValueOpt''); ';
    Script.Add := '    end';
    Script.Add := '    else if DefaultValue <> '''' then begin';
    Script.Add := '      RunSQL(sql, format(''Insert into Options (ParamOpt, ValueOpt) values (''''%s'''', ''''%s'''')'', [Param, DefaultValue])); ';
    Script.Add := '      jTx.Commit; '; // AA, only commit when neccessary
    Script.Add := '      result := DefaultValue; ';
    Script.Add := '    end; ';
    Script.Add := '  finally';
//    Script.Add := '    jTx.Commit; ';
    Script.Add := '    sql.Free; ';
    Script.Add := '    jTx.Free; ';
    Script.Add := '  end; ';
    Script.Add := 'end; ';
    Script.Add := '';
  end;
end;

procedure TInjector.remove_menu;
begin
  Script.Add := 'procedure remove_menu(menu_name:string);';
  Script.Add := 'var';
  Script.Add := '  deleted_menu : TMenuItem;';
  Script.Add := 'begin';
  Script.Add := '  deleted_menu := TMenuItem(Form.FindComponent( menu_name ));';
  Script.Add := '  if deleted_menu <> nil then begin';
  Script.Add := '    deleted_menu.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TInjector.WriteOption;
begin
  CreateTx;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  if not Script.IsProcedureExist('function WriteOption(Param:String; Value:String):String;') then begin
    Script.Add := 'var sql:TjbSQL; ';
    Script.Add := '    jTx : TIBTransaction;         ';
    Script.Add := 'Begin ';
    Script.Add := '  jTx := CreateATx;                ';
    Script.Add := '  sql := CreateSQL(jTx); ';
    Script.Add := '  try ';
//    Script.Add := '    RunSQL(sql, ''Select ValueOpt from Options Where ParamOpt=:Param'', false); ';
//    Script.Add := '    sql.SetParam(0, Param); ';
//    Script.Add := '    sql.ExecQuery; ';
//    Script.Add := '    if (sql.RecordCount > 0) then begin ';
//    Script.Add := '      RunSQL(sql, format(''Update Options set ValueOpt=''''%s'''' where ParamOpt=''''%s'''''', [Value, Param])); ';
//    Script.Add := '    end';
//    Script.Add := '    else begin';
//    Script.Add := '      RunSQL(sql, format(''Insert into Options (ParamOpt, ValueOpt) values (''''%s'''', ''''%s'''')'', [Param, Value])); ';
//    Script.Add := '    end; ';
    // AA, reduce sql call to database
    Script.add := '    RunSQL(sql, format(''UPDATE or INSERT INTO Options(ParamOpt, ValueOpt) Values(''''%s'''', ''''%s'''')'', [Param, Value]));';
    Script.Add := '  finally';
    Script.Add := '    jTx.Commit; ';
    Script.Add := '    sql.Free; ';
    Script.Add := '    jTx.Free; ';
    Script.Add := '  end; ';
    Script.Add := 'End; ';
    Script.Add := '';
  end;
end;

procedure TInjector.WriteToIniFile;
begin
  if not Script.IsProcedureExist('procedure WriteToIniFile(Content:String; FileName:String=''reportSQL.ini'');') then begin
    Script.Add := 'var ini : TIniFile; ';
    Script.Add := 'begin ';
    Script.Add := '  ini := TInifile.Create( ExtractFilePath(Application.ExeName ) + FileName); ';
    Script.Add := '  try ';
    Script.Add := '    ini.WriteString( ''sql'', ''value'', content ); ';
    Script.Add := '  finally ';
    Script.Add := '    ini.Free; ';
    Script.Add := '  end; ';
    Script.Add := 'end; ';
  end;
end;

procedure TInjector.RightStr;
begin
  if not Script.IsProcedureExist('Function RightStr(TextStr:String; Len:Integer):String;') then begin
    Script.Add := 'Var ';
    Script.Add := '  Index     : Integer; ';
    Script.Add := '  ReturnStr : String; ';
    Script.Add := '  TextTemp  : String; ';
    Script.Add := '  LenText   : Integer; ';
    Script.Add := 'Begin ';
    Script.Add := '  ReturnStr := ''''; ';
    Script.Add := '  TextTemp  := TextStr; ';
    Script.Add := '  LenText   := Length(TextTemp); ';
    Script.Add := '  For Index := LenText DownTo LenText - Len + 1 Do Begin ';
    Script.Add := '    ReturnStr := TextTemp[Index] + ReturnStr; ';
    Script.Add := '  End; ';
    Script.Add := '  Result := ReturnStr; ';
    Script.Add := 'End; ';
    Script.Add := '';
  end;
end;

procedure TInjector.LeftPos;
begin
  if not Script.IsProcedureExist('function LeftPos(obj: TControl; Spacing:Integer = 5):Integer;') then begin
    Script.Add := 'begin ';
    Script.Add := '  result := obj.Left + obj.Width + Spacing; ';
    Script.Add := 'end; ';
    Script.Add := '';
  end;
end;

procedure TInjector.LeftStr;
begin
  if not Script.IsProcedureExist('Function LeftStr(TextStr:String; Len:Integer):String;') then begin
    Script.Add := 'Var ';
    Script.Add := '  Index     : Integer; ';
    Script.Add := '  ReturnStr : String; ';
    Script.Add := '  TextTemp  : String; ';
    Script.Add := 'Begin ';
    Script.Add := '  ReturnStr := ''''; ';
    Script.Add := '  TextTemp  := TextStr; ';
    Script.Add := '  For Index := 1 To Len Do Begin ';
    Script.Add := '    ReturnStr := ReturnStr + TextTemp[Index]; ';
    Script.Add := '  End; ';
    Script.Add := '  Result := ReturnStr; ';
    Script.Add := 'End; ';
    Script.Add := '';
  end;
end;

procedure TInjector.CreateProgressBar;
begin
  if not Script.IsProcedureExist('function CreateProgressBar(L, T, W, H:Integer; ATag:Integer; '+
    'AParent:TWinControl):TProgressBar;') then begin
    Script.Add := 'begin ';
    Script.Add := '  result := TProgressBar.Create(AParent); ';
    Script.Add := '  result.Parent := AParent; ';
    Script.Add := '  result.SetBounds(L, T, W, H); ';
    Script.Add := 'end;';
    Script.Add := '';
  end;
end;

procedure TInjector.CreateForm;
begin
  if not Script.IsProcedureExist('function CreateForm(FormName, FormCaption:String; W, H:Integer; Pos:Integer=6):TForm;') then begin
    Script.Add := 'begin ';
    Script.Add := '  result := TForm.Create(nil); ';
    Script.Add := '  result.Name     := FormName; ';
    Script.Add := '  result.Width    := W;          ';
    Script.Add := '  result.Height   := H;          ';
    Script.Add := '  result.Position := Pos;        ';
    Script.Add := '  result.Caption  := FormCaption;';
    Script.Add := 'end; ';
    Script.Add := '';
  end;
end;

procedure TInjector.CreateCurrencyEdit;
begin
  if not Script.IsProcedureExist('function CreatejvCurrencyEdit(L, T, W, H:Integer; AParent:TWinControl; FormatCurr:String):TJvxCurrencyEdit;') then begin
    Script.Add := 'Begin ';
    Script.Add := '  Result := TJvxCurrencyEdit.Create(AParent); ';
    Script.Add := '  Result.Parent := AParent; ';
    Script.Add := '  Result.SetBounds(L, T, W, H); ';
    Script.Add := '  result.DisplayFormat := FormatCurr; ';
    Script.Add := 'End; ';
  end;
end;

Procedure Tinjector.CreateCustomMenuSetting;
Begin
  if not Script.IsProcedureExist('procedure AddCustomMenuSetting(MnuName, mnuCaption, mnuOnClick:String);') then begin
    Script.Add := 'var mnuSetting : TMenuItem; ';
    Script.Add := 'begin ';
    Script.Add := '  mnuSetting := TMenuItem(Form.FindComponent( MnuName )); ';
    Script.Add := '  if mnuSetting <> nil then mnuSetting.Free; ';
    Script.Add := '  mnuSetting := TMenuItem.Create( Form );';
    Script.Add := '  mnuSetting.Name    := MnuName;';
    Script.Add := '  mnuSetting.Caption := mnuCaption;';
    Script.Add := '  mnuSetting.OnClick := mnuOnClick;';
    Script.Add := '  mnuSetting.Visible := True;';
    Script.Add := '  Form.AmnuEdit.Add( mnuSetting );';
    Script.Add := 'end; ';
    Script.Add := '';
  end;
End;

procedure TInjector.CreateDBCheckBox;
begin
  if not Script.IsProcedureExist('function CreateDBCheckBox(L, T, W, H : Integer; Cap: String; AParent : TWinControl):TJbDBCheckBox;') then begin
    Script.Add := 'begin                                                                               ';
    Script.Add := '  result := TJbDBCheckBox.Create(AParent);                                              ';
    Script.Add := '  result.Parent := AParent;                                                         ';
    Script.Add := '  result.SetBounds(L, T, W, H);                                                     ';
    Script.Add := '  result.Caption := Cap;                                                            ';
    Script.Add := 'end;                                                                                ';
    Script.Add := EmptyStr;
  end;
end;

procedure TInjector.CreateFormSetting;
begin
  //ListType dapat diisi dengan:
  //  CUSTOMFIELD
  //  LOOKUP
  //  ITEMRESERVED
  //  TEMPLATE_X (X = TemplateType)
  //  WAREHOUSE
  //  ACCOUNT_X (X = Account type. Bila ada lebih dari 1, pisahkan dengan tanda minus. Mis: ACCOUNT_7-8)
  //  TEXT
  //  INFO
  //  CHECKBOX
  //  CUSTOMER
  //  EXTENDEDTYPE_TYPENAME (TYPENAME diisi dgn nama Extended Type)
  add_procedure_runsql;
  AddFunction_CreateSQL;
  CreateTx;
  ReadOption;
  WriteOption;
  CreateForm;
  CreateLabel;
  CreateCombobox;
  CreateButton;
  CreateCheckBox;
  Script.Add := 'var ScrollBox : TScrollBox; ';
  Script.Add := 'procedure FillCombo(combo:TComboBox; ListType:String); ';
  Script.Add := '  procedure AddComboList(Count:Integer);';
  Script.Add := '  var idx:Integer; ';
  Script.Add := '  begin ';
  Script.Add := '    combo.Items.Clear; ';
  Script.Add := '    for idx:=1 to Count do begin ';
  Script.Add := '      combo.Items.Add( ListType + IntToStr(idx) ); ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := '  procedure LoadFromDatabase(Query, FieldName:String); ';
  Script.Add := '  var sql:TjbSQL; ';
  Script.Add := '  begin ';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '    try ';
  Script.Add := '      RunSQL(sql, Query); ';
  Script.Add := '      combo.Items.Clear; ';
  Script.Add := '      while not sql.EOF do begin ';
  Script.Add := '        combo.Items.Add( sql.FieldByName(FieldName) ); ';
  Script.Add := '        sql.Next; ';
  Script.Add := '      end; ';
  Script.Add := '    finally ';
  Script.Add := '      sql.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := '  procedure AddWarehouse; ';
  Script.Add := '  begin ';
  Script.Add := '    LoadFromDatabase(''Select w.Name WarehouseName from Warehs w order by w.Name'', ''WarehouseName''); ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := '  procedure AddCUSTOMER;';
  Script.Add := '  begin';
  Script.Add := '    LoadFromDatabase(''Select c.Name CustomerName from Persondata c where c.PersonType = 0 and c.Suspended=0 '+
    'order by c.Name'', ''CustomerName''); ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := '  procedure AddTemplate(TemplateType:String);';
  Script.Add := '  begin ';
  Script.Add := '    LoadFromDatabase(format(''Select t.Name TemplateName from Template t Where t.TemplateType = %s order by t.TemplateID'', '+
    '[TemplateType]), ''TemplateName''); ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := '  procedure AddAccount(AccType:String); ';
  Script.Add := '  var StrAccType : String; ';
  Script.Add := '  begin ';
  Script.Add := '    StrAccType := AccType; ';
  Script.Add := '    While Pos(''-'', StrAccType) > 0 do StrAccType := ReplaceStr(StrAccType, ''-'', '',''); ';
  Script.Add := '    LoadFromDatabase(format(''Select g.GLAccount from GLAccnt g where g.AccountType in (%s) order by g.GLAccount'', [StrAccType]), '+
    '''GLAccount'');';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  procedure AddExtendedType( TypeName:String ); ';
  Script.Add := '  begin';
  Script.Add := '    LoadFromDatabase(format(''Select ed.Info1 Kelurahan from ExtendedDet ed '+
    'Join ExtendedType et on et.ExtendedTypeID=ed.ExtendedTypeID Where Upper(et.ExtendedName) = ''''%s'''' order by 1'', '+
    '[UpperCase(TypeName)]), ''Kelurahan''); ';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  procedure AddWorkCenter;';
  Script.Add := '  begin';
  Script.Add := '    LoadFromDatabase(''Select wc.WorkCenterName from WorkCenter wc order by wc.ID'', ''WorkCenterName'');';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := '  if (ListType = ''CUSTOMFIELD'') or (ListType=''LOOKUP'') or (ListType=''INFO'') then AddComboList(20); ';
  Script.Add := '  if (ListType = ''ITEMRESERVED'') or (ListType = ''RESERVED'') then AddComboList(10);';
  Script.Add := '  if ListType = ''WAREHOUSE''    then AddWarehouse; ';
  Script.Add := '  if Pos(''TEMPLATE'', ListType) > 0 then AddTemplate( GetToken(ListType, ''_'', 2) ); ';
  Script.Add := '  if Pos(''ACCOUNT'', ListType) > 0 then AddACCOUNT( GetToken(ListType, ''_'', 2) ); ';
  Script.Add := '  if Pos(''CUSTOMER'', ListType) > 0 then AddCUSTOMER; ';
  Script.Add := '  if Pos(''EXTENDEDTYPE'', ListType) > 0 then AddExtendedType( GetToken(ListType, ''_'', 2) );';
  Script.Add := '  if ListType = ''WORKCENTER'' then AddWorkCenter;';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'const idxCtlName      = 1; ';
  Script.Add := '      idxParam        = 2; ';
  Script.Add := '      idxIsLookup     = 3; ';
  Script.Add := '      idxValueField   = 4; ';
  Script.Add := '      idxDisplayField = 5; ';
  Script.Add := '      idxTableLookup  = 6; ';
  Script.Add := '      StrFalse        = ''0'';';
  Script.Add := '      StrTrue         = ''1'';';
  Script.Add := '      StrCheckBox     = ''CheckBox'';';
  Script.Add := 'var ListCtrl : TStringList; ';
  Script.Add := '';
  Script.Add := 'function GetValue(ParamName, DefaultValue, IsLookup, LookupValue:String):String; ';
  Script.Add := 'var Hasil:String; ';
  Script.Add := '    sql:TjbSQL; ';
  Script.Add := 'begin ';
  Script.Add := '  Hasil := ReadOption(ParamName, DefaultValue);';
  Script.Add := '  if IsLookup = ''0'' then begin ';
  Script.Add := '    result := Hasil; ';
  Script.Add := '  end';
  Script.Add := '  else begin ';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '    try ';
  Script.Add := '      if Hasil = '''' then Hasil := ''-1''; ';
  Script.Add := '      try ';
  Script.Add := '        RunSQL( sql, format(''Select t.%s from %s t where t.%s=%s'', '+
    '[GetToken(LookupValue, '';'', 2), GetToken(LookupValue, '';'', 3), GetToken(LookupValue, '';'', 1), Hasil])); ';
  Script.Add := '        if sql.RecordCount > 0 then begin ';
  Script.Add := '          result := sql.FieldByName( GetToken(LookupValue, '';'', 2) ); ';
  Script.Add := '        end ';
  Script.Add := '        else result := '' ''; ';
  Script.add := '      except';
  Script.add := '      end;';
  Script.Add := '    finally ';
  Script.Add := '      sql.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure AddControl(frm:TForm; Caption, ListType, ParamName, DefaultValue, IsLookup, LookupValue:String; IsAutoSize:Boolean=False); ';
  {IsLookup diisi dengan 0 atau 1. 0= Nilai yang disimpan yang akan ditampilkan. 1=Nilai yang ditampilkan beda dgn yg disimpan
   LookupValue perlu diisi bila IsLookup = 1. Isinya adalah: ValueField;DisplayField;TableLookup}
  Script.Add := 'const CtlH  = 20; ';
  Script.Add := '      SPACE = 5; ';
  Script.Add := 'var Lbl      : TLabel;';
  Script.Add := '    combo    : TComboBox; ';
  Script.Add := '    CheckBox : TCheckBox; ';
  Script.Add := 'begin ';
  Script.Add := '  Lbl   := CreateLabel( 10, (CtlH + SPACE) * ListCtrl.Count + 10, 150, CtlH, Caption, ScrollBox); ';
  Script.Add := '  lbl.AutoSize := IsAutoSize; ';
  Script.Add := '  if ListType = ''TEXT'' then begin ';
  Script.Add := '    combo       := CreateComboBox(Lbl.Left + Lbl.Width + SPACE, Lbl.Top, 150, CtlH, csDropDownList, ScrollBox); ';
  Script.Add := '    combo.Name  := ''Combo'' + IntToStr(ListCtrl.Count); ';
  Script.Add := '    combo.Style := csSimple; ';
  Script.Add := '    combo.Text  := GetValue( ParamName, DefaultValue, IsLookup, LookupValue ); ';
  Script.Add := '    ListCtrl.Add( Combo.Name + '';'' + ParamName + '';'' + IsLookup + '';'' + LookupValue); ';
  Script.Add := '  end ';
  Script.Add := '  else If ListType = ''CHECKBOX'' then begin ';
  Script.Add := '    CheckBox         := CreateCheckBox(Lbl.Left + Lbl.Width + SPACE, Lbl.Top, 150, CtlH, '''', ScrollBox); ';
  Script.Add := '    CheckBox.Name    := StrCheckBox + IntToStr(ListCtrl.Count); ';
  Script.Add := '    CheckBox.Caption := ''''; ';
  Script.Add := '    if GetValue( ParamName, DefaultValue, IsLookup, LookupValue )=StrTrue then begin ';
  Script.Add := '      CheckBox.Checked :=True; ';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      CheckBox.Checked :=False; ';
  Script.Add := '    end;';
  Script.Add := '    ListCtrl.Add( CheckBox.Name + '';'' + ParamName + '';'' + IsLookup + '';'' + LookupValue); ';
  Script.Add := '  end ';
  Script.Add := '  else begin ';
  Script.Add := '    combo           := CreateComboBox(Lbl.Left + Lbl.Width + SPACE, Lbl.Top, 150, CtlH, csDropDownList, ScrollBox); ';
  Script.Add := '    combo.Name      := ''Combo'' + IntToStr(ListCtrl.Count); ';
  Script.Add := '    FillCombo(combo, ListType); ';
  Script.Add := '    Combo.ItemIndex := Combo.Items.IndexOf(GetValue( ParamName, DefaultValue, IsLookup, LookupValue )) ; ';
  Script.Add := '    ListCtrl.Add( Combo.Name + '';'' + ParamName + '';'' + IsLookup + '';'' + LookupValue); ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  LeftStr;
  Script.Add := 'procedure SaveToOptions; ';
  Script.Add := 'var idx:Integer; ';
  Script.Add := '    ValueStr : String; ';
  Script.Add := '    combo    : TComboBox; ';
  Script.Add := '    sql      : TjbSQL; ';
  Script.Add := '    iTx      : TIBTransaction; ';
  Script.Add := '    CheckBox : TCheckBox; ';
  Script.Add := '  function TokenValue(TokenIdx:Integer):String; ';
  Script.Add := '  begin ';
  Script.Add := '    result := GetToken( ListCtrl[idx], '';'', TokenIdx); ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := '  if ListCtrl.Count = 0 then exit; ';
  Script.Add := '  for idx := 0 to ListCtrl.Count -1 do begin ';
  Script.Add := '    if LeftStr(ListCtrl[idx], 8) = StrCheckBox then begin ';
  Script.Add := '      CheckBox := TCheckBox(ScrollBox.FindComponent( TokenValue( idxCtlName ))); ';
  Script.Add := '    end ';
  Script.Add := '    else begin ';
  Script.Add := '      combo := TComboBox(ScrollBox.FindComponent( TokenValue( idxCtlName ))); ';
  Script.Add := '    end; ';
  Script.Add := '    if (combo=Nil) and (CheckBox=Nil) then Continue; ';
  Script.Add := '    If CheckBox<>Nil then begin ';
  Script.Add := '      if CheckBox.Checked=False Then Begin ';
  Script.Add := '        ValueStr := StrFalse; ';
  Script.Add := '      end ';
  Script.Add := '      else begin ';
  Script.Add := '        ValueStr := StrTrue; ';
  Script.Add := '      end; ';
  Script.Add := '      CheckBox := Nil; ';
  Script.Add := '    end; ';
  Script.add := '    If combo<>nil then begin ';
  Script.add := '      ValueStr := combo.Text;';
  Script.add := '      Combo := Nil;';
  Script.Add := '    end; ';
  Script.Add := '    iTx := CreateATx; ';
  Script.Add := '    sql := CreateSQL( iTx ); ';
  Script.Add := '    try ';
  Script.Add := '      if TokenValue(idxIsLookup) = ''1'' then begin ';
  Script.Add := '        RunSQL(sql, format(''Select t.%s from %s t where t.%s=''''%s'''''', '+
    '[TokenValue(idxValueField), TokenValue(idxTableLookup), TokenValue(idxDisplayField), ValueStr ])); ';
  Script.Add := '        if sql.RecordCount > 0 then ValueStr := sql.FieldByName(TokenValue(idxValueField)) else ValueStr := '''';';
  Script.Add := '      end; ';
  Script.Add := '      WriteOption(TokenValue(idxParam), ValueStr); ';
  Script.Add := '      iTx.Commit; ';
  Script.Add := '    finally ';
  Script.Add := '      sql.Free; ';
  Script.Add := '      iTx.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure FormSettingDestroy; ';
  Script.Add := 'begin ';
  Script.Add := '  ListCtrl.free; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'function CreateFormSetting(FormName, FormCaption:String; W, H : Integer):TForm; ';
  Script.Add := 'var btnOK, btnCancel:TButton; ';
  Script.Add := 'begin ';
  Script.Add := '  result := CreateForm(FormName, FormCaption, W, H);';
  Script.Add := '  ScrollBox := TScrollBox.Create(result); ';
  Script.Add := '  ScrollBox.Parent := result; ';
  Script.Add := '  ScrollBox.SetBounds( 0, 0, result.ClientWidth, result.ClientHeight - 30); ';
  Script.Add := '  ScrollBox.Anchors := akLeft + akTop + akRight + akBottom; ';
  Script.Add := '  btnOK     := CreateBtn((result.ClientWidth - 150) div 2, ScrollBox.Top + ScrollBox.Height, 50, 30, 0, ''&Simpan'', result); ';
  Script.Add := '  btnCancel := CreateBtn(btnOK.Left + btnOK.Width + 50, btnOK.Top, 50, 30, 0, ''&Batal'', result); ';
  Script.Add := '  btnOK.Anchors         := akLeft + akBottom; ';
  Script.Add := '  btnCancel.Anchors     := btnOK.Anchors;';
  Script.Add := '  btnOK.ModalResult     := mrOK; ';
  Script.Add := '  btnCancel.ModalResult := mrCancel; ';
  Script.Add := '  ListCtrl := TStringList.Create; ';
  Script.Add := '  result.OnDestroy := @FormSettingDestroy; ';
  Script.Add := 'end; ';
  Script.Add := '';
  CreateCustomMenuSetting;
end;

procedure TInjector.CreateGrid;
begin
  if not Script.IsProcedureExist('function CreateGrid( L, T, W, H:Integer; AParent:TWinControl; DS:TDataSource):TjbGrid;') then begin
    Script.Add := 'begin ';
    Script.Add := '  result := CreateJBGrid( AParent ); ';
    Script.Add := '  TControl(result).Parent := AParent; ';
    Script.Add := '  result.Left   := L; ';
    Script.Add := '  result.Top    := T; ';
    Script.Add := '  result.Width  := W; ';
    Script.Add := '  result.Height := H; ';
    Script.Add := '  result.DataSource := DS; ';
    Script.Add := 'end; ';
  end;
end;

procedure TInjector.CreatejbEdit;
begin
  if not Script.IsProcedureExist('function CreatejbEdit(L, T, W, H:Integer; AParent:TWinControl):TjbEdit;') then begin
    Script.Add := 'Begin ';
    Script.Add := '  Result := TjbEdit.Create(AParent); ';
    Script.Add := '  Result.Parent := AParent; ';
    Script.Add := '  Result.SetBounds(L, T, W, H); ';
    Script.Add := 'End; ';
  end;
end;

procedure TInjector.CreateJBLabel;
begin
  if not Script.IsProcedureExist('function CreateJBLabel(L, T, W, H:Integer; Cap:String; AParent:TWinControl; Logic:Boolean=True):TjbLabel;') then begin
    Script.Add := 'begin ';
    Script.Add := '  result := TjbLabel.Create( AParent ); ';
    Script.Add := '  result.Parent   := AParent; ';
    Script.Add := '  result.AutoSize := false; ';
    Script.Add := '  TLabel(result).SetBounds( L, T, W, H); ';
    Script.Add := '  result.Caption  := Cap; ';
    Script.Add := '  result.IsHyperText := Logic; ';
    Script.Add := 'end; ';
  end;
end;

procedure TInjector.SendEmail;
begin
  if not Script.IsProcedureExist('procedure SendEmail(EmailAdd, Header, Msg:String); ') then begin
//    Script.Add := '  ShellExecute(format(''mailto:%s ?subject=%s &body=%s'', [EmailAdd, Header, Msg]), '' '', '' '');';
    // AA, format function has limit of 256 character
    Script.Add := 'var';
    Script.Add := '  email_content : string;';
    Script.Add := 'begin';
    Script.Add := '  email_content := format(''mailto:%s ?subject=%s &body='', [EmailAdd, Header]);';
    Script.Add := '  email_content := email_content + Msg;';
    Script.Add := '  ShellExecute(email_content, '' '', '' '');';
    Script.Add := 'end;';
  end;
end;

procedure TInjector.Setfeature_name(const Value: string);
begin
  Ffeature_name := Value;
end;

procedure TInjector.AddScriptAttach(FieldName, FormName: String;
  Proc: TProc; AOwner: string; L, T, W, H: String);
begin
  ClearScript;
  CreateForm;
  CreateButton;
  CallFinaAttachment;
  Script.Add := 'const EXE_FILENAME = ''FinaAttachment.exe''; ';
  Script.Add := 'var frmPrevent : TForm; ';
  Script.Add := '    timer      : TTimer; ';
  Script.Add := '';
  Script.Add := 'procedure CloseFormPrevent; ';
  Script.Add := 'begin ';
  Script.Add := '  frmPrevent.Close; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure CreateFormPrevent; ';
  Script.Add := '  procedure DestroyFormPrevent( sender: TObject; var Action: TCloseAction ); ';
  Script.Add := '  begin ';
  Script.Add := '    Action := caFree; ';
  Script.Add := '  end; ';
  Script.Add := 'begin ';
  Script.Add := '  frmPrevent := CreateForm( ''frmPrevent'', ''Form'', 0, 0 ); ';
  Script.Add := '  frmPrevent.Position    := nil; ';
  Script.Add := '  frmPrevent.Left        := -10; ';
  Script.Add := '  frmPrevent.BorderStyle := bsToolWindow; ';
  Script.Add := '  frmPrevent.OnClose     := @DestroyFormPrevent; ';
  Script.Add := '  frmPrevent.ShowModal; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure CheckProcessAttachment; ';
  Script.Add := 'begin ';
  Script.Add := '  if not ProcessExists( EXE_FILENAME ) then begin ';
  Script.Add := '    CloseFormPrevent; ';
  Script.Add := '    timer.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure CreateTimer; ';
  Script.Add := 'begin ';
  Script.Add := '  timer := TTimer.Create( script_object ); ';
  Script.Add := '  timer.Interval := 1000; ';
  Script.Add := '  timer.OnTimer  := @CheckProcessAttachment; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure BtnScanClick; ';
  Script.Add := 'begin ';
  Script.Add := format('  CallFINAAttachment( Master.%s.value, Master.GUID.value, ''%s'' ); ', [FieldName, FormName]);
  //Script.Add := '  CreateTimer; ';
  //Script.Add := '  CreateFormPrevent; ';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  Script.Add := 'procedure CreateBtnScan; ';
  Script.Add := 'var btnScan : TButton; ';
  Script.Add := '    W : Integer; ';
  Script.Add := 'begin';
  if W='0' then begin
    Script.Add := format('  W := Form.%s.Width; ', [AOwner]);
  end
  else begin
    Script.Add := format('  W := %s;', [W]);
  end;
  Script.Add := format('  btnScan := CreateBtn(%s, %s, W, %s, 12, ''Attachment'', Form.%s); ', [L, T, H, AOwner]);
  Script.Add := '  btnScan.OnClick := @btnScanClick; ';
  Script.Add := 'end;';
  Script.Add := EmptyStr;
  Proc;
end;

procedure TInjector.GroupingAsBOM;
begin
  CreateButton;
  Script.Add := 'var checkBOM : TCheckBox; ';
  Script.Add := '    OriginalLabel3 : String; ';
  Script.Add := '    OriginalLabel5 : String; ';
  Script.Add := '    OriginalLabel6 : String; ';
  Script.Add := '    EditFG         : TEdit; ';
  Script.Add := '    EditBS         : TEdit; ';
  Script.Add := '    LabelFG        : TLabel; ';
  Script.Add := '    LabelBS        : TLabel; ';
  Script.Add := '    btnSearchFG    : TButton; ';
  Script.Add := '    btnSearchBS    : TButton; ';
  Script.Add := '';
  Script.Add := 'procedure AssignField(FieldName, Value:String); ';
  Script.Add := 'begin ';
  Script.Add := '  if Master.ExtendedID.FieldLookup.FieldByName( FieldName ).IsNull or (Master.ExtendedID.FieldLookup.FieldByName( FieldName ).asString <> Value) then begin ';
  Script.Add := '    if Master.State = 1 {dsBrowse} then Master.Edit; ';
  Script.Add := '    if Master.ExtendedID.FieldLookup.State = 1 then Master.ExtendedID.FieldLookup.Edit; ';
  Script.Add := '    Master.ExtendedID.FieldLookup.FieldByName( FieldName ).value := Value; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure SetVisible(vis:Boolean);';
  Script.Add := 'begin ';
  //Script.Add := '  Form.ALabel3.Visible         := vis; ';
  //Script.Add := '  Form.AeditUnitPrice.Visible  := vis; ';
  Script.Add := '  Form.AbtnUnitPrice.Visible   := vis; ';
  Script.Add := '  Form.AcboSales.Visible       := vis; ';
  Script.Add := '  Form.AeditSales.Visible      := vis; ';
  Script.Add := '  Form.AeditSalesRet.Visible   := vis; ';
  Script.Add := '  Form.AcboSalesRet.Visible    := vis; ';
  Script.Add := '  Form.ALabel7.Visible         := vis; ';
  Script.Add := '  Form.AcboSlsDiscount.Visible := vis; ';
  Script.Add := '  Form.AedtSlsDiscount.Visible := vis; ';
  Script.Add := '  Form.ATabSheet2.TabVisible   := vis; ';
  Script.Add := '  Form.ALabel4.visible         := vis; ';
  Script.Add := '  Form.AEditTaxCode.visible    := vis; ';
  Script.Add := '  EditFG.visible               := not vis; ';
  Script.Add := '  EditBS.Visible               := not vis; ';
  Script.Add := '  LabelFG.Visible              := not vis; ';
  Script.Add := '  LabelBS.Visible              := not vis; ';
  Script.Add := '  btnSearchFG.visible          := not vis; ';
  Script.Add := '  btnSearchBS.visible          := not vis; ';
  Script.Add := '  if Vis then begin ';
  Script.Add := '    Form.ALabel3.Caption  := OriginalLabel3; ';
  Script.Add := '    Form.ALabel5.Caption  := OriginalLabel5; ';
  Script.Add := '    Form.ALabel6.Caption  := OriginalLabel6; ';
  Script.Add := '    AssignField(GROUP_IS_BOM_FIELD, ''0''); ';
  Script.Add := '  end ';
  Script.Add := '  else begin ';
  Script.Add := '    Form.ALabel3.Caption  := ''FG Quantity''; ';
  Script.Add := '    Form.ALabel5.Caption  := ''Finished Goods''; ';
  Script.Add := '    Form.ALabel6.Caption  := ''Bad Stock''; ';
  Script.Add := '    AssignField(GROUP_IS_BOM_FIELD, ''1''); ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure CheckBOMClick(sender:TObject); ';
  Script.Add := 'begin ';
  Script.Add := '  if not (Sender is TCheckBox) then exit; ';
  Script.Add := '  SetVisible( not TCheckBox(Sender).Checked ); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function ValidateItem(editbox:TEdit):String; ';
  Script.Add := 'var sql:TjbSQL; ';
  Script.Add := 'begin ';
  Script.Add := '  result := ''''; ';
  Script.Add := '  if editBox.Text = '''' then exit; ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sql, ''Select i.ItemDescription from Item i where i.ItemNo=:ItemNo'', false); ';
  Script.Add := '    sql.SetParam(0, editBox.Text); ';
  Script.Add := '    sql.ExecQuery; ';
  Script.Add := '    if sql.RecordCount = 0 then begin ';
  Script.Add := '      editBox.SetFocus; ';
  Script.Add := '      RaiseException( ''Item tidak ditemukan'' ); ';
  Script.Add := '    end; ';
  Script.Add := '    result := sql.FieldByName(''ItemDescription''); ';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure OnEditItemExit(EditBox:TEdit; Lbl:TLabel; FieldName:String); ';
  Script.Add := 'begin ';
  Script.Add := '  lbl.Caption := ValidateItem( EditBox );';
  Script.Add := '  AssignField( FieldName, editBox.Text ); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure EditFGExit; ';
  Script.Add := 'begin ';
  Script.Add := '  OnEditItemExit( editFG, LabelFG, GROUP_FG_FIELD ); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure EditBSExit; ';
  Script.Add := 'begin ';
  Script.Add := '  OnEditItemExit( editBS, LabelBS, GROUP_BS_FIELD ); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure btnSearchFGClick; ';
  Script.Add := 'begin ';
  Script.Add := '  ShowSearchItemNo('''', '''', '''', EditFG, false, false, false); ';
  Script.Add := '  EditFG.SetFocus; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure btnSearchBSClick;';
  Script.Add := 'begin ';
  Script.Add := '  ShowSearchItemNo('''', '''', '''', EditBS, false, false, false); ';
  Script.Add := '  EditBS.SetFocus; ';
  Script.Add := 'end; ';
  Script.Add := '';
  // AA, BZ 1835
  Script.Add := 'procedure set_bom_flag_to_true;';
  Script.Add := 'begin';
  Script.Add := '  if not checkBOM.checked then begin';
  Script.Add := '    checkBOM.checked := True;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure DecorateGroupForm; ';
  Script.Add := 'begin';
  Script.Add := '  OriginalLabel3 := Form.ALabel3.Caption; ';
  Script.Add := '  OriginalLabel5 := Form.ALabel5.Caption; ';
  Script.Add := '  OriginalLabel6 := Form.ALabel6.Caption; ';
  Script.Add := '  Form.AeditGroupNo.Width := Form.AeditGroupNo.Width - 100; ';
  Script.Add := '  checkBOM := CreateCheckBox(Form.AeditGroupNo.Left + Form.AeditGroupNo.Width + 5, '+
    'Form.AeditGroupNo.Top, 100, Form.AeditGroupNo.Height, ''BOM'', Form.AeditGroupNo.Parent); ';
  Script.Add := '  checkBOM.Anchors := akTop + akRight; ';
  Script.Add := '  checkBOM.OnClick := @checkBOMClick; ';
  Script.Add := '  editFG  := CreateEdit(Form.AeditSales.Left, Form.AeditSales.Top, Form.AeditSales.Width, Form.AeditSales.Height, Form.AeditSales.Parent); ';
  Script.Add := '  editBS  := CreateEdit(Form.AeditSalesRet.Left, Form.AeditSalesRet.Top, Form.AeditSalesRet.Width, Form.AeditSalesRet.Height, Form.AeditSalesRet.Parent); ';
  Script.Add := '  LabelFG := CreateLabel(Form.AcboSales.Left, Form.AcboSales.Top, Form.AcboSales.Width-Form.AcboSales.Height, Form.AcboSales.Height, '''', Form.AcboSales.Parent); ';
  Script.Add := '  LabelBS := CreateLabel(Form.AcboSalesRet.Left, Form.AcboSalesRet.Top, Form.AcboSalesRet.Width-Form.AcboSalesRet.Height, Form.AcboSalesRet.Height, '''', Form.AcboSalesRet.Parent); ';
  Script.Add := '  btnSearchFG := CreateBtn(LabelFG.Left + LabelFG.Width, LabelFG.Top, LabelFG.Height, LabelFG.Height, 0, ''...'', LabelFG.Parent); ';
  Script.Add := '  btnSearchBS := CreateBtn(LabelBS.Left + LabelBS.Width, LabelBS.Top, LabelBS.Height, LabelBS.Height, 0, ''...'', LabelBS.Parent); ';
  Script.Add := '  editFG.OnExit := @EditFGExit; ';
  Script.Add := '  editBS.OnExit := @EditBSExit; ';
  Script.Add := '  btnSearchFG.OnClick := @btnSearchFGClick; ';
  Script.Add := '  btnSearchBS.OnClick := @btnSearchBSClick; ';
  Script.Add := '  LabelFG.Anchors      := akLeft + akTop + akRight; ';
  Script.Add := '  LabelBS.Anchors      := akLeft + akTop + akRight;';
  Script.Add := '  btnSearchFG.Anchors  := akTop + akRight;';
  Script.Add := '  btnSearchBS.Anchors  := akTop + akRight;';
  //Script.Add := '  SetVisible( not checkBOM.Checked ); ';
  Script.Add := '  set_bom_flag_to_true;'; // AA, BZ 1835
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure LoadItemFG_BS; ';
  Script.Add := 'begin ';
//  Script.Add := '  checkBOM.checked := (Master.ExtendedID.FieldLookup.FieldByName( GROUP_IS_BOM_FIELD ).value = ''1''); ';
//  Script.Add := '  SetVisible(not checkBOM.Checked); ';
  // AA, BZ 1835
  Script.Add := '  if ( Master.FieldByName(''Itemno'').AsString<>'''' ) then begin';
  Script.Add := '    checkBOM.checked := (Master.ExtendedID.FieldLookup.FieldByName( GROUP_IS_BOM_FIELD ).value = ''1'');';
  Script.Add := '  end;';
  Script.Add := '  editFG.Text := Master.ExtendedID.FieldLookup.FieldByName(GROUP_FG_FIELD).asString; ';
  Script.Add := '  editBS.Text := Master.ExtendedID.FieldLookup.FieldByName(GROUP_BS_FIELD).asString; ';
  Script.Add := '  EditFGExit;';
  Script.Add := '  EditBSExit;';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure ValidateFGQty; ';
  Script.Add := 'begin';
  Script.Add := '  if checkBOM.Checked then begin';
  Script.Add := '    if (Master.UnitPrice.value = 0) or (Master.UnitPrice.isNull) then Master.UnitPrice.value := 1; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TInjector.CreateFormChoose;
begin
  CreateListView;
  Script.Add := 'procedure OnFormClose(Sender : TObject; var Action : TCloseAction); ';
  Script.Add := 'begin                   ';
  Script.Add := '  action := caFree;     ';
  Script.Add := 'end;                    ';
  Script.Add := '';
  Script.Add := 'var list      : TListView; ';
  Script.Add := 'function CreateFrmChoose(FormCaption, BtnOKClick, SQLScript, IDField, NoField:String): TForm;    ';
  Script.Add := 'var btnOK     : TButton; ';
  Script.Add := '    btnCancel : TButton; ';
  Script.Add := '  procedure FillList; ';
  Script.Add := '  var                                                       ';
  Script.Add := '    listItem : TListItem;                                   ';
  Script.Add := '    sql : TjbSQL; ';
  Script.Add := '  begin ';
  Script.Add := '    list.Items.Clear;                                       ';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Tx));                   ';
  Script.Add := '    try                                                     ';
  Script.Add := '      RunSQL(sql, SQLScript);                               ';
  Script.Add := '      while not sql.EOF do begin                            ';
  Script.Add := '        listItem         := list.Items.Add;               ';
  Script.Add := '        listItem.Caption := sql.FieldByName(NoField);     ';
  Script.Add := '        listItem.SubItems.Add( sql.FieldByName(IDField)); ';
  Script.Add := '        sql.Next;                                           ';
  Script.Add := '      end;                                                  ';
  Script.Add := '    finally                                                 ';
  Script.Add := '      sql.Free;                                             ';
  Script.Add := '    end;                                                    ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := 'begin                                 ';
  Script.Add := '  result := TForm.Create(Form);       ';
  Script.Add := '  result.Name        := ''FrmChoose'';';
  Script.Add := '  result.Width       := 400;          ';
  Script.Add := '  result.Height      := 400;          ';
  Script.Add := '  result.Position    := 6;            ';
  Script.Add := '  result.Caption     := FormCaption;  ';
  Script.Add := '  result.BorderIcons := biSystemMenu; ';
  Script.Add := '  result.OnClose := @OnFormClose;     ';
  Script.Add := '  list := CreateListView( result, 0, 0, result.ClientWidth, 320);                                                  ';
  Script.Add := '  CreateListViewCol(list, ''ID'', 150); ';
  Script.Add := '  CreateListViewCol(list, ''NO'', 150); ';
  Script.Add := '  FillList; ';
  Script.Add := '  BtnOK     := CreateBtn( 5, result.Height-70, 180, 30, 0, ''Ok'', result );      ';
  Script.Add := '  BtnCancel := CreateBtn( 190, result.Height-70, 192, 30, 0, ''Cancel'', result); ';
  Script.Add := '  BtnOK.OnClick         := BtnOKClick;                                           ';
  Script.Add := '  BtnCancel.ModalResult := mrCancel;                                              ';
  Script.Add := 'end;                                  ';
  Script.Add := '';
  Script.Add := 'function GetSelectedID:Integer;';
  Script.Add := 'var i:Integer; ';
  Script.Add := '    CheckedCount : Integer; ';
  Script.Add := 'begin ';
  Script.Add := '  CheckedCount := 0;                                                                                                    ';
  Script.Add := '  for i:=0 to list.Items.Count-1 do begin                                                                      ';
  Script.Add := '    if list.Items[i].Checked then begin                                                                        ';
  Script.Add := '      Inc(CheckedCount);                                                                                                ';
  Script.Add := '      result := StrToInt(list.Items[i].SubItems[0]);                                                      ';
  Script.Add := '      if CheckedCount>1 then begin                                                                                      ';
  Script.Add := '        RaiseException(''You can only select one quotation!'');                                                           ';
  Script.Add := '      end;                                                                                                              ';
  Script.Add := '    end;                                                                                                                ';
  Script.Add := '  end;                                                                                                                  ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TInjector.PrintOneTransaction(TblName, FieldName, ID : String; UseDM : Boolean);
begin
  Script.Add := EmptyStr;
  if not Script.IsProcedureExist('procedure PrintOneTransaction(TemplateID : Integer = -1; TransID : Integer = -1);') then begin
    Script.Add := 'var';
    Script.Add := '  util : TfrPrintUtility;';
    Script.Add := 'begin';
    Script.Add := '  if TransID = -1 then begin';
    Script.Add := format('    TransID := DataModule.%s.AsInteger;', [ID]);
    Script.Add := '  end;';
    if UseDM then begin
      Script.Add := '  if TemplateID = -1 then begin';
//      Script.Add := format('    Form.PrintOneInvoice( DataModule.%s.value, Form.AfrReport1, (TemplateID <> -1) );', [ID]);
      Script.Add := '    Form.PrintOneInvoice(TransID, Form.AfrReport1, (TemplateID <> -1) );';  //SCY BZ 3452
      Script.Add := '  end';
      Script.Add := '  else begin';
    end;
    Script.Add := '  util := TfrPrintUtility.Create;';
    Script.Add := '  try';
//    Script.Add := format('    util.PrintOneTransaction( ''%s'', ''%s'', DataModule.%s.value, TIBDatabase(DB), TemplateID ); ', [TblName, FieldName, ID]);
    Script.Add := format('    util.PrintOneTransaction( ''%s'', ''%s'', TransID, TIBDatabase(DB), TemplateID ); ', [TblName, FieldName]);  //SCY BZ 3452
    Script.Add := '  finally';
    Script.Add := '    util.free;';
    Script.Add := '  end;';
    if UseDM then begin
      Script.Add := '  end;';
    end;
    Script.Add := 'end;';
  end;
end;

procedure TInjector.PrintTransactionInAllList;
begin
  Script.Add := EmptyStr;
  if not Script.IsProcedureExist('procedure PrintTransactionInAllList(Sender : TObject; TransID : Integer; var LogLocation : string = '''');') then begin
    Script.Add := 'begin';
    Script.Add := '  PrintOneTransaction(TMenuItem(Sender).Tag, TransID);';
    Script.Add := 'end;';
  end;
end;

procedure TInjector.AddPrintForm(TblName, FieldName, ID, Dataset:String; UseDM:Boolean=false; FromNo:String='edtNoFrom.Text'; ToNo:String='edtNoTo.Text');
begin
  PrintOneTransaction(TblName, FieldName, ID, UseDM);
  PrintTransactionInAllList;

  Script.Add := EmptyStr;
  Script.Add := 'procedure RefreshList(qrysql, PrintMessage : string);';  //SCY BZ 3452
  Script.Add := 'begin';
  Script.Add := '  ShowMessage(''Print '' + PrintMessage + '' Done.'');';
  Script.Add := format('  DataModule.%s.Close; ', [Dataset]);
  Script.Add := format('  Datamodule.%s.SelectSQL.Text := qrysql;', [Dataset]);
  Script.Add := format('  DataModule.%s.Open; ', [Dataset]);
  Script.Add := 'end;';

  Script.Add := EmptyStr;
  Script.Add := 'procedure UpdateStatusPrint(ID:Integer); ';
  Script.Add := 'var sqlUpdate  : TjbSQL; ';
  Script.Add := '    ATx  : TIBTransaction; ';
  Script.Add := 'begin ';
  Script.Add := '  ATx := CreateATx; ';
  Script.Add := '  sqlUpdate := CreateSQL(ATx); ';
  Script.Add := '  try ';
//  Script.Add := Format('    RunSQL( sqlUpdate, Format(''Update %s set Printed = 1 where %s ',[TblName, FieldName])+ ' = %d '', [ID]) ); ';
//  Script.Add := '    ATx.Commit; ';
  // AA, BZ 2030
  Script.Add := Format('    RunSQL( sqlUpdate, ''Select 1 from RDB$RELATION_FIELDS rf  '+
                       'where rf.RDB$RELATION_NAME = ''''%s'''' and rf.RDB$FIELD_NAME = ''''PRINTED'''''');',[UpperCase(TblName)] );
  Script.Add := '    if ( Not sqlUpdate.EOF ) then begin';
  Script.Add := Format('      RunSQL( sqlUpdate, Format(''Update %s set Printed = 1 where %s ',[TblName, FieldName])+ ' = %d '', [ID]) ); ';
  Script.Add := '      ATx.Commit; ';
  Script.Add := '    end;';

  Script.Add := '  finally ';
  Script.Add := '    ATx.Free; ';
  Script.Add := '    sqlUpdate.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := ' ';
  Script.Add := 'procedure DoPrintAll(sender:TObject);                         ';
  Script.Add := 'var List : TStringList; ';
  Script.Add := '    idx  : Integer; ';
  Script.Add := '    qrysql : String; ';
  Script.Add := '    LogLocation : string;';
  Script.Add := 'begin                                                         ';
  Script.Add := '  List := TStringList.Create; ';
  Script.Add := format('  qrysql := Datamodule.%s.SelectSQL.Text;', [Dataset]);
  Script.Add := format('    Datamodule.%s.DisableControls;', [Dataset]);  //SCY BZ 3452
  Script.Add := '  try ';
  Script.Add := format('    Datamodule.%s.First;', [Dataset]);
  Script.Add := format('    While not Datamodule.%s.EOF do begin', [Dataset]);
//  Script.Add := '      PrintTransactionInAllList(Sender, LogLocation);';  //SCY BZ 3452 Bug Filter when SI Update.
  Script.Add := '      List.Add( '+ Format('DataModule.%s.value',[ID]) +'); ';
  Script.Add := format('      DataModule.%s.Next;', [Dataset]);
  Script.Add := '    end; ';
  Script.Add := '    for idx := 0 to List.Count -1 do begin ';
  Script.Add := '      PrintTransactionInAllList(Sender, StrToInt(List[idx]), LogLocation);';  //SCY BZ 3452
  Script.Add := '      UpdateStatusPrint(StrToInt(List[idx]) ); ';
  Script.Add := '    end; ';
  Script.Add := '    if (LogLocation <> '''') then begin';
  Script.Add := '      ShellExecute(LogLocation, nil, nil);';
  Script.Add := '    end;';
  Script.Add := '    RefreshList(qrysql, ''All'');';
  Script.Add := '  finally ';
  Script.Add := '    List.Free; ';
  Script.Add := format('    Datamodule.%s.EnableControls;', [Dataset]);  //SCY BZ 3452
  Script.Add := '  end; ';
  Script.Add := 'end;                                                          ';
  Script.Add := '                                                              ';
  Script.Add := 'procedure DoPrintSelected(sender:TObject);';
  Script.Add := 'var';
  Script.Add := '  qrysql : string;';
  Script.Add := 'begin';
  Script.Add := format('  qrysql := Datamodule.%s.SelectSQL.Text;', [Dataset]);
  Script.Add := '  PrintOneTransaction( TMenuItem(sender).Tag );               ';
  Script.Add := Format('  UpdateStatusPrint( DataModule.%s.Value ); ', [ID]);
  Script.Add := '  RefreshList(qrysql, ''Selected'');';
  Script.Add := 'end;                                                          ';
  Script.Add := '                                                              ';
  Script.Add := 'procedure AddTemplateMenu( mnuParent:TMenuItem; DoClick:String; TemplateType:Integer );';
  Script.Add := 'var sqlmnu:TjbSQL;                                               ';
  Script.Add := '  procedure CreateSubMenu(Tag:Integer; MenuName:String);         ';
  Script.Add := '  var mnu   : TmenuItem;                                         ';
  Script.Add := '  begin                                                          ';
  Script.Add := '    mnu := TMenuItem.Create(mnuParent);                          ';
  Script.Add := '    mnuParent.Add( mnu );                                        ';
  Script.Add := '    mnu.Tag     := Tag;                                          ';
  Script.Add := '    mnu.Caption := MenuName;                                     ';
  Script.Add := '    mnu.OnClick := DoClick;                                      ';
  Script.Add := '  end;                                                           ';
  Script.Add := '  function GetTemplateType:Integer;                              ';
  Script.Add := '  begin                                                          ';
  if TblName = 'JV' then begin
    Script.Add := '      result := TemplateType + Datamodule.FormType - 1;        ';
  end
  else begin
    Script.Add := '      result := TemplateType;                                  ';
  end;
  Script.Add := '  end;                                                           ';
  Script.Add := 'begin                                                            ';
  Script.Add := '  sqlmnu := CreateSQL(TIBTransaction(Tx));                                           ';
  Script.Add := '  try';
  Script.Add := '    RunSQL( sqlMnu, format(''Select t.TemplateID, t.Name from Template t where t.TemplateType=%d order by t.IsDefTemplate Desc'', [GetTemplateType])); ';
  Script.Add := '    CreateSubMenu( -1, ''Default'');                         ';
  Script.Add := '    while not sqlMnu.EOF do begin                                ';
  Script.Add := '      CreateSubMenu(sqlMnu.FieldByName(''TemplateID''), sqlMnu.FieldByName(''Name'')); ';
  Script.Add := '      sqlMnu.Next;                                               ';
  Script.Add := '    end;                                                         ';
  Script.Add := '  finally                                                        ';
  Script.Add := '    sqlMnu.Free;                                                 ';
  Script.Add := '  end;                                                           ';
  Script.Add := 'end;                                                             ';
  Script.Add := EmptyStr;

  Script.Add := 'function AddPopMenu(Caption, DoClick:String; TemplateType:Integer; TemplateID:Integer=-1):TMenuItem;       ';
  Script.Add := 'begin                                                         ';
  Script.Add := '  result := TMenuItem.Create(Form);                           ';
  Script.Add := '  result.Tag       := TemplateID;                             ';
  Script.Add := '  result.Caption   := Caption;                                ';
  //Script.Add := '  result.Name      := DoClick; '; //JR, BZ 2510
  Script.Add := '  Form.popupMenu.Items.Add( result );                         ';
  Script.Add := '  if TemplateType =-1 then begin                              ';
  Script.Add := '    result.OnClick   := DoClick;                              ';
  Script.Add := '  end                                                         ';
  Script.Add := '  else begin                                                  ';
  Script.Add := '    AddTemplateMenu( result, DoClick, TemplateType );                       ';
  Script.Add := '  end;                                                        ';
  Script.Add := 'end;                                                          ';
  Script.Add := '                                                              ';
  Script.Add := 'procedure AddPrintForm(TemplateType:Integer=-1);              ';
  Script.Add := 'begin                                                         ';
  Script.Add := '  AddPopMenu(''Print All Form'', ''DoPrintAll'', TemplateType);     ';
  Script.Add := '  AddPopMenu(''Print Selected'', ''DoPrintSelected'', TemplateType);';
  Script.Add := 'end;                                                          ';
  Script.Add := '                                                              ';
end;

procedure TInjector.MultiDBConsolFunction;
begin
  Script.Add := 'function GetMultiDBConsoleFileName(ext:String):String;';
  Script.Add := 'begin';
  Script.Add := '  result := ExtractFilePath(Application.ExeName) + format(''\MultiDBConsole.%s'', [Ext]); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function GetDataset:String; ';
  Script.Add := 'var ini : Tinifile; ';
  Script.Add := 'begin';
  Script.Add := '  ini := TInifile.Create( GetMultiDBConsoleFileName(''ini'') );';
  Script.Add := '  try';
  Script.Add := '    result := ini.ReadString(''Main'', ''Dataset'', ''1''); ';
  Script.Add := '  finally';
  Script.Add := '    ini.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function GetOutputFileName:String; ';
  Script.Add := 'begin';
  Script.Add := '  result := format(''%s%s.txt'', [GetApplicationDataDir, FormatDateTime(''yyyymmddhhnnss'', Now)]); ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TInjector.AddFilterByNumber(filter, Dataset, Index, DateTo, FilterCaption, BottomCtl, FieldName, btnReset, CheckDate:String; idx:String='');
begin
  CreateTx;
  Script.Add := format('var CheckFilterNo%s : TCheckBox; ', [idx]);
  Script.Add := format('    lblNoFrom%s     : TLabel;    ', [idx]);
  Script.Add := format('    lblNoTo%s       : TLabel;    ', [idx]);
  Script.Add := format('    edtNoFrom%s     : TEdit;     ', [idx]);
  Script.Add := format('    edtNoTo%s       : TEdit;     ', [idx]);
  Script.Add := '                               ';
  Script.Add := format('procedure UpdateVisible%s( vis:Boolean ); ', [idx]);
  Script.Add := 'begin ';
  Script.Add := format('  lblNoFrom%s.Visible := vis; ', [idx]);
  Script.Add := format('  lblNoTo%s.visible   := vis; ', [idx]);
  Script.Add := format('  edtNoFrom%s.Visible := vis; ', [idx]);
  Script.Add := format('  edtNoTo%s.visible   := vis; ', [idx]);
  Script.Add := '  if not Vis then begin     ';
  Script.Add := format('    if edtNoFrom%s.Text <> '''' then begin ', [idx]);
  Script.Add := format('      edtNoFrom%s.Text  := '''';           ', [idx]);
  Script.Add := format('      edtNoTo%s.Text    := '''';           ', [idx]);
  Script.Add := format('      FilterByNo%s;                            ', [idx]);
  Script.Add := '    end;                                     ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := EmptyStr;

  Script.Add := format('procedure CheckFilterNoClick%s;  ', [idx]);
  Script.Add := 'begin ';
  Script.Add := format('  UpdateVisible%s( CheckFilterNo%s.Checked ); ', [idx, idx]);
  Script.Add := 'end;  ';
  Script.Add := EmptyStr;

  Script.Add := format('function FilterIsEmpty%s:Boolean; ', [idx]);
  Script.Add := 'begin                           ';
  Script.Add := format('  result := (edtNoFrom%s.Text = '''') or (edtNoTo%s.Text = ''''); ', [idx, idx]);
  Script.Add := 'end;                            ';
  Script.Add := EmptyStr;

  Script.Add := format('procedure FilterByNo%s; ', [idx]);
  Script.Add := 'begin ';
  Script.Add := format('  %s;', [Filter]);
  Script.Add := format('  if FilterIsEmpty%s then exit; ', [idx]);
  Script.Add := format('  Datamodule.%s.SelectSQL[%s] := DataModule.%s.SelectSQL[%s] + ', [dataset, index, dataset, index])+
    'format('' and ' + FieldName + ' between ''''%s'''' and ''''%s'''' '', [edtNoFrom' + idx + '.Text, edtNoTo' + idx + '.Text]); ';
  Script.Add := format('  DataModule.%s.Close; ', [dataset]);
  Script.Add := format('  DataModule.%s.Open;  ', [dataset]);
  Script.Add := 'end; ';
  Script.Add := EmptyStr;

  Script.Add := format('procedure AddFilterByNumber%s; ', [idx]);
  Script.Add := 'begin                          ';
  Script.Add := format('  CheckFilterNo%s := CreateCheckBox( Form.%s.Left, %s.Top + %s.Height + 10,', [idx, CheckDate, BottomCtl, BottomCtl]) +
                format('  Form.%s.Width, Form.%s.Height, ''%s'', %s.Parent ); ', [CheckDate, CheckDate, FilterCaption, BottomCtl]);
  Script.Add := format('  CheckFilterNo%s.Font.Style := fsBold; ', [idx]);
  Script.Add := format('  CheckFilterNo%s.OnClick    := @CheckFilterNoClick%s;  ', [idx, idx]);
  Script.Add := format('  lblNoFrom%s := CreateLabel( 10, CheckFilterNo%s.Top + CheckFilterNo%s.Height + 10, 40, 20, ''From '', CheckFilterNo%s.Parent); ',
    [idx, idx, idx, idx]);
  Script.ADd := format('  lblNoTo%s   := CreateLabel( lblNoFrom%s.Left, lblNoFrom%s.Top + lblNoFrom%s.Height + 10, lblNoFrom%s.Width, 20, ''To '', lblNoFrom%s.Parent); ',
    [idx, idx, idx, idx, idx, idx]);
  Script.Add := format('  edtNoFrom%s  := CreateEdit(  %s.Left, lblNoFrom%s.Top, %s.Width, %s.Height, lblNoFrom%s.Parent);', [idx, DateTo, idx, DateTo, DateTo, idx]);
  Script.Add := format('  edtNoTo%s    := CreateEdit(  edtNoFrom%s.Left, lblNoTo%s.Top, edtNoFrom%s.Width, edtNoFrom%s.Height, lblNoTo%s.Parent);', [idx, idx, idx, idx, idx, idx]);
  Script.Add := format('  UpdateVisible%s( false );', [idx]);
  Script.Add := format('  edtNoFrom%s.OnExit := @FilterByNo%s;', [idx, idx]);
  Script.Add := format('  edtNoTo%s.OnExit   := @FilterByNo%s;', [idx, idx]);
  if BtnReset <> '' then begin
    Script.Add := format('  if (%s <> nil) then %s.Top := lblNoTo%s.Top + lblNoTo%s.Height + 20; ', [btnReset, BtnReset, idx, idx]);
  end;
  Script.Add := 'end;                           ';
  Script.Add := EmptyStr;
end;

procedure TInjector.LoadCombo;
begin
  add_procedure_runsql;

  if not Script.IsProcedureExist('procedure LoadCombo (sql : TjbSQL; Combo : TComboBox; sqlScript : String; WithAll : Boolean); ') then begin
    Script.Add := '  function GetFirstItem:String; ';
    Script.Add := '  begin';
    Script.Add := '    if WithAll then result := ''<ALL>'' else result := ''<None>''; ';
    Script.Add := '  end; ';
    Script.Add := 'begin';
    Script.Add := '  combo.Items.Clear; ';
    Script.Add := '  combo.Items.AddObject(GetFirstItem, nil); ';
    Script.Add := '  RunSQL(sql, sqlScript); ';
    Script.Add := '  while not sql.EOF do begin ';
    Script.Add := '    combo.Items.AddObject( sql.FieldByName(''code''), sql.FieldByName(''ID'') ); ';
    Script.Add := '    sql.Next; ';
    Script.Add := '  end; ';
    Script.Add := '  combo.ItemIndex := 0; ';
    Script.Add := 'end; ';
  end;
end;

procedure TInjector.LoopInDataset(LoopName, procName:String);
(* Prosedur ini digunakan untuk menghindari pengulangan mengetik looping di dalam sebuah TDataset
   Contoh Cara menggunakannya:

  Script.Add := 'function CheckCount: Integer;';
  Script.Add := 'var totalCheck : Integer = 0;';
  Script.Add := '';
  LoopInDataset('Count', 'if d.FieldByName(''Check'').value then inc( TotalCheck );');
  Script.Add := 'begin';
  Script.Add := '  Count(ds);';
  Script.Add := '  result := totalCheck;';
  Script.Add := 'end;';

  Kalau mau create loop yang lain untuk kepentingan yang lain, tinggal panggil LoopInDataset lagi dengan nama procedur yang lain
  Contoh:

  Script.Add := 'procedure SelectQtyMoreThanZero;';
  LoopInDataset('Check', 'd.FieldByName(''Check'').value := d.FieldByName(''Quantity'').value > 0;');
  Script.Add := 'begin';
  Script.Add := '  Check(ds);';
  Script.Add := 'end;';
*)
begin
  Script.Add := format('procedure %s(d:TDataset);', [LoopName]);
  Script.Add := 'begin';
  Script.Add := '  d.DisableControls;';
  Script.Add := '  try';
  Script.Add := '    d.First;';
  Script.Add := '    while not d.eof do begin';
  Script.Add := format('      %s', [procName]);
  Script.Add := '      d.Next;';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    d.EnableControls;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TInjector.IsActiveScriptExist;
begin
  Script.Add := EmptyStr;
  if not Script.IsProcedureExist('function IsActiveScriptExist(FeatureName : string; FormType : Integer = -1) : Boolean;') then begin
    Script.Add := 'var';
    Script.Add := '  scriptSQL   : TjbSQL;';
    Script.Add := '  scriptQuery : string;';
    Script.Add := 'begin';
    Script.Add := '  scriptSQL := CreateSQL (TIBTransaction (Tx) );';
    Script.Add := '  try';
    Script.Add := '    scriptQuery := Format(''SELECT FIRST 1 ID FROM SCRIPTLIST '+
                                      'WHERE FEATURENAME = ''''%s'''' AND ISACTIVE = 1 '' '+
                                      ', [FeatureName]);';
    Script.Add := '    if (FormType > -1) then begin';
    Script.Add := '      scriptQuery := scriptQuery + Format(''AND FORMTYPE = %d '', [FormType]);';
    Script.Add := '    end;';

    Script.Add := '    RunSQL (scriptSQL, scriptQuery);';
    Script.Add := '    Result := NOT scriptSQL.EOF;';
    Script.Add := '  finally';
    Script.Add := '    scriptSQL.Free;';
    Script.Add := '  end;';
    Script.Add := 'end;';
  end;
end;


{ TScriptList }

function TScriptList.IsProcedureExist(ProcedureLine: String): Boolean;
begin
  result := List.IndexOf(ProcedureLine) > -1;
  if not result then begin
    Add := ProcedureLine;
  end;
end;

procedure TScriptList.Clear;
begin
  List.Clear;
end;

constructor TScriptList.Create;
begin
  List := TStringList.Create;
end;

destructor TScriptList.Destroy;
begin
  List.Free;
  inherited;
end;

function TScriptList.GetCount: Integer;
begin
  result := List.Count;
end;

function TScriptList.GetItems(index: integer): String;
begin
  result := List[index];
end;

procedure TScriptList.SetAdd(const Value: string);
begin
  List.Add( value );
end;

function TScriptList.Text: String;
begin
  result := List.Text;
end;

end.
