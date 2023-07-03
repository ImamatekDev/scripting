unit SOApprovalOverlimitInjector;

interface
uses Injector, sysutils, ScriptConst, BankConst;

type
  TSOApprovalOverlimitInjector = class(TInjector)
  private
    procedure GenerateScriptForSO;
    procedure SONeedApproval;
    procedure AddConstant;
    procedure GenerateScriptForChooseForm;
    procedure GenerateSOList;
    procedure GenerateMain;
    procedure MainCreateMenuSetting;
    procedure SOsApproval;
    procedure SOsCreateCheckBoxNeedApproval(Filter: String);
    procedure SOsShowFrmPreview;
    procedure GenerateDO;
    procedure GenerateSI;
  protected
    procedure ValidateSOOverDue (SalesDate : string); virtual;
    procedure ShouldByPassValidation; virtual;
    procedure set_scripting_parameterize; override;
  public
    procedure GenerateScript; override;
  end;

implementation
uses Classes;
{ TSOApprovalOverlimitInjector }

procedure TSOApprovalOverlimitInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := SCRIPTING_SO_OVERLIMIT_APPROVAL;
end;

procedure TSOApprovalOverlimitInjector.AddConstant;
begin
  Script.Add := 'Const';
  Script.Add := '    PARAM_OPT_ALLOWED_OVERDUE_SI=''ALLOW_OVER_DUE_SI''; ';
  Script.Add := 'var ';
  Script.Add := '    SO_RECEIVE_FIELD    : String; ';
  Script.Add := '    SO_MOBILE_FIELD     : String; ';
  Script.Add := '    NEED_APPROVAL_FIELD : String; ';
  Script.Add := '    APPROVED_FIELD      : String; ';
  Script.Add := '    USE_CBD             : Boolean; ';
  Script.Add := '    CBD_FIELD           : String; ';
  Script.Add := '    INCLUDE_OVERDUE     : Boolean; ';

  Script.Add := '';
  Script.Add := 'procedure InitializeFieldName; ';
  Script.Add := 'begin ';
  Script.Add := '  SO_RECEIVE_FIELD    := ReadOption(''SO_RECEIVE_FIELD'', ''CUSTOMFIELD19'');';
  Script.Add := '  SO_MOBILE_FIELD     := ReadOption(''SO_MOBILE_FIELD'', ''CUSTOMFIELD20'');';
  Script.Add := '  NEED_APPROVAL_FIELD := ReadOption(''NEED_APPROVAL_FIELD''); ';
  Script.Add := '  APPROVED_FIELD      := ReadOption(''APPROVED_FIELD''); ';
  Script.Add := '  USE_CBD             := ReadOption(''USE_CBD'') = ''1''; ';
  Script.Add := '  CBD_FIELD           := ReadOption(''CBD_FIELD''); ';
  Script.Add := '  INCLUDE_OVERDUE     := ReadOption(''INCLUDE_OVERDUE'', ''0'') = ''1''; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TSOApprovalOverlimitInjector.SONeedApproval;
begin

  Script.Add := 'procedure BtnNeedApprovalClick;                                                             ';
  Script.Add := '  procedure MakeSureInEditMode;                                                             ';
  Script.Add := '  begin                                                                                     ';
  Script.Add := '    if not (Master.State in [2, 3]) then                                                    ';
  Script.Add := '      Master.Edit;                                                                          ';
  Script.Add := '  end;                                                                                      ';
  Script.Add := 'begin                                                                                       ';
  Script.Add := '  DataModule.EmptyOnCustomerLimitError;                                                     ';
  Script.Add := '  MakeSureInEditMode;                                                                       ';
  Script.Add := '  Master.ExtendedID.FieldLookup.FieldByName(APPROVED_FIELD).AsString := ''0'';   ';
  Script.Add := '  Master.ExtendedID.FieldLookup.FieldByName(NEED_APPROVAL_FIELD).AsString := ''1'';   ';
  Script.Add := '  if INCLUDE_OVERDUE then begin';
  Script.Add := '    WriteOption( PARAM_OPT_ALLOWED_OVERDUE_SI, ''1''); ';
  Script.Add := '  end; ';
  Script.Add := '  ShowMessage(''This order has been marked as need to be approved!'');                  ';
  Script.Add := 'end;                                                                                        ';
  Script.Add := '';
  Script.Add := 'procedure Create_BtnNeedApproval;';
  Script.Add := 'var ';
  Script.Add := '  BtnNeedApproval : TButton; ';
  Script.Add := '  topPos : integer; ';
  Script.Add := 'begin                            ';
  Script.Add := '  BtnNeedApproval := CreateBtn(0, Form.pnljbRightTop.Height-20, Form.pnljbRightTop.Width, 20, 0, ''Need Approval'', Form.pnljbRightTop);';
  Script.Add := '  topPos := StrToInt(ReadOption(''APPROVE_BTN_TOP'', ''-1''));';
  Script.Add := '  if (topPos<>-1) then begin';
  Script.Add := '    BtnNeedApproval.Top := topPos;'; // AA, BZ 3100
  Script.Add := '  end;';
  Script.Add := '  BtnNeedApproval.OnClick := @BtnNeedApprovalClick; ';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'function IsCBD:Boolean; ';
  Script.Add := 'begin ';
  Script.Add := '  result := false; ';
  Script.Add := '  if not USE_CBD then exit; ';
  Script.Add := '  result := Master.ExtendedID.FieldLookup.FieldByName(CBD_FIELD).asString = ''1''; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'function IsTopChanged:Boolean; ';
  Script.Add := 'var sql:TjbSQL; ';
  Script.Add := 'begin ';
  Script.Add := '  sql := CreateSQL(TIBTransaction(Tx)); ';
  Script.Add := '  try ';
  Script.Add := '    RunSQL(sql, format(''select c.TERMSID from persondata c where c.ID=%d'', [Master.CustomerID.value])); ';
  Script.Add := '    result := (sql.FieldByName(''TermsID'') <> Master.Terms.value); ';
  Script.Add := '  finally';
  Script.Add := '    sql.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure MasterBeforePost; ';
  Script.Add := 'begin ';
  Script.Add := '  if Master.IsFirstPost then exit; ';
  Script.Add := '  if IsCBD or IsTOPChanged then begin ';
  Script.Add := '    Master.ExtendedID.FieldLookup.FieldByName(NEED_APPROVAL_FIELD).AsString := ''1'';   ';
  Script.Add := '    Master.ExtendedID.FieldLookup.FieldByName(APPROVED_FIELD).AsString := ''0'';   ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure MasterAfterClose; ';
  Script.Add := 'begin ';
  Script.Add := '  if INCLUDE_OVERDUE then begin';
  Script.Add := '    WriteOption( PARAM_OPT_ALLOWED_OVERDUE_SI, ''0''); ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TSOApprovalOverlimitInjector.ValidateSOOverDue (SalesDate : string);
