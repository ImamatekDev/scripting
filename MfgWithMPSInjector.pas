unit MfgWithMPSInjector;

interface
uses MfgInjector, Bankconst, Sysutils, Injector, ScriptConst;

type
  TMfgWithMPSInjector = class(TInjector)
  private
    procedure GenerateForIADetDataset;
    procedure GenerateScriptForMain;
    procedure ShowSetting;
    procedure MfgConst;
    procedure GenerateForIADataset;
    procedure add_function_is_standard_cost_at_production_result;
    procedure GenerateForSODetDataset; //MMD, BZ 3332
  protected
    procedure set_scripting_parameterize; override;

  public
    procedure GenerateScript; override;
  end;

implementation

{ TMfgWithMPSInjector }

procedure TMfgWithMPSInjector.set_scripting_parameterize;
begin
  feature_name := SCRIPTING_MFG_WITH_MPS;
end;

procedure TMfgWithMPSInjector.GenerateForIADetDataset;
begin
  ClearScript;
  MfgConst;
  Script.Add := 'var ScheduleID:Integer; ';
  Script.Add := 'function GetScheduleID(sql:TjbSQL):Integer;';
  Script.Add := 'begin';
  Script.Add := '  result := 0;';
  Script.Add := '    RunSQL(sql, format(''Select e.%s ScheduleID from Extended e join ItemAdj ia on ia.ExtendedID=e.ExtendedID '+
    'where ia.ItemAdjID=%d'', [IA_SCHEDULEID_FIELDNAME, Dataset.FieldByName(''ItemAdjID'').asInteger])); ';
  //Script.Add := '    ShowMessage( sql.FieldByName(''ScheduleID'') ); ';
  Script.Add := '    if sql.EOF then exit; ';
  Script.Add := '    if sql.FieldByName(''ScheduleID'') = null then exit; ';
  Script.Add := '    result := sql.FieldByName(''ScheduleID''); ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'function GetValueFromBOM(sql:TjbSQL):Currency; ';
  Script.Add := 'const SQLRM = ''select prm.ITEMNO, ''+ ';
//  Script.Add := '        ''coalesce(prm.QUANTITY, 0) Quantity, ''+ ';
  Script.Add := '        ''(coalesce(prm.QUANTITY, 0)/coalesce(lp.OUTPUTQUANTITY, 0)) as Quantity, ''+ '; // AA, BZ 1834, 2098
//  Script.Add := '        ''coalesce((select first 1 aid.ITEMCOSTBASE from APITMDET aid join APINV ai on ai.APINVOICEID=aid.APINVOICEID ''+ ';
//  Script.Add := '        ''where aid.ITEMNO=prm.ITEMNO order by ai.INVOICEDATE DESC), 0) PurchPrice ''+ ';
  // AA, BZ 1898
  Script.Add := '        ''coalesce((select first 1 ih.cost from itemhist ih where ih.itemno=prm.itemno and ih.txtype in (''''P'''', ''''AV'''') ''+ ';
  Script.Add := '        ''order by ih.txdate desc, ih.itemhistid desc ), 0) PurchPrice ''+ ';
  Script.Add := '        ''from SCHEDULE s ''+ ';
  Script.Add := '        ''join wo on wo.ID=s.WOID ''+ ';
  Script.Add := '        ''join route r on r.ID=wo.ROUTE_ID ''+ ';
  Script.Add := '        ''join PROCESS p on p.ROUTE_ID=r.ID ''+ ';
  Script.Add := '        ''join PROCESSRAWMATERIAL prm on prm.PROCESSID=p.ID ''+ ';
  Script.Add := '        ''join process lp on lp.id=(Select rp.id from process rp where rp.route_id=wo.route_id and NOT EXISTS (select * from NEXTPROCESS np where np.PreviousProcessID=rp.ID)) '' + ';
  Script.Add := '        ''where s.ID=%d''; ';
  Script.Add := 'begin';
  Script.Add := '  result := 0; ';
  Script.Add := '  RunSQL( sql, format(SQLRM, [ ScheduleID ])); ';
  Script.Add := '  while not sql.EOF do begin ';
  Script.Add := '    result := result + sql.FieldByName(''Quantity'') * sql.FieldByName(''PurchPrice''); ';
  Script.Add := '    sql.Next; ';
  Script.Add := '  end; ';
  //Script.Add := '  ShowMessage( FloatToStr( result ) ); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function GetStdCost(sql:TjbSQL):Currency; ';
  Script.Add := '  function ItemExtendedField:TField;';
  Script.Add := '  begin';
  Script.Add := '    result := TExtendedDetLookupField(Dataset.ItemNo.FieldLookup.FieldByName(''ExtendedID'')).FieldLookup.FieldByName(ITEM_STDCOSTNO_FIELD);';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  result := 0; ';
  Script.Add := '  RunSQL(sql, GetStdCostSQL(STDCOST_EXT_TYPE_NAME) ); ';
  Script.Add := '  while not sql.EOF do begin ';
  Script.Add := '    result := result + sql.FieldByName(''StdCost'' + GetFGStdCostNo(ItemExtendedField.value) ); ';
