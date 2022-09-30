public with sharing class LogManager {

    public enum TypeLogs {NONE, INTERNAL, FINEST, FINER, FINE, DEBUG, INFO, WARN, ERROR}

    public static List<Log__c> getLogsByTypes(List<String> types, String fields) {
        return Database.query('SELECT ' + fields + ' FROM Log__c WHERE Type__c IN :types');
    }

    public static Log__c createLog(String logType, String message, Boolean serialize) {

        Log__c log = new Log__c();

        log.Type__c = logType;
        log.Message__c = message;

        if(log.Type__c == null || log.Message__c == null) {
            return null;
        }

        if (serialize) insert log;
        return log;
    }

    public static Log__c updateLogById(Id id, String logType, Boolean serialize) {
        Log__c logToUpdate = [SELECT Type__c, Message__c FROM Log__c WHERE Id = :id LIMIT 1];

        logToUpdate.Type__c = String.isNotBlank(logType) ? logType : TypeLogs.ERROR.name();

        if (serialize) update logToUpdate;

        return logToUpdate;
    }

    public static void deleteLogsByTypes(List<String> types) {
        delete [SELECT Id FROM Log__c WHERE Type__c IN :types];
    }
}