public with sharing class PropertyManager {

    public class PropertyWrapper {
        public Id id {get; set;}
        public String latitude {get; set;}
        public String longitude {get; set;}
        public String country {get; set;}
        public String city {get; set;}
        public String address{get; set;}
        public Decimal rentPrice {get; set;}
        public Decimal soldPrice {get; set;}
        public Id propertyOwner {get; set;}
        public Id owner {get; set;}

        public PropertyWrapper(){}

        public PropertyWrapper(Property__c property) {
            this.id = property.Id;
            this.latitude = property.Latitude__c;
            this.longitude = property.Longitude__c;
            this.rentPrice = property.Rent_Price__c;
            this.soldPrice = property.Sold_Price__c;
            this.propertyOwner = property.Property_Owner__c;
            //this.owner = property.Owner__c;
            this.city = property.City__c;
            this.country = property.Country__c;
            this.address = property.Address__c;
        }
    }

    public class AddressWrapper {
        public String country {get; set;}
        public String city {get; set;}
        public String address{get; set;}

        public AddressWrapper(){}

        public AddressWrapper(String country, String city, String address) {
            this.country = country;
            this.city = city;
            this.address = address;
        }
    }

    public static Property__c createProperty(PropertyWrapper wrapper, LocationWrapper__c locationWrapper, Boolean serialize) {
        Property__c property = new Property__c();
        property.Address__c = locationWrapper.Address__c;
        property.City__c = locationWrapper.City__c;
        property.Country__c = locationWrapper.Country__c;
        property.Location__c = locationWrapper.Id;
        property.Rent_Price__c = wrapper.rentPrice;
        property.Sold_Price__c = wrapper.soldPrice;
        property.Property_Owner__c = wrapper.propertyOwner;
        property.Latitude__c = (String.isBlank(wrapper.latitude)) ? property.Latitude__c : '' ;
        property.Longitude__c = (String.isBlank(wrapper.longitude)) ? property.Longitude__c : '' ;

        if(serialize) insert property;

        return property;
    }

    public static Integer getPropertyCount() {
        return [SELECT count() FROM Property__c];
    }

    public static List<Property__c> getPropertiesForPage(String fields, Integer countOfItems, Integer offset) {
        return Database.query('SELECT ' + fields + ' FROM Property__c ORDER BY Sold_Price__c LIMIT ' + countOfItems + 'OFFSET ' + offset);
    }

    public static List<Property__c> getPropertiesByIds(List<Id> ids, String fields) {
        return Database.query('SELECT ' + fields + ' FROM Property__c WHERE Id IN :ids');
    }

    public static List<Property__c> getPropertiesBySoldPrices(List<Decimal> soldPrices, String fields) {
        return Database.query('SELECT ' + fields + ' FROM Property__c WHERE Sold_Price__c IN :soldPrices');
    }

    public static List<Property__c> getPropertiesByOwners(List<Id> owners, String fields) {
        return Database.query('SELECT ' + fields + ' FROM Property__c WHERE Property_Owner__c IN :owners');
    }

    public static List<Property__c> updatePropertiesByIds(List<Id> ids, String address, Boolean serialize) {
        List<Property__c> propertiesList =
            [SELECT Address__c, Rent_Price__c, Sold_Price__c, Property_Owner__c FROM Property__c WHERE Id IN :ids];

        for (Property__c property : propertiesList) {
            property.Address__c = address;
        }

        if (serialize) update propertiesList;

        return propertiesList;
    }

    public static void deletePropertiesByAddress(List<String> addresses) {
        delete [SELECT Id FROM Property__c WHERE Address__c IN :addresses];
    }
}