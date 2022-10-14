public class SerializationWrapper {
    public class Response {
        public Date startDate {get; set;}
        public Date endDate {get; set;}
        public String totalRevenue {get; set;}
        public List<DealManager.DealWrapper> deals {get; set;}

        public Response (Date startDate, Date endDate, List<Deal__c> deals) {
            this.startDate = startDate;
            this.endDate = endDate;
            this.deals = new List<DealManager.DealWrapper>();
            Decimal revenue = 0;
            for (Deal__c deal : deals) {
                this.deals.add(new DealManager.DealWrapper(deal));
                if (deal.RecordType.DeveloperName == 'Lease') {
                    revenue += deal.Deal_Amount__c;
                }
            }
            this.totalRevenue = String.valueOf(revenue);
        }
    }

    public class ClientWrapper {
        public String sfId {get; set;}
        public String firstName {get; set;}
        public String lastName {get; set;}
        public String email {get; set;}

        public ClientWrapper(){}

        public ClientWrapper(Contact contact) {
            this.sfId = contact.Id;
            this.firstName = contact.FirstName;
            this.lastName = contact.LastName;
            this.email = contact.Email;
        }
    }

    public class PropertyOwnerWrapper {
        public String propertyId;
        public ClientWrapper ownerClient;
    }
}