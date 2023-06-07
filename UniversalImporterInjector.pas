unit UniversalImporterInjector;

interface

uses
  injector, BankConst, System.SysUtils;

type
  TUniversalImporterInjector = class(TInjector)
  private
    procedure VarAndConst;
    procedure DoAutoImportCSV;
    procedure GenerateScriptForMain;
  protected
    procedure ExecuteImport; virtual;
    procedure set_scripting_parameterize; override;
  public
     procedure GenerateScript; override;
  end;

implementation

{ TUniversalImporterInjector }

procedure TUniversalImporterInjector.ExecuteImport;
begin
//  Script.Add := '';
//  Script.Add := 'procedure ExecuteImport (FReader : TUniversalImporterReader; iniDirFile, file_location : string);';
//  Script.Add := 'begin';
//  Script.Add := '  FReader.read_importer_config_file(iniDirFile);';
//  Script.Add := '  FReader.from_csv_to_db(file_location);';
//  Script.Add := 'end;';

  Script.Add := EmptyStr;
  Script.Add := 'function ExecuteImport (FReader : TUniversalImporterReader; iniDirFile, file_location : string) : string;';  //SCY BZ 3549
  Script.Add := 'begin';
  Script.Add := '  FReader.read_importer_config_file(iniDirFile);';
  Script.Add := '  Result := FReader.from_csv_to_db(file_location);';
  Script.Add := 'end;';

end;

procedure TUniversalImporterInjector.DoAutoImportCSV;
begin
  ExecuteImport;

  Script.Add := 'procedure DoAutoImportCSV; ';
  Script.Add := 'var';
  Script.Add := '  iniDirFile       : String; ';
  Script.Add := '  iniAutoImport    : String; ';
  Script.Add := '  iniTo_Import     : String; ';
  Script.Add := '  iniImported      : String; ';
  Script.Add := '  iniError         : String; ';
  Script.Add := '  iniTimer         : String; ';
  Script.Add := '  iniImport_Time   : String; ';
  Script.Add := '  iniTime_From     : String; ';
  Script.Add := '  iniTime_To       : String; ';
  Script.Add := '  iniSkipFirstLine : Integer; ';
  Script.Add := '  ';
  Script.Add := '  procedure ReadIniFile; ';
  Script.Add := '    var iniFile    : TiniFile; ';
  Script.Add := '  begin ';
  Script.Add := '    iniDirFile := ExtractFilePath( Application.ExeName ) + ''ImportCSV.ini''; ';
  Script.Add := '    if not FileExists( iniDirFile ) then Exit; ';
  Script.Add := '    iniFile := TiniFile.Create( iniDirFile ); ';
  Script.Add := '    try ';
  Script.Add := '      iniAutoImport    := iniFile.ReadString( ''Auto'', ''AutoImport'', ''0'' ); ';
  Script.Add := '      iniTo_Import     := iniFile.ReadString( ''Auto'', ''To_Import'', '''' ); ';
  Script.Add := '      iniImported      := iniFile.ReadString( ''Auto'', ''Imported'', '''' ); ';
  Script.Add := '      iniError         := iniFile.ReadString( ''Auto'', ''Error'', '''' ); ';
  Script.Add := '      iniTimer         := iniFile.ReadString( ''Auto'', ''Timer'', ''1'' ); ';
  Script.Add := '      iniImport_Time   := iniFile.ReadString( ''Auto'', ''Import_Time'', ''0'' ); ';
  Script.Add := '      iniTime_From     := iniFile.ReadString( ''Auto'', ''Start_Time'', '''' ); ';
  Script.Add := '      iniTime_To       := iniFile.ReadString( ''Auto'', ''End_Time'', '''' ); ';
  Script.Add := '      iniSkipFirstLine := iniFile.ReadInteger( ''Main'', ''SkipFirstLine'', 0 ); ';
  Script.Add := '    finally ';
  Script.Add := '      iniFile.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  function IsValidImport: Boolean; ';
  Script.Add := '    function IsValidMinute( min: String ): Boolean; ';
  Script.Add := '    begin ';
  Script.Add := '      result := False; ';
  Script.Add := '      if min = '''' then Exit; ';
  Script.Add := '      if ( ( min >= ''00:00'' ) and ( min <= ''23:59'' ) ) then begin ';
  Script.Add := '        result := True; ';
  Script.Add := '      end; ';
  Script.Add := '    end; ';
  Script.Add := '  begin ';
  Script.Add := '    result := True; ';
  Script.Add := '    if iniAutoImport = ''0'' then result := False; ';
  Script.Add := '    if iniTo_Import = '''' then result := False; ';
  Script.Add := '    if iniImported = '''' then result := False; ';
  Script.Add := '    if iniError = '''' then result := False; ';
  Script.Add := '    if not DirectoryExists( iniTo_Import ) then result := False; ';
  Script.Add := '    if not DirectoryExists( iniImported ) then result := False; ';
  Script.Add := '    if not DirectoryExists( iniError ) then result := False; ';
  Script.Add := '    if ( ( iniTimer <> '''' ) and IsNumber( iniTimer ) ) then begin ';
  Script.Add := '      if StrToInt( iniTimer ) < 1 then result := False; ';
  Script.Add := '    end else begin ';
  Script.Add := '      result := False; ';
  Script.Add := '    end; ';
  Script.Add := '    if iniImport_Time = ''1'' then begin ';
  Script.Add := '      if not IsValidMinute( iniTime_From ) then result := False; ';
  Script.Add := '      if not IsValidMinute( iniTime_To ) then result := False; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  function IsValidImportTime: Boolean; ';
  Script.Add := '    var minNow : String; ';
  Script.Add := '  begin ';
  Script.Add := '    result := True; ';
  Script.Add := '    if iniImport_Time = ''1'' then begin ';
  Script.Add := '      minNow := FormatDateTime( ''hh:mm'', Now ); ';
  Script.Add := '      if not ( ( minNow >= iniTime_From ) and ( minNow <= iniTime_To ) ) then begin ';
  Script.Add := '        result := False; ';
  Script.Add := '      end; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  procedure load_file_csv( file_location: String ); ';
  Script.Add := '    var FReader     : TUniversalImporterReader; ';
  Script.Add := '        iniFile     : TIniFile; ';
  Script.Add := '        listSuccess : TStringList; ';
  Script.Add := '        listError   : TStringList; ';
  Script.Add := '        Field       : TStringList; ';
  Script.Add := '        RowList     : string;';  //SCY BZ 3549
  Script.Add := '    const';
  Script.Add := '      ENDROW = ''EndRow'';';
  Script.Add := '    ';
