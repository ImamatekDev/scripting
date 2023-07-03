unit AutomaticLockingPeriodInjector;

interface
uses Injector, Sysutils, BankConst;

type
  TAutomaticLockingPeriodInjector = class(TInjector)
  private
    procedure MainLockPeriod;
    procedure GenerateScriptForMain;
  protected
    procedure set_scripting_parameterize; override;
  public
    procedure GenerateScript; override;
  end;

implementation

{ TAutomaticLockingPeriodInjector }

procedure TAutomaticLockingPeriodInjector.GenerateScriptForMain;
begin
  ClearScript;
  AddFunction_CreateSQL;
  add_procedure_runsql;
  CreateTx;
  MainLockPeriod;

  Script.Add := EmptyStr;
  Script.Add := 'begin';
  Script.Add := '  CheckPeriod;';
  Script.Add := 'end.';
end;

procedure TAutomaticLockingPeriodInjector.MainLockPeriod;
begin
  Script.Add := EmptyStr;
  Script.Add := 'procedure CheckPeriod;';
  Script.Add := 'const';
  Script.Add := '  TOLERANCE_DAY      = 5;';
  Script.Add := '  LOCKING_DATE_FIELD = ''INFO1'';';
  Script.Add := '  LOCKING_DATE       = ''LOCKING DATE'';';
  Script.Add := 'var';
  Script.Add := '  ErrorPP    : Integer;';
  Script.Add := '  ErrorYY    : Integer;';
  Script.Add := '  DD, MM, YY : Word;';
  Script.Add := '  sql        : TjbSQL;';
  Script.Add := '  trans      : TIBTransaction;';

  Script.Add := EmptyStr;
  Script.Add := '  function GetToleranceDay : Integer;';
  Script.Add := '  begin';
  Script.Add := '    RunSQL(sql, Format (''SELECT %s FROM EXTENDEDDET ED '+
                     'JOIN EXTENDEDTYPE ET ON ED.EXTENDEDTYPEID = ET.EXTENDEDTYPEID '+
                     'WHERE ET.EXTENDEDNAME = ''''%s'''' '' '+
                     ', [LOCKING_DATE_FIELD, LOCKING_DATE]) );';
  Script.Add := '    if sql.EOF then begin';
  Script.Add := '      result := TOLERANCE_DAY;';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      result := StrToInt(sql.FieldByName (Format (''%s'', [LOCKING_DATE_FIELD]) ) );';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  procedure GetCurrentErrorPeriod;';
  Script.Add := '  begin';
  Script.Add := '    RunSQL(sql, ''Select coalesce(c.EPeriodFromPP, 1) EPeriodFromPP '+
                     ', coalesce(c.EPeriodFromYYYY, 1900) EPeriodFromYYYY from Company c'');';
  Script.Add := '    ErrorPP := sql.FieldByName(''EPeriodFromPP'');';
  Script.Add := '    ErrorYY := sql.FieldByName(''EPeriodFromYYYY'');';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  procedure UpdateCurrentErrorPeriod;';
  Script.Add := '  begin';
  Script.Add := '    RunSQL(sql, format(''Update Company set EPeriodFromPP=%d, EPeriodFromYYYY=%d'', [MM, YY]));';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  function IsShouldLock:Boolean;';
  Script.Add := '  var StrEPeriod : String;';
  Script.Add := '      StrDate    : String;';
  Script.Add := '  begin';
  Script.Add := '    DecodeDate( Date, YY, MM, DD );';
  Script.Add := '    StrDate    := formatDateTime(''yyyymm'', Date);';
  Script.Add := '    StrEPeriod := formatDateTime(''yyyymm'', EncodeDate(ErrorYY, ErrorPP, 1));';
  Script.Add := '    result := (StrDate > StrEPeriod) and (DD > GetToleranceDay);';  //SCY BZ 3084
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := 'begin';
  Script.Add := '  Trans := CreateATx;';
  Script.Add := '  sql := CreateSQL(Trans);';
  Script.Add := '  try';
  Script.Add := '    GetCurrentErrorPeriod;';
  Script.Add := '    if IsShouldLock then begin';
  Script.Add := '      UpdateCurrentErrorPeriod;';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '    Trans.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
end;

procedure TAutomaticLockingPeriodInjector.GenerateScript;
begin
  inherited;
  GenerateScriptForMain;
  InjectToDB(fnMain);
end;

procedure TAutomaticLockingPeriodInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := 'Automatic Locking Period';
end;

end.
