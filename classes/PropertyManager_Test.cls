@IsTest
private class PropertyManager_Test {
    @TestSetup
    static void setup() {
        Contact firstContact = TestDataFactory.createContact('eskobar','pablo');

        Contact secondContact = TestDataFactory.createContact('test','pavlo');

        PropertyManager.AddressWrapper wrapper = new PropertyManager.AddressWrapper('test','test','test');

        LocationWrapper__c locationWrapper = TestDataFactory.createLocationWrapper(wrapper);

        TestDataFactory.createProperty(9999, 99, firstContact, 'test', locationWrapper, wrapper);

        TestDataFactory.createProperty(9999, 9, secondContact, 'test', locationWrapper, wrapper);
    }

    @IsTest static void testCreateProperty() {
        PropertyManager.PropertyWrapper wrapper = getWrapper();
        LocationWrapper__c locationWrapper = new LocationWrapper__c();
        locationWrapper.Country__c = 'test';
        locationWrapper.City__c = 'test';
        locationWrapper.Address__c = 'test';
        insert locationWrapper;

        Property__c property = PropertyManager.createProperty(wrapper, locationWrapper,false);

        Test.startTest();
        Database.SaveResult result = Database.insert(property);
        Test.stopTest();
        System.assert(result.isSuccess());
    }

    @IsTest static void testGetPropertiesByIds() {
        Id propertyId = [SELECT Id FROM Property__c WHERE Address__c = 'test' LIMIT 1].Id;
        List<Property__c> properties = PropertyManager.getPropertiesByIds(new List<String>{propertyId}, 'Address__c');
        System.assertEquals(1, properties.size());
    }

    @IsTest static void testGetPropertiesBySoldPrices() {
        Decimal propertyPrice = [SELECT Sold_Price__c FROM Property__c WHERE Address__c = 'test' LIMIT 1].Sold_Price__c;
        List<Property__c> properties = PropertyManager.getPropertiesBySoldPrices
                                                            (new List<Decimal>{propertyPrice}, 'Address__c');
        System.assertEquals(1, properties.size());
    }

    @IsTest static void testUpdatePropertiesByIds() {
        PropertyManager.PropertyWrapper wrapper = getWrapper();

        Id propertyId = [SELECT Id FROM Property__c WHERE Address__c = 'test' LIMIT 1].Id;

        List<Property__c> createdProperty =
                new List<Property__c>{[SELECT Address__c FROM Property__c WHERE Address__c = 'test' LIMIT 1]};

        List<Property__c> updatedProperty = createdProperty;

        updatedProperty = PropertyManager.updatePropertiesByIds(new List<Id>{propertyId},
                                                         'ul Pushkina',false);

        System.assertNotEquals(updatedProperty, createdProperty);
    }

    @IsTest static void testDelete() {
        PropertyManager.deletePropertiesByAddress(new List<String>{'test'});
        System.assertEquals(new List<Property__c>(),
                [SELECT Address__c FROM Property__c WHERE Address__c =:new List<String>{'test'}]);
    }

    private static PropertyManager.PropertyWrapper getWrapper() {

        Contact contact = new Contact(LastName = 'Alex');
        insert contact;

        PropertyManager.PropertyWrapper wrapper = new PropertyManager.PropertyWrapper();
        wrapper.propertyOwner = contact.Id;
        wrapper.rentPrice = 99;
        wrapper.soldPrice = 9910;
        return wrapper;
    }
}