//  Script.Add := '    procedure CreateListError; ';
//  Script.Add := '    begin ';
//  Script.Add := '      listError := FReader.ListRowError; ';
//  Script.Add := '    end; ';
//  Script.Add := '    ';
//  Script.Add := '    procedure CreateListSuccess; ';
//  Script.Add := '    begin ';
//  Script.Add := '      listSuccess := FReader.ListRowSuccess; ';
//  Script.Add := '    end; ';
//  Script.Add := '    ';
  Script.Add := '    procedure CreateFileError; ';
  Script.Add := '      var errorFile : String; ';
  Script.Add := '          idxError  : Integer = 0; ';
  Script.Add := '    begin ';
  Script.Add := '      errorFile := format( ''%s\%s.csv'', [ iniError, GetToken( ExtractFileName( file_location ), ''.'', 1 ) ] ); ';
  Script.Add := '      for idxError := 0 to listError.Count-1 do begin ';
  Script.Add := '        AssignFileText( errorFile, Field[ StrToInt( listError[ idxError ] ) ] ); ';
  Script.Add := '      end; ';
  Script.Add := '    end; ';
  Script.Add := '    ';
  Script.Add := '    procedure CreateFileImported; ';
  Script.Add := '      var importedFile : String; ';
  Script.Add := '          idxSuccess   : Integer = 0; ';
  Script.Add := '    begin ';
  Script.Add := '      importedFile := format( ''%s\%s.csv'', [ iniImported, GetToken( ExtractFileName( file_location ), ''.'', 1 ) ] ); ';
  Script.Add := '      for idxSuccess := 0 to listSuccess.Count-1 do begin ';
  Script.Add := '        AssignFileText( importedFile, Field[ StrToInt( listSuccess[ idxSuccess ] ) ] ); ';
  Script.Add := '      end; ';
  Script.Add := '    end; ';
  Script.Add := '    ';
  Script.Add := '    procedure DeleteFileImport; ';
  Script.Add := '    begin ';
  Script.Add := '      if ( ( listError.Count > 0 ) or ( listSuccess.Count > 0 ) ) then begin ';
  Script.Add := '        DeleteFile( file_location ); ';
  Script.Add := '      end; ';
  Script.Add := '    end; ';
  Script.Add := '    ';
  Script.Add := '    procedure MoveFileImport; ';
  Script.Add := '    begin ';
  Script.Add := '      Field       := TStringList.Create; ';
