@IsTest
private class CommissionsPercentManager_Test {
    @TestSetup
    static void setup() {
        Contact contactCustomer = new Contact(LastName = 'Customer');
        insert contactCustomer;

        Contact contactSeller = new Contact(LastName = 'Seller');
        insert contactSeller;

        Property__c property = new Property__c(Property_Owner__c = contactCustomer.Id,
                Sold_Price__c = 10000, Rent_Price__c = 50,
                Address__c = 'ul. Testovaya');
        insert property;

        Deal__c deal =
                new Deal__c(Customer__c = contactCustomer.Id,
                            Seller__c = contactSeller.Id,
                            Selling_Property__c = property.Id,
                            Status__c = 'Open');
        insert deal;

        Commissions_Percent__c firstPercent =
                new Commissions_Percent__c(Brokers_Percent__c = 10,
                                           Commission_Deal__c = deal.Id,
                                           Commission_Contact__c = contactCustomer.Id);
        insert firstPercent;

        Commissions_Percent__c secondPercent =
                new Commissions_Percent__c(Brokers_Percent__c = 15,
                        Commission_Deal__c = deal.Id,
                        Commission_Contact__c = contactCustomer.Id);
        insert secondPercent;
    }

    @isTest static void testCreate() {
        Id contactId = [SELECT Id FROM Contact WHERE LastName = 'Customer'].Id;
        Id dealId = [SELECT Id FROM Deal__c WHERE Status__c = 'Open'].Id;
        Commissions_Percent__c percent = CommissionsPercentManager.createCommissionsPercent(10,contactId, dealId, false);

        Test.startTest();
        Database.SaveResult result = Database.insert(percent);
        Test.stopTest();
        System.assert(result.isSuccess());
    }

    @isTest static void testGet() {
        Id percentId = [SELECT Id FROM Commissions_Percent__c WHERE Brokers_Percent__c = 10].Id;
        List<Commissions_Percent__c> percents = CommissionsPercentManager.getCommissionPercentsByIds(new List<String>{percentId}, 'Id');
        System.assertEquals(1, percents.size());
    }

    @IsTest static void testUpdate() {
        Id percentId = [SELECT Id FROM Commissions_Percent__c WHERE Brokers_Percent__c = 10 LIMIT 1].Id;
        List<Commissions_Percent__c> createdList =
                        [SELECT Brokers_Percent__c FROM Commissions_Percent__c
                         WHERE Brokers_Percent__c = 15];
        List<Commissions_Percent__c> updatedList = createdList;
        updatedList = CommissionsPercentManager.updateCommissionsPercents(new List<Id>{percentId},
                                                                   10,true);
        System.assertNotEquals(updatedList, createdList);
    }

    @isTest static void testDelete() {
        CommissionsPercentManager.deleteCommissionPercentsByBrokersPercent(new List<Decimal>{10});
        System.assertEquals(new List<Commissions_Percent__c>(),
                            [SELECT Brokers_Percent__c FROM Commissions_Percent__c
                             WHERE Brokers_Percent__c =:new List<Decimal>{10}]);
    }
}