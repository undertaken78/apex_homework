public inherited sharing class LogManager {

    public static final String DEFAULT_TYPE = 'DEBUG';

    public class LogWrapper {
        public String logType {get; set;}
        public String message {get; set;}
    }

    public static List<Log__c> getLogsByIds(List<Id> ids, String fields) {
        return Database.query('SELECT ' + fields + ' FROM Log__c WHERE Id IN :ids');
    }

    public static List<Log__c> getLogsByTypes(List<Type> types, String fields) {
        return Database.query('SELECT ' + fields + ' FROM Log__c WHERE Type__c IN :types');
    }

    public static Log__c createLog(LogWrapper wrapper ,Boolean serialize) {
        Log__c log = new Log__c();
        log.Type__c = String.isNotBlank(wrapper.logType) ? wrapper.logType : DEFAULT_TYPE;
        log.Message__c = wrapper.message;

        if (serialize) insert log;

        return log;
    }

    public static List<Log__c> updateLogsByIds(List<Id> ids, LogWrapper wrapper, Boolean serialize) {
        List<Log__c> logsList = [SELECT Type__c, Message__c FROM Log__c WHERE Id IN :ids];
        List<Log__c> updatedLogsList = new List<Log__c>();

        for(Log__c log : logsList) {
            log.Type__c = wrapper.logType;
            log.Message__c = wrapper.message;
            updatedLogsList.add(log);
        }

        if (serialize) update updatedLogsList;

        return updatedLogsList;
    }

    public static Log__c updateLogById(Id id, LogWrapper wrapper, Boolean serialize) {
        Log__c logToUpdate = [SELECT Type__c, Message__c FROM Log__c WHERE Id = :id LIMIT 1];

        logToUpdate.Type__c = wrapper.logType;
        logToUpdate.Message__c = wrapper.message;

        if (serialize) update logToUpdate;

        return logToUpdate;
    }

    public static void deleteLogsByIds(List<String> types) {
        delete [SELECT Id FROM Log__c WHERE Type__c IN :types];
    }
}