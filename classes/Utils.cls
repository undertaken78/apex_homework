public with sharing class Utils {
    public static void checkDatabaseSaveResults(List<Database.SaveResult> saveResults,
            List<SObject> records, String errorSource) {
        String logMsg = '';
        for (Integer i = 0; i < saveResults.size(); i++) {
            if (saveResults[i].isSuccess()) continue;
            logMsg += 'DML operation failed for record: ' + records[i].Id + '\ncause:\n';
            for (Database.Error err: saveResults[i].getErrors()) {
                logMsg += err.getMessage() + '\n';
            }
        }
        if (String.isBlank(logMsg)) LogManager.log(errorSource, logMsg, true);
    }

}