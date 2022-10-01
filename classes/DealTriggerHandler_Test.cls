@IsTest
private class DealTriggerHandler_Test {
    @IsTest static void testTriggerHandler() {
        Contact firstContact = Utility.createContact('Pavel', 'Testovich');
        Contact secondContact = Utility.createContact('Alexey', 'Test');
        Contact thirdContact = Utility.createContact('Max', 'Testovoy');

        Property__c property = Utility.createProperty('ul. Testovaya', 9999,
                                                   99, thirdContact);

        Deal__c firstDeal = Utility.createDeal(firstContact, thirdContact, property.Id);
        Deal__c secondDeal = Utility.createDeal(secondContact, thirdContact, property.Id);
        firstDeal.Status__c = 'Closed Won';

        update firstDeal;

        secondDeal.Status__c = [SELECT Status__c FROM Deal__c WHERE Status__c = 'Closed Lost'
                                                                    AND Seller__c =:thirdContact.Id].Status__c;
        System.assertEquals('Closed Lost', secondDeal.Status__c);
    }
}