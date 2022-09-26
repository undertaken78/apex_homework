public with sharing class CommissionsPercentManager {

    public class CommissionsPercentWrapper {
        public Id dealId {get; set;}
        public Id contactId {get; set;}
        public Id percent {get; set;}
    }

    public static Commissions_Percent__c createCommissionsPercent(CommissionsPercentWrapper wrapper, Boolean serialize) {
        Commissions_Percent__c commissionsPercent = new Commissions_Percent__c();

        commissionsPercent.Brokers_Percent__c = wrapper.percent;
        commissionsPercent.Commission_Deal__c = wrapper.dealId;
        commissionsPercent.Commission_Contact__c = wrapper.contactId;

        if(serialize) insert commissionsPercent;

        return commissionsPercent;
    }

    public static List<Commissions_Percent__c> getCommissionPercentByIds(List<Id> id, String fields) {
        return Database.query('SELECT ' + fields + ' FROM Commissions_Percent__c WHERE Id IN :ids');
    }

    public static List<Commissions_Percent__c> updateCommissionsPercents(List<Id> ids, Decimal percent, Boolean serialize) {
        List<Commissions_Percent__c> commissionsPercents =
                                    [SELECT Brokers_Percent__c FROM Commissions_Percent__c WHERE Id IN :ids];
        List<Commissions_Percent__c> updatedCommissionsPercents = new List<Commissions_Percent__c>();

        for (Commissions_Percent__c commissionsPercent : commissionsPercents) {
            commissionsPercent.Brokers_Percent__c = percent;
            updatedCommissionsPercents.add(commissionsPercent);
        }

        if(serialize) update updatedCommissionsPercents;

        return updatedCommissionsPercents;
    }

    public static void deleteCommissionPercentsByBrokersPercent(List<Decimal> percents) {
        delete [SELECT Id FROM Commissions_Percent__c WHERE Brokers_Percent__c IN :percents];
    }
}