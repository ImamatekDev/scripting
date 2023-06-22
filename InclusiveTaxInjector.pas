unit InclusiveTaxInjector;

interface
uses Injector, BankConst, Sysutils;

type
  TInclusiveTaxInjector = class(TInjector)
  private
    procedure SalesPurchaseTaxInc (FieldName, taxableFieldName : String);
    procedure GenerateScriptForSO;
    procedure GenerateScriptForSI;
    procedure GenerateScriptForSR;
    procedure GenerateScriptForPO;
    procedure GenerateScriptForPI;
    procedure GenerateScriptForPR;
    procedure SalesPurchaseMain (taxableFieldName: String);
  protected
    procedure set_scripting_parameterize; override;
  public
    procedure GenerateScript; override;
  end;
implementation

procedure TInclusiveTaxInjector.set_scripting_parameterize;
begin
  inherited;
  feature_name := 'Inclusive Tax';
end;

procedure TInclusiveTaxInjector.GenerateScriptForPI;
begin
  ClearScript;
  SalesPurchaseTaxInc('InclusiveTax', 'InvoiceIsTaxable');
  SalesPurchaseMain ('InvoiceIsTaxable');
end;

procedure TInclusiveTaxInjector.GenerateScriptForPO;
begin
  ClearScript;
  SalesPurchaseTaxInc ('InclusiveTax', 'VendorIsTaxable');
  SalesPurchaseMain ('VendorIsTaxable');
end;

procedure TInclusiveTaxInjector.GenerateScriptForPR;
begin
  ClearScript;
  SalesPurchaseTaxInc('InclusiveTax', 'IsTaxable');
  SalesPurchaseMain ('IsTaxable');
end;

procedure TInclusiveTaxInjector.GenerateScriptForSI;
begin
  ClearScript;
  SalesPurchaseTaxInc ('InclusiveTax', 'CustomerIsTaxable');
  SalesPurchaseMain ('CustomerIsTaxable');;
end;

procedure TInclusiveTaxInjector.GenerateScriptForSO;
begin
  ClearScript;
  SalesPurchaseTaxInc ('TaxInclusive', 'CustomerIsTaxable');
  SalesPurchaseMain ('CustomerIsTaxable');
end;

procedure TInclusiveTaxInjector.GenerateScriptForSR;
begin
  ClearScript;
  SalesPurchaseTaxInc ('InclusiveTax', 'CustomerIsTaxable');
  SalesPurchaseMain ('CustomerIsTaxable');
end;

procedure TInclusiveTaxInjector.SalesPurchaseTaxInc (FieldName, taxableFieldName: String);
begin
  Script.Add := 'procedure proTaxInc;';
  Script.Add := 'begin ';
  Script.Add := '  if Dataset.'+ taxableFieldName +'.Value = 1 then begin ';
  Script.Add := '    Dataset.'+ FieldName +'.Value := 1; ';
  Script.Add := '  end ';
  Script.Add := '  else begin ';
  Script.Add := '    Dataset.'+ FieldName +'.Value := 0; ';
  Script.Add := '  end; ';
  Script.Add := 'end; ';
  Script.Add := '';
end;

procedure TInclusiveTaxInjector.SalesPurchaseMain (taxableFieldName: String);
begin
  Script.Add := 'begin';
  Script.Add := '  Dataset.'+ taxableFieldName +'.OnChangeArray := @proTaxinc;';
  Script.Add := 'end.';
end;

procedure TInclusiveTaxInjector.GenerateScript;
begin
  GenerateScriptForSO;
  InjectToDB( dnSO );

  GenerateScriptForSI;
  InjectToDB( dnSI );

  GenerateScriptForSR;
  InjectToDB( dnSR );

  GenerateScriptForPO;
  InjectToDB( dnPO );

  GenerateScriptForPI;
  InjectToDB( dnPI );

  GenerateScriptForPR;
  InjectToDB( dnPR );
end;

end.
