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

        function createSql(trans){
          let sql
          sql = TjbSQL.Create(nil)
          sql.database = DB
          sql.transaction = trans
          return sql
        }
      
        function runSql(qryObj, sql, execute) {
          qryObj.close
          qryObj.sql.text = sql
    
          if (execute) {
            qryObj.execQuery
          }
        }
        
        showMessage("Just show this message to you")
      ` 
    }
  }
}
