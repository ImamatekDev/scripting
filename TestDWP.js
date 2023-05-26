get = ()=>{
  return {
    name: 'Testing DWP',
    GenerateScript: ()=>{
      injectToDb('fnSalesOrders', generateScriptForListSO());
    },
    
     OtherJScriptFn: (inputArg)=>{
      return `
        function runOtherJScriptFn(${inputArg}, inputJScript) {
          showMessage(inputJs + " - " + inputJScript)
        }
      `
    },
    
    generateScriptForListSO: ()=>{
      return `
      #language JScript
      ${OtherJScriptFn('inputJs')}
      
      showMessage("Just show this message to you")
      ` 
    }
  }
}
