@IsTest
private class NotifyRentEndingBatch_Test {
    @TestSetup static void setup() {
        Contact customer = TestDataFactory.createContact('test', 'test', 'test@yandex.ru');

        Contact seller = TestDataFactory.createContact('Test Contact', 'Owner 2', 'seller@mail.ru');

        Client__c client = new Client__c(Sfid__c = customer.Id, Email__c = 'undertaken789@gmail.com');
        insert client;

        PropertyManager.AddressWrapper wrapper = new PropertyManager.AddressWrapper('test', 'test', 'test');

        LocationWrapper__c location = TestDataFactory.createLocationWrapper(wrapper);

        Property__c prop = TestDataFactory.createProperty(999, 9, customer, 'test', location, wrapper, client);

        Deal__c rent = new Deal__c(Customer__c = customer.Id,Customer__r = customer, Seller__c = seller.Id,
                                   Selling_Property__c = prop.Id, Selling_Property__r = prop,
                                   RecordTypeId = DealManager.LEASE_RECORDTYPE,
                                   Date_End_Rent__c = Date.today().addDays(1));
        //rent.Customer__r.Email = 'sssharan@mail.ru';
        insert rent;
    }

    @IsTest static void testBatch() {
        Test.startTest();
        Database.executeBatch(new NotifyRentEndingBatch());
        Test.stopTest();
    }

    @IsTest static void testEmailSending() {
        Test.startTest();
        Database.executeBatch(new NotifyRentEndingBatch());
        Test.stopTest();
        System.assertEquals(0, [SELECT COUNT() FROM Log__c WHERE Type__c = 'EmailSender is failed']);
    }
}