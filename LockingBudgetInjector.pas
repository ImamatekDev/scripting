unit LockingBudgetInjector;

interface
uses Injector, BankConst, System.SysUtils;

type
  TLockingBudgetInjector = class (TInjector)
    private
      procedure VarAndConst;
      procedure ShowSettingEmailForm;
      procedure SendNotificationEmail (txDate, formName, txID, txNo : String);
      procedure NeedApproval (aliasField, fieldNoSQL, formName, datasetName : String);
      procedure LockingBudgetValidation (TxDate, formName, txID, txNo : String);
      procedure NormalizeAccount;
      procedure GetAccountListFromItem (formName : String);
      procedure OverBudgetField;
      procedure GeneralProceduresAmongCalculationMethods (txDate, formName, txID : String);
      procedure GetBaseAndActualBudgetForAccumulationEach (txDate, formName, txID : String);
      procedure GetBaseAndActualBudgetForAccumulationTotal (txDate, formName, txID : String);
      procedure GetBaseAndActualBudgetForPeriodEach (txDate, formName, txID : String);
      procedure GetBaseAndActualBudgetForPeriodTotal (txDate, formName, txID : String);
      procedure GenerateScriptForJVList;
      procedure GenerateScriptForCRList;
      procedure GenerateScriptForVPList;
      procedure GenerateScriptForPIList;
      procedure GenerateScriptForSIList;
      procedure GenerateScriptForIAList;
      procedure GenerateScriptForJCList;
      procedure GenerateScriptForOP;
      procedure GenerateScriptForOR;
      procedure GenerateScriptForJV;
      procedure GenerateScriptForCR;
      procedure GenerateScriptForVP;
      procedure GenerateScriptForPI;
      procedure GenerateScriptForSI;
      procedure GenerateScriptForIA;
      procedure GenerateScriptForJC;
      procedure BudgetScript;
      procedure GenerateScriptForAccountBudget;
      procedure GenerateScriptForProjectAndDepartmentBudget;
      procedure GenerateScriptForMain;
    public
      procedure set_scripting_parameterize; Override;
    published
      procedure GenerateScript; Override;
  end;

implementation

{ TLockingBudget }

procedure TLockingBudgetInjector.GenerateScriptForJVList;
begin
  NeedApproval ('J','Datamodule.AqryJV.SelectSQL[2]','JV','AqryJV');
end;

procedure TLockingBudgetInjector.GenerateScriptForCRList;
begin
  NeedApproval ('A','Datamodule.AtblARPayments.SelectSQL[5]','CR','AtblARPayments');
end;

procedure TLockingBudgetInjector.GenerateScriptForVPList;
begin
  NeedApproval ('C','DataModule.AtblAPCheq.SelectSQL[5]','VP','AtblAPCheq');
end;

procedure TLockingBudgetInjector.GenerateScriptForPIList;
begin
  NeedApproval ('R','DataModule.qryAPInv.SelectSQL[7]','PI','qryAPInv');
end;

procedure TLockingBudgetInjector.GenerateScriptForSIList;
begin
  NeedApproval ('R','DataModule.AqryARInv.SelectSQL[4]','SI','AqryARInv');
end;

procedure TLockingBudgetInjector.GenerateScriptForIAList;
begin
  NeedApproval ('A','Datamodule.AtblItemAdj.SelectSQL[3]','IA','AtblItemAdj');
end;

procedure TLockingBudgetInjector.GenerateScriptForJCList;
begin
  NeedApproval ('M','Datamodule.tblMfsht.SelectSQL[6]','JC','tblMfsht');
end;

procedure TLockingBudgetInjector.GenerateScriptForOP;
begin
  LockingBudgetValidation ('TransDate', 'OP', 'JVID', 'JVNumber');
end;

procedure TLockingBudgetInjector.GenerateScriptForOR;
begin
  LockingBudgetValidation ('TransDate', 'OR', 'JVID', 'JVNumber');
end;

procedure TLockingBudgetInjector.GenerateScriptForJV;
begin
  LockingBudgetValidation ('TransDate', 'JV', 'JVID', 'JVNumber');
end;

procedure TLockingBudgetInjector.GenerateScriptForCR;
begin
  LockingBudgetValidation ('ChequeDate', 'CR', 'PaymentID', 'SequenceNo');
end;

procedure TLockingBudgetInjector.GenerateScriptForVP;
begin
  LockingBudgetValidation ('ChequeDate', 'VP', 'ChequeID', 'SequenceNo');
end;

procedure TLockingBudgetInjector.GenerateScriptForPI;
begin
  LockingBudgetValidation ('InvoiceDate', 'PI', 'APInvoiceID', 'InvoiceNo');
end;

procedure TLockingBudgetInjector.GenerateScriptForSI;
begin
  LockingBudgetValidation ('InvoiceDate', 'SI', 'ARInvoiceID', 'InvoiceNo');
end;

procedure TLockingBudgetInjector.GenerateScriptForIA;
begin
  LockingBudgetValidation ('AdjDate', 'IA', 'ItemAdjID', 'AdjNo');
end;

procedure TLockingBudgetInjector.GenerateScriptForJC;
begin
  LockingBudgetValidation ('SheetDate', 'JC', 'MfID', 'MfNo');
end;

procedure TLockingBudgetInjector.GeneralProceduresAmongCalculationMethods (txDate, formName, txID : String);
begin
  GetAccountListFromItem (formName);

