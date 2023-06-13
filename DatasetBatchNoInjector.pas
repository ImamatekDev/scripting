unit DatasetBatchNoInjector;

interface

Uses
  Injector
  , SysUtils
  , BankConst;

Const
  FIELD_CAPTION = 'Required Batch No';

Type
  TExtraScriptProcedure = Procedure of object;

  TDatasetBatchNoInjector = class(TInjector)
  private
//    is_item_transfer : boolean;
//    is_arinv : boolean;
    is_apinv : boolean;
    is_job_costing : boolean;
    Frequired_batch_no_field_name: string;
    Fexpired_date_field_name: string;
    Fbatch_no_field_name: string;
    procedure reset_transaction_flag;

    procedure add_global_constanta( Masuk:integer );
    procedure add_global_variable;

    procedure AddMasterDatasetConstanta(FirstKeyField, DetailDataset:String);
    procedure add_master_dataset_variable;
    function add_code_to_fill_is_masuk_variable:string;
    procedure AddFunction_ComposeListContent;
    procedure AddProcedure_FillList;
    procedure AddFunction_Get;
    procedure AddProcedure_MasterBeforeEdit;
    procedure AddFunction_IsExistInList;
    procedure AddFunction_RecordExist;
    procedure AddProcedure_MasterBeforePost;
    procedure AddProcedure_ClearNormalizeList;
    procedure AddProcedure_MergeList;
    function get_procedure_for_update_itemsn:string;
    procedure AddProcedure_for_outgoing_list;
    procedure AddProcedure_UpdateItemSN;
    procedure AddProcedure_Initialization;
    procedure Add_Main;
    procedure AddProcedure_Finalization;
    procedure AddProcedure_MasterBeforeInsert;
    procedure AddProcedure_MasterAfterDelete;
    procedure AddProcedure_MasterBeforeDelete;
    procedure AddProcedure_MasterBeforePostAudit;
    procedure AddProcedure_ValidateDetailBatchNoInformation;

    procedure Generate_global_master_dataset_script( masuk:integer; FirstKeyField, DetailDataset: String );
    procedure generate_arinv_script;
    procedure generate_arrefund_script;
    procedure generate_apinv_script;
    procedure generate_apreturn_script;
    procedure generate_job_costing_script;
    procedure generate_item_adjustment_script;
    procedure generate_item_transfer_script;

    procedure generate_detail_dataset_transaction_script( masuk:integer; form_type:TFormName; extra_script:TExtraScriptProcedure=nil );
    procedure generate_outgoing_detail_dataset_transaction_script;
    procedure generate_incoming_detail_dataset_transaction_script;
    procedure generate_item_adjustment_detail_dataset_script;
    procedure generate_apinv_detail_dataset_script;
    procedure generate_item_transfer_detail_dataset_script;
    procedure generate_job_costing_detail_dataset_script;

    function add_code_to_fill_is_masuk_variable_detail_dataset:string;
    procedure add_detail_dataset_constanta;
    procedure add_detail_dataset_variable;
    procedure add_procedure_to_validate_batch_no_required_info;
    procedure add_batch_no_exists_validation;
    procedure is_expired_date_exists_at_current_dataset(form_type:TFormName);
    procedure add_expired_date_validation;
    procedure Setbatch_no_field_name(const Value: string);
    procedure Setexpired_date_field_name(const Value: string);
    procedure Setrequired_batch_no_field_name(const Value: string);
    procedure add_procedure_set_sql_transaction;
    procedure set_item_extended_mapping;
//    procedure prepare_item_reserved;
    procedure save_batch_no_parameters_to_option_table;

    procedure add_is_batch_number_enough_for_auto_fill(form_type:TFormName);
    procedure add_auto_fill_scripts(form_type:TFormName);
    procedure add_do_clear_batch_no_info; // AA, BZ 1754

    procedure generate_do_det_auto_fill_script;
    procedure generate_si_det_auto_fill_script;
    procedure generate_jc_det_auto_fill_script;
    procedure generate_ia_det_auto_fill_script;
    procedure add_is_doing_auto_fill_before_save;
  protected
    have_auto_fill_feature : boolean;
    is_item_adjustment : boolean;
    
    //MMD, BZ 3626 - 3628
    is_item_transfer : boolean;
    is_arinv : boolean;
    is_pr : boolean;
    
    procedure add_before_save_event; virtual;
    procedure add_main_procedure_transaction_script; virtual;
    procedure set_scripting_parameterize; override;
    procedure add_warehouse_field_const;
//    procedure add_batch_field_const;
//    procedure add_expired_date_field_const;
//    procedure add_required_batch_no_field_const;
    procedure add_batch_no_parameter_function;
    procedure add_expired_date_parameter_function;
    procedure add_required_batch_no_parameter_function;
    procedure add_read_option_function;
    function get_auto_fill_quantity_field_name(form_type: TFormName):string;
    procedure add_do_auto_fill_for_all_item(form_type:TFormName); virtual;
    procedure generate_arinv_detail_dataset_script(dataset_type:TFormName);
    procedure CalculateQuantity;
    procedure addVarAutoFillIsPromo(formType:TFormName);
    procedure add_variable_for_auto_fill(form_type:TFormName);
    procedure add_fill_batch_no_information_for_auto_fill(form_type: TFormName); virtual;
    procedure add_collect_data_for_new_record(form_type:TFormName);
    procedure add_fill_data_for_new_record(form_type:TFormName);
    procedure addConditionIsPromo(formType:TFormName);
  public
    procedure setup_database_setting; virtual;
    procedure GenerateScript; override;
    property batch_no_field_name : string read Fbatch_no_field_name write Setbatch_no_field_name;
    property expired_date_field_name : string read Fexpired_date_field_name write Setexpired_date_field_name;
    property required_batch_no_field_name : string read Frequired_batch_no_field_name write Setrequired_batch_no_field_name;
  end;

implementation

Uses
  Language
  , DBConst
  , ReadyToUseSQL
  , ExtendedMappingDataset
  , SNUtility
  , ReadWriteOptions
  , ScriptConst;

{ TDatasetBatchNoInjector }

procedure TDatasetBatchNoInjector.AddMasterDatasetConstanta(FirstKeyField, DetailDataset:String);

  function get_quantity_field_name: string;
  begin
    if is_item_adjustment then begin
      result := 'QtyDifference';
    end
    else begin
      result := 'Quantity';
    end;
  end;

begin
  Script.Add := 'Const';
  Script.Add := '  TOKEN = '';'';   ';
  Script.Add := '  KURANG = -1;        ';
  Script.Add := '  TAMBAH = 1;         ';
  Script.Add := '  ITEMNO  = 1;        ';
  Script.Add := '  BATCHNO = 2;        ';
  Script.Add := '  QTY     = 3;        ';
  Script.Add := '  EXPDATE = 4;        ';
  Script.Add := '  WHID = 5;           ';
  Script.Add := '  UNIT = 6;           ';
  Script.Add := format('  DetailTableName = ''%s'';', [DetailDataset]);
  Script.Add := format('  DetailFirstKeyField = ''%s'';', [FirstKeyField]);
  Script.Add := format('  DetailQuantityField = ''%s'';', [get_quantity_field_name]);
  add_warehouse_field_const;
  Script.Add := format('  MSG_BATCH_NO_QTY_CANNOT_MINUS = ''%s'';', [MSG_BATCH_NO_QTY_CANNOT_MINUS]);
  Script.Add := format('  MSG_BATCH_NO_QTY_NOT_ENOUGH = ''%s'';', [MSG_BATCH_NO_QTY_NOT_ENOUGH]);
  Script.Add := format( '  MSG_FILL_BATCH_NO_INFORMATION = ''%s'';', [MSG_FILL_BATCH_NO_INFORMATION] );
end;

procedure TDatasetBatchNoInjector.add_global_variable;
begin
  Script.Add := '  is_masuk : boolean;';
  Script.Add := '';
end;

procedure TDatasetBatchNoInjector.add_is_batch_number_enough_for_auto_fill(form_type: TFormName);
begin
  Script.Add := '  function is_batch_number_enough:boolean;';
  Script.Add := '  var';
  Script.Add := '    check_sql : TjbSQL;';
  Script.Add := '    available_qty : currency;';
  Script.Add := '    used_bn_qty : currency;';
  Script.Add := '    sql : string;';
  Script.Add := '  begin';
  Script.Add := '    check_sql := CreateSQL(dataset.Tx);';
  Script.Add := '    try';
  Script.Add := '      RunSQL(check_sql,';
  Script.Add := '             Format(''Select coalesce(sum(Quantity),0) as qty from ItemSN '+
                              'where itemno=''''%s''''and WarehouseID=%d and quantity>0'',';
  Script.Add := '                     [dataset.itemno.AsString, dataset.warehouseid.AsInteger]));';
  Script.Add := '      available_qty := check_sql.fieldByName(''qty'');';
  Script.Add := '';
  Script.Add := '      RunSQL(check_sql,';
  Script.Add := '             Format(''Select coalesce(sum(ABS(' + get_auto_fill_quantity_field_name(form_type) + ')),0) as qty from %s '+
                              'where %s=%d and itemno=''''%s'''' and WarehouseID=%d '+
                              'and ABS(' + get_auto_fill_quantity_field_name(form_type) + ')>0 and %s<>'''''''' '',';
  Script.Add := '             [dataset.tableName, dataset.FirstKeyField, dataset.FirstKeyFieldValue'+
                              ', dataset.itemno.AsString, dataset.warehouseid.AsInteger, BatchField]));';
  Script.Add := '      used_bn_qty := check_sql.fieldByName(''qty'');';
  Script.Add := '';
  Script.Add := '      result := ( (available_qty-used_bn_qty) >= ABS(dataset.' + get_auto_fill_quantity_field_name(form_type) + '.AsCurrency) );';
  Script.Add := '    finally';
  Script.Add := '      check_sql.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TDatasetBatchNoInjector.addConditionIsPromo(formType: TFormName);
begin
  if formType in [dnDODet, dnSIDet] then begin
    Script.Add := '        isPromo := 0; ';
    Script.Add := '        if Dataset.Is_Promo.Value then begin ';
    Script.Add := '          isPromo := 1; ';
    Script.Add := '        end; ';
  end;
end;

procedure TDatasetBatchNoInjector.AddFunction_ComposeListContent;
begin
  Script.Add := 'function ComposeListContent(ItemNo, BatchNo:String; Qty:Currency; Warehouseid:integer; ExpiredDate:String=''''; ItemUnit:String=''''):String;';
  Script.Add := 'begin';
  Script.Add := '  result := ItemNo + TOKEN + BatchNo + TOKEN + FloatToStr(Qty) + TOKEN + ExpiredDate + TOKEN + IntToStr(Warehouseid) + TOKEN + ItemUnit;';
  Script.Add := 'end;';
  Script.Add := ' ';
end;

procedure TDatasetBatchNoInjector.AddProcedure_FillList;

  function get_warehouse_field_name:string;
  begin
    if is_item_transfer then begin
      result := 'Format( ''(Select it.FromWHID from WTran it where it.TransferID=d.%s) as %s'', [DETAILFIRSTKEYFIELD, WAREHOUSEFIELD] )';
    end
    else begin
      result := ' ''d.'' + WAREHOUSEFIELD';
    end;
  end;

