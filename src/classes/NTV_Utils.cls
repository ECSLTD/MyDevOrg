public with sharing class NTV_Utils {

    public static BusinessHours DEFAULT_BUSINESS_HOUR {
        get{
            if(DEFAULT_BUSINESS_HOUR == null){
                DEFAULT_BUSINESS_HOUR = [select Id from BusinessHours where IsDefault = true and IsActive = true];
            }
            return DEFAULT_BUSINESS_HOUR;
        }
        set;
    }

    public static Id BUSINESS_HOURS_ID {
        get {
            if(String.isBlank(BUSINESS_HOURS_ID)){
                BUSINESS_HOURS_ID = DEFAULT_BUSINESS_HOUR.Id;
            }
            return BUSINESS_HOURS_ID;
        }
        set;
    }
    public static final String  DATETIME_FORMAT_ERR = 'Set String To DateTime Format';
    public static final String  TIMEZONE_ERR        = 'Convert to Specific Time Zone';
    private static Map<String, Schema.SObjectType> gd;
    private static Map<String, Map<Id,Schema.RecordTypeInfo>> recordTypesById = new Map<String, Map<Id,Schema.RecordTypeInfo>>();
    private static Map<String, Map<String,Schema.RecordTypeInfo>> recordTypesByName = new Map<String, Map<String,Schema.RecordTypeInfo>>();
    private static Map<String, sObject> configMetaData;

    private static final String NTV_CUSTOM_METADATA_TYPE = 'NTV_Org_Config__mdt';
    private static final String NTV_CUSTOM_PICKLIST_METADATA_TYPE = 'NTV_Org_Picklist__mdt';
    
    public static String getRecordTypeName(final Schema.SObjectType sObjectType, final Id recordTypeId){
        String objectName = String.valueof(sObjectType);
        if(!recordTypesById.containsKey(objectName))
            loadMapsForObject(objectName);
        
        Map<Id,Schema.RecordTypeInfo> rtMap = recordTypesById.get(objectName);
        if(rtMap != null && rtMap.containsKey(recordTypeId)){
            return rtMap.get(recordTypeId).getName();
        }
        
        return null;
    }
    
    public static Id getRecordTypeId(final Schema.SObjectType sObjectType, final String recordTypeName){
        String objectName = String.valueof(sObjectType);
        if(!recordTypesByName.containsKey(objectName))
            loadMapsForObject(objectName);
        
        Map<String,Schema.RecordTypeInfo> rtMap = recordTypesByName.get(objectName);
        if(rtMap != null && rtMap.containsKey(recordTypeName)){
            return rtMap.get(recordTypeName).getRecordTypeId();
        }
        
        return null;
    }
    
    private static void loadMapsForObject(final string objectName){
        
        if(gd == null)
            gd = Schema.getGlobalDescribe();
        
        if(gd.containsKey(objectName)){
            Schema.DescribeSObjectResult d = gd.get(objectName).getDescribe();
            recordTypesByName.put(objectName, d.getRecordTypeInfosByName());
            recordTypesById.put(objectName, d.getRecordTypeInfosById());
        }
    }
    
    //Get the Business Hours from the Organization Business Hours
    public static BusinessHours getBusinessHours(final String bhName) {
        List<BusinessHours> bhList = [select Id from BusinessHours where Name =:bhName and IsActive = true];

        return bhList.isEmpty() ? null : bhList.get(0);
    }

    //Calculate the business hours
    public static Double businessHoursInHours(final Id businessHoursId, final DateTime startTime, final DateTime endTime) {
        return BusinessHours.diff(businessHoursId, startTime, endTime)/3600000.0;
    }

    public static String randomUUID(){
        Blob cryptoKey = Crypto.GenerateAESKey(128);
        String hexValue = EncodingUtil.ConvertTohex(cryptoKey);
        String uuid = hexValue.SubString(0,8)+ '-' + hexValue.SubString(8,12) + '-' + hexValue.SubString(12,16) + '-' + hexValue.SubString(16,20) + '-' + hexValue.substring(20);
        system.debug('UUID generated: ' + uuid);
        return uuid;
    }

    public static String getHouseHoldId(String profileUUID){
        return parseProfileId(profileUUID).get(0);
    }

    public static String getTerritory(String profileUUID){
        return parseProfileId(profileUUID).get(1);
    }

    private static List<String> parseProfileId(String profileUUID) {
        if (String.isBlank(profileUUID)) {
            //throw new NTV_BaseException(Label.NTV_External_DataSource_Null_Or_Empty_ProfileUUID);
        }

        List<String> profileUuIdParts = profileUuId.split('_');

        if(profileUuIdParts.size() != 2) {
            //throw new NTV_BaseException(Label.NTV_External_DataSource_ProfileUUID_Error);   
        }

        return profileUuIdParts;
    }

    /**
    * this will return the class name of an instance
    * Function works only for class instance.
    **/
    public static String getClassName(Object instance) {
        return String.valueOf(instance).split(':')[0];
    }

    /**
    * function will add barces to string expression. e.g. expression  '1 AND 2 AND 3 OR (4 AND 1)'
    * will be converted to '{1} AND {2} AND {3} OR ( {4} AND {1} )'
    **/
    public static String wrapIndexInCurelyBraces(String expression) {
        // parse the expression and wrapp the index with delimiters
        String parsedExpr = expression;
        Pattern pat     = Pattern.compile('\\d+');
        Matcher mat       = pat.matcher(expression); 
        set<Integer> indexset = new set<Integer>();
        // collect all integer index in expression and remove duplicates using 
        // set
        while (mat.find()) {
           Integer matchedVal = Integer.valueOf(mat.group());
           if (!indexset.contains(matchedVal)) {
             indexset.add(matchedVal);
           }
        }

        list<Integer> indexList = new list<Integer>(indexset);
        // sort the integers 
        indexList.sort();
        // from reverse start replacing all integers
        for(Integer i= indexList.size() - 1; i >=0 ; --i) {
          String target      = String.valueOf(indexList[i]);
          String replacement = String.valueOf(indexList[i]);
          parsedExpr        = parsedExpr.replace(target, NTV_GlobalConstants.OPEN_BRACE + replacement + 
                                  NTV_GlobalConstants.CLOSE_BRACE);       
        }
        return parsedExpr;
    }
    
    /**
    * Description : To convert string into Date time format
    **/    
    public static DateTime setStringToDateTimeFormat(String myDateTime, Boolean isFromAPIRequest) {
     
        try{
            String updatedDateTime = myDateTime;
            updatedDateTime        = updatedDateTime.replaceAll('T', ' ');
            updatedDateTime        = updatedDateTime.replaceAll('Z', '');

            String[] myDateOnly    = updatedDateTime.split(' ');
            String[] strDate       = myDateOnly.get(0).split('-');

            Integer myIntYear      = integer.valueOf(strDate.get(0));
            Integer myIntMonth     = integer.valueOf(strDate.get(1));
            Integer myIntDate      = integer.valueOf(strDate.get(2));

            String[] strTime       = myDateOnly.get(1).split(':'); 
            Integer myIntHR        = integer.valueOf(strTime.get(0));
            Integer myIntMM        = integer.valueOf(strTime.get(1));
            Integer myIntSS;
            if(!strTime.get(2).contains('.')){
                myIntSS          = integer.valueOf(strTime.get(2));  
            }else{
                myIntSS          = integer.valueOf(strTime.get(2).split('\\.')[0]);  
            }       
            DateTime dt ;

            if(isFromAPIRequest){
                dt = DateTime.newInstance(myIntYear, myIntMonth, myIntDate, myIntHR, myIntMM, myIntSS);
            }else{
                dt = DateTime.newInstanceGmt(myIntYear, myIntMonth, myIntDate, myIntHR, myIntMM, myIntSS);
            }

            return dt;
        }
        catch(Exception ex){
            //Create a log record for the error.
           // NTV_Logger.error(NTV_Utils.getClassName(new NTV_Utils()), DATETIME_FORMAT_ERR, ex);
            return null;
        }
    }

    /**
    * Description : To convert String in ISO8601 format into Datetime
    **/    
    public static DateTime setStringInTZToDateTimeFormat(String myDateTime){
        DateTime dt = (DateTime) JSON.deserialize(
                                    '"' + myDateTime + '"', DateTime.class);
        return dt;
    }

    /**
    * Description : Method to convert Datetime into BST
    **/
    public Static DateTime convertToSpecificTimeZone(String dateTimeStr, String timeZone){
        try{
            DateTime dt;
            String dateTimeStrBst;
            DateTime dateTimeBst;

            dt = setStringToDateTimeFormat(dateTimeStr, false) ;
            dateTimeStrBst = dt.format('yyyy-MM-dd HH:mm:ss', timeZone);      
            dateTimeBst =  setStringToDateTimeFormat(dateTimeStrBst, false);    

            return dateTimeBst;
        }
        catch(Exception ex){
            //Create a log record for the error.
           // NTV_Logger.error(NTV_Utils.getClassName(new NTV_Utils()), TIMEZONE_ERR, ex);
            return null;
        }    
    }

    public static Map<String, sObject> getCustomMetadataTypes(String sObjectName) {
        List<sObject> relativePaths = Database.query('select Relative_Path__c, DeveloperName from ' + sObjectName);
        Map<String, sObject> relativePathWithLabels = new Map<String, sObject>();
        for(sObject relativePath: relativePaths) {
                relativePathWithLabels.put(String.ValueOf(relativePath.get('DeveloperName')),relativePath);
        }
        return relativePathWithLabels;
    }

    public static String getNtvOrgConfigValue(String key) {
        if(configMetaData == null) {
            List<sObject> relativePaths = Database.query('select value__c, DeveloperName from ' + NTV_CUSTOM_METADATA_TYPE);
            configMetaData = new Map<String, sObject>();
            for(sObject relativePath: relativePaths) {
                    configMetaData.put(String.ValueOf(relativePath.get('DeveloperName')),relativePath);
            }
        }
        final String value =''; //((NTV_Org_Config__mdt)configMetaData.get(key)).Value__c;
        return value;
    }

    public static String getNtvOrgPickListValue(String key) {
        if(configMetaData == null) {
            List<sObject> relativePaths = Database.query('select value__c, DeveloperName from ' + NTV_CUSTOM_PICKLIST_METADATA_TYPE);
            configMetaData = new Map<String, sObject>();
            for(sObject relativePath: relativePaths) {
                    configMetaData.put(String.ValueOf(relativePath.get('DeveloperName')),relativePath);
            }
        }
        final String value = '';//((NTV_Org_Picklist__mdt)configMetaData.get(key)).Value__c;
        return value;
    }

    public static Map<String, sObject> getCustomMetadataTypes(String sObjectName,List<String> selectList) {

        String strSelectList = String.join(selectList,NTV_GlobalConstants.COMMA_SEPRATOR);
        List<sObject> relativePaths = Database.query('select ' + strSelectList + ' from ' + sObjectName);
        Map<String, sObject> relativePathWithLabels = new Map<String, sObject>();
        for(sObject relativePath: relativePaths) {
                relativePathWithLabels.put(String.ValueOf(relativePath.get('DeveloperName')),relativePath);
        }
        return relativePathWithLabels;
    }

}