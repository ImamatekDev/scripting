

interface
 uses Injector, BankConst;
 type
   TCustomTemplateCollectionInjector = class(TInjector)
  private
    procedure GenerateScriptForMain;
    procedure GenerateScriptForCC;
    procedure InitializationVar;
  protected
    procedure set_scripting_parameterize; override;
  public
    procedure GenerateScript; override;
   end;

implementation

{ TCustomTemplateCollectionInjector }

procedure TCustomTemplateCollectionInjector.InitializationVar;
begin
  ReadOption;
  WriteOption;

  Script.Add := 'var';
  Script.Add := '  LOCATEDFILE_FRF_LOCATION : String;';
  Script.Add := '';
  Script.Add := 'procedure InitializationVar;';
  Script.Add := 'begin';
  Script.Add := '  LOCATEDFILE_FRF_LOCATION := ReadOption(''LOCATEDFILE_FRF_LOCATION'');';
  Script.Add := 'end;';
end;

procedure TCustomTemplateCollectionInjector.GenerateScriptForMain;
begin
  ClearScript;
  CreateFormSetting;
  CreateForm;
  IsAdmin;

  Script.Add := '';
  Script.Add := 'procedure ShowSettingDocLocation;';
  Script.Add := 'var';
  Script.Add := '  frmSetting  : TForm;';

  Script.Add := '  ';
  Script.Add := '  function GetFilePathComboBox : TComboBox;';
  Script.Add := '  const';
  Script.Add := '    FILE_PATH_COMBO_BOX = ''Combo1'';';
  Script.Add := '  begin';
  Script.Add := '    result := TComboBox (ScrollBox.FindComponent (FILE_PATH_COMBO_BOX) );';
  Script.Add := '  end;';

  Script.Add := 'begin';
  Script.Add := '  if not IsAdmin then exit;';
  Script.Add := '  frmSetting := CreateFormSetting(''frmDocSetting'', ''Document Collection Location'', 400, 200);';
  Script.Add := '  try';
  Script.Add := '    ListCtrl.Add('' ; ; ; '');';
  Script.Add := '    AddControl( frmSetting, ''File Path (max : 40 character)'', ''TEXT'', ''LOCATEDFILE_FRF_LOCATION'', '''', ''0'', '''');';
  Script.Add := '    GetFilePathComboBox.MaxLength := 40;';
  Script.Add := '    if frmSetting.ShowModal = mrOK then begin';
  Script.Add := '      SaveToOptions;';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    frmSetting.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  AddCustomMenuSetting(''mnuCustomDocSetting'', ''Document Collection Location'', ''ShowSettingDocLocation'');';
  Script.Add := 'end.';
end;

procedure TCustomTemplateCollectionInjector.GenerateScriptForCC;
begin
  ClearScript;
  InitializationVar;
  CreateButton;

  Script.Add := 'var BtnPrintNew : TButton;';

  Script.Add := '';
  Script.Add := 'procedure HideBtnPrintMain;';
  Script.Add := 'begin';
  Script.Add := '  Form.BtnPrint.Visible := False;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure DoOpenFRF;';
  Script.Add := 'begin';
  Script.Add := '  OpenFRF( LOCATEDFILE_FRF_LOCATION );';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure CreateBtnPrintNew;';
  Script.Add := 'begin';
  Script.Add := '  BtnPrintNew := CreateBtn(Form.BtnPrint.Left, Form.BtnPrint.Top '+
                                  ', Form.BtnPrint.Width, Form.BtnPrint.Height '+
                                  ', 0, ''Print'', Form.PnlButton);';
  Script.Add := '  BtnPrintNew.OnClick := @DoOpenFRF;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure FormOnResizeCC;';
  Script.Add := 'begin';
  Script.Add := '  BtnPrintNew.Left := Form.BtnPrint.Left;';
  Script.Add := '  BtnPrintNew.Top  := Form.BtnPrint.Top;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  InitializationVar;';
  Script.Add := '  CreateBtnPrintNew;';
  Script.Add := '  HideBtnPrintMain;';
  Script.Add := '  Form.OnResize := @FormOnResizeCC;';
  Script.Add := 'end.';
end;

procedure TCustomTemplateCollectionInjector.GenerateScript;
begin
  inherited;
  GenerateScriptForMain;
  InjectToDB(fnMain);

  GenerateScriptForCC;
  InjectToDB(fnCreateCollection);
end;

procedure TCustomTemplateCollectionInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := 'Custom Template Collection';
end;

end.
