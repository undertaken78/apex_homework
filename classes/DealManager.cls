public with sharing class DealManager {

    public static final String DEFAULT_STATUS = 'Awaiting Approval';

    public static final Id SALE_RECORDTYPE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName()
            .get('Sale').getRecordTypeId();

    public static final Id LEASE_RECORDTYPE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName()
            .get('Lease').getRecordTypeId();

    public class DealWrapper {
        public Id customer { get; set; }
        public Id seller { get; set; }
        public Id sellingProperty { get; set; }
        public String status { get; set; }
        public Date rentStartDate { get; set; }
        public Date rentEndDate { get; set; }
        public Id recordTypeId { get; set; }

        public DealWrapper(){}

        public DealWrapper(Deal__c deal) {
            this.customer = deal.Customer__c;
            this.seller = deal.Seller__c;
            this.sellingProperty = deal.Selling_Property__c;
            this.status = deal.Status__c;
            this.rentStartDate = deal.Date_Start_Rent__c;
            this.rentEndDate = deal.Date_End_Rent__c;
            this.recordTypeId = deal.RecordTypeId;
        }
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

    public static List<Deal__c> getDealsByDateAndRecordType(String propertyId, String fields, String recordTypeName,
            Date startLease, Date endLease) {

        Id recordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName()
                .get(recordTypeName).getRecordTypeId();

        return Database.query('SELECT ' + fields +
                              ' FROM Deal__c WHERE RecordTypeId =: recordTypeId ' +
                              'AND Date_Start_Rent__c =:startLease AND Date_End_Rent__c =:endLease' +
                              ' AND Selling_Property__c =: propertyId');
    }

    public static Deal__c updateDealById(Id ids, DealWrapper wrapper, Boolean serialize) {
        Deal__c mainDeal = [SELECT Customer__c, Seller__c, Selling_Property__c, Status__c FROM Deal__c WHERE Id = :ids LIMIT 1];

        mainDeal.Customer__c = wrapper.customer;
        mainDeal.Seller__c = wrapper.seller;
        mainDeal.Selling_Property__c = wrapper.sellingProperty;
        mainDeal.Status__c = wrapper.status;
        mainDeal.Date_Start_Rent__c = wrapper.rentStartDate;
        mainDeal.Date_End_Rent__c = wrapper.rentEndDate;
        if (serialize) update mainDeal;

        return mainDeal;
    }

    public static void deleteDealsByStatus(List<String> statuses) {
        delete [SELECT Id FROM Deal__c WHERE Status__c IN :statuses];
    }

    public static List<Deal__c> getNotClosedSaleDealsByProperties(List<Id> propertyIds) {
        return [
                SELECT Id
                FROM Deal__c
                WHERE Selling_Property__c IN :propertyIds
                AND Status__c NOT IN ('Closed Won', 'Closed', 'Closed Lost')
                AND RecordTypeId = :SALE_RECORDTYPE
        ];

    }
}