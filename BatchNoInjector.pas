unit BatchNoInjector;

interface

Uses
  DatasetBatchNoInjector
  , ScriptConst
  , BankConst;

Type
  TBatchNoInjector = class( TDatasetBatchNoInjector )
  private
    procedure add_fill_IT_det_batch_number_with_pick_list;
    procedure add_auto_fill_menus(form_type: TFormName);
    procedure add_Fill_Multi_BN_menus;
    procedure addEventBatchFieldChanged;
    procedure addProcedureCheckBN;
  protected
    procedure add_variable;
    procedure add_remove_batch_no_const;

    procedure add_OnGridDatePickerExit;
    procedure add_OnGriddatePickerKeyPress;
    procedure add_create_date_time_picker;
    procedure add_DoShowGridDatePicker;
    procedure add_setGridColumnBtnStyle_incoming;

    procedure add_make_sure_detail_can_be_edited;

    procedure add_const;

    procedure add_sales_invoice_field_read_only;
    procedure add_purchase_invoice_field_read_only;

    procedure add_DoShowBatchNoSearchForm;
    procedure add_setGridColumnBtnStyle_outgoing;
    procedure add_cannot_change_if_batch_no_exist;
    procedure add_cannot_change_if_batch_no_exist_sales_invoice;

    procedure add_DoShowBatchNoSearchForm_item_transfer;
    procedure add_cannot_change_if_batch_no_exist_item_transfer;

    procedure add_set_detail_column_read_only;
    procedure add_set_expired_field_column_read_only;
    procedure add_cannot_change_if_batch_no_exist_item_adjustment;
    procedure add_setGridColumnBtnStyle_item_adjustment;
    procedure add_is_incoming_transaction;
    procedure add_ShowColumnInputVCL;

    procedure add_fill_batch_no_information;

    procedure generate_incoming_transaction_script( formType:TFormName );
    procedure generate_jc_ro_item_script;

    procedure generate_outgoing_transaction_script( is_sales_invoice:Boolean=False );
    procedure generate_delivery_order_script;
    procedure generate_sales_invoice_script;

    procedure generate_item_transfer_script;
    procedure generate_item_adjustment_script;

    procedure generate_job_costing_script;

    procedure generate_script_for_main_form;

    procedure generate_script_for_non_batch_no_form;
    procedure MainCreateReport;
    procedure MainCreateMenuSetting;
    procedure generateItem;
  public
    procedure GenerateScript; override;
    function describe_manual_step:string; override;
  end;

implementation

Uses
  SysUtils
  , Dialogs
  , DBConst;

{ TBatchNoInjector }

