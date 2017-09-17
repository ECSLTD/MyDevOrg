public class NTV_JsonUtil {
    public final static String SALESFORCE_DATA_FORMAT = 'dd/MM/YYYY HH:mm';
    public final static String ISO_DATE_PATTERN_MATCHER = '\\d+-\\d+-\\d+T\\d+:\\d+:\\d+(.\\d+)?(Z)?';
    /**
     * recursively find and replace all isodates in json deserialised to a map
     * @param  json desirialized to a map
     * @return map
     */
    public Static void findAndReplaceIsoDates(Map<String, Object> objectMap) {
        for (String key : objectMap.keySet()) {
            if(isIsoDate(objectMap.get(key))){
                objectMap.put(key, (String)convertIsoDateToSalesforceDateString(objectMap.get(key)));
            } else if (getJsonNodeObjectType(objectMap.get(key)) =='List') {
                findAndReplaceIsoDates((List<Object>) objectMap.get(key));
            } else if (getJsonNodeObjectType(objectMap.get(key)) == 'Map') {
                findAndReplaceIsoDates((Map<String, Object>) objectMap.get(key));
            } 
        }
    }

    /**
     *  overloaded method to handle list
     * @param  json array deserialised to a list of object
     * @return void
     */
    public Static void findAndReplaceIsoDates(List<Object> objectList) {
        for (Object data : objectList) {
            if (getJsonNodeObjectType(data).equals('Map')){
               findAndReplaceIsoDates((Map<String, Object>) data);
            }
        }
    }

    /**
     * Method to convert ISO Date into Local Salesforce DateTime object
     * @param Date String e.g. 2015-06-02T13:10:26.140Z
     * @return Salesforce user local timezone date string i.e. 02/06/2015 if param pattern matches IsoDate
     */
    public Static Object convertIsoDateToSalesforceDateString(Object dateTimeString) {
        return NTV_Utils.convertToSpecificTimeZone((String) dateTimeString, UserInfo.getTimeZone().getDisplayName()).format(SALESFORCE_DATA_FORMAT);
    }

    /**
     * checks if string pattern matches iso date pattern
     * @param  someObject 
     * @return   boolean
     */
    private static boolean isIsoDate(Object someObject) {
        if (someObject != null) {
            return Pattern.matches(ISO_DATE_PATTERN_MATCHER, String.valueOf(someObject));
        }
        return false;
    }

    /**
     * @param  someObject 
     * @return  String value of object type
     */
    private static string getJsonNodeObjectType(Object o) {
        if (o == null) return null;
        if (o instanceof Boolean) return 'Boolean';
        if (o instanceof Integer) return 'Integer';
        if (o instanceof Long) return 'Long';
        if (o instanceof List<object>) return 'List';
        if (o instanceof Map<String, object>) return 'Map';

        if (o instanceof String && isIsoDate(o)) {
            return 'IsoDate';
        } else if (o instanceof String) {
            return 'String';
        }

        return 'Object';
    }
}