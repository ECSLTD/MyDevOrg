@isTest
public class NTV_TestDataFactory {
    public static Boolean setDefaults;
    private static Map<String, Map<String, Schema.SObjectField>> fieldCache;
    private static final Map<String, Schema.SObjectType> globalDescribe;
    static {
        fieldCache = new Map<String, Map<String, Schema.SObjectField>>();
        globalDescribe = Schema.getGlobalDescribe();
        setDefaults = true;
    }
    
    /**
     * create sobject and set default random values if 'setDefaults' is set to true.
     */
    public static SObject createSObject(String strSObjectType) {
        Schema.sObjectType sobjectType = globalDescribe.get(strSObjectType.toLowerCase());
        SObject record = sObjectType.newSObject();

        if (setDefaults) {
            setDefaults(record, strSObjectType);
        }

        return record;
    }

    /**
     * create sobject and set values from customFieldValMap
     */
    public static SObject createSObject(String strSObjectType, Map<String,Object> customFieldValMap) {
        SObject sobj = createSObject(strSObjectType);
        setCustomValue(sobj, customFieldValMap);
        return sobj;
    }

    /**
     * create list of sobject and set default values on each of them.
     */
    public static list<SObject> createSObjects(Integer size, String strSObjectType) {
        list<SObject> sobjects = new list<SObject>();
        for (Integer i=0; i<size; ++i) {
            sobjects.add(createSObject(strSObjectType));
        }

        return sobjects;
    }

    /**
     * create list of sobject and set default values on each of them.
     */
    public static list<SObject> createSObjects(Integer size, String strSObjectType, Map<String,Object> customFieldValMap) {
        List<SObject> sobjects = createSObjects(size, strSObjectType);
        for (SObject sobj:sobjects) {
            setCustomValue(sobj, customFieldValMap);
        }

        return sobjects;
    }

    public static void setDefaults(SObject record, String strSObjectType) {
        Map<String, Schema.SObjectField> fieldMap = getAllSObjectFields(strSObjectType);
        for (Schema.SObjectField field:fieldMap.values()) {
            setDefautValue(record, strSObjectType, field);
        }
    }

    private static void setCustomValue(SObject sobj, Map<String,Object> customFieldValMap) {
        for (String field :customFieldValMap.keyset()) {
            sobj.put(field, customFieldValMap.get(field));
        }
    }

    private static void setDefautValue(SObject obj, String strSObjectType, Schema.SObjectField field) {
        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

        if (isFieldCreatable(strSObjectType, fieldDescribe)) {
            // Generate a "random" number based upon the current timestamp in 
            // milliseconds (reversed), allowing for a unique value to be obtained.
            // NOTE: math.random() isn't as random as we'd like it to be!
            String randomval = String.valueOf(Datetime.now().getTime()).reverse();

            if (fieldDescribe.getType() == Schema.DisplayType.base64) {
                obj.put(field, blob.valueOf('Hello world'));
            
            } else if (fieldDescribe.getType() == Schema.DisplayType.Boolean) {
                obj.put(field, false);
            
            } else if (fieldDescribe.getType() == Schema.DisplayType.Combobox) {
                obj.put(field, randomval);
            
            } else if ((fieldDescribe.getType() == Schema.DisplayType.Currency) || 
                                (fieldDescribe.getType() == Schema.DisplayType.Double)) {
                obj.put(field, math.random());
            
            } else if (fieldDescribe.getType() == Schema.DisplayType.Date) {
                obj.put(field, Date.today());
            
            } else if (fieldDescribe.getType() == Schema.DisplayType.DateTime) {
                obj.put(field, DateTime.now());
            
            } else if (fieldDescribe.getType() == Schema.DisplayType.Email) {
                obj.put(field, 'test' + randomval + '@example.com');
            
            } else if (fieldDescribe.getType() == Schema.DisplayType.EncryptedString) {
                obj.put(field, 'Secret' + randomval);
            
            } else if (fieldDescribe.getType() == Schema.DisplayType.Integer) {
                Integer allowedDigits = fieldDescribe.getDigits();
                randomval = (randomval.length() > allowedDigits) ? 
                                            randomval.substring(0, allowedDigits - 1) : randomval;
                obj.put(field, Integer.valueOf(randomval));
            
            } else if (fieldDescribe.getType() == Schema.DisplayType.MultiPicklist) {
                obj.put(field, getDefaultPicklistValue(fieldDescribe));
            
            } else if (fieldDescribe.getType() == Schema.DisplayType.Percent) {
                obj.put(field, math.random());
            
            } else if (fieldDescribe.getType() == Schema.DisplayType.Phone) {
                obj.put(field, '123-456-7890');
            
            } else if (fieldDescribe.getType() == Schema.DisplayType.Picklist) {
                obj.put(field, getDefaultPicklistValue(fieldDescribe));
            
            } else if ((fieldDescribe.getType() == Schema.DisplayType.String) ||
                                (fieldDescribe.getType() == Schema.DisplayType.TextArea)) {
                Integer length = fieldDescribe.getLength();
                String strval = 'test' + randomval;
                strval = (strval.length() > length) ? strval.substring(0, length) : strval;
                obj.put(field, strval); 
            
            } else if (fieldDescribe.getType() == Schema.DisplayType.Time) {
                obj.put(field, Time.newInstance(0, 0, 0, 0)); 
            
            } else if (fieldDescribe.getType() == Schema.DisplayType.URL) {
                obj.put(field, 'http://example'+ randomval +'.com'); 
            }
        }  
    }

    private static boolean isFieldCreatable(String strSObjectType, Schema.DescribeFieldResult fieldDescribe) {
        String fieldName = fieldDescribe.getName().toLowerCase();

        return (
            !isFieldExcluded(strSObjectType,fieldName) &&
            fieldDescribe.isCreateable() && 
            fieldDescribe.isAccessible() &&
            fieldDescribe.isUpdateable() &&
            (fieldDescribe.getType() != Schema.DisplayType.Reference) &&
            (fieldDescribe.getType() != Schema.DisplayType.Id)
        );
    }

    private static boolean isFieldExcluded(String strSObjectType, String fieldName) {
        String sobjectType = strSObjectType.toLowerCase();
        String fieldType   = fieldName.toLowerCase();
        return (
            (
                NTV_TestSObjectFieldMap.FIELDS_TO_IGNORE.containsKey(sobjectType) &&
                NTV_TestSObjectFieldMap.FIELDS_TO_IGNORE.get(sobjectType).contains(fieldType)
            ) ||
            (
                NTV_TestSObjectFieldMap.FIELDS_TO_IGNORE.containsKey('standard') &&
                NTV_TestSObjectFieldMap.FIELDS_TO_IGNORE.get('standard').contains(fieldType)
            )
        );
    }

    private static String getDefaultPicklistValue(Schema.DescribeFieldResult fieldDescribe) {
        List<Schema.PicklistEntry> entries = fieldDescribe.getPicklistValues();
        return (entries.size() > 0 ? entries[0].getValue() : 'None');
    }

    private static Map<String, Schema.SObjectField> getAllSObjectFields(String strSObjectType) {
        Schema.sObjectType sobjectType = globalDescribe.get(strSObjectType);

        if (!fieldCache.containsKey(strSObjectType.toLowerCase())) {
            // get all fields and cache it
            fieldCache.put(strSObjectType.toLowerCase(), sobjectType.getDescribe().fields.getMap());
        }
        
        // fetch from cache
        return fieldCache.get(strSObjectType.toLowerCase());
    }  
    
}