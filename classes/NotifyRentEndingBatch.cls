public class NotifyRentEndingBatch implements Database.Batchable<SObject>, Schedulable{

    private static final Id LEASE_RECORDTYPE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName()
            .get('Lease').getRecordTypeId();

    private static final String FIELDS = 'Id, CreatedDate'
                                          + ', Customer__r.Id'
                                          + ', Customer__r.FirstName'
                                          + ', Customer__r.LastName'
                                          + ', Customer__r.Email'
                                          + ', Selling_Property__r.Id'
                                          + ', Selling_Property__r.Owner__r.Id'
                                          + ', Selling_Property__r.Owner__r.FirstName__c'
                                          + ', Selling_Property__r.Owner__r.LastName__c'
                                          + ', Selling_Property__r.Owner__r.Email__c'
                                          + ', Selling_Property__r.Country__c'
                                          + ', Selling_Property__r.City__c'
                                          + ', Selling_Property__r.Address__c'
                                          + ', Selling_Property__r.Latitude__c'
                                          + ', Selling_Property__r.Longitude__c'
                                          + ', Date_End_Rent__c'
                                          + ', Date_Start_Rent__c';

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id
                                         FROM Deal__c
                                         WHERE RecordTypeId =: LEASE_RECORDTYPE
                                         AND Date_End_Rent__c = TOMORROW]);
    }

    public void execute(Database.BatchableContext bc, List<Deal__c> deals){
        deals = Database.query('SELECT ' + FIELDS + ' FROM Deal__c WHERE RecordTypeId =: LEASE_RECORDTYPE AND Date_End_Rent__c = TOMORROW');

        List<NotifyClientRentEnding__e> eventList = new List<NotifyClientRentEnding__e>();

        for (Deal__c deal : deals) {
            NotifyClientRentEnding__e event = new NotifyClientRentEnding__e();
            event.DealId__c = deal.Id;
            event.Info__c = JSON.serialize(TestDataFactory.getInfo(deal, true));
            eventList.add(event);
        }
        List<Database.SaveResult> results = EventBus.publish(eventList);
        Utils.checkDatabaseSaveResults(results, eventList, 'NotifyRentEndingBatch');
        EmailSender.sendEmail(deals);
    }

    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new NotifyRentEndingBatch());
        //String cron = '0 0 6 * * ?';
        //System.schedule('NotifyClientRentEnd' + Date.today(), cron, new NotifyRentEndingBatch());
    }

    public void finish(Database.BatchableContext bc){
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
                JobItemsProcessed,
                TotalJobItems, CreatedBy.Email
        FROM AsyncApexJob
        WHERE Id = :bc.getJobId()];
        String logMessage = 'The batch Apex job processed ' + job.TotalJobItems +
                ' batches with '+ job.NumberOfErrors + ' failures.';
        LogManager.createLog('DealEndRentEmailBatch', logMessage, true);
    }
}