procedure TBatchNoInjector.add_Fill_Multi_BN_menus;
  procedure Variables;
  begin
    Script.Add := 'const';
    Script.Add := '   SPACE   = 10;';
    Script.Add := '   Label_H = 17; ';
    Script.Add := '   Btn_H   = 20;';
    Script.Add := '   Btn_W   = 80;';

    Script.Add := '   BN_Field = ''BN'';';
    Script.Add := '   ED_Field = ''ED'';';
    Script.Add := '   Qty_FIeld = ''Qty'';';
    Script.Add := '   dsInsert = 3;';
    Script.Add := '   dsEdit   = 2;';

    Script.Add := 'var frm                : TForm;';
    Script.Add := '    lblItem            : TLabel;';
    Script.Add := '    grid               : TjbGrid;';
    Script.Add := '    btnOK              : TButton;';
    Script.Add := '    btnCancel          : TButton;';
    Script.Add := '    BnDataset          : TJvMemoryData;';
    Script.Add := '    BnDatasource       : TDataSource;';
    Script.Add := '    OldBN              : String;';
    Script.Add := '    CurrentItemNo      : String;';
    Script.Add := '    CurrentAPInvoiceID : Integer;';
    Script.Add := '    CurrentSeq         : Integer;';
    Script.Add := '    uom_qty1           : String;';
  end;

  procedure CreateControls;
  begin
    Script.Add := 'procedure CreateControls;';
    Script.Add := 'begin';
    Script.Add := '  lblItem := CreateLabel( SPACE, SPACE, 200, Label_H, ''Item: '' + Detail.ItemNo.value + '' - '' +'+
      ' Detail.ItemOvDesc.value, frm );';
    Script.Add := '  grid    := CreateJBGrid( frm );';
    Script.Add := '  TControl(grid).parent := frm;                                ';
    Script.Add := '  TControl(grid).SetBounds( lblItem.Left, TopPos(lblItem, SPACE), frm.ClientWidth - (2*SPACE), '+
                       'frm.ClientHeight - (4*SPACE) - Label_H - Btn_H ); ';
    Script.Add := '  btnOK     := CreateBtn( SPACE, TopPos(grid, SPACE), Btn_W, Btn_H, 0, ''&OK'', frm );';
    Script.Add := '  btnCancel := CreateBtn( LeftPos(btnOK), btnOK.Top, Btn_W, Btn_H, 0, ''&Cancel'', frm );';
    Script.Add := 'end;';
    Script.Add := '';
  end;

  procedure DecorateControls;
  begin
    Script.Add := 'procedure DecorateControls;';
    Script.Add := 'begin';
    Script.Add := '  BnDataset.BeforePost  := @OnBnDatasetBeforePost;';
    Script.Add := '  BnDataset.OnNewRecord := @OnNewRecordBnDataset;';
    Script.Add := '  BnDataset.AfterPost   := @OnBnDatasetAfterPost;';
    Script.Add := '  BnDatasource.Dataset  := BnDataset;';
    Script.Add := '  grid.dataSource       := BnDatasource;';
    Script.Add := '  btnCancel.ModalResult := mrCancel;';
    Script.Add := '  btnOK.OnClick         := @OnBtnOKClick;';
    Script.Add := '  frm.OnResize          := @OnFormResize;';
    Script.Add := '  frm.OnClose           := @OnFormClose;';
    Script.Add := 'end;';
    Script.Add := '';
    Script.Add := 'procedure DecorateGrid;';
    Script.Add := '  procedure CreateCol(AFieldName, ACaption:String);';
    Script.Add := '  begin';
    Script.Add := '    with grid.Columns.Add do begin';
    Script.Add := '      FieldName := AFieldName;';
    Script.Add := '      Title.Caption := ACaption;';
    Script.Add := '      Title.Alignment := taCenter;';
    Script.Add := '    end;';
    Script.Add := '  end;';
    Script.Add := 'begin';
    Script.Add := '  CreateCol(BN_Field , ''Batch Number'');';
    Script.Add := '  CreateCol(ED_Field , ''Expired Date'');';
    Script.Add := '  CreateCol(Qty_FIeld, ''Quantity''    );';
    Script.Add := 'end;';
    Script.Add := '';
  end;

  procedure CopyRecordFromExisting;
  begin
    Script.Add := '  procedure CopyRecordFromExisting;';
    Script.Add := '  var sqlCurrent : TjbSQL;';
    Script.Add := '      idxField   : Integer;';
    Script.Add := '    procedure AssignField( AFieldName:String );';
    Script.Add := '    begin';
    Script.Add := '        Detail.FieldByName( AFieldName ).asVariant := sqlCurrent.FieldByName( AFieldName );';
    Script.Add := '    end;';
    Script.Add :='';
    Script.Add := '    procedure AssignExtendedField( AFieldName:String );';
    Script.Add := '    begin';
    Script.Add := '        Detail.ExtendedID.FieldLookup.FieldByName( AFieldName ).asVariant := sqlCurrent.FieldByName( AFieldName );';
    Script.Add := '    end;';
    Script.Add :='';
    Script.Add := '    function GetCurrentSQL:String;';
    Script.Add := '    begin';
    Script.Add := '      result := format(''Select * from APItmDet aid join Extended e on e.ExtendedID=aid.ExtendedID '+
                           'where aid.APInvoiceID=%d and aid.Seq=%d and aid.ItemNo=''''%s'''' '', '+
                           '[CurrentAPInvoiceID, CurrentSeq, CurrentItemNo]);';
    Script.Add := '    end;';
    Script.Add := '  begin';
    Script.Add := '    sqlCurrent := CreateSQL( detail.Tx );';
    Script.Add := '    try';
    Script.Add := '      RunSQL( sqlCurrent, GetCurrentSQL );';
    Script.Add := '      if sqlCurrent.RecordCount = 0 then exit;';
    Script.Add := '      Detail.Append;';
    Script.Add := '      AssignField( ''ItemNo'' );';
    Script.Add := '      AssignField( ''BRUTOUNITPRICE'' );';
    Script.Add := '      AssignField( ''TAXCODES'' );';
    Script.Add := '      AssignField( ''POID'' );';
    Script.Add := '      AssignField( ''ITEMUNIT'' );';
    Script.Add := '      AssignField( ''POSEQ'' );';
    Script.Add := '      AssignField( ''ITEMDISCPC'' );';
    Script.Add := '      AssignField( ''BILLID'' );';
    Script.Add := '      for idxField := 1 to 10 do begin';
    Script.Add := '        AssignField( ''ITEMRESERVED'' + IntToStr(idxField) );';
    Script.Add := '      end;';
    Script.Add := '      AssignField( ''DEPTID'' );';
    Script.Add := '      AssignField( ''PROJECTID'' );';
    Script.Add := '      AssignField( ''WAREHOUSEID'' );';
    Script.Add := '      AssignField( ''ITEMOVDESC'' );';
    Script.Add := '      for idxField := 1 to 20 do begin';
    Script.Add := '        AssignExtendedField( ''CUSTOMFIELD'' + IntToStr(idxField) );';
    Script.Add := '      end;';
    Script.Add := '      for idxField := 1 to 20 do begin';
    Script.Add := '        AssignExtendedField( ''LOOKUP'' + IntToStr(idxField) );';
    Script.Add := '      end;';
    Script.Add := '      if is_distribution_variant then begin';
    Script.Add := '        detail.ExtendedID.FieldLookUp.fieldByName( uom_qty1 ).AsCurrency := StrSQLToCurr(BnDataset.FieldByName(Qty_Field).value);'; // AA, BZ 3140
    Script.Add := '      end';
    Script.Add := '      else begin';
    Script.Add := '        detail.quantity.AsCurrency := StrSQLToCurr(BnDataset.FieldByName(Qty_Field).value);';
    Script.Add := '      end;';
    Script.Add := '      Detail.FieldByName(BATCHFIELD).value   := BnDataset.FieldByName(BN_Field).value;';
    Script.Add := '      Detail.FieldByName(EXPIREDFIELD).value := BnDataset.FieldByName(ED_Field).value;';
    Script.Add := '      Detail.Post;';
    Script.Add := '    finally';
    Script.Add := '      sqlCurrent.Free;';
    Script.Add := '    end;';
    Script.Add := '  end;';
    Script.Add := '';
  end;

  procedure SplitBN;
  begin
    Script.Add := 'procedure SplitBN;';
    Script.Add := '  procedure DeleteCurrentRecord;';
    Script.Add := '  begin';
    Script.Add := '    Detail.First;';
    Script.Add := '    if Detail.Locate(''APInvoiceID;Seq'', [CurrentAPInvoiceID, CurrentSeq], 0) then begin';
    Script.Add := '      Detail.Delete;';
    Script.Add := '    end;';
    Script.Add := '  end;';
    Script.Add := '';
    Script.Add := '  function RecordCount:Integer;';
    Script.Add := '  begin';
    Script.Add := '    result := 0;';
    Script.Add := '    BnDataset.first;';
    Script.Add := '    while not BnDataset.EOF do begin';
    Script.Add := '      inc( result );';
    Script.Add := '      BnDataset.Next;';
    Script.Add := '    end;';
    Script.Add := '  end;';
    Script.Add := 'begin';
    Script.Add := '  if RecordCount = 0 then RaiseException(''Please input at least 1 Batch Number'');';
    Script.Add := '  if RecordCount = 1 then begin';
    Script.Add := '    Detail.Edit;';
    Script.Add := '    Detail.FieldByName( BATCHFIELD ).value   := BnDataset.FieldByName(BN_Field).value ; ';
    Script.Add := '    Detail.FieldByName( EXPIREDFIELD ).value := BnDataset.FieldByName(ED_Field).value ; ';
    Script.Add := '    if is_distribution_variant then begin';
    Script.Add := '      detail.ExtendedID.FieldLookUp.fieldByName( uom_qty1 ).AsCurrency := StrSQLToCurr(BnDataset.FieldByName(Qty_Field).value);'; // AA, BZ 3140
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      detail.quantity.AsCurrency := StrSQLToCurr(BnDataset.FieldByName(Qty_Field).value);';
    Script.Add := '    end;';
    Script.Add := '    Detail.post;';
    Script.Add := '    exit;';
    Script.Add := '  end;';
    Script.Add := '  BnDataset.First;';
    Script.Add := '  Detail.DisableControls;';
    Script.Add := '  try';
    Script.Add := '    while not BnDataset.EOF do begin';
    Script.Add := '      CopyRecordFromExisting;';
    Script.Add := '      BnDataset.Next;';
    Script.Add := '    end;';
    Script.Add := '    DeleteCurrentRecord;';
    Script.Add := '  finally';
    Script.Add := '    Detail.EnableControls;';
    Script.Add := '  end;';
    Script.Add := 'end;';
    Script.Add := '';
  end;

  procedure Events;
  begin
    Script.Add := 'procedure OnBtnOKClick;';
    Script.Add := 'begin';
    Script.Add := '  SplitBN;';
    Script.Add := '  frm.ModalResult := mrOK;';
    Script.Add := 'end;';
    Script.Add := '';
    Script.Add := 'procedure OnBnDatasetBeforePost;';
    Script.Add := '  procedure ValidateField( AFieldName, AMsg:String );';
    Script.Add := '  begin';
    Script.Add := '    if BnDataset.FieldByName( AFieldName ).isNull then RaiseException(AMsg + '' Must have a value'');';
    Script.Add := '  end;';
    Script.Add := 'begin';
    Script.Add := '  ValidateField(BN_Field, ''Batch Number'');';
    Script.Add := '  ValidateField(Qty_Field, ''Quantity'');';
    Script.Add := 'end;';
    Script.Add := '';
    Script.Add := 'procedure OnBnDatasetAfterPost;';
    Script.Add := 'begin';
    Script.Add := '  OldBN := BnDataset.FieldByName(ED_Field).value;';
    Script.Add := 'end;';
    Script.Add := '';
    Script.Add := 'procedure OnNewRecordBnDataset;';
    Script.Add := 'begin';
    Script.Add := '  if OldBN = '''' then begin';
    Script.Add := '    BnDataset.FieldByName(BN_Field).value  := Detail.FieldByName( BATCHFIELD ).value; ';
    Script.Add := '    BnDataset.FieldByName(ED_Field).value  := Detail.FieldByName( EXPIREDFIELD ).value; ';
    Script.Add := '    BnDataset.FieldByName(Qty_Field).value := Detail.Quantity.value; ';
    Script.Add := '    if (not BnDataset.FieldByName(BN_Field).IsNull) and (BnDataset.FieldByName(BN_Field).value <> '''') then begin';
    Script.Add := '      BnDataset.post;';
    Script.Add := '    end;';
    Script.Add := '  end';
    Script.Add := '  else begin';
    Script.Add := '    BnDataset.FieldByName(ED_Field).value := OldBN;';
    Script.Add := '  end;';
    Script.Add := '  grid.SelectedIndex := 0;';
    Script.Add := 'end;';
    Script.Add := '';
    Script.Add := 'procedure OnFormResize;';
    Script.Add := 'begin';
    Script.Add := '  lblItem.Width  := frm.ClientWidth - (2*SPACE);';
    Script.Add := '  grid.Width     := frm.ClientWidth - (2*SPACE);';
    Script.Add := '  grid.Height    := frm.ClientHeight - (4*SPACE) - Label_H - Btn_H;';
    Script.Add := '  btnOK.Top      := TopPos(grid, SPACE);';
    Script.Add := '  btnOK.Left     := (frm.ClientWidth - (2 * Btn_W)) div 3;';
    Script.Add := '  btnCancel.Top  := btnOK.Top;';
    Script.Add := '  btnCancel.Left := LeftPos(btnOK, btnOK.Left);';
    Script.Add := 'end;';
    Script.Add := '';
    Script.Add := 'procedure OnFormClose(Sender: TObject;var Action: TCloseAction);';
    Script.Add := 'var ini : TInifile; ';
    Script.Add := '    idx : Integer; ';
    Script.Add := 'begin';
    Script.Add := '  ini := TInifile.Create( GetApplicationDataDir + ''SplitBNForm.ini'');';
    Script.Add := '  try';
    Script.Add := '    ini.writeInteger(''form'', ''width'',  frm.Width);';
    Script.Add := '    ini.writeInteger(''form'', ''height'', frm.Height);';
    Script.Add := '    ini.writeInteger(''grid'', ''count'',  grid.Columns.count); ';
    Script.Add := '    for idx := 0 to grid.Columns.count-1 do begin';
    Script.Add := '      ini.writeInteger(''grid'', intToStr(idx), grid.Columns[idx].Width);';
    Script.Add := '    end;';
    Script.Add := '  finally';
    Script.Add := '    ini.Free; ';
    Script.Add := '  end;';
    Script.Add := '  Action := caFree; ';
    Script.Add := 'end;';
    Script.Add := '';
    Script.Add := 'procedure LoadDataFromIniFile; ';
    Script.Add := 'var ini:TInifile; ';
    Script.Add := '    idx : Integer; ';
    Script.Add := 'begin';
    Script.Add := '  ini := TInifile.Create( GetApplicationDataDir + ''SplitBNForm.ini'' ); ';
    Script.Add := '  try';
    Script.Add := '    frm.Width          := ini.ReadInteger(''form'', ''width'', 800);';
    Script.Add := '    frm.Height         := ini.ReadInteger(''form'', ''height'', 600);';
    Script.Add := '    for idx := 0 to ini.ReadInteger(''grid'', ''count'', 1)-1 do begin';
    Script.Add := '      grid.Columns[idx].Width := ini.ReadInteger(''grid'', intToStr(idx), 10);';
    Script.Add := '    end;';
    Script.Add := '  finally';
    Script.Add := '    ini.Free; ';
    Script.Add := '  end;';
    Script.Add := 'end;';
    Script.Add := '';

  end;

  procedure CreateDataset;
  begin
    Script.Add := 'procedure CreateDataset;';
    Script.Add := 'begin';
    Script.Add := '  BnDataset := TJvMemoryData.Create( frm );';
    Script.Add := '  BnDataset.FieldDefs.Add( ''BN'',  ftString, 40, False ); ';
    Script.Add := '  BnDataset.FieldDefs.Add( ''ED'',  ftDate, 0, false ); ';
    Script.Add := '  BnDataset.FieldDefs.Add( ''Qty'', ftFloat, 0, false ); ';
    Script.Add := '  BnDataset.Open;';
    Script.Add := '  BnDatasource := TDataSource.Create( frm );';
    Script.Add := 'end;';
  end;
  procedure GetCurrentValue;
  begin
    Script.Add := '  procedure GetCurrentValue;';
    Script.Add := '  begin';
    Script.Add := '    CurrentItemNo      := Detail.ItemNo.value;';
    Script.Add := '    CurrentAPInvoiceID := Detail.FieldByName(''APInvoiceID'').value;';
    Script.Add := '    CurrentSeq         := Detail.Seq.value;';
    Script.Add := '  end;';
    Script.Add := '';
  end;
