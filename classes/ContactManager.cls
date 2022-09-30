public with sharing class ContactManager {

    public static final Id DEFAULT_RECORD_TYPE = Schema.SObjectType.Contact.getRecordTypeInfosByName()
            .get('Broker').getRecordTypeId();

    public class ContactWrapper {
        public String firstName {get; set;}
        public String lastName {get; set;}
        public Id recordTypeId {get; set;}
        public String phone {get; set;}
        public Date birthdate {get; set;}
        public String email {get; set;}

    }

    public static Contact createContact(ContactWrapper wrapper, Boolean serialize) {
        Contact contact = new Contact();
        contact.FirstName = wrapper.firstName;
        contact.LastName = wrapper.lastName;
        contact.RecordTypeId = wrapper.recordTypeId;
        contact.Phone = wrapper.phone;
        contact.Birthdate = wrapper.birthdate;
        contact.Email = wrapper.email;

        if (serialize) insert contact;

        return contact;
    }

    public static List<Contact> getContactsByIds(List<Id> ids, String fields) {
        return Database.query('SELECT ' + fields + ' FROM Contact WHERE Id IN :ids');
    }

    public static List<Contact> getContactsByRecordTypes(List<Id> recordTypes, String fields) {
        return Database.query('SELECT ' + fields + ' FROM Contact WHERE RecordTypeId IN :recordTypes');
    }

    public static Contact updateContactsById(Id id, ContactWrapper wrapper, Boolean serialize) {
        Contact contact = [SELECT FirstName, LastName, RecordTypeId, Phone, Birthdate, Email
                           FROM Contact WHERE Id = :id LIMIT 1];

        contact.FirstName = wrapper.firstName;
        contact.LastName = wrapper.lastName;
        contact.RecordTypeId = String.isNotBlank(wrapper.recordTypeId) ? wrapper.recordTypeId : DEFAULT_RECORD_TYPE;
        contact.Phone = wrapper.phone;
        contact.Birthdate = wrapper.birthdate;
        contact.Email = wrapper.email;

        if (serialize) update contact;

        return contact;
    }

    public static void deleteContactsByRecordTypes(List<String> recordTypes) {
        delete [SELECT Id FROM Contact WHERE RecordType.Name IN :recordTypes];
    }
}