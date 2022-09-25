@IsTest
public with sharing class TestDataFactory {

    public static final Id DEFAULT_DEAL_TYPE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName()
            .get('Sale').getRecordTypeId();

    public static final Id CEO_ROLE = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1].Id;

    public static final Id IDENTITY_USER_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'Identity User' LIMIT 1].Id;

    public static final Id STANDARD_PLATFORM_USER_PROFILE_ID =
            [SELECT Id FROM Profile WHERE Name = 'Standard Platform User' LIMIT 1].Id;

    public static List<Log__c> createLogs(Integer counter) {
        List<Log__c> logs = new List<Log__c>(counter);
        for (Integer i = 0; i < counter; i++) {
            logs[i] = new Log__c(Type__c = 'DEBUG' + i, Message__c = 'hello '+ i +' world!');
        }
        insert logs;
        return logs;
    }

    public static Log__c createLog() {
        Log__c log = new Log__c(Type__c = 'FINEST', Message__c = 'goodbye world!');
        insert log;
        return log;
    }

    public static Log__c createLog(String type, String message) {
        Log__c log = new Log__c(Type__c = type, Message__c = message);
        insert log;
        return log;
    }

    public static List<Property__c> createProperties(Integer counter) {
        List<Property__c> properties = new List<Property__c>(counter);
        for (Integer i = 0; i < counter; i++) {
            properties[i] = new Property__c(Address__c = 'street Pushkina, house Kolotushkina', Rent_Price__c = 10 / i,
                                            Sold_Price__c = 999 - i, Property_Owner__c = '123454321');
        }
        insert properties;
        return properties;
    }

    public static Property__c createProperty(String address, Decimal rentPrice, Decimal soldPrice, Id propertyOwner) {
        Property__c property = new Property__c(Address__c = address, Rent_Price__c = rentPrice,
                                               Sold_Price__c = soldPrice, Property_Owner__c = propertyOwner);
        insert property;
        return property;
    }

    public static Property__c createProperty() {
        Property__c property = new Property__c(Address__c = 'test', Rent_Price__c = 666,
                Sold_Price__c = 322, Property_Owner__c = 'test');
        insert property;
        return property;
    }

    public static Contact createContact(String firstName, String lastName) {
        Contact contact = new Contact(FirstName = firstName, LastName = lastName);
        insert contact;
        return contact;
    }

    public static Deal__c createDeal() {
        Deal__c deal = new Deal__c(Status__c = 'Closed', RecordTypeId = DEFAULT_DEAL_TYPE);
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
        User user = new User(ProfileId = STANDARD_PLATFORM_USER_PROFILE_ID, ContactId = contact.Id, LastName = contact.LastName,
                LanguageLocaleKey = 'en_US', Username = contact.LastName + '@username.com',
                Email = contact.LastName + '@test.com', Alias = 'abc',
                TimeZoneSidKey = 'Europe/Minsk', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8');
        insert user;
        return user;
    }


}