begin
  CreateMenu;
  CreateForm;
  CreateLabel;
  CreateButton;
  TopPos;
  LeftPos;
  Script.Add := 'procedure do_Fill_Multi_BN;';
  Variables;
  is_distro_variant;
  CreateControls;
  DecorateControls;
  CreateDataset;
  CopyRecordFromExisting;
  SplitBN;
  Events;
  GetCurrentValue;
  Script.Add := 'begin';
  Script.Add := '  if detail.ItemNo.isNull then RaiseException(''Please input Item first'');';
  Script.Add := '  GetCurrentValue;';
  Script.Add := '  if (Detail.State = dsEdit) or (Detail.State = dsInsert) then begin';
  Script.Add := '    Detail.Post;';
  Script.Add := '  end;';
  Script.Add := '  if is_distribution_variant then begin';
  Script.Add := '    uom_qty1 := ReadOption(''' + STR_UOM_QTY1 + ''', ''' + STR_DEFAULT_UOM_QTY1 + ''');';
  Script.Add := '  end;';
  Script.Add := '  frm := CreateForm(''frmFillMultiBN'', ''Fill Multiple Batch Number'', 800, 600);';
  Script.Add := '  try';
  Script.Add := '    OldBN := '''';';
  Script.Add := '    CreateControls;';
  Script.Add := '    CreateDataset;';
  Script.Add := '    DecorateControls;';
  Script.Add := '    DecorateGrid;';
  Script.Add := '    BnDataset.Append;';
  Script.Add := '    LoadDataFromIniFile; ';
  Script.Add := '    frm.ShowModal;';
  Script.Add := '  finally';
  Script.Add := '    frm.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'Procedure Add_Fill_Multi_BN_Menus;';
  Script.Add := 'var';
  Script.Add := '  new_menu : TMenuItem;';
  Script.Add := 'begin';
  Script.Add := '  new_menu := CreateMenu(-1, nil, ''mnuFillMultiBN'', ''Fill Multi Batch Number'', ''do_Fill_Multi_BN'');';
  Script.Add := '  new_menu.Shortcut := 16461; // Ctrl + M';
  Script.Add := '  form.popItem.items.add(new_menu);';
  Script.Add := 'end;';
  Script.Add := '';
end;


procedure TBatchNoInjector.addEventBatchFieldChanged;
begin
  Script.Add := 'procedure batchFieldChanged; ';
  Script.Add := '  function getExpiredDate:String; ';
  Script.Add := '  var sqlExp : TjbSQL; ';
  Script.Add := '  const BATCH_NO_NOT_FOUND = ''Batch number not found''; ';
  Script.Add := '  begin ';
  Script.Add := '    sqlExp := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '    try ';
  Script.Add := '      RunSQL( sqlExp, Format(''Select first 1 ExpiredDate from ItemSN '+
                         'where ItemNo=''''%s'''' and SN=''''%s'''' and WarehouseID=%d'','+
//                         '[detail.ItemNo.AsString, detail.FieldByName(BATCHFIELD).AsString, master.WarehouseID.AsInteger]) ); ';
//                         '[detail.ItemNo.AsString, detail.FieldByName(BATCHFIELD).AsString, detail.WarehouseID.AsInteger]) ); '; // AA, BZ 2891
  //MMD, BZ 3626 - 3628
                         '[detail.ItemNo.AsString, detail.FieldByName(BATCHFIELD).AsString, ';
  if is_item_transfer then begin
    Script.Add := '      Master.FromWHID.AsInteger]) );';
  end
  else begin
    Script.Add := '      detail.WarehouseID.AsInteger]));';
  end;

  Script.Add := '      if sqlExp.Eof then begin ';
  Script.Add := '        detail.FieldByName(EXPIREDFIELD).Value := NULL; ';
  Script.Add := '        detail.FieldByName(BATCHFIELD).Value := NULL; ';
  Script.Add := '        raiseException(BATCH_NO_NOT_FOUND); ';
  Script.Add := '      end; ';
  Script.Add := '      result := sqlExp.FieldByName(''ExpiredDate''); ';
  Script.Add := '    finally ';
  Script.Add := '      sqlExp.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := '  if NOT detail.FieldByName(BATCHFIELD).IsNULL then begin ';
  if is_item_adjustment then begin                 //JR, BZ 2696  only for item out.
    Script.Add := '    if master.AdjCheck.AsBoolean = False then begin ';
    Script.Add := '      detail.FieldByName(EXPIREDFIELD).AsString := getExpiredDate; ';
    Script.Add := '    end; ';
  end
  else if is_arinv then begin //JR, BZ 2697
    Script.Add := '    if (Not master.GetFromDO.asBoolean) then begin'; // AA, BZ 2914
    Script.Add := '      detail.FieldByName(EXPIREDFIELD).AsString := getExpiredDate; ';
    Script.Add := '    end; ';
  end
  
  //MMD, BZ 3626 - 3628
  else if is_pr then begin
    Script.Add := '    if (Master.WITHOUTPI.value = 1) then begin';
    Script.Add := '      detail.FieldByName(EXPIREDFIELD).AsString := getExpiredDate;';
    Script.Add := '    end; ';
  end
  else begin
    Script.Add := '    detail.FieldByName(EXPIREDFIELD).AsString := getExpiredDate;';
  end;
  
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TBatchNoInjector.add_auto_fill_menus(form_type:TFormName);

  function get_parent_menu_object_name:string;
  begin
    if form_type=fnJobCosting then begin
      result := 'PopUpMenu2';
    end
    else begin
      result := 'PopUpMenu1';
    end;
  end;

begin
  CreateMenu;
  Script.Add := '  procedure do_auto_fill_for_all_item;';
  Script.Add := '  begin';
  Script.Add := '    detail.execute_runtime_procedure(''do_auto_fill_for_all_item'');';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  procedure do_clear_batch_no_info;';
  Script.Add := '  begin';
  Script.Add := '    detail.execute_runtime_procedure(''do_clear_batch_no_info'');';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  Procedure add_auto_fill_menus;';
  Script.Add := '  var';
  Script.Add := '    new_menu : TMenuItem;';
  Script.Add := '  begin';
  Script.Add := '    new_menu := CreateMenu(-1, nil, ''mnuBNAutoFill'', ''Fill batch number'', ''do_auto_fill_for_all_item'');';
  Script.Add := '    new_menu.Shortcut := 16449; // Ctrl + A';
  Script.Add := '    form.' + get_parent_menu_object_name + '.items.add(new_menu);';
  Script.Add := '';
  Script.Add := '    new_menu := CreateMenu(-1, nil, ''mnuBNClear'', ''Clear batch number'', ''do_clear_batch_no_info'');';
  Script.Add := '    new_menu.Shortcut := 16451; // Ctrl + C';
  Script.Add := '    form.' + get_parent_menu_object_name + '.items.add(new_menu);';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.add_cannot_change_if_batch_no_exist;
