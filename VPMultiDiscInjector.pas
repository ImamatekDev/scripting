unit VPMultiDiscInjector;

interface
uses Injector, Sysutils;

type
  TVPMultiDiscInjector = class(TInjector)
  private
    procedure GenerateMain;
    procedure GenerateVPDataset;
    procedure GenerateJVForm;
    procedure generateJVList;
    procedure generateJVDataset;
    procedure addConst;
  protected
    procedure set_scripting_parameterize; override;
    procedure GenerateVP; virtual;
    procedure Variables(SetVP: Boolean=True); virtual;
    procedure VPMultiDiscountForm; virtual;
    procedure VPAddMultiDiscountForm; virtual;
    procedure MainCreateMenuSetting; virtual;
    procedure DatasetJVBeforeEdit; virtual;
  public
    procedure GenerateScript; override;

  end;

implementation
uses BankConst;


procedure TVPMultiDiscInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := 'VP Multi Discount';
end;

procedure TVPMultiDiscInjector.VPAddMultiDiscountForm;
begin
  CreateLabel;
  CreateEditBox;
(*   CreateComboBox; *)
  Script.Add := 'Const TOKEN= '':''; ';
  Script.Add := 'procedure btnAddClick; ';
  Script.Add := 'var frmAdd : TForm; ';
  Script.Add := '    lblDisc     : TLabel; ';
  Script.Add := '    editDisc    : TEdit; ';
  Script.Add := '    lblAcc      : TLabel; ';
  Script.Add := '    comboAcc    : TComboBox; ';
  Script.Add := '    btnAddOK    : TButton; ';
  Script.Add := '    btnAddCancel: TButton; ';
  Script.Add := '';
  Script.Add := '  procedure btnAddOKClick; ';
  Script.Add := '  begin';
  Script.Add := '    if (editDisc.Text = '''') or (editDisc.Text = ''0'') then begin';
  Script.Add := '      editDisc.SetFocus; ';
  Script.Add := '      RaiseException(''Discount must have a value''); ';
  Script.Add := '    end; ';
  Script.Add := '    if not IsNumeric( editDisc.Text ) then begin';
  Script.Add := '      editDisc.SetFocus; ';
  Script.Add := '      RaiseException(''Discount must be a numeric''); ';
  Script.Add := '    end; ';
  Script.Add := '    if comboAcc.ItemIndex < 0 then begin';
  Script.Add := '      comboAcc.Setfocus; ';
  Script.Add := '      RaiseException(''Account must have a value''); ';
  Script.Add := '    end; ';
  Script.Add := '    frmAdd.ModalResult := mrOK; ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := '  procedure FillComboAccount; ';
  Script.Add := '  var sql:TjbSQL; ';
  Script.Add := '  begin';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '    try';
  Script.Add := '      RunSQL(sql, ''select a.GLAccount, a.AccountName from GLAccnt a '+
    'where a.AccountType in (21, 20, 19, 18, 17, 16, 15, 14, 12, 11, 10, 9) and not exists (select * from GLAccnt g1 where g1.ParentAccount = a.GLAccount) '+
    'order by a.GLAccount''); ';
  Script.Add := '      while not sql.EOF do begin ';
  Script.Add := '        comboAcc.Items.Add( sql.FieldByName(''GLAccount'') + TOKEN + sql.FieldByName(''AccountName''));';
  Script.Add := '        sql.Next; ';
  Script.Add := '      end; ';
  Script.Add := '    finally';
  Script.Add := '      sql.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  procedure CreateAndDecorateAddForm; ';
  Script.Add := '  begin';
  Script.Add := '    lblDisc      := CreateLabel(10, 10, 50, 15, ''Discount'', frmAdd); ';
  Script.Add := '    editDisc     := CreateEdit( lblDisc.Left + lblDisc.Width, lblDisc.Top, 120, 20, frmAdd );';
  Script.Add := '    lblAcc       := CreateLabel( lblDisc.Left, lblDisc.Top + lblDisc.Height + 10, lblDisc.Width, lblDisc.Height, ''Account'', frmAdd); ';
  Script.Add := '    comboAcc     := CreateComboBox( editDisc.Left, lblAcc.Top, 300, editDisc.Height, csDropDownList, frmAdd); ';
  Script.Add := '    btnAddOK     := CreateBtn( 30, lblAcc.Top + lblAcc.Height + 10, 80, 30, 0, ''OK'', frmAdd ); ';
  Script.Add := '    btnAddCancel := CreateBtn( 2 * btnAddOK.Left + btnAddOK.Width, btnAddOK.Top, btnAddOK.Width, btnAddOK.Height, 0, ''Cancel'', frmAdd);';
  Script.Add := '    btnAddCancel.ModalResult := mrCancel; ';
  Script.Add := '    btnAddOK.OnClick := @btnAddOKClick; ';
  Script.Add := '    FillComboAccount; ';
  Script.Add := '  end; ';
  Script.Add := 'begin';
  Script.Add := '  frmAdd := CreateForm(''frmAddMultiDisc'', ''Add Discount Form'', 400, 300);';
  Script.Add := '  try';
  Script.Add := '    CreateAndDecorateAddForm; ';
  Script.Add := '    if frmAdd.ShowModal = mrOK then begin';
  Script.Add := '      with lv.Items.Add do begin';
  Script.Add := '        Caption := editDisc.Text;';
  Script.Add := '        SubItems.Add( GetToken(comboAcc.Text, TOKEN, 1) ); ';
  Script.Add := '        SubItems.Add( GetToken(comboAcc.Text, TOKEN, 2) ); ';
  Script.Add := '      end; ';
  Script.Add := '    end; ';
  Script.Add := '  finally';
  Script.Add := '    frmAdd.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure btnDeleteClick; ';
  Script.Add := 'var i:Integer; ';
  Script.Add := 'begin';
  Script.Add := '  for i := lv.Items.Count-1 downto 0 do begin';
  Script.Add := '    if lv.Items[i].Checked then begin';
  Script.Add := '      lv.Items[i].Delete; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TVPMultiDiscInjector.VPMultiDiscountForm;
begin
  CreateForm;
  CreateListView;
  CreateButton;
  addConst;
  Script.Add := 'var frm : TForm;';
  Script.Add := '    lv:TListView;';
  Script.Add := '    btnAdd    : TButton; ';
  Script.Add := '    btnDelete : TButton; ';
  Script.Add := '    btnOK     : TButton;';
  //Script.Add := '    btnCancel : TButton;';
  Script.Add := '    jvDM : TdmJV;';
  Script.Add := '    NEXTJVNUMBER : String; '; //MMD, BZ 3574
  Script.Add := '    SEG1DATA     : String; ';
  Script.Add := '    SEG1POSITION : Byte; ';
  Script.Add := '    SEG2DATA     : String; ';
  Script.Add := '    SEG2POSITION : Byte; ';
  Script.Add := '    JVNUMLEN     : Byte; ';
  Script.Add := '';
  VPAddMultiDiscountForm;
  Script.Add := 'procedure CreateVCL;';
  Script.Add := 'begin';
  Script.Add := '  lv        := CreateListView(frm, 0, 0, frm.ClientWidth, frm.ClientHeight-40, true);';
  Script.Add := '  btnAdd    := CreateBtn( 10, lv.TOp + lv.Height + 5, 50, 30, 0, ''Add'', frm);';
  Script.Add := '  btnDelete := CreateBtn( btnAdd.Left + btnAdd.Width + 30, btnAdd.Top, btnAdd.Width, btnAdd.Height, 0, ''Delete'', frm); ';
  Script.Add := '  btnOK     := CreateBtn( btnDelete.Left + btnDelete.Width + 30, btnDelete.Top, btnDelete.Width, btnDelete.Height, 0, ''OK'', frm);';
  //Script.Add := '  btnCancel := CreateBtn( btnOK.Left + btnOK.Width + 30, btnOK.Top, btnOK.Width, btnOK.Height, 0, ''Cancel'', frm);';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure btnOKClick; ';
  Script.Add := '  function TotalDisc:Currency; ';
  Script.Add := '  var i: Integer; ';
  Script.Add := '  begin';
  Script.Add := '    result := 0;';
  Script.Add := '    for i:=0 to lv.Items.Count-1 do begin';
  Script.Add := '      result := result + StrToFloat(lv.Items[i].Caption); ';
  Script.Add := '    end; ';
  Script.Add := '  end;';
  Script.Add := 'begin';
  Script.Add := '  if TotalDisc = DataModule.AtblAPInvChq2.Discount.value then begin';
  Script.Add := '    frm.ModalResult := mrOK;';
  Script.Add := '  end';
  Script.Add := '  else begin';
  Script.Add := '    RaiseException(format(''Total Discount must be %f'', [DataModule.AtblAPInvChq2.Discount.value])); ';
  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure DecorateForm;';
  Script.Add := 'begin';
  Script.Add := '  frm.BorderIcons := frm.BorderIcons - biSystemMenu; ';
  Script.Add := '  lv.ViewStyle := vsReport;';
  Script.Add := '  CreateListViewCol(lv, ''Discount'', 90);';
  Script.Add := '  CreateListViewCol(lv, ''Account'', 80);';
  Script.Add := '  CreateListViewCol(lv, ''Account Name'', 120); ';
  Script.Add := '  lv.Anchors        := akTop + akLeft + akRight + akBottom;';
  Script.Add := '  btnOK.Anchors     := akBottom + akLeft;';
  //Script.Add := '  btnCancel.Anchors := btnOK.Anchors;';
  Script.Add := '  btnOK.OnClick     := @btnOKClick;';
  //Script.Add := '  btnCancel.ModalResult := mrCancel;';
  Script.Add := '  btnAdd.OnClick    := @btnAddClick; ';
  Script.Add := '  btnDelete.OnClick := @btnDeleteClick; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'function GetJVID:Integer; ';
  Script.Add := 'var sql : TjbSQL;';
  Script.Add := '  function GetJVIDSQL:String; ';
  Script.Add := '  begin';
  Script.Add := '    result := format(''Select j.JVID from JV j join Extended e on e.ExtendedID=j.ExtendedID '+
//    'where j.TransDate=''''%s'''' and e.%s=%d and e.%s=%d'', '+
//    '[DateToStrSQL(Master.ChequeDate.value), '+
    'where e.%s=%d and e.%s=%d'', '+ // cheque date and JV date can have different
    '['+
    ' JV_VPID_FIELD, '+
    ' Datamodule.AtblAPInvChq2.FieldByName(''ChequeID'').asInteger, '+
    ' JV_PIID_FIELD, '+
    ' Datamodule.AtblAPInvChq2.FieldByName(''APInvoiceID'').asInteger]); ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  result := -1; ';
  Script.Add := '  if Datamodule.AtblAPInvChq2.FieldByName(''APInvoiceID'').IsNull '+
    'or Datamodule.AtblAPInvChq2.FieldByName(''ChequeID'').isNull then exit; ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Master.Tx)); ';
  Script.Add := '  try';
  Script.Add := '    RunSQL(sql, GetJVIDSQL); ';
  Script.Add := '    if sql.RecordCount > 0 then result := sql.FieldByName(''JVID''); ';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure CreateJV; ';
  Script.Add := 'begin';
  Script.Add := '  jvDM := TdmJV.ACreate(TIBDatabase(DB), TIBTransaction(Master.Tx), GetJVID, UserID, 1); ';
  Script.Add := '  jvDM.DMStartDatabase; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure LoadJV;';
  Script.Add := 'var listItem : TListItem; ';
  Script.Add := 'begin';
  Script.Add := '  CreateJV; ';
  Script.Add := '  if jvDM.AtblJVDet.RecordCount = 0 then exit;';
  Script.Add := '  jvDM.AtblJVDet.First; ';
  Script.Add := '  while not jvDM.AtblJVDet.EOF do begin';
  Script.Add := '    if jvDM.AtblJVDet.GLAccount.value = VP_ACC_AYAT_SILANG then begin';
  Script.Add := '      jvDM.AtblJVDet.Next; ';
  Script.Add := '      continue; ';
  Script.Add := '    end; ';
  Script.Add := '    listItem := lv.Items.Add; ';
//  Script.Add := '    ListItem.Caption := jvDM.AtblJVDet.GLAmount.asString; ';
  Script.Add := '    ListItem.Caption := FloatToStr(ABS(jvDM.AtblJVDet.GLAmount.asCurrency)); '; // AA, BZ 3160
  Script.Add := '    ListItem.SubItems.Add( jvDM.AtblJVDet.GLAccount.value ); ';
  Script.Add := '    ListItem.SubItems.Add( jvDM.AtblJVDet.FieldByName(''AccountName'').value ); ';
  Script.Add := '    jvDM.AtblJVDet.Next; ';
  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'Procedure BackupJVCTL; ';
  Script.Add := 'Var ';
  Script.Add := '  Sql : TjbSQL; ';
  Script.Add := 'Begin ';
  Script.Add := '  Sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  Try ';
  Script.Add := '    RunSQL(Sql, ''SELECT r.NEXTJVNUMBER, r.SEG1DATA, r.SEG1POSITION, r.SEG2DATA, r.SEG2POSITION, r.JVNUMLEN, r.RDB$DB_KEY FROM JVCTL r''); ';
  Script.Add := '    NEXTJVNUMBER := Sql.FieldByName(''NEXTJVNUMBER''); ';
  Script.Add := '    SEG1DATA     := Sql.FieldByName(''SEG1DATA''); ';
  Script.Add := '    SEG1POSITION := Sql.FieldByName(''SEG1POSITION''); ';
  Script.Add := '    SEG2DATA     := Sql.FieldByName(''SEG2DATA''); ';
  Script.Add := '    SEG2POSITION := Sql.FieldByName(''SEG2POSITION''); ';
  Script.Add := '    JVNUMLEN     := Sql.FieldByName(''JVNUMLEN''); ';
  Script.Add := '    Sql.Close; ';
  Script.Add := '  Finally ';
  Script.Add := '    Sql.Free; ';
  Script.Add := '  End; ';
  Script.Add := 'End; ';
  Script.Add := '';
  Script.Add := 'Procedure RestoreJVCTL; ';
  Script.Add := 'Var ';
  Script.Add := '  Sql : TjbSQL; ';
  Script.Add := '  ATx : TIBTransaction; ';
  Script.Add := 'Begin ';
  Script.Add := '  ATx := CreateATx; ';
  Script.Add := '  Sql := CreateSQL(ATx); ';
  Script.Add := '  Try ';
  Script.Add := '  RunSQL(Sql,Format(''UPDATE JVCTL SET NEXTJVNUMBER=''''%s'''', SEG1DATA=''''%s'''', SEG1POSITION=%d, SEG2DATA=''''%s'''', SEG2POSITION=%d, JVNUMLEN=%d'', [NEXTJVNUMBER, SEG1DATA, SEG1POSITION, SEG2DATA, SEG2POSITION, JVNUMLEN] )); '; //MMD, BZ 3574
  Script.Add := '  ATx.Commit; ';
  Script.Add := '  Finally ';
  Script.Add := '    ATx.Free; ';
  Script.Add := '    Sql.Free; ';
  Script.Add := '  End; ';
  Script.Add := 'End; ';
  Script.Add := '';
  Script.Add := 'Procedure IncNextNoJV; ';
  Script.Add := 'Var ';
  Script.Add := '  Sql : TjbSQL; ';
  Script.Add := '  ATx : TIBTransaction; ';
  Script.Add := 'Begin ';
  Script.Add := 'ATx := CreateATx; ';
  Script.Add := 'Sql := CreateSQL(ATx); ';
  Script.Add := '  Try ';
  Script.Add := '    RunSQL(Sql,Format(''UPDATE Options SET ValueOpt=''''%s'''' WHERE ParamOpt=''''%s'''''', [IncCtlNumber(NEXT_NO_JV), ''NEXT_NO_JV''] )); ';
  Script.Add := '    ATx.Commit; ';
  Script.Add := '  Finally ';
  Script.Add := '    ATx.Free; ';
  Script.Add := '    Sql.Free; ';
  Script.Add := '  End; ';
  Script.Add := 'End; ';
  Script.Add := '';
  Script.Add := 'procedure SaveToJV;';
  Script.Add := 'var i : Integer; ';
  Script.Add := '  procedure AppendDetail(Acc: String; Amt:Currency); ';
  Script.Add := '  begin';
  Script.Add := '    jvDM.AtblJVDet.Append; ';
  Script.Add := '    jvDM.AtblJVDet.GLAccount.value     := Acc; ';
  Script.Add := '    jvDM.AtblJVDet.GLAmount.value      := Amt ; ';
  Script.Add := '    jvDM.AtblJVDet.DeptID.asVariant    := DataModule.AtblAPInvChq2.DeptID.asVariant; ';
  Script.Add := '    jvDM.AtblJVDet.ProjectID.asVariant := DataModule.AtblAPInvChq2.ProjectID.asVariant; ';
  Script.Add := '    jvDM.AtblJVDet.Description.value   := format(''Discount dan Beban lain-lain untuk invoice %s'','+
    ' [Detail.InvoiceNo.value]);';
  Script.Add := '    jvDM.AtblJVDet.Post; ';
  Script.Add := '  end; ';
  Script.Add := '  function isJVNumberExist:Boolean; ';
  Script.Add := '  var sqlJVNum : TjbSQL; ';
  Script.Add := '  begin ';
  Script.Add := '    sqlJVNum := CreateSQL(TIBTransaction(Master.Tx)); ';
  Script.Add := '    try ';
  Script.Add := '      RunSQL( sqlJVNum, Format(''Select 1 from JV where JVNumber=''''%s'''''',[NUMBER_JV] ) ); ';
  Script.Add := '      result := NOT sqlJVNum.EOF; ';
  Script.Add := '    finally ';
  Script.Add := '      sqlJVNum.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := '  function getNewJVNumber:String; ';
  Script.Add := '  begin ';
  Script.Add := '    if isJVNumberExist then begin ';
  Script.Add := '      IncNextNoJV; ';
  Script.Add := '      NEXT_NO_JV := ReadOption(''NEXT_NO_JV'', ''14-00001''); ';
  Script.Add := '      NUMBER_JV  := FORMAT_JV + ''-'' + NEXT_NO_JV; ';
  Script.Add := '      result := NUMBER_JV; ';
  Script.Add := '    end ';
  Script.Add := '    else begin ';
  Script.Add := '      result := NUMBER_JV; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  if jvDM.AtblJV.State = 1 then jvDM.ATblJV.Edit; ';
  Script.Add := '  BackupJVCTL; ';
  Script.Add := '  jvDM.AtblJV.JVNumber.Value         := getNewJVNumber; ';
  Script.Add := '  jvDM.AtblJV.TransDate.value        := Master.ChequeDate.value; ';
  Script.Add := '  jvDM.AtblJV.TransDescription.value := Master.SequenceNo.value; ';

  Script.Add := '  jvDM.AtblJV.ExtendedID.FieldLookup.FieldByName(JV_VPID_FIELD).value :=' +
    'Datamodule.AtblAPInvChq2.FieldByName(''ChequeID'').asInteger; ';
  Script.Add := '  jvDM.AtblJV.ExtendedID.FieldLookup.FieldByName(JV_PIID_FIELD).value :=' +
    'Datamodule.AtblAPInvChq2.FieldByName(''APInvoiceID'').asInteger; ';

  Script.Add := '  while not jvDM.AtblJVDet.EOF do jvDM.AtblJVDet.Delete; ';
  Script.Add := '  for i:=0 to lv.Items.Count-1 do begin';
//  Script.Add := '    AppendDetail( lv.Items[i].SubItems[0], StrToFloat(lv.Items[i].Caption) ); ';
  Script.Add := '    AppendDetail( lv.Items[i].SubItems[0], -StrToFloat(lv.Items[i].Caption) ); '; // AA, BZ 3158
  Script.Add := '  end;';
//  Script.Add := '  AppendDetail( VP_ACC_AYAT_SILANG, -DataModule.AtblAPInvChq2.Discount.value ); ';
  Script.Add := '  AppendDetail( VP_ACC_AYAT_SILANG, DataModule.AtblAPInvChq2.Discount.value ); '; // AA, BZ 3158
  Script.Add := '  jvDM.PostData(false); ';
  Script.Add := '  IncNextNoJV; ';
  Script.Add := '  RestoreJVCTL; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure FreeJV; ';
  Script.Add := 'begin';
  Script.Add := '  jvDM.Free;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure ShowMultiDiscountForm; ';
  Script.Add := 'begin';
  Script.Add := '  frm := CreateForm(''frmMultiDisc'', ''Multi Discount Form'', 400, 300);';
  Script.Add := '  try';
  Script.Add := '    CreateVCL;';
  Script.Add := '    DecorateForm; ';
  Script.Add := '    LoadJV; ';
  Script.Add := '    try';
  Script.Add := '      if frm.ShowModal = mrOK then begin ';
  Script.Add := '        SaveToJV; ';
  Script.Add := '      end';
  Script.Add := '      else begin';
  Script.Add := '        Datamodule.AtblAPInvChq.Edit; //put Detail into edit mode again ';
  Script.Add := '        RaiseException(''Multi Discount has not been saved''); ';
  Script.Add := '      end; ';
  Script.Add := '    finally';
  Script.Add := '      FreeJV; ';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    frm.Free; ';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'Procedure SetBackNextNoJV; ';
  Script.Add := 'Var ';
  Script.Add := '  Sql : TjbSQL; ';
  Script.Add := '  ATx : TIBTransaction; ';
  Script.Add := 'Begin ';
  Script.Add := '  ATx := CreateATx; ';
  Script.Add := '  Sql := CreateSQL(ATx); ';
  Script.Add := '  Try ';
  Script.Add := '    RunSQL(Sql,Format(''UPDATE Options SET ValueOpt=''''%s'''' WHERE ParamOpt=''''%s'''''', [NEXT_NO_JV, ''NEXT_NO_JV''] )); ';
  Script.Add := '    ATx.Commit; ';
  Script.Add := '  Finally ';
  Script.Add := '    ATx.Free; ';
  Script.Add := '    Sql.Free; ';
  Script.Add := '  End; ';
  Script.Add := 'End; ';
  Script.Add := '';
  Script.Add := 'procedure DeleteJV;';
  Script.Add := 'begin';
  Script.Add := '  CreateJV; ';
  Script.Add := '  try';
  Script.Add := '    SetBackNextNoJV; ';
  Script.Add := '    writeOption( JV_ALLOW_DELETE, ''1'' ); ';
  Script.Add := '    jvDM.AtblJV.Delete; ';
  Script.Add := '    writeOption( JV_ALLOW_DELETE, ''0'' ); ';
  Script.Add := '    jvDM.PostData(false); ';
  Script.Add := '  finally';
  Script.Add := '    FreeJV; ';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TVPMultiDiscInjector.Variables(SetVP: Boolean=True);
begin
  ReadOption;
  Script.Add := 'var ';
  Script.Add := '  VP_ACC_AYAT_SILANG : String; ';
  Script.Add := '  JV_VPID_FIELD      : String; ';
  Script.Add := '  JV_PIID_FIELD      : String; ';
  if SetVP=True then begin
    Script.Add := '  FORMAT_JV          : String; ';
    Script.Add := '  NUMBER_JV          : String; ';
    Script.Add := '  NEXT_NO_JV         : String; ';
    Script.Add := '';
    RightStr;
    LeftStr;
  end;
  Script.Add := 'procedure InitializeParameter; ';
  Script.Add := 'begin ';
  Script.Add := '  VP_ACC_AYAT_SILANG := ReadOption(''VP_ACC_AYAT_SILANG''); ';
  Script.Add := '  JV_VPID_FIELD      := ReadOption(''JV_VPID_FIELD'', ''CustomField1''); ';
  Script.Add := '  JV_PIID_FIELD      := ReadOption(''JV_PIID_FIELD'', ''CustomField2''); ';
  if SetVP=True then begin
    Script.Add := '  FORMAT_JV          := ReadOption(''FORMAT_JV'', ''JVVP''); ';
    Script.Add := '  NEXT_NO_JV         := ReadOption(''NEXT_NO_JV'', ''14-00001''); ';
    Script.Add := '  If LeftStr(NEXT_NO_JV, 2) <> RightStr(DateToStr(Date), 2) Then NEXT_NO_JV := RightStr(DateToStr(Date), 2) + ''-00001''; ';
    Script.Add := '  NUMBER_JV          := FORMAT_JV + ''-'' + NEXT_NO_JV; ';
  end;
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TVPMultiDiscInjector.GenerateVPDataset;
begin
  ClearScript;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  WriteOption;
  Variables;
  addConst;
  Script.Add := 'function IsJVExist(sql:TjbSQL):Boolean; ';
  Script.Add := '  function GetSQL:String; ';
  Script.Add := '  begin';
  {Script.Add := '    result := format(''select * FROM APCHEQ ac join APINVCHQ aic on aic.CHEQUEID=ac.CHEQUEID ' +
                '      where ac.ChequeID=%d and EXISTS( select * from JV j join EXTENDED e on j.EXTENDEDID=e.EXTENDEDID ' +
                '        where j.TRANSDATE=ac.CHEQUEDATE AND j.TRANSTYPE=''''JV'''' and e.%s=aic.CHEQUEID '+
                '        and e.%s=aic.APINVOICEID)'', [Dataset.ChequeID.value, JV_VPID_FIELD, JV_PIID_FIELD]); ';}
  Script.Add := '    result := format(''SELECT distinct j.JVID from APCHEQ ac join APINVCHQ aic on aic.CHEQUEID=ac.CHEQUEID '+
                '     join jv j on j.TRANSDATE=ac.CHEQUEDATE '+
                '     join EXTENDED e on j.EXTENDEDID=e.EXTENDEDID '+
                '     where ac.CHEQUEID=%d and e.%s=aic.CHEQUEID and e.%s=aic.APINVOICEID'', '+
                '     [Dataset.ChequeID.value, JV_VPID_FIELD, JV_PIID_FIELD]); ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '    RunSQL(sql, GetSQL); ';
  Script.Add := '    result := sql.RecordCount > 0; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure DeleteOneJV(jvID:Integer); ';
  Script.Add := 'var jvDM : TdmJV; ';
  Script.Add := 'begin';
  Script.Add := '  jvDM := TdmJV.ACreate(TIBDatabase(DB), TIBTransaction(Dataset.Tx), JVID, UserID, 1); ';
  Script.Add := '  try';
  Script.Add := '    jvDM.DMStartDatabase; ';
  Script.Add := '    jvDM.AtblJV.Delete; ';
  Script.Add := '    jvDM.PostData(false); ';
  Script.Add := '  finally';
  Script.Add := '    jvDM.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure DeleteJV(sql:TjbSQL); ';
  Script.Add := 'begin';
  Script.Add := '  writeOption( JV_ALLOW_DELETE, ''1'' ); ';
  Script.Add := '  while not sql.EOF do begin';
  Script.Add := '    DeleteOneJV( sql.FieldByName(''JVID'') ); ';
  Script.Add := '    sql.Next; ';
  Script.Add := '  end; ';
  Script.Add := '  writeOption( JV_ALLOW_DELETE, ''0'' ); ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure OnBeforeDelete; ';
  Script.Add := 'var sql:TjbSQL; ';
  Script.Add := 'begin';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  try';
  Script.Add := '    if IsJVExist(sql) then DeleteJV(sql);';
  Script.Add := '  finally';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  InitializeParameter; ';
  Script.Add := '  Dataset.OnBeforeDeleteArray := @OnBeforeDelete; ';
  Script.Add := 'end.';
end;

procedure TVPMultiDiscInjector.GenerateVP;
begin
  ClearScript;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  Variables;
  VPMultiDiscountForm;
  WriteOption;
  Script.Add := 'var Discount : Variant; ';
  Script.Add := '    DiscAcc  : Variant; ';
  Script.Add := '    DeptID   : Variant; ';
  Script.Add := '    ProjID   : Variant; ';
  Script.Add := '';
  Script.Add := 'procedure OnNewRecord; ';
  Script.Add := 'begin';
  Script.Add := '  Discount := null; ';
  Script.Add := '  DiscAcc  := null; ';
  Script.Add := '  DeptID   := null; ';
  Script.Add := '  ProjID   := null; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure OnBeforeEdit; ';
  Script.Add := '  procedure AssignVar(var Data:variant; field:TField);';
  Script.Add := '  begin';
  Script.Add := '    if Field.IsNull then Data := null else Data := Field.value; ';
  Script.Add := '  end;';
  Script.Add := 'begin';
  Script.Add := '  AssignVar(Discount, Datamodule.AtblAPInvChq2.Discount); ';
  Script.Add := '  AssignVar(DiscAcc , Datamodule.AtblAPInvChq2.DiscAccount); ';
  Script.Add := '  AssignVar(DeptID  , Datamodule.AtblAPInvChq2.DeptID); ';
  Script.Add := '  AssignVar(ProjID  , Datamodule.AtblAPInvChq2.ProjectID); ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure CheckMultiDiscount;';
  Script.Add := '  function isMultiDiscAcc(data:Variant):Boolean;';
  Script.Add := '  begin';
  Script.Add := '    result := (data <> null) and (Data = VP_ACC_AYAT_SILANG);';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := '  function IsDiff(Data: variant; Field:String):Boolean;';
  Script.Add := '  begin';
  Script.Add := '    result := Data <> Datamodule.AtblAPInvChq2.FieldByName(Field).value; ';
  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  if IsDiff(Discount, ''Discount'') or IsDiff(DiscAcc, ''DiscAccount'') '+
    'or IsDiff(DeptID, ''DeptID'') or IsDiff(ProjID, ''ProjectID'') then begin';
  Script.Add := '    if IsMultiDiscAcc(DiscAcc) and not IsMultiDiscAcc(Datamodule.AtblAPInvChq2.DiscAccount.value) then begin';
  Script.Add := '      ShowMessage(''JV Created by Multi Discount will be deleted''); ';
  Script.Add := '      DeleteJV; ';
  Script.Add := '    end';
  Script.Add := '    else if {IsMultiDiscAcc(DiscAcc) or} IsMultiDiscAcc(Datamodule.AtblAPInvChq2.DiscAccount.value) then begin';
  Script.Add := '      ShowMultiDiscountForm; ';
  Script.Add := '    end';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  InitializeParameter; ';
  Script.Add := '  Datamodule.AtblAPInvChq2.OnNewRecordArray  := @OnNewRecord; ';
  Script.Add := '  Datamodule.AtblAPInvChq2.OnBeforeEditArray := @OnBeforeEdit; ';
  Script.Add := '  Datamodule.AtblAPInvChq2.OnBeforePostArray := @CheckMultiDiscount; ';
  Script.Add := 'end.';
end;

procedure TVPMultiDiscInjector.MainCreateMenuSetting;
begin
  CreateFormSetting;
  Script.Add := 'procedure ShowSetting; ';
  Script.Add := 'var frmSetting : TForm; ';
  Script.Add := 'begin ';
  Script.Add := '  frmSetting := CreateFormSetting(''frmSetting'', ''VP Multi Discount Setting'', 400, 400);';
  Script.Add := '  try ';
  Script.Add := '    AddControl( frmSetting, ''VP-Akun Ayat Silang'', ''ACCOUNT_10'', ''VP_ACC_AYAT_SILANG'', '''', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''JV-VP ID Field'', ''CUSTOMFIELD'', ''JV_VPID_FIELD'', ''CustomField1'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''JV-PI ID Field'', ''CUSTOMFIELD'', ''JV_PIID_FIELD'', ''CustomField2'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Format JV'', ''TEXT'', ''FORMAT_JV'', ''JVVP'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Next No JV'', ''TEXT'', ''NEXT_NO_JV'', ''14-00001'', ''0'', ''''); ';
  Script.Add := '    if frmSetting.ShowModal = mrOK then begin ';
  Script.Add := '      SaveToOptions; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    frmSetting.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure AddMenuSettingMultiDisc;';
  Script.Add := 'var mnuMultiDiscSetting : TMenuItem; ';
  Script.Add := 'begin ';
  Script.Add := '  mnuMultiDiscSetting := TMenuItem(Form.FindComponent( ''mnuMultiDiscSetting'' )); ';
  Script.Add := '  if mnuMultiDiscSetting <> nil then mnuMultiDiscSetting.Free; ';
  Script.Add := '  mnuMultiDiscSetting := TMenuItem.Create( Form );';
  Script.Add := '  mnuMultiDiscSetting.Name    := ''mnuMultiDiscSetting'';';
  Script.Add := '  mnuMultiDiscSetting.Caption := ''Setting VP Multi Discount'';';
  Script.Add := '  mnuMultiDiscSetting.OnClick := @ShowSetting;';
  Script.Add := '  mnuMultiDiscSetting.Visible := True;';
  Script.Add := '  Form.AmnuEdit.Add( mnuMultiDiscSetting );';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TVPMultiDiscInjector.GenerateMain;
begin
  ClearScript;
  MainCreateMenuSetting;
  IsAdmin;
  Script.Add := 'BEGIN';
  Script.Add := '  if IsAdmin then AddMenuSettingMultiDisc; ';
  Script.Add := 'END.';
end;

procedure TVPMultiDiscInjector.addConst;
begin
  Script.Add := 'const JV_ALLOW_DELETE = ''JV_ALLOW_DELETE'';  ';
end;

procedure TVPMultiDiscInjector.DatasetJVBeforeEdit;
begin
  Script.Add := 'procedure DatasetBeforeEdit; ';
  Script.Add := '  function IsNull(Field:String):Boolean;';
  Script.Add := '  begin';
  Script.Add := '    result := Master.ExtendedID.FieldLookup.FieldByName(Field).isNull;';
  Script.Add := '  end;';
  Script.Add := 'begin';
  Script.Add := '  if not (IsNull(JV_VPID_FIELD) or IsNull(JV_PIID_FIELD)) then begin';
  Script.Add := '    RaiseException(''Multi discount JV can not be edited'');';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
end;

procedure TVPMultiDiscInjector.generateJVDataset;
begin
  ClearScript;
  ReadOption;
  DatasetExtended;
  addConst;
  Script.Add := 'var JV_PIID_FIELD : String; ';
  Script.Add := 'procedure InitializeParameter; ';
  Script.Add := 'begin ';
  Script.Add := '  JV_PIID_FIELD      := ReadOption(''JV_PIID_FIELD'', ''CustomField2''); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure doValidate; ';
  Script.Add := '  function isVPDiscountExist:Boolean; ';
  Script.Add := '  var sqlJV : TjbSQL; ';
  Script.Add := '  begin ';
  Script.Add := '    result := False; ';
  Script.Add := '    if datasetExtended(JV_PIID_FIELD).isNull then Exit; ';
  Script.Add := '    sqlJV := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '    try ';
  Script.Add := '      RunSQL( sqlJV, Format(''Select 1 from APInvChq vpdet where '+
                               'vpdet.APInvoiceID=%d'',[datasetExtended(JV_PIID_FIELD).AsInteger]) ); ';
  Script.Add := '      result := NOT sqlJV.Eof; ';
  Script.Add := '    finally ';
  Script.Add := '      sqlJV.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '';
  Script.Add := '  function isAllowDelete:Boolean; ';
  Script.Add := '  begin ';
  Script.Add := '    result := ReadOption( JV_ALLOW_DELETE, ''0'' ) = ''1''; ';
  Script.Add := '  end; ';
  Script.Add := 'begin ';
  Script.Add := '  if isVPDiscountExist and NOT isAllowDelete then begin ';
  Script.Add := '    raiseException( Format(''VP with Form No %s still exist'',[Dataset.TransDescription.AsString] ) ); ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := '  InitializeParameter; ';
  Script.Add := '  Dataset.OnBeforeDeleteArray := @doValidate; ';
  Script.Add := 'end. ';
end;

procedure TVPMultiDiscInjector.GenerateJVForm;
begin
  ClearScript;
  Variables(False);
  DatasetJVBeforeEdit;
  Script.Add := 'begin';
  Script.Add := '  InitializeParameter; ';
  Script.Add := '  Master.OnBeforeEditArray := @DatasetBeforeEdit; ';
  Script.Add := 'end.';
end;

procedure TVPMultiDiscInjector.generateJVList;
begin
  ClearScript;
  CreateCheckBox;
  CreateLabel;
  TopPos;
  ReadOption;
  Script.Add := 'var JV_PIID_FIELD : String; ';
  Script.Add := '    chkVP : TCheckBox; ';
  Script.Add := 'procedure doCheck; ';
  Script.Add := 'begin ';
  Script.Add := '  Form.setFilterAndRun; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure addFilter; ';
  Script.Add := 'var lblVP : TLabel; ';
  Script.Add := 'begin ';
  Script.Add := '  lblVP := createLabel( Form.ALabel5.Left, Form.APanel1.Height -40, 100, 12, ''Add Filter'', Form.AcbDa.Parent ); ';
  Script.Add := '  lblVP.Font.Style := fsBold; ';
  Script.Add := '  lblVP.Font.Height := Form.ALabel5.Height; ';
  Script.Add := '  chkVP := createCheckBox( Form.ACbDa.Left, TopPos(lblVP), 100, Form.AcbDa.Height, '+
                         '''Multi Discount'', Form.AcbDa.Parent ); ';
  Script.Add := '  chkVP.OnClick := @doCheck; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure InitializeParameter; ';
  Script.Add := 'begin ';
  Script.Add := '  JV_PIID_FIELD      := ReadOption(''JV_PIID_FIELD'', ''CustomField2''); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure doBeforeOpen; ';
  Script.Add := 'var filterVPSQL : String; ';
  Script.Add := 'begin ';
  Script.Add := '  filterVPSQL := Format(''e.%s in (select distinct vpdet.APINVOICEID from APINVCHQ vpdet)'',[JV_PIID_FIELD]); ';
  Script.Add := '  if chkVP.Checked then begin ';
  Script.Add := '    DataModule.AqryJV.SelectSQL[2] := ReplaceStr( DataModule.AqryJV.SelectSQL[2], '+
                                                    '''1=1'', filterVPSQL )  ';
  Script.Add := '  end ';
  Script.Add := '  else begin ';
  Script.Add := '    DataModule.AqryJV.SelectSQL[2] := ReplaceStr( DataModule.AqryJV.SelectSQL[2], '+
                                                    'filterVPSQL, ''1=1'' )  ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure setDisallowDeleteJV; ';
  Script.Add := 'var iniFile : TIniFile; ';
  Script.Add := 'begin ';
  Script.Add := '  iniFile := TIniFile.Create( GetApplicationDataDir + ''allowDeleteVP.ini'' ); ';
  Script.Add := '  try ';
  Script.Add := '    iniFile.WriteInteger( ''SettingDeleteVP'', ''Allow'', 0 ); ';
  Script.Add := '  finally ';
  Script.Add := '    iniFile.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := '  InitializeParameter; ';
  Script.Add := '  addFilter; ';
  Script.Add := '  setDisallowDeleteJV; ';
  Script.Add := '  dataModule.AqryJV.BeforeOpen := @doBeforeOpen; ';
  Script.Add := 'end. ';
end;

procedure TVPMultiDiscInjector.GenerateScript;
begin
  GenerateVP;
  InjectToDB( fnAPCheque );

  GenerateMain;
  InjectToDB( fnMain );

  GenerateVPDataset;
  InjectToDB( dnVP );

  GenerateJVForm;
  InjectToDB(fnJV);

  generateJVList;
  InjectToDB( fnJVs );

  generateJVDataset;
  InjectToDB( dnJV );

end;

end.