//  Script.Add := '    result := result + StrSQLToCurr( sql.FieldByName(''StdCost'' + GetFGStdCostNo(ItemExtendedField.value) ) ); ';
  Script.Add := '    sql.Next; ';
  Script.Add := '  end; ';
  //Script.Add := '  ShowMessage( FloatToStr(result) ); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function IsProduction(sql:TjbSQL): Boolean; ';
  Script.Add := 'begin';
  Script.Add := '    RunSQL(sql, format(''Select coalesce(ia.AdjCheck, 0) IsAdjValue, Coalesce(ia.Production, 0) IsProduction '+
    'from ItemAdj ia where ia.ItemAdjID=%d'', '+
    '[Dataset.FieldByName(''ItemAdjID'').asInteger])); ';
  Script.Add := '    result := (sql.FieldByName(''IsAdjValue'') = 1) and (sql.FieldByName(''IsProduction'') = 1);';
  //Script.Add := '  ShowMessage(''IsAdjValue:'' + IntToStr( sql.FieldByName(''IsAdjValue'')) + '', IsProduction:''+ IntToStr(sql.FieldByName(''IsProduction''))); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function IsFG(sql:TjbSQL):Boolean; ';
  Script.Add := 'begin';
  Script.Add := '  RunSQL(sql, format(''select coalesce(r.FGCODE, '''''''') FGCode from SCHEDULE s '+
    'join wo on wo.ID=s.WOID '+
    'join ROUTE r on r.ID=wo.ROUTE_ID '+
    'where s.ID=%d'', [ScheduleID])); ';
  Script.Add := '  result := sql.FieldByName(''FGCode'') = Dataset.ItemNo.value; ';
  //Script.Add := '  ShowMessage(''FGCode='' + sql.FieldByName(''FGCode'') + '', ItemNo='' + Dataset.ItemNo.value); ';
  Script.Add := 'end;';
  Script.add := '';
//  Script.Add := 'function get_total_rm_cost_of_current_work_order:currency;';
//  Script.Add := 'var';
//  Script.Add := '  rm_cost_sql : TjbSQL;';
//  Script.Add := '  total_rm_cost : Currency;';
//  Script.Add := '  wo_fg_qty : Currency;';
//  Script.Add := 'begin';
//  Script.Add := '  rm_cost_sql := CreateSQL(TIBTransaction(Dataset.Tx)); ';
//  Script.Add := '  Try';
//  Script.Add := '    RunSQL( rm_cost_sql, Format( ''Select Coalesce(Sum( (select AmountItem from Get_AmountJobCost(ms.MfID)) ), 0) as total_rm_cost '' + ';
//  Script.Add := '                                 ''from MFSHT ms '' + ';
//  Script.Add := '                                 ''join Extended e on e.ExtendedID=ms.ExtendedID '' + ';
//  Script.Add := '                                 ''join Schedule s on s.ID=e.%s '' + ';
//  Script.Add := '                                 ''join wo on wo.ID=s.WOID '' + ';
//  Script.Add := '                                 ''where wo.ID=(select ia.woid from schedule ia where ia.ID=%d) '' ';
//  Script.Add := '                                 , [IA_SCHEDULEID_FIELDNAME, ScheduleID] ) );';
//  Script.Add := '    total_rm_cost := rm_cost_sql.FieldByName( ''total_rm_cost'' );';
//  Script.Add := '';
//  Script.Add := '    RunSQL( rm_cost_sql, Format( ''Select wo.quantity '' + ';
//  Script.Add := '                                 ''from wo '' + ';
//  Script.Add := '                                 ''where wo.ID=(select ia.woid from schedule ia where ia.ID=%d) '' ';
//  Script.Add := '                                 , [ScheduleID] ) );';
//  Script.Add := '    wo_fg_qty := rm_cost_sql.FieldByName( ''quantity'' );';
//  Script.Add := '';
//  Script.Add := '    result := FloatToCurr( total_rm_cost / wo_fg_qty );';
//  Script.Add := '  Finally';
//  Script.Add := '    rm_cost_sql.free;';
//  Script.Add := '  End;';
//  Script.Add := 'end;';
//  Script.Add := '';
//  add_function_is_standard_cost_at_production_result;
  Script.Add := 'function GetWasteCost(sql:TjbSQL):Currency; ';
//  Script.Add := 'var';
//  Script.Add := '  rm_cost : Currency;';
  Script.Add := 'begin';
  Script.Add := '  result := 0;';
  Script.Add := '  RunSQL(sql, format(''select coalesce(ed.INFO2, ''''0'''') WasteCost from EXTENDEDTYPE et '+
    'join EXTENDEDDET ed on ed.EXTENDEDTYPEID=et.EXTENDEDTYPEID '+
    'where et.EXTENDEDNAME=''''WASTE'''' and ed.Info1=''''%s'''' '', [Dataset.ItemNo.value])); ';
// AA, BZ 2132
//  Script.Add := '  if is_standard_cost_at_production_result then begin';
//  Script.Add := '    rm_cost := get_total_rm_cost_of_current_work_order;';
//  Script.Add := '    result := ( rm_cost-sql.FieldByName(''WasteCost'') ); '; // AA, BZ 2086
//  Script.Add := '  end';
//  Script.Add := '  else begin';
  Script.Add := '  if ( Not sql.Eof ) then begin';
  Script.Add := '    result := sql.FieldByName(''WasteCost'');';
  Script.Add := '  end;';
//  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'function GetItemValue(sql:TjbSQL):Currency; ';
  Script.Add := 'begin';
  Script.Add := '  if IsFG(sql) then begin';
  Script.Add := '    result := GetValueFromBOM(sql) + GetStdCost(sql); ';
  Script.Add := '  end';
  Script.Add := '  else begin';
  Script.Add := '    result := GetWasteCost(sql);';
  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure BeforePost; ';
  Script.Add := 'var sql:TjbSQL; ';
  Script.Add := 'begin';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Dataset.Tx)); ';
  Script.Add := '  try';
  Script.Add := '    if not IsProduction(sql) then exit; ';
  Script.Add := '    ScheduleID := GetScheduleID(sql); ';
  Script.Add := '    if ScheduleID = 0 then exit; ';
  Script.Add := '    Dataset.ValueDifference.value := Dataset.QtyDifference.value * GetItemValue(sql); ';
  Script.Add := '  finally';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  InitializeFieldName; ';
  Script.Add := '  Dataset.OnBeforePostArray := @BeforePost; ';
  Script.Add := 'end.';
