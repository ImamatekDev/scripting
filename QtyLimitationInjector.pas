unit QtyLimitationInjector;

interface
uses Injector, BankConst, SysUtils, ReadWriteFeatures;
type
  TQtyValidationInjector = class(TInjector)
  private
    procedure ValidateQuantity(transType, orderIDField, orderSeqField, InvIDField, remark : String);
    procedure SetQtyByUnitRatio;
  end;

  TSIDOQtyLimitationInjector = class(TQtyValidationInjector)
  protected
    procedure set_scripting_parameterize; override;
  public
    procedure GenerateScript; override;
  end;

  TPIRIQtyLimitationInjector = class(TQtyValidationInjector)
  protected
    procedure set_scripting_parameterize; override;
  public
    procedure GenerateScript; override;
  end;

implementation

{ TSIDOQtyLimitationInjector }

procedure TQtyValidationInjector.SetQtyByUnitRatio;
begin
  is_distro_variant;
  DetailExtended;

  Script.Add := 'procedure SetQtyByUnitRatio( AItemNo: String; AQtyRemain: Currency; '+
                ' AQty2: Currency = 1; AQty3: Currency = 1);';
  Script.Add := '  var sqlQty : TjbSQL;';

  Script.Add := '  ';
  Script.Add := '  function GetTextSQLQtyForDistro : String;';
  Script.Add := '  begin';
  Script.Add := '    result := Format (''SELECT (CASE WHEN RATIO2 = 0 OR COALESCE( %s, 0) <= 0 '+
                                        'THEN MOD3 ELSE MOD(MOD3, RATIO2) END) QTY1, '+
                                        '(CASE WHEN RATIO2 = 0 OR COALESCE( %s, 0) <= 0 '+
                                        'THEN 0 ELSE TRUNC(MOD3 / RATIO2) END) QTY2, '+
                                        'QTY3 '+

                                        'FROM (SELECT RATIO2, '+
                                             '(CASE WHEN RATIO3 = 0 OR COALESCE( %s, 0) <= 0 '+
                                             'THEN 0 ELSE TRUNC (QUANTITY / RATIO3) END) QTY3, '+
                                             '(CASE WHEN RATIO3 = 0 OR COALESCE( %s, 0) <= 0 '+
                                             'THEN QUANTITY ELSE MOD(QUANTITY, RATIO3) END) MOD3 '+

                                             'FROM (SELECT COALESCE(%s, 0) QUANTITY, '+
                                                  'COALESCE(A.RATIO2, 0) RATIO2, '+
                                                  'COALESCE(A.RATIO3, 0) RATIO3 '+

                                                  'FROM ITEM A '+
                                                  'WHERE A.ITEMNO = ''''%s'''') )'' '+
                                                  ', [CurrToStrSQL(AQty2), CurrToStrSQL(AQty2) '+
                                                  ', CurrToStrSQL(AQty3), CurrToStrSQL(AQty3) '+
                                                  ', CurrToStrSQL(AQtyRemain), AItemNo]);';
  Script.Add := '  end;';

  Script.Add := '  procedure FillMultiUnitValue;';
  Script.Add := '  begin';
  Script.Add := '    DetailExtended(GetUOM_QTY (''1'') ).AsCurrency := sqlQty.FieldByName(''Qty1'');';
  Script.Add := '    DetailExtended(GetUOM_QTY (''2'') ).AsCurrency := sqlQty.FieldByName(''Qty2'');';
  Script.Add := '    DetailExtended(GetUOM_QTY (''3'') ).AsCurrency := sqlQty.FieldByName(''Qty3'');';
  Script.Add := '  end;';

  Script.Add := 'begin';
  Script.Add := '  sqlQty := CreateSQL(TIBTransaction(Tx) );';
  Script.Add := '  try';
  Script.Add := '    if is_distribution_variant then begin';
  Script.Add := '      RunSQL(sqlQty, GetTextSQLQtyForDistro);';
  Script.Add := '      if not sqlQty.EOF then begin';
  Script.Add := '        FillMultiUnitValue;';
  Script.Add := '      end;';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      Detail.Quantity.AsCurrency := AQtyRemain;';
  Script.Add := '    end;';
  Script.Add := '  finally';
  Script.Add := '    sqlQty.Free;';
  Script.Add := '  end;';
  Script.Add := 'end;';
end;

