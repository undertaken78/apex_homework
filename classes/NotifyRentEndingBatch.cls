public class NotifyRentEndingBatch implements Database.Batchable<sObject>{

    public static final Id LEASE_RECORDTYPE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName()
            .get('Lease').getRecordTypeId();

    private static final Date endDateNotify = Datetime.now().addHours(3).addDays(1).date();

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id FROM Deal__c WHERE RecordTypeId =: LEASE_RECORDTYPE
                                                                AND Date_End_Rent__c =: endDateNotify]);
    }

    public void execute(Database.BatchableContext bc, List<Deal__c> deals){
        List<Deal__c> dealList = [SELECT Id, Date_End_Rent__c, Customer__c FROM Deal__c WHERE RecordTypeId =: LEASE_RECORDTYPE
        AND Date_End_Rent__c =: endDateNotify];
        if(!dealList.isEmpty()) {
            for (Deal__c deal : dealList) {
                NotifyClientRentEnding__e event = new NotifyClientRentEnding__e();
                event.DealId__c = deal.Id;
                event.Info__c = Utils.serializeJSONInfo(deal);
                EventBus.publish(event);
                Utils.sendEmail(deal);
            }
        }
    }

    public void finish(Database.BatchableContext bc){}
}