begin
  Script.Add := 'procedure FillList(list:TStringList);';
  Script.Add := '  function GetDetailSQL:String;';
  Script.Add := '  begin';

  Script.Add := '    result := format(''Select d.ItemNo, COALESCE(d.%s, '''''''')%s, COALESCE(d.%s, '''''''')%s, COALESCE(d.ItemUnit, ''''PCS'''')ItemUnit, %s, ABS(d.%s) ''+ ';
  Script.Add := '                     ''as %s from %s d left outer join item i on i.itemno=d.itemno Where (d.%s=%s) and (i.ItemType=0) and '' + ';
  Script.Add := '                     ''((Select E.%s from extended E where E.Extendedid=i.extendedid)=1) '', ';
  Script.Add := '                [BATCHFIELD, BATCHFIELD, EXPIREDFIELD, EXPIREDFIELD, ' + get_warehouse_field_name + ', DETAILQUANTITYFIELD, DETAILQUANTITYFIELD, ';
  Script.Add := '                 DETAILTABLENAME, DETAILFIRSTKEYFIELD, Dataset.FieldByName(DETAILFIRSTKEYFIELD).asString, REQUIREDBATCHNOFIELD]);';

  Script.Add := '  end;';
  Script.Add := ' ';
  Script.Add := '  function NotNullDate(data:Variant):String; ';
  Script.Add := '  begin ';
  Script.Add := '    if Data = null then begin';
  Script.Add := '      result := ''''; ';
  Script.Add := '     end ';
  Script.Add := '     else begin';
  Script.Add := '       result := ( VarToStr( data ) ); ';
  Script.Add := '     end;';
  Script.Add := '  end; ';
  Script.Add := ' ';
  Script.Add := 'begin';
  Script.Add := '  //putar di detail: masukkan itemno, BN, ED, WarehouseID & Qty ke list;';
  Script.Add := '  List.Clear;';
  Script.Add := '  RunSQL( sql, GetDetailSQL);';
  Script.Add := '                                                       ';
  Script.Add := '  while not sql.EOF do begin                           ';
  Script.Add := '    List.Add( ComposeListContent( sql.FieldByName(''ItemNo''), sql.FieldByName(BATCHFIELD), ';
//  Script.Add := '      sql.FieldByName(DetailQuantityField), Sql.FieldByName(WAREHOUSEFIELD), VarToStr(sql.FieldByName(EXPIREDFIELD)) ) );';
  Script.Add := '      sql.FieldByName(DetailQuantityField), Sql.FieldByName(WAREHOUSEFIELD), ';
  Script.Add := '      NotNullDate(sql.FieldByName(EXPIREDFIELD)), sql.FieldByName(''ItemUnit'') ) );';
  Script.Add := '    sql.Next;                                          ';
  Script.Add := '  end;                                                 ';
  Script.Add := 'end;                                                   ';
  Script.Add := '                                                       ';
end;

procedure TDatasetBatchNoInjector.AddFunction_Get;
begin
  Script.Add := 'function GetItemNo(Data:String):String;                ';
  Script.Add := 'begin                                                  ';
  Script.Add := '  result := GetToken(Data, TOKEN, ITEMNO);             ';
  Script.Add := 'end;                                                   ';
  Script.Add := '                                                       ';
  Script.Add := 'function GetBatchNo(Data:String):String;               ';
  Script.Add := 'begin                                                  ';
  Script.Add := '  result := GetToken(Data, TOKEN, BATCHNo);            ';
  Script.Add := 'end;                                                   ';
  Script.Add := '                                                       ';
  Script.Add := 'function GetQty(Data:String):Currency;                 ';
  Script.Add := 'begin                                                  ';
  Script.Add := '  result := StrToFloat(GetToken(Data, TOKEN, QTY) );   ';
  Script.Add := 'end;                                                   ';
  Script.Add := '                                                       ';
  Script.Add := 'function GetExpiredDate(Data:String):String;           ';
  Script.Add := 'begin                                                  ';
  Script.Add := '  result := GetToken(Data, TOKEN, EXPDATE);            ';
  Script.Add := 'end;                                                   ';
  Script.Add := '                                                       ';
  Script.Add := 'function GetWarehouseId(Data:String):Integer;          ';
  Script.Add := 'begin                                                  ';
  Script.Add := '  result := StrToInt(GetToken(Data, TOKEN, WhId));     ';
  Script.Add := 'end;                                                   ';
  Script.Add := '                                                       ';
  Script.Add := 'function GetUnit(Data:String):String; ';
  Script.Add := 'begin ';
  Script.Add := '  result := GetToken(Data, TOKEN, UNIT);               ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function GetRatio(Data:String):Currency; '; // AA, BZ 3122
  Script.Add := 'var sql_ratio : TjbSQL; ';
  Script.Add := '    item_no   : String; ';
  Script.Add := '    Item_unit : String; ';
  Script.Add := 'begin ';
  Script.Add := '  result := 1; ';
  Script.Add := '  item_no := GetToken( Data, TOKEN, 1 ); ';
  Script.Add := '  item_unit := GetUnit(Data); ';
  Script.Add := '  sql_ratio := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sql_ratio, Format(''Select COALESCE(i.Ratio2, 0)Ratio2, COALESCE(i.Ratio3, 0)Ratio3, ''+ ';
  Script.Add := '      ''COALESCE(i.Unit2, ''''-'''')Unit2, COALESCE(i.Unit3, ''''-'''')Unit3 from Item i where i.ItemNo=''''%s'''' '',[ item_no ]) ); ';
  Script.Add := '    if sql_ratio.FieldByName(''Unit2'') = item_unit then begin ';
  Script.Add := '      result := sql_ratio.FieldByName(''Ratio2''); ';
  Script.Add := '    end ';
  Script.Add := '    else if sql_ratio.FieldByName(''Unit3'') = item_unit then begin ';
  Script.Add := '      result := sql_ratio.FieldByName(''Ratio3''); ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    sql_ratio.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TDatasetBatchNoInjector.AddFunction_RecordExist;
begin
  Script.Add := 'function RecordExist( data:String; var Qty:Currency ):Boolean;';
  Script.Add := 'begin                                                  ';
  Script.Add := '  Qty := 0;                                            ';
  Script.Add := '  RunSQL( sql, ''Select isn.Quantity from ItemSN isn where isn.ItemNo=:ItemNo and isn.warehouseid=:WareId and isn.SN=:BN '', false );';
  Script.Add := '  sql.SetParam(0, GetItemNo( Data )); ';
  Script.Add := '  sql.SetParam(1, GetWarehouseId( Data )); ';
  Script.Add := '  sql.SetParam(2, GetBatchNo( Data ));';
  Script.Add := '  sql.ExecQuery;';
  Script.Add := '  result := (sql.RecordCount = 1);                       ';
  Script.Add := '  if result then begin                                 ';
  Script.Add := '    Qty := sql.FieldByName(''Quantity'');          ';
  Script.Add := '  end;                                                 ';
  Script.Add := 'end;                                                   ';
  Script.Add := '                                                       ';
end;

procedure TDatasetBatchNoInjector.AddFunction_IsExistInList;
begin
  Script.Add := 'Function IsExistInList(List:TStringList; ItemNO, BatchNo:String; var index:Integer;warehouseid:integer; Unit:String):Boolean;';
  Script.Add := 'var i:Integer;                                         ';
  Script.Add := 'begin                                                  ';
  Script.Add := '  result := false;                                     ';
  Script.Add := '  for i:=0 to List.Count-1 do begin                    ';
  Script.Add := '    if (GetItemNo(List[i]) = ItemNo) and (GetWarehouseId(List[i])=warehouseid) and (GetBatchNo(List[i]) = BatchNo) and ';
  Script.Add := '      (GetUnit(List[i]) = Unit) then begin';
  Script.Add := '      index := i;                                      ';
  Script.Add := '      result := true;                               ';
  Script.Add := '      break;                                        ';
  Script.Add := '    end;                                            ';
  Script.Add := '  end;                                                 ';
  Script.Add := 'end;                                                   ';
  Script.Add := '                                                       ';
  Script.Add := '                                                       ';
end;

procedure TDatasetBatchNoInjector.AddProcedure_MergeList;
begin
  Script.Add := 'procedure MergeList(MinusList, PlusList, UpdateList:TStringList);';
  Script.Add := 'var i:Integer;                                                   ';
  Script.Add := '    index:Integer;                                               ';
{  Script.Add := '	                                                          ';
  Script.Add := '  function UpdatedQty(CurrentQty:Currency):Currency;             ';
  Script.Add := '  begin                                                          ';
  Script.Add := '    result := CurrentQty - GetQty(MinusList[i]) ;                ';
  Script.Add := '  end;                                                           ';
  Script.Add := '                                                                 ';
  Script.Add := 'begin                                                            ';
  Script.Add := '  UpdateList.Clear;                                              ';
  Script.Add := '  for i:= 0 to PlusList.Count-1 do begin                         ';
  Script.Add := '    UpdateList.add( PlusList[i] );                               ';
  Script.Add := '  end;                                                           ';
  Script.Add := '                                                                 ';

  Script.Add := '  for i:=0 to MinusList.Count-1 do begin                         ';
  Script.Add := '    if IsExistInList(UpdateList, GetItemNo(MinusList[i]), GetBatchNo(MinusList[i]), index, GetWarehouseID(MinusList[i])) then begin';
  Script.Add := '      if GetItemNo(MinusList[i]) <> GetItemNo(UpdateList[index]) then begin';
  Script.Add := '	    RaiseException(''Function IsExistInList salah'');       ';
  Script.Add := '      end;                                                    ';
  Script.Add := '      UpdateList[index] := ComposeListContent( GetItemNo(UpdateList[index]), ';
  Script.Add := '                                               GetBatchNo(UpdateList[index]), ';
  Script.Add := '                                               UpdatedQty(GetQty(UpdateList[index])), ';
  Script.Add := '                                               GetWarehouseID(UpdateList[index]),';
  Script.Add := '                                               GetExpiredDate(UpdateList[index]));';
  Script.Add := '    end                                                       ';
  Script.Add := '    else begin                                                ';
  Script.Add := '      UpdateList.Add( ComposeListContent( GetItemNo(MinusList[i]), ';
  Script.Add := '                                          GetBatchNo(MinusList[i]),';
  Script.Add := '                                          UpdatedQty(0), ';
  Script.Add := '                                          GetWarehouseID(MinusList[i]),';
  Script.Add := '                                          GetExpiredDate(MinusList[i])));';
  Script.Add := '    end;                                                      ';
  Script.Add := '  end;                                                           ';
}
  // AA, BZ 1516
  Script.Add := 'begin';
  Script.Add := '  UpdateList.Clear;';
  Script.Add := '  for i:= 0 to PlusList.Count-1 do begin';
  Script.Add := '    if IsExistInList(UpdateList, GetItemNo(PlusList[i]), GetBatchNo(PlusList[i]), index, GetWarehouseID(PlusList[i]), GetUnit(PlusList[i])) then begin';
  Script.Add := '      UpdateList[index] := ComposeListContent( GetItemNo(UpdateList[index]), ';
  Script.Add := '                                               GetBatchNo(UpdateList[index]), ';
  Script.Add := '                                               (GetQty(UpdateList[index])+GetQty(PlusList[i])), ';
  Script.Add := '                                               GetWarehouseID(UpdateList[index]),';
  Script.Add := '                                               GetExpiredDate(UpdateList[index]),';
  Script.Add := '                                               GetUnit(UpdateList[index]));';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      UpdateList.add( PlusList[i] );';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  for i:=0 to MinusList.Count-1 do begin';
  Script.Add := '    if IsExistInList(UpdateList, GetItemNo(MinusList[i]), GetBatchNo(MinusList[i]), index, GetWarehouseID(MinusList[i]), GetUnit(MinusList[i])) then begin';
  Script.Add := '      UpdateList[index] := ComposeListContent( GetItemNo(UpdateList[index]), ';
  Script.Add := '                                               GetBatchNo(UpdateList[index]), ';
  Script.Add := '                                               (GetQty(UpdateList[index])-GetQty(MinusList[i])), ';
  Script.Add := '                                               GetWarehouseID(UpdateList[index]),';
  Script.Add := '                                               GetExpiredDate(UpdateList[index]),';
  Script.Add := '                                               GetUnit(UpdateList[index]));';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      UpdateList.Add( ComposeListContent( GetItemNo(MinusList[i]), ';
  Script.Add := '                                          GetBatchNo(MinusList[i]),';
  Script.Add := '                                          (-GetQty(MinusList[i])), ';
  Script.Add := '                                          GetWarehouseID(MinusList[i]),';
  Script.Add := '                                          GetExpiredDate(MinusList[i]),';
  Script.Add := '                                          GetUnit(MinusList[i])));';
  Script.Add := '    end;                                                      ';
  Script.Add := '  end;';
  Script.Add := 'end;                                                             ';
  Script.Add := '                                                                 ';
end;

procedure TDatasetBatchNoInjector.AddProcedure_UpdateItemSN;
begin
  Script.Add := EmptyStr;
  Script.Add := 'procedure ExecuteItemSNModification(sql : TjbSQL; UpdatedList: TStringList; Qty : Currency; IsNormalize : Boolean = False);';
  Script.Add := 'var';
  Script.Add := '  idx     : Integer;';
  Script.Add := '  listIdx : Integer;';

  Script.Add := EmptyStr;
  Script.Add := '  function GetItemSNQuantity : string;';
  Script.Add := '  var';
  Script.Add := '    QtyItemSN : Currency;';
  Script.Add := '  begin';
  Script.Add := '    QtyItemSN := GetQty(Updatedlist[listIdx]) * GetRatio(Updatedlist[listIdx]);';
  Script.Add := '    if IsNormalize then begin';
  Script.Add := '      QtyItemSN := -QtyItemSN;';
  Script.Add := '    end;';
  Script.Add := '    Result := CurrToStrSQL(QtyItemSN);';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  function UpdateSQL : String;';
  Script.Add := '  begin';
//  Script.Add := '    result := format(''Update ItemSN set Quantity = Quantity + %f '', [ GetQty(Updatedlist[listIdx]) ] );';
  Script.Add := '    result := format(''Update ItemSN set Quantity = Quantity + %s '' '+
                               ', [GetItemSNQuantity]);';
//  Script.Add := '    if is_masuk then result := result + '', ExpiredDate=:ED '';';
  Script.Add := '    if is_masuk then begin';
  Script.Add := '      result := result + Format( '', ExpiredDate=''''%s'''' '', [GetExpiredDate( UpdatedList[listIdx] )] );';
  Script.Add := '    end;';
  Script.Add := '    result := result + ''Where ItemNo=:ItemNo and WarehouseID=:d and SN=:BN '';';
  Script.Add := '  end;';

  Script.Add := 'begin';
  Script.Add := '  for listIdx := 0 to UpdatedList.Count - 1 do begin';
  Script.Add := '    if RecordExist( Updatedlist[listIdx], Qty ) then begin';
//  Script.Add := '      If ( ( Qty+GetQty( UpdatedList[listIdx] ) )<0 ) then begin ';
//  Script.Add := '        RaiseException( Format( MSG_BATCH_NO_QTY_NOT_ENOUGH, [GetItemNo(Updatedlist[listIdx]), GetBatchNo(Updatedlist[listIdx])] ) );';
//  Script.Add := '      end;';
  Script.Add := '      RunSQL( sql, UpdateSQL, false );';
  Script.Add := '      idx := 0;';
//  Script.Add := '      if is_masuk then begin';
//  Script.Add := '        sql.SetParam(idx, StrSQLToDate( GetExpiredDate(UpdatedList[listIdx]) ));';
//  Script.Add := '        inc(idx);';
//  Script.Add := '      end;';
  Script.Add := '      sql.SetParam(idx, GetItemNo(Updatedlist[listIdx]));';
  Script.Add := '      inc(idx);';
  Script.Add := '      sql.SetParam(idx, GetWarehouseID(Updatedlist[listIdx]));';
  Script.Add := '      inc(idx);';
  Script.Add := '      sql.SetParam(idx, GetBatchNo(Updatedlist[listIdx]));';
  Script.Add := '    end';
  Script.Add := '    else begin';
//  Script.Add := '      If ( GetQty( UpdatedList[listIdx] )<0 ) then begin';
//  Script.Add := '        RaiseException( Format( MSG_BATCH_NO_QTY_CANNOT_MINUS, [GetItemNo(Updatedlist[listIdx]), GetBatchNo(Updatedlist[listIdx])] ) );';
//  Script.Add := '      end;';
//  Script.Add := '      RunSQL( format(''Insert into ItemSN (ItemNo, SN, Quantity, ExpiredDate, WarehouseID) values (:ItemNo, :BN, %f, :ED, :WHID)'',';
//  Script.Add := '     [GetQty(Updatedlist[listIdx]) ]), false);';
  Script.Add := '      RunSQL( sql, format(''Insert into ItemSN (ItemNo, SN, Quantity, ExpiredDate, WarehouseID) values (:ItemNo, :BN, %s, ''''%s'''', :WHID)'',';
  Script.Add := '	    [CurrToStrSQL( GetQty(Updatedlist[listIdx])*GetRatio(Updatedlist[listIdx]) ), GetExpiredDate(UpdatedList[listIdx]) ]), false);';
  Script.Add := '      sql.SetParam(0, GetItemNo(Updatedlist[listIdx]));';
  Script.Add := '      sql.SetParam(1, GetBatchNo(Updatedlist[listIdx]));';
//  Script.Add := '      sql.SetParam(2, StrSQLToDate( GetExpiredDate(UpdatedList[listIdx]) ));';
//  Script.Add := '      sql.SetParam(3, GetWarehouseID(UpdatedList[listIdx]));';
  Script.Add := '      sql.SetParam(2, GetWarehouseID(UpdatedList[listIdx]));';
  Script.Add := '    end;';
  Script.Add := '    sql.ExecQuery;';

  //SCY LOG
//  Script.Add := '    AssignFileText(ExtractFilePath(Application.ExeName) + ''log.txt'', ''=========='' + #13#10 '+
//                '    + FormatDateTime( ''yyyy-mm-dd hh:mm:ss'', Now) + #13#10 '+
//                '    + sql.SQL.Text + #13#10 '+
//                '    + ''Item No : '' + GetItemNo(Updatedlist[listIdx]) + #13#10 '+
//                '    + ''Batch No : '' + GetBatchNo(Updatedlist[listIdx]) + #13#10 '+
//                '    + ''Warehouse ID : '' + IntToStr(GetWarehouseID(UpdatedList[listIdx]) ) );';
  //
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := EmptyStr;
  Script.Add := 'procedure UpdateItemSN( before_list, after_list, NormalizeList : TStringList);';
  Script.Add := 'var';
  Script.Add := '  UpdatedList : TStringList;';
  Script.Add := '  Qty         : Currency;';
  Script.Add := '  NormalIdx   : Integer;';

  Script.Add := EmptyStr;
  Script.Add := '  procedure ValidateUpdateList;';
  Script.Add := '  var';
  Script.Add := '    recordIdx : Integer;';
  Script.Add := '  begin';
  Script.Add := '    for recordIdx:=0 to UpdatedList.Count - 1 do begin';
  Script.Add := '      if RecordExist( Updatedlist[recordIdx], Qty ) then begin';
  Script.Add := '        If ( ( Qty+ ( GetQty(Updatedlist[recordIdx])*GetRatio(Updatedlist[recordIdx]) ) )<0 ) then begin';
  Script.Add := '          RaiseException( Format( MSG_BATCH_NO_QTY_NOT_ENOUGH, [GetItemNo(Updatedlist[recordIdx]), GetBatchNo(Updatedlist[recordIdx])] ) );';
  Script.Add := '        end;';
  Script.Add := '      end';
  Script.Add := '      else begin';
  Script.Add := '        If ( GetQty( UpdatedList[recordIdx] )<0 ) then begin';
  Script.Add := '          RaiseException( Format( MSG_BATCH_NO_QTY_CANNOT_MINUS, [GetItemNo(Updatedlist[recordIdx]), GetBatchNo(Updatedlist[recordIdx])] ) );';
  Script.Add := '        end;';
  Script.Add := '      end;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  procedure SetUpdateList;';
  Script.Add := '  begin';
  Script.Add := '    if is_masuk then begin';
  Script.Add := '      MergeList(before_list, after_list, UpdatedList);';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      MergeList(after_list, before_list, UpdatedList);';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := 'begin';
  Script.Add := '  ExecuteItemSNModification(sql, NormalizeList, Qty, True);';  //SCY BZ 3311    
  Script.Add := '  UpdatedList := TStringList.Create;';
  Script.Add := '  try';
  Script.Add := '    SetUpdateList;';

  // AA, BZ 1219
  Script.Add := '    ValidateUpdateList;';
  Script.Add := '    NormalizeList.Text := UpdatedList.Text;';  //SCY BZ 3311
  Script.Add := '    ExecuteItemSNModification(sql, UpdatedList, Qty);';
  Script.Add := '  finally';
  Script.Add := '    UpdatedList.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
end;

procedure TDatasetBatchNoInjector.AddProcedure_ClearNormalizeList;  //SCY BZ 3311
begin
  Script.Add := EmptyStr;
  Script.Add := 'procedure ClearNormalizeList;';
  Script.Add := 'begin';
  if is_item_transfer then begin
//    Script.Add := '  NormalizeInList.Clear;';
//    Script.Add := '  NormalizeOutList.Clear;';
    Script.Add := '  NormalizeListDestinationWh.Clear;';
    Script.Add := '  NormalizeListSourceWh.Clear;';
  end
  else begin
    Script.Add := '  NormalizeList.Clear;';
  end;  
  Script.Add := 'end;';

end;

function TDatasetBatchNoInjector.add_code_to_fill_is_masuk_variable: string;
begin
  if is_item_adjustment then begin
    result := '  is_masuk := ( Dataset.ADJCHECK.AsBoolean );';
  end
  else begin
    result := '  is_masuk := ( MASUK=1 );';
  end;
end;

{procedure TDatasetBatchNoInjector.AddProcedure_for_outgoing_list;
begin
  if ( is_item_transfer ) then begin
    Script.Add := 'procedure generate_outgoing_list_from_old_list;';
    Script.Add := '// every batch no at oldList is considered as incoming qty to source warehouse and and outgoing qty from destination warehouse';
    Script.Add := 'var';
    Script.Add := '  idx : integer;';
    Script.Add := 'begin';
    Script.Add := '  before_edit_list.clear;';
    Script.Add := '  For idx:=0 to OldList.count-1 do begin';
    Script.Add := '    before_edit_list.Add( ComposeListContent( GetItemNo(OldList[idx]), GetBatchNo(OldList[idx]), GetQty(OldList[idx]), ';
    Script.Add := '      dataset.FieldByName(''ToWHID'').AsInteger, '''', GetUnit(OldList[idx]) ) );';
    Script.Add := '    before_edit_list.Add( ComposeListContent( GetItemNo(OldList[idx]), GetBatchNo(OldList[idx]), -GetQty(OldList[idx]), ';
    Script.Add := '      dataset.FieldByName(''FromWHID'').AsInteger, '''', GetUnit(OldList[idx]) ) );';
    Script.Add := '  end;';
    Script.Add := 'end;';
    Script.Add := '  ';
    Script.Add := 'procedure do_item_transfer_updateItemSN;';
    Script.Add := 'var';
    Script.Add := '  out_list : TStringList;';
    Script.Add := '  in_list : TStringList;';
    Script.Add := '  empty_list : TStringList;';
    Script.Add := '  ';
    Script.Add := '  procedure generate_outgoing_list_from_new_list;';
    Script.Add := '  // processed before_edit_list and newList as outgoing qty from source warehouse';
    Script.Add := '  var';
    Script.Add := '    idx : integer;';
    Script.Add := '  begin';
    Script.Add := '    For idx:=0 to before_edit_list.count-1 do begin';
    Script.Add := '      out_list.Add( before_edit_list[idx] );';
    Script.Add := '    end;';
    Script.Add := '';
    Script.Add := '    For idx:=0 to NewList.count-1 do begin';
    Script.Add := '      out_list.Add( NewList[idx] );';
    Script.Add := '    end;';
    Script.Add := '  end;';
    Script.Add := '  ';
    Script.Add := '  procedure process_outgoing_qty_from_source_warehouse;';
    Script.Add := '  begin';
    Script.Add := '    out_list := TStringList.Create;';
    Script.Add := '    generate_outgoing_list_from_new_list;';
    Script.Add := '    updateItemSN( empty_list, out_list, NormalizeOutList );';
    Script.Add := '  end;';
    Script.Add := '  ';
    Script.Add := '  procedure generate_incoming_list;';
    Script.Add := '  var ';
    Script.Add := '    idx : integer;';
    Script.Add := '    i_item_no : string;';
    Script.Add := '    i_batch_no : string;';
    Script.Add := '  begin';
    Script.Add := '    in_list := TStringList.Create;';
    Script.Add := '    For idx:=0 to NewList.count-1 do begin';
    Script.Add := '      i_item_no := GetItemNo( NewList[idx] );';
    Script.Add := '      i_batch_no := GetBatchNo( NewList[idx] );';
    Script.Add := '      RunSQL( sql, ''Select isn.ExpiredDate from ItemSN isn where isn.itemno=:itemno and isn.sn=:batchNo'', False );';
    Script.Add := '      sql.SetParam( 0, i_item_no );';
    Script.Add := '      sql.SetParam( 1, i_batch_no );';
    Script.Add := '      sql.ExecQuery;';
//    Script.Add := '      in_list.Add( ComposeListContent( i_item_no, i_batch_no, GetQty(NewList[idx]), dataset.FieldByName(''ToWHID'').AsInteger, VarToStr(sql.FieldByName(''ExpiredDate'')) ) );';
    Script.Add := '      in_list.Add( ComposeListContent( i_item_no, i_batch_no, GetQty(NewList[idx]), dataset.FieldByName(''ToWHID'').AsInteger, ';
    Script.Add := '        DateToStrSQL(sql.FieldByName(''ExpiredDate'')), GetUnit(NewList[idx]) ) );';
    Script.Add := '    end;';
    Script.Add := '  end;';
    Script.Add := '  ';
    Script.Add := '  procedure process_incoming_qty_to_destination_warehouse;';
    Script.Add := '  begin';
    Script.Add := '    Try';
    Script.Add := '      generate_incoming_list;';
    Script.Add := '      is_masuk := True;';
    Script.Add := '      updateItemSN( empty_list, in_list, NormalizeInList );';
    Script.Add := '    Finally';
    Script.Add := '      is_masuk := False;';
    Script.Add := '    End;';
    Script.Add := '  end;';
    Script.Add := '  ';
    Script.Add := 'begin';
    Script.Add := '  out_list := nil;';
    Script.Add := '  in_list := nil;';
    Script.Add := '  empty_list := nil;';
    Script.Add := '  Try';
    Script.Add := '    empty_list := TStringList.Create;';
    Script.Add := '    process_outgoing_qty_from_source_warehouse;';
    Script.Add := '    process_incoming_qty_to_destination_warehouse;';
    Script.Add := '  Finally';
    Script.Add := '    empty_list.Free;';
    Script.Add := '    in_list.Free;';
    Script.Add := '    out_list.Free;';
    Script.Add := '  End;';
    Script.Add := 'end;';
  end;
end;}

procedure TDatasetBatchNoInjector.AddProcedure_for_outgoing_list;
begin
  if ( is_item_transfer ) then begin
    Script.Add := 'procedure expandOldListWithTwoWarehouse;';
    Script.Add := 'var';
    Script.Add := '  idx : integer;';
    Script.Add := '  itemNo : String;';
    Script.Add := '  batchNo : String;';
    Script.Add := '  qty : currency;';
    Script.Add := '  expiredDate : String;';
    Script.Add := '  itemUnit : String;';
    Script.Add := '  sourceWhId : Integer;';
    Script.Add := '  destinationWhId : Integer;';
    Script.Add := 'begin';
    Script.Add := '  oldListSourceWh.clear;';
    Script.Add := '  oldListDestinationWh.clear;';
    Script.Add := '  sourceWhId := dataset.FieldByName(''FromWHID'').AsInteger;';
    Script.Add := '  destinationWhId := dataset.FieldByName(''ToWHID'').AsInteger;';
    Script.Add := '  For idx:=0 to OldList.count-1 do begin';
    Script.Add := '    itemNo := GetItemNo(OldList[idx]);';
    Script.Add := '    batchNo := GetBatchNo(OldList[idx]);';
    Script.Add := '    qty := GetQty(OldList[idx]);';
    Script.Add := '    expiredDate := GetExpiredDate(OldList[idx]);';
    Script.Add := '    itemUnit := GetUnit(OldList[idx]);';
    Script.Add := '    oldListSourceWh.Add( ComposeListContent( itemNo, batchNo, qty, sourceWhId, expiredDate, itemUnit ) );';
    Script.Add := '    oldListDestinationWh.Add( ComposeListContent( itemNo, batchNo, qty, destinationWhId, expiredDate, itemUnit ) );';
    Script.Add := '  end;';
    Script.Add := 'end;';
    Script.Add := '';
    Script.Add := 'procedure do_item_transfer_updateItemSN;';
    Script.Add := 'var';
    Script.Add := '  itemListSourceWh : TStringList;';
    Script.Add := '  itemlistDestinationWh : TStringList;';
    Script.Add := '  empty_list : TStringList;';
    Script.Add := '  ';
    Script.Add := '  procedure processSourceWarehouse;';
    Script.Add := '  begin';
    Script.Add := '    itemListSourceWh.clear;';
    Script.Add := '    mergeList(oldListSourceWh, newList, itemListSourceWh);';
    Script.Add := '    updateItemSN( empty_list, itemListSourceWh, NormalizeListSourceWh );';
    Script.Add := '  end;';
    Script.Add := '';
    Script.Add := '  procedure processDestinationWarehouse;';
    Script.Add := '  var';
    Script.Add := '    oldValue : Boolean;';
    Script.Add := '    newListDestinationWh : TStringList;';
    Script.Add := '    idx : integer;';
    Script.Add := '    itemData : String;';
    Script.Add := '    destinationWhId : Integer;';
    Script.Add := '  begin';
    Script.Add := '    oldValue := is_masuk;';
    Script.Add := '    destinationWhId := dataset.FieldByName(''ToWHID'').AsInteger;';
    Script.Add := '    newListDestinationWh := TStringList.create;';
    Script.Add := '    Try';
    Script.Add := '      For idx:=0 to NewList.count-1 do begin';
    Script.Add := '        itemData := NewList[idx];';
    Script.Add := '        newListDestinationWh.Add( ComposeListContent(GetItemNo(itemData), GetBatchNo(itemData), GetQty(itemData), destinationWhId, GetExpiredDate(itemData), GetUnit(itemData)) );';
    Script.Add := '      end;';
    Script.Add := '      itemListDestinationWh.clear;';
    Script.Add := '      mergeList(oldListDestinationWh, newListDestinationWh, itemListDestinationWh);';
    Script.Add := '      is_masuk := True;';
    Script.Add := '      updateItemSN( empty_list, itemListDestinationWh, NormalizeListDestinationWh );';
    Script.Add := '    Finally';
    Script.Add := '      newListDestinationWh.free;';
    Script.Add := '      is_masuk := oldValue;';
    Script.Add := '    End;';
    Script.Add := '  end;';
    Script.Add := '  ';
    Script.Add := 'begin';
    Script.Add := '  itemListSourceWh := nil;';
    Script.Add := '  itemlistDestinationWh := nil;';
    Script.Add := '  empty_list := nil;';
    Script.Add := '  Try';
    Script.Add := '    itemListSourceWh := TStringList.Create;';
    Script.Add := '    itemlistDestinationWh := TStringList.Create;';
    Script.Add := '    empty_list := TStringList.Create;';
    Script.Add := '    processSourceWarehouse;';
    Script.Add := '    processDestinationWarehouse;'; // AA, BZ 3961
    Script.Add := '  Finally';
    Script.Add := '    empty_list.Free;';
    Script.Add := '    itemlistDestinationWh.Free;';
    Script.Add := '    itemListSourceWh.Free;';
    Script.Add := '  End;';
    Script.Add := 'end;';
  end;
end;

function TDatasetBatchNoInjector.get_auto_fill_quantity_field_name(form_type: TFormName): string;
begin
  case form_type of
    dnDODet, dnSIDet, dnJCDet :
      begin
        result := 'Quantity';
      end;
    dnIADet :
      begin
        result := 'QtyDifference';
      end;
  end;
end;

function TDatasetBatchNoInjector.get_procedure_for_update_itemsn: string;
begin
  if is_item_transfer then begin
    result := '  do_item_transfer_updateItemSN;';
  end
  else begin
    result := '  UpdateItemSN( OldList, NewList, NormalizeList );';
  end;
end;

procedure TDatasetBatchNoInjector.AddProcedure_Initialization;
begin
  Script.Add := 'procedure DoInitialization;';
  Script.Add := 'begin';
  Script.Add := '    OldList          := TStringList.Create;';
  Script.Add := '    NewList          := TStringList.Create;';
  if is_item_transfer then begin
//    Script.Add := '    NormalizeInList  := TStringList.Create;';
//    Script.Add := '    NormalizeOutList := TStringList.Create;';
    Script.Add := '    NormalizeListDestinationWh  := TStringList.Create;';
    Script.Add := '    NormalizeListSourceWh := TStringList.Create;';
  end
  else begin
    Script.Add := '    NormalizeList    := TStringList.Create;';
  end;
  Script.Add := '    sql              := CreateSQL(TIBTransaction(Dataset.Tx) );';
  if is_item_transfer then begin
//    Script.Add := '    before_edit_list := TStringList.Create;';
    Script.Add := '    oldListSourceWh := TStringList.Create;';
    Script.Add := '    oldListDestinationWh := TStringList.Create;';
  end;
  Script.Add := 'end;';
  Script.Add := EmptyStr
end;

procedure TDatasetBatchNoInjector.AddProcedure_Finalization;
begin
  Script.Add := 'procedure DoFinalization;';
  Script.Add := 'begin';
  if is_item_transfer then begin
//    Script.Add := '  before_edit_list.Free;';
    Script.Add := '  oldListSourceWh.Free;';
    Script.Add := '  oldListDestinationWh.Free;';
  end;
  Script.Add := '  sql.Free;';
  Script.Add := '  OldList.Free;';
  Script.Add := '  NewList.Free;';
  if is_item_transfer then begin
//    Script.Add := '  NormalizeInList.Free;';
//    Script.Add := '  NormalizeOutList.Free;';
    Script.Add := '  NormalizeListDestinationWh.Free;';
    Script.Add := '  NormalizeListSourceWh.Free;';
  end
  else begin
    Script.Add := '  NormalizeList.Free;';
  end;
  Script.Add := 'end;';
  Script.Add := EmptyStr
end;

procedure TDatasetBatchNoInjector.AddProcedure_MasterBeforeInsert;
begin
  Script.Add := 'procedure MasterBeforeInsert;                                                                       ';
  Script.Add := 'begin                                                                                               ';
  Script.Add := '  OldList.Clear;                                                                                    ';
  Script.Add := 'end;                                                                                                ';
  Script.Add := '                                                                                                    ';
end;

procedure TDatasetBatchNoInjector.AddProcedure_MasterBeforeEdit;
begin
  Script.Add := 'procedure MasterBeforeEdit;                            ';
  Script.Add := 'begin                                                  ';
  Script.Add := '  if (Dataset.State in [2, 3]) then exit;              ';
  Script.Add := '  FillList( OldList );                                 ';
  if is_item_transfer then begin
//    Script.Add := ' generate_outgoing_list_from_old_list;';
    Script.Add := ' expandOldListWithTwoWarehouse;';
  end;
  Script.Add := 'end;                                                   ';
  Script.Add := '                                                       ';
end;

procedure TDatasetBatchNoInjector.AddProcedure_MasterBeforePost;
begin
  Script.Add := 'procedure MasterBeforePost;                                                                         ';
  Script.Add := 'begin';
  Script.Add := '  if Dataset.IsFirstPost then exit;                                                                 ';
  Script.Add := '  FillList( NewList );                                                                              ';
  Script.Add := add_code_to_fill_is_masuk_variable;
  Script.Add := get_procedure_for_update_itemsn;
  Script.Add := 'end;                                                                                                ';
  Script.Add := '                                                                                                    ';
end;

procedure TDatasetBatchNoInjector.AddProcedure_MasterBeforeDelete;
begin
  Script.Add := 'procedure MasterBeforeDelete; ';
  Script.Add := 'begin ';
  Script.Add := '  NewList.Clear; ';
  Script.Add := '  MasterBeforeEdit; ';
  Script.Add := add_code_to_fill_is_masuk_variable;
  Script.Add := 'end; ';
end;

procedure TDatasetBatchNoInjector.AddProcedure_MasterAfterDelete;
begin
  Script.Add := 'procedure MasterAfterDelete;';
  Script.Add := 'begin';
  Script.Add := get_procedure_for_update_itemsn;
  Script.Add := 'end;';
  Script.Add := EmptyStr
end;

procedure TDatasetBatchNoInjector.add_procedure_set_sql_transaction;
begin
  Script.Add := 'procedure set_sql_transaction;';
  Script.Add := 'begin';
  Script.Add := '  sql.Database := TIBDatabase( Dataset.DB );';
  Script.Add := '  sql.Transaction := TIBTransaction( Dataset.Tx );';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TDatasetBatchNoInjector.Add_Main;
begin
  Script.Add := EmptyStr;
  Script.Add := 'BEGIN';
  Script.Add := '  Dataset.OnAfterCreateScriptDecorator := @DoInitialization;';
  Script.Add := '  Dataset.OnBeforeDestroyScriptDecorator := @DoFinalization;';
  Script.Add := '  Dataset.OnTxChangeArray := @set_sql_transaction;';
  Script.Add := '  Dataset.OnBeforeInsertArray := @MasterBeforeInsert;';
  Script.Add := '  Dataset.OnBeforeEditArray   := @MasterBeforeEdit;';
  Script.Add := '  Dataset.OnBeforePostArray   := @MasterBeforePost;';
  Script.Add := '  Dataset.OnAfterPostArray    := @ClearNormalizeList;';
  Script.Add := '  Dataset.OnBeforeDeleteArray := @MasterBeforeDelete;';
  Script.Add := '  Dataset.OnAfterDeleteArray  := @MasterAfterDelete;';
  Script.Add := '  Dataset.on_before_save_array := @ClearNormalizeList;';  //MMD, BZ 3401
  if is_arinv or is_apinv or is_item_transfer then begin
    AddProcedure_MasterBeforePostAudit;
  end;
  Script.Add := 'END.';
end;

procedure TDatasetBatchNoInjector.Generate_global_master_dataset_script( masuk:integer; FirstKeyField, DetailDataset:String );
begin
  Script.clear;

  AddMasterDatasetConstanta( FirstKeyField, DetailDataset );
  add_global_constanta( masuk );
  add_master_dataset_variable;

  add_read_option_function;
  add_procedure_set_sql_transaction;
  add_batch_no_parameter_function;
  add_expired_date_parameter_function;
  add_required_batch_no_parameter_function;

  AddProcedure_Initialization;
  AddProcedure_Finalization;

  AddFunction_ComposeListContent;
  AddProcedure_FillList;
  AddFunction_Get;
  AddFunction_RecordExist;
  AddFunction_IsExistInList;
  AddProcedure_MergeList;

  AddProcedure_for_outgoing_list;
  AddProcedure_UpdateItemSN;

  if is_arinv or is_apinv or is_item_transfer then begin
    AddProcedure_ValidateDetailBatchNoInformation;
  end;

  AddProcedure_MasterBeforeEdit;
  AddProcedure_MasterBeforePost;
  AddProcedure_MasterBeforeInsert;
  AddProcedure_MasterAfterDelete;
  AddProcedure_MasterBeforeDelete;
  AddProcedure_ClearNormalizeList;

  Add_Main;
end;

procedure TDatasetBatchNoInjector.generate_apinv_script;
begin
  is_apinv := True;
  Try
    Generate_global_master_dataset_script(1, 'APInvoiceID', 'APItmDet');
  Finally
    reset_transaction_flag;
  End;
end;

procedure TDatasetBatchNoInjector.generate_arinv_script;
begin
  is_arinv := True;
  Try
    Generate_global_master_dataset_script(-1, 'ARInvoiceID', 'ARInvDet' );
  Finally
    reset_transaction_flag;
  End;
end;

procedure TDatasetBatchNoInjector.generate_apreturn_script;
begin
  Generate_global_master_dataset_script(-1, 'APReturnID', 'APRetDet' );
end;

procedure TDatasetBatchNoInjector.generate_arrefund_script;
begin
  Generate_global_master_dataset_script( 1, 'ARRefundID', 'ARRefDet' );
end;

procedure TDatasetBatchNoInjector.generate_jc_det_auto_fill_script;
begin
  add_auto_fill_scripts( dnJCDet );
end;

procedure TDatasetBatchNoInjector.generate_job_costing_detail_dataset_script;
begin
  is_job_costing := True;
  have_auto_fill_feature := True;
  Try
    generate_detail_dataset_transaction_script( -1, dnJCDet, generate_jc_det_auto_fill_script ); // AA, BZ 1908
  Finally
    reset_transaction_flag;
  End;
end;

procedure TDatasetBatchNoInjector.generate_job_costing_script;
begin
  Generate_global_master_dataset_script( -1, 'MFID', 'MFSHTDET' );
end;

procedure TDatasetBatchNoInjector.generate_item_adjustment_script;
begin
  is_item_adjustment := True;
  Try
    Generate_global_master_dataset_script( 0, 'ItemAdjId', 'ITAdjDet' );
  Finally
    reset_transaction_flag;
  End;
end;

procedure TDatasetBatchNoInjector.generate_item_transfer_script;
begin
  is_item_transfer := True;
  Try
    Generate_global_master_dataset_script( -1, 'TRANSFERID', 'WTRANDET' );
  Finally
    reset_transaction_flag;
  End;
end;

procedure TDatasetBatchNoInjector.reset_transaction_flag;
begin
  is_item_adjustment := False;
  is_item_transfer := False;
  is_arinv := False;
  is_apinv := False;
  is_job_costing := False;
  have_auto_fill_feature := False;
end;

procedure TDatasetBatchNoInjector.GenerateScript;

  procedure generate_master_dataset_script;
  begin
    reset_transaction_flag;
    // tranasksi barang masuk
    generate_apinv_script;
    InjectToDB( dnPI );
    InjectToDB( dnRI );

    generate_arrefund_script;
    InjectToDB( dnSR );


    // transaksi barang keluar
    generate_arinv_script;
    InjectToDB( dnSI );
    InjectToDB( dnDO );

    generate_apreturn_script;
    InjectToDB( dnPR );

    generate_job_costing_script;
    InjectToDb( dnJC );


    // transaksi barang masuk ATAU keluar
    generate_item_adjustment_script;
    InjectToDB( dnIA );

    // transaksi barang masuk DAN keluar
    generate_item_transfer_script;
    InjectToDB( dnIT );
  end;

  procedure generate_detail_dataset_script;
  begin
    reset_transaction_flag;

    generate_apinv_detail_dataset_script;
    InjectToDB( dnPIItm );
    InjectToDB( dnRIItm );

    generate_incoming_detail_dataset_transaction_script;
    InjectToDB( dnSRDet );

    generate_arinv_detail_dataset_script( dnDODet );
    InjectToDB( dnDODet );
    generate_arinv_detail_dataset_script( dnSIDet );
    InjectToDB( dnSIDet );

    generate_outgoing_detail_dataset_transaction_script;
    InjectToDB( dnPRDet );

    generate_job_costing_detail_dataset_script;
    InjectToDB( dnJCDet );

    generate_item_transfer_detail_dataset_script;
    InjectToDB( dnITDet );

    generate_item_adjustment_detail_dataset_script;
    InjectToDB( dnIADet );
//    StringListToFile( Script.List, 'D:\bintest\batchNoScript_debug.txt' );
  end;

begin
  reset_transaction_flag;
  
  generate_master_dataset_script;
  generate_detail_dataset_script;
end;

procedure TDatasetBatchNoInjector.add_detail_dataset_constanta;
begin
  Script.Add := 'Const';
  Script.Add := format('  MSG_FILL_BATCH_NO = ''%s'';', [MSG_FILL_BATCH_NO]);
  Script.Add := format('  MSG_FILL_EXPIRED_DATE = ''%s'';', [MSG_FILL_EXPIRED_DATE]);
  Script.Add := format('  MSG_INVALID_EXPIRED_DATE_AT_TRANSACTION = ''%s'';', [MSG_INVALID_EXPIRED_DATE_AT_TRANSACTION]);
  Script.Add := format('  MSG_INVALID_EXPIRED_DATE = ''%s'';', [MSG_INVALID_EXPIRED_DATE]);
end;

procedure TDatasetBatchNoInjector.is_expired_date_exists_at_current_dataset(form_type:TFormName);
begin
  Script.Add := '  procedure validate_expired_date;';
  Script.Add := '  var';
  Script.Add := '    check_sql : TjbSQL;';
  Script.Add := '    select_sql : String;';
  Script.Add := '    item_no : String;';
  Script.Add := '    batch_no : String;';
  Script.Add := '';
  Script.Add := '    Function is_valid_in_current_transaction:boolean;';
  Script.Add := '    begin';
//  Script.Add := '        select_sql := Format( '' Select d.%s from %s d where (d.%s=%s) and (d.seq<>%d) and (d.%s=:batch_no) and (d.%s<>:expired_date) '', ';
//  Script.Add := '        select_sql := Format( '' Select d.%s from %s d where (d.%s=%s) and (d.seq<>%d) and (d.%s=:batch_no) and (d.%s<>''''%s'''') '', ';
  Script.Add := '        select_sql := Format( '' Select d.%s from %s d where (d.%s=%s) and (d.seq<>%d) and (d.itemNo=''''%s'''') and (d.%s=:batch_no) and (d.%s<>''''%s'''') '', '; // AA, BZ  3960
  Script.Add := '                        [EXPIREDFIELD, ';
//  Script.Add := '                         dataset.tablename, dataset.FirstKeyField, VarToStr(dataset.FirstKeyFieldValue), dataset.seq.AsInteger, ';
  Script.Add := '                         dataset.tablename, dataset.FirstKeyField, VarToStr(dataset.FirstKeyFieldValue), dataset.seq.AsInteger, item_no, '; // AA, BZ 3960
//  Script.Add := '                         BATCHFIELD, EXPIREDFIELD] );';
  Script.Add := '                         BATCHFIELD, EXPIREDFIELD, dataset.fieldByName( EXPIREDFIELD ).AsString] );';
  Script.Add := '        check_sql.sql.Add( select_sql );';
  Script.Add := '        check_sql.SetParam( 0, batch_no ); ';
//  Script.Add := '        check_sql.SetParam( 1, dataset.fieldByName( EXPIREDFIELD ).AsString ); ';
  Script.Add := '        check_sql.ExecQuery;';
  Script.Add := '        result := ( check_sql.RecordCount=0 );';
  Script.Add := '    end;';
  Script.Add := '';
  Script.Add := '  begin';
  Script.Add := '    if (dataset.FieldByName(EXPIREDFIELD).AsString='''') then begin ';
  Script.Add := '      RaiseException( MSG_FILL_EXPIRED_DATE );';
  Script.Add := '    end;';
  Script.Add := '';
  Script.Add := '    check_sql := TjbSQL.Create( nil );';
  Script.Add := '    Try';
  Script.Add := '      check_sql.database := TIBDatabase( dataset.DB );';
  Script.Add := '      check_sql.Transaction := TIBTransaction( dataset.Tx );';
  Script.Add := '';
  Script.Add := '      item_no := dataset.itemno.AsString;';
  Script.Add := '      batch_no := dataset.fieldByName( BATCHFIELD ).AsString;';
  Script.Add := '';
  Script.Add := '      if ( is_valid_in_current_transaction ) then begin';
  Script.Add := '        // check at ItemSN table.';
