@isTest
private class PropertyOwnerInfoController_Test {
    static final Id PROP_OWNER_TYPE = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Property Owner').getRecordTypeId();
	@testSetup
    static void setup() {
        Contact contactCustomer = new Contact(LastName = 'Customer', RecordTypeId = PROP_OWNER_TYPE);
        insert contactCustomer;

        Contact contactSeller = new Contact(LastName = 'Seller');
        insert contactSeller;

        PropertyManager.AddressWrapper wrapper = new PropertyManager.AddressWrapper('test','test','test');

        LocationWrapper__c locationWrapper = TestDataFactory.createLocationWrapper(wrapper);

        Property__c property = TestDataFactory.createProperty(1000,
                1000, contactCustomer, 'test', locationWrapper, wrapper);
        
        Property__c property1 = TestDataFactory.createProperty(2000,
                2000, contactCustomer, 'test', locationWrapper, wrapper);
        
        Property__c property2 = TestDataFactory.createProperty(1000,
                1000, contactCustomer, 'test', locationWrapper, wrapper);

        Deal__c deals1 = new Deal__c(Customer__c = contactSeller.Id,
                                     Seller__c = contactCustomer.Id,
                                     Selling_Property__c = property.Id,
                                     Status__c = 'Closed Won');
        insert deals1;

        Deal__c deals2 = new Deal__c(Customer__c = contactSeller.Id,
                            		Seller__c = contactCustomer.Id,
                            		Selling_Property__c = property1.Id,
                            		Status__c = 'Closed Won');
        insert deals2;
        
        Deal__c deals3 = new Deal__c(Customer__c = contactSeller.Id,
                            		Seller__c = contactCustomer.Id,
                            		Selling_Property__c = property2.Id,
                            		Status__c = 'Closed Won');
        insert deals3;
    }
    
    @isTest static void test1() {
        Contact contactSeller = [SELECT Id, LastName, Total_Property_Price__c FROM Contact WHERE LastName = 'Customer' LIMIT 1];
        
        ApexPages.currentPage().getParameters().put('id', contactSeller.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(contactSeller);
        PropertyOwnerInfoController control = new PropertyOwnerInfoController(controller);
        
        List<PropertyOwnerInfoController.DealWrapper> result = control.getDealList();
        System.assertEquals(3, result[0].dealsWonStatus);
        System.assertEquals(4000, result[0].dealAmountSum);
    }
}