public class NTV_OrderHistoryDriverUtil {
    
    @TestVisible private static final String ORDER_HISTORY = 'Order_History';
    public static final String ORDER_HISTORY_DURATION = 'CRM_API_Order_History_Duration';
    private static final String ORDER_METADATA_TYPE = 'CRM_API_Order__mdt';
    private static final String ORDER_ORDER_BY_ID = 'OrderById';

    private static final String ATTRIBUTE_HISTORY = 'history';
    private static final String ATTRIBUTE_STATUS = 'status';
    private static final String ATTRIBUTE_REASON = 'reason';
    @TestVisible private static final String ATTRIBUTE_ORDER_ID =  'orderId';
    private static final String ATTRIBUTE_OFFERS = 'offers';

  /*  public static final Map<String, sObject> relativePathsInfo = NTV_Utils.getCustomMetadataTypes(ORDER_METADATA_TYPE);
    private String currentTableName;
   

    public static String relativeEndpointPath(String profileUUID) {
        final Integer duration = Integer.valueOf(NTV_OrgConfigUtil.getOrgConfig(ORDER_HISTORY_DURATION));
        final String startDate = String.valueOf(getDateInEpoch(0, -duration));
        final String endDate = String.valueOf(getDateInEpoch(1, 0));

        return buildRelativePath(profileUUID, startDate, endDate);
    }

    private static String buildRelativePath(String profileUUID, String startDate, String endDate) {
        final String relativePath = ((CRM_API_Order__mdt)relativePathsInfo.get(ORDER_HISTORY)).Relative_Path__c;
        return String.format(relativePath, new List<String>{profileUUID, startDate, endDate});
    }

    public static DateTime getDateTimeInFuture(Integer days, Integer months) {
        return DateTime.now().addDays(days).dateGmt().addMonths(months);
    }

    public static Long getDateTimeInEpoch(DateTime dateToBeTransform) {
        return dateToBeTransform.getTime()/1000;
    }

    @testVisible public static Long getDateInEpoch(Integer days, Integer months) {
        DateTime result = getDateTimeInFuture(days, months);
        return getDateTimeInEpoch(result);
    }

    public static Map<String, Object> performHttpCallout(String profileUUID, String startDate, String endDate,
            final String propositionVal, final String providerVal) {
        String territory = NTV_Utils.getTerritory(profileUUID);
        String profileId = NTV_Utils.getHouseHoldId(profileUUID);
        String relativePath = buildRelativePath(profileId, startDate, endDate); 
        NTV_CRMRestClient crmApiClient = new NTV_CRMRestClient();
        crmApiClient.addHeader('Content-Type', 'application/vnd.crmorderhistory.v1+json');
        crmApiClient.addHeader('Accept', 'application/vnd.crmorderhistory.v1+json');       
        return httpCallout(territory, relativePath, crmApiClient, propositionVal, providerVal);
    }

    public static Map<String, Object> performHttpCallout(String profileUUID, final String propositionVal,
            final String providerVal) {
        String territory = NTV_Utils.getTerritory(profileUUID);
        String profileId = NTV_Utils.getHouseHoldId(profileUUID);
        String relativePath = relativeEndpointPath(profileId); 
        NTV_CRMRestClient crmApiClient = new NTV_CRMRestClient();
        crmApiClient.addHeader('Content-Type', 'application/vnd.crmorderhistory.v1+json');
        crmApiClient.addHeader('Accept', 'application/vnd.crmorderhistory.v1+json');       
        return httpCallout(territory, relativePath, crmApiClient, propositionVal, providerVal);
    }

    public static Map<String, Object> performHttpCallout(String territory, String orderById,
            final String propositionVal, final String providerVal) {
        String relativePath = orderByIdrelativeEndpointPath(orderById);  
        NTV_CRMRestClient crmApiClient = new NTV_CRMRestClient();
        crmApiClient.addHeader('Content-Type', 'application/vnd.crmgetorder.v1+json');
        crmApiClient.addHeader('Accept', 'application/vnd.crmgetorder.v1+json');      
        return httpCallout(territory, relativePath, crmApiClient, propositionVal, providerVal);
    }

    public static Map<String, Object> httpCallout(String territory, String relativePath,NTV_CRMRestClient crmApiClient,
            final String propositionVal, final String providerVal) {
        NTV_JsonResponse response = (NTV_JsonResponse)crmApiClient.performGet(territory, relativePath,
            propositionVal, providerVal);
        if (!response.isSuccessful()) {
            throw new NTV_BaseException(Label.NTV_Get_Order_History);
        }
        return (Map<String,Object>)response.deserialize();
    }
   
    public static List<Map<String, Object>> getProduct(Map<String, Object> orderHistoryMap, String externalId, String profileUUID,String orderId){
            List<Map<String, Object>> productRows = new List<Map<String, Object>>(); 
            Map<String, Object> objProductMap;
            String productId;
            
            if(orderHistoryMap.containskey('products')){
                if(externalId.split(NTV_CRMDataSourceDriver.DELIMITER).size()==3){
                             productId = externalId.split(NTV_CRMDataSourceDriver.DELIMITER).get(2);
                }
                for(Object product : (List<Object>)orderHistoryMap.get('products')){
                objProductMap = new Map<String, Object>();
                Map<String, Object> prodMapMap = (Map<String, Object>) product;
                    objProductMap.put('staticId',prodMapMap.get('staticId'));
                    objProductMap.put('ProductId',prodMapMap.get('id'));
                    objProductMap.put('quantity',prodMapMap.get('quantity'));
                    objProductMap.put('orderId',profileUUID + NTV_CRMDataSourceDriver.DELIMITER + orderId);
                    objProductMap.put('ExternalId' ,profileUUID + NTV_CRMDataSourceDriver.DELIMITER+orderId+NTV_CRMDataSourceDriver.DELIMITER +prodMapMap.get('id'));
                    if(!String.isBlank(productId) && productId==prodMapMap.get('id')){
                        productRows.add(objProductMap);
                        return productRows;
                    }else if(String.isBlank(productId)){
                         productRows.add(objProductMap);
                    }                    
                }
            }
        return productRows;
    }
   

   public static List<Map<String, Object>> getPayment(Map<String, Object> orderHistoryMap, String profileUUID, String orderId){
            List<Map<String, Object>> paymentRows = new List<Map<String, Object>>(); 
            Map<String, Object> objPaymentMap = new Map<String, Object>();

            if(orderHistoryMap.containskey('payment')){
                objPaymentMap.put('orderId', profileUUID + NTV_CRMDataSourceDriver.DELIMITER + orderId);
                objPaymentMap.put('ExternalId', profileUUID + NTV_CRMDataSourceDriver.DELIMITER + orderId);

                Map<String, Object> paymentMap = (Map<String, Object>)orderHistoryMap.get('payment');
                if(paymentMap.containsKey('account')) {
                    Map<String, Object> accounts = (Map<String, Object>) paymentMap.get('account');
                    objPaymentMap.put('token', accounts.get('token'));
                    objPaymentMap.put('provider', accounts.get('provider'));
                    objPaymentMap.put('method', accounts.get('method'));
                }
                if(paymentMap.containsKey('charge')) {
                    Map<String, Object> charges = (Map<String, Object>) paymentMap.get('charge');
                    objPaymentMap.put('amount', charges.get('amount'));
                    objPaymentMap.put('currency', charges.get('currency'));
                    objPaymentMap.put('paymentTransactionId', charges.get('paymentTransactionId'));
                }
                paymentRows.add(objPaymentMap);
            }
        return paymentRows;
    }

    public static List<Map<String, Object>> getSubscription(Map<String, Object> orderHistoryMap,String externalId,String profileUUID,String orderId){
            List<Map<String, Object>> productRows = new List<Map<String, Object>>(); 
            Map<String, Object> objProductMap;
            String productId;
            
           if(orderHistoryMap.containskey('subscriptions')){
                if(externalId.split(NTV_CRMDataSourceDriver.DELIMITER).size()==3){
                             productId = externalId.split(NTV_CRMDataSourceDriver.DELIMITER).get(2);
                }

                Map<String,Object> subscriptionsMap = (Map<String, Object>) orderHistoryMap.get('subscriptions');
                for(String actionType: subscriptionsMap.keySet()){
                    for(Object product : (List<Object>) subscriptionsMap.get(actionType)){
                        objProductMap = new Map<String, Object>();
                        Map<String, Object> prodMapMap = (Map<String, Object>) product;
                        String productState = actionType.equalsIgnoreCase('added') ? 'New' : 'Changed';
                        objProductMap.put('productState',productState);
                        objProductMap.put('product',prodMapMap.get('staticId'));
                        objProductMap.put('Subscription_Id',prodMapMap.get('id'));
                        objProductMap.put('state',prodMapMap.get('state'));
                        objProductMap.put('cancellationEffectiveDate',prodMapMap.get('cancellationEffectiveDate'));
                        objProductMap.put('orderId',profileUUID + NTV_CRMDataSourceDriver.DELIMITER + orderId);
                        objProductMap.put('ExternalId' ,profileUUID +NTV_CRMDataSourceDriver.DELIMITER +prodMapMap.get('id'));
                        if(!String.isBlank(productId) && productId==prodMapMap.get('id')){
                            productRows.add(objProductMap);
                            return productRows;
                        }else if(String.isBlank(productId)){
                             productRows.add(objProductMap);
                        }                    
                    }
                }
            }
        return productRows;
    }
   
    public static List<Map<String, Object>> getEntitlement(Map<String, Object> orderHistoryMap,String externalId,String profileUUID,String orderId){
            List<Map<String, Object>> productRows = new List<Map<String, Object>>(); 
            Map<String, Object> objProductMap;
            String entitlementId;
            
           if(orderHistoryMap.containskey('entitlements')){
                 if(externalId.split(NTV_CRMDataSourceDriver.DELIMITER).size()==3){
                        entitlementId= externalId.split(NTV_CRMDataSourceDriver.DELIMITER).get(2);
                  }
                for(Object product : (List<Object>)orderHistoryMap.get('entitlements')){
                objProductMap = new Map<String, Object>();
                Map<String, Object> prodMapMap = (Map<String, Object>) product;
                    objProductMap.put('entitlementId',prodMapMap.get('id'));
                    objProductMap.put('productStaticId',prodMapMap.get('productStaticId'));
                    objProductMap.put('billingType',prodMapMap.get('billingType'));
                    objProductMap.put('orderId',profileUUID + NTV_CRMDataSourceDriver.DELIMITER + orderId);
                    //objProductMap.put('ExternalId' ,profileUUID + NTV_CRMDataSourceDriver.DELIMITER+orderId+NTV_CRMDataSourceDriver.DELIMITER +prodMapMap.get('id'));
                    objProductMap.put('ExternalId' ,profileUUID +NTV_CRMDataSourceDriver.DELIMITER +prodMapMap.get('id'));                    
                    if(!String.isBlank(entitlementId) && entitlementId==prodMapMap.get('id')){
                        productRows.add(objProductMap);
                        return productRows;
                    }else if(String.isBlank(entitlementId)){
                         productRows.add(objProductMap);
                    }                    
                }
            }
        return productRows;
    }

     public static List<Map<String, Object>> getResultFor(String tableName, Map<String, Object> orderHistoryMap,String externalId,String profileUUID,String orderId) {
        if(tableName.equalsIgnoreCase(NTV_EntitlementsDriver.ENTITLEMENTS)) {
            return getEntitlement(orderHistoryMap,externalId,externalId.split(NTV_CRMDataSourceDriver.DELIMITER).get(0),orderId);
        } else if(tableName.equalsIgnoreCase(NTV_PaymentDriver.PAYMENT)) {
            return getPayment(orderHistoryMap,externalId.split(NTV_CRMDataSourceDriver.DELIMITER).get(0),orderId);
        } else  if(tableName.equalsIgnoreCase(NTV_ProductDriver.PRODUCTS)) {
            return getProduct(orderHistoryMap,externalId,externalId.split(NTV_CRMDataSourceDriver.DELIMITER).get(0),orderId);
        } else  if(tableName.equalsIgnoreCase(NTV_SubscriptionOfferDriver.OFFERS)) {
            return getOffers(orderHistoryMap,externalId,externalId.split(NTV_CRMDataSourceDriver.DELIMITER).get(0),orderId);
        } else  if(tableName.equalsIgnoreCase(NTV_SubscriptionsDriver.SUBSCRIPTIONS)) {
            return getSubscription(orderHistoryMap,externalId,externalId.split(NTV_CRMDataSourceDriver.DELIMITER).get(0),orderId);
        }
        return null;
    }

    public static List<Map<String,Object>> getOrderHistoryForDriver(String externalId, String tableName) {
        List<Map<String, Object>> resultRows = new List<Map<String, Object>>();
        String orderId = externalId.split(NTV_CRMDataSourceDriver.DELIMITER).get(1);
        
        // Get proposition and provider of the customer
        final String profileUUID = externalId.split(NTV_CRMDataSourceDriver.DELIMITER).get(0);
        Map<String, String> propositionProviderMap = NTV_Utils.getPropositionAndProviderForProfileUUID(profileUUID);
        String proposition, provider;
        if(propositionProviderMap != null){
            proposition = propositionProviderMap.get(NTV_CRMApiRequestUtil.PROPOSITION_HEADER_KEY);
            provider = propositionProviderMap.get(NTV_CRMApiRequestUtil.PROVIDER_HEADER_KEY);
        }

        Map<String, Object> response = NTV_OrderHistoryDriverUtil.performHttpCallout(
            externalId.split(NTV_CRMDataSourceDriver.DELIMITER).get(0), proposition, provider);
        
        List<Object> orderHistory = (List<Object>)response.get('history');
        for(Object order : orderHistory){
            Map<String, Object> orderHistoryMap = (Map<String, Object>) order;
            String recordId = (String)orderHistoryMap.get(ATTRIBUTE_ORDER_ID);
            if(String.isNotBlank(orderId) && orderId == recordId){
                orderHistoryMap.put('ExternalId', externalId.split(NTV_CRMDataSourceDriver.DELIMITER).get(0) + NTV_CRMDataSourceDriver.DELIMITER + recordId );
                resultRows.addAll(getResultFor(tableName, orderHistoryMap, externalId, externalId.split(NTV_CRMDataSourceDriver.DELIMITER).get(0),orderId));
                return resultRows;
            }
        } 
        return resultRows;
    }

    public static List<Map<String, Object>> getOffers(Map<String, Object> orderHistoryMap, String externalId,
                                                      String profileUUID,String orderId){
            List<Map<String, Object>> productRows = new List<Map<String, Object>>(); 
            Map<String, Object> objProductMap;
            String offerId;
            
           if(orderHistoryMap.containskey(ATTRIBUTE_OFFERS)){
                 if(externalId.split(NTV_CRMDataSourceDriver.DELIMITER).size()==3){
                        offerId= externalId.split(NTV_CRMDataSourceDriver.DELIMITER).get(2);
                  }
                for(Object product : (List<Object>)orderHistoryMap.get(ATTRIBUTE_OFFERS)){
                objProductMap = new Map<String, Object>();
                Map<String, Object> prodMapMap = (Map<String, Object>) product;
                    objProductMap.put('offerId',prodMapMap.get('id'));
                    objProductMap.put('staticId',prodMapMap.get('staticId'));
                    objProductMap.put('voucherCode',prodMapMap.get('voucherCode'));
                    objProductMap.put('applied_to_business_id',prodMapMap.get('applied_to_business_id'));
                    objProductMap.put('orderId',profileUUID + NTV_CRMDataSourceDriver.DELIMITER + orderId);
                    objProductMap.put('ExternalId' ,profileUUID + NTV_CRMDataSourceDriver.DELIMITER+orderId+NTV_CRMDataSourceDriver.DELIMITER +prodMapMap.get('id'));
                    if(String.isNotBlank(offerId) && offerId.equals(prodMapMap.get('id'))){
                        productRows.add(objProductMap);
                        return productRows;
                    }else if(String.isBlank(offerId)){
                         productRows.add(objProductMap);
                    }                    
                }
            }
        return productRows;
    }
    public  static String orderByIdrelativeEndpointPath(String orderId) {
        final String relativePath = ((CRM_API_Order__mdt)relativePathsInfo.get(ORDER_ORDER_BY_ID)).Relative_Path__c;
        return String.format(relativePath, new List<String>{orderId});
    }*/
}