//  Script.Add := '      listError   := TStringList.Create; ';
//  Script.Add := '      listSuccess := TStringList.Create; ';
  Script.Add := '      try ';
  Script.Add := '        Field.LoadFromFile( file_location ); ';
//  Script.Add := '        CreateListError; ';
//  Script.Add := '        CreateListSuccess; ';
  Script.Add := '        CreateFileError; ';
  Script.Add := '        CreateFileImported; ';
  Script.Add := '        DeleteFileImport; ';
  Script.Add := '      finally ';
//  Script.Add := '        listSuccess.Free; ';
//  Script.Add := '        listError.Free; ';
  Script.Add := '        Field.Free; ';
  Script.Add := '      end; ';
  Script.Add := '    end; ';
  Script.Add := '  begin ';
  Script.Add := '    if not IsValidImportTime then Exit; ';
  Script.Add := '    FReader := TUniversalImporterReader.Create; ';
  Script.Add := '    iniFile := TIniFile.Create( iniDirFile ); ';
  Script.Add := '    listError   := TStringList.Create; ';  //SCY BZ 3549
  Script.Add := '    listSuccess := TStringList.Create; ';  //SCY BZ 3549
  Script.Add := '    try ';
  Script.Add := '      try ';
//  Script.Add := '        ExecuteImport (FReader, iniDirFile, file_location);';
  Script.Add := '        RowList := ExecuteImport (FReader, iniDirFile, file_location);';  //SCY BZ 3549
  Script.Add := '        listSuccess.Text := GetToken(RowList, ENDROW, 1);';  //SCY BZ 3549
  Script.Add := '        listError.Text   := GetToken(RowList, ENDROW, 2);';  //SCY BZ 3549
  Script.Add := '      except ';
  Script.Add := '      end; ';
  Script.Add := '    finally ';
  Script.Add := '      MoveFileImport; ';
  Script.Add := '      FReader.Free; ';
  Script.Add := '      iniFile.Free; ';
  Script.Add := '      listSuccess.Free; ';  //SCY BZ 3549
  Script.Add := '      listError.Free; ';  //SCY BZ 3549
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  procedure list_file_csv; ';
  Script.Add := '    var listFile : TStringList; ';
  Script.Add := '        idxFile  : Integer; ';
  Script.Add := '  begin ';
//  Script.Add := '    listFile := TStringList.Create; ';  //SCY BZ 3549 Avoid Leak
  Script.Add := '    try ';
  Script.Add := '      listFile := GetFolderContent( iniTo_Import, ''*.csv'' ); ';
  Script.Add := '      for idxFile := 0 to listFile.Count-1 do begin ';
  Script.Add := '        load_file_csv( listFile[ idxFile ] ); ';
  Script.Add := '      end; ';
  Script.Add := '    finally ';
  Script.Add := '      listFile.Free; ';
  Script.Add := '    end; ';
  Script.Add := '  end; ';
  Script.Add := '  ';
  Script.Add := '  procedure CreateTimer; ';
  Script.Add := '    var timer : TTimer; ';
  Script.Add := '  begin ';
  Script.Add := '    if not IsValidImport then Exit; ';
  Script.Add := '    timer := TTimer.Create( script_object ); ';
  Script.Add := '    timer.Interval := ( StrToInt( iniTimer ) * 1000 ); ';
  Script.Add := '    timer.OnTimer  := @list_file_csv; ';
  Script.Add := '  end; ';
  Script.Add := 'begin ';
  Script.Add := '  ReadIniFile; ';
  Script.Add := '  CreateTimer; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TUniversalImporterInjector.GenerateScript;
begin
  GenerateScriptForMain;
  InjectToDB( fnMain );
end;

procedure TUniversalImporterInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := 'UniversalImporter';
end;

procedure TUniversalImporterInjector.VarAndConst;
begin
  Script.add := 'var';
  Script.add := '  frmImportCSV    : TForm;';
  Script.add := '  LFileName       : TLabel;';
  Script.Add := '  TextLocation    : TEdit;';
  Script.Add := '  LblLocation     : TLabel;';
  Script.add := '  btnBrowse       : TButton;';
  Script.add := '  btnOK           : TButton;';
  Script.add := '  BtnCancel       : TButton;';
  Script.Add := '  iniLastUpdate   : String;';
  Script.Add := '  iniErrorLogFile : String;';
  Script.Add := 'const';
  Script.Add := '  ENDROW = ''EndRow'';';
  Script.Add := '';