begin
  MasterExtended;

  Script.Add := EmptyStr;
  Script.Add := 'procedure ValidateSOOverDue;';
  Script.Add := 'var';
  Script.Add := '  overSQL : TjbSQL;';
  Script.Add := 'const';
  Script.Add := '  UNLIMITED_NUMBER = 1000000;';

  Script.Add := EmptyStr;
  Script.Add := '  function isSalesApproved : Boolean;';
  Script.Add := '  begin';
  Script.Add := '    Result := MasterExtended(NEED_APPROVAL_FIELD).AsBoolean;';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  function GetCustomerID : Integer;';
  Script.Add := '  begin';
  Script.Add := '    result := Master.CustomerID.AsInteger;';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  function GetDueSIFirstQuery : string;';
  Script.Add := '  begin';
  Script.Add := '    Result := Format (''SELECT COUNT (AI.ARINVOICEID) ARINVDUECOUNTER FROM ARINV AI '+
                               'LEFT JOIN ARINVPMT AIP ON AIP.ARINVOICEID = AI.ARINVOICEID '+
                               'LEFT JOIN ARPMT AP ON AP.PAYMENTID = AIP.PAYMENTID '+
                               'LEFT JOIN TERMOPMT T ON T.TERMID = AI.TERMSID '+
                               'WHERE AI.CUSTOMERID = %d AND AI.DELIVERYORDER = ''''0'''' '+
                               'AND AI.INVFROMSR = ''''0'''' AND ( AI.OWING > 0 OR (AP.CHEQUE = 1 '+
                               'AND AP.CLEARANCEDATE IS NULL) ) '+
                               'AND ( (AI.INVOICEDATE + T.NETDAYS) <= CAST (''''%s'''' AS DATE) ) '' '+
                               ', [GetCustomerID, DateToStrSQL(Date)]);';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  function GetDueSIAfterTransactionDate : Integer;';
  Script.Add := '  begin';
  Script.Add := '    RunSQL (overSQL, GetDueSIFirstQuery + Format('' AND AI.INVOICEDATE > ''''%s'''' '' '+
                     ', [DateToStrSQL (Master.' + SalesDate + '.AsDateTime)]) );';
  Script.Add := '    result := overSQL.FieldByName (''ARINVDUECOUNTER'');';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  function GetDueSI : Integer;';
  Script.Add := '  begin';
  Script.Add := '    RunSQL (overSQL, GetDueSIFirstQuery + Format('' AND AI.INVOICEDATE <= ''''%s'''' '' '+
                     ', [DateToStrSQL (Date)]) );';
  Script.Add := '    result := overSQL.FieldByName (''ARINVDUECOUNTER'');';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  function GetDueSILimit : Integer;';
  Script.Add := '  begin';
  Script.Add := '    RunSQL (overSQL, Format (''SELECT COALESCE(PD.OVERDUESILIMIT, %d) OVERDUESILIMIT '+
                     'FROM PERSONDATA PD WHERE PD.ID = %d'' '+
                     ', [UNLIMITED_NUMBER, GetCustomerID]) );';
  Script.Add := '    result := overSQL.FieldByName (''OVERDUESILIMIT'');';
  Script.Add := '  end;';

  Script.Add := EmptyStr;
  Script.Add := '  function isOverSIDue : Boolean;';
  Script.Add := '  begin';
  Script.Add := '    if (GetDueSILimit > -1) AND (GetDueSI > 0) then begin';
  Script.Add := '      result := (GetDueSILimit <= (GetDueSI - GetDueSIAfterTransactionDate) );';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := 'begin';
  Script.Add := '  overSQL := CreateSQL (TIBTransaction(Tx) );';
  Script.Add := '  try';
  Script.Add := '    if isOverSIDue AND NOT isSalesApproved then begin';
//  Script.Add := '      RaiseException(''Customer already have max allowed over due sales invoice..'');';
  Script.Add := '      Detail.Cancel;';
  Script.Add := '      ShowMessage(''Customer already have max allowed over due sales invoice..'');';  //SCY BZ 3899
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    overSQL.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
end;

procedure TSOApprovalOverlimitInjector.GenerateScriptForSO;
begin
  ClearScript;
  CreateButton;
  ReadOption;
  WriteOption;
  AddConstant;
  SONeedApproval;
  CheckCreditLimit('InvAmount', 'SO', 'SOID', 'SODate', 'Tax1Amount', 'Tax2Amount');
  ValidateSOOverDue ('SODate');

  Script.Add := 'begin';
  Script.Add := '  InitializeFieldName; ';
  Script.Add := '  Create_BtnNeedApproval;';
  Script.Add := '  Master.OnBeforePostValidationArray := @MasterBeforePost; ';
  Script.Add := '  Master.OnBeforePostValidationArray := @DoCheckCreditLimit; ';
  Script.Add := '  Master.OnAfterCloseArray := @MasterAfterClose; ';
  Script.Add := '  Detail.OnBeforePostValidationArray := @ValidateSOOverDue;';
  Script.Add := 'end.';
end;

