@IsTest
private class ContactManager_Test {
    @TestSetup
    static void setup() {
        Contact contact = new Contact(
                LastName = 'Pavel',
                Phone = '+375 33 8593023',
                RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Broker').getRecordTypeId());
        insert contact;

        Contact contactNew = new Contact(
                LastName = 'Alexey',
                Phone = '+375 33 7643275',
                RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Property Owner').getRecordTypeId());
        insert contactNew;
    }

    @isTest static void testGetContactsByIds() {
        Id contactId = [SELECT Id FROM Contact WHERE LastName = 'Pavel'].Id;
        List<Contact> contacts = ContactManager.getContactsByIds(new List<String>{contactId}, 'Phone');
        System.assertEquals(1, contacts.size());
    }

    @isTest static void testGetContactsByRecordTypes() {
        Id recordTypeId = getRecordTypeId('Broker');
        List<Contact> contacts = ContactManager.getContactsByRecordTypes(new List<String>{recordTypeId}, 'Id');
        System.assertEquals(1, contacts.size());
    }

    @IsTest static void testCreateContactById() {
        ContactManager.ContactWrapper wrapper = getWrapper();

        Contact contact = ContactManager.createContact(wrapper,false);

        Test.startTest();
        Database.SaveResult result = Database.insert(contact);
        Test.stopTest();
        System.assert(result.isSuccess());
    }

    @IsTest static void testUpdateContactByIds() {
        ContactManager.ContactWrapper wrapper = getWrapper();

        Id contactId = [SELECT Id FROM Contact WHERE LastName = 'Pavel' LIMIT 1].Id;
        Contact createdContact = [SELECT LastName FROM Contact WHERE LastName = 'Alexey' LIMIT 1];
        Contact updatedContact = createdContact;
        updatedContact = ContactManager.updateContactsById(contactId, wrapper,false);
        System.assertNotEquals(updatedContact, createdContact);
    }

    @isTest static void testDelete() {
        ContactManager.deleteContactsByRecordTypes(new List<String>{'Broker'});
        System.assertEquals(new List<Contact>(),
                [SELECT RecordTypeId FROM Contact WHERE RecordTypeId =:new List<String>{'Broker'}]);
    }

    private static ContactManager.ContactWrapper getWrapper() {
        ContactManager.ContactWrapper wrapper = new ContactManager.ContactWrapper();
        wrapper.lastName = 'testovich';
        wrapper.firstName = 'test';
        wrapper.email = 'test@testmail.testru';
        wrapper.phone = '+375 33 8373834';
        wrapper.recordTypeId = getRecordTypeId('Broker');
        return wrapper;
    }

    private static Id getRecordTypeId(String recordTypeName) {
        return Schema.SObjectType.Contact.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
    }
}