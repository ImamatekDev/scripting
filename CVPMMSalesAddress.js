get = () => {
  return {
    name: 'CVPMM SALES ADDRESS',
    GenerateScript: () => {
      injectToDb('fnSalesOrder', generateScriptForSO());
      injectToDb('fnARRefund', generateScriptForSR());
      injectToDb('fnARPayment', generateScriptForCR());
    },

    generateScriptForSO: () => {
      return `
        #language JScript

        Form.AcboCustomer.LookUpDisplay = "NAME;ADDRESSLINE1;";
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

    generateScriptForSR: () => {
      return `
        #language JScript
        
        function setDisplay() {
          Form.AcboCustomer.LookUpDisplay = "NAME;ADDRESSLINE1;";
        }
        Form.AcboCustomer.OnEnter = "setDisplay";
      `
    },
    generateScriptForCR: () => {
      return `
        #language JScript
        
        Form.AcboBillTo.DropDownWidth = Form.AcboBillTo.Width;
        Form.AcboBillTo.LookUpDisplay = "NAME;ADDRESSLINE1;";
        Form.AcboBillTo.LookupSource.DataSet.FieldByName("Name").DisplayWidth = 40;
      `
    },
  }
}
