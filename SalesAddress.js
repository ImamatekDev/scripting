get = () => {
  return {
    name: 'SALES ADDRESS',
    GenerateScript: () => {
      injectToDb('fnSalesOrder', generateScriptForSO());
      // injectToDb('fnARRefund', generateScriptForSR());
      // injectToDb('fnARPayment', generateScriptForCR());
    },

    generateScriptForSO: () => {
      return `
        #language JScript
        
        // ${unitTestSO()}

        // DataModule.qryWareHS.Active = False;
        // Insert(", DESCRIPTION ", DataModule.qryWareHS.SQL.Text, pos("from", DataModule.qryWareHS.SQL.Text) );
        // DataModule.qryWareHS.AddJbField("DESCRIPTION","TIBStringField", 40);
        // DataModule.qryWareHS.Active = True;
        Form.AcboCustomer.LookUpDisplay = ''NAME;ADDRESSLINE1;'';
      `
    },
    // unitTestSO: () => {
    //   return `
    //     function test() {
    //       testData("functionName", "input1", output1);
    //     }
    //     test()
    //   `
    // }
  }
}
