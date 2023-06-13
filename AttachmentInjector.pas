unit AttachmentInjector;

interface
uses Injector, Sysutils;

type


  TAttachInjector = class(TInjector)
  private
    procedure GenerateScriptForSO;
    procedure GenerateScriptForSI;
    procedure GenerateScriptForDO;
    procedure GenerateScriptForCR;
    procedure GenerateScriptForPI;
    procedure GenerateScriptForPO;
    procedure GenerateScriptForPR;
    procedure GenerateScriptForRI;

    procedure GenerateScriptForSR;
    procedure GenerateScriptForVP;
    procedure GenerateScriptForGroup;
    procedure GenerateScriptForIA;
    procedure GenerateScriptForIR;
    procedure GenerateScriptForIT;
    procedure GenerateScriptForJC;
    procedure GenerateScriptForJV;
    procedure GenerateScriptForOP;
    procedure GenerateScriptForOR;
    procedure GenerateScriptForCust;
    procedure generateScriptForFA;
    procedure GenerateScriptForItem;  //MMD, BZ 3380
    procedure BeginScanEnd;
  protected
    procedure set_scripting_parameterize; override;
    procedure DoBegin;
    procedure DoEnd;
    procedure CreateBtnScan;
    procedure DoSO; virtual;
    procedure DoCR;   virtual;
    procedure DoCust; virtual;
    procedure DoDO;   virtual;
    procedure DoGRP;  virtual;
    procedure DoIA;   virtual;
    procedure DoIR;   virtual;
    procedure DoIT;   virtual;
    procedure DoJC;   virtual;
    procedure DoJV;   virtual;
    procedure DoOP;   virtual;
    procedure DoOR;   virtual;
    procedure DoPI;   virtual;
    procedure DoPO;   virtual;
    procedure DoPR;   virtual;
    procedure DoRI;   virtual;
    procedure DoSI;   virtual;
    procedure DoSR;   virtual;
    procedure DoVP;   virtual;
    procedure DOFA;   virtual;
    procedure DOItem; virtual;  //MMD, BZ 3380
  public
    procedure GenerateScript; override;
  end;

implementation
uses
  BankConst
  , ScriptConst;

{ TAttachInjector }

procedure TAttachInjector.CreateBtnScan;
begin
  Script.Add := '  CreateBtnScan;';
end;

procedure TAttachInjector.DoBegin;
begin
  Script.Add := 'begin';
end;

procedure TAttachInjector.DoEnd;
begin
  Script.Add := 'end.';
end;

procedure TAttachInjector.DOFA;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.BeginScanEnd;
begin
  DoBegin;
  CreateBtnScan;
  DoEnd;
end;

procedure TAttachInjector.DoSO;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DoDO;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DoSI;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DoSR;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DoCR;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DoPO;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DoRI;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DoPI;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DoVP;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DoPR;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DoIT;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DOItem;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DoJC;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DoIA;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DoIR;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DoGRP;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DoJV;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DoOP;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DoOR;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.DoCust;
begin
  BeginScanEnd;
end;

procedure TAttachInjector.GenerateScriptForSO;
begin
  AddScriptAttach('SONo', 'SO', DoSO);
end;

procedure TAttachInjector.GenerateScriptForDO;
begin
  AddScriptAttach('InvoiceNo', 'DO', DoDO);
end;

procedure TAttachInjector.generateScriptForFA;
begin
  AddScriptAttach('AssetCode', 'FA', DoFA, 'pnlJbButtons', '0', 'Form.btnResv4.Top+Form.btnResv4.Height+5');
end;

procedure TAttachInjector.GenerateScriptForSI;
begin
  AddScriptAttach('InvoiceNo', 'SI', DoSI);
end;

procedure TAttachInjector.GenerateScriptForSR;
begin
  AddScriptAttach('InvoiceNo', 'SR', DoSR, 'pnlJbButtons', '0', 'Form.btnPrintX.Top+Form.btnPrintX.Height+5');
end;

procedure TAttachInjector.GenerateScriptForCR;
begin
  AddScriptAttach('SequenceNo', 'CR', DoCR);
end;

procedure TAttachInjector.GenerateScriptForPO;
begin
  AddScriptAttach('PONO', 'PO', DoPO);
end;

procedure TAttachInjector.GenerateScriptForRI;
begin
  AddScriptAttach('SequenceNo', 'RI', DoRI);
end;

procedure TAttachInjector.GenerateScriptForPI;
begin
  AddScriptAttach('SequenceNo', 'PI', DoPI);
end;

