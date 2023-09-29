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
