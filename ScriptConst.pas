unit ScriptConst;

interface

Const
  STR_SCRIPT_REQUEST_ID = 'SCRIPT_REQUEST_ID';

  INJECTOR_DATABASE_FILE_NAME = 'Injector.fdb';
  INJECTOR_DATABASE_USER_NAME = 'IMM';
  INJECTOR_DATABASE_PASSWORD = 'developer';
  INJECTOR_COMMAND_FORMAT = STR_SCRIPT_REQUEST_ID + ':%s|%s';

  //SCRIPTING_DEVELOPER_PASSWORD = 'ImmDeveloper2013';
  SCRIPTING_DEVELOPER_PASSWORD = 'Imm@2022';
  SCRIPTING_ADMINISTRATOR_PASSWORD = 'ScriptAdmin2013';

  SCRIPTING_DEFAULT_FEATURE_NAME = 'Custom-built';
  SCRIPTING_BATCH_NUMBER = 'Batch number';
  SCRIPTING_ATTACHMENT   = 'Attachment';
  SCRIPTING_RUNNING_FP   = 'Running FP No';
  SCRIPTING_JC_INPUT_SN  = 'JC RO Input SN';
  SCRIPTING_MFG_DIRECT   = 'Manufacturing Direct';
  SCRIPTING_SO_OVERLIMIT_APPROVAL = 'SO Overlimit Approval';
  SCRIPTING_QUOTATION    = 'Quotation';
  SCRIPTING_MFG_WITH_MPS = 'Mfg with MPS';
  SCRIPTING_DEFAULT_USD  = 'Default USD';
  SCRIPTING_IMPORT_SN_FILE = 'Import SN from File';
  SCRIPTING_REPORT_MENU  = 'Report Menu';
  SCRIPTING_RUNNING_NUMBER = 'Running Number';
  SCRIPTING_EXCLUSIVE_MULTI_BRANCH = 'Exclusive Multi Branch';
  SCRIPTING_ITEM_TARGET = 'Item Sales Target';
  SCRIPTING_GIT         = 'Goods In Transit';
  SCRIPTING_WALLPAPER    = 'Wall paper';

  OPTIONS_PARAM_NAME_BATCH_NO_FIELD = 'ITEM_BATCH_NO_FIELD';
  DEFAULT_BATCH_NO_FIELD = 'Reserved2';
  OPTIONS_PARAM_NAME_EXPIRED_DATE_FIELD = 'ITEM_EXPIRED_DATE_FIELD';
  DEFAULT_EXPIRED_DATE_FIELD = 'Reserved3';
  OPTIONS_PARAM_NAME_REQUIRED_BATCH_NO_FIELD = 'ITEM_EXTENDED_REQUIRED_BATCH_NO_FIELD';
  OPTIONS_PARAM_NAME_AUTO_FILL_BATCH_NO = 'AUTO_FILL_BATCH_NO';
  OPTIONS_PARAM_NAME_USER_CHECK = 'BN_USER_CHECK';

implementation

end.
