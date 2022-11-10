public class PropertyOwnerInfoController {
    
	private final Contact contact;
    private final String FIELDS = 'Id, Deal_Amount__c, Sum_After_Commission__c, Selling_Property__c, Selling_Property__r.RecordType.Name, Status__c';
    
    public PropertyOwnerInfoController(ApexPages.StandardController stdController) {
        this.contact = (Contact)stdController.getRecord();
    }
    
    public class DealWrapper {
        public String propertyRecordType {get;set;}
        public Integer dealsWonStatus {get;set;}
        public Decimal dealAmountSum {get;set;}
        public Decimal dealAmountAfterCommission {get;set;}
    }
    
    public List<DealWrapper> getDealList() {
        List<Deal__c> deals = DealManager.getDealsBySeller(contact.Id, FIELDS);
        Map<String, List<Deal__c>> dealsMap = getDealsByRecordType(deals);
        return getDealWrapper(dealsMap);
    }
    
    private Map<String, List<Deal__c>> getDealsByRecordType(List<Deal__c> deals) {
        Map<String, List<Deal__c>> dealsMap = new Map<String, List<Deal__c>>();
        for(Deal__c deal : deals) {
            String propertyRecordType = deal.Selling_Property__r.RecordType.Name;
             if(dealsMap.get(propertyRecordType) == null) {
                 dealsMap.put(propertyRecordType, new List<Deal__c>());
             }
            dealsMap.get(propertyRecordType).add(deal);
        }
        return dealsMap;
    }

    private List<DealWrapper> getDealWrapper(Map<String, List<Deal__c>> dealsMap) {
        List<DealWrapper> wrapper = new List<DealWrapper>();
        for(List<Deal__c> dealsForOutput : dealsMap.values()) {
            wrapper.add(getDealValues(dealsForOutput));
        }
        return wrapper;
    }

    private DealWrapper getDealValues(List<Deal__c> deals) {
        DealWrapper wrapper = new DealWrapper();
        wrapper.propertyRecordType = deals[0].Selling_Property__r.RecordType.Name;
        wrapper.dealAmountSum = 0;
        wrapper.dealAmountAfterCommission = 0;
        wrapper.dealsWonStatus = 0;

        for (Deal__c deal : deals) {
            if (deal.Status__c == 'Closed Won') {
                wrapper.dealsWonStatus += 1;
            }
            wrapper.dealAmountSum += deal.Deal_Amount__c;
            wrapper.dealAmountAfterCommission += deal.Sum_After_Commission__c;
        }

        return wrapper;
    }
}