end;

procedure TMfgWithMPSInjector.GenerateForSODetDataset;
begin
  ClearScript;
  AddFunction_CreateSQL;
  add_procedure_runsql;
  Script.Add := 'procedure CheckSODetUsedInWO;';
  Script.Add := 'var';
  Script.Add := '  sql   : TjbSQL;';
  Script.Add := '  query : String;';
  Script.Add := 'begin';
  Script.Add := '  sql := Nil;';
  Script.Add := '  try';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Tx));';
  Script.Add := '    query := FORMAT(''SELECT Count(1) ' +
                                      'FROM   wo ' +
                                      '       JOIN sodet ' +
                                      '         ON wo.soid = sodet.soid ' +
                                      '            AND wo.soseq = sodet.seq ' +
                                      '            AND wo.soid = %d ' +
                                      '            AND wo.soseq = %d '', [Dataset.SOID.AsInteger, Dataset.Seq.AsInteger]);';
  Script.Add := '    RunSQL(sql, query);';
  Script.Add := '    if sql.FieldByName(''Count'') = 1 then begin';
  Script.Add := '      RaiseException(''Item sudah digunakan di WO, tidak dapat dihapus.'');';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  Dataset.OnBeforeDeleteArray := @CheckSODetUsedInWO;';
  Script.Add := 'end.';
end;

procedure TMfgWithMPSInjector.GenerateForIADataset;
begin
  ClearScript;
  MfgConst;
//  Script.Add := 'const SQLJC = ''select first 1 coalesce(ms.MfID, 0) MfID from MFSHT ms join EXTENDED e on e.EXTENDEDID=ms.EXTENDEDID where e.%s=%d''; ';
  // AA, BZ 1941
  Script.Add := 'const';
  Script.Add := 'SQLJC = ''select first 1 coalesce(ms.MfID, 0) MfID ' +
                'from MFSHT ms ' +
                'join EXTENDED e on e.EXTENDEDID=ms.EXTENDEDID ' +
                'join schedule s on s.ID=e.%s ' +
//                'where s.WOID=(select ia.woid from schedule ia where ia.ID=%d)''; ';
                'where s.production_id=(select sc.production_id from schedule sc where sc.ID=%d) ' +
                'order by ms.sheetdate desc'';'; // AA, BZ 2213
  Script.Add := '';
  Script.Add := 'function GetIAScheduleID:Integer; ';
  Script.Add := 'begin';
  Script.Add := '  if Dataset.ExtendedID.FieldLookup.FieldByName(IA_SCHEDULEID_FIELDNAME).IsNull then begin '; //JR, BZ 2685
  Script.Add := '    result := -1; ';
  Script.Add := '  end ';
  Script.Add := '  else begin ';
  Script.Add := '    result := Dataset.ExtendedID.FieldLookup.FieldByName(IA_SCHEDULEID_FIELDNAME).asInteger; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function get_first_jc_id_of_current_production(used_sql:TjbSQL):Integer; ';
  Script.Add := 'begin';
  Script.Add := '  result := 0; ';
  Script.Add := '  RunSQL(used_sql, Format(SQLJC, [IA_SCHEDULEID_FIELDNAME, GetIAScheduleID])); ';
  Script.Add := '  if (used_sql.RecordCount = 0) or (used_sql.FieldByName(''MfID'') = 0) then exit; ';
  Script.Add := '  result := used_sql.FieldByName(''MfID''); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function GetStdCostNo:String; ';
  Script.Add := 'var';
  Script.Add := '  item_sql : TjbSQL;';
  Script.Add := 'begin';
  Script.Add := '  item_sql := CreateSQL(TIBTransaction(Dataset.Tx)); ';
  Script.Add := '  Try';
  Script.Add := '    RunSQL(item_sql, format(''SELECT Coalesce(ei.%s, ''''1'''') %s from SCHEDULE s join wo on wo.ID=s.WOID '+
                      'join Route r on r.ID=wo.ROUTE_ID '+
                      'JOIN ITEM i on i.ITEMNO=r.FGCODE '+
                      'join EXTENDED ei on ei.EXTENDEDID=i.EXTENDEDID '+
                      'where s.ID=%d'', [ITEM_STDCOSTNO_FIELD, ITEM_STDCOSTNO_FIELD, GetIAScheduleID])); ';
  Script.Add := '    result := GetFGStdCostNo( item_sql.FieldByName(ITEM_STDCOSTNO_FIELD) ); ';
  Script.Add := '  Finally';
  Script.Add := '    item_sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure AddStdCostToJC; ';
  Script.Add := 'var sql:TjbSQL; ';
  Script.add := '    JC : TdmJobCost; ';
  Script.Add := '    JCID : Integer; ';
  Script.Add := '    FGQty : Currency; ';
  Script.Add := '';
  Script.Add := '  function GetFGQty:Currency; ';
  Script.Add := '  begin';
  Script.Add := '    result := 0; ';
  Script.Add := '    RunSQL(sql, format(''Select first 1 coalesce(iad.QtyDifference, 0) QtyDif '+
    'from ItAdjDet iad where iad.ItemAdjID=%d order by Seq'', [Dataset.FieldByName(''ItemAdjID'').asInteger])); ';
  Script.Add := '    if ((sql.RecordCount=0) or (sql.FieldByName(''QtyDif'') <= 0)) then exit; ';
  Script.Add := '    result := sql.FieldByName(''QtyDif''); ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  sql := nil; ';
  Script.Add := '  try';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Dataset.Tx)); ';
  Script.Add := '    JCID := get_first_jc_id_of_current_production(sql); ';
  Script.Add := '    if (JCID = 0) then exit; ';
  Script.Add := '    FGQty := GetFGQty; ';
  Script.Add := '    if FGQty <= 0 then exit; ';
  Script.add := '    JC := TdmJobCost.ACreate( TIBDatabase(Dataset.DB), TIBTransaction(Dataset.Tx), JCID, UserID ); ';
  Script.Add := '    try';
  Script.Add := '      JC.DmStartDatabase; ';
  Script.Add := '      JC.try_lock;'; // AA, BZ 2133
  Script.Add := '      JC.AtblMfSht.shall_check_period := shall_check_accounting_period;'; // AA, BZ 2226
  Script.Add := '      JC.AtblMfSht.Edit; ';
  Script.Add := '      RunSQL(sql, GetStdCostSQL(STDCOST_EXT_TYPE_NAME)); ';
  Script.Add := '      while not sql.EOF do begin ';
  Script.Add := '        JC.AtblMFShtGL.Append; ';
  Script.Add := '        JC.AtblMfShtGL.GLAccount.value := sql.FieldByName(''GLAccount''); ';
  //Script.Add := '        JC.AtblMfShtGL.GLAmount.value  := FGQty * (StrToFloat(sql.FieldByName(''StdCost1'')) + '+
  //  'StrToFloat(sql.FieldByName(''StdCost2''))); ';
