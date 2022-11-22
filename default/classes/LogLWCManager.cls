public inherited sharing class LogLWCManager { 
    public class LogLWCWrapper{
        public String objectType {get; set;}
        public String actionType {get; set;}
        public String description {get; set;}
        public Boolean isSuccessful {get; set;}
        public String errorMessage {get; set;}
    }

    public static List<LogLWC__c> getLogsLWC(String fields) {
        return Database.query('SELECT ' + fields + ' FROM LogLWC__c');
    }

    public static LogLWC__c createLogLWC(LogLWCWrapper wrapper, Boolean serialize) {
        LogLWC__c log = new LogLWC__c();
        log.ObjectType__c = wrapper.objectType;
        log.ActionType__c = wrapper.actionType;
        log.Description__c = wrapper.description;
        log.IsSuccessful__c = wrapper.isSuccessful;
        log.ErrorMessage__c = wrapper.errorMessage;

        if (serialize) insert log;

        return log;
    }
}
