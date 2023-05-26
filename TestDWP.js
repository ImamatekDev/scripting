get = ()=>{
  return {
    name: 'Testing DWP',
    GenerateScript: ()=>{
      injectToDb('fnSalesOrders', generateScriptForListSO());
//    insert script into form, list / dataset into fina
    },
    
    generateScriptForListSO: ()=>{
      return `
        showMessage("Just show this message to you")
      ` 
    }
  }
}
