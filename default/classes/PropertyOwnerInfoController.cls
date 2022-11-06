public class PropertyOwnerInfoController {
    
	private final Contact contact;
    
    public PropertyOwnerInfoController(ApexPages.StandardController stdController) {
        this.contact = (Contact)stdController.getRecord();
    }
    
    public class DealWrapper {
        public String propertyRecordType {get;set;}
        public Integer dealsWonStatus {get;set;}
        public Decimal dealAmountSum {get;set;}
        public Decimal dealAmountAfterCommission {get;set;}

        public DealWrapper(){}
        
        public DealWrapper(List<Deal__c> deals) {
            this.propertyRecordType = deals[0].Selling_Property__r.RecordType.Name;
            this.dealAmountSum = 0;
            this.dealAmountAfterCommission = 0;
            this.dealsWonStatus = 0;

            for (Deal__c deal : deals) {
                if (deal.Status__c == 'Closed Won') {
                    this.dealsWonStatus += 1;
                }
                this.dealAmountSum += deal.Deal_Amount__c;
                this.dealAmountAfterCommission += deal.Sum_After_Commission__c;
            }
        }
    }
    
    public List<DealWrapper> getDealList() {
        List<Deal__c> deals = [SELECT Id, Deal_Amount__c, Sum_After_Commission__c, Selling_Property__c, Selling_Property__r.RecordType.Name, Status__c FROM Deal__c WHERE Seller__c =: contact.Id];
        Map<String, List<Deal__c>> dealsMap = new Map<String, List<Deal__c>>();
        
         for(Deal__c deal : deals) {
             if(dealsMap.get(deal.Selling_Property__r.RecordType.Name) == null) {
                 dealsMap.put(deal.Selling_Property__r.RecordType.Name, new List<Deal__c>());
             }
            dealsMap.get(deal.Selling_Property__r.RecordType.Name).add(deal);
        }
        
        List<DealWrapper> wrapper = new List<DealWrapper>();
        for(List<Deal__c> dealsForOutput : dealsMap.values()) {
            wrapper.add(new DealWrapper(dealsForOutput));
        }
        return wrapper;
    }
    
    
}