begin
  Script.Add := '  procedure cannot_change_if_batch_no_exist;';
  Script.Add := '  begin';
  Script.Add := '    if ( detail.FieldByName( BatchField ).AsString<>'''' ) then begin';
  Script.Add := '      RaiseException( REMOVE_BATCH_NO );';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.add_create_date_time_picker;
begin
  Script.Add := '  procedure create_date_time_picker;';
  Script.Add := '  begin';
  Script.Add := '    exp_date_picker := TDateTimePicker.Create( form );';
  Script.Add := '    exp_date_picker.dateFormat := dfLong;';
  Script.Add := '    exp_date_picker.Visible := False;';
  Script.Add := '    exp_date_picker.Parent := ItemGrid;';
  Script.Add := '';
  Script.Add := '    exp_date_picker.OnExit := @OnGridDatePickerExit;';
  Script.Add := '    exp_date_picker.OnKeyPress := @OnGriddatePickerKeyPress;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.add_DoShowBatchNoSearchForm;
begin
  Script.Add := '  procedure DoShowBatchNoSearchForm;';
  Script.Add := '  var';
  Script.Add := '    BNForm : TBatchNoSearchForm;';
  Script.Add := '  begin';
  Script.Add := '    if ( CompareText( ItemGrid.CurrentSelectedField.FieldName, BATCHFIELD )=0 ) and ( Not ItemGrid.CurrentSelectedField.ReadOnly ) then begin';
  Script.Add := '      BNForm := TBatchNoSearchForm.Create( nil );';
  Script.Add := '      Try';
  Script.Add := '        if detail.FieldByName( WAREHOUSEFIELD ).isNull then begin';
  Script.Add := '          BNForm.warehouse_id := -1;';
  Script.Add := '        end';
  Script.Add := '        else begin';
  Script.Add := '          BNForm.warehouse_id := detail.FieldByName( WAREHOUSEFIELD ).AsInteger;';
  Script.Add := '        end;';
  Script.Add := '';
  Script.Add := '        if detail.ItemNo.isNull then begin';
  Script.Add := '          BNForm.item_no := '''' ;';
  Script.Add := '        end';
  Script.Add := '        else begin';
  Script.Add := '          BNForm.item_no := detail.ItemNo.AsString;';
  Script.Add := '        end;';
  Script.Add := '';
  Script.Add := '        if ( BNForm.ShowModal=mrOk ) then begin';
  Script.Add := '          make_sure_detail_can_be_edited;';
  Script.Add := '          detail.fieldByName( BATCHFIELD ).AsString := BNForm.selected_batch_no;';
  Script.Add := '          detail.fieldByName( EXPIREDFIELD ).AsString := BNForm.selected_expired_date;';
  Script.Add := '        end;';
  Script.Add := '      Finally';
  Script.Add := '        BNForm.Free;';
  Script.Add := '      End;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.add_DoShowGridDatePicker;
begin
  Script.Add :='  procedure DoShowGridDatePicker;';
  Script.Add :='  begin';
  Script.Add :='    if ( CompareText( ItemGrid.CurrentSelectedField.FieldName, EXPIREDFIELD )=0 ) and ( Not ItemGrid.CurrentSelectedField.ReadOnly ) then begin';
  Script.Add :='      exp_date_picker.Left := ItemGrid.GetCellRectLeft;';
  Script.Add :='      exp_date_picker.Top := ItemGrid.GetCellRectTop;';
  Script.Add :='      exp_date_picker.Height := ItemGrid.RowsHeight;';
  Script.Add :='      exp_date_picker.Width := ItemGrid.get_current_column_width;';
  Script.Add :='      ItemGrid.EditorMode := False;';
  Script.Add :='      exp_date_picker.Show;';
  Script.Add :='      exp_date_picker.setfocus;';
  Script.Add :='    end;';
  Script.Add :='  end;';
  Script.Add :='';
end;

procedure TBatchNoInjector.add_OnGridDatePickerExit;
begin
  Script.Add := '  procedure OnGridDatePickerExit(sender: TObject);';
  Script.Add := '  var';
  Script.Add := '    d, m, y :word;';
  Script.Add := '  begin';
  Script.Add := '    exp_date_picker.hide;';
  Script.Add := '    make_sure_detail_can_be_edited;';
  Script.Add := '    Detail.FieldByName( EXPIREDFIELD ).AsString := DateToStrSQL( exp_date_picker.date );';
  Script.Add := '    ItemGrid.Setfocus;';
  Script.Add := '  end;';
  Script.Add := '';  
end;

procedure TBatchNoInjector.add_OnGriddatePickerKeyPress;
begin
  Script.Add := '  procedure OnGriddatePickerKeyPress(sender: TObject; var Key: Char);';
  Script.Add := '  begin';
  Script.Add := '    if ( Key='' '' ) then begin';
  Script.Add := '      Key := #0;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.add_setGridColumnBtnStyle_incoming;
begin
  Script.Add := '  procedure setGridColumnBtnStyle;';
  Script.Add := '  begin';
  Script.Add := '    ItemGrid.set_grid_column_btn_style_ellipsis( EXPIREDFIELD );';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.add_setGridColumnBtnStyle_outgoing;
begin
  Script.Add := '  procedure setGridColumnBtnStyle;';
  Script.Add := '  begin';
  Script.Add := '    ItemGrid.set_grid_column_btn_style_ellipsis( BATCHFIELD );';
  Script.Add := '    ItemGrid.set_grid_column_read_only( EXPIREDFIELD, True );';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.add_make_sure_detail_can_be_edited;
begin
  Script.Add := '  procedure make_sure_detail_can_be_edited;';
  Script.Add := '  begin';
  Script.Add := '    if Not ( detail.state in [2, 3] ) then begin';
  Script.Add := '      detail.edit;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.GenerateScript;
begin
  is_item_adjustment := False;
  setup_database_setting;

  // generate script for dataset.
  inherited;

  // generate script for form.
  generate_incoming_transaction_script( fnReceiveItem );
  InjectToDB( fnReceiveItem );
  generate_incoming_transaction_script( fnARRefund );
  InjectToDB( fnARRefund );
  generate_incoming_transaction_script( fnAPInvoice );
  InjectToDB( fnAPInvoice );

  generate_outgoing_transaction_script;
  InjectToDB( fnDM );

  generate_job_costing_script;
  InjectToDB( fnJobCosting );

  generate_delivery_order_script;
  InjectToDB( fnDeliveryOrder );

  generate_sales_invoice_script;
  InjectToDB( fnARInvoice );

  generate_item_transfer_script;
  InjectToDB( fnTransferForm );

  generate_item_adjustment_script;
  InjectToDB( fnInvAdjustment );

  generate_jc_ro_item_script;
  InjectToDB( fnJCRollOver );

  generate_script_for_main_form;
  InjectToDB( fnMain );

  generate_script_for_non_batch_no_form;
  InjectToDB( fnSalesOrder );
  InjectToDB( fnPurchaseOrder );
  InjectToDB( fnRequestForm );

  generateItem;
  InjectToDB( fnItem );
end;

procedure TBatchNoInjector.generate_delivery_order_script;
begin
  Script.Clear;

  add_const;

  add_DoShowBatchNoSearchForm;
  add_cannot_change_if_batch_no_exist;

  add_setGridColumnBtnStyle_outgoing;
  add_make_sure_detail_can_be_edited;

  add_auto_fill_menus( fnDeliveryOrder );

  Script.Add := 'procedure check_bn; ';  //JR, BZ ....
  Script.Add := 'var sql_search_bn : TjbSQL; ';
  Script.Add := 'begin ';
  Script.Add := '  sql_search_bn := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sql_search_bn, Format(''select i.EXPIREDDATE from ITEMSN i where i.SN = ''''%s'''' '',[Detail.FieldByName(BATCHFIELD).AsString]) ); ';
  Script.Add := '    make_sure_detail_can_be_edited; ';
  Script.Add := '    if sql_search_bn.Eof then begin ';
  Script.Add := '        detail.FieldByName(EXPIREDFIELD).Value := NULL; '; // AA, BZ 3941
  Script.Add := '    end';
  Script.Add := '    else begin';
//  Script.Add := '      detail.fieldByName( BATCHFIELD ).AsString := Detail.FieldByName(BATCHFIELD).AsString; '; // AA, BZ 3941
  Script.Add := '      detail.fieldByName( EXPIREDFIELD ).AsString := sql_search_bn.FieldByName(''ExpiredDate''); ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    sql_search_bn.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'var cash_disc_pc : Variant; ';
  Script.Add := 'procedure do_before_post_array; '; //JR, BZ 2490
  Script.Add := 'begin ';
  Script.Add := '  cash_disc_pc := Master.CashDiscPC.Value; ';
  Script.Add := '  Master.CashDiscPC.Value := 0; '; //this is to skip validate in FINA code
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure do_after_post_array; ';
  Script.Add := 'begin ';
  Script.Add := '  Master.CashDiscPC.Value := cash_disc_pc; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'BEGIN';
  Script.Add := '  TjbIntegerField( Detail.FieldByName(BATCHFIELD) ).OnChangeArray := @check_bn; ';
  Script.Add := '  ItemGrid.OnGridLayoutArray := @setGridColumnBtnStyle;';
  Script.Add := '  ItemGrid.OnEditButtonClickArray := @DoShowBatchNoSearchForm;';
  Script.Add := '  TjbIntegerField( detail.FieldByName( WAREHOUSEFIELD ) ).OnValidateArray := @cannot_change_if_batch_no_exist;';
  Script.Add := '  add_auto_fill_menus;';
  Script.Add := '  Detail.OnBeforePostArray := @do_before_post_array; ';
  Script.Add := '  Detail.OnAfterPostArray  := @do_after_post_array; ';
  Script.Add := 'END.';
end;

procedure TBatchNoInjector.generate_incoming_transaction_script( formType:TFormName );
begin
  Script.Clear;

//  Script.Add := 'Const';
//  add_expired_date_field_const;
  add_read_option_function;
  add_expired_date_parameter_function;
//  if formType=fnAPInvoice then begin
//    add_batch_field_const;
    add_batch_no_parameter_function;
