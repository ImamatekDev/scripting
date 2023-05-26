get = ()=>{
  return {
    name: 'Testing DWP',
    GenerateScript: ()=>{
      injectToDb('fnSalesOrders', generateScriptForListSO());
//    insert script into form, list / dataset into fina
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
      runOtherJScriptFn("a", "b")
      ` 
    }
  }
}
