@IsTest
public with sharing class TestDataFactory {

    public static final Id DEFAULT_DEAL_TYPE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName()
            .get('Sale').getRecordTypeId();

    public static final Id CEO_ROLE = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1].Id;

    public static final Id IDENTITY_USER_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'Identity User' LIMIT 1].Id;

    public static final Id STANDARD_PLATFORM_USER_PROFILE_ID =
            [SELECT Id FROM Profile WHERE Name = 'Standard Platform User' LIMIT 1].Id;

    public static Info__c getInfo(Deal__c deal, Boolean serialize) {

        Client__c client = new Client__c();
        client.Sfid__c = deal.Customer__r.Id;
        client.FirstName__c = String.isBlank(deal.Customer__r.FirstName) ? deal.Customer__r.FirstName : '';
        client.LastName__c = String.isBlank(deal.Customer__r.LastName) ? deal.Customer__r.LastName : '';
        client.Email__c = deal.Customer__r.Email;

        if(serialize) insert client;

        LocationWrapper__c locationWrapper = new LocationWrapper__c();
        locationWrapper.Country__c = deal.Selling_Property__r.Country__c;
        locationWrapper.City__c = deal.Selling_Property__r.City__c;
        locationWrapper.Address__c = deal.Selling_Property__r.Address__c;
        locationWrapper.Latitude__c = String.isBlank(deal.Selling_Property__r.Latitude__c) ? deal.Selling_Property__r.Latitude__c : '';
        locationWrapper.Longitude__c = String.isBlank(deal.Selling_Property__r.Longitude__c) ? deal.Selling_Property__r.Longitude__c : '';

        if(serialize) insert locationWrapper;

        Property__c property = deal.Selling_Property__r;
        property.Location__r = locationWrapper;

        if(serialize) update property;

        Info__c info = new Info__c();
        info.CreateDate__c = Datetime.now();
        info.RentEndDate__c = deal.Date_End_Rent__c;
        info.RentStartDate__c = deal.Date_Start_Rent__c;
        info.Client__c = client.Id;
        info.Property__c = property.Id;

        if(serialize) insert info;

        return info;
    }

    public static Log__c createLog() {
        Log__c log = new Log__c(Type__c = 'FINEST', Message__c = 'No errors');
        insert log;
        return log;
    }

    public static Log__c createLog(String type, String message) {
        Log__c log = new Log__c(Type__c = type, Message__c = message);
        insert log;
        return log;
    }

    public static List<Property__c> createProperties(Integer counter, List<Id> ids) {
        List<Property__c> properties = new List<Property__c>(counter);
        for (Integer i = 0; i < counter && i < ids.size(); i++) {
            properties[i] = new Property__c(Address__c = 'street Pushkina, house Kolotushkina ' + i + 'A',
                                            Rent_Price__c = 0.9 * i,
                    Sold_Price__c = 3 * i, Property_Owner__c = ids[i]);
        }
        insert properties;
        return properties;
    }

    public static Property__c createProperty(Decimal rentPrice, Decimal soldPrice, Contact propertyOwner,
            String sfId, LocationWrapper__c location, PropertyManager.AddressWrapper wrapper) {

        Property__c property = new Property__c(Address__c = wrapper.address, Rent_Price__c = rentPrice,
                Sold_Price__c = soldPrice, Property_Owner__c = propertyOwner.Id,
                Country__c = wrapper.country, City__c = wrapper.city,
                Sfid__c = sfId, Location__c = location.Id);

        insert property;
        return property;
    }

    public static Property__c createProperty(Decimal rentPrice, Decimal soldPrice, Contact propertyOwner,
            String sfId, LocationWrapper__c location, PropertyManager.AddressWrapper wrapper, Client__c client) {

        Property__c property = new Property__c(Address__c = wrapper.address, Rent_Price__c = rentPrice,
                Sold_Price__c = soldPrice, Property_Owner__c = propertyOwner.Id,
                Country__c = wrapper.country, City__c = wrapper.city,
                Sfid__c = sfId, Location__c = location.Id, Owner__c = client.Id);

        insert property;
        return property;
    }

    public static LocationWrapper__c createLocationWrapper(PropertyManager.AddressWrapper wrapper) {
        LocationWrapper__c location = new LocationWrapper__c();
        location.Country__c = wrapper.country;
        location.City__c = wrapper.city;
        location.Address__c = wrapper.address;
        insert location;
        return location;
    }

    public static Contact createContact(String firstName, String lastName) {
        Contact contact = new Contact(FirstName = firstName, LastName = lastName);
        contact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName()
                .get('Broker').getRecordTypeId();
        insert contact;
        return contact;
    }

    public static Contact createContact(String firstName, String lastName, String email) {
        Contact contact = new Contact(FirstName = firstName, LastName = lastName, Email = email);
        contact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName()
                .get('Broker').getRecordTypeId();
        insert contact;
        return contact;
    }

    public static Deal__c createDeal(Contact customer,Contact seller,Id sellingProp) {
        Deal__c deal = new Deal__c(Customer__c = customer.Id, Seller__c = seller.Id,
                Selling_Property__c = sellingProp, Status__c = 'Open',
                RecordTypeId = DEFAULT_DEAL_TYPE);
        insert deal;
        return deal;
    }

    public static User createCEOUser(String name, String language) {
        User user = new User();
            user = new User(LastName = 'tetsik', ALias = 'kistet',
                            Email = 'testo@mail.ru', Username = name + '@username.com',
                            UserRoleId = CEO_ROLE, ProfileId = IDENTITY_USER_PROFILE_ID,
                            EmailEncodingKey = 'UTF-8',
                            TimeZoneSidKey = 'Europe/Minsk', LocaleSidKey = language,
                            LanguageLocaleKey = language);
        insert user;
        return user;
    }

    public static User createClientUser(Contact contact) {
        User user = new User(
                ProfileId = STANDARD_PLATFORM_USER_PROFILE_ID, ContactId = contact.Id, LastName = contact.LastName,
                LanguageLocaleKey = 'en_US', Username = contact.LastName + '@username.com',
                Email = contact.LastName + '@test.com', Alias = 'abc',
                TimeZoneSidKey = 'Europe/Minsk', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8');
        insert user;
        return user;
    }

}