//  Script.Add := '        select_sql := '' Select i.ExpiredDate from ITEMSN i where (i.ItemNo=:item_no) and (i.SN=:batch_no) and (i.ExpiredDate<>:expired_date) and (i.Quantity>0)'';';
//  Script.Add := '        select_sql := Format( ''Select i.ExpiredDate from ITEMSN i where (i.ItemNo=:item_no) and (i.SN=:batch_no) and (i.ExpiredDate<>''''%s'''') and (i.Quantity>0) '' ';
  Script.Add := '        select_sql := Format( ''Select i.ExpiredDate from ITEMSN i where (i.ItemNo=:item_no) and (i.SN=:batch_no) and (i.ExpiredDate<>''''%s'''') '' '; // AA, BZ 3125
{
  if form_type = dnITDet then begin
    Script.Add := '                     ,[dataset.fieldByName( EXPIREDFIELD ).AsString] );';
  end
  else begin
    Script.Add := '                   + '' and i.WarehouseID=%d'' ';
    Script.Add := '                     ,[dataset.fieldByName( EXPIREDFIELD ).AsString, dataset.warehouseid.AsInteger ] );';
  end;
}
  Script.Add := '                     ,[dataset.fieldByName( EXPIREDFIELD ).AsString] );'; // AA, BZ 3977
