public with sharing class NTV_SubscriptionsDriver extends NTV_CRMDataSourceDriver {

    public static final String SUBSCRIPTIONS = 'subscriptions';
    private static final String OFFERS_KEY_ON_RESPONSE = 'offers';
    private static final String PRODUCT_KEY_ON_RESPONSE = 'product';
    private static final String ALLOWED_OPERATIONS_KEY_ON_RESPONSE = 'allowedOperations';
    private static final String CRM_SUBSCRIPTION_PATH = 'CRM API Subscriptions Path';
    @TestVisible private static Map<String, List<Map<String, Object>>> offersBySubscriptionId = new Map<String,List<Map<String, Object>>>();
    private static final String ORDER_LOOKUP_ID = 'orderId';

    private String subscriptionId;
    private Boolean isOrderRequest;

   /* public override DataSource.TableResult query(DataSource.QueryContext context) {
        List<Map<String, Object>> resultRows = new List<Map<String, Object>>();
        String externalId = (String)getValueFromQueryFilter(context.tableSelection.filter, EXTERNAL_ID);
        if(String.isBlank(externalId)){
            String orderExternalId = (String)getValueFromQueryFilter(context.tableSelection.filter, ORDER_LOOKUP_ID);
            if(String.isBlank(orderExternalId)){
                return super.query(context);
            }else{
                 orderExternalId = extractOriginalExternalId(orderExternalId);
                 resultRows = NTV_OrderHistoryDriverUtil.getOrderHistoryForDriver(orderExternalId, SUBSCRIPTIONS);
                 return DataSource.TableResult.get(context, resultRows);
            }
        }

        String profileUUID = externalId.split(DELIMITER).get(0);
        this.subscriptionId = externalId.split(DELIMITER).get(1);

        DataSource.Filter extraFilter = new DataSource.Filter();
        extraFilter.columnName = ACCOUNT_PROFILE_UUID;
        extraFilter.columnValue = profileUUID;
        extraFilter.type = DataSource.FilterType.EQUALS;
        extraFilter.tableName = context.tableSelection.filter.tableName;

        context.tableSelection.filter = extraFilter;
        return super.query(context);
    }

    protected override List<Map<String,Object>> transform(Map<String, Object> response, String profileUUID) {
        List<Map<String, Object>> resultRows = new List<Map<String, Object>>();
        List<Object> subscriptionsObj = (List<Object>)response.get(SUBSCRIPTIONS);

        for(Object subscription : subscriptionsObj){
            Map<String, Object> subscriptionMap = (Map<String, Object>) subscription;
            String recordId = (String)subscriptionMap.get(CRM_API_ID_FIELD_LABEL);
            if(String.isNotBlank(this.subscriptionId) && this.subscriptionId != recordId)
                continue;
            subscriptionMap.put('Subscription_Id', recordId);
            subscriptionMap.put(EXTERNAL_ID, profileUUID + DELIMITER + recordId );
            subscriptionMap.put(PROFILE_UUID, profileUUID);
            subscriptionMap.put(ACCOUNT_PROFILE_UUID, profileUUID);
            subscriptionMap.put(DISPLAY_URL, this.getDisplayUrl(profileUUID, recordId));
            if(subscriptionMap.containsKey(PRODUCT_KEY_ON_RESPONSE)){
                Map<String, Object> productMap = (Map<String, Object>)subscriptionMap.get(PRODUCT_KEY_ON_RESPONSE);
                subscriptionMap.put(PRODUCT_KEY_ON_RESPONSE, (String)productMap.get('staticId'));
                Map<String, Object> productContext = productMap.keySet().contains('context') ? (Map<String, Object>) productMap.get('context') : null;

                if(productContext != null && productContext.keySet().contains(OFFERS_KEY_ON_RESPONSE)){
                    List<Object> offers = (List<Object>)productContext.get(OFFERS_KEY_ON_RESPONSE);
                   
                    List<Map<String, Object>> offerRows = new List<Map<String, Object>>(); 
                    Map<String, Object> offerMap;
                            for(Object offer : offers){
                                    offerMap = (Map<String, Object>) offer;
                                    offerMap.put('offerId' ,offerMap.get('id'));
                                    offerMap.put('id' ,profileUUID + NTV_CRMDataSourceDriver.DELIMITER +recordId+NTV_CRMDataSourceDriver.DELIMITER +offerMap.get('id'));
                                    offerRows.add(offerMap);
                                }
                            if(!offerRows.isEmpty() ){
                                offersBySubscriptionId.put(recordId,offerRows);
                            }
                }
            }
            if(subscriptionMap.containsKey(ALLOWED_OPERATIONS_KEY_ON_RESPONSE)){
                List<Object> allowedOperations = (List<Object>)subscriptionMap.get(ALLOWED_OPERATIONS_KEY_ON_RESPONSE);
                subscriptionMap.put(ALLOWED_OPERATIONS_KEY_ON_RESPONSE, String.valueOf(allowedOperations));
            }
            resultRows.add(subscriptionMap);
            
        }
        return resultRows;
    }

    protected override String relativeEndpointPath(String profileUUID) {
        return String.format(NTV_OrgConfigUtil.getOrgConfig(CRM_SUBSCRIPTION_PATH), new List<String>{profileUUID});
    }

    protected override Map<String, Object> performHttpCallout(String profileUUID, final String propositionVal,
            final String providerVal) {
        String territory = NTV_Utils.getTerritory(profileUUID);
        String profileId = NTV_Utils.getHouseHoldId(profileUUID);
        NTV_CRMRestClient crmApiClient = new NTV_CRMRestClient();
        crmApiClient.addHeader('Accept','application/vnd.crmlatestsubscriptions.v1+json');
        NTV_JsonResponse response = (NTV_JsonResponse)crmApiClient.performGet(territory, relativeEndpointPath(profileId),
            propositionVal, providerVal);

        if (!response.isSuccessful()) {
            throw new NTV_BaseException(Label.NTV_Get_Subscriptions_Error);
        }
        return (Map<String,Object>)response.deserialize();
    }

    public static List<Object> getOffers(final String subscriptionExternalId){
        String profileUUID = subscriptionExternalId.split(NTV_CRMDataSourceDriver.DELIMITER).get(0);
        String subscriptionId = subscriptionExternalId.split(NTV_CRMDataSourceDriver.DELIMITER).get(1);
        if(!Test.isRunningTest()){
            for(Subscriptions__x subscription : [Select Id, ExternalId, Effective_Cancellation_Date__c, Error__c, First_Renewal_Attempt_Date__c, Account__c, Profile_UUID__c,
                                                        Last_Renewal_Date__c, Next_Renewal_Due_Date__c, Start_Date__c, Subscription_State__c, Product__c
                                                    From Subscriptions__x
                                                    Where Account__c =: profileUUID]){
            }
        }
        return offersBySubscriptionId.get(subscriptionId);
    }

    private String getDisplayUrl(final String profileUUID, final String subscriptionId){
        return URL.getSalesforceBaseUrl().toExternalForm() + '/apex/NTV_SubscriptionDetails?profileUUID=' + profileUUID + '&subscriptionId=' + subscriptionId;
    }*/
}