//  Script.Add := '';
//  Script.Add := 'function GetOtherTotalTransIfAccountSame (masterAccount : String; idxAccount : Integer = 1) : Currency;';
//  Script.Add := 'var';
//  Script.Add := '  sameAccSQL      : TjbSQL;';
//  Script.Add := '  otherTotalTrans : String;';
//  Script.Add := '  accountField    : String;';
//  Script.Add := '  discAccount     : String;';
//  Script.Add := 'begin';
//  Script.Add := '  if (masterAccount = '''') then begin';
//  Script.Add := '    sameAccSQL := CreateSQL (TIBTransaction (Detail.Tx) );';
//  Script.Add := '    try';
//  Script.Add := '      otherTotalTrans := '''';';
//  if (formName = 'OP') OR (formName = 'OR') OR (formName = 'JV') then begin
//    if (formName = 'OP') OR (formName = 'JV') then begin
//      Script.Add := '    otherTotalTrans := ''SELECT COALESCE (SUM (GLAMOUNT), 0) SAMEACCOUNTAMOUNT '';';
//    end
//    else if (formName = 'OR') then begin
//      Script.Add := '    otherTotalTrans := ''SELECT COALESCE (-1 * SUM (GLAMOUNT), 0) SAMEACCOUNTAMOUNT '';';
//    end;
//    Script.Add := '    otherTotalTrans := otherTotalTrans + Format (''FROM JVDET WHERE JVID = %d AND SEQ <> %d '+
//                                          'AND GLACCOUNT = ''''%s'''' '', [Master.' + txID + '.AsInteger '+
//                                          ', Detail.Seq.AsInteger, Detail.GLAccount.AsString]);';
//  end
//  else if (formName = 'SI') OR (formName = 'PI') then begin
//    Script.Add := '     case idxAccount of';
//    Script.Add := '       1 : accountField := ''INVENTORYGLACCNT'';';
//    Script.Add := '       2 : accountField := ''COGSGLACCNT'';';
//    Script.Add := '       3 : accountField := ''PURCHASERETGLACCNT'';';
//    Script.Add := '       4 : accountField := ''SALESGLACCNT'';';
//    Script.Add := '       5 : accountField := ''SALESRETGLACCNT'';';
//    Script.Add := '       6 : accountField := ''SALESDISCOUNTACCNT'';';
//    Script.Add := '       7 : accountField := ''GOODSTRANSITACCNT'';';
//    Script.Add := '       8 : accountField := ''FINISHEDMTRLGLACCNT'';';
//    Script.Add := '       9 : accountField := ''INVENTORYCONTROLACCNT'';';
//    Script.Add := '     end;';
//
//    if (formName = 'SI') then begin
//      Script.Add := '      if (idxAccount = 1) then begin';
//      Script.Add := '        otherTotalTrans := ''SELECT COALESCE (-1 * SUM (A.QUANTITY * I.COST), 0) SAMEACCOUNTAMOUNT '';';
//      Script.Add := '      end';
//      Script.Add := '      else if (idxAccount = 2) then begin';
//      Script.Add := '        otherTotalTrans := ''SELECT COALESCE (SUM (A.QUANTITY * I.COST), 0) SAMEACCOUNTAMOUNT '';';
//      Script.Add := '      end';
//      Script.Add := '      else if (idxAccount = 4) then begin';
//      Script.Add := '        otherTotalTrans := ''SELECT COALESCE (-1 * SUM (A.QUANTITY * A.BRUTOUNITPRICE), 0) SAMEACCOUNTAMOUNT '';';
//      Script.Add := '      end';
//      Script.Add := '      else begin';
//      Script.Add := '        otherTotalTrans := ''SELECT 0 SAMEACCOUNTAMOUNT '';';
//      Script.Add := '      end;';
//      Script.Add := '      otherTotalTrans := otherTotalTrans + Format (''FROM ARINVDET A '+
//                                              'JOIN ITEM I ON A.ITEMNO = I.ITEMNO '+
//                                              'WHERE A.ARINVOICEID = %d AND A.SEQ <> %d AND I.%s = ''''%s'''' '' '+
//                                              ', [Master.' + txID + '.AsInteger '+
//                                              ', Detail.Seq.AsInteger, accountField '+
//                                              ', GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount)]);';
//    end
//    else if (formName = 'PI') then begin
//      Script.Add := '      if expenseDetail then begin';
//      Script.Add := '        otherTotalTrans := ''SELECT COALESCE (SUM (GLAMOUNT), 0) SAMEACCOUNTAMOUNT '';';
//      Script.Add := '        otherTotalTrans := otherTotalTrans + Format (''FROM APINVDET WHERE APINVOICEID = %d '+
//                                                'AND SEQ <> %d AND GLACCOUNT = ''''%s'''' '' '+
//                                                ', [Master.' + txID + '.AsInteger '+
//                                                ', Detail2.Seq.AsInteger, Detail2.GLAccount.AsString]);';
//      Script.Add := '      end';
//      Script.Add := '      else begin';
//      Script.Add := '        if (idxAccount = 1) then begin';
//      Script.Add := '          otherTotalTrans := ''SELECT COALESCE (SUM (A.QUANTITY * A.ITEMCOST), 0) SAMEACCOUNTAMOUNT '';';
//      Script.Add := '        end';
//      Script.Add := '        else begin';
//      Script.Add := '          otherTotalTrans := ''SELECT 0 SAMEACCOUNTAMOUNT '';';
//      Script.Add := '        end;';
//      Script.Add := '        otherTotalTrans := otherTotalTrans + Format (''FROM APITMDET A '+
//                                                'JOIN ITEM I ON A.ITEMNO = I.ITEMNO '+
//                                                'WHERE A.APINVOICEID = %d AND A.SEQ <> %d AND I.%s = ''''%s'''' '' '+
//                                                ', [Master.' + txID + '.AsInteger '+
//                                                ', Detail.Seq.AsInteger, accountField '+
//                                                ', GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount)]);';
//      Script.Add := '      end;';
//    end;
//  end
//  else if (formName = 'JC') then begin
//    Script.Add := '      if expenseDetail then begin';
//    Script.Add := '        otherTotalTrans := ''SELECT COALESCE (SUM (GLAMOUNT), 0) SAMEACCOUNTAMOUNT '';';
//    Script.Add := '        otherTotalTrans := otherTotalTrans + Format (''FROM MFSHTGL WHERE MFID = %d AND SEQ <> %d '+
//                                              'AND GLACCOUNT = ''''%s'''' '', [Master.' + txID + '.AsInteger '+
//                                              ', Detail2.Seq.AsInteger, Detail2.GLAccount.AsString]);';
//    Script.Add := '      end';
//    Script.Add := '      else begin';
//    Script.Add := '        otherTotalTrans := ''SELECT COALESCE (-1 * SUM (IH.COST), 0) SAMEACCOUNTAMOUNT '';';
//    Script.Add := '        otherTotalTrans := otherTotalTrans + Format (''FROM MFSHTDET M '+
//                                              'JOIN ITEMHIST IH ON M.ITEMHISTID = IH.ITEMHISTID '+
//                                              'WHERE M.MFID = %d AND M.SEQ <> %d '+
//                                              'AND M.ITEMNO = ''''%s'''' '', [Master.' + txID + '.AsInteger '+
//                                              ', Detail.Seq.AsInteger, Detail.ItemNo.AsString]);';
//    Script.Add := '      end;';
//  end
//  else if (formName = 'IA') then begin
//    Script.Add := '      If Master.AdjCheck.Value = 0 then begin';
//    Script.Add := '        otherTotalTrans := ''SELECT COALESCE (-1 * SUM (VALUEDIFFERENCE), 0) SAMEACCOUNTAMOUNT '';';
//    Script.Add := '      end';
//    Script.Add := '      else begin';
//    Script.Add := '        otherTotalTrans := ''SELECT COALESCE (SUM (VALUEDIFFERENCE), 0) SAMEACCOUNTAMOUNT '';';
//    Script.Add := '      end;';
//    Script.Add := '      otherTotalTrans := otherTotalTrans + Format (''FROM ITADJDET WHERE ITEMADJID = %d AND SEQ <> %d '+
//                                            'AND ITEMNO = ''''%s'''' '', [Master.' + txID + '.AsInteger '+
//                                            ', Detail.Seq.AsInteger, Detail.ItemNo.AsString]);';
//  end
//  else if (formName = 'VP') then begin
//    Script.Add := '      otherTotalTrans := Format (''SELECT COALESCE (SUM (DISCOUNT), 0) SAMEACCOUNTAMOUNT '+
//                                            'FROM APINVCHQ WHERE CHEQUEID = %d AND SEQ <> %d '+
//                                            'AND DISCACCOUNT = ''''%s'''' '', [Master.' + txID + '.AsInteger '+
//                                            ', Detail.Seq.AsInteger, Detail.DiscAccount.AsString]);';
//  end
//  else if (formName = 'CR') then begin
//    Script.Add := '      otherTotalTrans := Format (''SELECT COALESCE (AD.DISCACCOUNT, '''''''') DISCACCOUNT '+
//                                            'FROM ARINVPMT AP JOIN ARINVPMT_DISC AD ON AP.INVPMTID = AD.INVPMTID '+
//                                            'WHERE AP.PAYMENTID = %d AND AP.SEQ = %d AND AD.SEQ = %d '' '+
//                                            ', [Master.' + txID + '.AsInteger '+
//                                            ', Detail.Seq.AsInteger, (idxAccount - 1)]);';
//    Script.Add := '      RunSQL (sameAccSQL, otherTotalTrans);';
//    Script.Add := '      discAccount     := sameAccSQL.FieldByName (''DISCACCOUNT'');';
//    Script.Add := '      otherTotalTrans := Format (''SELECT COALESCE (SUM (DISCOUNT), 0) SAMEACCOUNTAMOUNT '+
//                                            'FROM ARINVPMT AP JOIN ARINVPMT_DISC AD ON AP.INVPMTID = AD.INVPMTID '+
//                                            'WHERE AP.PAYMENTID = %d AND NOT (AP.SEQ = %d AND AD.SEQ = %d) '+
//                                            'AND AD.DISCACCOUNT = ''''%s'''' '' '+
//                                            ', [Master.' + txID + '.AsInteger '+
//                                            ', Detail.Seq.AsInteger, (idxAccount - 1), discAccount]);';
//  end;
//
//  Script.Add := '      RunSQL (sameAccSQL, otherTotalTrans);';
//  Script.Add := '      result := sameAccSQL.FieldByName (''SAMEACCOUNTAMOUNT'');';
//  Script.Add := '    finally';
//  Script.Add := '      sameAccSQL.Free;';
//  Script.Add := '    end;';
//  Script.Add := '  end';
//  Script.Add := '  else begin';
//  Script.Add := '    result := 0;';
//  Script.Add := '  end;';
//  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'function GetID (tableName : String) : Integer;';
  Script.Add := 'var';
  Script.Add := '  deptProjIDSQL : TjbSQL;';
  Script.Add := '  deptProjIDStr : String;';
  Script.Add := 'begin';
  Script.Add := '  deptProjIDSQL := CreateSQL (TIBTransaction (Tx) );';
  Script.Add := '  try';
  Script.Add := '    deptProjIDStr := Format (''SELECT COALESCE (%s, 0) %s '+
                                      'FROM ARINVPMT AP JOIN ARINVPMT_DISC AD ON AP.INVPMTID = AD.INVPMTID '+
                                      'WHERE AP.PAYMENTID = %d AND AP.SEQ = %d AND AD.SEQ = %d '' '+
                                      ', [tableName, tableName, Master.' + txID + '.AsInteger '+
                                      ', Detail.Seq.AsInteger, (idxAccount - 1)]);';
  Script.Add := '    RunSQL (deptProjIDSQL, deptProjIDStr);';
  Script.Add := '    result := deptProjIDSQL.FieldByName (tableName);';
  Script.Add := '  finally';
  Script.Add := '    deptProjIDSQL.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'function GetOldActualBudgetTransactionBeforeEdit (masterAccount : String): String;';
  Script.Add := 'begin';
  Script.Add := '  result := Format (''SELECT GH.BASEAMOUNT FROM GLHIST GH '+
                             'WHERE GH.GLYEAR = %d AND GH.INVOICEID = %d '' '+
                             ', [transYear, Master.' + txID + '.AsInteger]);';

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '  result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                        ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '  if expenseDetail then begin';
    Script.Add := '    result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                          ', [Detail2.GLAccount.Value]);';
    Script.Add := '  end';
    Script.Add := '  else begin';
    Script.Add := '    result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                          ', [GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount)]);';
    Script.Add := '  end;';
  end
  else begin
    Script.Add := '  result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                        ', [GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount)]);';
  end;
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure CalculateActualAmount (masterAccount : String);';

  if (formName = 'JC') then begin
    Script.Add := '  function GetSumItemCost : Currency;';
    Script.Add := '  begin';
    Script.Add := '    Detail.DisableControls;';
    Script.Add := '    try';
    Script.Add := '      Detail.First;';
    Script.Add := '      result := 0;';
    Script.Add := '      while NOT Detail.EOF do begin';
    Script.Add := '        result := result + Detail.CostQty.AsCurrency;';
    Script.Add := '        Detail.Next;';
    Script.Add := '      end;';
    Script.Add := '    finally';
    Script.Add := '      Detail.EnableControls;';
    Script.Add := '    end;';
    Script.Add := '  end;';
  end;

  Script.Add := 'begin';
  if (formName = 'CR') then begin
    Script.Add := '  RunSQL (costSQL, Format (''SELECT COALESCE (DISCACCOUNT, '''''''') DISCACCOUNT '+
                     ', DISCOUNT FROM ARINVPMT_DISC '+
                     'WHERE INVPMTID = %d AND SEQ = %d'', [Detail.FieldByName (''InvPmtID'').Value, (idxAccount - 1)]) );';
    Script.Add := '  actualAmount := costSQL.FieldByName (''DISCOUNT'');';
    Script.Add := '  actualAmount := NormalizeAccount (VarToStr (costSQL.FieldByName (''DISCACCOUNT'') ) ) '+
                                     '* actualAmount;';
  end
  else if (formName = 'VP') then begin
    Script.Add := '  RunSQL (costSQL, Format (''SELECT COALESCE (DISCACCOUNT, '''''''') DISCACCOUNT FROM APINVCHQ '+
                     'WHERE CHEQUEID = %d '', [Detail.FieldByName (''ChequeID'').Value]) );';
    Script.Add := '  actualAmount := Detail.Discount.AsCurrency;';
    Script.Add := '  actualAmount := NormalizeAccount (VarToStr (costSQL.FieldByName (''DISCACCOUNT'') ) ) '+
                                     '* actualAmount;';
  end
  else if (formName = 'SI') OR (formName = 'PI') OR (formName = 'IA') OR (formName = 'JC') then begin
    if (formName = 'SI') then begin
      Script.Add := '  if (masterAccount = '''') then begin';
      Script.Add := '    RunSQL (costSQL, Format (''SELECT COST FROM ITEM WHERE ITEMNO = ''''%s'''' '' '+
                         ', [Detail.ItemNo.AsString]) );';
      Script.Add := '    if (idxAccount = 1) then begin';
      Script.Add := '      actualAmount := -1 * costSQL.FieldByName (''COST'') * Detail.Quantity.Value;';
      Script.Add := '    end';
      Script.Add := '    else if (idxAccount = 2) then begin';
      Script.Add := '      actualAmount := costSQL.FieldByName (''COST'') * Detail.Quantity.Value;';
      Script.Add := '    end';
      Script.Add := '    else if (idxAccount = 4) then begin';
      Script.Add := '      actualAmount := -1 * Detail.BrutoUnitPrice.Value * Detail.Quantity.Value;';
      Script.Add := '    end;';
      Script.Add := '  end';
      Script.Add := '  else begin';
      Script.Add := '    actualAmount := -1 * Master.Freight.Value;';
      Script.Add := '  end;';
    end
    else if (formName = 'PI') then begin
      Script.Add := '  if (masterAccount = '''') then begin';
      Script.Add := '    if expenseDetail then begin';
      Script.Add := '      actualAmount := Detail2.GLAmount.Value;';
      Script.Add := '    end';
      Script.Add := '    else begin';
      Script.Add := '      RunSQL (costSQL, Format (''SELECT ITEMCOST FROM APITMDET '+
                           'WHERE SEQ = %d AND APINVOICEID = %d'' '+
                           ', [Detail.Seq.Value, Master.APInvoiceID.Value]) );';
      Script.Add := '      if (idxAccount = 1) then begin';
      Script.Add := '        actualAmount := costSQL.FieldByName (''ITEMCOST'') * Detail.Quantity.Value;';
      Script.Add := '      end;';
      Script.Add := '    end;';
      Script.Add := '  end';
      Script.Add := '  else begin';
      Script.Add := '    actualAmount := Master.Freight.Value;';
      Script.Add := '  end;';
    end
    else if (formName = 'IA') then begin
      Script.Add := '  if (masterAccount = '''') then begin';
      Script.Add := '    If Master.AdjCheck.Value = 0 then begin';
      Script.Add := '      actualAmount := -1 * Detail.ValueDifference.Value;';
      Script.Add := '    end';
      Script.Add := '    else begin';
      Script.Add := '      actualAmount := Detail.ValueDifference.Value;';
      Script.Add := '    end;';
      Script.Add := '  end';
      Script.Add := '  else begin';
      Script.Add := '    If Master.AdjCheck.Value = 0 then begin';
      Script.Add := '      actualAmount := -1 * Master.TotalValue.Value;';
      Script.Add := '    end';
      Script.Add := '    else begin';
      Script.Add := '      actualAmount := Master.TotalValue.Value;';
      Script.Add := '    end;';
      Script.Add := '  end;';
    end
    else if (formName = 'JC') then begin
      Script.Add := '  if (masterAccount = '''') then begin';
      Script.Add := '    if expenseDetail then begin';
      Script.Add := '      actualAmount := Detail2.GLAmount.Value;';
      Script.Add := '    end';
      Script.Add := '    else begin';
      Script.Add := '      actualAmount := -1 * Detail.CostQty.Value;';
      Script.Add := '    end;';
      Script.Add := '  end';
      Script.Add := '  else begin';
      Script.Add := '      actualAmount := Master.AccountAmount.AsCurrency + GetSumItemCost;';
      Script.Add := '  end;';
    end;

    if (formName = 'PI') OR (formName = 'JC') then begin
      Script.Add := '  if (masterAccount = '''') then begin';
      Script.Add := '    if expenseDetail then begin';
      Script.Add := '      actualAmount := NormalizeAccount (Detail2.GLAccount.Value) * actualAmount;';
      Script.Add := '    end';
      Script.Add := '    else begin';
      Script.Add := '      actualAmount := NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','' '+
                                           ', idxAccount) ) * actualAmount;';
      Script.Add := '    end;';
      Script.Add := '  end';
      Script.Add := '  else begin';
      Script.Add := '    actualAmount := NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','' '+
                                         ', idxAccount) ) * actualAmount;';
      Script.Add := '  end;';
    end
    else begin
      Script.Add := '  actualAmount := NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','' '+
                                       ', idxAccount) ) * actualAmount;';
    end;
  end
  else if (formName = 'OP') OR (formName = 'OR') OR (formName = 'JV') then begin
    if (formName = 'OP') OR (formName = 'JV') then begin
      Script.Add := '  actualAmount := Detail.GLAmount.Value;';
    end
    else if (formName = 'OR') then begin
      Script.Add := '  actualAmount := -1 * Detail.GLAmount.Value;';
    end;
    Script.Add := '  actualAmount := NormalizeAccount (Detail.GLAccount.Value) * actualAmount;';
  end;
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure SaveCalculationBudget (scriptType, masterAccount : String);';
  Script.Add := 'var';
  Script.Add := '  accountStr  : String;';
  Script.Add := '  accountName : String;';
  Script.Add := 'const';
  Script.Add := '  DUMMY_SEQ = 9999;';

  Script.Add := '  procedure CreateRecord;';
  Script.Add := '  begin';
  Script.Add := '    with budgetDataset do begin';
  Script.Add := '      Append;';
  Script.Add := '      FieldByName (''Expense Detail'').AsBoolean := expenseDetail;';

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '      if (masterAccount = '''') then begin';
    Script.Add := '        if expenseDetail then begin';
    Script.Add := '          FieldByName (''Sequence'').AsInteger  := Detail2.Seq.Value;';
    Script.Add := '          FieldByName (''Dep. ID'').AsInteger   := Detail2.DeptID.AsInteger;';
    Script.Add := '          FieldByName (''Proyek ID'').AsInteger := Detail2.ProjectID.AsInteger;';
    Script.Add := '        end';
    Script.Add := '        else begin';
    Script.Add := '          FieldByName (''Sequence'').AsInteger  := Detail.Seq.Value;';
    Script.Add := '          FieldByName (''Dep. ID'').AsInteger   := Detail.DeptID.AsInteger;';
    Script.Add := '          FieldByName (''Proyek ID'').AsInteger := Detail.ProjectID.AsInteger;';
    Script.Add := '        end;';
    Script.Add := '      end';
    Script.Add := '      else begin';
    Script.Add := '        FieldByName (''Sequence'').AsInteger  := DUMMY_SEQ;';
    Script.Add := '        FieldByName (''Dep. ID'').AsInteger   := 0;';
    Script.Add := '        FieldByName (''Proyek ID'').AsInteger := 0;';
    Script.Add := '      end;';
  end
  else begin
    Script.Add := '      if (masterAccount = '''') then begin';
    Script.Add := '        FieldByName (''Sequence'').AsInteger  := Detail.Seq.Value;';
    Script.Add := '        FieldByName (''Dep. ID'').AsInteger   := Detail.DeptID.AsInteger;';
    Script.Add := '        FieldByName (''Proyek ID'').AsInteger := Detail.ProjectID.AsInteger;';
    Script.Add := '      end';
    Script.Add := '      else begin';
    Script.Add := '        FieldByName (''Sequence'').AsInteger  := DUMMY_SEQ;';
    Script.Add := '        FieldByName (''Dep. ID'').AsInteger   := 0;';
    Script.Add := '        FieldByName (''Proyek ID'').AsInteger := 0;';
    Script.Add := '      end;';
  end;
  Script.Add := '      RunSQL (budgetSQL, accountStr);';
  Script.Add := '      accountName := budgetSQL.FieldByName (''ACCOUNTNAME'');';
  Script.Add := '      FieldByName (''No. Akun'').AsString  := budgetSQL.FieldByName (''GLACCOUNT'');';
  Script.Add := '      FieldByName (''Sorting'').AsString   := FieldByName (''No. Akun'').AsString '+
                                                               '+ FieldByName (''Dep. ID'').AsString '+
                                                               '+ FieldByName (''Proyek ID'').AsString;';
  Script.Add := '      FieldByName (''Nama Akun'').AsString := accountName;';
  Script.Add := '      Post;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure LocateField;';
  Script.Add := '  var';
  Script.Add := '    isRecExist : Boolean;';
  Script.Add := '  begin';
  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      isRecExist := budgetDataset.Locate (''Expense Detail;Sequence;Nama Akun'' '+
                         ', [expenseDetail, Detail2.Seq.Value, accountName], 0);';
    Script.Add := '      if NOT isRecExist then begin';
    Script.Add := '        CreateRecord;';
    Script.Add := '        FillDataset;';
    Script.Add := '      end;';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      isRecExist := budgetDataset.Locate (''Expense Detail;Sequence;Nama Akun'' '+
                         ', [expenseDetail, Detail.Seq.Value, accountName], 0);';
    Script.Add := '      if NOT isRecExist then begin';
    Script.Add := '        CreateRecord;';
    Script.Add := '        FillDataset;';
    Script.Add := '      end;';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    isRecExist := budgetDataset.Locate (''Expense Detail;Sequence;Nama Akun'' '+
                       ', [expenseDetail, Detail.Seq.Value, accountName], 0);';
    Script.Add := '      if NOT isRecExist then begin';
    Script.Add := '        CreateRecord;';
    Script.Add := '        FillDataset;';
    Script.Add := '      end;';
  end;
  Script.Add := '  end;';

  Script.Add := '  procedure FillDataset;';
  Script.Add := '  begin';
  Script.Add := '    LocateField;';
  Script.Add := '    budgetDataset.Edit;';
  Script.Add := '    if (scriptType = ''Account'') then begin';
  Script.Add := '      budgetDataset.FieldByName (''Akun Sisa Budget'').AsCurrency     := budgetRemain;';
  Script.Add := '      budgetDataset.FieldByName (''Akun Nilai Transaksi'').AsCurrency := actualAmount;';
  Script.Add := '    end';
  Script.Add := '    else if (scriptType = ''Department'') then begin';
  Script.Add := '      budgetDataset.FieldByName (''Dep. Sisa Budget'').AsCurrency     := budgetRemain;';
  Script.Add := '      budgetDataset.FieldByName (''Dep. Nilai Transaksi'').AsCurrency := actualAmount;';
  Script.Add := '    end';
  Script.Add := '    else if (scriptType = ''Project'') then begin';
  Script.Add := '      budgetDataset.FieldByName (''Proyek Sisa Budget'').AsCurrency     := budgetRemain;';
  Script.Add := '      budgetDataset.FieldByName (''Proyek Nilai Transaksi'').AsCurrency := actualAmount;';
  Script.Add := '    end;';
  Script.Add := '    budgetDataset.Post;';
  Script.Add := '  end;';

  Script.Add := 'begin';
  Script.Add := '  if (totalBudget <> ''0'') AND (totalBudget <> '''') AND (actualAmount <> 0) then begin';
  Script.Add := '    accountStr := ''SELECT GLACCOUNT, ACCOUNTNAME FROM GLACCNT '';';
  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '    accountStr := accountStr + Format (''WHERE GLACCOUNT = ''''%s'''' '' '+
                                                  ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      accountStr := accountStr + Format (''WHERE GLACCOUNT = ''''%s'''' '' '+
                                                    ', [Detail2.GLAccount.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      accountStr := accountStr + Format (''WHERE GLACCOUNT = ''''%s'''' '' '+
                                                    ', [GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount)]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    accountStr := accountStr + Format (''WHERE GLACCOUNT = ''''%s'''' '' '+
                                                  ', [GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount)]);';
  end;
  Script.Add := '    FillDataset;';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := 'procedure CalculateRemainBudget;';

  Script.Add := '  function isOverBudget : Boolean;';
  Script.Add := '  begin';
  Script.Add := '    result := (budgetDataset.FieldByName (''Akun Sisa Budget'').AsCurrency '+
                               '- budgetDataset.FieldByName (''Akun Nilai Transaksi'').AsCurrency < 0) '+
                               'OR (budgetDataset.FieldByName (''Dep. Sisa Budget'').AsCurrency '+
                               '- budgetDataset.FieldByName (''Dep. Nilai Transaksi'').AsCurrency < 0) '+
                               'OR (budgetDataset.FieldByName (''Proyek Sisa Budget'').AsCurrency '+
                               '- budgetDataset.FieldByName (''Proyek Nilai Transaksi'').AsCurrency < 0);';
  Script.Add := '  end;';

  Script.Add := '  procedure SetFlagOverBudget;';
  Script.Add := '  begin';
  Script.Add := '    while NOT budgetDataset.BOF do begin';
  Script.Add := '      if isOverBudget then begin';
  Script.Add := '        isShowConfirmation := True;';
  Script.Add := '        break;';
  Script.Add := '      end;';
  Script.Add := '      budgetDataset.Prior;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure CalculateRemainBudgetDataset (overBudgetType : String);';
  Script.Add := '  var';
  Script.Add := '    accountBudget     : Currency;';
  Script.Add := '    prevAccountBudget : Currency;';
  Script.Add := '    accNo             : String;';
  Script.Add := '    overBudgetID      : Integer;';
  Script.Add := '    changeAcc         : Boolean;';

  Script.Add := '    procedure CalculateSameAccount;';
  Script.Add := '    begin';
  Script.Add := '      budgetDataset.Edit;';
  Script.Add := '      if changeAcc then begin';
  Script.Add := '        budgetDataset.FieldByName (Format (''%s Sisa Budget'', [overBudgetType]) ).AsCurrency := accountBudget;';
  Script.Add := '        prevAccountBudget := budgetDataset.FieldByName (Format (''%s Nilai Transaksi'', [overBudgetType]) ).AsCurrency;';
  Script.Add := '        changeAcc := False;';
  Script.Add := '      end';
  Script.Add := '      else begin';
  Script.Add := '        budgetDataset.FieldByName (Format (''%s Sisa Budget'', [overBudgetType]) ).AsCurrency := accountBudget '+
                                                                                                                  '- prevAccountBudget;';
  Script.Add := '      end;';
  Script.Add := '      budgetDataset.Post;';
  Script.Add := '    end;';

  Script.Add := '    procedure CalculateDifferentAccount;';
  Script.Add := '    begin';
  Script.Add := '      changeAcc     := True;';
  Script.Add := '      accNo         := budgetDataset.FieldByName (''No. Akun'').AsString;';
  Script.Add := '      accountBudget := budgetDataset.FieldByName (Format (''%s Sisa Budget'', [overBudgetType]) ).AsCurrency '+
                                        '- budgetDataset.FieldByName (Format (''%s Nilai Transaksi'', [overBudgetType]) ).AsCurrency;';
  Script.Add := '    end;';

  Script.Add := '  begin';
  Script.Add := '    with budgetDataset do begin';
  Script.Add := '      First;';
  Script.Add := '      accNo             := '''';';
  Script.Add := '      overBudgetID      := 0;';
  Script.Add := '      prevAccountBudget := 0;';
  Script.Add := '      while NOT budgetDataset.EOF do begin';
  Script.Add := '        if (FieldByName (Format (''%s Sisa Budget'', [overBudgetType]) ).AsCurrency <> 0) then begin';
  Script.Add := '          if (accNo = '''') then begin';
  Script.Add := '            if (overBudgetType <> ''Akun'') then begin';
  Script.Add := '              overBudgetID := FieldByName (Format (''%s ID'', [overBudgetType]) ).AsInteger;';
  Script.Add := '            end;';
  Script.Add := '            accNo         := FieldByName (''No. Akun'').AsString;';
  Script.Add := '            accountBudget := FieldByName (Format (''%s Sisa Budget'', [overBudgetType]) ).AsCurrency '+
                                              '- FieldByName (Format (''%s Nilai Transaksi'', [overBudgetType]) ).AsCurrency;';
  Script.Add := '          end';
  Script.Add := '          else begin';
  Script.Add := '            if (overBudgetType = ''Akun'') then begin';
  Script.Add := '              if (accNo = FieldByName (''No. Akun'').AsString) then begin';
  Script.Add := '                CalculateSameAccount;';
  Script.Add := '              end';
  Script.Add := '              else begin';
  Script.Add := '                CalculateDifferentAccount;';
  Script.Add := '              end;';
  Script.Add := '            end';
  Script.Add := '            else begin';
  Script.Add := '              if (accNo = FieldByName (''No. Akun'').AsString) '+
                               'AND (overBudgetID = FieldByName (Format (''%s ID'', [overBudgetType]) ).AsInteger) then begin';
  Script.Add := '                CalculateSameAccount;';
  Script.Add := '              end';
  Script.Add := '              else begin';
  Script.Add := '                overBudgetID := FieldByName (Format (''%s ID'', [overBudgetType]) ).AsInteger;';
  Script.Add := '                CalculateDifferentAccount;';
  Script.Add := '              end;';
  Script.Add := '            end;';
  Script.Add := '          end;';
  Script.Add := '        end;';
  Script.Add := '        Next;';
  Script.Add := '      end;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := 'begin';
  Script.Add := '  CalculateRemainBudgetDataset (''Akun'');';
  Script.Add := '  CalculateRemainBudgetDataset (''Dep.'');';
  Script.Add := '  CalculateRemainBudgetDataset (''Proyek'');';
  Script.Add := '  SetFlagOverBudget;';
  Script.Add := 'end;';

  Script.Add := 'procedure CombineSameAccountNo;';
  Script.Add := 'var';
  Script.Add := '  nextRecord                : Variant;';
  Script.Add := '  sameDepartmentBudgetValue : Variant;';
  Script.Add := '  sameProjectBudgetValue    : Variant;';
  Script.Add := '  sameAccountTransValue     : Variant;';
  Script.Add := '  sameDepartmentTransValue  : Variant;';
  Script.Add := '  sameProjectTransValue     : Variant;';

  Script.Add := '  procedure SetIndexOverBudget;';
  Script.Add := '  begin';
  Script.Add := '    budgetDataset.First;';
  Script.Add := '    while NOT budgetDataset.EOF do begin';
  Script.Add := '      budgetDataset.Edit;';
  Script.Add := '      budgetDataset.FieldByName (''No.'').AsInteger := budgetDataset.RecNo;';
  Script.Add := '      budgetDataset.Post;';
  Script.Add := '      budgetDataset.Next;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure SetDeletedRecordValue;';
  Script.Add := '  begin';
  Script.Add := '    sameDepartmentBudgetValue := budgetDataset.LookUp (''No.'', budgetDataset.RecNo, ''Dep. Sisa Budget'');';
  Script.Add := '    sameProjectBudgetValue    := budgetDataset.LookUp (''No.'', budgetDataset.RecNo, ''Proyek Sisa Budget'');';
  Script.Add := '    sameAccountTransValue     := budgetDataset.LookUp (''No.'', budgetDataset.RecNo, ''Akun Nilai Transaksi'');';
  Script.Add := '    sameDepartmentTransValue  := budgetDataset.LookUp (''No.'', budgetDataset.RecNo, ''Dep. Nilai Transaksi'');';
  Script.Add := '    sameProjectTransValue     := budgetDataset.LookUp (''No.'', budgetDataset.RecNo, ''Proyek Nilai Transaksi'');';
  Script.Add := '  end;';

  Script.Add := 'begin';
  Script.Add := '  with budgetDataset do begin';
  Script.Add := '    SetIndexOverBudget;';
  Script.Add := '    while NOT BOF do begin';
  Script.Add := '      nextRecord := LookUp (''No.'', (RecNo + 1), ''Sorting'');';
  Script.Add := '      if (VarToStr (nextRecord) = FieldByName (''Sorting'').AsString) then begin';
  Script.Add := '        SetDeletedRecordValue;';
  Script.Add := '        Delete;';

  Script.Add := '        Edit;';
  Script.Add := '        if (VarToStr (sameDepartmentBudgetValue) <> '''') then begin';
  Script.Add := '          FieldByName (''Dep. Sisa Budget'').AsCurrency := sameDepartmentBudgetValue;';
  Script.Add := '        end;';
  Script.Add := '        if (VarToStr (sameProjectBudgetValue) <> '''') then begin';
  Script.Add := '          FieldByName (''Proyek Sisa Budget'').AsCurrency := sameProjectBudgetValue;';
  Script.Add := '        end;';

  Script.Add := '        if (VarToStr (sameAccountTransValue) <> '''') then begin';
  Script.Add := '          FieldByName (''Akun Nilai Transaksi'').AsCurrency := FieldByName (''Akun Nilai Transaksi'').AsCurrency '+
                                                                                '+ sameAccountTransValue;';
  Script.Add := '        end;';
  Script.Add := '        if (VarToStr (sameDepartmentTransValue) <> '''') then begin';
  Script.Add := '          FieldByName (''Dep. Nilai Transaksi'').AsCurrency := FieldByName (''Dep. Nilai Transaksi'').AsCurrency '+
                                                                                '+ sameDepartmentTransValue;';
  Script.Add := '        end;';
  Script.Add := '        if (VarToStr (sameProjectTransValue) <> '''') then begin';
  Script.Add := '          FieldByName (''Proyek Nilai Transaksi'').AsCurrency := FieldByName (''Proyek Nilai Transaksi'').AsCurrency '+
                                                                                  '+ sameProjectTransValue;';
  Script.Add := '        end;';
  Script.Add := '        Post;';

  Script.Add := '        SetIndexOverBudget;';
  Script.Add := '      end;';
  Script.Add := '      Prior;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure CalculationAssignments (method : String);';
  Script.Add := 'var';
  Script.Add := '  oldTransDate : String;';

  Script.Add := '  procedure ValidateOldDate;';
  Script.Add := '  begin';
  Script.Add := '    if budgetSQL.EOF then begin';
  Script.Add := '      oldTransDate := Master.' + txDate + '.AsString;';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      oldTransDate := FormatDateTime (''dd/mm/yyyy'', budgetSQL.FieldByName (''TRANSDATE'') );';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure CalculateBudgetMethodSelection (scriptType, budgetField, actualField : String; masterAccount : String = '''');';
  Script.Add := '  begin';
  Script.Add := '    case method of';
  Script.Add := '      ''AccEach''     : CalculateBudgetAccEach (scriptType, budgetField, actualField, masterAccount);';
  Script.Add := '      ''AccTotal''    : CalculateBudgetAccTotal (scriptType, budgetField, actualField, masterAccount);';
  Script.Add := '      ''PeriodEach''  : CalculateBudgetPeriodEach (scriptType, budgetField, actualField, masterAccount);';
  Script.Add := '      ''PeriodTotal'' : CalculateBudgetPeriodTotal (scriptType, budgetField, actualField, masterAccount);';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure CheckDatasetSimilarity;';

  Script.Add := '    procedure CompareDataset (fieldName : String);';
  Script.Add := '    begin';
  Script.Add := '      if comparatorDataset.FieldByName (fieldName).AsCurrency <> budgetDataset.FieldByName (fieldName).AsCurrency then begin;';
  Script.Add := '        isGranted := False;';
  Script.Add := '        CopyDataset;';
  Script.Add := '        ShowLockingBudgetConfirmation;';
  Script.Add := '        break;';
  Script.Add := '      end;';
  Script.Add := '    end;';

  Script.Add := '  begin';
  Script.Add := '    budgetDataset.First;';
  Script.Add := '    comparatorDataset.First;';
  Script.Add := '    while NOT budgetDataset.EOF do begin';
  Script.Add := '      CompareDataset (''Akun Sisa Budget'');';
  Script.Add := '      CompareDataset (''Dep. Sisa Budget'');';
  Script.Add := '      CompareDataset (''Proyek Sisa Budget'');';
  Script.Add := '      budgetDataset.Next;';
  Script.Add := '      comparatorDataset.Next;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure ClearDataset;';
  Script.Add := '  begin';
  Script.Add := '    comparatorDataset.First;';
  Script.Add := '    while NOT comparatorDataset.EOF do begin';
  Script.Add := '      comparatorDataset.Delete;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure CopyDataset;';
  Script.Add := '  begin';
  Script.Add := '    ClearDataset;';
  Script.Add := '    budgetDataset.First;';
  Script.Add := '    while NOT budgetDataset.EOF do begin';
  Script.Add := '      comparatorDataset.Append;';
  Script.Add := '      comparatorDataset.FieldByName (''Akun Sisa Budget'').AsCurrency   := budgetDataset.FieldByName (''Akun Sisa Budget'').AsCurrency;';
  Script.Add := '      comparatorDataset.FieldByName (''Dep. Sisa Budget'').AsCurrency   := budgetDataset.FieldByName (''Dep. Sisa Budget'').AsCurrency;';
  Script.Add := '      comparatorDataset.FieldByName (''Proyek Sisa Budget'').AsCurrency := budgetDataset.FieldByName (''Proyek Sisa Budget'').AsCurrency;';
  Script.Add := '      comparatorDataset.Post;';
  Script.Add := '      budgetDataset.Next;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure SetDisplayFormat (fieldName : String);';
  Script.Add := '  begin';
  Script.Add := '    TFloatField (budgetDataset.FieldByName (fieldName) ).DisplayFormat := ''#,##0.####'';';
  Script.Add := '  end;';

  Script.Add := 'begin';
  Script.Add := '  budgetSQL := CreateSQL (TIBTransaction (Tx) );';
  Script.Add := '  if (budgetDataset <> nil) then begin';
  Script.Add := '    budgetDataset.Free;';
  Script.Add := '    budgetDataset := nil;';
  Script.Add := '  end;';
  Script.Add := '  budgetDataset := TjvMemoryData.Create (Form);';
  Script.Add := '  try';
  Script.Add := '    with budgetDataset do begin';
  Script.Add := '      FieldDefs.Add (''No.''                   , ftInteger,  0, False);';
  Script.Add := '      FieldDefs.Add (''Expense Detail''        , ftBoolean,  0, False);';
  Script.Add := '      FieldDefs.Add (''Sequence''              , ftInteger,  0, False);';
  Script.Add := '      FieldDefs.Add (''No. Akun''              , ftString , 20, False);';
  Script.Add := '      FieldDefs.Add (''Dep. ID''               , ftInteger,  0, False);';
  Script.Add := '      FieldDefs.Add (''Proyek ID''             , ftInteger,  0, False);';
  Script.Add := '      FieldDefs.Add (''Sorting''               , ftString , 20, False);';
  Script.Add := '      FieldDefs.Add (''Nama Akun''             , ftString , 35, False);';
  Script.Add := '      FieldDefs.Add (''Akun Sisa Budget''      , ftFloat  ,  0, False);';
  Script.Add := '      FieldDefs.Add (''Akun Nilai Transaksi''  , ftFloat  ,  0, False);';
  Script.Add := '      FieldDefs.Add (''Dep. Sisa Budget''      , ftFloat  ,  0, False);';
  Script.Add := '      FieldDefs.Add (''Dep. Nilai Transaksi''  , ftFloat  ,  0, False);';
  Script.Add := '      FieldDefs.Add (''Proyek Sisa Budget''    , ftFloat  ,  0, False);';
  Script.Add := '      FieldDefs.Add (''Proyek Nilai Transaksi'', ftFloat  ,  0, False);';
  Script.Add := '      Open;';

  Script.Add := '      SetDisplayFormat (''Akun Sisa Budget'');';
  Script.Add := '      SetDisplayFormat (''Akun Nilai Transaksi'');';
  Script.Add := '      SetDisplayFormat (''Dep. Sisa Budget'');';
  Script.Add := '      SetDisplayFormat (''Dep. Nilai Transaksi'');';
  Script.Add := '      SetDisplayFormat (''Proyek Sisa Budget'');';
  Script.Add := '      SetDisplayFormat (''Proyek Nilai Transaksi'');';
  Script.Add := '    end;';

  Script.Add := '    isShowConfirmation := False;';

  Script.Add := '    RunSQL (budgetSQL, Format (''SELECT TRANSDATE FROM GLHIST '+
                     'WHERE GLHISTID = %d'', [Master.GLHistID.Value]) );';

  Script.Add := '    ValidateOldDate;';
  Script.Add := '    DecodeDate (StrToDateTime (oldTransDate), oldTransYear, oldTransMonth, oldTransDay);';

  Script.Add := '    DecodeDate (Master.' + txDate + '.Value, transYear, transMonth, transDay);';

  //Calculate Master
  if (formName = 'PI') then begin
    Script.Add := '    if NOT Master.FreightAccnt.IsNull then begin';
    Script.Add := '      CalculateBudgetMethodSelection (''Account'', ''BUDGETAMOUNT'' '+
                         ', ''BASEAMOUNT'', Master.FreightAccnt.AsString);';
    Script.Add := '    end;';
  end
  else if (formName = 'SI') then begin
    Script.Add := '    if NOT Master.FreightAccnt.IsNull then begin';
    Script.Add := '      CalculateBudgetMethodSelection (''Account'', ''BUDGETAMOUNT'', ''BASEAMOUNT'' '+
                         ', Master.FreightAccnt.AsString);';
    Script.Add := '    end;';
  end
  else if (formName = 'JC') then begin
    Script.Add := '    CalculateBudgetMethodSelection (''Account'', ''BUDGETAMOUNT'', ''BASEAMOUNT'' '+
                       ', Master.WIPAccount.AsString);';
  end
  else if (formName = 'IA') then begin
    Script.Add := '    CalculateBudgetMethodSelection (''Account'', ''BUDGETAMOUNT'', ''BASEAMOUNT'' '+
                       ', Master.AdjAccount.AsString);';
  end;

  //Calculate Detail
  Script.Add := '    if (Detail.RecordCount > 0) then begin';
  Script.Add := '      CalculateBudgetMethodSelection (''Account'', ''BUDGETAMOUNT'', ''BASEAMOUNT'');';
  Script.Add := '      CalculateBudgetMethodSelection (''Department'', ''PERIOD'', ''ACTUALBUDGET'');';
  Script.Add := '      CalculateBudgetMethodSelection (''Project'', ''PERIOD'', ''ACTUALBUDGET'');';
  Script.Add := '    end;';

  //Calculate Detail 2
  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    expenseDetail := True;';
    Script.Add := '    CalculateBudgetMethodSelection (''Account'', ''BUDGETAMOUNT'', ''BASEAMOUNT'');';
    Script.Add := '    CalculateBudgetMethodSelection (''Department'', ''PERIOD'', ''ACTUALBUDGET'');';
    Script.Add := '    CalculateBudgetMethodSelection (''Project'', ''PERIOD'', ''ACTUALBUDGET'');';
    Script.Add := '    expenseDetail := False;';
  end;

  Script.Add := '    budgetDataset.SortOnFields (''Sorting'');';
  Script.Add := '    CombineSameAccountNo;';
  Script.Add := '    CalculateRemainBudget;';

  Script.Add := '    if isShowConfirmation then begin';
  Script.Add := '      if isGranted then begin';
  Script.Add := '        CheckDatasetSimilarity;';
  Script.Add := '      end';
  Script.Add := '      else begin';
  Script.Add := '        if (Master.GLHistID.AsString = '''') then begin';
  Script.Add := '          CopyDataset;';
  Script.Add := '          ShowLockingBudgetConfirmation;';
  Script.Add := '        end';
  Script.Add := '        else begin';
//  Script.Add := '          if isModified AND (oldTransDate <> Master.' + txDate + '.AsString) then begin';
  Script.Add := '          if isModified then begin';
  Script.Add := '            RaiseException (''Transaksi tidak dapat disimpan '' + #10#13 + '+
                             ' ''karena tanggal transaksi berubah dan/atau budget terlampaui'');';
  Script.Add := '          end';
  Script.Add := '          else begin';
  Script.Add := '            CopyDataset;';
  Script.Add := '            ShowLockingBudgetConfirmation;';
  Script.Add := '          end;';
  Script.Add := '        end;';
  Script.Add := '      end;';
  Script.Add := '      Detail.Edit;';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    budgetSQL.Free;';
  Script.Add := '    budgetSQL := nil;';
  Script.Add := '  end;';
  Script.Add := 'end;';
end;

procedure TLockingBudgetInjector.GetBaseAndActualBudgetForAccumulationEach (txDate, formName, txID : String);
begin
  Script.Add := '  function GetBudgetActualAccountAccEachStr (masterAccount : String) : String;';
  Script.Add := '  begin';
  Script.Add := '    result := Format (''SELECT BASEAMOUNT%d , BUDGETAMOUNT%d '' '+
                               ', [idxMonthAccumulation, idxMonthAccumulation]);';
  Script.Add := '    result := result + Format (''FROM GLACTUAL GA '+
                               'WHERE GA.GLYEAR = %d '', [transYear]);';

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '    result := result + Format (''AND GA.GLACCOUNT = ''''%s'''' '' '+
                                          ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND GA.GLACCOUNT = ''''%s'''' '' '+
                                            ', [Detail2.GLAccount.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GA.GLACCOUNT = ''''%s'''' '' '+
                                            ', [GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount)]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GA.GLACCOUNT = ''''%s'''' '' '+
                                          ', [GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount)]);';
  end;
  Script.Add := '  end;';

  Script.Add := '  function GetBudgetActualDepartmentAccEachStr : String;';
  Script.Add := '  begin';
  Script.Add := '    result := Format (''SELECT COALESCE (DB.PERIOD%d, 0) PERIOD%d, '' '+
                               ', [idxMonthAccumulation, idxMonthAccumulation]);';
  Script.Add := '    result := result + ''COALESCE ( (SELECT SUM (GH.BASEAMOUNT) FROM GLHIST GH '';';
  Script.Add := '    result := result + Format (''WHERE GH.GLYEAR = %d AND GH.GLPERIOD = %d '+
                                        'AND GH.INVOICEID <> %d '' '+
                                        ', [transYear, idxMonthAccumulation, Master.' + txID + '.AsInteger]);';

  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '    result := result + Format (''AND GH.DEPTID = %d '', [GetID (''DeptID'')]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND GH.DEPTID = %d '', [Detail2.DeptID.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GH.DEPTID = %d '', [Detail.DeptID.Value]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GH.DEPTID = %d '', [Detail.DeptID.Value]);';
  end;

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '    result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                          ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';

    Script.Add := '      result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                            ', [Detail2.GLAccount.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                            ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                          ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
  end;

  Script.Add := '    result := result + ''), 0) ACTUALBUDGET '';';

  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '    result := result + Format (''FROM DEPARTMENTBUDGET DB WHERE DB.GLYEAR = %d '+
                                          'AND DB.DEPTID = %d '', [transYear, GetID (''DeptID'')]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''FROM DEPARTMENTBUDGET DB WHERE DB.GLYEAR = %d AND DB.DEPTID = %d '' '+
                                            ', [transYear, Detail2.DeptID.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''FROM DEPARTMENTBUDGET DB WHERE DB.GLYEAR = %d AND DB.DEPTID = %d '' '+
                                            ', [transYear, Detail.DeptID.Value]);';
    Script.Add := '    end;';
  end
  else begin
  Script.Add := '    result := result + Format (''FROM DEPARTMENTBUDGET DB WHERE DB.GLYEAR = %d '+
                                        'AND DB.DEPTID = %d '', [transYear, Detail.DeptID.Value]);';
  end;

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '    result := result + Format (''AND DB.GLACCOUNT = ''''%s'''' '' '+
                                          ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND DB.GLACCOUNT = ''''%s'''' '' '+
                                            ', [Detail2.GLAccount.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND DB.GLACCOUNT = ''''%s'''' '' '+
                                            ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND DB.GLACCOUNT = ''''%s'''' '' '+
                                          ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
  end;

  Script.Add := '  end;';

  Script.Add := '  function GetBudgetActualProjectAccEachStr : String;';
  Script.Add := '  begin';
  Script.Add := '    result := Format (''SELECT COALESCE (PB.PERIOD%d, 0) PERIOD%d, '' '+
                               ', [idxMonthAccumulation, idxMonthAccumulation]);';
  Script.Add := '    result := result + ''COALESCE ( (SELECT SUM (GH.BASEAMOUNT) FROM GLHIST GH '';';
  Script.Add := '    result := result + Format (''WHERE GH.GLYEAR = %d AND GH.GLPERIOD = %d '+
                                        'AND GH.INVOICEID <> %d '' '+
                                        ', [transYear, idxMonthAccumulation, Master.' + txID + '.AsInteger]);';

  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '    result := result + Format (''AND GH.PROJECTID = %d '', [GetID (''ProjectID'')]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND GH.PROJECTID = %d '', [Detail2.ProjectID.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GH.PROJECTID = %d '', [Detail.ProjectID.Value]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GH.PROJECTID = %d '', [Detail.ProjectID.Value]);';
  end;

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '    result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                          ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                            ', [Detail2.GLAccount.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                            ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                          ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
  end;

  Script.Add := '    result := result + ''), 0) ACTUALBUDGET '';';

  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '    result := result + Format (''FROM PROJECTBUDGET PB WHERE PB.GLYEAR = %d '+
                                          'AND PB.PROJECTID = %d '', [transYear, GetID (''ProjectID'')]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''FROM PROJECTBUDGET PB WHERE PB.GLYEAR = %d '+
                                            'AND PB.PROJECTID = %d '', [transYear, Detail2.ProjectID.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''FROM PROJECTBUDGET PB WHERE PB.GLYEAR = %d '+
                                            'AND PB.PROJECTID = %d '', [transYear, Detail.ProjectID.Value]);';
    Script.Add := '    end;';
  end
  else begin
  Script.Add := '    result := result + Format (''FROM PROJECTBUDGET PB WHERE PB.GLYEAR = %d '+
                                        'AND PB.PROJECTID = %d '', [transYear, Detail.ProjectID.Value]);';
  end;

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '    result := result + Format (''AND PB.GLACCOUNT = ''''%s'''' '' '+
                                          ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND PB.GLACCOUNT = ''''%s'''' '' '+
                                            ', [Detail2.GLAccount.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND PB.GLACCOUNT = ''''%s'''' '' '+
                                            ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND PB.GLACCOUNT = ''''%s'''' '' '+
                                          ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
  end;
  Script.Add := '  end;';

  Script.Add := '  procedure CalculateBudgetAccEach (scriptType, budgetField, actualField, masterAccount : String);';
  Script.Add := '  var';
  Script.Add := '    detailCount : Integer;';

  Script.Add := '  begin';
  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      costSQL := CreateSQL (TIBTransaction (Detail2.Tx) );';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      costSQL := CreateSQL (TIBTransaction (Detail.Tx) );';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    costSQL := CreateSQL (TIBTransaction (Detail.Tx) );';
  end;
  Script.Add := '    try';
  Script.Add := '      budgetRemain := 0;';
  Script.Add := '      totalBudget  := '''';';
  Script.Add := '      totalActual  := '''';';
  Script.Add := '      Detail.First;';
  Script.Add := '      idxAccount := 1;';

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '      if (masterAccount = '''') then begin';
    Script.Add := '        if expenseDetail then begin';
    Script.Add := '          Detail2.First;';
    Script.Add := '          detailCount    := Detail2.RecordCount;';
    Script.Add := '          maxItemAccount := 1;';
    Script.Add := '        end';
    Script.Add := '        else begin';
    Script.Add := '          Detail.First;';
    Script.Add := '          detailCount := Detail.RecordCount;';
    Script.Add := '        end;';
    Script.Add := '      end';
    Script.Add := '      else begin';
    Script.Add := '        detailCount    := 1;';
    Script.Add := '        maxItemAccount := 1;';
    Script.Add := '      end;';
  end
  else begin
    Script.Add := '      if (masterAccount = '''') then begin';
    Script.Add := '        Detail.First;';
    Script.Add := '        detailCount := Detail.RecordCount;';
    Script.Add := '      end';
    Script.Add := '      else begin';
    Script.Add := '        detailCount    := 1;';
    Script.Add := '        maxItemAccount := 1;';
    Script.Add := '      end;';
  end;

  Script.Add := '      for loopDetail := 1 to detailCount do begin';

  if (formName = 'CR') then begin
    Script.Add := '      RunSQL (costSQL, Format (''SELECT COUNT (DISCACCOUNT) COUNTDISCACCOUNT FROM ARINVPMT_DISC '+
                         'WHERE INVPMTID = %d '', [Detail.FieldByName (''InvPmtID'').Value]) );';
    Script.Add := '      maxItemAccount := costSQL.FieldByName (''COUNTDISCACCOUNT'');';
  end;

  if (formName = 'SI') OR (formName = 'PI')
  OR (formName = 'IA') OR (formName = 'JC') OR (formName = 'CR') then begin
    Script.Add := '          for idxAccount := 1 to maxItemAccount do begin';
  end;

  Script.Add := '            if (scriptType = ''Department'') then begin';
  Script.Add := '              if NOT expenseDetail then begin';
  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '                if (GetID (''DeptID'') = 0) then begin';
  end
  else begin
    Script.Add := '                if Detail.DeptID.Isnull then begin';
  end;
  Script.Add := '                  Detail.Next;';
  Script.Add := '                  Continue;';
  Script.Add := '                end;';
  Script.Add := '              end;';

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '              if expenseDetail then begin';
    Script.Add := '                if Detail2.DeptID.Isnull then begin';
    Script.Add := '                  Detail2.Next;';
    Script.Add := '                  Continue;';
    Script.Add := '                end;';
    Script.Add := '              end;';
  end;
  Script.Add := '            end;';

  Script.Add := '            if (scriptType = ''Project'') then begin';
  Script.Add := '              if NOT expenseDetail then begin';
  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '                if (GetID (''ProjectID'') = 0) then begin';
  end
  else begin
    Script.Add := '                if Detail.ProjectID.Isnull then begin';
  end;
  Script.Add := '                  Detail.Next;';
  Script.Add := '                  Continue;';
  Script.Add := '                end;';
  Script.Add := '              end;';

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '              if expenseDetail then begin';
    Script.Add := '                if Detail2.ProjectID.Isnull then begin';
    Script.Add := '                  Detail2.Next;';
    Script.Add := '                  Continue;';
    Script.Add := '                end;';
    Script.Add := '              end;';
  end;
  Script.Add := '            end;';

  Script.Add := '            for idxMonthAccumulation := 1 to transMonth do begin';
  Script.Add := '              if (scriptType = ''Account'') then begin';
  Script.Add := '                RunSQL (budgetSQL, GetBudgetActualAccountAccEachStr (masterAccount) );';
  Script.Add := '              end;';

  Script.Add := '              if (scriptType = ''Department'') then begin';
  Script.Add := '                RunSQL (budgetSQL, GetBudgetActualDepartmentAccEachStr);';
  Script.Add := '              end;';

  Script.Add := '              if (scriptType = ''Project'') then begin';
  Script.Add := '                RunSQL (budgetSQL, GetBudgetActualProjectAccEachStr);';
  Script.Add := '              end;';

  Script.Add := '              if budgetSQL.EOF then begin';
  Script.Add := '                budgetRemain := 0;';
  Script.Add := '                totalBudget  := '''';';
  Script.Add := '                totalActual  := '''';';
  Script.Add := '              end';
  Script.Add := '              else begin';
  Script.Add := '                totalBudget := CurrToStrSQL (budgetSQL.FieldByName (budgetField + IntToStr(idxMonthAccumulation) ) );';
  Script.Add := '                if (scriptType = ''Account'') then begin';
  Script.Add := '                  totalActual := CurrToStrSQL (budgetSQL.FieldByName (actualField + IntToStr (idxMonthAccumulation) ) );';
  Script.Add := '                end';
  Script.Add := '                else begin';
  Script.Add := '                  totalActual := CurrToStrSQL (budgetSQL.FieldByName (actualField) );';
  Script.Add := '                end;';

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '                totalActual := CurrToStrSQL (NormalizeAccount (Detail.GLAccount.Value) * StrSQLTOCurr (totalActual) );';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '                if expenseDetail then begin';
    Script.Add := '                  totalActual := CurrToStrSQL (NormalizeAccount (Detail2.GLAccount.Value) * StrSQLTOCurr (totalActual) );';
    Script.Add := '                end';
    Script.Add := '                else begin';
    Script.Add := '                  totalActual := CurrToStrSQL (NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * StrSQLTOCurr (totalActual) );';
    Script.Add := '                end;';
  end
  else begin
    Script.Add := '                totalActual := CurrToStrSQL (NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * StrSQLTOCurr (totalActual) );';
  end;

  Script.Add := '                if (scriptType = ''Account'') then begin';
  Script.Add := '                  RunSQL (budgetSQL, GetOldActualBudgetTransactionBeforeEdit (masterAccount) );';

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '                  totalActual := CurrToStrSQL (StrSQLtoCurr (totalActual) '+
                                                    '- NormalizeAccount (Detail.GLAccount.Value) * StrSQLTOCurr (budgetSQL.FieldByName (''BASEAMOUNT'') ) );';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '                  if expenseDetail then begin';
    Script.Add := '                    totalActual := CurrToStrSQL (StrSQLtoCurr (totalActual) '+
                                                      '- NormalizeAccount (Detail2.GLAccount.Value) * StrSQLTOCurr (budgetSQL.FieldByName (''BASEAMOUNT'') ) );';
    Script.Add := '                  end';
    Script.Add := '                  else begin';
    Script.Add := '                    totalActual := CurrToStrSQL (StrSQLtoCurr (totalActual) '+
                                                      '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * StrSQLTOCurr (budgetSQL.FieldByName (''BASEAMOUNT'') ) );';
    Script.Add := '                  end;';
  end
  else begin
    Script.Add := '                  totalActual := CurrToStrSQL (StrSQLtoCurr (totalActual) '+
                                                    '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * StrSQLTOCurr (budgetSQL.FieldByName (''BASEAMOUNT'') ) );';
  end;
  Script.Add := '                end;';
  Script.Add := '              end;';

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '              if (budgetRemain > 0) AND (idxMonthAccumulation < transMonth) then begin';
//    Script.Add := '                budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) + budgetRemain '+
//                                                   '- NormalizeAccount (Detail.GLAccount.Value) * GetOtherTotalTransIfAccountSame (masterAccount);';
    Script.Add := '                budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) + budgetRemain;';
    Script.Add := '              end';
    Script.Add := '              else begin';
//    Script.Add := '                budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) '+
//                                                   '- NormalizeAccount (Detail.GLAccount.Value) * GetOtherTotalTransIfAccountSame (masterAccount);';
    Script.Add := '                budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual);';
    Script.Add := '              end;';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '              if expenseDetail then begin';
    Script.Add := '                if (budgetRemain > 0) AND (idxMonthAccumulation < transMonth) then begin';
//    Script.Add := '                  budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) + budgetRemain '+
//                                                     '- NormalizeAccount (Detail2.GLAccount.Value) * GetOtherTotalTransIfAccountSame (masterAccount);';
    Script.Add := '                  budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) + budgetRemain;';
    Script.Add := '                end';
    Script.Add := '                else begin';
//    Script.Add := '                  budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) '+
//                                                     '- NormalizeAccount (Detail2.GLAccount.Value) * GetOtherTotalTransIfAccountSame (masterAccount);';
    Script.Add := '                  budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual);';
    Script.Add := '                end;';
    Script.Add := '              end';
    Script.Add := '              else begin';
    Script.Add := '                if (budgetRemain > 0) AND (idxMonthAccumulation < transMonth) then begin';
//    Script.Add := '                  budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) + budgetRemain '+
//                                                     '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * GetOtherTotalTransIfAccountSame (masterAccount);';
    Script.Add := '                  budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) + budgetRemain;';
    Script.Add := '                end';
    Script.Add := '                else begin';
//    Script.Add := '                  budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) '+
//                                                     '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * GetOtherTotalTransIfAccountSame (masterAccount);';
    Script.Add := '                  budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual);';
    Script.Add := '                end;';
    Script.Add := '              end;';
  end
  else begin
    Script.Add := '              if (budgetRemain > 0) AND (idxMonthAccumulation < transMonth) then begin';
//    Script.Add := '                budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) + budgetRemain '+
//                                                   '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * GetOtherTotalTransIfAccountSame (masterAccount, idxAccount);';
    Script.Add := '                budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) + budgetRemain;';
    Script.Add := '              end';
    Script.Add := '              else begin';
//    Script.Add := '                budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) '+
//                                                   '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * GetOtherTotalTransIfAccountSame (masterAccount, idxAccount);';
    Script.Add := '                budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual);';
    Script.Add := '              end;';
  end;
  Script.Add := '            end;';

  Script.Add := '            CalculateActualAmount (masterAccount);';

//  Script.Add := '            if (totalBudget <> ''0'') AND (totalBudget <> '''') then begin';
//  Script.Add := '              if ( (budgetRemain - actualAmount) < 0) AND (actualAmount > 0) then begin';
//  Script.Add := '                isShowConfirmation := True;';
//  Script.Add := '              end;';
//  Script.Add := '            end;';

  Script.Add := '          SaveCalculationBudget (scriptType, masterAccount);';

  if (formName = 'SI') OR (formName = 'PI')
  OR (formName = 'IA') OR (formName = 'JC') OR (formName = 'CR') then begin
    Script.Add := '          end;';
  end;

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '        if expenseDetail then begin';
    Script.Add := '          Detail2.Next;';
    Script.Add := '        end';
    Script.Add := '        else begin';
    Script.Add := '          Detail.Next;';
    Script.Add := '        end;';
  end
  else begin
    Script.Add := '        Detail.Next;';
  end;

  Script.Add := '      end;';
  Script.Add := '    finally';
  Script.Add := '      costSQL.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '';
  Script.Add := 'procedure GetBaseAndActualBudgetForAccumulationEach (method : String);';
  Script.Add := 'begin';
  Script.Add := '  CalculationAssignments (method);';
  Script.Add := 'end;';
end;

procedure TLockingBudgetInjector.GetBaseAndActualBudgetForAccumulationTotal (txDate, formName, txID : String);
begin

  Script.Add := '  function GetSumOfFieldAccTotal (field, alias : String) : String;';
  Script.Add := '  begin';
  Script.Add := '    result := Format (''COALESCE (SUM (%s%d), 0) %s%d '' '+
                               ', [field, idxMonthAccumulation, alias, idxMonthAccumulation]);';
  Script.Add := '  end;';

  Script.Add := '  function GetBudgetActualAccountAccTotalStr (masterAccount : String) : String;';
  Script.Add := '  begin';
  Script.Add := '    result := ''SELECT '';';
  Script.Add := '    result := result + GetSumOfFieldAccTotal (''BASEAMOUNT'', ''BASEAMOUNT'') + '', '';';
  Script.Add := '    result := result + GetSumOfFieldAccTotal (''BUDGETAMOUNT'', ''BUDGETAMOUNT'');';
  Script.Add := '    result := result + Format (''FROM GLACTUAL '+
                               'WHERE GLYEAR = %d '', [transYear]);';
  Script.Add := '    result := result + Format (''AND GLACCOUNT IN (%s) '' '+
                                        ', [sameParentAccount]);';
  Script.Add := '  end;';

  Script.Add := '  function GetBudgetActualDepartmentAccTotalStr : String;';
  Script.Add := '  begin';
  Script.Add := '    result := ''SELECT '';';
  Script.Add := '    result := result + GetSumOfFieldAccTotal (''PERIOD'', ''PERIOD'') + '', '';';
  Script.Add := '    result := result + ''COALESCE ( (SELECT SUM (GH.BASEAMOUNT) FROM GLHIST GH '';';
  Script.Add := '    result := result + Format (''WHERE GH.GLYEAR = %d AND GH.GLPERIOD = %d '+
                                        'AND GH.INVOICEID <> %d '' '+
                                        ', [transYear, idxMonthAccumulation, Master.' + txID + '.AsInteger]);';
  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '    result := result + Format (''AND GH.DEPTID = %d '', [GetID (''DeptID'')]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND GH.DEPTID = %d '', [Detail2.DeptID.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GH.DEPTID = %d '', [Detail.DeptID.Value]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GH.DEPTID = %d '', [Detail.DeptID.Value]);';
  end;
  Script.Add := '    result := result + Format (''AND GH.GLACCOUNT IN (%s) '' '+
                                        ', [sameParentAccount]);';
  Script.Add := '    result := result + ''), 0) ACTUALBUDGET '';';

  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '    result := result + Format (''FROM DEPARTMENTBUDGET DB WHERE DB.GLYEAR = %d '+
                                          'AND DB.DEPTID = %d '', [transYear, GetID (''DeptID'')]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''FROM DEPARTMENTBUDGET DB WHERE DB.GLYEAR = %d AND DB.DEPTID = %d '' '+
                                            ', [transYear, Detail2.DeptID.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''FROM DEPARTMENTBUDGET DB WHERE DB.GLYEAR = %d AND DB.DEPTID = %d '' '+
                                            ', [transYear, Detail.DeptID.Value]);';
    Script.Add := '    end;';
  end
  else begin
  Script.Add := '    result := result + Format (''FROM DEPARTMENTBUDGET DB WHERE DB.GLYEAR = %d '+
                                        'AND DB.DEPTID = %d '', [transYear, Detail.DeptID.Value]);';
  end;
  Script.Add := '    result := result + Format (''AND DB.GLACCOUNT IN (%s) '' '+
                                        ', [sameParentAccount]);';
  Script.Add := '  end;';

  Script.Add := '  function GetBudgetActualProjectAccTotalStr : String;';
  Script.Add := '  begin';
  Script.Add := '    result := ''SELECT '';';
  Script.Add := '    result := result + GetSumOfFieldAccTotal (''PERIOD'', ''PERIOD'') + '', '';';
  Script.Add := '    result := result + ''COALESCE ( (SELECT SUM (GH.BASEAMOUNT) FROM GLHIST GH '';';
  Script.Add := '    result := result + Format (''WHERE GH.GLYEAR = %d AND GH.GLPERIOD = %d '+
                                        'AND GH.INVOICEID <> %d '' '+
                                        ', [transYear, idxMonthAccumulation, Master.' + txID + '.AsInteger]);';
  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '    result := result + Format (''AND GH.PROJECTID = %d '', [GetID (''ProjectID'')]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND GH.PROJECTID = %d '', [Detail2.ProjectID.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GH.PROJECTID = %d '', [Detail.ProjectID.Value]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GH.PROJECTID = %d '', [Detail.ProjectID.Value]);';
  end;
  Script.Add := '    result := result + Format (''AND GH.GLACCOUNT IN (%s) '' '+
                                        ', [sameParentAccount]);';
  Script.Add := '    result := result + ''), 0) ACTUALBUDGET '';';

  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '    result := result + Format (''FROM PROJECTBUDGET PB WHERE PB.GLYEAR = %d '+
                                          'AND PB.PROJECTID = %d '', [transYear, GetID (''ProjectID'')]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''FROM PROJECTBUDGET PB WHERE PB.GLYEAR = %d '+
                                            'AND PB.PROJECTID = %d '', [transYear, Detail2.ProjectID.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''FROM PROJECTBUDGET PB WHERE PB.GLYEAR = %d '+
                                            'AND PB.PROJECTID = %d '', [transYear, Detail.ProjectID.Value]);';
    Script.Add := '    end;';
  end
  else begin
  Script.Add := '    result := result + Format (''FROM PROJECTBUDGET PB WHERE PB.GLYEAR = %d '+
                                        'AND PB.PROJECTID = %d '', [transYear, Detail.ProjectID.Value]);';
  end;
  Script.Add := '    result := result + Format (''AND PB.GLACCOUNT IN (%s) '' '+
                                        ', [sameParentAccount]);';
  Script.Add := '  end;';

  Script.Add := '  procedure CalculateBudgetAccTotal (scriptType, budgetField, actualField, masterAccount : String);';
  Script.Add := '  var';
  Script.Add := '    parentAccount     : String;';
  Script.Add := '    idxParent         : Integer;';
  Script.Add := '    parentAccountList : TStringList;';
  Script.Add := '    GLAmountList      : TStringList;';
  Script.Add := '    accountStr        : String;';
  Script.Add := '    detailCount       : Integer;';
  Script.Add := '    idxLockingAccount : Integer;';

  Script.Add := '  begin';
  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      costSQL := CreateSQL (TIBTransaction (Detail2.Tx) );';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      costSQL := CreateSQL (TIBTransaction (Detail.Tx) );';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    costSQL := CreateSQL (TIBTransaction (Detail.Tx) );';
  end;
  Script.Add := '    lockingINI        := TINIFile.Create (ExtractFilePath (Application.Exename) '+
                                          '+ ''LockingBudgetSetting.ini'');';
  Script.Add := '    parentAccountList := TStringList.Create;';
  Script.Add := '    GLAmountList      := TStringList.Create;';

  Script.Add := '    try';
  Script.Add := '      budgetRemain := 0;';
  Script.Add := '      totalBudget  := '''';';
  Script.Add := '      totalActual  := '''';';
  Script.Add := '      parentAccountList.Clear;';
  Script.Add := '      GLAmountList.Clear;';
  Script.Add := '      idxAccount := 1;';

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '      if (masterAccount = '''') then begin';
    Script.Add := '        if expenseDetail then begin';
    Script.Add := '          Detail2.First;';
    Script.Add := '          detailCount    := Detail2.RecordCount;';
    Script.Add := '          maxItemAccount := 1;';
    Script.Add := '        end';
    Script.Add := '        else begin';
    Script.Add := '          Detail.First;';
    Script.Add := '          detailCount := Detail.RecordCount;';
    Script.Add := '        end;';
    Script.Add := '      end';
    Script.Add := '      else begin';
    Script.Add := '        detailCount    := 1;';
    Script.Add := '        maxItemAccount := 1;';
    Script.Add := '      end;';
  end
  else begin
    Script.Add := '      if (masterAccount = '''') then begin';
    Script.Add := '        Detail.First;';
    Script.Add := '        detailCount := Detail.RecordCount;';
    Script.Add := '      end';
    Script.Add := '      else begin';
    Script.Add := '        detailCount    := 1;';
    Script.Add := '        maxItemAccount := 1;';
    Script.Add := '      end;';
  end;

  Script.Add := '      for loopDetail := 1 to detailCount do begin';

  if (formName = 'CR') then begin
    Script.Add := '      RunSQL (costSQL, Format (''SELECT COUNT (DISCACCOUNT) COUNTDISCACCOUNT FROM ARINVPMT_DISC '+
                         'WHERE INVPMTID = %d '', [Detail.FieldByName (''InvPmtID'').Value]) );';
    Script.Add := '      maxItemAccount := costSQL.FieldByName (''COUNTDISCACCOUNT'');';
  end;

  if (formName = 'SI') OR (formName = 'PI')
  OR (formName = 'IA') OR (formName = 'JC') OR (formName = 'CR') then begin
    Script.Add := '        for idxAccount := 1 to maxItemAccount do begin';
  end;

  Script.Add := '            if (scriptType = ''Account'') then begin';
  Script.Add := '              if NOT lockingINI.ReadBool (''LOCKING_CATEGORIES'', ''AccountBudget'', False) then begin';
  Script.Add := '                Continue;';
  Script.Add := '              end;';
  Script.Add := '            end;';

  Script.Add := '            if (scriptType = ''Department'') then begin';
  Script.Add := '              if lockingINI.ReadBool (''LOCKING_CATEGORIES'', ''Department'', False) then begin';
  Script.Add := '                if NOT expenseDetail then begin';
  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '                  if (GetID (''DeptID'') = 0) then begin';
  end
  else begin
    Script.Add := '                  if Detail.DeptID.Isnull then begin';
  end;
  Script.Add := '                    Detail.Next;';
  Script.Add := '                    Continue;';
  Script.Add := '                  end;';
  Script.Add := '                end;';

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '                if expenseDetail then begin';
    Script.Add := '                  if Detail2.DeptID.Isnull then begin';
    Script.Add := '                    Detail2.Next;';
    Script.Add := '                    Continue;';
    Script.Add := '                  end;';
    Script.Add := '                end;';
  end;
  Script.Add := '              end';
  Script.Add := '              else begin';
  Script.Add := '                Continue;';
  Script.Add := '              end;';
  Script.Add := '            end;';

  Script.Add := '            if (scriptType = ''Project'') then begin';
  Script.Add := '              if lockingINI.ReadBool (''LOCKING_CATEGORIES'', ''Project'', False) then begin';
  Script.Add := '                if NOT expenseDetail then begin';
  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '                  if (GetID (''ProjectID'') = 0) then begin';
  end
  else begin
    Script.Add := '                  if Detail.ProjectID.Isnull then begin';
  end;
  Script.Add := '                    Detail.Next;';
  Script.Add := '                    Continue;';
  Script.Add := '                  end;';
  Script.Add := '                end;';

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '                if expenseDetail then begin';
    Script.Add := '                  if Detail2.ProjectID.Isnull then begin';
    Script.Add := '                    Detail2.Next;';
    Script.Add := '                    Continue;';
    Script.Add := '                  end;';
    Script.Add := '                end;';
  end;
  Script.Add := '              end';
  Script.Add := '              else begin';
  Script.Add := '                Continue;';
  Script.Add := '              end;';
  Script.Add := '            end;';

  Script.Add := '          accountStr := ''SELECT COALESCE (PARENTACCOUNT, '''''''') PARENTACCOUNT FROM GLACCNT '';';
  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '          accountStr := accountStr + Format (''WHERE GLACCOUNT = ''''%s'''' '' '+
                                                        ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '          if expenseDetail then begin';
    Script.Add := '            accountStr := accountStr + Format (''WHERE GLACCOUNT = ''''%s'''' '' '+
                                                          ', [Detail2.GLAccount.Value]);';

    Script.Add := '          end';
    Script.Add := '          else begin';
    Script.Add := '            accountStr := accountStr + Format (''WHERE GLACCOUNT = ''''%s'''' '' '+
                                                          ', [GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount)]);';
    Script.Add := '          end;';
  end
  else begin
    Script.Add := '          accountStr := accountStr + Format (''WHERE GLACCOUNT = ''''%s'''' '' '+
                                                        ', [GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount)]);';
  end;
  Script.Add := '          RunSQL (budgetSQL, accountStr);';
  Script.Add := '          parentAccount  := budgetSQL.FieldByName (''PARENTACCOUNT'');';
  Script.Add := '          lockingAccount := lockingINI.ReadString (''LOCKING_ACCOUNT'', ''BudgetLocking'', '''');';
  Script.Add := '          sameParentAccount  := '''';';
  Script.Add := '          for idxLockingAccount := 1 to CountToken (lockingAccount, ''&'') do begin';
  Script.Add := '            RunSQL (budgetSQL, Format (''SELECT GLACCOUNT FROM GLACCNT '+
                             'WHERE GLACCOUNT = ''''%s'''' AND PARENTACCOUNT = ''''%s'''' '' '+
                             ', [GetToken (lockingAccount, ''&'', idxLockingAccount), parentAccount]) );';
  Script.Add := '            if NOT budgetSQL.EOF then begin;';
  Script.Add := '              sameParentAccount := sameParentAccount + '''''''' '+
                                                    '+ budgetSQL.FieldByName (''GLACCOUNT'') + '''''', '';';
  Script.Add := '            end;';
  Script.Add := '          end;';
  Script.Add := '          sameParentAccount := Copy (sameParentAccount, 1, (Length (sameParentAccount) - 2) );';  //Delete comma di paling kanan
  Script.Add := '          if (sameParentAccount = '''') then begin';
  Script.Add := '            sameParentAccount := '''''''''''';';
  Script.Add := '          end;';

  Script.Add := '          for idxMonthAccumulation := 1 to transMonth do begin';
  Script.Add := '            if (scriptType = ''Account'') then begin';
  Script.Add := '              if lockingINI.ReadBool (''LOCKING_CATEGORIES'', ''AccountBudget'', False) then begin';
  Script.Add := '                RunSQL (budgetSQL, GetBudgetActualAccountAccTotalStr (masterAccount) );';
  Script.Add := '              end';
  Script.Add := '              else begin';
  Script.Add := '                Continue;';
  Script.Add := '              end;';
  Script.Add := '            end;';

  Script.Add := '            if (scriptType = ''Department'') then begin';
  Script.Add := '              if lockingINI.ReadBool (''LOCKING_CATEGORIES'', ''Department'', False) then begin';
  Script.Add := '                if NOT expenseDetail then begin';
  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '                  if (GetID (''DeptID'') = 0) then begin';
  end
  else begin
    Script.Add := '                  if Detail.DeptID.Isnull then begin';
  end;
  Script.Add := '                    Detail.Next;';
  Script.Add := '                    Continue;';
  Script.Add := '                  end;';
  Script.Add := '                end;';

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '                if expenseDetail then begin';
    Script.Add := '                  if Detail2.DeptID.Isnull then begin';
    Script.Add := '                    Detail2.Next;';
    Script.Add := '                    Continue;';
    Script.Add := '                  end;';
    Script.Add := '                end;';
  end;
  Script.Add := '                RunSQL (budgetSQL, GetBudgetActualDepartmentAccTotalStr);';
  Script.Add := '              end';
  Script.Add := '              else begin';
  Script.Add := '                Continue;';
  Script.Add := '              end;';
  Script.Add := '            end;';

  Script.Add := '            if (scriptType = ''Project'') then begin';
  Script.Add := '              if lockingINI.ReadBool (''LOCKING_CATEGORIES'', ''Project'', False) then begin';
  Script.Add := '                if NOT expenseDetail then begin';
  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '                  if (GetID (''ProjectID'') = 0) then begin';
  end
  else begin
    Script.Add := '                  if Detail.ProjectID.Isnull then begin';
  end;
  Script.Add := '                    Detail.Next;';
  Script.Add := '                    Continue;';
  Script.Add := '                  end;';
  Script.Add := '                end;';

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '                if expenseDetail then begin';
    Script.Add := '                  if Detail2.ProjectID.Isnull then begin';
    Script.Add := '                    Detail2.Next;';
    Script.Add := '                    Continue;';
    Script.Add := '                  end;';
    Script.Add := '                end;';
  end;
  Script.Add := '                RunSQL (budgetSQL, GetBudgetActualProjectAccTotalStr);';
  Script.Add := '              end';
  Script.Add := '              else begin';
  Script.Add := '                Continue;';
  Script.Add := '              end;';
  Script.Add := '            end;';

  Script.Add := '            if budgetSQL.EOF then begin';
  Script.Add := '              budgetRemain := 0;';
  Script.Add := '              totalBudget  := '''';';
  Script.Add := '              totalActual  := '''';';
  Script.Add := '            end';
  Script.Add := '            else begin';
  Script.Add := '              totalBudget := CurrToStrSQL (budgetSQL.FieldByName (budgetField '+
                                              '+ IntToStr (idxMonthAccumulation) ) );';

  Script.Add := '              for idxParent := 0 to (parentAccountList.Count - 1) do begin';
  Script.Add := '                if (parentAccountList[idxParent] = parentAccount) then begin';
  Script.Add := '                  totalBudget := CurrToStrSQL (StrSQLToCurr (totalBudget) '+
                                                  '- StrSQLToCurr (GLAmountList[idxParent]) );';
  Script.Add := '                end;';
  Script.Add := '              end;';

  Script.Add := '              if (scriptType = ''Account'') then begin';
  Script.Add := '                totalActual := CurrToStrSQL (budgetSQL.FieldByName (actualField + IntToStr (idxMonthAccumulation) ) );';
  Script.Add := '              end';
  Script.Add := '              else begin';
  Script.Add := '                totalActual := CurrToStrSQL (budgetSQL.FieldByName (actualField) );';
  Script.Add := '              end;';

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '              totalActual := CurrToStrSQL (NormalizeAccount (Detail.GLAccount.Value) * StrSQLTOCurr (totalActual) );';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '              if expenseDetail then begin';
    Script.Add := '                totalActual := CurrToStrSQL (NormalizeAccount (Detail2.GLAccount.Value) * StrSQLTOCurr (totalActual) );';
    Script.Add := '              end';
    Script.Add := '              else begin';
    Script.Add := '                totalActual := CurrToStrSQL (NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * StrSQLTOCurr (totalActual) );';
    Script.Add := '              end;';
  end
  else begin
    Script.Add := '              totalActual := CurrToStrSQL (NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * StrSQLTOCurr (totalActual) );';
  end;

  Script.Add := '              if (scriptType = ''Account'') then begin';
  Script.Add := '                RunSQL (budgetSQL, GetOldActualBudgetTransactionBeforeEdit (masterAccount) );';

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '                totalActual := CurrToStrSQL (StrSQLtoCurr (totalActual) '+
                                                  '- NormalizeAccount (Detail.GLAccount.Value) * StrSQLTOCurr (budgetSQL.FieldByName (''BASEAMOUNT'') ) );';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '                if expenseDetail then begin';
    Script.Add := '                  totalActual := CurrToStrSQL (StrSQLtoCurr (totalActual) '+
                                                    '- NormalizeAccount (Detail2.GLAccount.Value) * StrSQLTOCurr (budgetSQL.FieldByName (''BASEAMOUNT'') ) );';
    Script.Add := '                end';
    Script.Add := '                else begin';
    Script.Add := '                  totalActual := CurrToStrSQL (StrSQLtoCurr (totalActual) '+
                                                    '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * StrSQLTOCurr (budgetSQL.FieldByName (''BASEAMOUNT'') ) );';
    Script.Add := '                end;';
  end
  else begin
    Script.Add := '                totalActual := CurrToStrSQL (StrSQLtoCurr (totalActual) '+
                                                  '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * StrSQLTOCurr (budgetSQL.FieldByName (''BASEAMOUNT'') ) );';
  end;
  Script.Add := '              end;';
  Script.Add := '            end;';

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '            if (budgetRemain > 0) AND (idxMonthAccumulation < transMonth) then begin';
//    Script.Add := '              budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) + budgetRemain '+
//                                                 '- NormalizeAccount (Detail.GLAccount.Value) * GetOtherTotalTransIfAccountSame (masterAccount);';
    Script.Add := '              budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) + budgetRemain;';
    Script.Add := '            end';
    Script.Add := '            else begin';
//    Script.Add := '              budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) '+
//                                                 '- NormalizeAccount (Detail.GLAccount.Value) * GetOtherTotalTransIfAccountSame (masterAccount);';
    Script.Add := '              budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual);';
    Script.Add := '            end;';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '            if expenseDetail then begin';
    Script.Add := '              if (budgetRemain > 0) AND (idxMonthAccumulation < transMonth) then begin';
//    Script.Add := '                budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) + budgetRemain '+
//                                                   '- NormalizeAccount (Detail2.GLAccount.Value) * GetOtherTotalTransIfAccountSame (masterAccount);';
    Script.Add := '                budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) + budgetRemain;';
    Script.Add := '              end';
    Script.Add := '              else begin';
//    Script.Add := '                budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) '+
//                                                   '- NormalizeAccount (Detail2.GLAccount.Value) * GetOtherTotalTransIfAccountSame (masterAccount);';
    Script.Add := '                budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual);';
    Script.Add := '              end;';

    Script.Add := '            end';
    Script.Add := '            else begin';
    Script.Add := '              if (budgetRemain > 0) AND (idxMonthAccumulation < transMonth) then begin';
//    Script.Add := '                budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) + budgetRemain '+
//                                                   '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * GetOtherTotalTransIfAccountSame (masterAccount);';
    Script.Add := '                budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) + budgetRemain;';
    Script.Add := '              end';
    Script.Add := '              else begin';
//    Script.Add := '                budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) '+
//                                                   '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * GetOtherTotalTransIfAccountSame (masterAccount);';
    Script.Add := '                budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual);';
    Script.Add := '              end;';
    Script.Add := '            end;';
  end
  else begin
    Script.Add := '            if (budgetRemain > 0) AND (idxMonthAccumulation < transMonth) then begin';
//    Script.Add := '              budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) + budgetRemain '+
//                                                 '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * GetOtherTotalTransIfAccountSame (masterAccount, idxAccount);';
    Script.Add := '              budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) + budgetRemain;';
    Script.Add := '            end';
    Script.Add := '            else begin';
//    Script.Add := '              budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) '+
//                                                 '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * GetOtherTotalTransIfAccountSame (masterAccount, idxAccount);';
    Script.Add := '              budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual);';
    Script.Add := '            end;';
  end;
  Script.Add := '          end;';

  Script.Add := '          CalculateActualAmount (masterAccount);';

//  Script.Add := '          if (totalBudget <> ''0'') AND (totalBudget <> '''') then begin';
//  Script.Add := '            if ( (budgetRemain - actualAmount) < 0) AND (actualAmount > 0) then begin';
//  Script.Add := '              isShowConfirmation := True;';
//  Script.Add := '            end;';
//  Script.Add := '          end;';

  Script.Add := '          parentAccountList.Add (parentAccount);';
  Script.Add := '          GLAmountList.Add (CurrToStrSQL (actualAmount) );';

  Script.Add := '          SaveCalculationBudget (scriptType, masterAccount);';

  if (formName = 'SI') OR (formName = 'PI')
  OR (formName = 'IA') OR (formName = 'JC') OR (formName = 'CR') then begin
    Script.Add := '        end;';
  end;

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '        if expenseDetail then begin';
    Script.Add := '          Detail2.Next;';
    Script.Add := '        end';
    Script.Add := '        else begin';
    Script.Add := '          Detail.Next;';
    Script.Add := '        end;';
  end
  else begin
    Script.Add := '        Detail.Next;';
  end;

  Script.Add := '      end;';
  Script.Add := '    finally';
  Script.Add := '      costSQL.Free;';
  Script.Add := '      lockingINI.Free;';
  Script.Add := '      parentAccountList.Free;';
  Script.Add := '      GLAmountList.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '';
  Script.Add := 'procedure GetBaseAndActualBudgetForAccumulationTotal (method : String);';
  Script.Add := 'begin';
  Script.Add := '  CalculationAssignments (method);';
  Script.Add := 'end;';
end;

procedure TLockingBudgetInjector.GetBaseAndActualBudgetForPeriodEach (txDate, formName, txID : String);
begin

  Script.Add := '  function GetBudgetActualAccountPeriodEachStr (masterAccount : String) : String;';
  Script.Add := '  begin';
//  Script.Add := '    result := Format (''SELECT GA.BASEAMOUNT%d '', [oldTransMonth]);';

  Script.Add := '    result := ''SELECT COALESCE ( (SELECT SUM (GH.BASEAMOUNT) FROM GLHIST GH '';';
  Script.Add := '    result := result + Format (''WHERE ( (GH.GLYEAR = %d AND GH.GLPERIOD = %d AND GH.INVOICEID <> %d) '+
                                        'OR (GH.GLYEAR = %d AND GH.GLPERIOD = %d AND GH.INVOICEID = %d) ) '' '+
                                        ', [transYear, transMonth, Master.' + txID + '.AsInteger '+
                                        ', oldTransYear, oldTransMonth, Master.' + txID + '.AsInteger]);';

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '    result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                          ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                            ', [Detail2.GLAccount.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                            ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                          ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
  end;
  Script.Add := '    result := result + Format (''), 0) BASEAMOUNT%d'', [oldTransMonth]);';

  Script.Add := '    result := result + Format ('', GA.BUDGETAMOUNT%d FROM GLACTUAL GA '' '+
                                        ', [transMonth]);';
  Script.Add := '    result := result + Format (''WHERE GA.GLYEAR = %d '', [transYear]);';

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '    result := result + Format (''AND GA.GLACCOUNT = ''''%s'''' '' '+
                                          ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND GA.GLACCOUNT = ''''%s'''' '' '+
                                            ', [Detail2.GLAccount.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GA.GLACCOUNT = ''''%s'''' '' '+
                                            ', [GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount)]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GA.GLACCOUNT = ''''%s'''' '' '+
                                          ', [GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount)]);';
  end;
  Script.Add := '  end;';

  Script.Add := '  function GetBudgetActualDepartmentPeriodEachStr : String;';
  Script.Add := '  begin';
  Script.Add := '    result := Format (''SELECT COALESCE (PERIOD%d, 0) PERIOD%d, '', [transMonth, transMonth]);';
//  Script.Add := '    result := result + ''COALESCE ( (SELECT SUM (GH.BASEAMOUNT) FROM GLHIST GH '';';
//  Script.Add := '    result := result + Format (''WHERE GH.GLYEAR = %d AND GH.GLPERIOD = %d '+
//                                        'AND GH.INVOICEID <> %d '' '+
//                                        ', [{oldTransYear} transYear, {oldTransMonth} transMonth, Master.' + txID + '.AsInteger]);';

  Script.Add := '    result := result + ''COALESCE ( (SELECT SUM (GH.BASEAMOUNT) FROM GLHIST GH '';';
  Script.Add := '    result := result + Format (''WHERE ( (GH.GLYEAR = %d AND GH.GLPERIOD = %d AND GH.INVOICEID <> %d) '+
                                        'OR (GH.GLYEAR = %d AND GH.GLPERIOD = %d AND GH.INVOICEID = %d) ) '' '+
                                        ', [transYear, transMonth, Master.' + txID + '.AsInteger '+
                                        ', oldTransYear, oldTransMonth, Master.' + txID + '.AsInteger]);';

  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '    result := result + Format (''AND GH.DEPTID = %d '', [GetID (''DeptID'')]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND GH.DEPTID = %d '', [Detail2.DeptID.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GH.DEPTID = %d '', [Detail.DeptID.Value]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GH.DEPTID = %d '', [Detail.DeptID.Value]);';
  end;

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '    result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                          ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                            ', [Detail2.GLAccount.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                            ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                          ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
  end;

  Script.Add := '    result := result + ''), 0) ACTUALBUDGET '';';

  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '    result := result + Format (''FROM DEPARTMENTBUDGET WHERE GLYEAR = %d AND DEPTID = %d '' '+
                                          ', [transYear, GetID (''DeptID'')]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''FROM DEPARTMENTBUDGET WHERE GLYEAR = %d AND DEPTID = %d '' '+
                                            ', [transYear, Detail2.DeptID.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''FROM DEPARTMENTBUDGET WHERE GLYEAR = %d AND DEPTID = %d '' '+
                                            ', [transYear, Detail.DeptID.Value]);';
    Script.Add := '    end;';
  end
  else begin
  Script.Add := '    result := result + Format (''FROM DEPARTMENTBUDGET WHERE GLYEAR = %d AND DEPTID = %d '' '+
                                        ', [transYear, Detail.DeptID.Value]);';
  end;

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '    result := result + Format (''AND GLACCOUNT = ''''%s'''' '' '+
                                          ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND GLACCOUNT = ''''%s'''' '' '+
                                            ', [Detail2.GLAccount.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GLACCOUNT = ''''%s'''' '' '+
                                            ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GLACCOUNT = ''''%s'''' '' '+
                                          ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
  end;

  Script.Add := '  end;';

  Script.Add := '  function GetBudgetActualProjectPeriodEachStr : String;';
  Script.Add := '  begin';
  Script.Add := '    result := Format (''SELECT COALESCE (PERIOD%d, 0) PERIOD%d, '', [transMonth, transMonth]);';
//  Script.Add := '    result := result + ''COALESCE ( (SELECT SUM (GH.BASEAMOUNT) FROM GLHIST GH '';';
//  Script.Add := '    result := result + Format (''WHERE GH.GLYEAR = %d AND GH.GLPERIOD = %d '+
//                                        'AND GH.INVOICEID <> %d '' '+
//                                        ', [{oldTransYear} transYear, {oldTransMonth} transMonth, Master.' + txID + '.AsInteger]);';

  Script.Add := '    result := result + ''COALESCE ( (SELECT SUM (GH.BASEAMOUNT) FROM GLHIST GH '';';
  Script.Add := '    result := result + Format (''WHERE ( (GH.GLYEAR = %d AND GH.GLPERIOD = %d AND GH.INVOICEID <> %d) '+
                                        'OR (GH.GLYEAR = %d AND GH.GLPERIOD = %d AND GH.INVOICEID = %d) ) '' '+
                                        ', [transYear, transMonth, Master.' + txID + '.AsInteger '+
                                        ', oldTransYear, oldTransMonth, Master.' + txID + '.AsInteger]);';

  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '    result := result + Format (''AND GH.PROJECTID = %d '', [GetID (''ProjectID'')]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND GH.PROJECTID = %d '', [Detail2.ProjectID.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GH.PROJECTID = %d '', [Detail.ProjectID.Value]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GH.PROJECTID = %d '', [Detail.ProjectID.Value]);';
  end;

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '    result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                          ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                            ', [Detail2.GLAccount.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                            ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                          ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
  end;

  Script.Add := '    result := result + ''), 0) ACTUALBUDGET '';';
  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '    result := result + Format (''FROM PROJECTBUDGET WHERE GLYEAR = %d '+
                                          'AND PROJECTID = %d '', [transYear, GetID (''ProjectID'')]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''FROM PROJECTBUDGET WHERE GLYEAR = %d '+
                                            'AND PROJECTID = %d '', [transYear, Detail2.ProjectID.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''FROM PROJECTBUDGET WHERE GLYEAR = %d '+
                                            'AND PROJECTID = %d '', [transYear, Detail.ProjectID.Value]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''FROM PROJECTBUDGET WHERE GLYEAR = %d '+
                                          'AND PROJECTID = %d '', [transYear, Detail.ProjectID.Value]);';
  end;

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '    result := result + Format (''AND GLACCOUNT = ''''%s'''' '' '+
                                          ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND GLACCOUNT = ''''%s'''' '' '+
                                            ', [Detail2.GLAccount.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GLACCOUNT = ''''%s'''' '' '+
                                            ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GLACCOUNT = ''''%s'''' '' '+
                                          ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
  end;
  Script.Add := '  end;';

  Script.Add := '  procedure CalculateBudgetPeriodEach (scriptType, budgetField, actualField, masterAccount : String);';
  Script.Add := '  var';
  Script.Add := '    detailCount : Integer;';
  Script.Add := '  begin';
  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      costSQL := CreateSQL (TIBTransaction (Detail2.Tx) );';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      costSQL := CreateSQL (TIBTransaction (Detail.Tx) );';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    costSQL := CreateSQL (TIBTransaction (Detail.Tx) );';
  end;
  Script.Add := '    try';
  Script.Add := '      budgetRemain := 0;';
  Script.Add := '      totalBudget  := '''';';
  Script.Add := '      totalActual  := '''';';
  Script.Add := '      idxAccount := 1;';

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '      if (masterAccount = '''') then begin';
    Script.Add := '        if expenseDetail then begin';
    Script.Add := '          Detail2.First;';
    Script.Add := '          detailCount    := Detail2.RecordCount;';
    Script.Add := '          maxItemAccount := 1;';
    Script.Add := '        end';
    Script.Add := '        else begin';
    Script.Add := '          Detail.First;';
    Script.Add := '          detailCount := Detail.RecordCount;';
    Script.Add := '        end;';
    Script.Add := '      end';
    Script.Add := '      else begin';
    Script.Add := '        detailCount    := 1;';
    Script.Add := '        maxItemAccount := 1;';
    Script.Add := '      end;';
  end
  else begin
    Script.Add := '      if (masterAccount = '''') then begin';
    Script.Add := '        Detail.First;';
    Script.Add := '        detailCount := Detail.RecordCount;';
    Script.Add := '      end';
    Script.Add := '      else begin';
    Script.Add := '        detailCount    := 1;';
    Script.Add := '        maxItemAccount := 1;';
    Script.Add := '      end;';
  end;

  Script.Add := '      for loopDetail := 1 to detailCount do begin';

  if (formName = 'CR') then begin
    Script.Add := '      RunSQL (costSQL, Format (''SELECT COUNT (DISCACCOUNT) COUNTDISCACCOUNT FROM ARINVPMT_DISC '+
                         'WHERE INVPMTID = %d '', [Detail.FieldByName (''InvPmtID'').Value]) );';
    Script.Add := '      maxItemAccount := costSQL.FieldByName (''COUNTDISCACCOUNT'');';
  end;

  if (formName = 'SI') OR (formName = 'PI')
  OR (formName = 'IA') OR (formName = 'JC') OR (formName = 'CR') then begin
    Script.Add := '        for idxAccount := 1 to maxItemAccount do begin';
  end;

  Script.Add := '          if (scriptType = ''Account'') then begin';
  Script.Add := '            RunSQL (budgetSQL, GetBudgetActualAccountPeriodEachStr (masterAccount) );';
  Script.Add := '          end;';

  Script.Add := '          if (scriptType = ''Department'') then begin';

  Script.Add := '            if NOT expenseDetail then begin';
  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '              if (GetID (''DeptID'') = 0) then begin';
  end
  else begin
    Script.Add := '              if Detail.DeptID.Isnull then begin';
  end;
  Script.Add := '                Detail.Next;';
  Script.Add := '                Continue;';
  Script.Add := '              end;';
  Script.Add := '            end;';

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '            if expenseDetail then begin';
    Script.Add := '              if Detail2.DeptID.Isnull then begin';
    Script.Add := '                Detail2.Next;';
    Script.Add := '                Continue;';
    Script.Add := '              end;';
    Script.Add := '            end;';
  end;
  Script.Add := '            RunSQL (budgetSQL, GetBudgetActualDepartmentPeriodEachStr);';
  Script.Add := '          end;';

  Script.Add := '          if (scriptType = ''Project'') then begin';
  Script.Add := '            if NOT expenseDetail then begin';
  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '              if (GetID (''ProjectID'') = 0) then begin';
  end
  else begin
    Script.Add := '              if Detail.ProjectID.Isnull then begin';
  end;
  Script.Add := '                Detail.Next;';
  Script.Add := '                Continue;';
  Script.Add := '              end;';
  Script.Add := '            end;';

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '            if expenseDetail then begin';
    Script.Add := '              if Detail2.ProjectID.Isnull then begin';
    Script.Add := '                Detail2.Next;';
    Script.Add := '                Continue;';
    Script.Add := '              end;';
    Script.Add := '            end;';
  end;
  Script.Add := '            RunSQL (budgetSQL, GetBudgetActualProjectPeriodEachStr);';
  Script.Add := '          end;';

  Script.Add := '          if budgetSQL.EOF then begin';
  Script.Add := '            budgetRemain := 0;';
  Script.Add := '            totalBudget  := '''';';
  Script.Add := '            totalActual  := '''';';
  Script.Add := '          end';
  Script.Add := '          else begin';
  Script.Add := '            totalBudget := CurrToStrSQL (budgetSQL.FieldByName (budgetField + IntToStr(transMonth) ) );';
  Script.Add := '            if (scriptType = ''Account'') then begin';
  Script.Add := '              totalActual := CurrToStrSQL (budgetSQL.FieldByName (actualField + IntToStr (oldTransMonth) ) );';
  Script.Add := '            end';
  Script.Add := '            else begin';
  Script.Add := '              totalActual := CurrToStrSQL (budgetSQL.FieldByName (actualField) );';
  Script.Add := '            end;';

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '            totalActual := CurrToStrSQL (NormalizeAccount (Detail.GLAccount.Value) * StrSQLTOCurr (totalActual) );';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '            if expenseDetail then begin';
    Script.Add := '              totalActual := CurrToStrSQL (NormalizeAccount (Detail2.GLAccount.Value) * StrSQLTOCurr (totalActual) );';
    Script.Add := '            end';
    Script.Add := '            else begin';
    Script.Add := '              totalActual := CurrToStrSQL (NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * StrSQLTOCurr (totalActual) );';
    Script.Add := '            end;';
  end
  else begin
    Script.Add := '            totalActual := CurrToStrSQL (NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * StrSQLTOCurr (totalActual) );';
  end;

  Script.Add := '            if (scriptType = ''Account'') then begin';
  Script.Add := '              RunSQL (budgetSQL, GetOldActualBudgetTransactionBeforeEdit (masterAccount) );';
  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '              totalActual := CurrToStrSQL (StrSQLtoCurr (totalActual) '+
                                                '- NormalizeAccount (Detail.GLAccount.Value) * StrSQLToCurr (budgetSQL.FieldByName (''BASEAMOUNT'') ) );';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '              if expenseDetail then begin';
    Script.Add := '                totalActual := CurrToStrSQL (StrSQLtoCurr (totalActual) '+
                                                  '- NormalizeAccount (Detail2.GLAccount.Value) * StrSQLTOCurr (budgetSQL.FieldByName (''BASEAMOUNT'') ) );';
    Script.Add := '              end';
    Script.Add := '              else begin';
    Script.Add := '                totalActual := CurrToStrSQL (StrSQLtoCurr (totalActual) '+
                                                  '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * StrSQLTOCurr (budgetSQL.FieldByName (''BASEAMOUNT'') ) );';
    Script.Add := '              end;';
  end
  else begin
    Script.Add := '              totalActual := CurrToStrSQL (StrSQLtoCurr (totalActual) '+
                                                '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * StrSQLTOCurr (budgetSQL.FieldByName (''BASEAMOUNT'') ) );';
  end;
  Script.Add := '            end;';
  Script.Add := '          end;';
  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
//    Script.Add := '          budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) '+
//                                             '- NormalizeAccount (Detail.GLAccount.Value) * GetOtherTotalTransIfAccountSame (masterAccount);';
    Script.Add := '          budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '          if expenseDetail then begin';
//    Script.Add := '            budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) '+
//                                               '- NormalizeAccount (Detail2.GLAccount.Value) * GetOtherTotalTransIfAccountSame (masterAccount);';
    Script.Add := '            budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual);';
    Script.Add := '          end';
    Script.Add := '          else begin';
//    Script.Add := '            budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) '+
//                                               '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * GetOtherTotalTransIfAccountSame (masterAccount);';
    Script.Add := '            budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual);';
    Script.Add := '          end;';
  end
  else begin
//    Script.Add := '          budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) '+
//                                             '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * GetOtherTotalTransIfAccountSame (masterAccount, idxAccount);';
    Script.Add := '          budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual);';
  end;
  Script.Add := '          CalculateActualAmount (masterAccount);';

//  Script.Add := '          if (totalBudget <> ''0'') AND (totalBudget <> '''') then begin';
//  Script.Add := '            if ( (budgetRemain - actualAmount) < 0) AND (actualAmount > 0) then begin';
//  Script.Add := '              isShowConfirmation := True;';
//  Script.Add := '            end;';
//  Script.Add := '          end;';

  Script.Add := '          SaveCalculationBudget (scriptType, masterAccount);';

  if (formName = 'SI') OR (formName = 'PI')
  OR (formName = 'IA') OR (formName = 'JC') OR (formName = 'CR') then begin
    Script.Add := '        end;';
  end;

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '        if expenseDetail then begin';
    Script.Add := '          Detail2.Next;';
    Script.Add := '        end';
    Script.Add := '        else begin';
    Script.Add := '          Detail.Next;';
    Script.Add := '        end;';
  end
  else begin
    Script.Add := '        Detail.Next;';
  end;

  Script.Add := '      end;';
  Script.Add := '    finally';
  Script.Add := '      maxItemAccount := 9;';
  Script.Add := '      costSQL.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '';
  Script.Add := 'procedure GetBaseAndActualBudgetForPeriodEach (method : String);';
  Script.Add := 'begin';
  Script.Add := '  CalculationAssignments (method);';
  Script.Add := 'end;';
end;

procedure TLockingBudgetInjector.GetBaseAndActualBudgetForPeriodTotal (txDate, formName, txID : String);
begin

  Script.Add := '  function GetSumOfFieldPeriodTotal (field, tableName : String) : String;';
  Script.Add := '  var';
  Script.Add := '    idxMonth : Integer;';
  Script.Add := '  begin';
  Script.Add := '    result := ''COALESCE ( ('';';
  Script.Add := '    for idxMonth := 1 to 12 do begin';
  Script.Add := '      result := result + Format (''%s.%s%d '', [tableName, field, idxMonth]);';
  Script.Add := '      if (idxMonth < 12) then begin';
  Script.Add := '        result := result + ''+ '';';
  Script.Add := '      end;';
  Script.Add := '    end;';
  Script.Add := '    result := result + Format (''), 0) %s '', [field]);';
  Script.Add := '  end;';

  Script.Add := '  function GetBudgetActualAccountPeriodTotalStr (masterAccount : String) : String;';
  Script.Add := '  begin';
  Script.Add := '    result := ''SELECT '';';
  Script.Add := '    result := result + GetSumOfFieldPeriodTotal (''BASEAMOUNT'', ''GA'') + '', '';';
  Script.Add := '    result := result + GetSumOfFieldPeriodTotal (''BUDGETAMOUNT'', ''GA'');';
  Script.Add := '    result := result + Format (''FROM GLACTUAL GA '+
                               'WHERE GA.GLYEAR = %d '', [transYear]);';

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '    result := result + Format (''AND GA.GLACCOUNT = ''''%s'''' '' '+
                                          ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND GA.GLACCOUNT = ''''%s'''' '' '+
                                            ', [Detail2.GLAccount.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GA.GLACCOUNT = ''''%s'''' '' '+
                                            ', [GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount)]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GA.GLACCOUNT = ''''%s'''' '' '+
                                          ', [GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount)]);';
  end;
  Script.Add := '  end;';

  Script.Add := '  function GetBudgetActualDepartmentPeriodTotalStr : String;';
  Script.Add := '  begin';
  Script.Add := '    result := ''SELECT '';';
  Script.Add := '    result := result + GetSumOfFieldPeriodTotal (''PERIOD'', ''DB'') + '', '';';
  Script.Add := '    result := result + ''COALESCE ( (SELECT SUM (GH.BASEAMOUNT) FROM GLHIST GH '';';
  Script.Add := '    result := result + Format (''WHERE GH.GLYEAR = %d AND GH.GLPERIOD = %d '+
                                        'AND GH.INVOICEID <> %d '' '+
                                        ', [{oldTransYear} transYear, {oldTransMonth} transMonth, Master.' + txID + '.AsInteger]);';

  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '    result := result + Format (''AND GH.DEPTID = %d '', [GetID (''DeptID'')]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND GH.DEPTID = %d '', [Detail2.DeptID.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GH.DEPTID = %d '', [Detail.DeptID.Value]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GH.DEPTID = %d '', [Detail.DeptID.Value]);';
  end;

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '    result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                          ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';

    Script.Add := '      result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                            ', [Detail2.GLAccount.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                            ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                          ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
  end;

  Script.Add := '    result := result + ''), 0) ACTUALBUDGET '';';

  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '    result := result + Format (''FROM DEPARTMENTBUDGET DB '+
                                          'WHERE DB.GLYEAR = %d AND DB.DEPTID = %d '' '+
                                          ', [transYear, GetID (''DeptID'')]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''FROM DEPARTMENTBUDGET DB WHERE DB.GLYEAR = %d AND DB.DEPTID = %d '' '+
                                            ', [transYear, Detail2.DeptID.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''FROM DEPARTMENTBUDGET DB WHERE DB.GLYEAR = %d AND DB.DEPTID = %d '' '+
                                            ', [transYear, Detail.DeptID.Value]);';
    Script.Add := '    end;';
  end
  else begin
  Script.Add := '    result := result + Format (''FROM DEPARTMENTBUDGET DB '+
                                        'WHERE DB.GLYEAR = %d AND DB.DEPTID = %d '' '+
                                        ', [transYear, Detail.DeptID.Value]);';
  end;

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '    result := result + Format (''AND DB.GLACCOUNT = ''''%s'''' '' '+
                                          ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND DB.GLACCOUNT = ''''%s'''' '' '+
                                            ', [Detail2.GLAccount.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND DB.GLACCOUNT = ''''%s'''' '' '+
                                            ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND DB.GLACCOUNT = ''''%s'''' '' '+
                                          ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
  end;
  Script.Add := '  end;';

  Script.Add := '  function GetBudgetActualProjectPeriodTotalStr : String;';
  Script.Add := '  begin';
  Script.Add := '    result := ''SELECT '';';
  Script.Add := '    result := result + GetSumOfFieldPeriodTotal (''PERIOD'', ''PB'') + '', '';';
  Script.Add := '    result := result + ''COALESCE ( (SELECT SUM (GH.BASEAMOUNT) FROM GLHIST GH '';';
  Script.Add := '    result := result + Format (''WHERE GH.GLYEAR = %d AND GH.GLPERIOD = %d '+
                                        'AND GH.INVOICEID <> %d '' '+
                                        ', [{oldTransYear} transYear, {oldTransMonth} transMonth, Master.' + txID + '.AsInteger]);';

  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '    result := result + Format (''AND GH.PROJECTID = %d '', [GetID (''ProjectID'')]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND GH.PROJECTID = %d '', [Detail2.ProjectID.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GH.PROJECTID = %d '', [Detail.ProjectID.Value]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GH.PROJECTID = %d '', [Detail.ProjectID.Value]);';
  end;

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '    result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                          ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                            ', [Detail2.GLAccount.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                            ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND GH.GLACCOUNT = ''''%s'''' '' '+
                                          ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
  end;

  Script.Add := '    result := result + ''), 0) ACTUALBUDGET '';';

  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '    result := result + Format (''FROM PROJECTBUDGET PB WHERE PB.GLYEAR = %d '+
                                          'AND PB.PROJECTID = %d '', [transYear, GetID (''ProjectID'')]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''FROM PROJECTBUDGET PB WHERE PB.GLYEAR = %d '+
                                            'AND PB.PROJECTID = %d '', [transYear, Detail2.ProjectID.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''FROM PROJECTBUDGET PB WHERE PB.GLYEAR = %d '+
                                            'AND PB.PROJECTID = %d '', [transYear, Detail.ProjectID.Value]);';
    Script.Add := '    end;';
  end
  else begin
  Script.Add := '    result := result + Format (''FROM PROJECTBUDGET PB WHERE PB.GLYEAR = %d '+
                                        'AND PB.PROJECTID = %d '', [transYear, Detail.ProjectID.Value]);';
  end;

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '    result := result + Format (''AND PB.GLACCOUNT = ''''%s'''' '' '+
                                          ', [Detail.GLAccount.Value]);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      result := result + Format (''AND PB.GLACCOUNT = ''''%s'''' '' '+
                                            ', [Detail2.GLAccount.Value]);';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      result := result + Format (''AND PB.GLACCOUNT = ''''%s'''' '' '+
                                            ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    result := result + Format (''AND PB.GLACCOUNT = ''''%s'''' '' '+
                                          ', [GetToken (GetAccountListFromItem, '','', idxAccount)]);';
  end;
  Script.Add := '  end;';

  Script.Add := '  procedure CalculateBudgetPeriodTotal (scriptType, budgetField, actualField, masterAccount : String);';
  Script.Add := '  var';
  Script.Add := '    detailCount : Integer;';
  Script.Add := '  begin';

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '    if expenseDetail then begin';
    Script.Add := '      costSQL := CreateSQL (TIBTransaction (Detail2.Tx) );';
    Script.Add := '    end';
    Script.Add := '    else begin';
    Script.Add := '      costSQL := CreateSQL (TIBTransaction (Detail.Tx) );';
    Script.Add := '    end;';
  end
  else begin
    Script.Add := '    costSQL := CreateSQL (TIBTransaction (Detail.Tx) );';
  end;
  Script.Add := '    try';
  Script.Add := '      budgetRemain := 0;';
  Script.Add := '      totalBudget  := '''';';
  Script.Add := '      totalActual  := '''';';
  Script.Add := '      idxAccount := 1;';

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '      if (masterAccount = '''') then begin';
    Script.Add := '        if expenseDetail then begin';
    Script.Add := '          Detail2.First;';
    Script.Add := '          detailCount    := Detail2.RecordCount;';
    Script.Add := '          maxItemAccount := 1;';
    Script.Add := '        end';
    Script.Add := '        else begin';
    Script.Add := '          Detail.First;';
    Script.Add := '          detailCount := Detail.RecordCount;';
    Script.Add := '        end;';
    Script.Add := '      end';
    Script.Add := '      else begin';
    Script.Add := '        detailCount    := 1;';
    Script.Add := '        maxItemAccount := 1;';
    Script.Add := '      end;';
  end
  else begin
    Script.Add := '      if (masterAccount = '''') then begin';
    Script.Add := '        Detail.First;';
    Script.Add := '        detailCount := Detail.RecordCount;';
    Script.Add := '      end';
    Script.Add := '      else begin';
    Script.Add := '        detailCount    := 1;';
    Script.Add := '        maxItemAccount := 1;';
    Script.Add := '      end;';
  end;

  Script.Add := '      for loopDetail := 1 to detailCount do begin';

  if (formName = 'CR') then begin
    Script.Add := '      RunSQL (costSQL, Format (''SELECT COUNT (DISCACCOUNT) COUNTDISCACCOUNT FROM ARINVPMT_DISC '+
                         'WHERE INVPMTID = %d '', [Detail.FieldByName (''InvPmtID'').Value]) );';
    Script.Add := '      maxItemAccount := costSQL.FieldByName (''COUNTDISCACCOUNT'');';
  end;

  if (formName = 'SI') OR (formName = 'PI')
  OR (formName = 'IA') OR (formName = 'JC') OR (formName = 'CR') then begin
    Script.Add := '        for idxAccount := 1 to maxItemAccount do begin';
  end;

  Script.Add := '            if (scriptType = ''Account'') then begin';
  Script.Add := '              RunSQL (budgetSQL, GetBudgetActualAccountPeriodTotalStr (masterAccount) );';
  Script.Add := '            end;';

  Script.Add := '            if (scriptType = ''Department'') then begin';

  Script.Add := '              if NOT expenseDetail then begin';
  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '                if (GetID (''DeptID'') = 0) then begin';
  end
  else begin
    Script.Add := '                if Detail.DeptID.Isnull then begin';
  end;
  Script.Add := '                  Detail.Next;';
  Script.Add := '                  Continue;';
  Script.Add := '                end;';
  Script.Add := '              end;';

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '              if expenseDetail then begin';
    Script.Add := '                if Detail2.DeptID.Isnull then begin';
    Script.Add := '                  Detail2.Next;';
    Script.Add := '                  Continue;';
    Script.Add := '                end;';
    Script.Add := '              end;';
  end;
  Script.Add := '              RunSQL (budgetSQL, GetBudgetActualDepartmentPeriodTotalStr);';
  Script.Add := '            end;';

  Script.Add := '            if (scriptType = ''Project'') then begin';
  Script.Add := '              if NOT expenseDetail then begin';
  if (formName = 'CR') OR (formName = 'VP') then begin
    Script.Add := '                if (GetID (''ProjectID'') = 0) then begin';
  end
  else begin
    Script.Add := '                if Detail.ProjectID.Isnull then begin';
  end;
  Script.Add := '                  Detail.Next;';
  Script.Add := '                  Continue;';
  Script.Add := '                end;';
  Script.Add := '              end;';

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '              if expenseDetail then begin';
    Script.Add := '                if Detail2.ProjectID.Isnull then begin';
    Script.Add := '                  Detail2.Next;';
    Script.Add := '                  Continue;';
    Script.Add := '                end;';
    Script.Add := '              end;';
  end;
  Script.Add := '              RunSQL (budgetSQL, GetBudgetActualProjectPeriodTotalStr);';
  Script.Add := '            end;';
  Script.Add := '            if budgetSQL.EOF then begin';
  Script.Add := '              budgetRemain := 0;';
  Script.Add := '              totalBudget  := '''';';
  Script.Add := '              totalActual  := '''';';
  Script.Add := '            end';
  Script.Add := '            else begin';
  Script.Add := '              totalBudget := CurrToStrSQL (budgetSQL.FieldByName (budgetField) );';
  Script.Add := '              totalActual := CurrToStrSQL (budgetSQL.FieldByName (actualField) );';
  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '              totalActual := CurrToStrSQL (NormalizeAccount (Detail.GLAccount.Value) * StrSQLTOCurr (totalActual) );';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '            if expenseDetail then begin';
    Script.Add := '              totalActual := CurrToStrSQL (NormalizeAccount (Detail2.GLAccount.Value) * StrSQLTOCurr (totalActual) );';
    Script.Add := '            end';
    Script.Add := '            else begin';
    Script.Add := '              totalActual := CurrToStrSQL (NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * StrSQLTOCurr (totalActual) );';
    Script.Add := '            end;';
  end
  else begin
    Script.Add := '              totalActual := CurrToStrSQL (NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * StrSQLTOCurr (totalActual) );';
  end;

  Script.Add := '              if (scriptType = ''Account'') then begin';
  Script.Add := '                RunSQL (budgetSQL, GetOldActualBudgetTransactionBeforeEdit (masterAccount) );';
  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
    Script.Add := '                totalActual := CurrToStrSQL (StrSQLtoCurr (totalActual) '+
                                                  '- NormalizeAccount (Detail.GLAccount.Value) * StrSQLTOCurr (budgetSQL.FieldByName (''BASEAMOUNT'') ) );';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '              if expenseDetail then begin';
    Script.Add := '                totalActual := CurrToStrSQL (StrSQLtoCurr (totalActual) '+
                                                  '- NormalizeAccount (Detail2.GLAccount.Value) * StrSQLTOCurr (budgetSQL.FieldByName (''BASEAMOUNT'') ) );';
    Script.Add := '              end';
    Script.Add := '              else begin';
    Script.Add := '                totalActual := CurrToStrSQL (StrSQLtoCurr (totalActual) '+
                                                  '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * StrSQLTOCurr (budgetSQL.FieldByName (''BASEAMOUNT'') ) );';
    Script.Add := '              end;';
  end
  else begin
    Script.Add := '                totalActual := CurrToStrSQL (StrSQLtoCurr (totalActual) '+
                                                  '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * StrSQLTOCurr (budgetSQL.FieldByName (''BASEAMOUNT'') ) );';
  end;
  Script.Add := '              end;';
  Script.Add := '            end;';

  if (formName = 'OR') OR (formName = 'OP') OR (formName = 'JV') then begin
//    Script.Add := '          budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) '+
//                                             '- NormalizeAccount (Detail.GLAccount.Value) * GetOtherTotalTransIfAccountSame (masterAccount);';
    Script.Add := '          budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual);';
  end
  else if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '          if expenseDetail then begin';
//    Script.Add := '            budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) '+
//                                               '- NormalizeAccount (Detail2.GLAccount.Value) * GetOtherTotalTransIfAccountSame (masterAccount);';
    Script.Add := '            budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual);';
    Script.Add := '          end';
    Script.Add := '          else begin';
//    Script.Add := '            budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) '+
//                                               '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * GetOtherTotalTransIfAccountSame (masterAccount);';
    Script.Add := '            budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual);';
    Script.Add := '          end;';
  end
  else begin
//    Script.Add := '          budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual) '+
//                                             '- NormalizeAccount (GetToken (GetAccountListFromItem (masterAccount), '','', idxAccount) ) * GetOtherTotalTransIfAccountSame (masterAccount, idxAccount);';
    Script.Add := '          budgetRemain := StrSQLToCurr (totalBudget) - StrSQLToCurr (totalActual);';
  end;

  Script.Add := '            CalculateActualAmount (masterAccount);';

//  Script.Add := '            if (totalBudget <> ''0'') AND (totalBudget <> '''') then begin';
//  Script.Add := '              if ( (budgetRemain - actualAmount) < 0) AND (actualAmount > 0) then begin';
//  Script.Add := '                isShowConfirmation := True;';
//  Script.Add := '              end;';
//  Script.Add := '            end;';

  Script.Add := '            SaveCalculationBudget (scriptType, masterAccount);';

  if (formName = 'SI') OR (formName = 'PI')
  OR (formName = 'IA') OR (formName = 'JC') OR (formName = 'CR') then begin
    Script.Add := '          end;';
  end;

  if (formName = 'PI') OR (formName = 'JC') then begin
    Script.Add := '        if expenseDetail then begin';
    Script.Add := '          Detail2.Next;';
    Script.Add := '        end';
    Script.Add := '        else begin';
    Script.Add := '          Detail.Next;';
    Script.Add := '        end;';
  end
  else begin
    Script.Add := '        Detail.Next;';
  end;

  Script.Add := '      end;';
  Script.Add := '    finally';
  Script.Add := '      costSQL.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '';
  Script.Add := 'procedure GetBaseAndActualBudgetForPeriodTotal (method : String);';
  Script.Add := 'begin';
  Script.Add := '  CalculationAssignments (method);';
  Script.Add := 'end;';
end;

procedure TLockingBudgetInjector.GetAccountListFromItem (formName : String);
begin
  Script.Add := '';
  Script.Add := 'function GetAccountListFromItem (masterAccount : String = '''') : String;';
  Script.Add := 'var';
  Script.Add := '  listAccountSQL : TjbSQL;';
  Script.Add := '  listAccountStr : String;';
  Script.Add := 'begin';
  Script.Add := '  listAccountSQL := CreateSQL (TIBTransaction (Tx) );';
  Script.Add := '  try';

  if (formName = 'CR') then begin
    Script.Add := '    listAccountStr := Format (''SELECT COALESCE (DISCACCOUNT, '''''''') DISCACCOUNT FROM ARINVPMT_DISC '+
                                         'WHERE INVPMTID = %d '', [Detail.FieldByName (''InvPmtID'').Value]);';
  end
  else if (formName = 'VP') then begin
    Script.Add := '    listAccountStr := Format (''SELECT COALESCE (DISCACCOUNT, '''''''') DISCACCOUNT FROM APINVCHQ '+
                                         'WHERE APINVOICEID = %d '', [Detail.FieldByName (''APInvoiceID'').Value]);';
  end
  else if (formName = 'SI') OR (formName = 'PI')
  OR (formName = 'IA') OR (formName = 'JC') then begin
    Script.Add := '    listAccountStr := ''SELECT '+
                                         'COALESCE (INVENTORYGLACCNT, '''''''') INVENTORYGLACCNT '+
                                         ', COALESCE (COGSGLACCNT, '''''''') COGSGLACCNT '+
                                         ', COALESCE (PURCHASERETGLACCNT, '''''''') PURCHASERETGLACCNT '+
                                         ', COALESCE (SALESGLACCNT, '''''''') SALESGLACCNT '+
                                         ', COALESCE (SALESRETGLACCNT, '''''''') SALESRETGLACCNT '+
                                         ', COALESCE (SALESDISCOUNTACCNT, '''''''') SALESDISCOUNTACCNT '+
                                         ', COALESCE (GOODSTRANSITACCNT, '''''''') GOODSTRANSITACCNT '+
                                         ', COALESCE (FINISHEDMTRLGLACCNT, '''''''') FINISHEDMTRLGLACCNT '+
                                         ', COALESCE (INVENTORYCONTROLACCNT, '''''''') INVENTORYCONTROLACCNT '';';
    Script.Add := '    listAccountStr := listAccountStr + Format (''FROM ITEM WHERE ITEMNO = ''''%s'''' '' '+
                                                          ', [Detail.ItemNo.AsString]);';
  end;

  Script.Add := '    RunSQL (listAccountSQL, listAccountStr);';
  if (formName = 'SI') then begin
    Script.Add := '    result := Format (''%s,'' '+
                                 ', [listAccountSQL.FieldByName (''INVENTORYGLACCNT'')]);';
    Script.Add := '    result := result + Format (''%s,'', [listAccountSQL.FieldByName (''COGSGLACCNT'')]);';
  end
  else if (formName = 'IA') OR (formName = 'JC') OR (formName = 'PI') then begin
    Script.Add := '    result := Format (''%s,'' '+
                                 ', [listAccountSQL.FieldByName (''INVENTORYGLACCNT'')]);';
    Script.Add := '    result := result + Format (''%s,'', ['''']);';
  end;

//  Script.Add := '    result := result + Format (''%s,'', [listAccountSQL.FieldByName (''PURCHASERETGLACCNT'')]);';
  Script.Add := '    result := result + Format (''%s,'', ['''']);';

  if (formName = 'SI') then begin
    Script.Add := '    result := result + Format (''%s,'', [listAccountSQL.FieldByName (''SALESGLACCNT'')]);';
  end
  else if (formName = 'IA') OR (formName = 'JC') OR (formName = 'PI') then begin
    Script.Add := '    result := result + Format (''%s,'', ['''']);';
  end;

//    Script.Add := '    result := result + Format (''%s,'', [listAccountSQL.FieldByName (''SALESRETGLACCNT'')]);';
    Script.Add := '    result := result + Format (''%s,'', ['''']);';
//    Script.Add := '    result := result + Format (''%s,'', [listAccountSQL.FieldByName (''SALESDISCOUNTACCNT'')]);';
    Script.Add := '    result := result + Format (''%s,'', ['''']);';
//    Script.Add := '    result := result + Format (''%s,'', [listAccountSQL.FieldByName (''GOODSTRANSITACCNT'')]);';
    Script.Add := '    result := result + Format (''%s,'', ['''']);';
//    Script.Add := '    result := result + Format (''%s,'', [listAccountSQL.FieldByName (''FINISHEDMTRLGLACCNT'')]);';
    Script.Add := '    result := result + Format (''%s,'', ['''']);';
//    Script.Add := '    result := result + Format (''%s,'', [listAccountSQL.FieldByName (''INVENTORYCONTROLACCNT'')]);';
    Script.Add := '    result := result + Format (''%s,'', ['''']);';

  if (formName = 'CR') then begin
//    Script.Add := '    result := Format (''%s,'', [listAccountSQL.FieldByName (''ARACCOUNT'')]);';
    Script.Add := '    result := '''';';
    Script.Add := '    while NOT listAccountSQL.EOF do begin;';
    Script.Add := '      result :=  result + Format (''%s,'', [listAccountSQL.FieldByName (''DISCACCOUNT'')]);';
    Script.Add := '      listAccountSQL.Next;';
    Script.Add := '    end;';
  end
  else if (formName = 'VP') then begin
//    Script.Add := '    result := Format (''%s,'', [listAccountSQL.FieldByName (''APACCOUNT'')]);';
    Script.Add := '    result := Format (''%s,'', [listAccountSQL.FieldByName (''DISCACCOUNT'')]);';
  end;

  Script.Add := '    if (masterAccount <> '''') then begin';
  Script.Add := '      result := masterAccount + '','';';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    listAccountSQL.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
end;

procedure TLockingBudgetInjector.NormalizeAccount;
begin

  Script.Add := '';
  Script.Add := 'function GetNormalAccount (account : String) : String;';
  Script.Add := 'var';
  Script.Add := '  normalAccSQL : TjbSQL;';
  Script.Add := '  accountType  : Integer;';
  Script.Add := 'begin';
  Script.Add := '  normalAccSQL := CreateSQL (TIBTransaction (Tx) );';
  Script.Add := '  try';
  Script.Add := '    RunSQL (normalAccSQL, Format (''SELECT ACCOUNTTYPE FROM GLACCNT '+
                     'WHERE GLACCOUNT = ''''%s'''' '', [account]) );';
  Script.Add := '    accountType := StrToInt (Format (''%d'', [normalAccSQL.FieldByName (''ACCOUNTTYPE'')]) );';
  Script.Add := Format ('    if accountType in [%d..%d, %d..%d] then begin'
                , [gtBANK, gtACC_DEPRECIATION, gtCOGS, gtOTHER_EXPENSE]);
  Script.Add := '      result := ''debit'';';
  Script.Add := '    end';
  Script.Add := Format ('    else if accountType in [%d..%d, %d] then begin'
                , [gtAP, gtREVENUE, gtOTHER_INCOME]);
  Script.Add := '      result := ''credit'';';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    normalAccSQL.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'function NormalizeAccount (normalAccount : String) : Integer;';
  Script.Add := 'begin';
  Script.Add := '  if (GetNormalAccount (normalAccount) = ''debit'') then begin';
  Script.Add := '    result := 1;';
  Script.Add := '  end';
  Script.Add := '  else if (GetNormalAccount (normalAccount) = ''credit'') then begin';
  Script.Add := '    result := -1;';
  Script.Add := '  end;';

  Script.Add := 'end;';
end;

procedure TLockingBudgetInjector.LockingBudgetValidation (txDate, formName, txID, txNo : String);
begin
  ClearScript;
  CreateGrid;
  CreateForm;
  CreateLabel;
  CreateButton;
  CreateEditBox;
  CreateGrid;
  CreateCheckBox;
  ReadOption;
  WriteOption;
  LeftStr;
  AddFunction_CreateSQL;
  add_procedure_runsql;
  SendNotificationEmail (txDate, formName, txID, txNo);
  MasterExtended;
  GetAuthorization;
  NormalizeAccount;
  OverBudgetField;

  Script.Add := 'var';
  Script.Add := '  lblUserName            : TLabel;';
  Script.Add := '  txtUserName            : TEdit;';
  Script.Add := '  lblPass                : TLabel;';
  Script.Add := '  txtPass                : TEdit;';
  Script.Add := '  btnOKAuthority         : TButton;';
  Script.Add := '  btnCancelAuthority     : TButton;';
  Script.Add := '  btnRequestAuthority    : TButton;';
  Script.Add := '  infoDataSource         : TDataSource;';
  Script.Add := '  infoGrid               : TjbGrid;';
  Script.Add := '  lblOverBudget          : TLabel;';
  Script.Add := '  btnYesOverBudget       : TButton;';
  Script.Add := '  btnNoOverBudget        : TButton;';
  Script.Add := '  btnViewOverBudget      : TButton;';
  Script.Add := '  isGranted              : Boolean;';
  Script.Add := '  budgetSQL              : TjbSQL;';
  Script.Add := '  budgetRemain           : Currency;';
  Script.Add := '  totalBudget            : String;';
  Script.Add := '  totalActual            : String;';
  Script.Add := '  isShowConfirmation     : Boolean;';
  Script.Add := '  idxMonthAccumulation   : Integer;';
  Script.Add := '  lockingINI             : TINIFile;';
  Script.Add := '  lockingAccount         : String;';
  Script.Add := '  sameParentAccount      : String;';
  Script.Add := '  actualAmount           : Currency;';
  Script.Add := '  costSQL                : TjbSQL;';
  Script.Add := '  transID                : Integer;';

  Script.Add := 'const';
  Script.Add := '  SPACE_BUTTON = 20;';
  Script.Add := '  BUTTON_WIDTH = 70;';

  GeneralProceduresAmongCalculationMethods (txDate, formName, txID);
  GetBaseAndActualBudgetForAccumulationEach (txDate, formName, txID);
  GetBaseAndActualBudgetForAccumulationTotal (txDate, formName, txID);
  GetBaseAndActualBudgetForPeriodEach (txDate, formName, txID);
  GetBaseAndActualBudgetForPeriodTotal (txDate, formName, txID);

  Script.Add := 'procedure SetModifiedFlag;';
  Script.Add := 'begin';
  Script.Add := '  isModified := True;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure ActivateOverBudgetControlWhenModified;';
  Script.Add := 'begin';
  Script.Add := '  try';
  Script.Add := '    if isGranted then begin';
  Script.Add := '      SetStateOverBudgetApproval (''0'');';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      SetStateOverBudgetApproval (''1'');';
  Script.Add := '    end;';

  Script.Add := '    if NOT hasValidationRun then begin';
  Script.Add := '      CheckBudget;';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    hasValidationRun := False;';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure SetStateOverBudgetApproval (state : String);';
  Script.Add := 'begin';
  Script.Add := '  if NOT Master.IsFirstPost then begin';
  Script.Add := '    MasterExtended (GetOverBudgetField).AsString := state;';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure ShowLockingBudgetConfirmation;';
  Script.Add := 'var';
  Script.Add := '  frmApprove    : TForm;';
  Script.Add := '  frmOverBudget : TForm;';

  Script.Add := '  procedure PendingGLTransaction (sender : TObject; var action : TCloseAction);';
  Script.Add := '  begin';
  Script.Add := '    if NOT isGranted then begin';

  if (formName = 'JC') then begin
    Script.Add := '      DataModule.OnPostGL := nil;';
  end
  else begin
    Script.Add := '      DataModule.Post_GL := False;';
  end;

  Script.Add := '      ShowMessage (''Transaksi akan disimpan tetapi jurnal terbaru tidak tersimpan'');';
  Script.Add := '    end;';
  Script.Add := '    action := caFree;';
  Script.Add := '  end;';

  Script.Add := '  procedure RevalidationBudget;';
  Script.Add := '  begin';
  Script.Add := '    CalculateBudget;';
  Script.Add := '  end;';

  Script.Add := '  procedure ValidateUserAndPassword;';
  Script.Add := '  var';
  Script.Add := '    uniqueCode : String;';
  Script.Add := '  begin';
  Script.Add := '    isGranted := False;';
  Script.Add := '    DecodeDate (Master.' + txDate + '.Value, transYear, transMonth, transDay);';
  Script.Add := '    uniqueCode  := ''' + formName + ''' + Format (''%.2d'', [transMonth]) '+
                                    '+ Master.' + txID + '.AsString + Format (''%.2d'', [transDay]) '+
                                    '+ IntToStr (userID) + Copy (IntToStr (transYear), 3, 4);';
  Script.Add := '    if (txtPass.Text = uniqueCode) OR validate (txtUserName.Text, txtPass.Text) then begin';
  Script.Add := '      isGranted := True;';
  Script.Add := '      frmApprove.Close;';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      ShowMessage (''Otorisasi gagal'');';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure ViewOverBudget;';
  Script.Add := '  var';
  Script.Add := '    btnOKView : TButton;';
  Script.Add := '    frmInfo   : TForm;';
  Script.Add := '  const';
  Script.Add := '    NO             = 0;';
  Script.Add := '    EXPENSE_DETAIL = 1;';
  Script.Add := '    SEQUENCE       = 2;';
  Script.Add := '    ACCOUNT_NO     = 3;';
  Script.Add := '    DEPT_ID        = 4;';
  Script.Add := '    PROJ_ID        = 5;';
  Script.Add := '    SORTING        = 6;';
  Script.Add := '  begin';
  Script.Add := '    if (frmInfo <> nil) then begin';
  Script.Add := '      frmInfo := nil;';
  Script.Add := '    end;';
  Script.Add := '    frmInfo := CreateForm (''frmInfo'', ''Information'', 900, 300);';
  Script.Add := '    try';
  Script.Add := '      infoDataSource         := TDataSource.Create(frmInfo);';
  Script.Add := '      infoDataSource.Dataset := budgetDataset;';
  Script.Add := '      btnOKView := CreateBtn ( (frmInfo.ClientWidth - BUTTON_WIDTH) div 2'+
                                    ', frmInfo.ClientHeight - 40, BUTTON_WIDTH, 25, 1, ''OK'', frmInfo);';
  Script.Add := '      infoGrid  := CreateGrid( 10, 10, frmInfo.ClientWidth - 20 '+
                                    ', frmInfo.ClientHeight - 70, frmInfo, infoDataSource);';
  Script.Add := '      infoGrid.Columns.Items[NO].Visible             := False;';
  Script.Add := '      infoGrid.Columns.Items[EXPENSE_DETAIL].Visible := False;';
  Script.Add := '      infoGrid.Columns.Items[SEQUENCE].Visible       := False;';
  Script.Add := '      infoGrid.Columns.Items[ACCOUNT_NO].Visible     := False;';
  Script.Add := '      infoGrid.Columns.Items[DEPT_ID].Visible        := False;';
  Script.Add := '      infoGrid.Columns.Items[PROJ_ID].Visible        := False;';
  Script.Add := '      infoGrid.Columns.Items[SORTING].Visible        := False;';
  Script.Add := '      infoGrid.ReadOnly     := True;';
  Script.Add := '      btnOKView.ModalResult := mrOK;';
  Script.Add := '      frmInfo.ShowModal;';
  Script.Add := '    finally';
  Script.Add := '      frmInfo.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure SendEmailPreparation;';
  Script.Add := '  begin';
  Script.Add := '    btnRequestAuthority.Enabled := False;';
  Script.Add := '    btnRequestAuthority.Caption := ''Sending Email'';';
  Script.Add := '    SendEmailRequest;';
  Script.Add := '    btnRequestAuthority.Caption := ''REQ. PASS.'';';
  Script.Add := '  end;';

  Script.Add := '  procedure InputPassword (sender : TObject; var key: Char);';
  Script.Add := '  begin';
  Script.Add := '    if (key = #13) then begin';
  Script.Add := '      ValidateUserAndPassword;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure ShowApprovalForm;';
  Script.Add := '  begin';
  Script.Add := '    if (frmApprove <> nil) then begin';
  Script.Add := '      frmApprove := nil;';
  Script.Add := '    end;';
  Script.Add := '    frmApprove := CreateForm (''frmApprove'', ''Otorisasi'', 290, 150);';
  Script.Add := '    try';
  Script.Add := '      lblUserName          := CreateLabel ( 10, 10, 100, 15, ''User Name'', frmApprove);';
  Script.Add := '      txtUserName          := CreateEdit (100, lblUserName.Top, 170, 20, frmApprove);';
  Script.Add := '      lblPass              := CreateLabel (10, lblUserName.Top + lblUserName.Height + 10 '+
                                               ', 100, 15, ''Password'', frmApprove);';
  Script.Add := '      txtPass              := CreateEdit (100, lblPass.Top, 170, 20, frmApprove);';
  Script.Add := '      txtPass.PasswordChar := ''*'';';
  Script.Add := '      btnOKAuthority       := CreateBtn ( ( (frmApprove.ClientWidth - (3 * BUTTON_WIDTH ) ) div 4) '+
                                               ', frmApprove.ClientHeight - 40 '+
                                               ', BUTTON_WIDTH, 25, 1, ''OK'', frmApprove);';
  Script.Add := '      btnCancelAuthority   := CreateBtn ( btnOKAuthority.Left + SPACE_BUTTON + btnOKAuthority.Width'+
                                               ', btnOKAuthority.Top '+
                                               ', BUTTON_WIDTH, 25, 2, ''CANCEL'', frmApprove);';
  Script.Add := '      btnRequestAuthority  := CreateBtn ( btnCancelAuthority.Left + SPACE_BUTTON + btnCancelAuthority.Width '+
                                               ', btnOKAuthority.Top '+
                                               ', BUTTON_WIDTH, 25, 3, ''REQ. PASS.'', frmApprove);';
  Script.Add := '      frmApprove.BorderStyle         := bsDialog;';
  Script.Add := '      btnCancelAuthority.ModalResult := mrCancel;';
  Script.Add := '      txtPass.OnKeyPress             := @InputPassword;';
  Script.Add := '      btnOKAuthority.OnClick         := @ValidateUserAndPassword;';
  Script.Add := '      btnRequestAuthority.OnClick    := @SendEmailPreparation;';
  Script.Add := '      frmApprove.ShowModal;';
  Script.Add := '    finally';
  Script.Add := '      frmApprove.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := 'begin';
  Script.Add := '  if (frmOverBudget <> nil) then begin';
  Script.Add := '    frmOverBudget := nil;';
  Script.Add := '  end;';
  Script.Add := '  frmOverBudget := CreateForm (''frmOverBudget'', ''Otorisasi'', 290, 150);';
  Script.Add := '  try';
  Script.Add := '    lblOverBudget     := CreateLabel ( 10, 20, 270, 40 '+
                                          ', ''Total Realisasi sudah melebihi Budget.'' '+
                                          '+ #13 + ''Apakah Anda mau minta otorisasi?'', frmOverBudget);';
  Script.Add := '    lblOverBudget.Alignment := taCenter;';
  Script.Add := '    btnYesOverBudget  := CreateBtn ( ( (frmOverBudget.ClientWidth - (3 * BUTTON_WIDTH ) ) div 4) '+
                                          ', frmOverBudget.ClientHeight - 40 '+
                                          ', BUTTON_WIDTH, 25, 1, ''YES'', frmOverBudget);';
  Script.Add := '    btnNoOverBudget   := CreateBtn (btnYesOverBudget.Left + SPACE_BUTTON + btnYesOverBudget.Width'+
                                          ', btnYesOverBudget.Top '+
                                          ', BUTTON_WIDTH, 25, 2, ''NO'', frmOverBudget);';
  Script.Add := '    btnViewOverBudget := CreateBtn (btnNoOverBudget.Left + SPACE_BUTTON + btnNoOverBudget.Width '+
                                          ', btnNoOverBudget.Top '+
                                          ', BUTTON_WIDTH, 25, 3, ''VIEW'', frmOverBudget);';
  Script.Add := '    frmOverBudget.BorderStyle    := bsDialog;';
  Script.Add := '    btnYesOverBudget.ModalResult := mrOK;';
  Script.Add := '    btnNoOverBudget.ModalResult  := mrCancel;';
  Script.Add := '    btnYesOverBudget.OnClick     := @ShowApprovalForm;';
  Script.Add := '    btnViewOverBudget.OnClick    := @ViewOverBudget;';
  Script.Add := '    frmOverBudget.OnClose        := @PendingGLTransaction;';
  Script.Add := '    frmOverBudget.ShowModal;';
  Script.Add := '  finally';
  Script.Add := '    frmOverBudget.Free;';
  Script.Add := '    if (frmOverBudget.ModalResult = mrOK) AND (frmApprove.ModalResult = 2) then begin';
  Script.Add := '      RevalidationBudget;';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure CalculateBudget;';
  Script.Add := 'var';
  Script.Add := '  loadSettingINI         : TINIFile;';
  Script.Add := '  periodAsOfAccState     : Boolean;';
  Script.Add := '  periodPerPeriodState   : Boolean;';
  Script.Add := '  budgetAmountEachState  : Boolean;';
  Script.Add := '  budgetAmountTotalState : Boolean;';
  Script.Add := '  accBudgetState         : Boolean;';
  Script.Add := '  departmentState        : Boolean;';
  Script.Add := '  projectState           : Boolean;';

  Script.Add := '  ';
  Script.Add := '  procedure CheckLockingSetting;';
  Script.Add := '  begin';
  Script.Add := '    if NOT (periodAsOfAccState OR periodPerPeriodState) then begin';
  Script.Add := '      RaiseException (''Setting Locking Budget tidak valid, cek file setting (.ini) terlebih dahulu'');';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := 'begin';
  Script.Add := '  loadSettingINI := TINIFile.Create (ExtractFilePath (Application.Exename) '+
                                     '+ ''LockingBudgetSetting.ini'');';
  Script.Add := '  Detail.DisableControls;';
  Script.Add := '  try';
  Script.Add := '    with loadSettingINI do begin';
  Script.Add := '      periodAsOfAccState     := ReadBool (''PERIOD'', ''AsOfAccumulation'', False);';
  Script.Add := '      periodPerPeriodState   := ReadBool (''PERIOD'', ''PerPeriod'', False);';
  Script.Add := '      budgetAmountEachState  := ReadBool (''BUDGET_AMOUNT'', ''Each'', False);';
  Script.Add := '      budgetAmountTotalState := ReadBool (''BUDGET_AMOUNT'', ''Total'', False);';
  Script.Add := '      accBudgetState         := ReadBool (''LOCKING_CATEGORIES'', ''AccountBudget'', False);';
  Script.Add := '      departmentState        := ReadBool (''LOCKING_CATEGORIES'', ''Department'', False);';
  Script.Add := '      projectState           := ReadBool (''LOCKING_CATEGORIES'', ''Project'', False);';
  Script.Add := '    end;';

  Script.Add := '    CheckLockingSetting;';
  Script.Add := '    if periodAsOfAccState then begin';
  Script.Add := '      if budgetAmountEachState then begin';
  Script.Add := '        GetBaseAndActualBudgetForAccumulationEach (''AccEach'');';
  Script.Add := '      end';
  Script.Add := '      else if budgetAmountTotalState then begin';
  Script.Add := '        GetBaseAndActualBudgetForAccumulationTotal (''AccTotal'');';
  Script.Add := '      end;';
  Script.Add := '    end';
  Script.Add := '    else if periodPerPeriodState then begin';
  Script.Add := '      if budgetAmountEachState then begin';
  Script.Add := '        GetBaseAndActualBudgetForPeriodEach (''PeriodEach'');';  // Customer only use this method
  Script.Add := '      end';
  Script.Add := '      else if budgetAmountTotalState then begin';
  Script.Add := '        GetBaseAndActualBudgetForPeriodTotal (''PeriodTotal'');';
  Script.Add := '      end;';
  Script.Add := '    end;';

  Script.Add := '    Master.Edit;';
  Script.Add := '    if isShowConfirmation AND NOT isGranted then begin';
  Script.Add := '      SetStateOverBudgetApproval (''1'');';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      isGranted := True;';
  Script.Add := '      SetStateOverBudgetApproval (''0'');';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    loadSettingINI.Free;';
  Script.Add := '    Detail.EnableControls;';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := 'procedure SetTransID;';
  Script.Add := 'begin';
  Script.Add := '  hasValidationRun := False;';
  Script.Add := '  isModified       := False;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure CheckBudget;';
  Script.Add := 'begin';
  Script.Add := '  if NOT hasValidationRun then begin';
  Script.Add := '    CalculateBudget;';
  Script.Add := '    hasValidationRun := True;';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure LockingBudgetValidation;';
  Script.Add := 'begin';
  Script.Add := '  comparatorDataset := TjvMemoryData.Create (Form);';
  Script.Add := '  with comparatorDataset do begin';
  Script.Add := '    FieldDefs.Add (''Akun Sisa Budget''   , ftFloat, 0, False);';
  Script.Add := '    FieldDefs.Add (''Dep. Sisa Budget''   , ftFloat, 0, False);';
  Script.Add := '    FieldDefs.Add (''Proyek Sisa Budget'' , ftFloat, 0, False);';
  Script.Add := '    comparatorDataset.Open;';
  Script.Add := '  end;';
  Script.Add := '  CheckBudget;';
  Script.Add := 'end;';

  Script.Add := 'begin';
  Script.Add := '  Master.OnBeforePostValidationArray := @ActivateOverBudgetControlWhenModified;';
//  Script.Add := '  Master.OnCalcFieldsArray           := @SetModifiedFlag;';
  Script.Add := '  Master.OnAfterEditArray            := @SetModifiedFlag;';
  Script.Add := '  Master.on_before_save_array        := @LockingBudgetValidation;';
  Script.Add := '  Form.layout_from_script            := @SetTransID;';
  Script.Add := 'end.';
end;

procedure TLockingBudgetInjector.NeedApproval (aliasField, fieldNoSQL, formName, datasetName : String);
begin
  ClearScript;
  CreateCheckBox;
  VarAndConst;
  OverBudgetField;

  Script.Add := 'var';
  Script.Add := '  cboNeedApproval : TCheckBox;';

  Script.Add := 'procedure DoFilterNeedApproval;';

  Script.Add := '  function GetWhereClause (aliasField : string) : String;';
  Script.Add := '  begin';
  Script.Add := '    result := Format('' AND %s.EXTENDEDID IN (SELECT E.EXTENDEDID '+
                               'FROM EXTENDED E WHERE E.%s = ''''1'''') '', [aliasfield '+
                               ', GetOverBudgetField]);';
  Script.Add := '  end;';

  Script.Add := 'begin';
  Script.Add := '  if cboNeedApproval.Checked then begin';
  Script.Add := format('  %s := %s + GetWhereClause (''%s'');', [fieldNoSQL, fieldNoSQL, aliasField]);
  Script.Add := '  end';
  Script.Add := '  else begin';
  Script.Add := format('  %s := ReplaceStr (%s, GetWhereClause(''%s''), '''');'
                , [fieldNoSQL, fieldNoSQL, aliasField]);
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure FilterNeedApproval;';
  Script.Add := 'begin';
  Script.Add := '  DoFilterNeedApproval;';
  Script.Add := format('  DataModule.%s.Close; ',[datasetname]);
  Script.Add := format('  DataModule.%s.Open; ',[datasetname]);
  Script.Add := 'end;';

  Script.Add := 'begin';
  Script.Add := '  cboNeedApproval         := CreateCheckBox (10, Form.AFilterBox.Top - 50'+
                                              '+ Form.AFilterBox.Height + 100, Form.AFilterBox.Width - 20, 20 '+
                                              ', ''Need Approval'', Form.AFilterBox);';
  Script.Add := '  cboNeedApproval.OnClick := @FilterNeedApproval;';
  Script.Add := 'end.';
end;

procedure TLockingBudgetInjector.GenerateScriptForMain;
begin
  ClearScript;
  CreateMenu;
  CreateForm;
  ReadOption;
  WriteOption;
  CreateLabel;
  CreateButton;
  CreateEditBox;
  CreateCheckBox;
  CreatePanel;
  CreateRadioButton;
  CreateListView;
  CreateComboBox;
  ShowSettingEmailForm;
  LeftPos;

  Script.Add := 'var';
  Script.Add := '  lockingBudgetMenu : TMenuItem;';
  Script.Add := '  settingEmailMenu  : TMenuItem;';
  Script.Add := 'const';
  Script.Add := '  BTN_WIDTH  = 80;';
  Script.Add := '  SPACE_LV   = 40;';

  Script.Add := 'procedure ShowLockingBudgetForm;';
  Script.Add := 'var';
  Script.Add := '  frmLockingBudget        : TForm;';
  Script.Add := '  frmLockingList          : TForm;';
  Script.Add := '  lblPeriod               : TLabel;';
  Script.Add := '  lblBudgetAmount         : TLabel;';
  Script.Add := '  rbPeriodAsOfAcc         : TRadioButton;';
  Script.Add := '  rbPeriodPerPeriod       : TRadioButton;';
  Script.Add := '  rbBudgetAmountEach      : TRadioButton;';
  Script.Add := '  rbBudgetAmountTotal     : TRadioButton;';
  Script.Add := '  pnlPeriod               : TPanel;';
  Script.Add := '  pnlBudgetAmount         : TPanel;';
  Script.Add := '  lblLockingBy            : TLabel;';
  Script.Add := '  chkAccBudget            : TCheckBox;';
  Script.Add := '  chkDepartment           : TCheckBox;';
  Script.Add := '  chkProject              : TCheckBox;';
  Script.Add := '  lvAccBudget             : TListView;';
  Script.Add := '  lvDepartment            : TListView;';
  Script.Add := '  lvProject               : TListView;';
  Script.Add := '  lvLockingList           : TListView;';
  Script.Add := '  lvSelectedList          : TListView;';  // buffer ListView
  Script.Add := '  liSelectedItems         : TListItem;';  // buffer ListItem
  Script.Add := '  col                     : TListColumn;';
  Script.Add := '  lblOverBudgetApproval   : TLabel;';
  Script.Add := '  cboOverBudgetApproval   : TComboBox;';

  Script.Add := '  btnOKLockingBudget      : TButton;';
  Script.Add := '  btnCancelLockingBudget  : TButton;';
  Script.Add := '  btnAdd                  : TButton;';
  Script.Add := '  btnDelete               : TButton;';
  Script.Add := '  btnAddAccBudget         : TButton;';
  Script.Add := '  btnDeleteAccBudget      : TButton;';
  Script.Add := '  btnAddDepartment        : TButton;';
  Script.Add := '  btnDeleteDepartment     : TButton;';
  Script.Add := '  btnAddProject           : TButton;';
  Script.Add := '  btnDeleteProject        : TButton;';
  Script.Add := '  lockingBudgetSettingINI : TINIFile;';
  Script.Add := '  loadLockingAccount      : String;';
  Script.Add := '  loadLockingAccountName  : String;';

  Script.Add := 'const';
  Script.Add := '  RECORD_FIT = -2;';

  Script.Add := '  procedure SetResetLockingControls (state : Boolean);';
  Script.Add := '  begin';
  Script.Add := '    chkAccBudget.Enabled        := state;';
  Script.Add := '    chkDepartment.Enabled       := state;';
  Script.Add := '    chkProject.Enabled          := state;';
  Script.Add := '    lvAccBudget.Enabled         := state;';
  Script.Add := '    lvDepartment.Enabled        := state;';
  Script.Add := '    lvProject.Enabled           := state;';
  Script.Add := '    btnAddAccBudget.Enabled     := state;';
  Script.Add := '    btnDeleteAccBudget.Enabled  := state;';
  Script.Add := '    btnAddDepartment.Enabled    := state;';
  Script.Add := '    btnDeleteDepartment.Enabled := state;';
  Script.Add := '    btnAddProject.Enabled       := state;';
  Script.Add := '    btnDeleteProject.Enabled    := state;';
  Script.Add := '  end;';

  Script.Add := '  procedure AddFunctionalLockingControls;';
  Script.Add := '  begin';
  Script.Add := '    if rbPeriodAsOfAcc.Checked AND rbBudgetAmountTotal.Checked then begin';
  Script.Add := '      SetResetLockingControls (True);';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      SetResetLockingControls (False);';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure LoadLockingAccountListView (account : String; accountType : TListView);';
  Script.Add := '  var';
  Script.Add := '    idxLoadLockingItem : Integer;';
  Script.Add := '  begin';
  Script.Add := '    with lockingBudgetSettingINI do begin';
  Script.Add := '      loadLockingAccount     := ReadString (''LOCKING_ACCOUNT'', account, '''');';
  Script.Add := '      loadLockingAccountName := ReadString (''LOCKING_ACCOUNT'', (account + ''Name''), '''');';
  Script.Add := '    end;';
  Script.Add := '    for idxLoadLockingItem := 1 to CountToken (loadLockingAccount, ''&'') do begin';
  Script.Add := '      liSelectedItems         := accountType.Items.Add;';
  Script.Add := '      liSelectedItems.Caption := GetToken (loadLockingAccount, ''&'', idxLoadLockingItem);';
  Script.Add := '      liSelectedItems.SubItems.Add (GetToken (loadLockingAccountName, ''&'', idxLoadLockingItem) );';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure LoadLockingBudgetSetting;';
  Script.Add := '  begin';
  Script.Add := '    lockingBudgetSettingINI := TINIFile.Create (ExtractFilePath (Application.Exename) '+
                                                '+ ''LockingBudgetSetting.ini'');';
  Script.Add := '    try';
  Script.Add := '      with lockingBudgetSettingINI do begin';
  Script.Add := '        rbPeriodAsOfAcc.Checked     := ReadBool (''PERIOD'', ''AsOfAccumulation'', False);';
  Script.Add := '        rbPeriodPerPeriod.Checked   := ReadBool (''PERIOD'', ''PerPeriod'', False);';
  Script.Add := '        rbBudgetAmountEach.Checked  := ReadBool (''BUDGET_AMOUNT'', ''Each'', False);';
  Script.Add := '        rbBudgetAmountTotal.Checked := ReadBool (''BUDGET_AMOUNT'', ''Total'', False);';
  Script.Add := '        chkAccBudget.Checked        := ReadBool (''LOCKING_CATEGORIES'', ''AccountBudget'', False);';
  Script.Add := '        chkDepartment.Checked       := ReadBool (''LOCKING_CATEGORIES'', ''Department'', False);';
  Script.Add := '        chkProject.Checked          := ReadBool (''LOCKING_CATEGORIES'', ''Project'', False);';

  Script.Add := '        cboOverBudgetApproval.ItemIndex := StrToInt (GetNumeric (ReadString (''OVER_BUDGET_SETTING'' '+
                                                            ', ''CustomField'', DEFAULT_CUSTOM_FIELD) ) ) - 1;';
  Script.Add := '      end;';

  Script.Add := '      LoadLockingAccountListView (''BudgetLocking'', lvAccBudget);';
  Script.Add := '      LoadLockingAccountListView (''Department'', lvDepartment);';
  Script.Add := '      LoadLockingAccountListView (''Project'', lvProject);';
  Script.Add := '    finally';
  Script.Add := '      lockingBudgetSettingINI.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure SaveLockingBudgetSetting;';
  Script.Add := '  var';
  Script.Add := '    savedLockingAccount    : String;';
  Script.Add := '    idxSavedLockingAccount : Integer;';
  Script.Add := '  const';
  Script.Add := '    IDX_NAME = 0;';
  Script.Add := '  begin';
  Script.Add := '    lockingBudgetSettingINI := TINIFile.Create (ExtractFilePath (Application.Exename) '+
                                                '+ ''LockingBudgetSetting.ini'');';
  Script.Add := '    try';
  Script.Add := '      with lockingBudgetSettingINI do begin';
  Script.Add := '        if rbPeriodAsOfAcc.Checked then begin';
  Script.Add := '          WriteBool (''PERIOD'', ''AsOfAccumulation'', True);';
  Script.Add := '          WriteBool (''PERIOD'', ''PerPeriod'', False);';
  Script.Add := '        end';
  Script.Add := '        else if rbPeriodPerPeriod.Checked then begin';
  Script.Add := '          WriteBool (''PERIOD'', ''AsOfAccumulation'', False);';
  Script.Add := '          WriteBool (''PERIOD'', ''PerPeriod'', True);';
  Script.Add := '        end';
  Script.Add := '        else begin';
  Script.Add := '          WriteBool (''PERIOD'', ''AsOfAccumulation'', False);';
  Script.Add := '          WriteBool (''PERIOD'', ''PerPeriod'', False);';
  Script.Add := '        end;';

  Script.Add := '        if rbBudgetAmountEach.Checked then begin';
  Script.Add := '          WriteBool (''BUDGET_AMOUNT'', ''Each'', True);';
  Script.Add := '          WriteBool (''BUDGET_AMOUNT'', ''Total'', False);';
  Script.Add := '        end';
  Script.Add := '        else if rbBudgetAmountTotal.Checked then begin';
  Script.Add := '          WriteBool (''BUDGET_AMOUNT'', ''Each'', False);';
  Script.Add := '          WriteBool (''BUDGET_AMOUNT'', ''Total'', True);';
  Script.Add := '        end';
  Script.Add := '        else begin';
  Script.Add := '          WriteBool (''BUDGET_AMOUNT'', ''Each'', False);';
  Script.Add := '          WriteBool (''BUDGET_AMOUNT'', ''Total'', False);';
  Script.Add := '        end;';

  Script.Add := '        if chkAccBudget.Checked then begin';
  Script.Add := '          WriteBool (''LOCKING_CATEGORIES'', ''AccountBudget'', True);';
  Script.Add := '        end';
  Script.Add := '        else begin';
  Script.Add := '          WriteBool (''LOCKING_CATEGORIES'', ''AccountBudget'', False);';
  Script.Add := '        end;';
  Script.Add := '        if chkDepartment.Checked then begin';
  Script.Add := '          WriteBool (''LOCKING_CATEGORIES'', ''Department'', True);';
  Script.Add := '        end';
  Script.Add := '        else begin';
  Script.Add := '          WriteBool (''LOCKING_CATEGORIES'', ''Department'', False);';
  Script.Add := '        end;';
  Script.Add := '        if chkProject.Checked then begin';
  Script.Add := '          WriteBool (''LOCKING_CATEGORIES'', ''Project'', True);';
  Script.Add := '        end';
  Script.Add := '        else begin';
  Script.Add := '          WriteBool (''LOCKING_CATEGORIES'', ''Project'', False);';
  Script.Add := '        end;';

  Script.Add := '        savedLockingAccount := '''';';
  Script.Add := '        for idxSavedLockingAccount := 0 to (lvAccBudget.Items.Count - 1) do begin';
  Script.Add := '          savedLockingAccount := savedLockingAccount '+
                                                  '+ lvAccBudget.Items[idxSavedLockingAccount].Caption + ''&'';';
  Script.Add := '        end;';
  Script.Add := '        WriteString (''LOCKING_ACCOUNT'', ''BudgetLocking'', savedLockingAccount);';

  Script.Add := '        savedLockingAccount := '''';';
  Script.Add := '        for idxSavedLockingAccount := 0 to (lvAccBudget.Items.Count - 1) do begin';
  Script.Add := '          savedLockingAccount := savedLockingAccount '+
                                                  '+ lvAccBudget.Items[idxSavedLockingAccount].SubItems[IDX_NAME] + ''&'';';
  Script.Add := '        end;';
  Script.Add := '        WriteString (''LOCKING_ACCOUNT'', ''BudgetLockingName'', savedLockingAccount);';

  Script.Add := '        savedLockingAccount := '''';';
  Script.Add := '        for idxSavedLockingAccount := 0 to (lvDepartment.Items.Count - 1) do begin';
  Script.Add := '          savedLockingAccount := savedLockingAccount '+
                                                  '+ lvDepartment.Items[idxSavedLockingAccount].Caption + ''&'';';
  Script.Add := '        end;';
  Script.Add := '        WriteString (''LOCKING_ACCOUNT'', ''Department'', savedLockingAccount);';

  Script.Add := '        savedLockingAccount := '''';';
  Script.Add := '        for idxSavedLockingAccount := 0 to (lvDepartment.Items.Count - 1) do begin';
  Script.Add := '          savedLockingAccount := savedLockingAccount '+
                                                  '+ lvDepartment.Items[idxSavedLockingAccount].SubItems[IDX_NAME] + ''&'';';
  Script.Add := '        end;';
  Script.Add := '        WriteString (''LOCKING_ACCOUNT'', ''DepartmentName'', savedLockingAccount);';

  Script.Add := '        savedLockingAccount := '''';';
  Script.Add := '        for idxSavedLockingAccount := 0 to (lvProject.Items.Count - 1) do begin';
  Script.Add := '          savedLockingAccount := savedLockingAccount '+
                                                  '+ lvProject.Items[idxSavedLockingAccount].Caption + ''&'';';
  Script.Add := '        end;';
  Script.Add := '        WriteString (''LOCKING_ACCOUNT'', ''Project'', savedLockingAccount);';

  Script.Add := '        savedLockingAccount := '''';';
  Script.Add := '        for idxSavedLockingAccount := 0 to (lvProject.Items.Count - 1) do begin';
  Script.Add := '          savedLockingAccount := savedLockingAccount '+
                                                  '+ lvProject.Items[idxSavedLockingAccount].SubItems[IDX_NAME] + ''&'';';
  Script.Add := '        end;';
  Script.Add := '        WriteString (''LOCKING_ACCOUNT'', ''ProjectName'', savedLockingAccount);';

  Script.Add := '        WriteString (''OVER_BUDGET_SETTING'', ''CustomField'', cboOverBudgetApproval.Text);';
  Script.Add := '      end;';
  Script.Add := '    finally';
  Script.Add := '      lockingBudgetSettingINI.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure DeleteItemLocking (sender : TButton);';
  Script.Add := '  begin';
  Script.Add := '    if (sender = btnDeleteAccBudget) then begin';
  Script.Add := '      lvSelectedList := lvAccBudget;';
  Script.Add := '    end';
  Script.Add := '    else if (sender = btnDeleteDepartment) then begin';
  Script.Add := '      lvSelectedList := lvDepartment;';
  Script.Add := '    end';
  Script.Add := '    else if (sender = btnDeleteProject) then begin';
  Script.Add := '      lvSelectedList := lvProject;';
  Script.Add := '    end;';
  Script.Add := '    TCustomListView(lvSelectedList).DeleteSelected;';
  Script.Add := '  end;';

  Script.Add := '  procedure LoadToLockingListView;';
  Script.Add := '  var';
  Script.Add := '    idxSelectedLockingItem : Integer;';
  Script.Add := '  begin';
  Script.Add := '    if (frmLockingList.Caption = ''Account Budget Account No'') then begin';
  Script.Add := '      lvSelectedList := lvAccBudget;';
  Script.Add := '    end';
  Script.Add := '    else if (frmLockingList.Caption = ''Department Account No'') then begin';
  Script.Add := '      lvSelectedList := lvDepartment;';
  Script.Add := '    end';
  Script.Add := '    else if (frmLockingList.Caption = ''Project Account No'') then begin';
  Script.Add := '      lvSelectedList := lvProject;';
  Script.Add := '    end;';

  Script.Add := '    for idxSelectedLockingItem := 0 to (lvLockingList.Items.Count - 1) do begin';
  Script.Add := '      if lvLockingList.Items[idxSelectedLockingItem].Selected then begin';
  Script.Add := '        liSelectedItems := lvSelectedList.Items.Add;';
  Script.Add := '        liSelectedItems.Assign (lvLockingList.Items[idxSelectedLockingItem]);';
  Script.Add := '      end;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure ShowItemLocking (sender : TButton);';
  Script.Add := '  var';
  Script.Add := '    col              : TListColumn;';
  Script.Add := '    liLockingList    : TListItem;';
  Script.Add := '    lockingListSQL   : TjbSQL;';
  Script.Add := '    btnOKLockingList : TButton;';
  Script.Add := '    formName         : String;';
  Script.Add := '    idxUniqueAccount : Integer;';
  Script.Add := '    uniqueAccount    : String;';
  Script.Add := '  begin';
  Script.Add := '    if (sender = btnAddAccBudget) then begin';
  Script.Add := '      formName       := ''Account Budget Account No'';';
  Script.Add := '      lvSelectedList := lvAccBudget;';
  Script.Add := '    end';
  Script.Add := '    else if (sender = btnAddDepartment) then begin';
  Script.Add := '      formName       := ''Department Account No'';';
  Script.Add := '      lvSelectedList := lvDepartment;';
  Script.Add := '    end';
  Script.Add := '    else if (sender = btnAddProject) then begin';
  Script.Add := '      formName       := ''Project Account No'';';
  Script.Add := '      lvSelectedList := lvProject;';
  Script.Add := '    end;';
  Script.Add := '    frmLockingList := CreateForm (''frmLockingList'', formName, 360, 480);';
  Script.Add := '    lockingListSQL := CreateSQL (TIBTransaction (Tx) );';
  Script.Add := '    uniqueAccount := '''';';
  Script.Add := '    try';
  Script.Add := '      for idxUniqueAccount := 0 to (lvSelectedList.Items.Count - 1) do begin';
  Script.Add := '        uniqueAccount := uniqueAccount + '''''''' '+
                                          '+ lvSelectedList.Items[idxUniqueAccount].Caption + '''''', '';';
  Script.Add := '      end;';
  Script.Add := '      uniqueAccount := Copy (uniqueAccount, 1, (Length (uniqueAccount) - 2) );';  //Delete comma di paling kanan

  Script.Add := '      lvLockingList := CreateListView (frmLockingList, 10, 10 '+
                                        ', frmLockingList.ClientWidth - 20, frmLockingList.ClientHeight - 80, False);';
  Script.Add := '      lvLockingList.ViewStyle   := vsReport;';
  Script.Add := '      lvLockingList.GridLines   := True;';
  Script.Add := '      lvLockingList.MultiSelect := True;';
  Script.Add := '      lvLockingList.RowSelect   := True;';
  Script.Add := '      col := CreateListViewCol (lvLockingList, ''Account No.'', -2);';
  Script.Add := '      col := CreateListViewCol (lvLockingList, ''Name'', -2);';
  Script.Add := '      lvLockingList.Items.Clear;';
  Script.Add := '      RunSQL (lockingListSQL, Format (''SELECT GLACCOUNT, ACCOUNTNAME '+
                       'FROM GLACCNT WHERE GLACCOUNT NOT IN (%s) '', [uniqueAccount]) );';

  Script.Add := '      while NOT lockingListSQL.EOF do begin';
  Script.Add := '        liLockingList         := lvLockingList.Items.Add;';
  Script.Add := '        liLockingList.Caption := lockingListSQL.FieldByName (''GLACCOUNT'');';
  Script.Add := '        liLockingList.SubItems.Add (lockingListSQL.FieldByName (''ACCOUNTNAME'') );';
  Script.Add := '        lockingListSQL.Next;';
  Script.Add := '      end;';
  Script.Add := '      btnOKLockingList := CreateBtn ( (frmLockingList.ClientWidth - BTN_WIDTH) div 2 '+
                                           ', frmLockingList.ClientHeight - 40 '+
                                           ', BTN_WIDTH, 25, 1, ''OK'', frmLockingList);';
  Script.Add := '      btnOKLockingList.ModalResult := mrOK;';
  Script.Add := '      btnOKLockingList.OnClick := @LoadToLockingListView;';
  Script.Add := '      frmLockingList.ShowModal;';
  Script.Add := '    finally';
  Script.Add := '      lockingListSQL.Free;';
  Script.Add := '      frmLockingList.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure AddOverBudgetApprovalSetting;';
  Script.Add := '  var';
  Script.Add := '    idxCombo : Integer;';
  Script.Add := '  const';
  Script.Add := '    MAX_CUSTOM_FIELD = 20;';
  Script.Add := '  begin';
  Script.Add := '    lblOverBudgetApproval := CreateLabel (lblPeriod.Left, frmLockingBudget.ClientHeight - 100 '+
                                              ', lblPeriod.Width + 50, lblPeriod.Height '+
                                              ', ''Over Budget Approval Field'', frmLockingBudget);';
  Script.Add := '    cboOverBudgetApproval := CreateComboBox ( LeftPos (lblPeriod, 20) '+
                                              ', lblOverBudgetApproval.Top, lblOverBudgetApproval.Width, lblOverBudgetApproval.Height '+
                                              ', csDropDownList, frmLockingBudget);';

  Script.Add := '    for idxCombo := 1 to MAX_CUSTOM_FIELD do begin';
  Script.Add := '      cboOverBudgetApproval.Items.Add (''CUSTOMFIELD'' + IntToStr (idxCombo) );';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure CreateAddAndDeleteButton (listView : TListView);';
  Script.Add := '  begin';
  Script.Add := '    btnAdd    := CreateBtn ( (listView.Left + listView.Width) '+
                                  ', listView.Top + (listView.Height div 2 - 20) '+
                                  ', 20, 20, 3, ''+'', frmLockingBudget);';
  Script.Add := '    btnDelete := CreateBtn ( (listView.Left + listView.Width) '+
                                  ', listView.Top + (listView.Height div 2) '+
                                  ', 20, 20, 3, ''-'', frmLockingBudget);';
  Script.Add := '    btnAdd.OnClick    := @ShowItemLocking;';
  Script.Add := '    btnDelete.OnClick := @DeleteItemLocking;';

  //SCY
  Script.Add := '    btnAdd.Visible    := False;';
  Script.Add := '    btnDelete.Visible := False;';
  Script.Add := '  end;';

  Script.Add := '  procedure CreateAddAndDeleteLv;';
  Script.Add := '  begin';
  Script.Add := '    CreateAddAndDeleteButton (lvAccBudget);';
  Script.Add := '    btnAddAccBudget    := btnAdd;';
  Script.Add := '    btnDeleteAccBudget := btnDelete;';
  Script.Add := '    CreateAddAndDeleteButton (lvDepartment);';
  Script.Add := '    btnAddDepartment    := btnAdd;';
  Script.Add := '    btnDeleteDepartment := btnDelete;';
  Script.Add := '    CreateAddAndDeleteButton (lvProject);';
  Script.Add := '    btnAddProject    := btnAdd;';
  Script.Add := '    btnDeleteProject := btnDelete;';
  Script.Add := '  end;';

  Script.Add := '  procedure AddColumnListViews;';
  Script.Add := '  begin';
  Script.Add := '    col := CreateListViewCol (lvAccBudget, ''Account No'', RECORD_FIT);';
  Script.Add := '    col := CreateListViewCol (lvAccBudget, ''Name'', RECORD_FIT);';
  Script.Add := '    col := CreateListViewCol (lvDepartment, ''Account No'', RECORD_FIT);';
  Script.Add := '    col := CreateListViewCol (lvDepartment, ''Name'', RECORD_FIT);';
  Script.Add := '    col := CreateListViewCol (lvProject, ''Account No'', RECORD_FIT);';
  Script.Add := '    col := CreateListViewCol (lvProject, ''Name'', RECORD_FIT);';
  Script.Add := '  end;';

  Script.Add := '  procedure CreateLockingCategories;';
  Script.Add := '  begin';
  Script.Add := '    lblLockingBy  := CreateLabel (lblPeriod.Left, lblPeriod.Top + 100 '+
                                      ', 120, 20, ''Locking By'', frmLockingBudget);';
  Script.Add := '    chkAccBudget  := CreateCheckBox (lblLockingBy.Left, lblLockingBy.Top + 25 '+
                                      ', (frmLockingBudget.ClientWidth - (4 * SPACE_LV) ) div 3, 25 '+
                                      ', ''Account Budget'', frmLockingBudget);';
  Script.Add := '    chkDepartment := CreateCheckBox (chkAccBudget.Left + SPACE_LV + chkAccBudget.Width '+
                                      ', chkAccBudget.Top, 120, 25, ''Department'', frmLockingBudget);';
  Script.Add := '    chkProject    := CreateCheckBox ( (chkAccBudget.Left + 2 * (SPACE_LV + chkAccBudget.Width) ) '+
                                      ', chkAccBudget.Top, 120, 25, ''Project'', frmLockingBudget);';
  Script.Add := '    lvAccBudget   := CreateListView (frmLockingBudget, chkAccBudget.Left, chkAccBudget.Top + 30 '+
                                      ', chkAccBudget.Width, frmLockingBudget.ClientHeight - 300, False);';
  Script.Add := '    lvDepartment  := CreateListView (frmLockingBudget, chkDepartment.Left, lvAccBudget.Top '+
                                      ', chkAccBudget.Width, lvAccBudget.Height, False);';
  Script.Add := '    lvProject     := CreateListView (frmLockingBudget, chkProject.Left, lvAccBudget.Top '+
                                      ', chkAccBudget.Width, lvAccBudget.Height, False);';
  Script.Add := '    lvAccBudget.ViewStyle    := vsReport;';
  Script.Add := '    lvDepartment.ViewStyle   := vsReport;';
  Script.Add := '    lvProject.ViewStyle      := vsReport;';
  Script.Add := '    lvAccBudget.GridLines    := True;';
  Script.Add := '    lvDepartment.GridLines   := True;';
  Script.Add := '    lvProject.GridLines      := True;';
  Script.Add := '    lvAccBudget.MultiSelect  := True;';
  Script.Add := '    lvDepartment.MultiSelect := True;';
  Script.Add := '    lvProject.MultiSelect    := True;';
  Script.Add := '    lvAccBudget.RowSelect    := True;';
  Script.Add := '    lvDepartment.RowSelect   := True;';
  Script.Add := '    lvProject.RowSelect      := True;';

  //SCY
  Script.Add := '    lblLockingBy.Visible  := False;';
  Script.Add := '    chkAccBudget.Visible  := False;';
  Script.Add := '    chkDepartment.Visible := False;';
  Script.Add := '    chkProject.Visible    := False;';
  Script.Add := '    lvAccBudget.Visible   := False;';
  Script.Add := '    lvDepartment.Visible  := False;';
  Script.Add := '    lvProject.Visible     := False;';
  Script.Add := '    lvAccBudget.Visible   := False;';
  Script.Add := '    lvDepartment.Visible  := False;';
  Script.Add := '    lvProject.Visible     := False;';
  Script.Add := '  end;';

  Script.Add := '  procedure CreateHeaderControls;';
  Script.Add := '  begin';
  Script.Add := '    lblPeriod           := CreateLabel (25, 15, 120, 20, ''Period'', frmLockingBudget);';
  Script.Add := '    pnlPeriod           := CreatePanel( lblPeriod.Left + 100, lblPeriod.Top - 5'+
                                            ', 200, 25, frmLockingBudget);';
  Script.Add := '    pnlPeriod.BevelOuter := bvNone;';
  Script.Add := '    rbPeriodAsOfAcc     := CreateRadioButton (lblPeriod.Left + 100, lblPeriod.Top '+
                                            ', 120, 25, ''As Of Accumulation'', pnlPeriod);';
  Script.Add := '    rbPeriodAsOfAcc.Align := alLeft;';
  Script.Add := '    rbPeriodPerPeriod   := CreateRadioButton (rbPeriodAsOfAcc.Left + 150 '+
                                            ', rbPeriodAsOfAcc.Top, 70, 25, ''Per Period'', pnlPeriod);';
  //SCY
//  Script.Add := '    rbPeriodPerPeriod.Align := alRight;';
  Script.Add := '    rbPeriodPerPeriod.Align := alLeft;';
  Script.Add := '    lblBudgetAmount     := CreateLabel (lblPeriod.Left, lblPeriod.Top + 25 '+
                                            ', 120, 25, ''Budget Amount'', frmLockingBudget);';
  Script.Add := '    pnlBudgetAmount           := CreatePanel( lblBudgetAmount.Left + 100, lblBudgetAmount.Top '+
                                            ', 200, 25, frmLockingBudget);';
  Script.Add := '    pnlBudgetAmount.BevelOuter := bvNone;';
  Script.Add := '    rbBudgetAmountEach  := CreateRadioButton (lblBudgetAmount.Left + 100, lblBudgetAmount.Top - 5'+
                                            ', 120, 25, ''Each'', pnlBudgetAmount);';
  Script.Add := '    rbBudgetAmountEach.Align := alLeft;';
  Script.Add := '    rbBudgetAmountTotal := CreateRadioButton (lblBudgetAmount.Left + 170, lblBudgetAmount.Top '+
                                            ', 120, 25, ''Total'', pnlBudgetAmount  );';
  Script.Add := '    rbBudgetAmountTotal.Align := alRight;';

  //SCY
  Script.Add := '    rbPeriodAsOfAcc.Visible     := False;';
  Script.Add := '    rbBudgetAmountTotal.Visible := False;';
  Script.Add := '  end;';

  Script.Add := 'begin';
  //SCY
//  Script.Add := '  frmLockingBudget := CreateForm (''frmLockingBudget'', ''Locking Budget'', 800, 600);';
  Script.Add := '  frmLockingBudget := CreateForm (''frmLockingBudget'', ''Locking Budget'', 800, 300);';
  Script.Add := '  try';
  Script.Add := '    frmLockingBudget.BorderStyle := bsDialog;';
  Script.Add := '    CreateHeaderControls;';
  Script.Add := '    CreateLockingCategories;';
  Script.Add := '    AddColumnListViews;';
  Script.Add := '    CreateAddAndDeleteLv;';
  Script.Add := '    AddOverBudgetApprovalSetting;';

  Script.Add := '    btnOKLockingBudget     := CreateBtn ( (frmLockingBudget.ClientWidth - (2 * BTN_WIDTH) ) div 3 '+
                                                ', frmLockingBudget.ClientHeight - 50, BTN_WIDTH, 25, 1, ''&OK'', frmLockingBudget);';
  Script.Add := '    btnCancelLockingBudget := CreateBtn ( (2 * btnOKLockingBudget.Left) + BTN_WIDTH, btnOKLockingBudget.Top '+
                                                ', BTN_WIDTH, 25, 2, ''&CANCEL'', frmLockingBudget);';
  Script.Add := '    btnOKLockingBudget.OnClick         := @SaveLockingBudgetSetting;';
  Script.Add := '    btnOKLockingBudget.ModalResult     := mrOK;';
  Script.Add := '    btnCancelLockingBudget.ModalResult := mrCancel;';
  Script.Add := '    LoadLockingBudgetSetting;';
  Script.Add := '    rbPeriodAsOfAcc.OnClick     := @AddFunctionalLockingControls;';
  Script.Add := '    rbPeriodPerPeriod.OnClick   := @AddFunctionalLockingControls;';
  Script.Add := '    rbBudgetAmountEach.OnClick  := @AddFunctionalLockingControls;';
  Script.Add := '    rbBudgetAmountTotal.OnClick := @AddFunctionalLockingControls;';
  Script.Add := '    AddFunctionalLockingControls;';
  Script.Add := '    frmLockingBudget.ShowModal;';
  Script.Add := '  finally';
  Script.Add := '    frmLockingBudget.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := 'begin';
  Script.Add := '  settingEmailMenu  := CreateMenu ( (Form.mnuAddOn.Count - 1) '+
                                        ', Form.mnuAddOn, ''mnuSettingEmail'' '+
                                        ', ''Setting Email'', ''ShowSettingEmailForm'');';
  Script.Add := '  lockingBudgetMenu := CreateMenu ( (Form.mnuAddOn.Count - 1) '+
                                        ', Form.mnuAddOn, ''mnuLockingBudget'' '+
                                        ', ''Locking Budget'', ''ShowLockingBudgetForm'');';
  Script.Add := 'end.';
end;

procedure TLockingBudgetInjector.SendNotificationEmail (txDate, formName, txID, txNo : String);
begin
  VarAndConst;

  Script.Add := '';
  Script.Add := 'procedure SetEmail;';
  Script.Add := 'begin';
  Script.Add := '  MAIL_USER        := ReadOption (''MAIL_USER'', '''');';
  Script.Add := '  MAIL_PASS        := ReadOption (''MAIL_PASS'', '''');';
  Script.Add := '  SMTP_SERVER      := ReadOption (''SMTP_SERVER'', '''');';
  Script.Add := '  SMTP_SERVER_PORT := ReadOption (''SMTP_SERVER_PORT'', '''');';
  Script.Add := '  USE_SSL          := ReadOption (''USE_SSL'', ''False'');';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure SendEmailRequest;';
  Script.Add := 'var';
  Script.Add := '  FileVBScript      : TStringlist;';
  Script.Add := '  mailAddress       : String;';
  Script.Add := '  mailHeader        : String;';
  Script.Add := '  mailBody          : array [1..9] of String;';
  Script.Add := '  emailSQL          : TjbSQL;';
  Script.Add := '  emailConfigINI    : TINIFile;';
  Script.Add := '  transYear         : Word;';
  Script.Add := '  transMonth        : Word;';
  Script.Add := '  transDay          : Word;';
  Script.Add := '  uniqueCode        : String;';
  Script.Add := '  idxBudgetDataset  : Integer;';
  Script.Add := 'const';
  Script.Add := '  EXTENDED_EMAIL = ''Email Locking Budget'';';

  Script.Add := '  procedure AddOverBudgetInfo;';
  Script.Add := '  var';
  Script.Add := '    accountTemplate    : String;';
  Script.Add := '    departmentTemplate : String;';
  Script.Add := '    projectTemplate    : String;';
  Script.Add := '  begin';
  Script.Add := '    budgetDataset.First;';
  Script.Add := '    with emailConfigINI do begin';
  Script.Add := '      accountTemplate    := ReadString (''Email'', ''BodyToAdmin6'', '''');';
  Script.Add := '      departmentTemplate := ReadString (''Email'', ''BodyToAdmin7'', '''');';
  Script.Add := '      projectTemplate    := ReadString (''Email'', ''BodyToAdmin8'', '''');';
  Script.Add := '    end;';

  Script.Add := '    for idxBudgetDataset := 0 to budgetDataset.RecordCount - 1 do begin';
  Script.Add := '      mailBody[6] := accountTemplate;';
  Script.Add := '      mailBody[7] := departmentTemplate;';
  Script.Add := '      mailBody[8] := projectTemplate;';

  Script.Add := '      with budgetDataset do begin';
  Script.Add := '        mailBody[6] := Format (mailBody[6], [FieldByName (''Nama Akun'').AsString '+
                                        ', FieldByName (''Akun Sisa Budget'').AsCurrency '+
                                        ', FieldByName (''Akun Nilai Transaksi'').AsCurrency]);';
  Script.Add := '        mailBody[7] := Format (mailBody[7], [FieldByName (''Dep. Sisa Budget'').AsCurrency '+
                                        ', FieldByName (''Dep. Nilai Transaksi'').AsCurrency]);';
  Script.Add := '        mailBody[8] := Format (mailBody[8], [FieldByName (''Proyek Sisa Budget'').AsCurrency '+
                                        ', FieldByName (''Proyek Nilai Transaksi'').AsCurrency]);';
  Script.Add := '      end;';

  Script.Add := '      FileVBScript.Add( Format(''strHTML.Add ("%s")'', [mailBody[6] ]) );';
  Script.Add := '      FileVBScript.Add( Format(''strHTML.Add ("%s")'', [mailBody[7] ]) );';
  Script.Add := '      FileVBScript.Add( Format(''strHTML.Add ("%s")'', [mailBody[8] ]) );';
  Script.Add := '      budgetDataset.Next;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := 'begin';
  Script.Add := '  FileVBScript   := TStringlist.Create;';
  Script.Add := '  emailSQL       := CreateSQL (TIBTransaction (Tx) );';
  Script.Add := '  emailConfigINI := TINIFile.Create (ExtractFilePath (Application.Exename) '+
                                     '+ ''LockingBudgetSetting.ini'');';
  Script.Add := '  try';
  Script.Add := '    SetEmail;';
  Script.Add := '    RunSQL (emailSQL, Format (''SELECT ED.INFO2 FROM EXTENDEDTYPE ET '+
                     'JOIN EXTENDEDDET ED ON ET.EXTENDEDTYPEID = ED.EXTENDEDTYPEID '+
                     'WHERE ET.EXTENDEDNAME = ''''%s'''' AND UPPER (ED.INFO1) = ''''%s'''' '' '+
                     ', [EXTENDED_EMAIL, get_active_user_name]) );';

  Script.Add := '    with emailConfigINI do begin';
  Script.Add := '      mailAddress := ReadString (''Email'', ''Admin''        , '''');';
  Script.Add := '      mailHeader  := ReadString (''Email'', ''HeaderToAdmin'', '''');';
  Script.Add := '      mailBody[1] := ReadString (''Email'', ''BodyToAdmin1'' , '''');';
  Script.Add := '      mailBody[2] := ReadString (''Email'', ''BodyToAdmin2'' , '''');';
  Script.Add := '      mailBody[3] := ReadString (''Email'', ''BodyToAdmin3'' , '''');';
  Script.Add := '      mailBody[4] := ReadString (''Email'', ''BodyToAdmin4'' , '''');';
  Script.Add := '      mailBody[5] := ReadString (''Email'', ''BodyToAdmin5'' , '''');';
  Script.Add := '      mailBody[9] := ReadString (''Email'', ''BodyToAdmin9'' , '''');';
  Script.Add := '    end;';

  Script.Add := '    DecodeDate (Master.' + txDate + '.Value, transYear, transMonth, transDay);';
  Script.Add := '    uniqueCode  := ''' + FormName + ''' + Format (''%.2d'', [transMonth]) '+
                                    '+ Master.' + txID + '.AsString + Format (''%.2d'', [transDay]) '+
                                    '+ IntToStr (userID) + Copy (IntToStr (transYear), 3, 4);';
  Script.Add := '    mailBody[1] := Format (mailBody[1], [''' + FormName + ''', Master.' + txNo + '.AsString '+
                                    ', Master.' + txDate + '.AsString]);';
  Script.Add := '    mailBody[9] := Format (mailBody[9], [uniqueCode, emailSQL.FieldByName (''INFO2'')]);';

  Script.Add := '    with FileVBScript do begin';
  Script.Add := '      Add(''Set msg = CreateObject("CDO.Message")'');';
  Script.Add := '      Add(''Set strHTML = CreateObject("System.Collections.ArrayList")'');';
  Script.Add := '      Add( Format(''strHTML.Add ("%s")'', [mailBody[1] ]) );';
  Script.Add := '      Add( Format(''strHTML.Add ("%s")'', [mailBody[2] ]) );';
  Script.Add := '      Add( Format(''strHTML.Add ("%s")'', [mailBody[3] ]) );';
  Script.Add := '      Add( Format(''strHTML.Add ("%s")'', [mailBody[4] ]) );';
  Script.Add := '      Add( Format(''strHTML.Add ("%s")'', [mailBody[5] ]) );';

  Script.Add := '      AddOverBudgetInfo;';

  Script.Add := '      Add( Format(''strHTML.Add ("%s")'', [mailBody[9] ]) );';
  Script.Add := '      Add( Format(''msg.From    = "%s"'', [MAIL_USER]) );';
  Script.Add := '      Add( Format(''msg.To      = "%s"'', [mailAddress]) );';
  Script.Add := '      Add( Format(''msg.Subject = "%s"'', [mailHeader]) );';
  Script.Add := '      Add(''msg.HTMLBody = join (strHTML.ToArray(), "")'');';

  Script.Add := '      Add(''msg.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2'');';
  Script.Add := '      Add( Format(''msg.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "%s"'', [SMTP_SERVER]) );';
  Script.Add := '      Add( Format(''msg.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = %s'', [SMTP_SERVER_PORT]) );';
  Script.Add := '      Add(''msg.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1'');';
  Script.Add := '      Add(''msg.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 30'');';
  Script.Add := '      Add( Format(''msg.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = "%s"'', [MAIL_USER]) );';
  Script.Add := '      Add( Format(''msg.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "%s"'', [MAIL_PASS]) );';
  Script.Add := '      Add( Format(''msg.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = %s '', [USE_SSL]) );';
//  Script.Add :=  '     Add(''msg.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendtls") = 1'');';
  Script.Add := '      Add(''msg.Configuration.Fields.Update'');';
  Script.Add := '      Add(''msg.Send'');';
  Script.Add := '      Add(''if err.number = 0 then MsgBox "Pemberitahuan Over Budget sudah dikirim"'');';
  Script.Add := '      SaveToFile(ExtractFilePath(Application.ExeName) + ''\EmailNotification.vbs'');';
  Script.Add := '    end;';
  Script.Add := '    ShellExecuteWait(ExtractFilePath(Application.ExeName) + ''\EmailNotification.vbs'', '''', '''');';
  Script.Add := '    DeleteFile (ExtractFilePath(Application.ExeName) + ''\EmailNotification.vbs'');';
  Script.Add := '  finally';
  Script.Add := '    maxItemAccount := 9;';
  Script.Add := '    emailSQL.Free;';
  Script.Add := '    FileVBScript.Free;';
  Script.Add := '    emailConfigINI.Free;';
  Script.Add := '  end;';

  Script.Add := 'end;';
end;


procedure TLockingBudgetInjector.ShowSettingEmailForm;
begin
  VarAndConst;

  Script.Add := '';
  Script.Add := 'procedure SetEmail;';
  Script.Add := 'begin';
  Script.Add := '  MAIL_USER        := ReadOption (''MAIL_USER'', '''');';
  Script.Add := '  MAIL_PASS        := ReadOption (''MAIL_PASS'', '''');';
  Script.Add := '  SMTP_SERVER      := ReadOption (''SMTP_SERVER'', '''');';
  Script.Add := '  SMTP_SERVER_PORT := ReadOption (''SMTP_SERVER_PORT'', '''');';
  Script.Add := '  USE_SSL          := ReadOption (''USE_SSL'', ''False'');';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure ShowSettingEmailForm;';
  Script.Add := 'var';
  Script.Add := '  frmEmailSetting   : TForm;';
  Script.Add := '  CheckRemind       : TCheckBox;';
  Script.Add := '  TxtUser           : TEdit;';
  Script.Add := '  TxtPass           : TEdit;';
  Script.Add := '  TxtSMTPServer     : TEdit;';
  Script.Add := '  TxtSMTPServerPort : TEdit;';
  Script.Add := '  CheckUseSSL       : TCheckBox;';

  Script.Add := '  procedure BtnOKClick;';
  Script.Add := '  begin';
  Script.Add := '    if CheckRemind.Checked then begin';
  Script.Add := '      WriteOption (''MAIL_USER''       , TxtUser.Text);';
  Script.Add := '      WriteOption (''MAIL_PASS''       , TxtPass.Text);';
  Script.Add := '      WriteOption (''SMTP_SERVER''     , TxtSMTPServer.Text);';
  Script.Add := '      WriteOption (''SMTP_SERVER_PORT'', TxtSMTPServerPort.Text);';
  Script.Add := '      WriteOption (''USE_SSL''         , BoolToStr (checkUseSSL.Checked) );';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      WriteOption (''MAIL_USER''       , '''');';
  Script.Add := '      WriteOption (''MAIL_PASS''       , '''');';
  Script.Add := '      WriteOption (''SMTP_SERVER''     , '''');';
  Script.Add := '      WriteOption (''SMTP_SERVER_PORT'', '''');';
  Script.Add := '      WriteOption (''USE_SSL''         , ''False'');';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '  procedure DecorateFormEmail;';
  Script.Add := '  var';
  Script.Add := '    BtnOKEmail        : TButton;';
  Script.Add := '    BtnCancelEmail    : TButton;';
  Script.Add := '    LblUser           : TLabel;';
  Script.Add := '    LblPass           : TLabel;';
  Script.Add := '    LblSMTPServer     : TLabel;';
  Script.Add := '    LblSMTPServerPort : TLabel;';
  Script.Add := '    LblKet            : TLabel;';
  Script.Add := '  const';
  Script.Add := '    SPACE = 10;';
  Script.Add := '  begin';
  Script.Add := '    LblUser      := CreateLabel ( SPACE, SPACE, 100, 15 '+
                                     ', ''Alamat Email'', frmEmailSetting);';
  Script.Add := '    TxtUser      := CreateEdit(100, LblUser.Top, 170, 20, frmEmailSetting);';
  Script.Add := '    TxtUser.Text := MAIL_USER;';

  Script.Add := '    LblPass              := CreateLabel( SPACE, LblUser.Top + LblUser.Height + SPACE, 100, 15 '+
                                             ', ''Password Email'', frmEmailSetting);';
  Script.Add := '    TxtPass              := CreateEdit(100, LblPass.Top, 170, 20, frmEmailSetting);';
  Script.Add := '    TxtPass.Text         := MAIL_PASS;';
  Script.Add := '    TxtPass.PasswordChar := ''*'';';

  Script.Add := '    LblSMTPServer      := CreateLabel( SPACE, LblPass.Top + LblPass.Height + SPACE, 100, 15 '+
                                           ', ''SMTP Server'', frmEmailSetting);';
  Script.Add := '    TxtSMTPServer      := CreateEdit(100, LblSMTPServer.Top, 170, 20, frmEmailSetting);';
  Script.Add := '    TxtSMTPServer.Text := SMTP_SERVER;';

  Script.Add := '    LblSMTPServerPort      := CreateLabel( SPACE, LblSMTPServer.Top + LblSMTPServer.Height + SPACE, 100, 15 '+
                                               ', ''SMTP Server Port'', frmEmailSetting);';
  Script.Add := '    TxtSMTPServerPort      := CreateEdit(100, LblSMTPServerPort.Top, 170, 20, frmEmailSetting);';
  Script.Add := '    TxtSMTPServerPort.Text := SMTP_SERVER_PORT;';

  Script.Add := '    CheckRemind         := CreateCheckBox( 100, LblSMTPServerPort.Top + LblSMTPServerPort.Height + SPACE, 100, 20 '+
                                            ', ''Remind Me'', frmEmailSetting);';
  Script.Add := '    CheckRemind.Checked := True;';

  Script.Add := '    CheckUseSSL         := CreateCheckBox( 100, CheckRemind.Top + CheckRemind.Height + SPACE, 100, 20 '+
                                            ', ''Use SSL'', frmEmailSetting);';
  Script.Add := '    CheckUseSSL.Checked := StrToBool (USE_SSL);';

  Script.Add := '    BtnOKEmail             := CreateBtn( (frmEmailSetting.ClientWidth Div 2) - 80 - 5 '+
                                               ', CheckUseSSL.Top + CheckUseSSL.Height + SPACE, 80, 35, 0 '+
                                               ', ''OK'', frmEmailSetting);';
  Script.Add := '    BtnOKEmail.ModalResult := mrOK;';
  Script.Add := '    BtnOKEmail.OnClick     := @BtnOKClick;';

  Script.Add := '    BtnCancelEmail             := CreateBtn( (frmEmailSetting.ClientWidth Div 2) + 5, btnOKEmail.Top '+
                                                   ', btnOKEmail.Width, btnOKEmail.Height, 0, ''Batal'', frmEmailSetting);';
  Script.Add := '    BtnCancelEmail.ModalResult := mrCancel;';

  Script.Add := '    LblKet          := CreateLabel( SPACE, BtnOKEmail.Top + BtnOKEmail.Height + 5, 270, 80'+
                                        ', ''Keterangan:'' + #10#13 + ''"Use SSL" tidak aktif secara sistem.'+
                                        ' Untuk SMTP yang mendukung SSL/TLS, silakan mengaktifkan "Use SSL".'', frmEmailSetting) ;';
  Script.Add := '    LblKet.AutoSize := False;';
  Script.Add := '    LblKet.WordWrap := True;';
  Script.Add := '  end;';

  Script.Add := 'begin';
  Script.Add := '  frmEmailSetting := CreateForm(''frmSettingEmail'', ''Setting Email'', 290, 320);';
  Script.Add := '  try';
  Script.Add := '    frmEmailSetting.BorderStyle := bsDialog;';
  Script.Add := '    SetEmail;';
  Script.Add := '    DecorateFormEmail;';
  Script.Add := '    frmEmailSetting.ShowModal;';
  Script.Add := '  finally';
  Script.Add := '    frmEmailSetting.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
end;

procedure TLockingBudgetInjector.VarAndConst;
begin
  Script.Add := 'const';
  Script.Add := '  DEFAULT_CUSTOM_FIELD = ''CUSTOMFIELD10'';';

  Script.Add := 'var';
  Script.Add := '  MAIL_USER         : String;';
  Script.Add := '  MAIL_PASS         : String;';
  Script.Add := '  SMTP_SERVER       : String;';
  Script.Add := '  SMTP_SERVER_PORT  : String;';
  Script.Add := '  USE_SSL           : String;';
  Script.Add := '  transYear         : Word;';
  Script.Add := '  transMonth        : Word;';
  Script.Add := '  transDay          : Word;';
  Script.Add := '  idxAccount        : Integer;';
  Script.Add := '  expenseDetail     : Boolean = False;';
  Script.Add := '  maxItemAccount    : Integer = 9;';
  Script.Add := '  budgetDataset     : TjvMemoryData;';
  Script.Add := '  comparatorDataset : TjvMemoryData;';
  Script.Add := '  hasValidationRun  : Boolean;';
  Script.Add := '  loopDetail        : Integer;';
  Script.Add := '  oldTransYear      : Word;';
  Script.Add := '  oldTransMonth     : Word;';
  Script.Add := '  oldTransDay       : Word;';
  Script.Add := '  isModified        : Boolean = False;';
end;

procedure TLockingBudgetInjector.OverBudgetField;
begin
  Script.Add := 'function GetOverBudgetField : String;';
  Script.Add := 'var';
  Script.Add := '  overBudgetFieldINI : TINIFile;';
  Script.Add := 'begin';
  Script.Add := '  overBudgetFieldINI := TINIFile.Create (ExtractFilePath (Application.Exename) '+
                                         '+ ''LockingBudgetSetting.ini'');';
  Script.Add := '  try';
  Script.Add := '    result := overBudgetFieldINI.ReadString (''OVER_BUDGET_SETTING'' '+
                               ', ''CustomField'', DEFAULT_CUSTOM_FIELD);';
  Script.Add := '  finally';
  Script.Add := '    overBudgetFieldINI.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
end;

procedure TLockingBudgetInjector.BudgetScript;
begin
  Script.Add := 'function isTransactionHistoryExist (historyStr : String) : Boolean;';
  Script.Add := 'var';
  Script.Add := '  historySQL : TjbSQL;';

  Script.Add := 'begin';
  Script.Add := '  historySQL := CreateSQL(TIBTransaction(Tx) );';
  Script.Add := '  try';
  Script.Add := '    RunSQL(historySQL, historyStr);';
  Script.Add := '    result := NOT historySQL.EOF;';
  Script.Add := '  finally';
  Script.Add := '    historySQL.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'function GetCalculationMethod : String;';
  Script.Add := 'var';
  Script.Add := '  loadSettingINI         : TINIFile;';
  Script.Add := '  periodAsOfAccState     : Boolean;';
  Script.Add := '  periodPerPeriodState   : Boolean;';
  Script.Add := '  budgetAmountEachState  : Boolean;';
  Script.Add := '  budgetAmountTotalState : Boolean;';

  Script.Add := 'begin';
  Script.Add := '  loadSettingINI := TINIFile.Create (ExtractFilePath (Application.Exename) '+
                                     '+ ''LockingBudgetSetting.ini'');';
  Script.Add := '  try';
  Script.Add := '    with loadSettingINI do begin';
  Script.Add := '      periodAsOfAccState     := ReadBool (''PERIOD'', ''AsOfAccumulation'', False);';
  Script.Add := '      periodPerPeriodState   := ReadBool (''PERIOD'', ''PerPeriod'', False);';
  Script.Add := '      budgetAmountEachState  := ReadBool (''BUDGET_AMOUNT'', ''Each'', False);';
  Script.Add := '      budgetAmountTotalState := ReadBool (''BUDGET_AMOUNT'', ''Total'', False);';
  Script.Add := '    end;';

  Script.Add := '    if periodAsOfAccState then begin';
  Script.Add := '      if budgetAmountEachState then begin';
  Script.Add := '        result := ''AccEach'';';
  Script.Add := '      end';
  Script.Add := '      else if budgetAmountTotalState then begin';
  Script.Add := '        result := ''AccTotal'';';
  Script.Add := '      end;';
  Script.Add := '    end';
  Script.Add := '    else if periodPerPeriodState then begin';
  Script.Add := '      if budgetAmountEachState then begin';
  Script.Add := '        result := ''PeriodEach'';';
  Script.Add := '      end';
  Script.Add := '      else if budgetAmountTotalState then begin';
  Script.Add := '        result := ''PeriodTotal'';';
  Script.Add := '      end;';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    loadSettingINI.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
end;

procedure TLockingBudgetInjector.GenerateScriptForProjectAndDepartmentBudget;
var
  idxPeriod : Integer;
const
  FIRST_MONTH_IDX = 4;
  LAST_MONTH_IDX  = 15;
begin
  ClearScript;
  AddFunction_CreateSQL;
  add_procedure_runsql;
  BudgetScript;

  Script.Add := 'var';
  Script.Add := Format('  budgetArr : array [%d..%d] of Currency;', [FIRST_MONTH_IDX, LAST_MONTH_IDX]);
  Script.Add := '  budgetGrid : TCPDBGrid;';

  Script.Add := '';
  Script.Add := 'function GetValueFromField (idxArr : Integer) : TField;';
  Script.Add := 'begin';
  Script.Add := '  result := budgetGrid.DataSource.Dataset.Fields.Fields[idxArr];';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure SetBudgetGrid;';
  Script.Add := 'begin';
  Script.Add := '  case Form.PageControl1.ActivePageIndex of';
  Script.Add := '    0 : budgetGrid := Form.BudgetRevenueGrid;';
  Script.Add := '    1 : budgetGrid := Form.BudgetItemGrid;';
  Script.Add := '    2 : budgetGrid := Form.BudgetExpenseGrid;';
  Script.Add := '    3 : budgetGrid := Form.BudgetBalShtGrid;';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure SavePrevBudget;';
  Script.Add := 'begin';
  for idxPeriod := FIRST_MONTH_IDX to LAST_MONTH_IDX do begin
    Script.Add := '  budgetArr[' + IntToStr(idxPeriod) + '] := '+
                     'GetValueFromField(' + IntToStr(idxPeriod) + ').AsCurrency;';
  end;
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure SetPrevBudget;';
  Script.Add := 'begin';
  Script.Add := '  SetBudgetGrid;';
  Script.Add := '  SavePrevBudget;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'function GetHistoryQuery : String;';
  Script.Add := 'const';
  Script.Add := '  GL_ACCOUNT_DS_IDX = 1;';
  Script.Add := '  PROJECT = ''Project'';';
  Script.Add := '  DEPARTMENT = ''Department'';';
  Script.Add := 'begin';
  Script.Add := '  if (Form.Label1.Caption = PROJECT) then begin';
  Script.Add := '    result := Format (''SELECT FIRST 1 GLACCOUNT FROM GLHIST GH '+
                               'JOIN PROJECT P ON GH.PROJECTID = P.PROJECTID '+
                               'WHERE GH.GLACCOUNT = ''''%s'''' AND GH.GLYEAR = %d '+
                               'AND P.PROJECTNO = ''''%s'''' '' '+
                               ', [GetValueFromField(GL_ACCOUNT_DS_IDX).AsString '+
                               ', Form.edtYear.AsInteger, Form.cedtProjectNo.Text]);';
  Script.Add := '  end';
  Script.Add := '  else if (Form.Label1.Caption = DEPARTMENT) then begin';
  Script.Add := '    result := Format (''SELECT FIRST 1 GLACCOUNT FROM GLHIST GH '+
                               'JOIN DEPARTMENT D ON GH.DEPTID = D.DEPTID '+
                               'WHERE GH.GLACCOUNT = ''''%s'''' AND GH.GLYEAR = %d '+
                               'AND D.DEPTNO = ''''%s'''' '' '+
                               ', [GetValueFromField(GL_ACCOUNT_DS_IDX).AsString '+
                               ', Form.edtYear.AsInteger, Form.cedtProjectNo.Text]);';
  Script.Add := '  end;';
  Script.Add := '  if (GetCalculationMethod = ''PeriodEach'') then begin';
  Script.Add := '    result := result + Format ('' AND GH.GLPERIOD = %d'', [(budgetGrid.SelectedIndex - 1)]);';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure ValidateBudget;';
  Script.Add := 'begin';
  Script.Add := '  if budgetArr[budgetGrid.SelectedIndex + 2] > GetValueFromField(budgetGrid.SelectedIndex + 2).AsCurrency then begin';
  Script.Add := '    if isTransactionHistoryExist (GetHistoryQuery) then begin;';
  Script.Add :='       budgetGrid.DataSource.Dataset.Cancel;';
  Script.Add := '      RaiseException (''Budget atas akun ini sudah digunakan'');';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure ValidateBudgetPreparation;';
  Script.Add := 'begin';
  Script.Add := '  SetBudgetGrid;';
  Script.Add := '  ValidateBudget;';
  Script.Add := 'end;';

  Script.Add := 'begin';
  Script.Add := '  DataModule.ATblBudgetBalSht.OnBeforeEditArray  := @SetPrevBudget;';
  Script.Add := '  DataModule.ATblBudgetItem.OnBeforeEditArray    := @SetPrevBudget;';
  Script.Add := '  DataModule.AtblBudgetRevenue.OnBeforeEditArray := @SetPrevBudget;';
  Script.Add := '  DataModule.ATblBudgetExpense.OnBeforeEditArray := @SetPrevBudget;';
  Script.Add := '  DataModule.ATblBudgetBalSht.OnBeforePostArray  := @ValidateBudgetPreparation;';
  Script.Add := '  DataModule.ATblBudgetItem.OnBeforePostArray    := @ValidateBudgetPreparation;';
  Script.Add := '  DataModule.AtblBudgetRevenue.OnBeforePostArray := @ValidateBudgetPreparation;';
  Script.Add := '  DataModule.ATblBudgetExpense.OnBeforePostArray := @ValidateBudgetPreparation;';
  Script.Add := 'end.';
end;

procedure TLockingBudgetInjector.GenerateScriptForAccountBudget;
var
  idxPeriod: Integer;
begin
  ClearScript;
  AddFunction_CreateSQL;
  add_procedure_runsql;
  BudgetScript;

  Script.Add := 'var';
  Script.Add := '  isValidBudget : Boolean = True;';
  Script.Add := '  budgetArr : array [1..12] of Currency;';

  Script.Add := '';
  Script.Add := 'procedure ValidateBudget (sender : TComponent);';

  Script.Add := '  function GetHistoryQuery : String;';
  Script.Add := '  begin';
  Script.Add := '    result := Format (''SELECT FIRST 1 GLACCOUNT FROM GLHIST '+
                               'WHERE GLACCOUNT = ''''%s'''' AND GLYEAR = %d '' '+
                               ', [Form.AeditGLAccount.Text, StrToInt (Form.AeditGLYear.Text)]);';
  Script.Add := '    if (GetCalculationMethod = ''PeriodEach'') then begin';
  Script.Add := '      result := result + Format ('' AND GLPERIOD = %d'', [StrToInt (GetNumeric(sender.Name))]);';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := 'begin';
  Script.Add := '  isValidBudget := True;';
  Script.Add := '  if budgetArr[StrToInt (GetNumeric(sender.Name) )] > '+
                   'StrSQLToCurr (StringReplace (TDBEdit (Form.FindComponent(sender.Name) ).Text, ThousandSeparator, '''') ) then begin';
  Script.Add := '    if isTransactionHistoryExist (GetHistoryQuery) then begin;';
  Script.Add := '      with TDBEdit (Form.FindComponent(''editAmount'' + GetNumeric(sender.Name) ) ) do begin';
  Script.Add := '        SetFocus;';
  Script.Add := '        Text := CurrToStrSQL (budgetArr[StrToInt (GetNumeric(sender.Name) ) ]);';
  Script.Add := '      end;';
  Script.Add := '      isValidBudget := False;';

  Script.Add := '      RaiseException (''Budget atas akun ini sudah digunakan'');';
  Script.Add := '    end;';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure DisableEvent;';
  Script.Add := 'begin';
  for idxPeriod := 1 to 12 do begin
    Script.Add := '  Form.AeditAmount' + IntToStr(idxPeriod) + '.OnExit := nil;';
  end;
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure CloseFormBudget (sender : TComponent; var Action : TCloseAction);';
  Script.Add := 'begin';
  Script.Add := '  Form.btnCancel.SetFocus;';
  Script.Add := '  if isValidBudget then begin';
  Script.Add := '    DisableEvent;';
  Script.Add := '    Action := caFree;';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'procedure SetPrevBudget;';
  Script.Add := 'begin';
  for idxPeriod := 1 to 12 do begin
    Script.Add := '  budgetArr[' + IntToStr(idxPeriod) + '] := StrSQLToCurr '+
                     '(StringReplace (Form.AeditAmount' + IntToStr(idxPeriod) + '.Text, ThousandSeparator, '''') );';
  end;
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  SetPrevBudget;';
  for idxPeriod := 1 to 12 do begin
    Script.Add := '  Form.AeditAmount' + IntToStr(idxPeriod) + '.OnExit := @ValidateBudget;';
  end;
  Script.Add := '  Form.OnClose := @CloseFormBudget;';
  Script.Add := 'end.';
end;

procedure TLockingBudgetInjector.GenerateScript;
begin
  inherited;
  GenerateScriptForMain;
  InjectToDB (fnMain);

  GenerateScriptForOP;
  InjectToDB(fnDirectPayment);

  GenerateScriptForOR;
  InjectToDB(fnOtherDeposit);

  GenerateScriptForJV;
  InjectToDB(fnJV);

  GenerateScriptForCR;
  InjectToDB(fnARPayment);

  GenerateScriptForVP;
  InjectToDB(fnAPCheque);

  GenerateScriptForPI;
  InjectToDB(fnAPInvoice);

  GenerateScriptForSI;
  InjectToDB(fnARInvoice);

  GenerateScriptForIA;
  InjectToDB(fnInvAdjustment);

  GenerateScriptForJC;
  InjectToDB(fnJobCosting);

  GenerateScriptForJVList;
  InjectToDB(fnJVs);

  GenerateScriptForCRList;
  InjectToDB(fnARPayments);

  GenerateScriptForVPList;
  InjectToDB(fnAPCheques);

  GenerateScriptForPIList;
  InjectToDB(fnAPInvoices);

  GenerateScriptForSIList;
  InjectToDB(fnARInvoices);

  GenerateScriptForIAList;
  InjectToDB(fnAdjInventories);

  GenerateScriptForJCList;
  InjectToDB(fnJobCosts);

  GenerateScriptForAccountBudget;
  InjectToDB(fnGLBudget);

  GenerateScriptForProjectAndDepartmentBudget;
  InjectToDB(fnProjectBudget);
  InjectToDB(fnDeptBudget);
end;

procedure TLockingBudgetInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := 'Locking Budget';
end;

end.
