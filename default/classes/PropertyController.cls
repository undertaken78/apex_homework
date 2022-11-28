public with sharing class PropertyController {
    
    @AuraEnabled(cacheable=true)
    public static List<Property__c> getProperties(String fields, Integer numberOfPage, Integer pageSize){
        try {
            Integer offset = (numberOfPage - 1) * pageSize;
            return PropertyManager.getPropertiesForPage(fields, pageSize, offset);
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Integer getPropertiesCount(){
        try {
            return PropertyManager.getPropertyCount();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
