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

        PropertyManager.PropertyWrapper propertyWrapper2 = new PropertyManager.PropertyWrapper();
        propertyWrapper2.address = 'testAddress2';
        propertyWrapper2.city = 'testCity2';
        propertyWrapper2.country = 'testCountry2';
        propertyWrapper2.propertyOwner = contactOwner2.Id;
        //propertyWrapper2.owner = contactOwner1.Id;
        propertyWrapper2.soldPrice = 9999;
        propertyWrapper2.rentPrice = 99;
        propertyWrapper2.longitude = 'testLongitude2';
        propertyWrapper2.latitude = 'testLatitude2';
        Property__c property2 = TestDataFactory.createProperty(propertyWrapper2, true);

        Deal__c dealLease1 = TestDataFactory.createDeal(contactOwner1, contactOwner2, property1.Id,
                LEASE_RECORDTYPE, Date.valueOf('2022-10-14'), Date.valueOf('2022-10-20'));

        Deal__c dealLease2 = TestDataFactory.createDeal(contactOwner1, contactOwner2, property2.Id,
                LEASE_RECORDTYPE, Date.valueOf('2022-9-14'), Date.valueOf('2022-9-20'));

        Deal__c dealSale1 = TestDataFactory.createDeal(contactOwner1, contactOwner2, property2.Id,
                SALE_RECORDTYPE);

        Deal__c dealSale2 = TestDataFactory.createDeal(contactOwner1, contactOwner2, property2.Id,
                SALE_RECORDTYPE);
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
                                       Address__c, Property_Owner__c, Longitude__c, Latitude__c
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
    @isTest static void updatePropertyOwnerTest() {
        Property__c prop = [SELECT Id FROM Property__c WHERE City__c = 'testCity1' LIMIT 1];

        SerializationWrapper.PropertyOwnerWrapper wrap = new SerializationWrapper.PropertyOwnerWrapper();
        wrap.propertyId = prop.Id;
        wrap.ownerClient = new SerializationWrapper.ClientWrapper();
        wrap.ownerClient.firstName = 'test25';
        wrap.ownerClient.lastName = 'test52';
        wrap.ownerClient.email = 'test25@gmail.ru';

        RestRequest request = new RestRequest();
        request.requestUri = 'https://senla62-dev-ed.my.salesforce.com/services/data/v55.0/sobjects/propery/v1';
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueOf(JSON.serialize(wrap));
        RestContext.request = request;

        String result = PropertyRESTService.updatePropertyOwner();

        System.assert(result != null);
        System.assert([SELECT Owner__r.Email__c FROM Property__c WHERE Owner__r.Email__c = 'newEmail@mail.ru'].Owner__r.Email__c == 'test25@gmail.ru');
    }
}