//  Script.Add := '        JC.AtblMfShtGL.GLAmount.value  := FGQty * (StrToFloat(sql.FieldByName(''StdCost'' + GetStdCostNo))); ';
  Script.Add := '        JC.AtblMfShtGL.GLAmount.value  := FGQty * (StrSQLToCurr(sql.FieldByName(''StdCost'' + GetStdCostNo))); '; // AA, BZ 1989
  Script.Add := '        JC.AtblMfShtGL.Notes.value     := format(''IA no : %s'', [Dataset.AdjNo.value]); ';
  Script.Add := '        JC.AtblMfShtGL.GLDate.asDateTime := Dataset.AdjDate.asDateTime; '; // AA, BZ 1904
  Script.Add := '        JC.AtblMFShtGL.Post; ';
  Script.Add := '        sql.Next; ';
  Script.Add := '      end; ';
  Script.Add := '      JC.PostData(false); ';
  Script.Add := '    finally';
  Script.Add := '      JC.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  finally';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  add_function_is_standard_cost_at_production_result;
  Script.Add := 'procedure DatasetBeforePost; ';
  Script.Add := 'begin';
  Script.Add := '  if is_standard_cost_at_production_result then exit;'; // AA, BZ 2086
  Script.Add := '  if Dataset.IsFirstPost then exit; ';
  Script.Add := '  if Dataset.AdjCheck.AsInteger = 0 then exit; '; //JR, BZ 2643, for DUnit be green
  Script.Add := '  if Dataset.Production.AsInteger = 0 then exit; ';
  // AA, BZ 2643
//  Script.Add := '  if Dataset.AdjCheck.AsBoolean then exit; ';
//  Script.Add := '  if Dataset.Production.AsBoolean then exit; ';
  Script.add := '  if Dataset.IsMasterNew then begin'; // AA, BZ 2044
  Script.Add := '    AddStdCostToJC; ';
  Script.add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