procedure TSOApprovalOverlimitInjector.GenerateScriptForChooseForm;
begin
  ClearScript;
  AddConstant;
  ReadOption;
  Script.Add := 'procedure DoAssignSOSQL;';
  Script.Add := 'begin';
  Script.Add := '  with TfrmChooseInvoice(Form).sqlSearch do begin';
  Script.Add := '    sql.Clear;';
  Script.Add := '    sql.Add(''Select Distinct m.SONO, m.SODate, m.PONO, m.Description, m.Terms '');';
  Script.Add := '    sql.Add(''FROM SODET s'');';
  Script.Add := '    sql.Add(''inner join SO m on s.SOID=m.SOID'');';
  Script.Add := '    sql.Add(''left outer join item i on s.ItemNo = i.ItemNo'');';
  Script.Add := '    sql.Add(''left outer join Extended e on e.extendedID=m.ExtendedID'');';
  Script.Add := '    sql.Add(''WHERE (s.Closed=0 and m.Proceed=0)'');';
  Script.Add := '    sql.Add(''AND i.Suspended = 0 and m.CustomerID=:CustomerID'');';
  Script.Add := '    sql.Add(format(''AND (e.%s<>''''1'''' or (e.%s is null))'', [NEED_APPROVAL_FIELD, NEED_APPROVAL_FIELD]));';
  Script.Add := '    sql.Add(format(''AND ( (e.%s = ''''1'''' and e.%s = ''''1'''') '+
                     'or (e.%s is null) or (e.%s = ''''0'''') ) '' '+
                     ', [SO_RECEIVE_FIELD, SO_MOBILE_FIELD, SO_MOBILE_FIELD, SO_MOBILE_FIELD]) );';  //SCY BZ 2988
  Script.Add := '    sql.Add(''order by m.SONo'');';
  Script.Add := '    SetParam(0, TFrmChooseInvoice(Form).PersonID);';
  Script.Add := '    ExecQuery;';
  Script.Add := '  end;';
  Script.Add := 'end;';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  InitializeFieldName;';
  Script.Add := '  TfrmChooseInvoice(Form).OnAssignSOSQL := @DoAssignSOSQL;';
  Script.Add := 'end.';
end;

procedure TSOApprovalOverlimitInjector.SOsCreateCheckBoxNeedApproval(Filter:String);
begin

  Script.Add := 'procedure OnCheckNeedApprovalClick(sender:TObject); ';
  Script.Add := '  function sqlFilter: String;';
  Script.Add := '  begin';
  Script.Add := '    result := format('' and (((select e.%s from Extended e where e.ExtendedID=a.ExtendedID) = 1) '', [NEED_APPROVAL_FIELD]) +'; //Need Approval
  Script.Add := '              format('' and ((select coalesce(e1.%s, 0) from Extended e1 where e1.ExtendedID=a.ExtendedID) <> 1))'', [APPROVED_FIELD]); '; //Belum di-Approve

  Script.Add := '  end;';
  Script.Add := '';
  Script.Add := 'begin ';
  Script.Add := format('  %s;', [Filter]);
  Script.Add := '  if TCheckBox(sender).Checked then begin ';
  Script.Add := '    if Pos(sqlFilter, Datamodule.tabelSO.SelectSQL[2]) = 0 then begin';
  Script.Add := '      Datamodule.tabelSO.SelectSQL[2] := DataModule.tabelSO.SelectSQL[2] + sqlFilter;';
  Script.Add := '      DataModule.tabelSO.Close; ';
  Script.Add := '      DataModule.tabelSO.Open;  ';
  Script.Add := '    end;';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := EmptyStr;
  Script.Add := 'procedure CreateCheckBoxNeedApproval; ';
  Script.Add := 'begin';
  Script.Add := '  TPanel(Form.cboxQueue.Parent).Height := TPanel(Form.cboxQueue.Parent).Height + 30; ';
  Script.Add := '  with CreateCheckBox(Form.cboxQueue.Left, Form.cboxQueue.Top + Form.cboxQueue.Height, Form.cboxQueue.Width, Form.cboxQueue.Height, ''Over Limit'', Form.cboxQueue.Parent) do begin';
  Script.Add := '    name := ''checkOverLimit'';';
  Script.Add := '    OnClick := @OnCheckNeedApprovalClick;';
  Script.Add := '  end;';
  Script.Add := 'end; ';
  Script.Add := EmptyStr;
end;

