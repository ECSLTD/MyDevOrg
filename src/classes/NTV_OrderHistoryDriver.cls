public class NTV_OrderHistoryDriver extends NTV_CRMDataSourceDriver {
    
    @TestVisible private static final String ORDER_HISTORY = 'Order_History';
    @TestVisible private static final String UNKNOWN_PRODUCT = 'Unknown Product';
    private static final String HARDWARE_TYPE = 'HardwareType';
    
    public static final String ORDER_HISTORY_DURATION = 'CRM_API_Order_History_Duration';
    public static final String ORDER_METADATA_TYPE = 'CRM_API_Order__mdt';
    public static final String UNDERSCORE ='_';
    public static final String ORDER_HOUSEHOLD_ID = 'householdId';
    public static final String TERRITORY ='territory';
    public static final String ERROR_DESCRIPTION = 'description';
    public static final String ERROR_CODE = 'errorCode';
    public static final String ERROR = 'Error';
    public static final String ORDER_SUMMARY = 'orderSummary';

    public static final String ATTRIBUTE_HISTORY = 'history';
    public static final String ATTRIBUTE_STATUS = 'status';
    public static final String ATTRIBUTE_REASON = 'reason';
    public static final String ATTRIBUTE_ORDER_ID =  'orderId';
    public static final String ATTRIBUTE_HARDWARE = 'hardware';
    public static final String ATTRIBUTE_ORDER_TIMESTAMP = 'orderTimestamp';
    public static final String PRODUCTS ='products';
    public static final String SUBSCRIPTIONS = 'Subscriptions';

    private String orderId; 
    private String profileUUID; 
    private String externalId; 
    private String caseId;

   /* private final Map<String, sObject> relativePathsInfo = NTV_Utils.getCustomMetadataTypes(ORDER_METADATA_TYPE);
    private String currentTableName;
    
    public override DataSource.TableResult query(DataSource.QueryContext context) {
        List<Map<String, Object>> resultRows = new List<Map<String, Object>>();
        currentTableName = context.tableSelection.filter.tableName;
        externalId = (String)getValueFromQueryFilter(context.tableSelection.filter, getFilterName(currentTableName));
        orderId = (String)getValueFromQueryFilter(context.tableSelection.filter,ATTRIBUTE_ORDER_ID);
        
        if(String.isBlank(externalId) && String.isNotBlank(orderId)){
            return getOrderByOrderID(context);
        }else if(String.isBlank(externalId)){
            if(ApexPages.currentPage()!= null) {
                caseId = ApexPages.currentPage().getParameters().get('caseId');
            }
            // Account detail page
            return super.query(context);
        }

        String[] splitExternalId = externalId.split(DELIMITER); 
        this.profileUUID = splitExternalId.get(0);
        this.orderId = splitExternalId.get(1);
        this.caseId = splitExternalId.size() > 2 ? splitExternalId.get(2) : '';

        final DataSource.Filter extraFilter = new DataSource.Filter();
        extraFilter.columnName = ACCOUNT_PROFILE_UUID;
        extraFilter.columnValue = profileUUID;
        extraFilter.type = DataSource.FilterType.EQUALS;
        extraFilter.tableName = context.tableSelection.filter.tableName;
        context.tableSelection.filter = extraFilter;

        return super.query(context);
    }
    
    protected override List<Map<String,Object>> transform(Map<String, Object> response, String profileUUID) {
        List<Map<String, Object>> resultRows = new List<Map<String, Object>>();
        Map<String, Object> orderHistoryMap;

        if(String.isBlank(profileUUID)){
            orderHistoryMap =transformOrder(response,profileUUID);
            resultRows.add(orderHistoryMap);
            return resultRows;
        }
        List<Object> orderHistory = (List<Object>)response.get(ATTRIBUTE_HISTORY);
        for(Object order : orderHistory){
            orderHistoryMap = (Map<String, Object>) order;
            String recordId = (String)orderHistoryMap.get(ATTRIBUTE_ORDER_ID);
            if(String.isNotBlank(this.orderId) && this.orderId != recordId)
            continue;
            orderHistoryMap =transformOrder(orderHistoryMap,profileUUID);
            resultRows.add(orderHistoryMap);
        }
        return resultRows;
    }

    private Map<String, Object> transformOrder(Map<String, Object> orderHistoryMap,String profileUUID){
            if(String.isBlank(profileUUID)){
                String orderTerritory = (String)orderHistoryMap.get(TERRITORY);
                profileUUID = (String)orderHistoryMap.get(ORDER_HOUSEHOLD_ID)+UNDERSCORE+orderTerritory;
                if(orderHistoryMap.containskey(ORDER_SUMMARY)){
                    orderHistoryMap = (Map<String, Object>) orderHistoryMap.get(ORDER_SUMMARY);
                }
            }

            String recordId = (String)orderHistoryMap.get(ATTRIBUTE_ORDER_ID);
            String caseForExternalId = String.isBlank(caseId) ? '' :  DELIMITER + caseId;

            orderHistoryMap.put(EXTERNAL_ID, profileUUID + DELIMITER + recordId + caseForExternalId);
            orderHistoryMap.put(PROFILE_UUID, profileUUID);
            orderHistoryMap.put(ACCOUNT_PROFILE_UUID, profileUUID);
            if(orderHistoryMap.containskey(ATTRIBUTE_STATUS)){
                Map<String, Object> orderHistoryStatus = (Map<String, Object>) orderHistoryMap.get(ATTRIBUTE_STATUS);
                orderHistoryMap.put(ATTRIBUTE_STATUS, orderHistoryStatus.get(ATTRIBUTE_STATUS));
                orderHistoryMap.put(ATTRIBUTE_REASON, orderHistoryStatus.get(ATTRIBUTE_REASON));
             }

            if(orderHistoryMap.containskey(ATTRIBUTE_HARDWARE)){
                String orderHistoryHardware = String.ValueOf(orderHistoryMap.get(ATTRIBUTE_HARDWARE));                        
                orderHistoryHardware=orderHistoryHardware.replace('(','');
                orderHistoryHardware=orderHistoryHardware.replace(')','').replace(' ','');
                orderHistoryMap.put(ATTRIBUTE_HARDWARE , orderHistoryHardware);

                List<String> hardwareList = orderHistoryHardware.replace(' ','').split(',');
                String hardwareTypes = getHardwareTypes(hardwareList);
                orderHistoryMap.put(HARDWARE_TYPE , hardwareTypes);
             }

             if(orderHistoryMap.containskey(ERROR_CODE)){
                    orderHistoryMap.put(ERROR, (String)orderHistoryMap.get(ERROR_DESCRIPTION));
             }
        return orderHistoryMap;
    }

    @testVisible private  static String getHardwareTypes(List<String> hardwareList) {
        List<Product2> hardwareInfoList = [select Id, SKU_Code__c, Name from Product2 where SKU_Code__c in :hardwareList];

        Map<String, String> productMap = new Map<String, String>();
        if(hardwareInfoList != null && hardwareInfoList.size() > 0) {
            //Converting list of products into map or SKU_Code and product name
            for(Product2 hardwareInfo: hardwareInfoList) {
                productMap.put(hardwareInfo.SKU_Code__c, hardwareInfo.Name);
            }
        }

        // creating a list of SKU Code and Product name to display
        List<String> hardwareWithProductName = new List<String>();
        for(String hardware: hardwareList) {
            if(String.isNotEmpty(hardware)) {
                String productName = productMap.get(hardware) == null ?
                    UNKNOWN_PRODUCT : productMap.get(hardware);
                hardwareWithProductName.add(String.format('{0} ({1})', new String [] {productName, hardware}));
            }
        }
        return String.join(hardwareWithProductName, ',|').replace('|','\n');
    }

    private  List<Map<String, Object>> getRelatedResponse(Map<String, Object> orderHistoryMap,String tableName){
        List<Map<String, Object>> resultRows = new List<Map<String, Object>>(); 
        if(PRODUCTS.equals(tableName)) {
              resultRows = NTV_OrderHistoryDriverUtil.getProduct(orderHistoryMap,externalId,profileUUID,orderId);
        } else if(SUBSCRIPTIONS.equals(tableName)){
              resultRows = NTV_OrderHistoryDriverUtil.getSubscription(orderHistoryMap,externalId,profileUUID,orderId);
        }
        return resultRows;
    }

    protected override Map<String, Object> performHttpCallout(String profileUUID, final String propositionVal, final String providerVal) {
        return NTV_OrderHistoryDriverUtil.performHttpCallout(profileUUID, propositionVal, providerVal);
    }

    private DataSource.TableResult getOrderByOrderID(DataSource.QueryContext context){
        List<Map<String, Object>> resultRows;
        try{
            // Fetch proposition and provider values
            String profileUUIDVal = orderId.split(DELIMITER).get(0);
            this.fetchPropositionAndProvider(profileUUIDVal);

            Map<String, Object> response = NTV_OrderHistoryDriverUtil.performHttpCallout(getUserDetails().Service_Agent_Territory__c,
                orderId, this.proposition, this.provider);
            resultRows = transform(response,'');
        } catch (Exception ex){
            resultRows = new List<Map<String, Object>>();
            resultRows.add(new Map<String,Object>{'Error' => ex.getMessage(), PROFILE_UUID => profileUUID, EXTERNAL_ID =>'ERROR'});
        }

        return DataSource.TableResult.get(context, resultRows);
    }

    private String getFilterName(String tableName){
        if(PRODUCTS.equals(tableName)){
            return ATTRIBUTE_ORDER_ID;
        }
        return EXTERNAL_ID;
    }
    
    private User getUserDetails(){
        return [select Id, Service_Agent_Territory__c from User where Id =: UserInfo.getUserId()];
    }*/
}