end;

procedure TUniversalImporterInjector.GenerateScriptForMain;
begin
  ClearScript;
  CreateMenu;
  CreateForm;
  CreateButton;
  CreateLabel;
  CreateEditBox;
  VarAndConst;
  IsNumber;
  DoAutoImportCSV;

  Script.Add :='procedure OnClickMenu;  ';
  Script.Add :='var    AStringList : TStringList;  ';
  Script.Add :='begin';
  Script.Add :='  frmImportCSV := CreateForm(''frmImportCSV'', ''Import From CSV'', 400, 150); ';
  Script.Add :='  AStringList := TStringList.Create; ';
  Script.Add :='  try ';
  Script.Add :='    ReadIniFile;  ';
  Script.Add :='    frmImportCSV.BorderStyle := bsDialog;  ';
  Script.Add :='    LFileName := CreateLabel(5, 5, frmImportCSV.ClientWidth - 35, 25, ''File Name : '', frmImportCSV);  ';
  Script.Add :='    LFileName.Font.Size := 13;  ';
  Script.Add :='    TextLocation := CreateEdit(LFileName.Left, LFileName.Top + LFileName.Height + 5, frmImportCSV.ClientWidth - 35, 20, frmImportCSV); ';
  Script.Add :='    btnBrowse := CreateBtn(TextLocation.Left + TextLocation.Width + 3, TextLocation.Top, 25, TextLocation.Height, 0,''...'', frmImportCSV);   ';
  Script.Add :='    btnBrowse.OnClick := @BtnBrowseClick; ';
  Script.Add :='    btnOK :=  CreateBtn((frmImportCSV.Width - ( 2 * 60))  div 2 , frmImportCSV.Height - 65, 60, 30, 0, ''OK'', frmImportCSV); ';
  Script.Add :='    BtnCancel   := CreateBtn(BtnOK.Left + BtnOK.Width + 5, BtnOK.Top, BtnOK.Width, BtnOK.Height, 0, ''Cancel'', frmImportCSV);  ';
  Script.Add :='    btnOK.OnClick := @FileLoadClick; ';
  Script.Add :='    btnOK.ModalResult := mrOK;  ';
  Script.Add :='    btnCancel.ModalResult := mrCancel; ';
  Script.Add :='    TextLocation.Text := iniLastUpdate;  ';
  Script.Add :='    Explode(AStringList, TextLocation.Text, ''\'');  ';
  Script.Add :='    LFileName.Caption := LFileName.Caption + AStringList[AStringList.Count - 1]; ';
  Script.Add :='    frmImportCSV.ShowModal;   ';
  Script.Add :='  finally   ';
  Script.Add :='    AStringList.Free;   ';
  Script.Add :='    frmImportCSV.Free;   ';
  Script.Add :='  end;  ';
  Script.Add :='end; ';
  Script.Add :='   ';
  Script.Add :='procedure BtnBrowseClick;  ';
  Script.Add :='var OpenDialog : TOpenDialog; ';
  Script.Add :='    AStringList : TStringList;  ';
  Script.Add :='begin  ';
  Script.Add :='  AStringList := TStringList.Create;   ';
  Script.Add :='  try  ';
  Script.Add :='    OpenDialog := TOpenDialog.Create( frmImportCSV );   ';
  Script.Add :='    OpenDialog.Filter := ''File csv (*.csv)|*.csv'';  ';
  Script.Add :='    if OpenDialog().Execute then begin ';
  Script.Add :='      TextLocation.Text := OpenDialog.FileName; ';
  Script.Add :='      Explode(AStringList, TextLocation.Text, ''\'');  ';
  Script.Add :='      LFileName.Caption := ''File name : ''+AStringList[AStringList.Count - 1]; ';
  Script.Add :='    end; ';
  Script.Add :='  finally  ';
  Script.Add :='    AStringList.Free; ';
  Script.Add :='  end;  ';
  Script.Add :='end;';
  Script.Add :='  ';
  Script.Add :='procedure Explode(AStrList: TStringList; AStr: string; Sep: string = ''|''); ';
  Script.Add :='var ';
  Script.Add :='  p: integer; ';
  Script.Add :='begin ';
  Script.Add :='  AStrList.Clear; ';
  Script.Add :='  p := Pos(Sep, AStr); ';
  Script.Add :='  while p > 0 do begin  ';
  Script.Add :='    AStrList.Add(Copy(AStr, 1, p-1));   ';
  Script.Add :='    if p <= Length(AStr) then';
  Script.Add :='      AStr := Copy(AStr, p + Length(Sep), Length(AStr));';
  Script.Add :='    p := Pos(Sep, AStr);';
  Script.Add :='  end;  ';
  Script.Add :='  AStrList.Add(Trim(AStr)); ';
  Script.Add :='end; ';
  Script.Add :='';
  Script.Add :='procedure ReadIniFile; ';
  Script.Add :='var iniFile : TiniFile;';
  Script.Add :='begin  ';
  Script.Add :='  iniFile := TiniFile.Create(ExtractFilePath(Application.ExeName)+ ''ImportCSV.ini''); ';
  Script.Add :='  try ';
  Script.Add :='    iniLastUpdate   := iniFile.ReadString(''Update'',''File'','''');    ';
  Script.Add :='    iniErrorLogFile := iniFile.ReadString(''Main'',''ErrorLogFile'','''');    ';
  Script.Add :='  finally  ';
  Script.Add :='    iniFile.Free;  ';
  Script.Add :='  end;  ';
  Script.Add :='end; ';
  Script.Add :='  ';
  Script.Add :='procedure FileLoadClick; ';
  Script.Add :='var';
  Script.Add :='  iniFile     : TIniFile;';
  Script.Add :='  FReader     : TUniversalImporterReader;';
  Script.Add :='  ListSuccess : TStringList;';  //SCY BZ 3549
  Script.Add :='  ListError   : TStringList;';  //SCY BZ 3549
  Script.Add :='  RowList     : string;';  //SCY BZ 3549
  Script.Add :='';
  Script.Add :='  procedure ShowResultImport; ';
  Script.Add :='  begin  ';
  Script.Add :='    if FReader.CountError > 0 then ';
  Script.Add :='      ShowMessage(IntToStr(FReader.CountError)+'' rows of data (Master - Detail) failed to be imported.''+#13#10+''Please check ErrorLogFile!!''+#13#10+''on ''+iniErrorLogFile) ';
  Script.Add :='    else ';
  Script.Add :='      ShowMessage(IntToStr(FReader.CountData)+'' rows of data (Master - Detail)''+#13#10+''has been successfully imported''); ';
  Script.Add :='  end;';
  Script.Add :='';
  Script.Add :='begin ';
  Script.Add :='  FReader     := TUniversalImporterReader.Create;   ';
  Script.Add :='  iniFile     := TIniFile.Create(ExtractFilePath(Application.ExeName)+ ''ImportCSV.ini''); ';
  Script.Add :='  ListSuccess := TStringList.Create;';  //SCY BZ 3549
  Script.Add :='  ListError   := TStringList.Create;';  //SCY BZ 3549
  Script.Add :='  try  ';