//  Script.Add := 'function get_total_rm_cost_of_current_work_order:currency;';
//  Script.Add := 'var';
//  Script.Add := '  rm_cost_sql : TjbSQL;';
//  Script.Add := '  total_rm_cost : Currency;';
//  Script.Add := '  wo_fg_qty : Currency;';
//  Script.Add := 'begin';
//  Script.Add := '  rm_cost_sql := CreateSQL(TIBTransaction(Dataset.Tx)); ';
//  Script.Add := '  Try';
//  Script.Add := '    RunSQL( rm_cost_sql, Format( ''Select Coalesce(Sum( (select AmountItem from Get_AmountJobCost(ms.MfID)) ), 0) as total_rm_cost '' + ';
//  Script.Add := '                                 ''from MFSHT ms '' + ';
//  Script.Add := '                                 ''join Extended e on e.ExtendedID=ms.ExtendedID '' + ';
//  Script.Add := '                                 ''join Schedule s on s.ID=e.%s '' + ';
//  Script.Add := '                                 ''join wo on wo.ID=s.WOID '' + ';
//  Script.Add := '                                 ''where wo.ID=(select ia.woid from schedule ia where ia.ID=%d) '' ';
//  Script.Add := '                                 , [IA_SCHEDULEID_FIELDNAME, GetIAScheduleID] ) );';
//  Script.Add := '    total_rm_cost := rm_cost_sql.FieldByName( ''total_rm_cost'' );';
//  Script.Add := '';
//  Script.Add := '    RunSQL( rm_cost_sql, Format( ''Select wo.quantity '' + ';
//  Script.Add := '                                 ''from wo '' + ';
//  Script.Add := '                                 ''where wo.ID=(select ia.woid from schedule ia where ia.ID=%d) '' ';
//  Script.Add := '                                 , [GetIAScheduleID] ) );';
//  Script.Add := '    wo_fg_qty := rm_cost_sql.FieldByName( ''quantity'' );';
//  Script.Add := '';
//  Script.Add := '    result := FloatToCurr( total_rm_cost / wo_fg_qty );';
//  Script.Add := '  Finally';
//  Script.Add := '    rm_cost_sql.free;';
//  Script.Add := '  End;';
//  Script.Add := 'end;';
//  Script.Add := '';
  Script.Add := 'procedure load_waste_info( item_no:string; var waste_cost:Currency; var waste_account:string );';
  Script.Add := 'var';
  Script.Add := '  waste_cost_sql : TjbSQL;';
  Script.Add := 'begin';
  Script.Add := '  waste_cost_sql := CreateSQL(TIBTransaction(Dataset.Tx)); ';
  Script.Add := '  Try';
  Script.Add := '    RunSQL( waste_cost_sql, Format( ''Select ed.Info1, ed.Info2, ed.Info3 '' + ';
  Script.Add := '                                    ''from ExtendedDet ed '' + ';
  Script.Add := '                                    ''Where '' + ';
  Script.Add := '                                    ''(ed.ExtendedTypeID=(Select et.ExtendedTypeID from ExtendedType et where Upper(et.ExtendedName)=''''WASTE'''')) '' + ';
  Script.Add := '                                    ''And '' + ';
  Script.Add := '                                    ''(Upper(ed.Info1)=Upper(''''%s''''))''';
  Script.Add := '                                   , [item_no] ) );';
  Script.Add := '    if ( waste_cost_sql.recordCount>0 ) then begin ';
  Script.Add := '      waste_cost := waste_cost_sql.FieldByName(''Info2'');';
  Script.Add := '      waste_account := waste_cost_sql.FieldByName(''Info3'');';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      waste_cost := 0;';
  Script.Add := '      waste_account := '''';';
  Script.Add := '    end;';
  Script.Add := '  Finally';
  Script.Add := '    waste_cost_sql.free;';
  Script.Add := '  End;';
  Script.Add := 'end;';
  Script.Add := '';
//  Script.Add := 'function add_production_result_waste_cost(schedule_id:integer; ia_date:TdateTime; bs_item_no:string; bs_qty:currency; residu_item_no:string; residu_qty:currency):string;';
//  Script.Add := 'var ';
//  Script.Add := '  IA : TdmAdjustItem; ';
//  Script.Add := '  rm_cost_for_each_fg : Currency;';
//  Script.Add := '';
//  Script.Add := '  procedure add_ia_item( item_no:string; item_qty:Currency );';
//  Script.Add := '  var';
//  Script.Add := '    waste_cost : Currency;';
//  Script.Add := '    waste_account : string;';
//  Script.Add := '  begin';
//  Script.Add := '    if ( (item_no<>'''') And (item_qty<>0) ) then begin';
//  Script.Add := '      load_waste_info( item_no, waste_cost, waste_account );';
//  Script.Add := '      IA.Detail.Append; ';
//  Script.Add := '      IA.Detail.ItemNo.AsString := item_no;';
//  Script.Add := '      IA.Detail.QtyDifference.AsCurrency := item_qty;';
//  Script.Add := '      IA.Detail.ValueDifference.AsCurrency := ( item_qty*( rm_cost_for_each_fg-waste_cost ));';
//  Script.Add := '      IA.Detail.Post; ';
//  Script.Add := '    end;';
//  Script.Add := '  end;';
//  Script.Add := '';
//  Script.Add := 'begin';
//  Script.Add := '  if ( ( bs_item_no<>'''' ) Or ( residu_item_no<>'''' ) ) then begin';
//  Script.Add := '    rm_cost_for_each_fg := get_total_rm_cost_of_current_work_order( schedule_id );';
//  Script.Add := '    IA := TdmAdjustItem.ACreate(nil, TIBDatabase(Dataset.DB), TIBTransaction(Dataset.Tx), -1, UserID); ';
//  Script.Add := '    try';
//  Script.Add := '      IA.DMStartDatabase; ';
//  Script.Add := '      IA.Master.AdjDate.AsDateTime := ia_date;';
//  Script.Add := '      IA.Master.AdjAccount.AsString := Dataset.AdjAccount.AsString;';
//  Script.Add := '      IA.Master.AdjCheck.AsBoolean := True;';
//  Script.Add := '      if ( bs_item_no=residu_item_no ) then begin';
//  Script.Add := '        add_ia_item( bs_item_no, ( bs_qty+residu_qty ) );';
//  Script.Add := '      end';
//  Script.Add := '      else begin';
//  Script.Add := '        add_ia_item( bs_item_no, bs_qty );';
//  Script.Add := '        add_ia_item( residu_item_no, residu_qty );';
//  Script.Add := '      end;';
//  Script.Add := '      IA.PostData(false); ';
//  Script.Add := '      result :=IA.Master.AdjNo.AsString;';
//  Script.Add := '    finally';
//  Script.Add := '      IA.Free; ';
//  Script.Add := '    end; ';
//  Script.Add := '  end';
//  Script.Add := '  else begin';
//  Script.Add := '    result := '''';';
//  Script.Add := '  end;';
//  Script.Add := 'end;';
//  Script.Add := 'procedure calculate_value_for_IA_waste_cost;';
//  Script.Add := 'var ';
//  Script.Add := '  rm_cost_for_each_fg : Currency;';
//  Script.Add := '  waste_cost : Currency;';
//  Script.Add := '  waste_account : string;';
//  Script.Add := '  ia_det : TIADetDataset;';
//  Script.Add := 'begin';
//  Script.Add := '  if is_standard_cost_at_production_result then begin';
//  Script.Add := '    ia_det := TIADetDataset( Dataset.ADetailDataset );';
//  Script.Add := '    rm_cost_for_each_fg := get_total_rm_cost_of_current_work_order;';
//  Script.Add := '    ia_det.First;';
//  Script.Add := '    While Not ia_det.Eof do begin';
//  Script.Add := '      load_waste_info( ia_det.ItemNo.AsString, waste_cost, waste_account );';
//  Script.Add := '      ia_det.Edit; ';
//  Script.Add := '      ia_det.ValueDifference.AsCurrency := ( ia_det.QtyDifference.AsCurrency*( rm_cost_for_each_fg-waste_cost ));';
//  Script.Add := '      ia_det.Post; ';
//  Script.Add := '      ia_det.Next; ';
//  Script.Add := '    end;';
//  Script.Add := '  end;';
//  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure create_production_result_standard_cost;';
  Script.Add := 'var';
  Script.Add := '  production_result_id : integer;';
  Script.Add := '  lookup_sql : TjbSQL;';
  Script.Add := '  bs_item_no : String;';
  Script.Add := '  residu_item_no : String;';
  Script.Add := '  bs_qty : Currency;';
  Script.Add := '  residu_qty : Currency;';
  Script.Add := '  fg_qty : Currency;';
  Script.Add := '  production_result_date : TDateTime;';
  Script.Add := '  machine_id : integer;';
  Script.Add := '  schedule_id : integer;';
  Script.Add := '  jc_id : integer;';
  Script.add := '  jc : TdmJobCost;';
