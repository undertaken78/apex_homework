@isTest
public with sharing class LogLWCManager_Test {
    static final String FIELDS = 'ObjectType__c, ActionType__c, Description__c, IsSuccessful__c, ErrorMessage__c';

    @testSetup 
    static void setup() {      
        LogLWC__c logLWC1 = TestDataFactory.createLogLWC('Property__c', 'Insert');
    }
    @isTest static void test1() {
        LogLWCManager.LogLWCWrapper wrapper = new LogLWCManager.LogLWCWrapper();
        wrapper.objectType = 'Property__c';
        wrapper.actionType = 'Insert';
        wrapper.description = 'description';
        wrapper.isSuccessful = true;
        wrapper.errorMessage = '';

        LogLWC__c logLWC = LogLWCManager.createLogLWC(wrapper, false);
        System.assertEquals('Property__c', logLWC.ObjectType__c);
    }

    @isTest static void test2() {
        List<LogLWC__c> logsLWCListTest = [SELECT Id FROM LogLWC__c];
        List<LogLWC__c> LogsLWCList = LogLWCManager.getLogsLWC(FIELDS);
        System.assertEquals(logsLWCListTest.size(), LogsLWCList.size());
    }
}