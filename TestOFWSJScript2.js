get = function(){
  return {
   name: 'Test JScript',
   GenerateScript: function() {
     injectToDb(getFormName('fnSalesOrder'), generateScriptForSO());           
   },
   generateScriptForSO: function() {
     return `
       #language JScript
       function createSql(trans){
         var sql
         sql = TjbSQL.Create(nil)
         sql.database = DB
         sql.transaction = trans
         return sql
       }
       function showData(){
         showMessage(Master.SONO.AsString + 'SCY')
       }
       function showQueryData(){
         var dataSQL
         dataSQL = createSql(tx)
         try {
           runSql(dataSql, 'Select first 2 SONO from SO', true)
           while (!dataSql.eof) {
             showMessage('No. SO = ' + dataSql.fieldByName('SONO'))
             dataSql.next
           }
         } finally {
           dataSQL.free
         }
       }
       function loopData(){
         var idxCounter
         const MAX_COUNTER = 2
         for (idxCounter = 0; idxCounter <= MAX_COUNTER; idxCounter++){
           if (idxCounter==2){
             return idxCounter
           }
         }
       }
       Master.on_before_save_array = 'showData'
       showMessage('Loop terakhir = ' + inttostr( loopData() ))
       showQueryData()
     ` 
   }
 }
}