procedure TSOApprovalOverlimitInjector.SOsShowFrmPreview;
begin
  Script.Add := 'procedure ShowFrmPreview(SOID, UserID : Integer);                    ';
  Script.Add := '  procedure Prepare_Data;                                            ';
  Script.Add := '  begin                                                              ';
  Script.Add := '    qrySO     := CreateSQL(TIBTransaction(Tx));                                        ';
  Script.Add := '    qrySODet  := CreateQuery(TIBTransaction(Tx));                                        ';
  Script.Add := '    qryCustSO := CreateSQL(TIBTransaction(Tx));                                        ';
  Script.Add := '    qryUpdate := CreateSQL(TIBTransaction(Tx));                                        ';
  Script.Add := '    RunSQL(qrySO,     format(''Select * from SO where SOID=%d'', [SOID])); ';
  Script.Add := '    RunQuery(qrySODet,  format(''Select ItemNo, ItemOvDesc, Quantity, UnitPrice, DiscPC, TaxCodes from SODET where SOID=%d'', [SOID]));';
  Script.Add := '    RunSQL(qryCustSO, format(''Select PersonNo, Name, coalesce(CreditLimit,0) CreditLimit from PersonData where ID=%d'', [qrySO.FieldByName(''CustomerID'')])); ';
  Script.Add := '    DataSource            := TDataSource.Create(FrmPreview);                ';
  Script.Add := '    DataSource.Dataset    := qrySODet;                               ';
  Script.Add := '    ATx                   := CreateATx;                              ';
  Script.Add := '    qryUpdate.Transaction := ATx;                                    ';
  Script.Add := '  end;                                                               ';
  Script.Add := EmptyStr;
  Script.Add := '  procedure SetFrmPreviewProperties;                                 ';
  Script.Add := '  begin                                                              ';
  Script.Add := '    FrmPreview.Caption     := ''Preview SO Approval Request'';   ';
  Script.Add := '    FrmPreview.Width       := 800;                                   ';
  Script.Add := '    FrmPreview.Height      := 400;                                   ';
  Script.Add := '    FrmPreview.Position    := 7;                                     ';
  Script.Add := '    FrmPreview.BorderStyle := bsSingle;                              ';
  Script.Add := '    FrmPreview.BorderIcons := FrmPreview.BorderIcons  - biMaximize - biMinimize; ';
  Script.Add := '    FrmPreview.OnClose     := @FrmPreviewClose;                      ';
  Script.Add := '  end;                                                               ';
  Script.Add := EmptyStr;
  Script.Add := '  procedure FrmPreviewClose(Sender : TObject; var Action : TCloseAction); ';
  Script.Add := '  begin                                                              ';
  Script.Add := '    qryUpdate.Free;                                                  ';
  Script.Add := '    atx.Free;                                                        ';
  Script.Add := '    qryCustSO.Free;                                                  ';
  Script.Add := '    qrySODet.Free;                                                   ';
  Script.Add := '    qrySO.Free;                                                      ';
  Script.Add := '    Action := caFree;                                                ';
  Script.Add := '  end;                                                               ';
  Script.Add := EmptyStr;
  Script.Add := '  procedure Decorate_FrmPreview;                                     ';
  Script.Add := '  begin                                                              ';
  Script.Add := '    Create_BtnApprove;                                               ';
  Script.Add := '    Create_BtnReject;                                                ';
  Script.Add := '    Create_BtnViewAR;                                                ';
  Script.Add := '    Create_BtnClose;                                                 ';
  Script.Add := '    LblSONO             := CreateLabel(5, 5, 80, 20, ''SO No.:'', FrmPreview);                                 ';
  Script.Add := '    LblSONOValue        := CreateLabel(LblSONO.Left + LblSONO.Width + 2, 5, 80, 20, '''', FrmPreview);         ';
  Script.Add := '    LblCustName         := CreateLabel(5, 25, 80, 20, ''Customer:'', FrmPreview);                              ';
  Script.Add := '    LblCustNameValue    := CreateLabel(LblCustName.Left + LblCustName.Width + 2, 25, 80, 20, '''', FrmPreview);';
  Script.Add := '    LblTotalAmount      := CreateLabel(640, 260, 80, 20, ''Total Amount:'', FrmPreview);                       ';
  Script.Add := '    LblTotalAmountValue := CreateLabel(640, 275, 80, 20, '''', FrmPreview);                                    ';
  Script.Add := '    LblCreditLimit      := CreateLabel(640, 290, 80, 20, ''Customer''''s Credit Limit:'', FrmPreview);     ';
  Script.Add := '    LblCreditLimitValue := CreateLabel(640, 305, 80, 20, '''', FrmPreview);                                    ';
  Script.Add := '    LblOverLimit        := CreateLabel(640, 320, 80, 20, ''Over Limit:'', FrmPreview);                         ';
  Script.Add := '    LblOverLimitValue   := CreateLabel(640, 335, 80, 20, '''', FrmPreview);                                    ';
  Script.Add := '    Create_DBGrid;                                                                                                 ';
  Script.Add := '  end;                                                                                                             ';
  Script.Add := EmptyStr;
  Script.Add := '  procedure Create_BtnApprove;                                                                                     ';
  Script.Add := '  begin                                                                                                            ';
  Script.Add := '    BtnApprove := CreateBtn(10, 320, 100, 40, 0, ''Approve'', FrmPreview);                                     ';
  Script.Add := '    BtnApprove.OnClick := @Approve_Current_SO;                                                                     ';
  Script.Add := '  end;                                                                                                             ';
  Script.Add := EmptyStr;
  Script.Add := '  procedure Create_BtnReject;                                                                                      ';
  Script.Add := '  begin                                                                                                            ';
  Script.Add := '    BtnReject := CreateBtn(BtnApprove.Left+BtnApprove.Width+20, BtnApprove.Top, 100, 40, 0, ''Reject'', FrmPreview);';
  Script.Add := '    BtnReject.OnClick := @Close_Current_SO;                                                                        ';
  Script.Add := '  end;                                                                                                             ';
  Script.Add := EmptyStr;
  Script.Add := '  procedure Create_BtnViewAR;                                                                                      ';
  Script.Add := '  begin                                                                                                            ';
  Script.Add := '    BtnViewAR := CreateBtn(BtnReject.Left+BtnReject.Width+20, BtnApprove.Top, 100, 40, 0, ''View AR'', FrmPreview); ';
  Script.Add := '    BtnViewAR.OnClick := @BtnViewARClick;                                                                          ';
  Script.Add := '  end;                                                                                                             ';
  Script.Add := EmptyStr;
  Script.Add := '  procedure Create_BtnClose;                                                                                       ';
  Script.Add := '  begin                                                                                                            ';
  Script.Add := '    BtnClose := CreateBtn(BtnViewAR.Left+BtnReject.Width+20, BtnViewAR.Top, 100, 40, 0, ''Close'', FrmPreview);';
  Script.Add := '    BtnClose.OnClick := @BtnCloseClick;                                                                            ';
  Script.Add := '  end;                                                                                                             ';
  Script.Add := EmptyStr;
  Script.Add := '  procedure BtnCloseClick;                                                                                         ';
  Script.Add := '  begin                                                                                                            ';
  Script.Add := '    FrmPreview.Close;                                                                                              ';
  Script.Add := '  end;                                                                                                             ';
  Script.Add := EmptyStr;
  Script.Add := '  procedure BtnViewARClick;                                                                                        ';
  Script.Add := '  begin                                                                                                            ';
  Script.Add := '    Form.Show_OutstandingInv_CustomerNo(qrySO.FieldByName(''CustomerID''));                          ';
  Script.Add := '  end;                                                                                                             ';
  Script.Add := EmptyStr;
  Script.Add := '  procedure Approve_Current_SO;                                                                                    ';
  Script.Add := '  begin                                                                                                            ';
  Script.Add := '    if not ATx.Active then ATx.StartTransaction; ';
  Script.Add := '    RunSQL(qryUpdate, format(''update Extended set %s = 0, %s = 1 where ExtendedID = (Select ExtendedID from SO where SOID=%d)'', '+
    '[NEED_APPROVAL_FIELD, APPROVED_FIELD, SOID]));';
  Script.Add := '    Atx.Commit; ';
  Script.Add := '    ShowMessage(''Order Approved!'');                                                                          ';
  Script.Add := '    Form.SetFilterAndRun;                                                                                          ';
  Script.Add := '    FrmPreview.Close;                                                                                            ';
  Script.Add := '  end;                                                                                                             ';
  Script.Add := EmptyStr;
  Script.Add := '  procedure Close_Current_SO;                                                                                      ';
  Script.Add := '  var                                                                                                              ';
  Script.Add := '    FrmReason : TForm;                                                                                             ';
  Script.Add := '    BtnOK, BtnClose : TButton;                                                                                     ';
  Script.Add := '    edtReason : TEdit;                                                                                             ';
  Script.Add := EmptyStr;
  Script.Add := '    procedure SetFrmReasonProperties;                                                                              ';
  Script.Add := '    begin                                                                                                          ';
  Script.Add := '      FrmReason.Caption     := ''Please fill reason of rejection'';                                            ';
  Script.Add := '      FrmReason.Width       := 600;                                                                                ';
  Script.Add := '      FrmReason.Height      := 120;                                                                                ';
  Script.Add := '      FrmReason.Position    := 7;                                                                                  ';
  Script.Add := '      FrmReason.BorderStyle := bsSingle;                                                                           ';
  Script.Add := '      FrmReason.BorderIcons := FrmReason.BorderIcons - biSystemMenu - biMaximize - biMinimize;                     ';
  Script.Add := '    end;                                                                                                           ';
  Script.Add := EmptyStr;
  Script.Add := '    procedure DecorateFrmReason;                                                                                   ';
  Script.Add := '    begin                                                                                                          ';
  Script.Add := '      Create_edtReason;                                                                                            ';
  Script.Add := '      Create_BtnOK;                                                                                                ';
  Script.Add := '      Create_BtnClose;                                                                                             ';
  Script.Add := '    end;                                                                                                           ';
  Script.Add := EmptyStr;
  Script.Add := '    procedure Create_BtnOK;                                                                                        ';
  Script.Add := '    begin                                                                                                          ';
  Script.Add := '      BtnOK := CreateBtn(3, 40, 80, 40, 0, ''OK'', FrmReason);                                                 ';
  Script.Add := '      BtnOK.OnClick := @OKRejectClick;                                                                             ';
  Script.Add := '    end;                                                                                                           ';
  Script.Add := EmptyStr;
  Script.Add := '    procedure Create_BtnClose;                                                                                     ';
  Script.Add := '    begin                                                                                                          ';
  Script.Add := '      BtnClose := CreateBtn(100, 40, 80, 40, 0, ''Close'', FrmReason);                                         ';
  Script.Add := '      BtnClose.OnClick := @CloseRejectClick;                                                                       ';
  Script.Add := '    end;                                                                                                           ';
  Script.Add := EmptyStr;
  Script.Add := '    procedure Create_edtReason;                                                                                    ';
  Script.Add := '    begin                                                                                                          ';
  Script.Add := '      edtReason := TEdit.Create(FrmReason);                                                                        ';
  Script.Add := '      edtReason.Parent := FrmReason;                                                                               ';
  Script.Add := '      edtReason.SetBounds(3, 10, 580, 40);                                                                         ';
  Script.Add := '      edtReason.MaxLength := 100;                                                                                  ';
  Script.Add := '    end;                                                                                                           ';
  Script.Add := EmptyStr;
  Script.Add := '    procedure OKRejectClick;                                                                                       ';
  Script.Add := '      function New_Description:String;                                                                   ';
  Script.Add := '      begin                                                                                                        ';
  Script.Add := '        if (qrySO.FieldByName(''Description'') = null) or (Trim(qrySO.FieldByName(''Description'')) = '''') then ';
  Script.Add := '          result := edtReason.Text ';
  Script.Add := '          else result := qrySO.FieldByName(''Description'') + #13 + edtReason.Text; ';
  Script.Add := '      end; ';
  Script.Add := '    begin  ';
  Script.Add := '      if (Trim(edtReason.Text) = '''') then RaiseException(''Please fill the reason first!'');             ';
  Script.Add := '      if not ATx.Active then ATx.StartTransaction; ';
  Script.Add := '      RunSQL(qryUpdate, format(''update SODET set Closed = 1 where SOID=%d'', [SOID]));                     ';
  Script.Add := '      RunSQL(qryUpdate, format(''update SO set Closed = 1, Description = ''''%s'''' where SOID=%d'', [new_description, SOID])); ';
  Script.Add := '      ATx.Commit;';
  Script.Add := '      ShowMessage(''Order Closed!'');                                                                          ';
  Script.Add := '      Form.SetFilterAndRun;                                                                                        ';
  Script.Add := '      FrmReason.Close;                                                                                             ';
  Script.Add := '      FrmPreview.Close;                                                                                            ';
  Script.Add := '    end;                                                                                                           ';
  Script.Add := EmptyStr;
  Script.Add := '    procedure CloseRejectClick;                                                                                    ';
  Script.Add := '    begin                                                                                                          ';
  Script.Add := '      FrmReason.Close;                                                                                             ';
  Script.Add := '    end;                                                                                                           ';
  Script.Add := '  begin                                                                                                            ';
  Script.Add := '    FrmReason := TForm.Create(FrmPreview);                                                                         ';
  Script.Add := '    SetFrmReasonProperties;                                                                                        ';
  Script.Add := '    DecorateFrmReason;                                                                                             ';
  Script.Add := '    FrmReason.ShowModal;                                                                                           ';
  Script.Add := '  end;                                                                                                             ';
  Script.Add := EmptyStr;
  Script.Add := '  procedure Create_DBGrid;                                                                                         ';
  Script.Add := '  begin                                                                                                            ';
  Script.Add := '    DBGrid := TDBGrid.Create(FrmPreview);                                                                          ';
  Script.Add := '    DBGrid.Parent := FrmPreview;                                                                                   ';
  Script.Add := '    DBGrid.SetBounds(10, 60, 700, 200);                                                                            ';
  Script.Add := '    DBGrid.ReadOnly := true;                                                                                       ';
  Script.Add := '    DBGrid.DataSource := DataSource;                                                                               ';
  Script.Add := '    DBGrid.Columns[0].Title.Caption := ''Item No.'';                                                           ';
  Script.Add := '    DBGrid.Columns[1].Title.Caption := ''Description'';                                                        ';
  Script.Add := '    DBGrid.Columns[2].Title.Caption := ''Qty'';                                                                ';
  Script.Add := '    DBGrid.Columns[3].Title.Caption := ''Unit Price'';                                                         ';
  Script.Add := '    DBGrid.Columns[4].Title.Caption := ''Discount'';                                                           ';
  Script.Add := '    DBGrid.Columns[5].Title.Caption := ''Tax'';                                                                ';
  Script.Add := '    DBGrid.Columns[0].Width := 80;                                                                                 ';
  Script.Add := '    DBGrid.Columns[1].Width := 160;                                                                                ';
  Script.Add := '    DBGrid.Columns[2].Width := 40;                                                                                 ';
  Script.Add := '    DBGrid.Columns[3].Width := 100;                                                                                ';
  Script.Add := '    DBGrid.Columns[4].Width := 80;                                                                                 ';
  Script.Add := '    DBGrid.Columns[5].Width := 40;                                                                                 ';
  Script.Add := '  end;                                                                                                             ';
  Script.Add := EmptyStr;
  Script.Add := '  procedure Fill_Data;                                                                                             ';
  Script.Add := '    procedure Fill_OverLimit;                                                                                      ';
  Script.Add := '    var                                                                                                            ';
  Script.Add := '      qry : TjbSQL;                                                                                   ';
  Script.Add := '    begin                                                                                                          ';
  Script.Add := '      qry := CreateSQL(TIBTransaction(Tx));                                                                             ';
  Script.Add := '      try                                                                                                          ';
  Script.Add := '        RunSQL(qry, format(''select amount from get_personbalance(%d, CURRENT_DATE, CURRENT_DATE)'', [qrySO.FieldByName(''CustomerID'')]));';
  Script.Add := '        LblOverlimitValue.Caption := FormatFloat(''#,##0.##;(#,##0.##)'', (qry.FieldByName(''Amount'') + DataModule.tabelSO.FieldByName(''InvoiceAmount'').Value - qryCustSO.FieldByName(''CreditLimit'')));';
  Script.Add := '      finally                                                                                                      ';
  Script.Add := '        qry.Free;                                                                                     ';
  Script.Add := '      end;                                                                                                         ';
  Script.Add := '    end;                                                                                                           ';
  Script.Add := '  begin                                                                                                            ';
  Script.Add := '    LblSONOValue.Caption        := qrySO.FieldByName(''SONO'');                                       ';
  Script.Add := '    LblCustNameValue.Caption    := qryCustSO.FieldByName(''Name'');                                   ';
  Script.Add := '    LblTotalAmountValue.Caption := FormatFloat(''#,##0.##;(#,##0.##)'', DataModule.tabelSO.FieldByName(''InvoiceAmount'').Value);  ';
  Script.Add := '    LblCreditLimitValue.Caption := FormatFloat(''#,##0.##;(#,##0.##)'', qryCustSO.FieldByName(''CreditLimit''));';
  Script.Add := '    Fill_OverLimit;                                                                                                 ';
  Script.Add := '  end;                                                                                                             ';
  Script.Add := 'begin                                                                                                              ';
  Script.Add := '  FrmPreview := TForm.Create(Form); ';
  Script.Add := '  Prepare_Data; ';
  Script.Add := '  SetFrmPreviewProperties; ';
  Script.Add := '  Decorate_FrmPreview;     ';
  Script.Add := '  Fill_Data;             ';
  Script.Add := '  FrmPreview.ShowModal;    ';
  Script.Add := 'end;                                                                                                               ';
  Script.Add := EmptyStr;