//  Script.Add := '  ia_waste_no : string;';
  Script.Add := '';
//  Script.Add := '  procedure add_jc_detail( gl_account:string; gl_amount:currency; notes:string; gl_date:TDateTime );';
  Script.Add := '  procedure add_jc_detail( gl_account:string; gl_amount:currency; gl_date:TDateTime );';
  Script.Add := '  begin';
  Script.Add := '    if (gl_amount<>0) then begin';
  Script.Add := '      jc.AtblMFShtGL.Append; ';
  Script.Add := '      jc.AtblMfShtGL.GLAccount.value := gl_account;';
  Script.Add := '      jc.AtblMfShtGL.GLAmount.value  := gl_amount;';
//  Script.Add := '      jc.AtblMfShtGL.Notes.value     := notes;';
  Script.Add := '      if (Dataset.AdjNo.AsString<>'''') then begin';
//  Script.Add := '        jc.AtblMfShtGL.Notes.value := format(''IA no: %s'', [Dataset.AdjNo.AsString]);';
  Script.Add := '        JC.AtblMfShtGL.Notes.value := format(''IA No \ Schedule ID : %s'', [Dataset.AdjNo.value]); ';
  Script.Add := '      end;';
  Script.Add := '      jc.AtblMfShtGL.GLDate.asDateTime := gl_date;';
  Script.Add := '      jc.AtblMFShtGL.Post; ';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  procedure add_fg_standard_cost;';
  Script.Add := '  var';
  Script.Add := '    std_cost_sql : TjbSQL;';
  Script.Add := '    wc_standard_cost_ext_type_name : String;';
  Script.Add := '  begin';
  Script.Add := '    std_cost_sql := CreateSQL(TIBTransaction(Dataset.Tx)); ';
  Script.Add := '    Try';
  Script.Add := '      RunSQL( std_cost_sql, Format( ''Select ed.Info2 '' + ';
  Script.Add := '                                  ''From ExtendedDet ed '' + ';
  Script.Add := '                                  ''Where '' + ';
  Script.Add := '                                  ''(ed.ExtendedTypeID=(Select et.ExtendedTypeId from ExtendedType et where Upper(et.ExtendedName)=Upper(''''%s''''))) '' + ';
  Script.Add := '                                  ''And '' + ';
  Script.Add := '                                  ''(Upper(ed.Info1)=''+ ';
  Script.Add := '                                  ''(select Upper(wc.workCenterName) from WorkCenter wc where wc.ID='' + ';
  Script.Add := '                                  ''(Select m.WorkCenter_id from machine m where m.id=%d)))''';
  Script.Add := '                                  , [WC_STDCOST_EXT_TYPE_NAME, machine_id] ) );';
  Script.Add := '      wc_standard_cost_ext_type_name := std_cost_sql.FieldByName(''Info2'');';
  Script.Add := '';
  Script.Add := '      RunSQL(std_cost_sql, GetStdCostSQL(wc_standard_cost_ext_type_name)); ';
  Script.Add := '      while not std_cost_sql.EOF do begin ';
  Script.Add := '        add_jc_detail( std_cost_sql.FieldByName(''GLAccount'')';
  Script.Add := '                       ,(fg_qty * (StrSQLToCurr(std_cost_sql.FieldByName(''StdCost'' + GetStdCostNo))))';
//  Script.Add := '                       ,''''';
  Script.Add := '                       ,production_result_date );';
  Script.Add := '        std_cost_sql.Next;';
  Script.Add := '      end;';
  Script.Add := '    Finally';
  Script.Add := '      std_cost_sql.free;';
  Script.Add := '    End;';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  procedure add_waste_standard_cost(item_no:string; item_qty:currency);';
  Script.Add := '  var';
  Script.Add := '    waste_cost : Currency;';
  Script.Add := '    waste_account : string;';
  Script.Add := '  begin';
  Script.Add := '    if ((item_no<>'''') And (item_qty>0)) then begin';
  Script.Add := '      load_waste_info( item_no, waste_cost, waste_account );';
  Script.Add := '      if ( (waste_cost<>0) And (waste_account<>'''') ) then begin ';
  Script.Add := '        add_jc_detail( waste_account,';
  Script.Add := '                       (item_qty*(-waste_cost)),';
