public class DealTriggerHandler extends TriggerHandler{
    private final Id SALE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName()
            .get('Sale').getRecordTypeId();

    public override void afterUpdate() {
        List<Deal__c> dealList = [SELECT Id, Status__c, Selling_Property__c FROM Deal__c
                                  WHERE Id IN :Trigger.new AND RecordTypeId = :SALE
                                  AND Status__c = 'Closed Won'];

        List<Id> pIds = new List<Id>();
        for(Deal__c d : dealList) {
            pIds.add(d.Selling_Property__c);
        }

        List<Property__c> propertyList = [SELECT Id,
                                         (SELECT Id, Status__c FROM Deals1__r
                                          WHERE (Status__c = 'Open' OR Status__c = 'Awaiting Approval')
                                          AND RecordTypeId = :SALE)
                                          FROM Property__c WHERE Id IN :pIds];

        List<Deal__c> dealsForUpdate = new List<Deal__c>();

        for(Property__c prop : propertyList) {
            for(Deal__c d : prop.Deals1__r) {
                d.Status__c = 'Closed Lost';
                dealsForUpdate.add(d);
            }
        }

        if (dealsForUpdate.size() > 0) {
            update dealsForUpdate;
        }
    }
}