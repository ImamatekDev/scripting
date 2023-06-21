get = ()=>{
  return {
    name: 'Test JScript',
    GenerateScript: ()=>{
      injectToDb('fnSalesOrder', generateScriptForSO());
      injectToDb('fnARInvoice', generateScriptForSI());
    },
    OtherJScriptFn: (inputArg)=>{
      return `
        function runOtherJScriptFn(${inputArg}, inputJScript) {
          showMessage(inputJs + " - " + inputJScript)
        }
      `
    },
    generateScriptForSO: ()=>{
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
        
        function showData(){
          showMessage(Master.SONO.AsString + "SCY")
        }
        
        function showQueryData(){
          let dataSQL
          dataSQL = createSql(tx)
          try {
            runSql(dataSql, "Select first 2 SONO from SO order by sono desc", true)
            while (!dataSql.eof) {
              showMessage("No. SO = " + dataSql.fieldByName("SONO"))
              dataSql.next
            }
          } finally {
            dataSQL.free
          }
        }
        
        function loopData(){
          let idxCounter
          const MAX_COUNTER = 2
          for (idxCounter = 0; idxCounter <= MAX_COUNTER; idxCounter++){
            if (idxCounter==2){
              return idxCounter
            }
          }
        }
        
        Master.on_before_save_array = "showData"
        showMessage("Loop terakhir = " + inttostr(loopData() ) )
        showQueryData()
        runOtherJScriptFn("a", "b")
      ` 
    },
    generateScriptForSI: ()=>{
      return `
        #language JScript
        
        ${unitTest()}     

        function doubleValue(a) {
          return a * 2;
        }        

        doubleValue(10)
      `
    },
    unitTest: ()=>{
      return `
        function dummytest() {
          const arg1 = 5 + 110;

          testData("double value", "10", doubleValue(arg1));
        }
        dummytest()
      `
    },
  }
}