//  Script.Add := '                       format(''IA no: %s'', [ia_waste_no]),';
  Script.Add := '                       production_result_date );';
  Script.Add := '      end;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  if is_standard_cost_at_production_result then begin';
  Script.Add := '    production_result_id := dataset.Description.AsInteger;';
  Script.Add := '    lookup_sql := CreateSQL(TIBTransaction(Dataset.Tx)); ';
  Script.Add := '    try';
  Script.Add := '      RunSQL( lookup_sql, format(''Select * from Production_result where ID=%d'', [ production_result_id ])); ';
  Script.Add := '';
  Script.Add := '      bs_item_no := '''';';
  Script.Add := '      if (lookup_sql.FieldByName(''BSItemNo'')<>null) then begin';
  Script.Add := '        bs_item_no := lookup_sql.FieldByName(''BSItemNo'');';
  Script.Add := '      end;';
  Script.Add := '';
  Script.Add := '      residu_item_no := '''';';
  Script.Add := '      if (lookup_sql.FieldByName(''ResiduItemNo'')<>null) then begin';
  Script.Add := '        residu_item_no := lookup_sql.FieldByName(''ResiduItemNo'');';
  Script.Add := '      end;';
  Script.Add := '';
  Script.Add := '      bs_qty := lookup_sql.FieldByName(''BadStockQty'');';
  Script.Add := '      residu_qty := lookup_sql.FieldByName(''ResiduQty'');';
  Script.Add := '      fg_qty := lookup_sql.FieldByName(''ProductQty'');';
  Script.Add := '      production_result_date := lookup_sql.FieldByName(''CreatedDate'');';
  Script.Add := '      machine_id := lookup_sql.FieldByName(''machine_id'');';
  Script.Add := '      schedule_id := lookup_sql.FieldByName(''Schedule_id'');';
  Script.Add := '      Dataset.ExtendedID.FieldLookup.FieldByName(IA_SCHEDULEID_FIELDNAME).AsInteger := schedule_id;';
//  Script.Add := '';
//  Script.Add := '      ia_waste_no := add_production_result_waste_cost(schedule_id, production_result_date, bs_item_no, bs_qty, residu_item_no, residu_qty);';
//  Script.Add := '';
  Script.Add := '      jc_id := get_first_jc_id_of_current_production(lookup_sql); ';
  Script.Add := '      if (jc_id<>0) then begin';
  Script.add := '        jc := TdmJobCost.ACreate( TIBDatabase(Dataset.DB), TIBTransaction(Dataset.Tx), jc_id, UserID ); ';
  Script.Add := '        try';
  Script.Add := '          jc.DmStartDatabase; ';
  Script.Add := '          jc.AtblMfSht.shall_check_period := shall_check_accounting_period;'; // AA, BZ 2226
  Script.Add := '          jc.AtblMfSht.Edit; ';
  Script.Add := '          add_fg_standard_cost;';
//  Script.Add := '          if (ia_waste_no<>'''') then begin';
  Script.Add := '          if ( bs_item_no=residu_item_no ) then begin';
  Script.Add := '            add_waste_standard_cost( bs_item_no, bs_qty+residu_qty ); ';
  Script.Add := '          end';
  Script.Add := '          else begin';
  Script.Add := '            add_waste_standard_cost( bs_item_no, bs_qty ); ';
  Script.Add := '            add_waste_standard_cost( residu_item_no, residu_qty ); ';
  Script.Add := '          end;';
//  Script.Add := '          end; ';
  Script.Add := '          jc.PostData(false); ';
  Script.Add := '        finally';
  Script.Add := '          jc.Free; ';
  Script.Add := '        end; ';
  Script.Add := '      end;';
  Script.Add := '    finally';
  Script.Add := '      lookup_sql.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  InitializeFieldName; ';
  Script.Add := '  Dataset.OnBeforePostValidationArray := @DatasetBeforePost; ';
  // AA, BZ 2086
  Script.Add := '  Dataset.add_runtime_procedure := @create_production_result_standard_cost;';
//  Script.Add := '  Dataset.add_runtime_procedure := @calculate_value_for_IA_waste_cost;';
  Script.Add := 'end.';
end;


procedure TMfgWithMPSInjector.MfgConst;
var
  I: Integer;
begin
  ReadOption;
  Script.Add := 'var';
  Script.Add := '  IA_SCHEDULEID_FIELDNAME : String; ';
  Script.Add := '  STDCOST_EXT_TYPE_NAME   : String; ';
  Script.Add := '  ITEM_STDCOSTNO_FIELD    : String; ';
  Script.Add := '  WC_STDCOST_EXT_TYPE_NAME : String; ';
  Script.Add := '  MFG_ACC_PERIOD : Boolean;';
  Script.Add := '';
  Script.Add := 'procedure InitializeFieldName; ';
  Script.Add := 'begin';
  Script.Add := '  IA_SCHEDULEID_FIELDNAME := ReadOption(''IA_SCHEDULEID_FIELDNAME'', ''CUSTOMFIELD1''); ';
  Script.Add := '  STDCOST_EXT_TYPE_NAME   := ReadOption(''STDCOST_EXT_TYPE_NAME'',   ''STANDARD COST''); ';
  Script.Add := '  ITEM_STDCOSTNO_FIELD    := ReadOption(''ITEM_STDCOSTNO_FIELD'',    ''CUSTOMFIELD1''); ';
  Script.Add := '  WC_STDCOST_EXT_TYPE_NAME   := ReadOption(''WC_STDCOST_EXT_TYPE_NAME'', ''WC STANDARD COST''); ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'function GetStdCostSQL(standard_cost_extended_type_name:string):String; ';
  Script.Add := 'begin';
  Script.Add := '  result := ''select ed.INFO1 GLAccount '' + ';
  for I := 1 to 19 do begin
    Script.Add := format('    '', coalesce(ed.INFO%d, ''''0'''') StdCost%d '' +', [I+1, I]);
  end;
  Script.Add := '    format(''from EXTENDEDDET ed '+
    'where ed.EXTENDEDTYPEID=(select et.EXTENDEDTYPEID from EXTENDEDTYPE et where et.EXTENDEDNAME=''''%s'''') '+
    'order by ed.ExtendedDetID'', [standard_cost_extended_type_name]); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function GetFGStdCostNo(value:variant):String; ';
  Script.Add := 'begin';
  Script.Add := '  result := ''1''; ';
  Script.Add := '  if value = null then exit;';
  Script.Add := '  if not IsNumeric( value ) then exit; ';
