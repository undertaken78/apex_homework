@RestResource(UrlMapping='/propery/v1/*')
global class PropertyRESTService {
    @HttpGet
    global static String getProperty() {
        String response;
        String path = RestContext.request.requestURI.substringAfterLast('v1/');
        if (path.contains('by_owner?owner=')) {
            response = getSerializedProperty(path.substringAfterLast('by_owner?owner='));
        }
        else if (path.contains('report/')) {
            response = getSerializedDeal(path.substringAfterLast('report/').substringBefore('?'),
                    path.substringAfterLast('startDate=').substringBefore('&'),
                    path.substringAfterLast('endDate=').substringBefore('&'),
                    path.substringAfterLast('dealType='));
        }
        else {
            response = 'Invalid path';
        }

        return response;
    }

    @HttpPost
    global static String createProperty() {
        PropertyManager.PropertyWrapper wrapper = (PropertyManager.PropertyWrapper)
                JSON.deserialize(RestContext.request.requestBody.toString(),
                        PropertyManager.PropertyWrapper.class);

        return JSON.serialize(TestDataFactory.createProperty(wrapper, true));
    }

    @HttpPut
    global static String updatePropertyOwner() {
        SerializationWrapper.PropertyOwnerWrapper wrapper = (SerializationWrapper.PropertyOwnerWrapper)
                JSON.deserialize(RestContext.request.requestBody.toString(),
                        SerializationWrapper.PropertyOwnerWrapper.class);

        String fields = 'Id, Property_Owner__c, Address__c, City__c, ' +
                        'Country__c, Rent_Price__c, Sold_Price__c, Longitude__c, Latitude__c';

        Id ownerID;
        Contact owner;

        if(wrapper.propertyId instanceof Id ) {
            ownerID = [SELECT Owner__c FROM Property__c WHERE Id = :wrapper.propertyId].Owner__c;
            owner = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :ownerID LIMIT 1];

            owner.Id = String.isNotEmpty(wrapper.ownerClient.sfId) ? wrapper.ownerClient.sfId : '';
            owner.FirstName = String.isNotEmpty(wrapper.ownerClient.firstName) ? wrapper.ownerClient.firstName : '';
            owner.LastName = String.isNotEmpty(wrapper.ownerClient.lastName) ? wrapper.ownerClient.lastName : '';
            owner.Email = wrapper.ownerClient.email;
        }

        PropertyManager.PropertyWrapper propWrapper = new PropertyManager.PropertyWrapper(PropertyManager.getPropertiesByIds(new List<Id>{wrapper.propertyId},fields).get(0));

        upsert owner;
        return JSON.serialize(propWrapper);
    }

    private static String getSerializedProperty(Id ownerId) {
        String fields = 'Id, Country__c, City__c, Address__c, Latitude__c, Longitude__c, Property_Owner__c,' +
                ' Rent_Price__c, Sold_Price__c, Owner__c';

        List<Property__c> properties = PropertyManager.getPropertiesByOwners(new List<Id>{ownerId}, fields);

        return JSON.serialize(properties, true);
    }

    private static String getSerializedDeal(String propId, String startRentString, String endRentString, String recTypeName) {
        String fields = 'Id, Date_Start_Rent__c, Date_End_Rent__c, RecordType.DeveloperName, ' +
                'Deal_Amount__c, Selling_Property__c, Customer__c, Seller__c, Status__c';

        Date startRent = Date.valueOf(startRentString);
        Date endRent = Date.valueOf(endRentString);
        List<Deal__c> deals = DealManager.getDealsByDateAndRecordType(propId, fields, recTypeName, startRent, endRent);

        SerializationWrapper.Response response = new SerializationWrapper.Response(startRent, endRent, deals);

        return JSON.serialize(response, true);
    }
}