//  end;
//  Script.Add := '';

  add_variable;

  add_OnGridDatePickerExit;
  add_OnGriddatePickerKeyPress;
  add_create_date_time_picker;
  add_DoShowGridDatePicker;
  add_setGridColumnBtnStyle_incoming;
  add_make_sure_detail_can_be_edited;

  if formType=fnAPInvoice then begin
    add_purchase_invoice_field_read_only;
  end;
  if formType <> fnARRefund then begin
    add_Fill_Multi_BN_menus;
  end;

  Script.Add := 'BEGIN';
  Script.Add := '  create_date_time_picker;';
  Script.Add := '  ItemGrid.OnGridLayoutArray := @setGridColumnBtnStyle;';
  if formType=fnAPInvoice then begin
    Script.Add := '  Master.Bill.OnChangeArray := @set_batch_no_and_expired_date_field_read_only;';
  end;
  Script.Add := '  ItemGrid.OnEditButtonClickArray := @DoShowGridDatePicker;';

  if formType <> fnARRefund then begin
    Script.Add := '  Add_Fill_Multi_BN_Menus;';
  end;

  Script.Add := 'END.';
end;

procedure TBatchNoInjector.generate_outgoing_transaction_script( is_sales_invoice:Boolean=False );
begin
  Script.Clear;

  add_const;

  add_DoShowBatchNoSearchForm;
  add_cannot_change_if_batch_no_exist;

  add_setGridColumnBtnStyle_outgoing;
  add_make_sure_detail_can_be_edited;
  
  //MMD, BZ 3628
  is_pr := True;
  addEventBatchFieldChanged;
  is_pr := False;
  
  Script.Add := 'BEGIN';
  Script.Add := '  ItemGrid.OnGridLayoutArray := @setGridColumnBtnStyle;';
  Script.Add := '  ItemGrid.OnEditButtonClickArray := @DoShowBatchNoSearchForm;';
  Script.Add := '  TjbIntegerField( detail.FieldByName( WAREHOUSEFIELD ) ).OnValidateArray := @cannot_change_if_batch_no_exist;';
  Script.Add := '  TExtendedCustomField(detail.FieldByName(BATCHFIELD)).OnChangeArray := @batchFieldChanged; '; //MMD, BZ 3628
  Script.Add := 'END.';
end;

procedure TBatchNoInjector.generate_item_adjustment_script;
begin
  Script.Clear;
  is_item_adjustment := True;
  add_const;
  add_variable;

  add_OnGridDatePickerExit;
  add_OnGriddatePickerKeyPress;
  add_create_date_time_picker;
  add_DoShowGridDatePicker;
  add_make_sure_detail_can_be_edited;
  add_DoShowBatchNoSearchForm;
  add_cannot_change_if_batch_no_exist_item_adjustment;
  add_ShowColumnInputVCL;
  add_setGridColumnBtnStyle_item_adjustment;
  add_is_incoming_transaction;
  add_set_expired_field_column_read_only;

  add_auto_fill_menus( fnInvAdjustment );
  addEventBatchFieldChanged;
  Script.Add := 'BEGIN';
  Script.Add := '  create_date_time_picker;';
  Script.Add := '  ItemGrid.OnGridLayoutArray := @setGridColumnBtnStyle;';
  Script.Add := '  ItemGrid.OnEditButtonClickArray := @showColumnInputVCL;';
  Script.Add := '  TjbIntegerField( detail.FieldByName( WAREHOUSEFIELD ) ).OnValidateArray := @cannot_change_if_batch_no_exist;';
  Script.Add := '  set_expired_field_column_read_only;';
  Script.Add := '  master.AdjCheck.OnValidateArray := @set_expired_field_column_read_only;';
  Script.Add := '  add_auto_fill_menus;';
  Script.Add := '  TExtendedCustomField(detail.FieldByName(BATCHFIELD)).OnChangeArray := @batchFieldChanged; ';
  Script.Add := 'END.';
end;

procedure TBatchNoInjector.add_remove_batch_no_const;
begin
  Script.Add := '  REMOVE_BATCH_NO = ''Warehouse cannot be changed, unless batch number removed first.'';';
end;

procedure TBatchNoInjector.add_const;
begin
  Script.Add := 'Const';
//  add_batch_field_const;
//  add_expired_date_field_const;
  add_warehouse_field_const;
  add_remove_batch_no_const;
  Script.Add := '';

  add_read_option_function;
  add_batch_no_parameter_function;
  add_expired_date_parameter_function;
end;

procedure TBatchNoInjector.add_is_incoming_transaction;
begin
  Script.Add := '  function is_incoming_transaction:boolean;';
  Script.Add := '  begin';
  Script.Add := '    result := master.Adjcheck.AsBoolean;';
  Script.Add := '  end;';
  Script.add := '';
end;

procedure TBatchNoInjector.add_variable;
begin
  Script.Add := 'Var';
  Script.Add := '  exp_date_picker : TDateTimePicker;';
  Script.Add := '';
end;

procedure TBatchNoInjector.add_ShowColumnInputVCL;
begin
  Script.Add := '  procedure showColumnInputVCL;';
  Script.Add := '  begin';
  Script.Add := '    if is_incoming_transaction then begin';
  Script.Add := '      DoShowGridDatePicker;';
  Script.Add := '    end';
  Script.Add := '    else begin ';
  Script.Add := '      DoShowBatchNoSearchForm;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.add_setGridColumnBtnStyle_item_adjustment;
begin
  Script.Add := '  procedure setGridColumnBtnStyle;';
  Script.Add := '  begin';
  Script.Add := '    ItemGrid.set_grid_column_btn_style_ellipsis( BATCHFIELD );';
  Script.Add := '    ItemGrid.set_grid_column_btn_style_ellipsis( EXPIREDFIELD );';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.add_cannot_change_if_batch_no_exist_item_adjustment;