end;

procedure TSOApprovalOverlimitInjector.SOsApproval;
  procedure SOsConstAndVar;
  begin
    Script.Add := 'const                                            ';
    Script.Add := '  STR_PROCEED = ''Terproses'';               ';
    Script.Add := '  STR_CLOSED  = ''Ditutup'';                 ';
    Script.Add := '  STR_QUE     = ''Mengantri'';               ';
    Script.Add := '  STR_WAIT    = ''Menunggu'';                ';
    Script.Add := EmptyStr;
    Script.Add := 'var                                              ';
    Script.Add := '  BtnPreview, BtnApprove, BtnReject, BtnViewAR, BtnClose : TButton;                         ';
    Script.Add := '  LblSONO, LblSONOValue, LblCustName, LblCustNameValue, LblTotalAmount, LblTotalAmountValue,';
    Script.Add := '  LblCreditLimit, LblCreditLimitValue, LblOverLimit, LblOverLimitValue : TLabel;            ';
    Script.Add := '  FrmPreview, FrmExpired : TForm;                                                           ';
    Script.Add := '  qrySO, qryCustSO, qryUpdate : TjbSQL;                                         ';
    Script.Add := '  qrySODet   : TIBQuery; ';
    Script.Add := '  DBGrid     : TDBGrid;                                                                     ';
    Script.Add := '  DataSource : TDataSource;                                                                 ';
    Script.Add := '  ATx        : TIBTransaction;                                                              ';
    Script.Add := EmptyStr;
  end;

  procedure SOsCreate_BtnPreview;
  begin
    Script.Add := 'function SOIsOutstanding:Boolean; ';
    Script.Add := 'begin ';
    Script.Add := '  result := (DataModule.tabelSO.FieldByName(''STATUSORDER'').Value = 2) or (DataModule.tabelSO.FieldByName(''STATUSORDER'').Value = 3); ';
    Script.Add := 'end; ';
    Script.Add := '';
    Script.Add := 'procedure BtnPreviewClick;                                                                                     ';
    Script.Add := 'begin                                                                                                          ';
    Script.Add := '  if Is_NeedApproval(DataModule.TabelSo.FieldByName(''SOID'').AsInteger) and SOIsOutstanding then begin    ';
    Script.Add := '    ShowFrmPreview(DataModule.TabelSo.FieldByName(''SOID'').AsInteger, UserID);                                                    ';
    Script.Add := '  end;                                                                                                         ';
    Script.Add := 'end;                                                                                                           ';
    Script.Add := '';
    Script.Add := 'procedure Create_BtnPreview;                                                               ';
    Script.Add := 'begin                                                                                      ';
    Script.Add := '  BtnPreview := CreateBtn(2, 300, 150, 21, 0, ''Preview Approval Request'', Form.AFilterBox); ';
    Script.Add := '  BtnPreview.OnClick := @BtnPreviewClick;                                                  ';
    Script.Add := 'end;                                                                                       ';
    Script.Add := EmptyStr;
  end;

  procedure IsNeedApproval;
  begin
    Script.Add := 'function Is_NeedApproval(SOID:Integer):Boolean; ';
    Script.Add := 'var sql : TjbSQL;                 ';
    Script.Add := 'begin                                           ';
    Script.Add := '  result := false;                              ';
    Script.Add := '  sql := CreateSQL(TIBTransaction(Tx));               ';
    Script.Add := '  try                                           ';
    Script.Add := '    RunSQL(sql, format(''select %s, %s from Extended where ExtendedID = (Select ExtendedID from SO where SOID=%d)'', '+
      '[NEED_APPROVAL_FIELD, APPROVED_FIELD, SOID]));';
    Script.Add := '    result := (sql.FieldByName(NEED_APPROVAL_FIELD) = ''1'') and (sql.FieldByName(APPROVED_FIELD) <> ''1'');';
    Script.Add := '  finally                                       ';
    Script.Add := '    sql.Free;                       ';
    Script.Add := '  end;                                          ';
    Script.Add := 'end;                                            ';
    Script.Add := EmptyStr;
  end;

  Procedure CalcField;
  begin
    Script.Add := 'procedure tblSOCalcFields;                                         ';
    Script.Add := 'begin                                                              ';
    Script.Add := '  if DataModule.tabelSO.FieldByName(''STATUSORDER'').Value = 0 then begin              ';
    Script.Add := '    DataModule.tabelSO.FieldByName(''Status'').Value := STR_PROCEED                    ';
    Script.Add := '  end                                                              ';
    Script.Add := '  else if DataModule.tabelSO.FieldByName(''STATUSORDER'').Value = 1 then begin         ';
    Script.Add := '    DataModule.tabelSO.FieldByName(''Status'').Value := STR_CLOSED                     ';
    Script.Add := '  end                                                              ';
    Script.Add := '  else if Is_NeedApproval(DataModule.TabelSo.FieldByName(''SOID'').AsInteger) then begin  ';
    Script.Add := '    DataModule.tabelSO.FieldByName(''Status'').Value := ''Over Limit'';';
    Script.Add := '  end ';
    Script.Add := '  else begin ';
    Script.Add := '    if DataModule.tabelSO.FieldByName(''STATUSORDER'').Value = 2 then begin         ';
    Script.Add := '      DataModule.tabelSO.FieldByName(''Status'').Value := STR_QUE;';
    Script.Add := '    end ';
    Script.Add := '    else if DataModule.tabelSO.FieldByName(''STATUSORDER'').Value = 3 then begin         ';
    Script.Add := '      DataModule.tabelSO.FieldByName(''Status'').Value := STR_WAIT;';
    Script.Add := '    end;';
    Script.Add := '  end;';
    Script.Add := 'end;  ';
    Script.Add := '';
  end;

  procedure IsApproval;
  begin
    Script.Add := 'function IsApproval:Boolean; ';
    Script.Add := 'var sql:TjbSQL; ';
    Script.Add := 'begin';
    Script.add := '  sql := CreateSQL(TIBTransaction(Tx)); ';
    Script.add := '  try';
    Script.add := '    RunSQL(sql, format(''Select FullName from Users u Where u.UserID=%d'', [UserID])); ';
    Script.Add := '    result := sql.FieldByName(''FullName'') = ''APPROVAL''; ';
    Script.add := '  finally';
    Script.Add := '    sql.Free; ';
    Script.add := '  end; ';
    Script.add := 'end;';
    Script.add := '';
  end;
