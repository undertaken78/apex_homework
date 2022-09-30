@IsTest
private class LogManager_Test {
    @testSetup
    static void setup() {
        List<Log__c> logsForDelete = new List<Log__c>{new Log__c(Type__c = 'FINEST', Message__c = 'test1'),
                                                      new Log__c(Type__c = 'DEBUG', Message__c = 'test2')};
        insert logsForDelete;
    }

    @isTest static void testCreateLog() {
        Log__c log = LogManager.createLog('FINEST','test', false);

        Test.startTest();
        Database.SaveResult result = Database.insert(log);
        Test.stopTest();
        System.assert(result.isSuccess());
    }

    @isTest static void testCreateLogIfNull() {
        Log__c log = LogManager.createLog(null, 'test', false);
        System.assertEquals(null, log);
    }

    @isTest static void testCreateLogIfNormal() {
        Log__c log = LogManager.createLog('DEBUG', 'test', false);
        System.assertEquals(new Log__c(Type__c = 'DEBUG', Message__c = 'test'), log);
    }

    @isTest static void testGetLogByTypes() {
        List<Log__c> logs = LogManager.getLogsByTypes(new List<String>{'DEBUG'}, 'Type__c');
        System.assertEquals(1, logs.size());
    }

    @IsTest static void testUpdateLogsTypesByIds() {
        Id logId = [SELECT Id FROM Log__c WHERE Type__c = 'FINEST' LIMIT 1].Id;
        Log__c createdList = [SELECT Type__c FROM Log__c WHERE Type__c = 'DEBUG' LIMIT 1];
        Log__c updatedList = createdList;
        updatedList = LogManager.updateLogById(logId, 'FINEST',true);
        System.assertNotEquals(updatedList, createdList);
    }

    @isTest static void testDeleteByTypes() {
        LogManager.deleteLogsByTypes(new List<String>{'FINEST'});
        System.assertEquals(new List<Log__c>(), [SELECT Type__c FROM Log__c WHERE Type__c =:new List<String>{'FINEST'}]);
    }
}