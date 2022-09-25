public inherited sharing class PropertyManager {

    public class PropertyWrapper {
        public String address {get; set;}
        public Decimal rentPrice {get; set;}
        public Decimal soldPrice {get; set;}
        public Id propertyOwner {get; set;}
    }

    public static Property__c createProperty(PropertyWrapper wrapper, Boolean serialize) {
        Property__c property = new Property__c();
        property.Address__c = wrapper.address;
        property.Rent_Price__c = wrapper.rentPrice;
        property.Sold_Price__c = wrapper.soldPrice;
        property.Property_Owner__c = wrapper.propertyOwner;

        if(serialize) insert property;

        return property;
    }

    public static List<Property__c> getPropertiesByIds(List<Id> ids, String fields) {
        return Database.query('SELECT ' + fields + ' FROM Property__c WHERE Id IN :ids');
    }

    public static List<Property__c> getPropertiesBySoldPrices(List<Decimal> soldPrices, String fields) {
        return Database.query('SELECT ' + fields + ' FROM Property__c WHERE Sold_Price__c IN :soldPrices');
    }

    public static List<Property__c> updateContactsByIds(List<Id> ids, PropertyWrapper wrapper, Boolean serialize) {
        List<Property__c> propertiesList =
            [SELECT Address__c, Rent_Price__c, Sold_Price__c, Property_Owner__c FROM Property__c WHERE Id IN :ids];
        List<Property__c> updatedPropertiesList = new List<Property__c>();

        for (Property__c property : updatedPropertiesList) {
            property.Address__c = wrapper.address;
            property.Rent_Price__c = wrapper.rentPrice;
            property.Sold_Price__c = wrapper.soldPrice;
            property.Property_Owner__c = wrapper.propertyOwner;
            updatedPropertiesList.add(property);
        }

        if (serialize) update updatedPropertiesList;

        return updatedPropertiesList;
    }

    public static void deletePropertiesByPropertyOwners(List<Id> propertyOwners) {
        delete [SELECT Id FROM Property__c WHERE Property_Owner__c IN :propertyOwners];
    }
}