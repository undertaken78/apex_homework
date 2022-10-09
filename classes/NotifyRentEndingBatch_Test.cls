@IsTest
private class NotifyRentEndingBatch_Test {
    // ТЕСТ КЛАСС В ПРОЦЕССЕ РАЗРАБОТКИ ( упустил required поля location wrapper и тд. )
    @TestSetup static void setup() {
        Contact customer = TestDataFactory.createContact('Test Contact', 'Owner 1');
        Contact seller = TestDataFactory.createContact('Test Contact', 'Owner 2');

        Property__c prop = TestDataFactory.createProperty('test', 999, 9, customer);

        Deal__c rent = TestDataFactory.createDeal(customer, seller, prop.Id);
        rent.RecordTypeId = NotifyRentEndingBatch.LEASE_RECORDTYPE;
        rent.Date_End_Rent__c = Datetime.now().addHours(3).addDays(1).date();
        insert rent;
    }
    

    @IsTest static void testBatch() {
        Test.startTest();
        Database.executeBatch(new NotifyRentEndingBatch(), 10);
        Test.stopTest();

        Test.getEventBus().deliver();
    }
}