procedure TQtyValidationInjector.ValidateQuantity (transType, orderIDField, orderSeqField, InvIDField, remark : String);
begin
  ClearScript;
  AddFunction_CreateSQL;
  add_procedure_runsql;
  ReadOption;

  Script.Add := 'var';
  Script.Add := '  orderQtyStr  : String;';
  Script.Add := '  preInvQtyStr : String;';

  Script.Add := '';
  Script.Add := 'function GetUOM_QTY (qtyIdx : String) : String;';
  Script.Add := 'begin';
  Script.Add := '  Result := ReadOption(''UOM_QTY'' + qtyIdx, ''CUSTOMFIELD'' + qtyIdx);';
  Script.Add := 'end;';

  SetQtyByUnitRatio;

  Script.Add := 'procedure ValidateQty;';
  Script.Add := 'var';
  Script.Add := '  vOrderQty : Currency = 0;';
  Script.Add := 'const';
  Script.Add := '  dsInsert = 3;';
  Script.Add := '  ';
  Script.Add := '  function GetOrderQty(queryQty : String; AOrderID, AOrderSEQ : Integer) : Currency;';
  Script.Add := '  var';
  Script.Add := '    sqlOrderQty : TjbSQL;';
  Script.Add := '  begin';
  Script.Add := '    result      := 0;';
  Script.Add := '    sqlOrderQty := CreateSQL(TIBTransaction(Tx) );';
  Script.Add := '    try';
  Script.Add := '      RunSQL(sqlOrderQty, Format (queryQty, [AOrderID, AOrderSEQ]) );';
  Script.Add := '      if not sqlOrderQty.EOF then begin';
  Script.Add := '        if sqlOrderQty.FieldByName(''QUANTITY'') > 0 then begin';
  Script.Add := '          result := sqlOrderQty.FieldByName(''QUANTITY'');';
  Script.Add := '        end;';
  Script.Add := '      end;';
  Script.Add := '    finally';
  Script.Add := '      sqlOrderQty.Free;';
  Script.Add := '    end;';
  Script.Add := '  end;';

  Script.Add := '';
  Script.Add := 'begin';
  Script.Add := '  if (Detail.FieldByName(''' + orderIDField + ''').IsNull OR (Detail.State = dsInsert) ) then begin';
  Script.Add := '    Exit;';
  Script.Add := '  end;';
  Script.Add := '  vOrderQty := GetOrderQty(orderQtyStr, Detail.FieldByName(''' + orderIDField + ''').AsInteger '+
                                ', Detail.FieldByName(''' + orderSeqField + ''').AsInteger );';
  Script.Add := '  vOrderQty := (vOrderQty + GetOrderQty(preInvQtyStr, Master.FieldByName(''' + InvIDField + ''').AsInteger '+
                                ', Detail.FieldByName(''SEQ'').AsInteger ) );';

  Script.Add := '  if (Detail.Quantity.AsCurrency > vOrderQty) then begin';
  Script.Add := '    if is_distribution_variant then begin';
  Script.Add := '      SetQtyByUnitRatio( Detail.ItemNo.AsString, vOrderQty '+
                       ' , DetailExtended(GetUOM_QTY (''2'') ).AsCurrency '+
                       ' , DetailExtended(GetUOM_QTY (''3'') ).AsCurrency ); ';
  Script.Add := '    end';
  Script.Add := '    else begin';
  Script.Add := '      SetQtyByUnitRatio( Detail.ItemNo.AsString, vOrderQty); ';
  Script.Add := '    end;';
  Script.Add := '    RaiseException(''Kuantitas ' + remark + ' melebihi kuantitas yang dipesan'');';
  Script.Add := '  end;';
  Script.Add := 'end;';

  Script.Add := '';
  Script.Add := 'begin';
  if (transType = 'Sales') then begin
    Script.Add := '  orderQtyStr  := ''SELECT COALESCE(QTY - QTY_RECV, 0) QUANTITY FROM '+
                                     '( '+
                                       'SELECT C.SOID, COALESCE( C.QTY, 0) QTY, SUM( COALESCE( F.QTY_RECV, 0) ) QTY_RECV FROM '+
                                       '( '+
                                         'SELECT A.SOID, A.SEQ, (A.QUANTITY * A.UNITRATIO) QTY FROM SODET A '+
                                         'JOIN EXTENDED B ON A.EXTENDEDID = B.EXTENDEDID) C LEFT JOIN '+

                                         '(SELECT D.SOID, D.SOSEQ, (D.QUANTITY * D.UNITRATIO) QTY_RECV FROM '+
                                         'ARINVDET D JOIN EXTENDED E ON D.EXTENDEDID = E.EXTENDEDID) F '+

                                         'ON (C.SOID = F.SOID AND C.SEQ = F.SOSEQ '+
                                       ') '+
                                     'WHERE C.SOID = %d AND C.SEQ = %d GROUP BY C.SOID, C.QTY) '';';
    Script.Add := '  preInvQtyStr := ''SELECT QUANTITY FROM ARINVDET '+
                                     'WHERE ARINVOICEID = %d AND SEQ = %d '';';
  end
  else if (transType = 'Purchase') then begin
    Script.Add := '  orderQtyStr  := ''SELECT COALESCE( (QUANTITY - QTYRECV), 0) QUANTITY FROM PODET '+
                                     'WHERE POID = %d AND SEQ = %d '';';
    Script.Add := '  preInvQtyStr := ''SELECT QUANTITY FROM APITMDET '+
                                     'WHERE APINVOICEID = %d AND SEQ = %d '';';
  end;
  Script.Add := '  Detail.Quantity.OnChangeArray := @ValidateQty;';
  Script.Add := 'end.';
end;

procedure TSIDOQtyLimitationInjector.GenerateScript;
begin
  inherited;
  ValidateQuantity ('Sales', 'SOID', 'SOSEQ', 'ARINVOICEID', 'dikirim');
  InjectToDB(fnDeliveryOrder);
  InjectToDB(fnARInvoice);
end;

procedure TSIDOQtyLimitationInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := 'SI / DO Quantity Limitation';
end;

{ TPIRIQtyLimitationInjector }

procedure TPIRIQtyLimitationInjector.GenerateScript;
begin
  inherited;
  ValidateQuantity ('Purchase', 'POID', 'POSEQ', 'APINVOICEID', 'diterima');
  InjectToDB(fnReceiveItem);
  InjectToDB(fnAPInvoice);
end;

procedure TPIRIQtyLimitationInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := 'PI / RI Quantity Limitation';
end;

end.
