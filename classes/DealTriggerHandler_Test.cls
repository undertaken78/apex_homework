@IsTest
private class DealTriggerHandler_Test {
    @IsTest static void testTriggerHandler() {
        Contact firstCustomer = TestDataFactory.createContact('Pavel', 'Testovich');
        Contact secondCustomer = TestDataFactory.createContact('Alexey', 'Test');
        Contact sellerContact = TestDataFactory.createContact('Max', 'Testovoy');

        Property__c property = TestDataFactory.createProperty('ul. Testovaya', 9999,
                                                   99, sellerContact);

        Deal__c firstDeal = TestDataFactory.createDeal(firstCustomer, sellerContact, property.Id);
        Deal__c secondDeal = TestDataFactory.createDeal(secondCustomer, sellerContact, property.Id);
        firstDeal.Status__c = 'Closed Won';

        update firstDeal;

        System.assertEquals('Closed Lost', [SELECT Status__c FROM Deal__c
                                            WHERE Status__c = 'Closed Lost'
                                            AND Selling_Property__c =: secondDeal.Selling_Property__c].Status__c);
    }
}