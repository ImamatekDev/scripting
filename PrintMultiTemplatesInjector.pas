unit PrintMultiTemplatesInjector;

interface
uses
  Injector, BankConst, System.SysUtils, Language;
type
  TPrintMultiTemplatesInjector = class(TInjector)  //SCY BZ 3547
  private
    procedure GenerateScriptForMain;
  protected
    procedure set_scripting_parameterize; override;
  public
    procedure GenerateScript; override;
  end;

implementation

uses
  MasterDataset;

{ TPrintMultiTemplatesInjector }

procedure TPrintMultiTemplatesInjector.GenerateScriptForMain;
begin
  ClearScript;
  CreateMenu;
  CreateForm;
  CreateButton;
  CreateLabel;
  CreateEditBox;
  CreateComboBox;
  CreateTx;
  AddFunction_CreateSQL;
  add_procedure_runsql;
  LeftPos;
  TopPos;
  LoadCombo;

  Script.Add := EmptyStr;
  Script.Add := 'procedure DecorateFormMultiTemplate(ParentForm: TForm);';
  Script.Add := 'const';
  Script.Add := '  BTN_WIDTH  = 100;';
  Script.Add := '  BTN_HEIGHT = 25;';
  Script.Add := '  SPACE      = 10;';
  Script.Add := '  MAX_ARRAY  = 9;';
  Script.Add := '  SI_INDEX   = 2;';
  Script.Add := 'var';
  Script.Add := '  cbTransName   : TComboBox;';
  Script.Add := '  lblFromTrans  : TLabel;';
  Script.Add := '  edtFromTrans  : TEdit;';
  Script.Add := '  lblToTrans    : TLabel;';
  Script.Add := '  edtToTrans    : TEdit;';
  Script.Add := '  lblTemplName  : TLabel;';
  Script.Add := '  cbTemplName   : TComboBox;';
  Script.Add := '  btnOK         : TButton; ';
  Script.Add := '  btnCancel     : TButton; ';
  Script.Add := '  FirstKeyField : string;';
  Script.Add := '  TableName     : string;';

  Script.Add := Format('  TransArr          : array [0..MAX_ARRAY] of string = [''%s'', ''%s'', ''%s'', ''%s'', ''%s'' '+
                                              ', ''%s'', ''%s'', ''%s'', ''%s'', ''%s''];'
                                              , [TypeSalesOrder, TypeDeliveryOrder, TypeSalesInvoice, TypeSalesReturn, TypeCustomerReceipt
                                              , TypePurchaseOrder, TypeReceiveItem, TypePurchaseInvoice, TypePurchaseReturn, TypeVendorPayment]);
  Script.Add := '  TransTemplTypeArr : array [0..MAX_ARRAY] of Integer = [1, 2, 0, 3, 11, 6, 5, 4, 7, 10];';
  Script.Add := '  TransDatasetArr   : array [0..MAX_ARRAY] of string = [''TSODataset'', ''TDODataset'', ''TSIDataset'', ''TSRDataset'', ''TCRDataset'' '+
                                       ', ''TPODataset'', ''TRIDataset'', ''TPIDataset'', ''TPRDataset'', ''TVPDataset''];';

  Script.Add := EmptyStr;
  Script.Add := '  procedure UpdateStatusPrint(ID:Integer); ';
  Script.Add := '  var';
  Script.Add := '    sqlUpdate : TjbSQL; ';
  Script.Add := '    ATx       : TIBTransaction; ';
  Script.Add := '  begin ';
  Script.Add := '    ATx := CreateATx; ';
  Script.Add := '    sqlUpdate := CreateSQL(ATx); ';
  Script.Add := '    try';
  Script.Add := '      RunSQL( sqlUpdate, ''Select 1 from RDB$RELATION_FIELDS rf  '+
                       'where rf.RDB$RELATION_NAME = ''''ARINV'''' and rf.RDB$FIELD_NAME = ''''PRINTED'''' ''); ';
  Script.Add := '      if ( Not sqlUpdate.EOF ) then begin ';
  Script.Add := '        RunSQL( sqlUpdate, Format(''Update ARInv set Printed = 1 where ARInvoiceID  = %d '', [ID]) ); ';
  Script.Add := '        ATx.Commit; ';
  Script.Add := '      end; ';
  Script.Add := '    finally ';
  Script.Add := '      ATx.Free; ';
  Script.Add := '      sqlUpdate.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';

  Script.Add := EmptyStr;
  Script.Add := '  procedure PrintOneTransaction(TransID : Integer; TemplateID : Integer = -1);';
  Script.Add := '  var';
  Script.Add := '    util : TfrPrintUtility;';
  Script.Add := '  begin';
  Script.Add := '    util := TfrPrintUtility.Create;';
  Script.Add := '    try';
  Script.Add := '      util.PrintOneTransaction(TableName, FirstKeyField, TransID, TIBDatabase(DB), TemplateID);';
  Script.Add := '    finally';
  Script.Add := '      util.free;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  function GetTemplateID : Integer;';
  Script.Add := '  begin';
  Script.Add := '    if (cbTemplName.ItemIndex = 0) then begin';
  Script.Add := '      Result := -1;';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      Result := StrToInt(Format(''%d'', [cbTemplName.Items.Objects[cbTemplName.ItemIndex] ]) );';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  procedure DoPrintByFilter; ';
  Script.Add := '  var';
  Script.Add := '    TransProps  : string;';
  Script.Add := '    NoFieldName : string;';
  Script.Add := '    TransFilter : string;';
  Script.Add := '    TransSQL    : TjbSQL;';
  Script.Add := '    printDialog : TPrintDialog; ';
  Script.Add := '  begin ';
  Script.Add := '    TransSQL := CreateSQL(TIBTransaction(Tx) );';
  Script.Add := '    try';
  Script.Add := '      TransProps    := TMasterDataset.GetPropsFromDatasetClass(TransDatasetArr[cbTransName.ItemIndex] '+
                                        ', TIBDatabase(Db), TjbTx(Tx) );';
  Script.Add := '      TableName     := Trim(GetToken(TransProps, '','', 1) );';
  Script.Add := '      FirstKeyField := Trim(GetToken(TransProps, '','', 2) );';
  Script.Add := '      NoFieldName   := Trim(GetToken(TransProps, '','', 3) );';
  Script.Add := '      TransFilter   := Trim(GetToken(TransProps, '','', 4) );';
  Script.Add := '      if TransFilter <> '''' then begin';
  Script.Add := '        TransFilter := ''AND '' + TransFilter;';
  Script.Add := '      end;';

  Script.Add := '      RunSQL(TransSQL, Format(''SELECT %s FROM %s '+
                       'WHERE %s BETWEEN ''''%s'''' AND ''''%s'''' %s '+
                       'ORDER BY %s'' '+
                       ', [FirstKeyField, TableName, NoFieldName '+
                       ', edtFromTrans.Text, edtToTrans.Text '+
                       ', TransFilter, NoFieldName]) );';

  Script.Add := '      if NOT TransSQL.EOF then begin ';
  Script.Add := '       printDialog := TPrintDialog.Create(Form);';
  Script.Add := '       try ';
  Script.Add := '         if printDialog.Execute then begin ';
  Script.Add := '           while NOT TransSQL.EOF do begin';
  Script.Add := '             PrintOneTransaction(TransSQL.FieldbyName(FirstKeyField), GetTemplateID);';
  Script.Add := '             UpdateStatusPrint(TransSQL.FieldbyName(FirstKeyField) );';
  Script.Add := '             TransSQL.Next; ';
  Script.Add := '           end; ';
  Script.Add := '         end; ';
  Script.Add := '       finally ';
  Script.Add := '         printDialog.Free; ';
  Script.Add := '       end; ';
  Script.Add := '      end; ';
  Script.Add := '    finally';
  Script.Add := '      TransSQL.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  procedure ValidateCompleteField;';
  Script.Add := '  begin';
  Script.Add := '    if edtFromTrans.Text = '''' then begin';
  Script.Add := '      RaiseException(Format(''Mohon isikan kolom "%s"'', [lblFromTrans.Caption]) );';
  Script.Add := '    end else if edtToTrans.Text = '''' then begin';
  Script.Add := '      RaiseException(Format(''Mohon isikan kolom "%s"'', [lblToTrans.Caption]) );';
  Script.Add := '    end else if cbTemplName.Text = ''<None>'' then begin';
  Script.Add := '      RaiseException(Format(''Mohon isikan kolom "%s"'', [lblTemplName.Caption]) );';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  procedure ValidatePrintByFilter;';
  Script.Add := '  begin';
  Script.Add := '    ValidateCompleteField;';
  Script.Add := '    DoPrintByFilter;';
  Script.Add := '    CloseForm;';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  procedure FillTransName;';
  Script.Add := '  var';
  Script.Add := '    idxTrans : Integer;';
  Script.Add := '  begin';
  Script.Add := '    cbTransName.Items.Clear;';
  Script.Add := '    for idxTrans := 0 to MAX_ARRAY do begin';
  Script.Add := '      cbTransName.Items.AddObject(TransArr[idxTrans], TObject(TransTemplTypeArr[idxTrans]) );';
  Script.Add := '    end;';
  Script.Add := '    cbTransName.ItemIndex := SI_INDEX;';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  procedure CreateCombolistTransaction;';
  Script.Add := '  var';
  Script.Add := '    lblTransName : TLabel;';
  Script.Add := '  begin';
  Script.Add := '    lblTransName := CreateLabel(SPACE * 2, SPACE * 2, 125, 25, ''Transaction Name'', ParentForm);';
  Script.Add := '    cbTransName  := CreateComboBox(LeftPos(lblTransName, SPACE), lblTransName.Top, 150, 25, csDropDownList, ParentForm);';
  Script.Add := '    FillTransName;';
  Script.Add := '    cbTransName.OnChange := @FillTemplateName;';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  procedure CreateEditFromTrans;';
  Script.Add := '  begin';
  Script.Add := '    lblFromTrans := CreateLabel(SPACE * 2, TopPos(cbTransName, SPACE), 125, 25, ''From Transaction No.'', ParentForm);';
  Script.Add := '    edtFromTrans := CreateEdit(LeftPos(lblFromTrans, SPACE), lblFromTrans.Top, 150, 25, ParentForm);';
  Script.Add := '    edtFromTrans.MaxLength := 20;';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  procedure CreateEditToTrans;';
  Script.Add := '  begin';
  Script.Add := '    lblToTrans := CreateLabel(SPACE * 2, TopPos(edtFromTrans, SPACE), 125, 25, ''To Transaction No.'', ParentForm);';
  Script.Add := '    edtToTrans := CreateEdit(LeftPos(lblToTrans, SPACE), lblToTrans.Top, 150, 25, ParentForm);';
  Script.Add := '    edtToTrans.MaxLength := 20;';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  procedure FillTemplateName;';
  Script.Add := '  var';
  Script.Add := '    SQL : TjbSQL;';
  Script.Add := '  begin';
  Script.Add := '    SQL := CreateSQL(TIBTransaction(Tx) );';
  Script.Add := '    try';
  Script.Add := '      LoadCombo(SQL, cbTemplName, Format(''SELECT TEMPLATEID ID, NAME CODE FROM TEMPLATE '+
                       'WHERE TEMPLATETYPE = %d ORDER BY TEMPLATEID'' '+
                       ', [cbTransName.Items.Objects[cbTransName.ItemIndex] ]), False);';
  Script.Add := '    finally';
  Script.Add := '      SQL.Free;';
  Script.Add := '    end;';
  Script.Add := '  end; ';

  Script.Add := EmptyStr;
  Script.Add := '  procedure CreateComboListTemplate;';
  Script.Add := '  begin';
  Script.Add := '    lblTemplName := CreateLabel(SPACE * 2, TopPos(edtToTrans, SPACE), 125, 25, ''Template Name'', ParentForm);';
  Script.Add := '    cbTemplName  := CreateComboBox(LeftPos(lblTemplName, SPACE), lblTemplName.Top, 150, 25, csDropDownList, ParentForm);';
  Script.Add := '    FillTemplateName;';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  procedure CreateBtnOK; ';
  Script.Add := '  begin ';
  Script.Add := '    btnOK         := CreateBtn((parentForm.ClientWidth - (BTN_WIDTH * 2)) div 3, parentForm.ClientHeight - BTN_HEIGHT - SPACE, BTN_WIDTH, BTN_HEIGHT, 0, ''OK'', parentForm); ';
  Script.Add := '    btnOK.OnClick := @ValidatePrintByFilter; ';
  Script.Add := '  end; ';

  Script.Add := EmptyStr;
  Script.Add := '  procedure CloseForm;';
  Script.Add := '  begin';
  Script.Add := '    ParentForm.Close;';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  procedure CreateBtnCancel; ';
  Script.Add := '  begin ';
  Script.Add := '    btnCancel         := CreateBtn((btnOK.Left * 2) + btnOK.Width, btnOK.Top, BTN_WIDTH, BTN_HEIGHT, 0, ''Cancel'', parentForm); ';
  Script.Add := '    btnCancel.OnClick := @CloseForm; ';
  Script.Add := '  end; ';

  Script.Add := EmptyStr;
  Script.Add := 'begin';
  Script.Add := '  ParentForm.BorderStyle := bsToolWindow;';
  Script.Add := '  CreateCombolistTransaction;';
  Script.Add := '  CreateEditFromTrans;';
  Script.Add := '  CreateEditToTrans;';
  Script.Add := '  CreateComboListTemplate;';
  Script.Add := '  CreateBtnOK;';
  Script.Add := '  CreateBtnCancel;';
  Script.Add := 'end;';

  Script.Add := EmptyStr;
  Script.Add := 'procedure DestroyForm(sender: TObject; var Action: TCloseAction);';
  Script.Add := 'begin';
  Script.Add := '  Action := caFree;';
  Script.Add := 'end;';

  Script.Add := EmptyStr;
  Script.Add := 'procedure ShowPrintMultiTemplatesForm;';
  Script.Add := 'var';
  Script.Add := '  frmMultiTemplate : TForm;';
  Script.Add := 'begin';
  Script.Add := '  frmMultiTemplate := CreateForm(''frmMultiTemplate'', ''Print Multi Templates'', 320, 240);';
  Script.Add := '  DecorateFormMultiTemplate(frmMultiTemplate);';
  Script.Add := '  frmMultiTemplate.ShowModal;';
  Script.Add := '  frmMultiTemplate.OnClose := @DestroyForm;';
  Script.Add := 'end;';

  Script.Add := EmptyStr;
  Script.Add := 'begin';
  Script.Add := '  CreateMenu( (Form.AEditableList1.Count - 1), Form.AEditableList1, ''mnuPrintMultiTemplates'' '+
                   ', ''Print Multi Templates'', ''ShowPrintMultiTemplatesForm'');';
  Script.Add := 'end.';
end;

procedure TPrintMultiTemplatesInjector.GenerateScript;
begin
  inherited;

  GenerateScriptForMain;
  InjectToDB(fnMain);
end;

procedure TPrintMultiTemplatesInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := 'Print Multi Templates';
end;

end.