//  Script.Add := '  if (value < 1) and (value > 19) then exit; ';
  Script.Add := '  if ((value < 1) or (value > 19)) then exit; ';  // AA, BZ 2968
  Script.Add := '  result := value; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function shall_check_accounting_period:boolean;';
{$IFDEF TESTING}
  Script.Add := 'var';
  Script.Add := '  test_sql : TjbSQL;';
  Script.Add := 'begin';
  Script.Add := '  test_sql := CreateSQL(dataset.Tx);';
  Script.Add := '  Try';
  Script.Add := '    RunSQL(test_sql, ''Select ValueOpt From Options Where ParamOpt=''''MFG_ACC_PERIOD'''' '');';
  Script.Add := '    result :=  ( test_sql.fieldByName(''ValueOpt'')=''1'' );';
  Script.Add := '  Finally';
  Script.Add := '    test_sql.Free;';
  Script.Add := '  End;';
{$ELSE}
  Script.Add := 'begin ';
  Script.Add := '  result := ( ReadOption(''MFG_ACC_PERIOD'', ''1'')=''1'' ); ';
{$ENDIF}
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TMfgWithMPSInjector.ShowSetting;
begin
  Script.Add := 'procedure ShowSetting; ';
  Script.Add := 'var frmSetting : TForm; ';
  Script.Add := 'begin ';
  Script.Add := '  frmSetting := CreateFormSetting(''frmMfgSetting'', ''Manufacturing Setting'', 400, 400);';
  Script.Add := '  try ';
  Script.Add := '    AddControl( frmSetting, ''IA-ScheduleID Field Name'', ''CUSTOMFIELD'',  ''IA_SCHEDULEID_FIELDNAME'', ''CUSTOMFIELD1'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Std Cost Ext Type Name'',   ''TEXT'',  ''STDCOST_EXT_TYPE_NAME'', ''STANDARD COST'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Item-Std Cost No Field Name'', ''CUSTOMFIELD'', ''ITEM_STDCOSTNO_FIELD'', ''CUSTOMFIELD1'', ''0'', ''''); ';

  // AA, BZ 2086
  Script.Add := '    AddControl( frmSetting, ''Std. Cost at Production Result'', ''CHECKBOX'',  ''STDCOST_AT_PRODUCTION_RESULT'', ''0'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Work Center Std. Cost Ext Type Name'',   ''TEXT'',  ''WC_STDCOST_EXT_TYPE_NAME'', ''WC STANDARD COST'', ''0'', ''''); ';

  Script.Add := '    AddControl( frmSetting, ''Work Order No.'',   ''TEXT'',  ''WORKORDER_NEXT_NO'', ''1001'', ''0'', ''''); '; // AA, BZ 2153

  // AA, BZ 2170
  Script.Add := '    AddControl( frmSetting, ''JC MFG No.'',   ''TEXT'',  ''JC_MFG_NEXT_NO'', ''1001'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''IA MFG No.'',   ''TEXT'',  ''IA_MFG_NEXT_NO'', ''1001'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''JV MFG No.'',   ''TEXT'',  ''JV_MFG_NEXT_NO'', ''1001'', ''0'', ''''); ';

  Script.Add := '    AddControl( frmSetting, ''FG-IN Note Field Name'', ''CUSTOMFIELD'',  ''FG_IN_NOTE_FIELDNAME'', ''CUSTOMFIELD3'', ''0'', ''''); '; // AA, BZ 2138

  Script.Add := '    AddControl( frmSetting, ''MFG with Accounting Period'', ''CHECKBOX'',  ''MFG_ACC_PERIOD'', ''1'', ''0'', ''''); '; // AA, BZ 2226

  Script.Add := '    if frmSetting.ShowModal = mrOK then begin ';
  Script.Add := '      SaveToOptions; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    frmSetting.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TMfgWithMPSInjector.GenerateScriptForMain;
begin
  ClearScript;
  CreateFormSetting;
  ShowSetting;
  Script.Add := 'begin';
  Script.Add := '  AddCustomMenuSetting(''mnuMfgSetting'', ''Manufacturing Setting'', ''ShowSetting''); ';
  Script.add := 'end.';
end;

procedure TMfgWithMPSInjector.GenerateScript;
begin
  GenerateScriptForMain;
  InjectToDB( fnMain );

  GenerateForIADetDataset;
  InjectToDB( dnIADet );

  GenerateForIADataset;
  InjectToDB( dnIA );

  GenerateForSODetDataset;
  InjectToDB( dnSODet );
end;

procedure TMfgWithMPSInjector.add_function_is_standard_cost_at_production_result;
begin
  Script.Add := 'function is_standard_cost_at_production_result:boolean;';
{$IFDEF TESTING}
  Script.Add := 'var';
  Script.Add := '  test_sql : TjbSQL;';
  Script.Add := 'begin';
  Script.Add := '  test_sql := CreateSQL(dataset.Tx);';
  Script.Add := '  Try';
  Script.Add := '    RunSQL(test_sql, ''Select ValueOpt From Options Where ParamOpt=''''STDCOST_AT_PRODUCTION_RESULT'''' '');';
  Script.Add := '    result :=  ( test_sql.fieldByName(''ValueOpt'')=''1'' );';
  Script.Add := '  Finally';
  Script.Add := '    test_sql.Free;';
  Script.Add := '  End;';
  Script.Add := 'end;';
{$ELSE}
  Script.Add := 'begin';
  Script.Add := '  result := ( ReadOption(''STDCOST_AT_PRODUCTION_RESULT'', ''0'')=''1'' );';
  Script.Add := 'end;';
{$ENDIF}
  Script.Add := '';
end;

end.