begin
  SOsConstAndVar;
  SOsCreate_BtnPreview;
  IsNeedApproval;
  SOsShowFrmPreview;
  SOsCreateCheckBoxNeedApproval('Form.SetFilterAndRun');
  CalcField;
  IsApproval;
end;

procedure TSOApprovalOverlimitInjector.GenerateSOList;
begin
  ClearScript;
  CreateButton;
  CreateLabel;
  CreateEditBox;
  CreateCheckBox;
  CreateQuery;
  RunQuery;
  ReadOption;
  IsAdmin;
  AddConstant;
  SOsApproval;

  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  InitializeFieldName;';
  Script.Add := '  if IsAdmin or IsApproval then begin';
  Script.Add := '    Create_BtnPreview;';
  Script.Add := '  end;';
  Script.Add := '  DataModule.tabelSO.OnCalcFields := @tblSOCalcFields;';
  Script.Add := '  Form.SetFilterAndRun;';
  Script.Add := '  CreateCheckBoxNeedApproval;';
  Script.Add := 'end.';
end;

procedure TSOApprovalOverlimitInjector.MainCreateMenuSetting;
begin
  CreateFormSetting;
  Script.Add := 'procedure ShowSetting; ';
  Script.Add := 'var frmSetting : TForm; ';
  Script.Add := 'begin ';
  Script.Add := '  frmSetting := CreateFormSetting(''frmSetting'', ''SO Approval Setting'', 400, 400);';
  Script.Add := '  try ';
  Script.Add := '    AddControl( frmSetting, ''NEED APPROVAL Field'', ''CUSTOMFIELD'', ''NEED_APPROVAL_FIELD'', ''CUSTOMFIELD11'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''APPROVED Field''     , ''CUSTOMFIELD'', ''APPROVED_FIELD''     , ''CUSTOMFIELD12'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Use CBD''            , ''TEXT''       , ''USE_CBD''            , ''0''            , ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''CBD Field''          , ''CUSTOMFIELD'', ''CBD_FIELD''          , ''CUSTOMFIELD13'', ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Include OverDue''    , ''CHECKBOX''   , ''INCLUDE_OVERDUE''    , ''0''            , ''0'', ''''); ';
  Script.Add := '    AddControl( frmSetting, ''Top position of Approve Button'', ''TEXT'', ''APPROVE_BTN_TOP'', ''-1'', ''0'', ''''); ';
  Script.Add := '    if frmSetting.ShowModal = mrOK then begin ';
  Script.Add := '      SaveToOptions; ';
  Script.Add := '    end; ';
  Script.Add := '  finally ';
  Script.Add := '    frmSetting.Free; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure AddMenuSetting;';
  Script.Add := 'var mnuSOApprovalSetting : TMenuItem; ';
  Script.Add := 'begin ';
  Script.Add := '  mnuSOApprovalSetting := TMenuItem(Form.FindComponent( ''mnuSOApprovalSetting'' )); ';
  Script.Add := '  if mnuSOApprovalSetting <> nil then mnuSOApprovalSetting.Free; ';
  Script.Add := '  mnuSOApprovalSetting := TMenuItem.Create( Form );';
  Script.Add := '  mnuSOApprovalSetting.Name := ''mnuSOApprovalSetting'';';
  Script.Add := '  mnuSOApprovalSetting.Caption := ''Setting SO Approval'';';
  Script.Add := '  mnuSOApprovalSetting.OnClick := @ShowSetting;';
  Script.Add := '  mnuSOApprovalSetting.Visible := True;';
  Script.Add := '  Form.AmnuEdit.Add( mnuSOApprovalSetting );';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TSOApprovalOverlimitInjector.GenerateMain;
