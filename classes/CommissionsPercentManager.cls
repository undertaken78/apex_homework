public with sharing class CommissionsPercentManager {

    public static Commissions_Percent__c createCommissionsPercent(Decimal brokersPercent, Id contactId, Id dealId, Boolean serialize) {
        Commissions_Percent__c commissionsPercent = new Commissions_Percent__c();
        commissionsPercent.Brokers_Percent__c = brokersPercent;
        commissionsPercent.Commission_Contact__c = contactId;
        commissionsPercent.Commission_Deal__c = dealId;

        if(serialize) insert commissionsPercent;

        return commissionsPercent;
    }

    public static List<Commissions_Percent__c> getCommissionPercentsByIds(List<Id> ids, String fields) {
        return Database.query('SELECT ' + fields + ' FROM Commissions_Percent__c WHERE Id IN :ids');
    }

    public static List<Commissions_Percent__c> updateCommissionsPercents(List<Id> ids, Decimal percent, Boolean serialize) {
        List<Commissions_Percent__c> commissionsPercents =
                                    [SELECT Brokers_Percent__c FROM Commissions_Percent__c WHERE Id IN :ids];

        for (Commissions_Percent__c commissionsPercent : commissionsPercents) {
            commissionsPercent.Brokers_Percent__c = percent;
        }

        if(serialize) update commissionsPercents;

        return commissionsPercents;
    }

    public static void deleteCommissionPercentsByBrokersPercent(List<Decimal> percents) {
        delete [SELECT Id FROM Commissions_Percent__c WHERE Brokers_Percent__c IN :percents];
    }
}