begin
  Script.Add := '  procedure cannot_change_if_batch_no_exist;';
  Script.Add := '  begin';
  Script.Add := '    if ( Not is_incoming_transaction ) and ( detail.FieldByName( BatchField ).AsString<>'''' ) then begin';
  Script.Add := '      RaiseException( REMOVE_BATCH_NO );';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.add_set_expired_field_column_read_only;
begin
  Script.Add := '  Procedure set_expired_field_column_read_only;';
  Script.Add := '  begin';
  Script.Add := '    if Master.AdjCheck.AsBoolean then begin';
  Script.Add := '      ItemGrid.set_grid_column_read_only( EXPIREDFIELD, False );';
  Script.Add := '    end ';
  Script.Add := '    else begin';
  Script.Add := '      ItemGrid.set_grid_column_read_only( EXPIREDFIELD, True );';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.generate_jc_ro_item_script;
begin
  Script.Clear;

//  Script.Add := 'Const';
//  add_batch_field_const;
//  add_expired_date_field_const;
//  Script.Add := '';

  add_read_option_function;
  add_batch_no_parameter_function;
  add_expired_date_parameter_function;

  add_fill_batch_no_information;
  Script.Add := 'BEGIN';
  Script.Add := '  form.show_batch_no_columns;';
  Script.Add := '  DataModule.OnCreateIADetArray := @fill_batch_no_information;';
  Script.Add := 'END.';
end;

procedure TBatchNoInjector.generate_job_costing_script;
begin
  Script.Clear;

  add_const;

  add_DoShowBatchNoSearchForm;
  add_cannot_change_if_batch_no_exist;

  add_setGridColumnBtnStyle_outgoing;
  add_make_sure_detail_can_be_edited;

  add_auto_fill_menus(fnJobCosting);
  addEventBatchFieldChanged; //MMD, BZ 3626
  Script.Add := 'BEGIN';
  Script.Add := '  ItemGrid.OnGridLayoutArray := @setGridColumnBtnStyle;';
  Script.Add := '  ItemGrid.OnEditButtonClickArray := @DoShowBatchNoSearchForm;';
  Script.Add := '  TjbIntegerField( detail.FieldByName( WAREHOUSEFIELD ) ).OnValidateArray := @cannot_change_if_batch_no_exist;';
  Script.Add := '  add_auto_fill_menus;';
  Script.Add := '  TExtendedCustomField(detail.FieldByName(BATCHFIELD)).OnChangeArray := @batchFieldChanged;'; //MMD, BZ 3626
  Script.Add := 'END.';
end;

procedure TBatchNoInjector.add_fill_batch_no_information;
begin
  Script.Add := '  procedure fill_batch_no_information( ia_det:TIADetDataset; finished_item:TItemRO );';
  Script.Add := '  begin';
  Script.Add := '    ia_det.FieldByName( BATCHFIELD ).AsString := finished_item.batch_no;';
  Script.Add := '    ia_det.FieldByName( EXPIREDFIELD ).AsString := DateToStrSQL( finished_item.expired_date );';
//  Script.Add := '    ia_det.FieldByName( EXPIREDFIELD ).AsString := DateToStr( finished_item.expired_date );';
  Script.Add := '  end;';
  Script.Add := '';
end;

function TBatchNoInjector.describe_manual_step: string;
begin
  result := 'Please do these following steps at your selected database (via FINA), before start using this new feature :'#13#10 +
            Format( '1. Set all Batch No transaction template to show %s (for batch no information) and %s (for expired date information).'#13#10, [batch_no_field_name, expired_date_field_name] )+
            '2. Prepare one field of item extended custom field (Boolean type) as Required Batch No Flag.'#13#10+
            '3. Set Required Batch No Flag at Item extended data. (Item that marked will be required batch no information to be used).'#13#10 +
            '4. Make sure you turn off "Use Serial Number" Option From Fina Application.';
end;

procedure TBatchNoInjector.generateItem;
begin
  ClearScript;
  ReadOption;
  MasterExtended;
  Script.Add := 'var REQUIRED_BATCH_FIELD : String; ';
//  Script.Add := '    stateBN : Integer; ';
  Script.Add := 'function isItemHistExist:Boolean; ';
  Script.Add := 'var sqlItem : TjbSQL;  ';
  Script.Add := 'begin ';
  Script.Add := '  sqlItem := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sqlItem, Format(''Select 1 from ItemHist i where i.ItemNo=''''%s'''' '',[Master.ItemNo.AsString]) ); ';
  Script.Add := '    result := not sqlItem.Eof; ';
  Script.Add := '  finally ';
  Script.Add := '    sqlItem.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
//  Script.Add := 'procedure validateRequredBatchField; ';
//  Script.Add := 'begin ';
//  Script.Add := '  if isItemHistExist and (stateBN = 1) then begin ';
//  Script.Add := '  if isItemHistExist then begin '; //JR, BZ 2700
//  Script.Add := '    MasterExtended(REQUIRED_BATCH_FIELD).Value := stateBN; '; 
//  Script.Add := '    raiseException(''Cannot change this status''); ';
//  Script.Add := '  end; ';
//  Script.Add := 'end; ';
//  Script.Add := '';
//  Script.Add := 'procedure showAdditional; ';
//  Script.Add := 'begin ';
//  Script.Add := '  stateBN := MasterExtended(REQUIRED_BATCH_FIELD).AsInteger; '; //JR, BZ 2651
//  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := Format('  REQUIRED_BATCH_FIELD := ReadOption(''%s'', ''%s''); ',
                  [OPTIONS_PARAM_NAME_REQUIRED_BATCH_NO_FIELD, self.required_batch_no_field_name]);
//  Script.Add := '  TExtendedCustomField(MasterExtended(REQUIRED_BATCH_FIELD)).OnValidateArray := @validateRequredBatchField; ';
//  Script.Add := '  Form.OnAfterFormShow := @showAdditional; ';
  Script.Add := '  TExtendedCustomField(MasterExtended(REQUIRED_BATCH_FIELD)).ReadOnly := isItemHistExist; '; // AA, BZ 3946
  Script.Add := 'end. ';
end;

procedure TBatchNoInjector.MainCreateReport;
begin
  Script.Add := '  procedure show_bn_history;';
  Script.Add := '  begin';
  Script.Add := '    showBatchNoHistory;';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  procedure show_expired_report;';
  Script.Add := '  begin';
  Script.Add := '    showExpiredItemReport( InputBox( ''Item that will be expired in the next xxx days'', ''Please fill the values of "xxx days" at below box.'', ''0'') );';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  procedure show_bn_warehouse_report;';
  Script.Add := '  begin';
  Script.Add := '    showBNWarehouseReport;';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  procedure add_menus;';
  Script.Add := '  var';
  Script.Add := '    mnuBNHist : TMenuItem;';
  Script.Add := '    mnuExRpt : TMenuItem;';
  Script.Add := '    mnuBNWhRpt : TMenuItem;';
  Script.Add := '    mnuBNSetting : TMenuItem;';
  Script.Add := '  begin';
  Script.Add := '    mnuBNHist := TMenuItem(Form.FindComponent( ''mnuBNHist'' )); ';
  Script.Add := '    if mnuBNHist <> nil then mnuBNHist.Free; ';
  Script.Add := '    mnuBNHist := TMenuItem.Create( Form );';
  Script.Add := '    mnuBNHist.Name := ''mnuBNHist'';';
  Script.Add := '    mnuBNHist.Caption := ''Batch No History'';';
  Script.Add := '    mnuBNHist.OnClick := @show_bn_history;';
  Script.Add := '    mnuBNHist.Visible := True;';
  Script.Add := '    TMenuItem( Form.FindComponent( ''mnuListInventory'' ) ).Add( mnuBNHist );';
  Script.Add := '';
  Script.Add := '    mnuExRpt := TMenuItem(Form.FindComponent( ''mnuExRpt'' )); ';
  Script.Add := '    if mnuExRpt <> nil then mnuExRpt.Free; ';
  Script.Add := '    mnuExRpt := TMenuItem.Create( Form );';
  Script.Add := '    mnuExRpt.Name := ''mnuExRpt'';';
  Script.Add := '    mnuExRpt.Caption := ''Expired Item'';';
  Script.Add := '    mnuExRpt.OnClick := @show_expired_report;';
  Script.Add := '    mnuExRpt.Visible := True;';
  Script.Add := '    TMenuItem( Form.FindComponent( ''mnuListInventory'' ) ).Add( mnuExRpt );';
  Script.Add := '';
  Script.Add := '    mnuBNWhRpt := TMenuItem(Form.FindComponent( ''mnuBNWhRpt'' )); ';
  Script.Add := '    if mnuBNWhRpt <> nil then mnuBNWhRpt.Free; ';
  Script.Add := '    mnuBNWhRpt := TMenuItem.Create( Form );';
  Script.Add := '    mnuBNWhRpt.Name := ''mnuBNWhRpt'';';
  Script.Add := '    mnuBNWhRpt.Caption := ''Batch No By Warehouse'';';
  Script.Add := '    mnuBNWhRpt.OnClick := @show_bn_warehouse_report;';
  Script.Add := '    mnuBNWhRpt.Visible := True;';
  Script.Add := '    TMenuItem( Form.FindComponent( ''mnuListInventory'' ) ).Add( mnuBNWhRpt );';
  Script.Add := '';
  Script.Add := '    mnuBNSetting := TMenuItem(Form.FindComponent( ''mnuBNSetting'' )); ';
  Script.Add := '    if mnuBNSetting <> nil then mnuBNSetting.Free; ';
  Script.Add := '    mnuBNSetting := TMenuItem.Create( Form );';
  Script.Add := '    mnuBNSetting.Name := ''mnuBNSetting'';';
  Script.Add := '    mnuBNSetting.Caption := ''Batch Number Setting'';';
  Script.Add := '    mnuBNSetting.OnClick := @ShowBatchNoSetting;';
  Script.Add := '    mnuBNSetting.Visible := True;';
  Script.Add := '    Form.AmnuEdit.Add( mnuBNSetting );';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.generate_sales_invoice_script;
begin
  Script.Clear;

  add_const;

  add_DoShowBatchNoSearchForm;
  add_cannot_change_if_batch_no_exist_sales_invoice;

  add_setGridColumnBtnStyle_outgoing;
  add_make_sure_detail_can_be_edited;

  add_sales_invoice_field_read_only;

  add_auto_fill_menus( fnARInvoice );
  is_arinv := True; //MMD, BZ 3626 - 3628
  addEventBatchFieldChanged; //JR, BZ 2697
  is_arinv := False; //MMD, BZ 3626 - 3628
  Script.Add := 'BEGIN';
  Script.Add := '  ItemGrid.OnGridLayoutArray := @setGridColumnBtnStyle;';
  Script.Add := '  Master.GetFromDO.OnChangeArray := @set_batch_no_field_read_only;';
  Script.Add := '  ItemGrid.OnEditButtonClickArray := @DoShowBatchNoSearchForm;';
  Script.Add := '  TjbIntegerField( detail.FieldByName( WAREHOUSEFIELD ) ).OnValidateArray := @cannot_change_if_batch_no_exist;';
  Script.Add := '  add_auto_fill_menus;';
  Script.Add := '  TExtendedCustomField(detail.FieldByName(BATCHFIELD)).OnChangeArray := @batchFieldChanged; ';
  Script.Add := 'END.';
end;

procedure TBatchNoInjector.generate_script_for_main_form;
begin
  Script.Clear;
  MainCreateReport;
  MainCreateMenuSetting;
  IsAdmin;
  remove_menu;
  addProcedureCheckBN;
  Script.Add := 'BEGIN';
  Script.Add := '  if IsAdmin then begin';
  Script.Add := '    add_menus;';
  Script.Add := '  end';
  Script.Add := '  else begin';
  // AA, BZ 1875
  Script.Add := '    remove_menu(''mnuBNHist'');';
  Script.Add := '    remove_menu(''mnuExRpt'');';
  Script.Add := '    remove_menu(''mnuBNWhRpt'');';
  Script.Add := '    remove_menu(''mnuBNSetting'');';
  Script.Add := '  end;';
  Script.Add := '  checkBN;';
  Script.Add := 'END.';
end;

procedure TBatchNoInjector.generate_item_transfer_script;
begin
  Script.Clear;

  Script.Add := 'Const';
//  add_batch_field_const;
//  add_expired_date_field_const;
  add_remove_batch_no_const;
  Script.Add := '';

  add_read_option_function;
  add_batch_no_parameter_function;
  add_expired_date_parameter_function;

  add_DoShowBatchNoSearchForm_item_transfer;
  add_cannot_change_if_batch_no_exist_item_transfer;
  add_setGridColumnBtnStyle_outgoing;
  add_make_sure_detail_can_be_edited;

  // AA, BZ 1899
  CreateForm;
  CreateListView;
  CreateButton;
  CreateMenu;
  add_fill_IT_det_batch_number_with_pick_list;
  
  //MMD, BZ 3627
  is_item_transfer := True;
  addEventBatchFieldChanged;
  is_item_transfer := False;
  
  Script.Add := 'BEGIN';
  Script.Add := '  ItemGrid.OnGridLayoutArray := @setGridColumnBtnStyle;';
  Script.Add := '  ItemGrid.OnEditButtonClickArray := @DoShowBatchNoSearchForm;';
  // validate the origin warehouse, because at form level IT considered as outgoing transaction
  Script.Add := '  Master.FromWHID.OnValidateArray := @cannot_change_if_batch_no_exist;';
  // Destination warehouse can be change at any time.
//  Script.Add := '  Master.ToWHID.OnValidateArray := @cannot_change_if_batch_no_exist;';
  Script.Add := '  add_batch_number_pick_list_menu;';
  Script.Add := '  TExtendedCustomField(detail.FieldByName(BATCHFIELD)).OnChangeArray := @batchFieldChanged;'; //MMD, BZ 3627
  Script.Add := 'END.';
end;

procedure TBatchNoInjector.add_cannot_change_if_batch_no_exist_item_transfer;
begin
  Script.Add := '  procedure cannot_change_if_batch_no_exist;';
  Script.Add := '  begin';
  Script.Add := '    detail.first;';
  Script.Add := '    While Not detail.eof do begin';
  Script.Add := '      if ( detail.FieldByName( BatchField ).AsString<>'''' ) then begin';
  Script.Add := '        RaiseException( REMOVE_BATCH_NO );';
  Script.Add := '        break;';
  Script.Add := '      end;';
  Script.Add := '      detail.next;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.add_DoShowBatchNoSearchForm_item_transfer;
