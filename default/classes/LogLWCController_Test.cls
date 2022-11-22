@isTest
public with sharing class LogLWCController_Test {
    static final String FIELDS = 'ObjectType__c, ActionType__c, Description__c, IsSuccessful__c, ErrorMessage__c';

    @testSetup 
    static void setup() {      
        LogLWC__c log1 = TestDataFactory.createLogLWC('Property__c', 'Insert');
    }

    @isTest static void test1() {
        LogLWC__c logLWC = LogLWCController.createLogLWC('Property__c', 'Insert', 'test', '');
        System.assertEquals('test', logLWC.Description__c);
    }

    @isTest static void test2() {
        List<LogLWC__c> logsLWCListTest = [SELECT Id FROM LogLWC__c];
        List<LogLWC__c> LogsLWCList = LogLWCController.getLogsLWC(FIELDS);
        System.assertEquals(logsLWCListTest.size(), LogsLWCList.size());
    }
}