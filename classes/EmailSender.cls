public class EmailSender {

    public static void sendEmail(List<Deal__c> deals) {
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        for(Deal__c deal : deals) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.toAddresses = new String[] { deal.Customer__r.Email, deal.Selling_Property__r.Owner__r.Email__c };
            System.debug('toAddresses ' + mail.toAddresses );
            if (!mail.toAddresses.isEmpty()) {
                mail.setToAddresses(mail.toAddresses);
                mail.setSubject('Rent ending');
                mail.setPlainTextBody('Your rent is about ending');
                mail.setTemplateId(Utils.getEmailTemplateIdByName('Rent_End_Email'));
                mailList.add(mail);
            }
        }
        Messaging.sendEmail(mailList);
    }
}