begin
  Script.Add := '  procedure DoShowBatchNoSearchForm;';
  Script.Add := '  var';
  Script.Add := '    BNForm : TBatchNoSearchForm;';
  Script.Add := '  begin';
  Script.Add := '    if ( CompareText( ItemGrid.CurrentSelectedField.FieldName, BATCHFIELD )=0 ) and ( Not ItemGrid.CurrentSelectedField.ReadOnly ) then begin';
  Script.Add := '      BNForm := TBatchNoSearchForm.Create( nil );';
  Script.Add := '      Try';
  Script.Add := '        if Master.FromWHID.isNull then begin';
  Script.Add := '          BNForm.warehouse_id := -1;';
  Script.Add := '        end';
  Script.Add := '        else begin';
  Script.Add := '          BNForm.warehouse_id := Master.FromWHID.AsInteger;';
  Script.Add := '        end;';
  Script.Add := '';
  Script.Add := '        if detail.ItemNo.isNull then begin';
  Script.Add := '          BNForm.item_no := '''' ;';
  Script.Add := '        end';
  Script.Add := '        else begin';
  Script.Add := '          BNForm.item_no := detail.ItemNo.AsString;';
  Script.Add := '        end;';
  Script.Add := '';
  Script.Add := '        if ( BNForm.ShowModal=mrOk ) then begin';
  Script.Add := '          make_sure_detail_can_be_edited;';
  Script.Add := '          detail.fieldByName( BATCHFIELD ).AsString := BNForm.selected_batch_no;';
  Script.Add := '          detail.fieldByName( EXPIREDFIELD ).AsString := BNForm.selected_expired_date;';
  Script.Add := '        end;';
  Script.Add := '      Finally';
  Script.Add := '        BNForm.Free;';
  Script.Add := '      End;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.add_sales_invoice_field_read_only;
begin
  Script.Add := '  procedure set_batch_no_field_read_only;';
  Script.Add := '  begin';
  Script.Add := '    detail.fieldByName( BATCHFIELD ).ReadOnly := Master.GetFromDO.AsBoolean;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.add_cannot_change_if_batch_no_exist_sales_invoice;
begin
  Script.Add := '  procedure cannot_change_if_batch_no_exist;';
  Script.Add := '  begin';
  Script.Add := '    if ( Not master.GetFromDO.AsBoolean ) and ( detail.FieldByName( BatchField ).AsString<>'''' ) then begin';
  Script.Add := '      RaiseException( REMOVE_BATCH_NO );';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.add_purchase_invoice_field_read_only;
begin
  Script.Add := '  procedure set_batch_no_and_expired_date_field_read_only;';
  Script.Add := '  begin';
  Script.Add := '    detail.fieldByName( BATCHFIELD ).ReadOnly := Master.Bill.AsBoolean;';
  Script.Add := '    detail.fieldByName( EXPIREDFIELD ).ReadOnly := Master.Bill.AsBoolean;';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.add_set_detail_column_read_only;
begin
  Script.Add := '  Procedure set_detail_column_read_only;';
  Script.Add := '  begin';
  Script.Add := '    ItemGrid.set_grid_column_read_only( BATCHFIELD, True );';
  Script.Add := '    ItemGrid.set_grid_column_read_only( EXPIREDFIELD, True );';
  Script.Add := '  end;';
  Script.Add := '';
end;

procedure TBatchNoInjector.generate_script_for_non_batch_no_form;
begin
  Script.Clear;

//  Script.Add := 'Const';
//  add_batch_field_const;
//  add_expired_date_field_const;
//  Script.Add := '';

  add_read_option_function;
  add_batch_no_parameter_function;
  add_expired_date_parameter_function;

  add_set_detail_column_read_only;

  Script.Add := 'BEGIN';
  Script.Add := '  ItemGrid.OnGridLayoutArray := @set_detail_column_read_only;';
  Script.Add := 'END.';
end;