begin
  ClearScript;
  MainCreateMenuSetting;
  Script.Add := 'BEGIN';
  Script.Add := '  AddMenuSetting; ';
  Script.Add := 'END.';
end;

procedure TSOApprovalOverlimitInjector.GenerateDO;
begin
  ClearScript;
  Script.Add := 'procedure DetailAfterPost;                              ';
  Script.Add := 'begin                                                   ';
  Script.Add := '  if not TIntegerField(Detail.SOID).isNull then begin   ';
  Script.Add := '    DataModule.AllowOverLimit := true;                  ';
  Script.Add := '  end;                                                  ';
  Script.Add := 'end;                                                    ';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  Detail.OnAfterPostArray := @DetailAfterPost;    ';
  Script.Add := 'end.';
end;

procedure TSOApprovalOverlimitInjector.ShouldByPassValidation;
begin
  Script.Add := '';
  Script.Add := 'function ShouldByPassValidation:Boolean;';
  Script.Add := 'begin';
  Script.Add := '  result := false;';
  Script.Add := '  if (not INCLUDE_OVERDUE) then exit;';
  Script.Add := '  if (Master.GetFromSO.value = 1) and (not Detail.SOID.isNull) then begin';
  Script.Add := '    result := (TSODataset(Detail.SOID.FieldLookup).ExtendedID.FieldLookup.FieldByName(APPROVED_FIELD).AsString = ''1'');';
  Script.Add := '  end;';
  Script.Add := 'end;';
