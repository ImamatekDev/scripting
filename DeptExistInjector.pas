unit DeptExistInjector;

interface
uses Injector, Sysutils;

type
  TDeptExistInjector = class(TInjector)
  private
    procedure GenerateScriptForVP; //MMD, BZ 3245
    procedure GenerateScriptForCR; //MMD, BZ 3246
    procedure GenerateScriptForSIDet; //MMD, BZ 3409
    procedure GenerateScriptForJVDet; //MMD, BZ 3562 & 3563
  protected
    procedure set_scripting_parameterize; override;
  public
    procedure GenerateScript; override;
  end;

implementation
uses BankConst;

{ TDeptExistInjector }


procedure TDeptExistInjector.GenerateScriptForVP;
begin
  ClearScript;
  Script.Add := 'procedure BeforePostValidation;';
  Script.Add := 'begin';
//  Script.Add := '  if DataModule.AtblAPInvChq.DeptID.isNull then begin';
  Script.Add := '  if ((DataModule.AtblAPInvChq.DISCOUNT.AsCurrency<>0) And DataModule.AtblAPInvChq.DeptID.isNull) then begin'; // AA, BZ 3720
  Script.Add := '    DataModule.AtblAPInvChq.Cancel;';
  Script.Add := '    RaiseException(''Mohon Kode Departemen diisi'');';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := ' ';
  Script.Add := 'begin';
  Script.Add := '  DataModule.AtblAPInvChq.OnBeforePostValidationArray := @BeforePostValidation;';
  Script.Add := 'end.';
end;

procedure TDeptExistInjector.GenerateScriptForCR;
begin
  ClearScript;
  Script.Add := 'procedure BeforePostValidation;';
  Script.Add := 'begin';
//  Script.Add := '  if DataModule.tblPmtDisc.DeptID.isNull then begin';
  Script.Add := '  if ((DataModule.tblPmtDisc.DISCOUNT.AsCurrency<>0) And DataModule.tblPmtDisc.DeptID.isNull) then begin'; // AA, BZ 3720
  Script.Add := '    RaiseException(''Mohon Kode Departemen diisi'');';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  DataModule.tblPmtDisc.OnBeforePostValidationArray := @BeforePostValidation;';
  Script.Add := 'end.';
end;

procedure TDeptExistInjector.GenerateScriptForJVDet;
begin
  ClearScript;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  Script.Add := 'function GetTransType : String;';
  Script.Add := 'var';
  Script.Add := '  sql : TjbSQL;';
  Script.Add := '  qry : String;';
  Script.Add := 'begin';
  Script.Add := '  sql := nil;';
  Script.Add := '  try';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Dataset.Tx));';
  Script.Add := '    qry := Format(''SELECT transtype FROM jv WHERE jvid = %d;'', [TJVDataset(Dataset).JVID.Value]);';
  Script.Add := '    RunSQL(sql, qry);';          
  Script.Add := '    if NOT sql.EoF then begin';
  Script.Add := '      Result := sql.FieldByName(''transtype'');';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure BeforePost;';
  Script.Add := 'begin';
  Script.Add := '  if ((GetTransType = ''PMT'') OR (GetTransType = ''DPT'')) AND ';
  Script.Add := '      (Dataset.Seq.Value = 0) then exit;';
  Script.Add := '  if Dataset.DeptID.isNull then begin';
  Script.Add := '    RaiseException(''Mohon Kode Departemen diisi''); ';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  Dataset.OnBeforePostArray := @BeforePost;';
  Script.Add := 'end.';
end;

procedure TDeptExistInjector.GenerateScriptForSIDet;
begin
  ClearScript;
  add_procedure_runsql;
  AddFunction_CreateSQL;
  Script.Add := 'function isInvFromSR : Boolean;';
  Script.Add := 'var';
  Script.Add := '  sql : TjbSQL;';
  Script.Add := '  query : String;';
  Script.Add := 'begin';
  Script.Add := '  sql := Nil;';
  Script.Add := '  try';
  Script.Add := '    sql := CreateSQL(TIBTransaction(Dataset.Tx));';
  Script.Add := '    query := format(''SELECT invfromsr FROM arinv WHERE arinvoiceid = %d;'', ' +
                                      '[Dataset.ARInvoiceID.AsInteger]);';
  Script.Add := '    RunSQL(sql, query);';
  Script.Add := '    result := (sql.FieldByName(''invfromsr'') = ''1'');';
  Script.Add := '  finally';
  Script.Add := '    sql.Free;';
  Script.Add := '  end; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'procedure BeforePost;';
  Script.Add := 'begin';
  Script.Add := '  if isInvFromSR then exit;';
  Script.Add := '  if Dataset.DeptID.isNull then begin';
  Script.Add := '    RaiseException(''Mohon Kode Departemen diisi'');';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  Dataset.OnBeforePostArray := @BeforePost;';
  Script.Add := 'end.';
end;

procedure TDeptExistInjector.GenerateScript;
begin
  GenerateScriptCheckDept;
  InjectToDB( dnPODet );
  InjectToDB( dnRIItm );
  InjectToDB( dnPIItm );
  InjectToDB( dnPIDet );
  InjectToDB( dnPRDet );
  InjectToDB( dnVP    );
  //InjectToDB( dnVPInv );
//  InjectToDB( dnSIDet );
  InjectToDB( dnDODet );
  InjectToDB( dnSODet );
  InjectToDB( dnSRDet );
  InjectToDB( dnCR    );
//  InjectToDB( dnJVDet );
  InjectToDB( dnFixedAsset);
  InjectToDB( dnIADet );
  InjectToDB( dnJC    );
  InjectToDB( dnJCDet );

  GenerateScriptForVP;
  InjectToDB( fnAPCheque );
  GenerateScriptForCR;
  InjectToDB( fnARPayment );

  GenerateScriptForSIDet;
  InjectToDB( dnSIDet );

  GenerateScriptForJVDet;
  InjectToDB( dnJVDet );
end;

procedure TDeptExistInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := 'Dept Must Exist';
end;

end.