//  Script.Add :='    ExecuteImport (FReader, ExtractFilePath(Application.ExeName)+''ImportCSV.ini'', TextLocation.Text);';
  Script.Add :='    RowList := ExecuteImport (FReader, ExtractFilePath(Application.ExeName)+''ImportCSV.ini'', TextLocation.Text);';  //SCY BZ 3549
  Script.Add :='    listSuccess.Text := GetToken(RowList, ENDROW, 1);';  //SCY BZ 3549
  Script.Add :='    listError.Text   := GetToken(RowList, ENDROW, 2);';  //SCY BZ 3549
  Script.Add :='    iniFile.WriteString(''Update'', ''File'',TextLocation.Text);  ';
  Script.Add :='  finally ';
  Script.Add :='    ShowResultImport;';
  Script.Add :='    FReader.Free;';
  Script.Add :='    iniFile.Free;';
  Script.Add :='    ListSuccess.Free;';  //SCY BZ 3549
  Script.Add :='    ListError.Free;';  //SCY BZ 3549
  Script.Add :='  end; ';
  Script.Add :='end;';
  Script.Add :='begin';
//  Script.Add :='  CreateMenu(10,Form.mnuFile,''mnuimport'',''Import Form CSV'',''OnClickMenu'', 10); ';
  Script.Add :='  CreateMenu(10,Form.AmnuFile,''mnuimport'',''Import Form CSV'',''OnClickMenu'', 10); ';  //SCY 3549 note : use Form.AmnuFile to avoid memory leak
  Script.Add :='  DoAutoImportCSV; ';
  Script.Add :='end.';
end;

end.