//  Script.Add := '                        [DateToStrSQL(StrToDate( dataset.fieldByName( EXPIREDFIELD ).AsString ))] );';
  Script.Add := '        check_sql.close;';
  Script.Add := '        check_sql.sql.Clear;';
  Script.Add := '        check_sql.sql.Add( select_sql );';
  Script.Add := '        check_sql.SetParam( 0, item_no ); ';
  Script.Add := '        check_sql.SetParam( 1, batch_no ); ';
//  Script.Add := '        check_sql.SetParam( 2, StrSqlToDate( dataset.fieldByName( EXPIREDFIELD ).AsString ) ); ';
  Script.Add := '        check_sql.ExecQuery;';
  Script.Add := '        if ( check_sql.RecordCount>0 ) then begin';
//  Script.Add := '          RaiseException( Format( MSG_INVALID_EXPIRED_DATE, [item_no, batch_no, FormatDateTime( ''d mmm yyyy'', StrSQLToDate( VarToStr( check_sql.fieldByName( ''ExpiredDate'' ) ) ) )] ) );';
  Script.Add := '          RaiseException( Format( MSG_INVALID_EXPIRED_DATE, [item_no, batch_no, FormatDateTime( ''d mmm yyyy'', check_sql.fieldByName( ''ExpiredDate'' ) )] ) );';
  Script.Add := '        end;';
  Script.Add := '      end';
  Script.Add := '      else begin';
  Script.Add := '        RaiseException( Format( MSG_INVALID_EXPIRED_DATE_AT_TRANSACTION, [item_no, batch_no, FormatDateTime( ''d mmm yyyy'', StrSQLToDate( check_sql.fieldByName( EXPIREDFIELD ) ) )] ) );';
