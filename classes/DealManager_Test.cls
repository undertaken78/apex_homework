@isTest
private class DealManager_Test {
    @testSetup
    static void setup() {
        Contact contactCustomer = new Contact(LastName = 'Customer');
        insert contactCustomer;

        Contact contactSeller = new Contact(LastName = 'Seller');
        insert contactSeller;

        Property__c property = new Property__c(Property_Owner__c = contactCustomer.Id,
                                               Sold_Price__c = 10000, Rent_Price__c = 50,
                                                Address__c = 'ul. Testovaya');
        insert property;

        List<Deal__c> deals1 = new List<Deal__c>{new Deal__c(Customer__c = contactCustomer.Id,
                                                            Seller__c = contactSeller.Id,
                                                            Selling_Property__c = property.Id,
                                                            Status__c = 'Awaiting Approval')};
        insert deals1;

        List<Deal__c> deals2 = new List<Deal__c>{new Deal__c(Customer__c = contactCustomer.Id,
                Seller__c = contactSeller.Id,
                Selling_Property__c = property.Id,
                Status__c = 'Open')};
        insert deals2;
    }

    @isTest static void testCreateDeal() {
        DealManager.DealWrapper wrapper = getWrapper();
        Deal__c deal = DealManager.createDeal(wrapper, false);

        Test.startTest();
        Database.SaveResult result = Database.insert(deal);
        Test.stopTest();
        System.assert(result.isSuccess());
    }

    @isTest static void testGetDealsByStatuses() {
        List<Deal__c> deals = DealManager.getDealsByStatuses(new List<String>{'Awaiting Approval'}, 'Status__c');
        System.assertEquals(1, deals.size());
    }

    @IsTest static void testUpdateDealsByIds() {
        DealManager.DealWrapper wrapper = getWrapper();

        Id dealId = [SELECT Id FROM Deal__c WHERE Status__c = 'Awaiting Approval' LIMIT 1].Id;
        Deal__c createdList = [SELECT Status__c FROM Deal__c WHERE Status__c = 'Open' LIMIT 1];
        Deal__c updatedList = createdList;
        updatedList = DealManager.updateDealsByIds(dealId, wrapper,false);
        System.assertNotEquals(updatedList, createdList);
    }

    @isTest static void testDeleteByStatus() {
        DealManager.deleteDealsByStatus(new List<String>{'Awaiting Approval'});
        System.assertEquals(new List<Deal__c>(),
                           [SELECT Status__c FROM Deal__c WHERE Status__c =:new List<String>{'Awaiting Approval'}]);
    }

    private static DealManager.DealWrapper getWrapper() {
        DealManager.DealWrapper wrapper = new DealManager.DealWrapper();
        wrapper.seller = [SELECT Id FROM Contact WHERE LastName = 'Seller' LIMIT 1].Id;
        wrapper.customer = [SELECT Id FROM Contact WHERE LastName = 'Customer' LIMIT 1].Id;
        wrapper.recordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Lease').getRecordTypeId();
        wrapper.rentStartDate = Date.today();
        wrapper.rentEndDate = Date.today().addMonths(6);
        wrapper.sellingProperty = [SELECT Id FROM Property__c WHERE Address__c = 'ul. Testovaya' LIMIT 1].Id;
        return wrapper;
    }
}