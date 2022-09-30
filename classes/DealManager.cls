public with sharing class DealManager {

    public static final String DEFAULT_STATUS = 'Awaiting Approval';

    public class DealWrapper {
        public Id customer {get; set;}
        public Id seller {get; set;}
        public Id sellingProperty {get; set;}
        public String status {get; set;}
        public Date rentStartDate {get; set;}
        public Date rentEndDate {get; set;}
        public Id recordTypeId {get; set;}
    }

    public static Deal__c createDeal(DealWrapper wrapper, Boolean serialize) {
        Deal__c deal = new Deal__c();
        deal.Customer__c = wrapper.customer;
        deal.Seller__c = wrapper.seller;
        deal.Selling_Property__c = wrapper.sellingProperty;
        deal.Status__c = String.isNotBlank(wrapper.status) ? wrapper.status : DEFAULT_STATUS;
        if (deal.RecordType.Name == 'Lease') {
            deal.Date_Start_Rent__c = wrapper.rentStartDate;
            deal.Date_End_Rent__c = wrapper.rentEndDate;
        }

        if (serialize) insert deal;

        return deal;
    }

    public static List<Deal__c> getDealsByIds(List<Id> ids, String fields) {
        return Database.query('SELECT ' + fields + ' FROM Deal__c WHERE Id IN :ids');
    }

    public static List<Deal__c> getDealsByStatuses(List<String> statuses, String fields) {
        return Database.query('SELECT ' + fields + ' FROM Deal__c WHERE Status__c IN :statuses');
    }

    public static Deal__c updateDealsByIds(Id ids, DealWrapper wrapper, Boolean serialize) {
        Deal__c mainDeal =
            [SELECT Customer__c, Seller__c, Selling_Property__c, Status__c FROM Deal__c WHERE Id = :ids LIMIT 1];

            mainDeal.Customer__c = wrapper.customer;
            mainDeal.Seller__c = wrapper.seller;
            mainDeal.Selling_Property__c = wrapper.sellingProperty;
            mainDeal.Status__c = String.isNotBlank(wrapper.status) ? wrapper.status : DEFAULT_STATUS;
            mainDeal.Date_Start_Rent__c = wrapper.rentStartDate;
            mainDeal.Date_End_Rent__c = wrapper.rentEndDate;
        if (serialize) update mainDeal;

        return mainDeal;
    }

    public static void deleteDealsByStatus(List<String> statuses) {
        delete [SELECT Id FROM Deal__c WHERE Status__c IN :statuses];
    }
}