//  Script.Add := '        RaiseException( Format( MSG_INVALID_EXPIRED_DATE_AT_TRANSACTION, [item_no, batch_no, FormatDateTime( ''d mmm yyyy'', StrToDate( check_sql.fieldByName( EXPIREDFIELD ) ) )] ) );';
  Script.Add := '      end;';

  Script.Add := '    Finally';
  Script.Add := '      check_sql.Free;';
  Script.Add := '    End;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TDatasetBatchNoInjector.add_expired_date_validation;
begin
  Script.Add := '';
  Script.Add := '      if is_masuk then begin ';
  Script.Add := '        validate_expired_date;';
  Script.Add := '      end;';
end;

procedure TDatasetBatchNoInjector.CalculateQuantity;
begin
  Script.Add := '    procedure calculate_quantity;';
  Script.Add := '    begin';
  Script.Add := '      if need_qty >= bn_sql.FieldByName(''Quantity'') then begin';
  Script.Add := '        used_qty := bn_sql.FieldByName(''Quantity'');';
  Script.Add := '      end';
  Script.Add := '      else begin';
  Script.Add := '        used_qty := need_qty;';
  Script.Add := '      end;';
  Script.Add := '      need_qty := need_qty - used_qty;';
  Script.Add := '    end;';
  Script.Add := '';
end;

procedure TDatasetBatchNoInjector.add_fill_batch_no_information_for_auto_fill(form_type: TFormName);
begin
  Script.Add := '  procedure fill_batch_no_info;';
  Script.Add := '  var';
  Script.Add := '    bn_sql : TjbSQL;';
  Script.Add := '    bn_field : TField;';
  Script.Add := '    expired_field : TField;';
  Script.Add := '    need_qty : currency;';
  Script.Add := '    used_qty : currency;';
  addVarAutoFillIsPromo( form_type );
  add_variable_for_auto_fill(form_type);
  Script.Add := '';
  add_collect_data_for_new_record(form_type);
  add_fill_data_for_new_record(form_type);
  CalculateQuantity;
  Script.Add := '    procedure do_auto_fill_batch_no_info;';
  Script.Add := '    begin';
  Script.Add := '      calculate_quantity;';
  Script.Add := '      fill_quantity(used_qty);';
  Script.Add := '      bn_field.AsString := bn_sql.FieldByName(''SN'');';
