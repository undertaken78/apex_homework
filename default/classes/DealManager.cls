public class DealManager {

    public static final String DEFAULT_STATUS = 'Awaiting Approval';

    public class DealWrapper {
        public Id customer {get; set;}
        public Id seller {get; set;}
        public Id sellingProperty {get; set;}
        public String status {get; set;}
    }

    public static Deal__c createDeal(DealWrapper wrapper, Boolean serialize) {
        Deal__c deal = new Deal__c();
        deal.Customer__c = wrapper.customer;
        deal.Seller__c = wrapper.seller;
        deal.Selling_Property__c = wrapper.sellingProperty;
        deal.Status__c = String.isNotBlank(wrapper.status) ? wrapper.status : DEFAULT_STATUS;

        if (serialize) insert deal;

        return deal;
    }

    public static List<Deal__c> getDealsByIds(List<Id> ids, String fields) {
        return Database.query('SELECT ' + fields + ' FROM Deal__c WHERE Id IN :ids');
    }

    public static List<Deal__c> getDealsBySeller(Id contactId, String fields) {
        return Database.query('SELECT ' + fields + ' FROM Deal__c WHERE Seller__c =: contactId');
    }

    public static List<Deal__c> getDealsByStatuses(List<String> statuses, String fields) {
        return Database.query('SELECT ' + fields + ' FROM Deal__c WHERE Status__c IN :statuses');
    }

    public static List<Deal__c> updateDealsByIds(List<Id> ids, DealWrapper wrapper, Boolean serialize) {
        List<Deal__c> dealsList = [SELECT Customer__c, Selling_Property__c, Status__c FROM Deal__c WHERE Id IN :ids];
        List<Deal__c> updatedDealsList = new List<Deal__c>();

        for(Deal__c deal : dealsList) {
            deal.Customer__c = wrapper.customer;
            deal.Seller__c = wrapper.seller;
            deal.Selling_Property__c = wrapper.sellingProperty;
            deal.Status__c = String.isNotBlank(wrapper.status) ? wrapper.status : DEFAULT_STATUS;
            updatedDealsList.add(deal);
        }

        if (serialize) update updatedDealsList;

        return updatedDealsList;
    }

    public static void deleteDealsByStatus(List<String> statuses) {
        delete [SElECT Id FROM Deal__c WHERE Status__c IN :statuses];
    }
}