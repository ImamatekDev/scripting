get = function() {
  return {
    name: 'Test JScript',
    GenerateScript: `function GenerateScript() {
      injectToDb(getFormName('fnSalesOrder'), GenerateScriptForSO());
    };`,
    GenerateScriptForSO: `function GenerateScriptForSO() {
return addNewLine([

"#language JScript",
"// Test Scripting dengan JScript, wajib menggunakan #language JScript agar mode script berubah dari PascalScript ke JScript",
"// Sumber : https://www.fast-report.com/public_download/fs_en.pdf",
"/* Akhiran kode boleh ada ; ataupun tidak*/",
'// Untuk string di JScript, wajib gunakan "(double quote)',

"",
"// Modif dari prosedur yang ada. Saat ini belum ambil dari Parent Class (TInjector)",
"function createSql(trans) {",
"var",
"  sql",
"",
"  sql = TjbSQL.Create(nil)",
"  sql.database = DB",
"  sql.transaction = trans",
"  return sql",
"}",
"",
"function runSql(qryObj, sql, execute) {",
"  qryObj.close",
"  qryObj.sql.text = sql",
"  if (execute) {",
"    qryObj.execQuery",
"  }",
"}",
"/////",
"",
"function showData() {",
'  showMessage(Master.SONO.AsString + " SCY")',
"}",
"",
"function showQueryData() {",
"",
"var",
"  dataSQL",
"  dataSQL = createSql(tx)",
"  try {",
'    runSql(dataSql, "SELECT FIRST 2 SONO FROM SO", true)',
"    while (!dataSql.eof) {",
'      showMessage("No. SO = " + dataSql.fieldByName("SONO") )',
"      dataSql.next",
"    }",
"  }",
"  finally {",
"    dataSQL.free",
"  }",
"}",
"",
"function loopData() {",
"var",
"  idxCounter",
"const",
"  MAX_COUNTER = 2",
"",
"  for (idxCounter = 0; idxCounter <= MAX_COUNTER; idxCounter++) {",
"    if (idxCounter == 2) {",
"      return idxCounter",
"    }",
"  }",
"}",
"",
'Master.on_before_save_array = "showData"',
'showMessage("Loop terakhir = " + inttostr (loopData() ) )',
"showQueryData()"

])};`,
  }
}