//  Script.Add := '      expired_field.AsString := bn_sql.FieldByName(''ExpiredDate'');';
  Script.Add := '      expired_field.AsString := DateToStrSQL(bn_sql.FieldByName(''ExpiredDate'') );';  //SCY BZ 3289
  Script.Add := '    end;';
  Script.Add := '';
  Script.Add := '  begin';
  Script.Add := '    bn_sql := CreateSQL(dataset.Tx);';
  Script.Add := '    try';
  Script.Add := '      item_no := dataset.ItemNo.AsString;';
  Script.Add := '      wh_id := dataset.warehouseid.AsInteger;';
  Script.Add := '      RunSQL(bn_sql,';
  Script.Add := '             Format( ''Select a.SN, a.ExpiredDate'' +';
  Script.Add := '                     '', (a.Quantity - ''+';
  Script.Add := '                     ''   coalesce((select sum(ABS(d.' + get_auto_fill_quantity_field_name(form_type) + ')) from %s d where ''+';
  Script.Add := '                     ''             d.%s=%d and d.WAREHOUSEID=a.WarehouseID and d.itemno=a.itemno and d.%s=a.SN and d.%s=a.EXPIREDDATE),0)''+';
  Script.Add := '                     ''   ) as quantity ''+';
  Script.Add := '                     ''from ItemSN a ''+';
  Script.Add := '                     ''where a.itemno=''''%s'''' and a.warehouseid=%d and ''+';
  Script.Add := '                     ''( (a.Quantity - ''+';
  Script.Add := '                     ''   coalesce((select sum(ABS(d.' + get_auto_fill_quantity_field_name(form_type) + ')) from %s d where d.%s=%d and d.WAREHOUSEID=a.WarehouseID and d.itemno=a.itemno and d.%s=a.SN and d.%s=a.EXPIREDDATE),0)''+';
  Script.Add := '                     ''   ) > 0 ) ''+';
  Script.Add := '                     ''order by a.expireddate, a.SN'',';
  Script.Add := '                     [dataset.TableName, dataset.FirstKeyField, dataset.FirstKeyFieldValue, BatchField, ExpiredField,';
  Script.Add := '                      item_no, wh_id,';
  Script.Add := '                     dataset.TableName, dataset.FirstKeyField, dataset.FirstKeyFieldValue, BatchField, ExpiredField])';
  Script.Add := '             );';
  Script.Add := '';
  Script.Add := '      if (bn_sql.RecordCount>0) then begin';
  Script.Add := '        collect_data_for_new_record;';
  Script.Add := '';
  Script.Add := '        bn_field := dataset.FieldByName( BatchField );';
  Script.Add := '        expired_field := dataset.FieldByName( ExpiredField );';
  Script.Add := '';
  Script.Add := '        dataset.Edit;';
  Script.Add := '        need_qty := ABS(dataset.' + get_auto_fill_quantity_field_name(form_type) + '.AsCurrency);';
  Script.Add := '        do_auto_fill_batch_no_info;';
  Script.Add := '        dataset.post;';
  Script.Add := '';
  addConditionIsPromo( form_type );
  Script.Add := '        While (need_qty>0) do begin';
  Script.Add := '          bn_sql.next;';
  Script.Add := '          dataset.append;';
  Script.Add := '          fill_new_record_data;';
  Script.Add := '          do_auto_fill_batch_no_info;';
  Script.Add := '          dataset.post;';
  Script.Add := '        end;';
  Script.Add := '';
  Script.Add := '        dataset.locate(''Seq'', current_seq, 0);';
  Script.Add := '      end;';
  Script.Add := '    finally';
  Script.Add := '      bn_sql.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TDatasetBatchNoInjector.add_fill_data_for_new_record(form_type: TFormName);

  function get_quantity_variable_with_sign:string;
  begin
    if (form_type=dnIADet) then begin
      result := '-iquantity'; // auto fill only available at IA Adjust Qty
    end
    else begin
      result := 'iquantity';
    end;
  end;

begin
  Script.Add := '    procedure fill_quantity(iquantity : currency);';
  Script.Add := '    var';
  Script.Add := '      uom_qty1 : string;';
  Script.Add := '      uom_qty2 : string;';
  Script.Add := '      uom_qty3 : string;';
//  Script.Add := '      function is_difference_qty:Boolean; '; //JR, BZ 2247 & 2295
//  Script.Add := '      begin ';
//  Script.Add := Format('        result := iquantity <> Dataset.%s.AsCurrency; ',[ get_auto_fill_quantity_field_name(form_type) ]);
//  Script.Add := '      end; ';
  Script.Add := '    begin';
  Script.Add := '      if is_distribution_variant then begin';
  Script.Add := '        uom_qty1 := ReadOption(''' + STR_UOM_QTY1 + ''', ''' + STR_DEFAULT_UOM_QTY1 + ''');';
  Script.Add := '        uom_qty2 := ReadOption(''' + STR_UOM_QTY2 + ''', ''' + STR_DEFAULT_UOM_QTY2 + ''');';
  Script.Add := '        uom_qty3 := ReadOption(''' + STR_UOM_QTY3 + ''', ''' + STR_DEFAULT_UOM_QTY3 + ''');';
//  Script.Add := '        if is_difference_qty then begin '; //JR, BZ 2247 & 2295
  Script.Add := '          Dataset.ExtendedID.FieldLookUp.fieldByName( uom_qty2 ).AsCurrency := 0; '; // converted to UOM_QTY1
  Script.Add := '          Dataset.ExtendedID.FieldLookUp.fieldByName( uom_qty3 ).AsCurrency := 0; ';
//  Script.Add := '        end; ';
  Script.Add := '        Dataset.ExtendedID.FieldLookUp.fieldByName( uom_qty1 ).AsCurrency := '+ get_quantity_variable_with_sign + ';';
  Script.Add := '        Dataset.' + get_auto_fill_quantity_field_name(form_type) + '.AsCurrency := '+ get_quantity_variable_with_sign + ';'; //JR, BZ 2273 ini perlu di assign untuk keperluan Ritase/Loading.
  Script.Add := '      end';
  Script.Add := '      else begin';
  Script.Add := '        Dataset.' + get_auto_fill_quantity_field_name(form_type) + '.AsCurrency := '+ get_quantity_variable_with_sign + ';';
  Script.Add := '      end;';
  Script.Add := '    end;';
  Script.Add := '';

  if ( form_type in [dnDODet, dnSIDet] ) then begin
    Script.Add := '    procedure fill_price(iprice : currency);';
    Script.Add := '    var';
    Script.Add := '      field_name : string;';
    Script.Add := '    begin';
    Script.Add := '      if is_distribution_variant then begin';
    Script.Add := '        field_name := Dataset.AliasTableName + ReadOption(''' + STR_UOM_UP1 + ''', ''' + STR_DEFAULT_UOM_UP1 + ''');';
    Script.Add := '        Dataset.fieldByName( field_name ).AsCurrency := iprice;';
    Script.Add := '      end';
    Script.Add := '      else begin';
    Script.Add := '        Dataset.brutoUnitPrice.AsCurrency := iprice;';
    Script.Add := '      end;';
    Script.Add := '    end;';
    Script.Add := '';
  end;

  Script.Add := '    procedure fill_new_record_data;';
  Script.Add := '    begin';
  Script.Add := '      Dataset.itemno.AsString := item_no;';
  Script.Add := '      Dataset.warehouseid.Asinteger := wh_id;';
  Script.Add := '      Dataset.DeptId.Asinteger := dept_id;';
  Script.Add := '      Dataset.ProjectId.AsInteger := proj_id;';
  Script.Add := '      Dataset.ItemUnit.AsString := item_unit;';

  if ( form_type in [dnDODet, dnSIDet] ) then begin
    Script.Add := '      if so_id > -1 then begin';
    Script.Add := '        Dataset.soid.Asinteger := so_id;';
    Script.Add := '        Dataset.soseq.AsInteger := so_seq;';
    Script.Add := '      end;';
    Script.Add := '      Dataset.taxCodes.AsString := tax_codes;';
    Script.Add := '      fill_price(bruto_unit_price);';
    Script.Add := '      Dataset.itemDiscPc.AsString := item_disc;';
    Script.Add := '      Dataset.Is_Promo.Value := isPromo; ';
  end;

  Script.Add := '    end;';
  Script.Add := '';
end;

procedure TDatasetBatchNoInjector.add_batch_no_exists_validation;
begin
  Script.Add := '      if ( dataset.FieldByName( BATCHFIELD).AsString='''' ) then begin ';
  Script.Add := '        RaiseException( MSG_FILL_BATCH_NO );';
  Script.Add := '      end;';
end;

procedure TDatasetBatchNoInjector.add_procedure_to_validate_batch_no_required_info;

  procedure add_specific_transaction_code;
  begin
    if is_arinv then begin
//      Script.Add := '       And ( dataset.FieldByName( ''soid'' ).isnull )';
      Script.Add := '       And ( not MasterDataset.isGettingDataFromOther )'; // AA, BZ 3125
      Script.Add := '       And ( not is_doing_auto_fill_before_save )';
    end
    else if is_apinv then begin
//      Script.Add := '       And ( dataset.FieldByName( ''poid'' ).isnull )';
      Script.Add := '       And ( not MasterDataset.isGettingDataFromOther )'; // AA, BZ 3125
    end
    else if is_item_transfer then begin
//      Script.Add := '       And ( dataset.FieldByName( ''reqid'' ).isnull )';
      Script.Add := '       And ( not MasterDataset.isGettingDataFromOther )'; // AA, BZ 3125
    end
    else if is_job_costing then begin
//      Script.Add := '       And ( not is_doing_auto_fill_procedure )';
      Script.Add := '       And ( not MasterDataset.isGettingDataFromOther )'; //MMD, BZ 3632
      Script.Add := '       And ( not is_doing_auto_fill_before_save )';
    end
    else if is_item_adjustment then begin
      Script.Add := '       And (is_masuk OR ';
//      Script.Add := '            ( ( Not is_masuk ) And ( not is_doing_auto_fill_procedure )))';
      Script.Add := '            ( ( Not is_masuk ) And ( not is_doing_auto_fill_before_save )';
      Script.Add := '                               And ( not MasterDataset.isGettingDataFromOther )'; //MMD, BZ 3633
      Script.Add := '            ))';
    end;
  end;

begin
  Script.Add := '  Procedure validate_batch_no_required_info;';
  Script.Add := '  begin';
  Script.Add := add_code_to_fill_is_masuk_variable_detail_dataset;
  Script.Add := '    if ( TItemDataset( dataset.ItemNo.FieldLookUp ).ItemType.AsInteger=0 ) ' ;
  Script.Add := '        And ( TItemDataset( dataset.ItemNo.FieldLookUp ).ExtendedID.FieldLookup.FieldByName( REQUIREDBATCHNOFIELD ).AsBoolean )';
  add_specific_transaction_code;
  Script.Add := '    then begin';

  add_batch_no_exists_validation;
  // Not need to validate warehouseid at here, already validate by WarehouseDatasetImplement
  add_expired_date_validation;

  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TDatasetBatchNoInjector.add_do_auto_fill_for_all_item(form_type: TFormName);
