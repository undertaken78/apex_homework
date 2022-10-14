@IsTest
private class PropertyRESTService_Test {

    static final Id SALE_RECORDTYPE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName()
            .get('Sale').getRecordTypeId();

    static final Id LEASE_RECORDTYPE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName()
            .get('Lease').getRecordTypeId();

    @TestSetup
    static void setup() {
        Contact contactOwner1 = TestDataFactory.createContact('testFirstName1','testLastName1','test1@gmail.com');
        Contact contactOwner2 = TestDataFactory.createContact('testFirstName2','testLastName2','test2@gmail.com');

        PropertyManager.PropertyWrapper propertyWrapper1 = new PropertyManager.PropertyWrapper();
        propertyWrapper1.address = 'testAddress1';
        propertyWrapper1.city = 'testCity1';
        propertyWrapper1.country = 'testCountry1';
        propertyWrapper1.propertyOwner = contactOwner1.Id;
        //propertyWrapper1.owner = contactOwner2.Id;
        propertyWrapper1.soldPrice = 1000;
        propertyWrapper1.rentPrice = 10;
        propertyWrapper1.longitude = 'testLongitude1';
        propertyWrapper1.latitude = 'testLatitude1';

        Property__c property1 = TestDataFactory.createProperty(propertyWrapper1, true);

        Deal__c dealLease1 = TestDataFactory.createDeal(contactOwner1, contactOwner2, property1.Id,
                LEASE_RECORDTYPE, Date.valueOf('2022-10-14'), Date.valueOf('2022-10-20'));
    }

    @IsTest static void getPropertyByOwnerTest() {
        Contact contactOwner = [SELECT Id FROM Contact WHERE Email = 'test1@gmail.com' LIMIT 1];
        RestRequest request = new RestRequest();
        request.requestURI = 'https://senla-dev-ed.my.salesforce.com/services/data/v55.0/sobjects/propery/v1/by_owner?owner=' + contactOwner.Id;
        request.httpMethod = 'GET';
        RestContext.request = request;

        String result = PropertyRESTService.getProperty();
        System.assert(result != null);

        List<Property__c> wrapperResult = (List<Property__c>)JSON.deserialize(result, List<Property__c>.class);
        System.assertEquals(contactOwner.Id, wrapperResult.get(0).Property_Owner__c);
    }

    @IsTest static void getPropertyByTypeAndDateTest() {
        Property__c prop = [SELECT Id FROM Property__c WHERE Sold_Price__c = 1000 LIMIT 1];
        RestRequest request = new RestRequest();
        request.requestURI = 'https://senla-dev-ed.my.salesforce.com/services/data/v55.0/sobjects/propery/v1/report/' + prop.Id +'?startDate=2022-10-14&endDate=2022-10-20&dealType=Lease';
        request.httpMethod = 'GET';
        RestContext.request = request;

        String result = PropertyRESTService.getProperty();
        System.assert(result != null);
    }

    @IsTest static void createPropertyTest() {
        Property__c property = [SELECT Id, Sold_Price__c, Country__c, City__c, Rent_Price__c,
                                       Address__c, Property_Owner__c, Longitude__c, Latitude__c, Owner__c
                                FROM Property__c WHERE Sold_Price__c = 1000 LIMIT 1];
        PropertyManager.PropertyWrapper wrapper = new PropertyManager.PropertyWrapper(property);

        RestRequest request = new RestRequest();
        request.requestURI = 'https://senla-dev-ed.my.salesforce.com/services/data/v55.0/sobjects/propery/v1/add';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(JSON.serialize(wrapper));
        RestContext.request = request;

        String result = PropertyRESTService.createProperty();
        System.assert(result != null);
        System.assert([SELECT COUNT() FROM Property__c WHERE Sold_Price__c = 1000] != 0);
    }

    // ДОРАБОТАТЬ
    @IsTest static void updatePropertyOwnerTest() {
        Property__c prop = [SELECT Id, Property_Owner__c FROM Property__c LIMIT 1];

        SerializationWrapper.PropertyOwnerWrapper wrapper = new SerializationWrapper.PropertyOwnerWrapper();
        wrapper.propertyId = prop.Property_Owner__c;
        wrapper.ownerClient = new SerializationWrapper.ClientWrapper();
        wrapper.ownerClient.firstName = 'test25';
        wrapper.ownerClient.lastName = 'test52';
        wrapper.ownerClient.email = 'test25@gmail.ru';

        RestRequest request = new RestRequest();
        request.requestURI = 'https://senla-dev-ed.my.salesforce.com/services/data/v55.0/sobjects/propery/v1';
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueOf(JSON.serialize(wrapper));
        RestContext.request = request;

        String result = PropertyRESTService.updatePropertyOwner();

        System.assert(result != null);
        System.assert([SELECT Property_Owner__r.Email FROM Property__c WHERE Property_Owner__r.Email = 'test25@gmail.ru'].Property_Owner__r.Email == 'test25@gmail.ru');
    }
}