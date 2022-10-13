public class DealTriggerHandler extends TriggerHandler{

    private List<Id> propertyIds = new List<Id>();

    public override void afterUpdate() {
        for(Id dealId : Trigger.newMap.keySet()) {
            Deal__c newDeal = (Deal__c)Trigger.newMap.get(dealId);

            if(newDeal.RecordTypeId != DealManager.SALE_RECORDTYPE || newDeal.Status__c != 'Closed Won') continue;

            if(newDeal.Status__c != Trigger.oldMap.get(dealId).get(Deal__c.Status__c)) {
                propertyIds.add(newDeal.Selling_Property__c);
            }
        }

        if(!propertyIds.isEmpty()) {
            List<Deal__c> dealsToUpdate = DealManager.getNotClosedSaleDealsByProperties(propertyIds);
            for(Deal__c deal : dealsToUpdate) {
                deal.Status__c = 'Closed Lost';
            }
            Database.SaveResult[] results = Database.update(dealsToUpdate, false);
            Utils.checkDatabaseSaveResults(results, dealsToUpdate, 'DealTriggerHandler');
        }
    }
}