begin
//  Script.Add := '  procedure do_auto_fill_for_all_item;';
//  Script.Add := '  var';
//  Script.Add := '    check_sql : TjbSQL;';
//  Script.Add := '    auto_fill_last_pos : integer;';
//  Script.Add := '    shall_clear_batch_no : boolean;';
//  Script.Add := '  begin';
//  if ( form_type=dnIADet ) then begin
//    Script.Add := '    if (MasterDataset<>nil) And ( MasterDataset.AdjCheck.AsBoolean ) then begin';
//{$IFDEF TESTING}
//    Script.Add := '      RaiseException('''+ MSG_IA_QUANTITY_ONLY + ''');';
//{$ELSE}
//    Script.Add := '      ShowMessage('''+ MSG_IA_QUANTITY_ONLY + ''');';
//{$ENDIF}
//    Script.Add := '      exit;';
//    Script.Add := '    end;';
//  end;
//  Script.Add := '    if ( dataset.ItemNo.AsString='''' ) then begin';
//  Script.Add := '      ShowMessage(''Please fill item detail first.'');';
//  Script.Add := '    end';
//  Script.Add := '    else begin';
//  Script.Add := '      auto_fill_last_pos := dataset.seq.AsInteger;';
//  Script.Add := '      check_sql := CreateSQL(dataset.Tx);';
//  Script.Add := '      try';
//  Script.Add := '        RunSQL(check_sql, Format(''Select max(seq) from %s where %s=%d'', [dataset.TableName, dataset.FirstKeyField, MasterDataset.firstKeyFieldValue]));';
//  Script.Add := '        if (VarToStr(check_sql.FieldByName(''max''))<>'''') then begin ';
//  Script.Add := '          auto_fill_last_pos := check_sql.FieldByName(''max'');';
//  script.Add := '        end;';
//  Script.Add := '      finally';
//  Script.Add := '        check_sql.Free;';
//  Script.Add := '      end;';
//  Script.Add := '';
////  Script.Add := '      is_doing_auto_fill_procedure := True;';
//  Script.Add := '      shall_clear_batch_no := false;';
//  Script.Add := '      dataset.DisableControls;';
//  Script.Add := '      Try';
//  Script.Add := '        dataset.first;';
//  Script.Add := '        while (dataset.Seq.value<=auto_fill_last_pos) And (Not dataset.eof) do begin';
//  Script.Add := '          if ( ABS(dataset.' + get_auto_fill_quantity_field_name(form_type) + '.AsCurrency)>0 ) And';
//  Script.Add := '             ( dataset.FieldByName( BatchField ).AsString='''' ) And';
//  Script.Add := '             ( Not dataset.warehouseId.isNull ) And';
//  if ( form_type in [dnDODet, dnSIDet] ) then begin
//    //Script.Add := '             ( TSICustomDataset( MasterDataset ).GetFromSO.AsBoolean ) And';
//  end;
//  Script.Add := '             ( TItemDataset( dataset.ItemNo.FieldLookUp ).ItemType.AsInteger=0 ) And';
//  Script.Add := '             ( TItemDataset( dataset.ItemNo.FieldLookUp ).ExtendedID.FieldLookup.FieldByName( REQUIREDBATCHNOFIELD ).AsBoolean )';
//  Script.Add := '          then begin';
//  Script.Add := '            if is_batch_number_enough then begin';
//  Script.Add := '              fill_batch_no_info;';
//  Script.Add := '            end';
//  Script.Add := '            else begin';
//  Script.Add := '              shall_clear_batch_no := true;';
//{$IFDEF TESTING}
//  Script.Add := '              RaiseException(Format(''Batch number for item "%s" are not enough at "%s" warehouse.'',';
//  Script.Add := '                                 [dataset.itemNo.AsString, dataset.warehouseid.FieldLookup.FieldByName(''Name'').AsString]));';
//{$ELSE}
//  Script.Add := '              showMessage(Format(''Batch number for item "%s" are not enough at "%s" warehouse.'',';
//  Script.Add := '                                 [dataset.itemNo.AsString, dataset.warehouseid.FieldLookup.FieldByName(''Name'').AsString]));';
//{$ENDIF}
//  Script.Add := '              break;';
//  Script.Add := '            end;';
//  Script.Add := '          end;';
//  Script.Add := '          dataset.next;';
//  Script.Add := '        end;';
//  Script.Add := '      Finally';
//  Script.Add := '        dataset.EnableControls;';
////  Script.Add := '        is_doing_auto_fill_procedure := False;';
//  Script.Add := '      End;';
//  Script.Add := '';
//  Script.Add := '      if shall_clear_batch_no then begin';
//  Script.Add := '        do_clear_batch_no_info;';
//  Script.Add := '      end;';
//  Script.Add := '    end;';
//  Script.Add := '  end;';
//  Script.Add := '';

  Script.Add := '  procedure do_auto_fill_for_all_item;'; //JR, BZ 2272, menghilangkan directive agar langsung menggunakan raise untuk bisa ditangkap ke block except ketika menggunakan form loading
  Script.Add := '  var';
  Script.Add := '    check_sql : TjbSQL;';
  Script.Add := '    auto_fill_last_pos : integer;';
  Script.Add := '    isGettingDataOldValue: boolean;';
  Script.Add := '  begin';
  if ( form_type=dnIADet ) then begin
    Script.Add := '    if (MasterDataset<>nil) And ( MasterDataset.AdjCheck.AsBoolean ) then begin';
    Script.Add := '      RaiseException('''+ MSG_IA_QUANTITY_ONLY + ''');';
    Script.Add := '    end;';
  end;
  Script.Add := '    if ( dataset.ItemNo.AsString='''' ) then begin';
  Script.Add := '      RaiseException(''Please fill item detail first.'');';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      auto_fill_last_pos := dataset.seq.AsInteger;';
  Script.Add := '      check_sql := CreateSQL(dataset.Tx);';
  Script.Add := '      try';
  Script.Add := '        RunSQL(check_sql, Format(''Select max(seq) from %s where %s=%d'', [dataset.TableName, dataset.FirstKeyField, MasterDataset.firstKeyFieldValue]));';
  Script.Add := '        if (VarToStr(check_sql.FieldByName(''max''))<>'''') then begin ';
  Script.Add := '          auto_fill_last_pos := check_sql.FieldByName(''max'');';
  script.Add := '        end;';
  Script.Add := '      finally';
  Script.Add := '        check_sql.Free;';
  Script.Add := '      end;';
  Script.Add := '';
  Script.Add := '      dataset.DisableControls;';
  Script.Add := '      isGettingDataOldValue := MasterDataset.isGettingDataFromOther;';
  Script.Add := '      MasterDataset.isGettingDataFromOther := True;';
  Script.Add := '      Try';
  Script.Add := '        dataset.first;';
  Script.Add := '        while (dataset.Seq.value<=auto_fill_last_pos) And (Not dataset.eof) do begin';
  Script.Add := '          if ( ABS(dataset.' + get_auto_fill_quantity_field_name(form_type) + '.AsCurrency)>0 ) And';
  Script.Add := '             ( dataset.FieldByName( BatchField ).AsString='''' ) And';
  Script.Add := '             ( Not dataset.warehouseId.isNull ) And';
  Script.Add := '             ( TItemDataset( dataset.ItemNo.FieldLookUp ).ItemType.AsInteger=0 ) And';
  Script.Add := '             ( TItemDataset( dataset.ItemNo.FieldLookUp ).ExtendedID.FieldLookup.FieldByName( REQUIREDBATCHNOFIELD ).AsBoolean )';
  Script.Add := '          then begin';
  Script.Add := '            if is_batch_number_enough then begin';
  Script.Add := '              fill_batch_no_info;';
  Script.Add := '            end';
  Script.Add := '            else begin';
  Script.Add := '              do_clear_batch_no_info;';
  Script.Add := '              RaiseException(Format(''Batch number for item "%s" are not enough at "%s" warehouse.'',';
  Script.Add := '                                 [dataset.itemNo.AsString, dataset.warehouseid.FieldLookup.FieldByName(''Name'').AsString]));';
  Script.Add := '              break;';
  Script.Add := '            end;';
  Script.Add := '          end;';
  Script.Add := '          dataset.next;';
  Script.Add := '        end;';
  Script.Add := '      Finally';
  Script.Add := '        MasterDataset.isGettingDataFromOther := isGettingDataOldValue;';
  Script.Add := '        dataset.EnableControls;';
  Script.Add := '      End;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TDatasetBatchNoInjector.add_global_constanta( Masuk:integer );
begin
  if is_item_adjustment then begin
    Script.Add := ' // (IA AV or AQ) using TIADataset.AdjCheck field for transaction type identifier.';
  end
  else if is_item_transfer then begin
    Script.Add := ' // IT consider as outgoing qty for source warehouse and incoming qty for destination warehouse.';
  end
  else begin
    Script.Add := '// 1= masuk (PI, SR) , -1 = keluar (SI, PR)';
  end;
  Script.Add := format( ' MASUK = %d;', [Masuk] );
//  add_batch_field_const;
//  add_expired_date_field_const;
//  add_required_batch_no_field_const;
  Script.Add := '';
end;

procedure TDatasetBatchNoInjector.generate_outgoing_detail_dataset_transaction_script;
begin
  generate_detail_dataset_transaction_script( -1, dnPRDet );
end;

procedure TDatasetBatchNoInjector.generate_ia_det_auto_fill_script;
begin
  add_auto_fill_scripts( dnIADet );
end;

procedure TDatasetBatchNoInjector.generate_si_det_auto_fill_script;
begin
  add_auto_fill_scripts( dnSIDet );
end;

procedure TDatasetBatchNoInjector.generate_incoming_detail_dataset_transaction_script;
begin
  generate_detail_dataset_transaction_script( 1, dnSRDet );
end;

procedure TDatasetBatchNoInjector.generate_item_adjustment_detail_dataset_script;
begin
  is_item_adjustment := True;
  have_auto_fill_feature := True;
  Try
    generate_detail_dataset_transaction_script( 0, dnIADet, generate_ia_det_auto_fill_script ); // AA, BZ 1909
  Finally
    reset_transaction_flag;
  End;
end;

procedure TDatasetBatchNoInjector.generate_detail_dataset_transaction_script( masuk:integer;  form_type:TFormName; extra_script:TExtraScriptProcedure=nil );
begin
  Script.Clear;

  add_detail_dataset_constanta;
  add_global_constanta( masuk );

  add_detail_dataset_variable;

  if have_auto_fill_feature then begin
//    Script.Add := '  is_doing_auto_fill_procedure : boolean;'; // AA, BZ 1982
    add_is_doing_auto_fill_before_save;
  end;

  add_read_option_function;
  add_batch_no_parameter_function;
  add_expired_date_parameter_function;
  add_required_batch_no_parameter_function;

  is_expired_date_exists_at_current_dataset(form_type);

  add_procedure_to_validate_batch_no_required_info;

  if Assigned(extra_script) then begin
    extra_script;
  end;

  add_main_procedure_transaction_script;
end;

procedure TDatasetBatchNoInjector.generate_do_det_auto_fill_script;
begin
  add_auto_fill_scripts( dnDODet );
end;

procedure TDatasetBatchNoInjector.add_main_procedure_transaction_script;
begin
  Script.Add := 'BEGIN';
  Script.Add := '  dataset.OnBeforePostAuditArray := @validate_batch_no_required_info;';
  if have_auto_fill_feature then begin
//    Script.Add := '  is_doing_auto_fill_procedure := False;';
    Script.Add := '  dataset.on_before_save_array := @before_save_dataset;';
    Script.Add := '  dataset.add_runtime_procedure := @do_auto_fill_for_all_item;';
    Script.Add := '  dataset.add_runtime_procedure := @do_clear_batch_no_info;';
  end;
  Script.Add := 'END.';
end;

procedure TDatasetBatchNoInjector.add_master_dataset_variable;
begin
  Script.Add := 'var ';
  Script.Add := '  OldList          : TStringList;';
  Script.Add := '  NewList          : TStringList;';
  Script.Add := '  sql              : TjbSQL;';
  if is_item_transfer then begin
//    Script.Add := '  before_edit_list : TStringList;';
//    Script.Add := '  NormalizeInList  : TStringList;';
//    Script.Add := '  NormalizeOutList : TStringList;';
    Script.Add := '  oldListSourceWh : TStringList;';
    Script.Add := '  oldListDestinationWh : TStringList;';
    Script.Add := '  NormalizeListDestinationWh  : TStringList;';
    Script.Add := '  NormalizeListSourceWh : TStringList;';
  end
  else begin
    Script.Add := '  NormalizeList    : TStringList;';
  end;
  add_global_variable;
end;

procedure TDatasetBatchNoInjector.add_detail_dataset_variable;
begin
  Script.Add := 'var ';
  add_global_variable;
end;

function TDatasetBatchNoInjector.add_code_to_fill_is_masuk_variable_detail_dataset: string;
begin
  if is_item_adjustment then begin
    result := '    is_masuk := ( MasterDataset.ADJCHECK.AsBoolean );';
  end
  else begin
    result := '    is_masuk := ( MASUK=1 );';
  end;
end;

procedure TDatasetBatchNoInjector.add_collect_data_for_new_record(form_type: TFormName);
begin
  Script.Add := '    procedure collect_data_for_new_record;';
  Script.Add := '    begin';
  Script.Add := '      current_seq := Dataset.seq.AsInteger;';
  Script.Add := '      dept_id := Dataset.DeptId.AsInteger;';
  Script.Add := '      proj_id := Dataset.ProjectID.AsInteger;';
  Script.Add := '      item_unit := Dataset.ItemUnit.AsString;';
  if ( form_type in [dnDODet, dnSIDet] ) then begin
    Script.Add := '      if Dataset.soid.isNull then begin';
    Script.Add := '        so_id            := -1;';
    Script.Add := '        so_seq           := -1;';
    Script.Add := '      end';
    Script.Add := '      else begin';
    Script.Add := '        so_id            := Dataset.soid.AsInteger;';
    Script.Add := '        so_seq           := Dataset.soseq.AsInteger;';
    Script.Add := '      end;';
    Script.Add := '      tax_codes        := Dataset.taxCodes.AsString;';
    Script.Add := '      bruto_unit_price := Dataset.brutoUnitPrice.AsCurrency;';
    Script.Add := '      item_disc        := Dataset.ItemDiscPc.AsString;';
  end;
  Script.Add := '    end;';
  Script.Add := '';
end;

//procedure TDatasetBatchNoInjector.add_batch_field_const;
//begin
//  Script.Add := '  BATCHFIELD = ''' + Fbatch_no_field_name + ''';';
//end;

//procedure TDatasetBatchNoInjector.add_expired_date_field_const;
//begin
//  Script.Add := '  EXPIREDFIELD = ''' + Fexpired_date_field_name + ''';';
//end;

procedure TDatasetBatchNoInjector.add_warehouse_field_const;
begin
  Script.Add := '  WAREHOUSEFIELD = ''WarehouseID'';';
end;

//procedure TDatasetBatchNoInjector.add_required_batch_no_field_const;
//begin
//  Script.Add := '  REQUIREDBATCHNOFIELD = ''' + Frequired_batch_no_field_name + ''';';
//end;

procedure TDatasetBatchNoInjector.Setbatch_no_field_name(
  const Value: string);
begin
  Fbatch_no_field_name := Value;
end;

procedure TDatasetBatchNoInjector.Setexpired_date_field_name(
  const Value: string);
begin
  Fexpired_date_field_name := Value;
end;

procedure TDatasetBatchNoInjector.Setrequired_batch_no_field_name(
  const Value: string);
begin
  Frequired_batch_no_field_name := Value;
end;

procedure TDatasetBatchNoInjector.set_scripting_parameterize;
begin
  inherited;
  self.feature_name := SCRIPTING_BATCH_NUMBER;
  Fbatch_no_field_name := 'ItemReserved2';
  Fexpired_date_field_name := 'ItemReserved3';
  Frequired_batch_no_field_name := 'CUSTOMFIELD20'; // field inside extended detail dataset.
end;

