get = ()=>{
  return {
    name: 'Testing DWP',
    GenerateScript: ()=>{
      //add script in form, list / dataset into fina
      injectToDb('fnSalesOrders', generateScriptForListSO());
      injectToDb('fnArinvoice', generateScriptForSI());
    },
    GlobalMessage: ()=>{
      return `
        function Message(){
            showMessage("Just show this message to you")
        }
      `
    },
    generateScriptForListSO: ()=>{
      return `
        #language JScript
        showMessage("Just show this message to you")
      ` 
    },
    
      generateScriptForSI: ()=>{
      return `
        #language JScript
        ${GlobalMessage()}

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
        
        Message()
      ` 
    }
  }
}