procedure TAttachInjector.GenerateScriptForVP;
begin
  AddScriptAttach('SequenceNo', 'VP', DoVP, 'pnlJbButtons', '0', 'Form.btnResv2.Top + Form.btnResv2.Height+5');
end;

procedure TAttachInjector.GenerateScriptForPR;
begin
  AddScriptAttach('InvoiceNo', 'PR', DoPR, 'pnlJbButtons', '0', 'Form.btnPrintX.Top+Form.btnPrintX.Height+5');
end;

procedure TAttachInjector.GenerateScriptForIT;
begin
  AddScriptAttach('TransferNo', 'IT', DoIT, 'pnlJbButtons', '0', 'Form.btnResv3.Top+Form.btnResv3.Height+5');
end;

procedure TAttachInjector.GenerateScriptForItem;
begin
  AddScriptAttach('ItemNo', 'Item', DoItem, 'APanel2', '5', '5', '80');
end;

procedure TAttachInjector.GenerateScriptForJC;
begin
  AddScriptAttach('MfNo', 'JC', DoJC, 'pnlJbButtons', '0', 'Form.btnResv2.Top + Form.btnResv2.Height+5');
end;

procedure TAttachInjector.GenerateScriptForIA;
begin
  AddScriptAttach('AdjNo', 'IA', DoIA, 'pnlJbButtons', '0', 'Form.btnPrintX.Top+Form.btnPrintX.Height+5');
end;

procedure TAttachInjector.GenerateScriptForIR;
begin
  AddScriptAttach('TransferNo', 'IR', DoIR, 'pnlJbButtons', '0', 'Form.btnPrintX.Top+Form.btnPrintX.Height+5');
end;

procedure TAttachInjector.GenerateScriptForGroup;
begin
  AddScriptAttach('ItemNo', 'GRP', DoGRP, 'pnlJbButtons', '0', 'Form.btnPrintX.Top+Form.btnPrintX.Height+5');
end;

procedure TAttachInjector.GenerateScriptForJV;
begin
  AddScriptAttach('JVNumber', 'JV', DoJV);
end;

procedure TAttachInjector.GenerateScriptForOP;
begin
  AddScriptAttach('JVNumber', 'OP', DoOP, 'pnlJbButtons', '0', 'Form.btnPrintX.Top+Form.btnPrintX.Height+5');
end;

procedure TAttachInjector.GenerateScriptForOR;
begin
  AddScriptAttach('JVNumber', 'OR', DoOR, 'pnlJbButtons', '0', 'Form.btnPrintX.Top+Form.btnPrintX.Height+5');
end;

procedure TAttachInjector.GenerateScriptForCust;
begin
  AddScriptAttach('PersonNo', 'CUS', DoCust, 'APanel2', '5', '5', '80');
end;

procedure TAttachInjector.GenerateScript;
begin
  GenerateScriptForSO;
  InjectToDB( fnSalesOrder );

  GenerateScriptForDO;
  InjectToDB( fnDeliveryOrder );

  GenerateScriptForSI;
  InjectToDB( fnARInvoice);

  GenerateScriptForSR;
  InjectToDB( fnARRefund);

  GenerateScriptForCR;
  InjectToDB( fnARPayment);

  GenerateScriptForPO;
  InjectToDB( fnPurchaseOrder );

  GenerateScriptForRI;
  InjectToDB( fnReceiveItem );

  GenerateScriptForPI;
  InjectToDB( fnAPInvoice );

  GenerateScriptForVP;
  InjectToDB( fnAPCheque );

  GenerateScriptForPR;
  InjectToDB( fnDM );

  GenerateScriptForIT;
  InjectToDB( fnTransferForm );

  GenerateScriptForJC;
  InjectToDB( fnJobCosting );

  GenerateScriptForIA;
  InjectToDB( fnInvAdjustment );

  GenerateScriptForIR;
  InjectToDB( fnRequestForm );

  GenerateScriptForGroup;
  InjectToDB( fnGrouping );

  GenerateScriptForJV;
  InjectToDB( fnJV );

  GenerateScriptForOP;
  InjectToDB( fnDirectPayment );

  GenerateScriptForOR;
  InjectToDB( fnOtherDeposit );

  GenerateScriptForCust;
  InjectToDB( fnCustomer );

  generateScriptForFA;
  InjectToDB( fnFixAsset );

  //MMD, BZ 3380
  GenerateScriptForItem;
  InjectToDB( fnItem );
end;

procedure TAttachInjector.set_scripting_parameterize;
begin
  inherited;
  Self.feature_name := SCRIPTING_ATTACHMENT;
end;

end.