procedure TBatchNoInjector.MainCreateMenuSetting;
begin
  CreateFormSetting;
  Script.Add := 'procedure ShowBatchNoSetting; ';
  Script.Add := 'var frmSetting : TForm; ';
  Script.Add := 'begin ';
  Script.Add := '  frmSetting := CreateFormSetting(''BatchNoSettingForm'', ''Batch Number Setting'', 400, 400);';
  Script.Add := '  try ';
  Script.Add := Format('    AddControl( frmSetting, ''Batch number field'', ''ITEMRESERVED'', ''%s'', ReadOption(''%s'',''%s''), ''0'', ''''); ',
                  [OPTIONS_PARAM_NAME_BATCH_NO_FIELD, OPTIONS_PARAM_NAME_BATCH_NO_FIELD, self.batch_no_field_name]);
  Script.Add := Format('    AddControl( frmSetting, ''Expired date field'', ''ITEMRESERVED'', ''%s'', ReadOption(''%s'', ''%s''), ''0'', ''''); ',
                  [OPTIONS_PARAM_NAME_EXPIRED_DATE_FIELD, OPTIONS_PARAM_NAME_EXPIRED_DATE_FIELD, self.expired_date_field_name]);
  Script.Add := Format('    AddControl( frmSetting, ''Required batch number field'', ''CUSTOMFIELD'', ''%s'', ReadOption(''%s'', ''%s''), ''0'', ''''); ',
                  [OPTIONS_PARAM_NAME_REQUIRED_BATCH_NO_FIELD, OPTIONS_PARAM_NAME_REQUIRED_BATCH_NO_FIELD, self.required_batch_no_field_name]);
  Script.Add := Format('    AddControl( frmSetting, ''Auto fill Batch Number'', ''CHECKBOX'', ''%s'', ReadOption(''%s'', ''%s''), ''0'', ''''); ',
                  [OPTIONS_PARAM_NAME_AUTO_FILL_BATCH_NO, OPTIONS_PARAM_NAME_AUTO_FILL_BATCH_NO, '0']);
  Script.Add := Format('    AddControl( frmSetting, ''User Check'', ''TEXT'', ''%s'', ReadOption(''%s''), ''0'', '''');',
                  [OPTIONS_PARAM_NAME_USER_CHECK, OPTIONS_PARAM_NAME_USER_CHECK]);
  Script.Add := '    if frmSetting.ShowModal = mrOK then begin ';
  Script.Add := '      SaveToOptions; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    frmSetting.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TBatchNoInjector.add_fill_IT_det_batch_number_with_pick_list;
begin
  Script.Add := 'procedure fill_IT_det_batch_number_with_pick_list;';
  Script.Add := 'const';
  Script.Add := '  SPACE = 5;';
  Script.Add := '  BTN_WIDTH = 90;';
  Script.Add := '  BTN_HEIGHT = 30;';
  Script.Add := 'var';
  Script.Add := '  frm : TForm;';
  Script.Add := '  detail_list : TListView;';
  Script.Add := '  btn_ok : TButton;';
  Script.Add := '';
  Script.Add := '  procedure create_list_columns;';
  Script.Add := '  begin';
  Script.Add := '    CreateListViewCol(detail_list, '''', 30);';
  Script.Add := '    CreateListViewCol(detail_list, ''Item No.'', 120);';
  Script.Add := '    CreateListViewCol(detail_list, ''Item Description'', 180);';
  Script.Add := '    CreateListViewCol(detail_list, ''Batch No.'', 200);';
  Script.Add := '    CreateListViewCol(detail_list, ''Qty (Unit 1)'', 100);';
  Script.Add := '    CreateListViewCol(detail_list, ''EXPIREDDATE'', 0);';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  procedure add_to_list_view(item_no:string; wh_id:integer);';
  Script.Add := '  var';
  Script.Add := '    bn_sql : TjbSQL;';
  Script.Add := '    list_item : TListItem;';
  Script.Add := '  begin';
  Script.Add := '    bn_sql := CreateSQL(Master.Tx);';
  Script.Add := '    Try';
  Script.Add := '      RunSQL(bn_sql, Format(''Select a.*, i.itemDescription from ItemSN a ''+';
  Script.Add := '                            ''join item i on i.itemno=a.itemno ''+';
  Script.Add := '                            ''where a.ItemNo=''''%s'''' and a.WarehouseId=%d and a.quantity>0'',';
  Script.Add := '                            [item_no, wh_id]));';
  Script.Add := '      while not bn_sql.EOF do begin';
  Script.Add := '        list_item := detail_list.items.Add;';
  Script.Add := '        list_item.SubItems.Add( bn_sql.FieldByName( ''ItemNo'' ) );';
  Script.Add := '        list_item.SubItems.Add( bn_sql.FieldByName( ''ItemDescription'' ) );';
  Script.Add := '        list_item.SubItems.Add( bn_sql.FieldByName( ''SN'' ) );';
  Script.Add := '        list_item.SubItems.Add( bn_sql.FieldByName( ''Quantity'' ) );';
  Script.Add := '        list_item.SubItems.Add( bn_sql.FieldByName( ''ExpiredDate'' ) );';
  Script.Add := '        bn_sql.Next;';
  Script.Add := '      end;';
  Script.Add := '    Finally';
  Script.Add := '      bn_sql.Free;';
  Script.Add := '    End;';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  function BATCHFIELD:String; ';
  Script.Add := '  begin ';
  Script.Add := Format('    result := ReadOption(''%s'', ''%s''); ', [OPTIONS_PARAM_NAME_BATCH_NO_FIELD, 'ItemReserved2']);
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := '  function EXPIREDFIELD : String; ';
  Script.Add := '  begin ';
  Script.Add := Format('    result := ReadOption(''%s'', ''%s''); ', [OPTIONS_PARAM_NAME_EXPIRED_DATE_FIELD, 'ItemReserved3']);
  Script.Add := '  end; ';
  Script.Add := '';
  is_distro_variant;
  Script.Add := '  procedure add_selection_to_WtranDet;';
  Script.Add := '  var';
  Script.Add := '    list_index : integer;';
  Script.Add := '    uom_qty1 : string;';
  Script.Add := '  begin';
  Script.Add := '    detail.delete;';
  Script.Add := '    if is_distribution_variant then begin';
  Script.Add := '      uom_qty1 := ReadOption(''' + STR_UOM_QTY1 + ''', ''' + STR_DEFAULT_UOM_QTY1 + ''');';
  Script.Add := '    end;';
  Script.Add := '    for list_index := 0 to detail_list.items.count-1 do begin';
  Script.Add := '      If (detail_list.items[list_index].Checked) then begin';
  Script.Add := '        detail.Append;';
  Script.Add := '        detail.itemno.AsString := detail_list.items[list_index].subItems[0];';
  Script.Add := '        if is_distribution_variant then begin';
  Script.Add := '          detail.ExtendedID.FieldLookUp.fieldByName( uom_qty1 ).AsCurrency := StrSQLToCurr(detail_list.items[list_index].subItems[3]);'; // AA, BZ 3141
  Script.Add := '        end';
  Script.Add := '        else begin';
  Script.Add := '          detail.quantity.AsCurrency := StrSQLToCurr(detail_list.items[list_index].subItems[3]);';
  Script.Add := '        end;';
  Script.Add := '        detail.FieldByName( BatchField ).AsString := detail_list.items[list_index].subitems[2];';
  Script.Add := '        detail.FieldByName( ExpiredField ).AsString := detail_list.items[list_index].subitems[4];';
  Script.Add := '        detail.post;';
  Script.Add := '      end;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  if ( Detail.itemno.AsString<>'''' ) And ( detail.FieldByName( BatchField ).AsString ='''' ) then begin';
  Script.Add := '    frm := CreateForm( ''IT_det_form'', ''Available Batch No List'', 650, 350 );';
  Script.Add := '    Try';
  Script.Add := '      frm.BorderStyle := bsToolWindow;';
  Script.Add := '      detail_list := CreateListView( frm, SPACE, SPACE, frm.ClientWidth - (SPACE*2), frm.ClientHeight - (BTN_HEIGHT + (2*SPACE)) );';
  Script.Add := '      detail_list.RowSelect := True;';
  Script.Add := '      detail_list.ReadOnly := True;';
  Script.Add := '      detail_list.viewStyle := vsReport;';
  Script.Add := '';
  Script.Add := '      create_list_columns;';
  Script.Add := '      add_to_list_view(detail.ItemNo.AsString, master.FromWHID.AsInteger);';
  Script.Add := '';
  Script.Add := '      btn_ok := CreateBtn( ((frm.clientWidth-(BTN_WIDTH*2)-SPACE) div 2), detail_list.Top+detail_list.Height+SPACE, BTN_WIDTH, BTN_HEIGHT, 0, ''&OK'', frm );';
  Script.Add := '      btn_ok.ModalResult := mrOK;';
  Script.Add := '';
  Script.Add := '      With CreateBtn( btn_ok.left+btn_ok.width+SPACE, btn_ok.Top, BTN_WIDTH, BTN_HEIGHT, 0, ''&Cancel'', frm ) do begin';
  Script.Add := '        ModalResult := mrCancel;';
  Script.Add := '      end;';
  Script.Add := '';
  Script.Add := '      if frm.ShowModal=mrOk then begin';
  Script.Add := '        add_selection_to_WtranDet;';
  Script.Add := '      end;';
  Script.Add := '    Finally';
  Script.Add := '      frm.Free;';
  Script.Add := '    End;';
  Script.Add := '  end';
  Script.Add := '  else begin';
  Script.Add := '    ShowMessage(''Please fill Item and make sure batch number is empty.'');';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'Procedure add_batch_number_pick_list_menu;';
  Script.Add := 'var';
  Script.Add := '  new_menu : TMenuItem;';
  Script.Add := 'begin';
  Script.Add := '  new_menu := CreateMenu(-1, nil, ''mnuITBNPickList'', ''Pick batch number'', ''fill_IT_det_batch_number_with_pick_list'');';
  Script.Add := '  new_menu.Shortcut := 16464; // Ctrl + P';
  Script.Add := '  form.PopUpMenu1.items.add(new_menu);';
  Script.Add := 'end;';
end;

procedure TBatchNoInjector.addProcedureCheckBN;
begin
  createTx;
  ReadOption;
  add_required_batch_no_parameter_function;
  Script.Add := 'procedure checkBN;';
  Script.Add := 'var BN_USER_CHECK : String;';
  Script.Add := '    sql           : TjbSQL; ';
  Script.Add := '';
  Script.Add := '  function UserName:String; ';
  Script.Add := '  begin';
  Script.Add := '    sql := CreateSQL( TIBTransaction(Tx) ); ';
  Script.Add := '    try ';
  Script.Add := '      RunSQL( sql, Format(''Select UserName from USERS where USERID = %d '', [ UserID ]) ); ';
  Script.Add := '      result := sql.FieldByName(''UserName''); ';
  Script.Add := '    finally ';
  Script.Add := '      sql.Free; ';
  Script.Add := '    end; ';
  script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  function strSQL : String;';
  Script.Add := '  begin';
  Script.Add := '    result := ''select ''+';
  Script.Add := '      ''SUM((Select quantity from GetItemQuantity (i.ItemNo, current_date, -1))) ''+';
  Script.Add := '      ''- SUM((select sum(sn.quantity) from ItemSN sn where sn.ItemNo=i.ItemNo)) selisih ''+';
  Script.Add := '      ''from Item i ''+';
  Script.Add := '      ''join extended e on e.extendedID = i.ExtendedID ''+ ';
  Script.Add := '      ''Left join IsChild(i.ItemNo, 1) ic on ic.ItemNo=i.ItemNo ''+ ';
  Script.Add := '      format(''Where i.ItemType=0 and e.%s = ''''1'''''', [REQUIREDBATCHNOFIELD]) +';
  Script.Add := '      '' and ic.ChildCount <> 1'';';
  Script.Add := '  end;';


  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := format('  BN_USER_CHECK := ReadOption(''%s'');', [OPTIONS_PARAM_NAME_USER_CHECK]);
  Script.Add := '  if BN_USER_CHECK = '''' then exit;';
  Script.Add := '  if BN_USER_CHECK <> USERNAME then exit;';
  Script.Add := '  sql := CreateSQL( TIBTransaction(Tx) ); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL( sql, strSQL); ';
  Script.Add := '    if (sql.FieldByName(''selisih'') <> 0) and (sql.FieldByName(''selisih'') <> null) then begin ';
  Script.Add := '      ShowMessage(''Ada selisih antara data inventory dan Batch Number. Segera hubungi tim Support Imamatek'');';
  Script.Add := '    end;';
  Script.Add := '  finally ';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := '';
end;

end.
