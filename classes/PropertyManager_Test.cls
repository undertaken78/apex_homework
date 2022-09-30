@IsTest
private class PropertyManager_Test {
    @TestSetup
    static void setup() {
        Contact firstContact = new Contact(LastName = 'pablo');
        insert firstContact;

        Contact secondContact = new Contact(LastName = 'pavlo');
        insert secondContact;

        Property__c firstProperty = new Property__c(Address__c= 'ul. Pushkina',
                                                  Rent_Price__c = 10,
                                                  Sold_Price__c = 1000,
                                                  Property_Owner__c = firstContact.Id);
        insert firstProperty;

        Property__c secondProperty = new Property__c(Address__c= 'test',
                Rent_Price__c = 5,
                Sold_Price__c = 500,
                Property_Owner__c = secondContact.Id);
        insert secondProperty;
    }

    @IsTest static void testCreateContactById() {
        PropertyManager.PropertyWrapper wrapper = getWrapper();

        Property__c property = PropertyManager.createProperty(wrapper,false);

        Test.startTest();
        Database.SaveResult result = Database.insert(property);
        Test.stopTest();
        System.assert(result.isSuccess());
    }

    @isTest static void testGetPropertiesByIds() {
        Id propertyId = [SELECT Id FROM Property__c WHERE Address__c = 'ul. Pushkina'].Id;
        List<Property__c> properties = PropertyManager.getPropertiesByIds(new List<String>{propertyId}, 'Address__c');
        System.assertEquals(1, properties.size());
    }

    @isTest static void testGetPropertiesBySoldPrices() {
        Decimal propertyPrice = [SELECT Sold_Price__c FROM Property__c WHERE Address__c = 'ul. Pushkina'].Sold_Price__c;
        List<Property__c> properties = PropertyManager.getPropertiesBySoldPrices
                                                            (new List<Decimal>{propertyPrice}, 'Address__c');
        System.assertEquals(1, properties.size());
    }

    @IsTest static void testUpdatePropertiesByIds() {
        PropertyManager.PropertyWrapper wrapper = getWrapper();

        Id propertyId = [SELECT Id FROM Property__c WHERE Address__c = 'ul. Pushkina' LIMIT 1].Id;

        List<Property__c> createdProperty =
                new List<Property__c>{[SELECT Address__c FROM Property__c WHERE Address__c = 'ul. Pushkina' LIMIT 1]};

        List<Property__c> updatedProperty = createdProperty;

        updatedProperty = PropertyManager.updatePropertiesByIds(new List<Id>{propertyId},
                                                         'ul Pushkina',false);

        System.assertNotEquals(updatedProperty, createdProperty);
    }

    @isTest static void testDelete() {
        PropertyManager.deletePropertiesByAddress(new List<String>{'ul. Pushkina'});
        System.assertEquals(new List<Property__c>(),
                [SELECT Address__c FROM Property__c WHERE Address__c =:new List<String>{'ul. Pushkina'}]);
    }

    private static PropertyManager.PropertyWrapper getWrapper() {
        PropertyManager.PropertyWrapper wrapper = new PropertyManager.PropertyWrapper();
        Contact contact = new Contact(LastName = 'Alex');
        insert contact;
        wrapper.propertyOwner = contact.Id;
        wrapper.address = 'ul. Himikov';
        wrapper.rentPrice = 99;
        wrapper.soldPrice = 9910;
        return wrapper;
    }
}