end;

procedure TSOApprovalOverlimitInjector.GenerateSI;
begin
  ClearScript;
  CreateButton;
  ReadOption;
  WriteOption;
  AddConstant;
  CheckCreditLimit('InvoiceAmount', 'ARInv', 'ARInvoiceID', 'InvoiceDate', 'Tax1Amount', 'Tax2Amount');
  ValidateSOOverDue ('InvoiceDate');
  Script.Add := 'procedure DetailAfterPost;                              ';
  Script.Add := 'begin                                                   ';
  Script.Add := '  if not TIntegerField(Detail.SOID).isNull then begin   ';
  Script.Add := '    DataModule.AllowOverLimit := true;                  ';
  Script.Add := '  end;                                                  ';
  Script.Add := 'end;                                                    ';

  ShouldByPassValidation;

  Script.Add := '';
  Script.Add := 'procedure SIMasterBeforePost; ';
  Script.Add := 'begin ';
  Script.Add := '  if Master.IsFirstPost then begin';
  Script.Add := '    WriteOption( PARAM_OPT_ALLOWED_OVERDUE_SI, ''1''); ';
  Script.Add := '  end;';
  Script.Add := '  if ShouldByPassValidation then begin';
  Script.Add := '    WriteOption( PARAM_OPT_ALLOWED_OVERDUE_SI, ''1''); ';
  Script.Add := '  end;';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'procedure SIMasterAfterPost; ';
  Script.Add := 'begin ';
  Script.Add := '  WriteOption( PARAM_OPT_ALLOWED_OVERDUE_SI, ''0''); ';
  Script.Add := 'end; ';
  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  InitializeFieldName; ';
  Script.Add := '  Detail.OnAfterPostArray := @DetailAfterPost;    ';
  Script.Add := '  Master.OnBeforePostValidationArray := @SIMasterBeforePost; ';
  Script.Add := '  Master.OnBeforePostValidationArray := @DoCheckCreditLimit; ';
  Script.Add := '  Master.OnAfterPostArray            := @SIMasterAfterPost; ';
  Script.Add := '  Detail.OnBeforePostValidationArray := @ValidateSOOverDue;';
  Script.Add := 'end.';
end;

procedure TSOApprovalOverlimitInjector.GenerateScript;
begin
  GenerateScriptForSO;
  InjectToDB( fnSalesOrder );

  GenerateScriptForChooseForm;
  InjectToDB(fnChoose);

  GenerateSOList;
  InjectToDB( fnSalesOrders );

  GenerateDO;
  InjectToDB( fnDeliveryOrder );

  GenerateSI;
  InjectToDB( fnARInvoice );

  GenerateMain;
  InjectToDB( fnMain );

end;

initialization
  Classes.RegisterClass( TSOApprovalOverlimitInjector );
end.