procedure TDatasetBatchNoInjector.set_item_extended_mapping;
var
  em : TExtendedMappingDataset;

  function ext_map_not_exists : boolean;
  var
    asql : IReadyToUseSQL;
  begin

    asql := TReadyToUseSQL.Create( Tx );
    asql.Exec( Format( 'Select * from extendedmapping where maptablename=''%s'' and mapfieldname=''%s'' and caption=''%s'' and customfieldtype=%d',
               [TN_ITEM, required_batch_no_field_name, FIELD_CAPTION, CustomFldTypeBoolean] ) );
    while not asql.eof do begin
      asql.next;
    end;
    result := ( asql.recordcount=0 );
  end;

begin
  if ext_map_not_exists then begin
    em := TExtendedMappingDataset.Create( nil, DB, Tx );
    Try
      em.Open;
      em.Append;
      em.MapTableName.AsString := TN_ITEM;
      em.MapFieldName.AsString := required_batch_no_field_name;
      em.Caption.AsString := FIELD_CAPTION;
      em.CUSTOMFIELDTYPE.AsInteger := CustomFldTypeBoolean;
      em.Post;
    Finally
      em.FreeAllImplementation;
    End;
  end;
end;

{procedure TDatasetBatchNoInjector.prepare_item_reserved;
var
  util : TSNUtility;

  procedure do_move_reserved_data( field_name:string; field_caption:string );
  var
    source_field_idx : integer;
    target_field_idx : integer;
  begin
    source_field_idx := StrToInt( StringReplace( field_name, 'ITEMRESERVED', '', [rfReplaceAll, rfIgnoreCase] ) );
    target_field_idx := util.CheckMoveItemReserved( source_field_idx, field_caption, Tx );
    if target_field_idx=0 then begin
      Exception.Create( MSG_BATCH_NO_ITEM_RESERVED_FIELD_FULL );
    end
    else if ( source_field_idx<>target_field_idx ) then begin
      util.MoveItemReserved( source_field_idx, field_caption, target_field_idx, Tx );
      msg_to_user.Add( Format( MSG_SUCCESS_MOVE_ITEM_RESERVED_DATA, [source_field_idx, target_field_idx] ) );
    end;
  end;

begin
  util := TSNUtility.Create;
  Try
    do_move_reserved_data( batch_no_field_name, STR_BATCH_NUMBER );
    do_move_reserved_data( expired_date_field_name, STR_EXPIRED_DATE );
  Finally
    util.free;
  End;
end; }

procedure TDatasetBatchNoInjector.setup_database_setting;
begin
  if Not Self.is_doing_remote_injection then begin
    set_item_extended_mapping;
  //  prepare_item_reserved;  // turn off for performance
    save_batch_no_parameters_to_option_table;
  end;
end;

procedure TDatasetBatchNoInjector.generate_apinv_detail_dataset_script;
begin
  is_apinv := True;
  Try
    generate_detail_dataset_transaction_script( 1, dnPIItm );
  Finally
    reset_transaction_flag;
  End;
end;

procedure TDatasetBatchNoInjector.generate_arinv_detail_dataset_script(dataset_type:TFormName);
begin
  is_arinv := True;
  have_auto_fill_feature := True;
  Try
    if dataset_type=dnDODet then begin
      generate_detail_dataset_transaction_script( -1, dnDODet, generate_do_det_auto_fill_script );
    end
    else if dataset_type=dnSIDet then begin
      generate_detail_dataset_transaction_script( -1, dnSIDet, generate_si_det_auto_fill_script );
    end;
  Finally
    reset_transaction_flag;
  End;
end;

procedure TDatasetBatchNoInjector.AddProcedure_ValidateDetailBatchNoInformation;
begin
  Script.Add := 'procedure validate_detail_batch_no_info;';
  Script.Add := 'var';
  Script.Add := '  is_auto_fill_turn_off : boolean;';
  Script.Add := '';
  Script.Add := '  function get_validate_detail_sql:String;';
  Script.Add := '  begin';
  Script.Add := '    result := format(''Select first 1 d.ItemNo from %s d left outer join item i on i.itemno=d.itemno Where (d.%s=%s) and (i.ItemType=0) and '' + ';
  if is_item_transfer then begin
    Script.Add := '                     ''( d.reqid is not null ) and '' + ';
  end;
  Script.Add := '                     ''((Select E.%s from extended E where E.Extendedid=i.extendedid)=1) and ((%s='''''''' or (%s is null)) or (%s='''''''' or (%s is null)))'', ';
  Script.Add := '                [DETAILTABLENAME, DETAILFIRSTKEYFIELD, Dataset.FieldByName(DETAILFIRSTKEYFIELD).asString, REQUIREDBATCHNOFIELD ';
  Script.Add := '                 , BATCHFIELD, BATCHFIELD, EXPIREDFIELD, EXPIREDFIELD]);';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := 'begin';
  if is_arinv then begin
    Script.Add := '  if Dataset.getFromSO.AsBoolean then begin';
  end
  else if is_apinv then begin
    Script.Add := '  if Dataset.getFromPO.AsBoolean then begin';
  end;
  Script.Add := '    RunSQL( sql, get_validate_detail_sql );';
  Script.Add := '    if ( VarToStr( sql.FieldByName(''ItemNo'') )<>'''' ) then begin';
  Script.Add := '      RaiseException( Format( MSG_FILL_BATCH_NO_INFORMATION, [sql.FieldByName(''itemno'')] ) );';
  Script.Add := '    end;';
  if is_arinv or is_apinv then begin
    Script.Add := '  end;';
  end;
  Script.Add := 'end;';
end;

procedure TDatasetBatchNoInjector.AddProcedure_MasterBeforePostAudit;
begin
  Script.Add := '  Dataset.OnBeforePostAuditArray := @validate_detail_batch_no_info;';
end;

procedure TDatasetBatchNoInjector.generate_item_transfer_detail_dataset_script;
begin
  is_item_transfer := True;
  Try
    generate_detail_dataset_transaction_script( -1, dnITDet );
  Finally
    reset_transaction_flag;
  End;
end;

procedure TDatasetBatchNoInjector.add_batch_no_parameter_function;
begin
  Script.Add := '  function BATCHFIELD:String; ';
  Script.Add := '  begin ';
  // AA, do not call "ReadOption", cuz it was design to used different transaction, and create in runtime (when scripting was executed).
{$IFDEF TESTING}
  Script.Add := Format('    result := ''%s''; ', [self.batch_no_field_name]);
{$ELSE}
  Script.Add := Format('    result := ReadOption(''%s'', ''%s''); ', [OPTIONS_PARAM_NAME_BATCH_NO_FIELD, self.batch_no_field_name]);
{$ENDIF}
  Script.Add := '  end; ';
  Script.Add := '';
end;

procedure TDatasetBatchNoInjector.add_is_doing_auto_fill_before_save;
begin
  Script.Add := '  function is_doing_auto_fill_before_save:boolean;';
{$IFDEF TESTING}
  Script.Add := '  var';
  Script.Add := '    test_sql : TjbSQL;';
  Script.Add := '  begin';
  Script.Add := '    test_sql := CreateSQL(dataset.Tx);';
  Script.Add := '    Try';
  Script.Add := '      RunSQL(test_sql, ''Select ValueOpt From Options Where ParamOpt=''' + QuotedStr(OPTIONS_PARAM_NAME_AUTO_FILL_BATCH_NO) + ''''');';
  Script.Add := '      result :=  ( test_sql.fieldByName(''ValueOpt'')=''1'' );';
  Script.Add := '    Finally';
  Script.Add := '      test_sql.Free;';
  Script.Add := '    End;';
  Script.Add := '  end;';
{$ELSE}
  Script.Add := '  begin';
  Script.Add := '    result := ( ' + Format('ReadOption(''%s'', ''0'')', [OPTIONS_PARAM_NAME_AUTO_FILL_BATCH_NO]) + '=''1'' ); ';
  Script.Add := '  end;';
{$ENDIF}
  Script.Add := '';
end;

procedure TDatasetBatchNoInjector.add_before_save_event;
begin
  Script.Add := '  procedure before_save_dataset;';
  Script.Add := '  begin';
  Script.Add := '    if is_doing_auto_fill_before_save ';
  if is_item_adjustment then begin
    Script.Add := '       And ( Not MasterDataset.AdjCheck.AsBoolean )';
  end;
  Script.Add := '    then begin';
  Script.Add := '      do_auto_fill_for_all_item;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TDatasetBatchNoInjector.add_expired_date_parameter_function;
begin
  Script.Add := '  function EXPIREDFIELD : String; ';
  Script.Add := '  begin ';
{$IFDEF TESTING}
  Script.Add := Format('    result := ''%s''; ', [self.expired_date_field_name]);
{$ELSE}
  Script.Add := Format('    result := ReadOption(''%s'', ''%s''); ', [OPTIONS_PARAM_NAME_EXPIRED_DATE_FIELD, self.expired_date_field_name]);
{$ENDIF}
  Script.Add := '  end; ';
  Script.Add := '';
end;

procedure TDatasetBatchNoInjector.add_required_batch_no_parameter_function;
begin
  Script.Add := '  function REQUIREDBATCHNOFIELD : String; ';
  Script.Add := '  begin ';
{$IFDEF TESTING}
  Script.Add := Format('    result := ''%s''; ', [self.required_batch_no_field_name]);
{$ELSE}
  Script.Add := Format('    result := ReadOption(''%s'', ''%s''); ', [OPTIONS_PARAM_NAME_REQUIRED_BATCH_NO_FIELD, self.required_batch_no_field_name]);
{$ENDIF}
  Script.Add := '  end; ';
  Script.Add := '';
end;

procedure TDatasetBatchNoInjector.add_variable_for_auto_fill(form_type: TFormName);
begin
  Script.Add := '    item_no : String;';
  Script.Add := '    wh_id : integer;';
  Script.Add := '    dept_id : integer;';
  Script.Add := '    proj_id : integer;';
  Script.Add := '    item_unit : string;';
  Script.Add := '    current_seq : integer;';
  if ( form_type in [dnDODet, dnSIDet] ) then begin
    Script.Add := '    so_id : integer;';
    Script.Add := '    so_seq : integer;';
    Script.Add := '    tax_codes : string;';
    Script.Add := '    bruto_unit_price : currency;';
    Script.Add := '    item_disc : string;';
  end;
end;

procedure TDatasetBatchNoInjector.save_batch_no_parameters_to_option_table;
begin
  ReadWriteOptions.Write_Options(OPTIONS_PARAM_NAME_BATCH_NO_FIELD, self.batch_no_field_name, Tx);
  ReadWriteOptions.Write_Options(OPTIONS_PARAM_NAME_EXPIRED_DATE_FIELD, self.expired_date_field_name, Tx);
  ReadWriteOptions.Write_Options(OPTIONS_PARAM_NAME_REQUIRED_BATCH_NO_FIELD, self.required_batch_no_field_name, Tx);
end;

procedure TDatasetBatchNoInjector.add_read_option_function;
begin
  CreateTx;
  AddFunction_CreateSQL;
  add_procedure_runsql;
  ReadOption;
end;

procedure TDatasetBatchNoInjector.addVarAutoFillIsPromo(formType:TFormName);
begin
  if formType in [dnDODet, dnSIDet] then begin
    Script.Add := '    isPromo : Integer; ';
  end;
end;

procedure TDatasetBatchNoInjector.add_auto_fill_scripts(form_type:TFormName);
begin
  is_distro_variant;
  add_is_batch_number_enough_for_auto_fill(form_type);
  add_fill_batch_no_information_for_auto_fill(form_type);
  add_do_auto_fill_for_all_item(form_type);
  add_do_clear_batch_no_info;
  add_before_save_event; // AA, BZ 1910
end;

procedure TDatasetBatchNoInjector.add_do_clear_batch_no_info;
begin
  Script.Add := '  procedure do_clear_batch_no_info;';
  Script.Add := '  var';
  Script.Add := '    bn_field      : TField;';
  Script.Add := '    expired_field : TField;';
  //Perbaikan dilakukan nanti
//  Script.Add := '    recNo         : Integer;';
  Script.Add := '  begin';
//  Script.Add := '    is_doing_auto_fill_procedure := True;';
  Script.Add := '    dataset.DisableControls;';
//  Script.Add := '    recNo := dataset.RecNo;';  //SCY BZ
  Script.Add := '    Try';
  Script.Add := '      dataset.first;';
  Script.Add := '      bn_field := dataset.FieldByName( BatchField );';
  Script.Add := '      expired_field := dataset.FieldByName( ExpiredField );';
  Script.Add := '      while (Not dataset.eof) do begin';
  Script.Add := '        dataset.Edit;';
  Script.Add := '        bn_field.AsString := '''';';
  Script.Add := '        expired_field.AsString := '''';';
  Script.Add := '        dataset.next;';
  Script.Add := '      end;';

//  Script.Add := '      while recNo <> dataset.RecNo do begin';  //SCY BZ
//  Script.Add := '        dataset.Prior;';
//  Script.Add := '      end;';
  Script.Add := '    Finally';
  Script.Add := '      dataset.EnableControls;';
//  Script.Add := '      is_doing_auto_fill_procedure := False;';
  Script.Add := '    End;';
  Script.Add := '  end;';
  Script.Add := '';
end;

end.

