public with sharing class Utils {

    public static final EmailTemplate remindEndRentTemplate = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Rent_End_Email' LIMIT 1];

    public static void checkDatabaseSaveResults(List<Database.SaveResult> saveResults,
            List<SObject> records, String errorSource) {
        String logMsg = '';
        for (Integer i = 0; i < saveResults.size(); i++) {
            if (saveResults[i].isSuccess()) continue;
            logMsg += 'DML operation failed for record: ' + records[i].Id + '\ncause:\n';
            for (Database.Error err: saveResults[i].getErrors()) {
                logMsg += err.getMessage() + '\n';
            }
        }
        if (String.isBlank(logMsg)) LogManager.log(errorSource, logMsg, true);
    }

    public static String serializeJSONInfo(Deal__c deal) {

        Client__c client = new Client__c();
        client.Sfid__c = deal.Customer__r.Id;
        client.FirstName__c = deal.Customer__r.FirstName;
        client.LastName__c = deal.Customer__r.LastName;
        client.Email__c = deal.Customer__r.Email;

        LocationWrapper__c locationWrapper =  new LocationWrapper__c();
        locationWrapper.Country__c = deal.Customer__r.MailingCountry;
        locationWrapper.City__c = deal.Customer__r.MailingCity;
        locationWrapper.Address__c = 'some address';
        locationWrapper.Latitude__c = 'test';
        locationWrapper.Longitude__c = 'test';

        Property__c property = new Property__c();
        property.Sfid__c = deal.Customer__r.Id;
        property.Owner__c = client.Id;
        property.Location__c = locationWrapper.Id;

        Info__c info = new Info__c();
        info.CreateDate__c = Datetime.now();
        info.RentEndDate__c = Date.today().addDays(1);
        info.RentStartDate__c = Date.newInstance(2022, 8, 1);
        info.Client__c = client.Id;
        info.Property__c = property.Id;

        String jsonInfo = JSON.serialize(info);

        return jsonInfo;
    }

    public static void sendEmail(Deal__c deal) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setCcAddresses(new List<String>{deal.Customer__r.Email});
        mail.setWhatId(deal.Id);
        mail.setReplyTo(deal.Customer__r.Email);
        mail.setTargetObjectId(deal.Customer__c);
        mail.setSaveAsActivity(true);
        mail.setTemplateId(remindEndRentTemplate.Id);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }

}