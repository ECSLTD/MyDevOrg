public without sharing class NTV_SObjectUtil {

    /**
     * Returns global describe Map
     */
    public static  Map<String, Schema.SObjectType> GlobalDescribe {
        get {
            if (GlobalDescribe == null) {
                GlobalDescribe = Schema.getGlobalDescribe();
            }
            return GlobalDescribe;
        } 
        private set;
    }

    /**
     * get sobject type
     */
    public static Schema.SObjectType getSObjectType(String sobjectName) {
        return GlobalDescribe.get(sobjectName);
    }

    /**
     * get sobject describe
     */
    public static Schema.DescribeSObjectResult getDescribeSObject(String sobjectName) {
        return GlobalDescribe.get(sobjectName).getDescribe();
    }

    /**
     * Returns field Map. throws null pointer exception, if invalid sobject api name is passed. 
     * @sObjectName  sobject api name
     */
    public static Map<String, Schema.SObjectField> getSObjectFieldMap(String sObjectName){
        Map<String, Schema.SObjectField> fieldMap = getDescribeSObject(sObjectName).fields.getMap();
        return fieldMap;
    }

    /**
     * Returns fieldset Map. throws null pointer exception, if invalid sobject api name is passed. 
     * @sObjectName  sobject api name
     */
    public static Map<String, Schema.FieldSet> getSObjectFieldSetMap(String sObjectName){
        Map<String, Schema.FieldSet> fieldsetMap = getDescribeSObject(sObjectName).fieldSets.getMap();
        return fieldsetMap;
    }

    /**
     * Returns Sobject field. throws null pointer exception, if invalid sobject api name is passed. 
     * @sObjectName  sobject api name
     */
    public static Schema.SObjectField getSObjectField(String sObjectName, String fieldName){
        Schema.SObjectField sobjectField = getSObjectFieldMap(sObjectName).get(fieldName);
        return sobjectField;
    }

    /**
     * Returns Sobject field. throws null pointer exception, if invalid sobject api name is passed. 
     * @sObjectName  sobject api name
     */
    public static Schema.DescribeFieldResult getDescribeField(String sObjectName, String fieldName){
        Schema.DescribeFieldResult describeField = getSObjectField(sObjectName,fieldName).getDescribe();
        return describeField;
    }

    /**
     * Returns Sobject field. throws null pointer exception, if invalid sobject api name is passed. 
     * @sObjectName  sobject api name
     */
    public static Schema.FieldSet getSObjectFieldSet(String sObjectName, String fieldSetName){
        Schema.FieldSet sobjectField = getSObjectFieldSetMap(sObjectName).get(fieldSetName);
        return sobjectField;
    }

    /**
     * Returns Sobject field. throws null pointer exception, if invalid sobject api name is passed. 
     * @sObjectName  sobject api name
     */
    public static List<Schema.FieldSetMember> getFieldsetMembers(String sObjectName, String fieldSetName){
        List<Schema.FieldSetMember> fields = getSObjectFieldSet(sObjectName, fieldSetName).getFields();
        return fields;
    }

    /**
     * Set with all field name.throw null pointer exception, if invalid sobject api names are passed. 
     * @sObjectName sobject api name
     * @fieldSetMembers  optional parameter, if is passed any parent fields will be added to the container;
     */
    public static List<String> getAllFieldNames(String sObjectName, List<Schema.FieldSetMember> fieldSetMembers) {
        Map<String, Schema.SObjectField> fieldMap = getSObjectFieldMap(sObjectName);
       
        Set<String> fieldNames = new Set<String>();
        // add all fields from the describe
        for (String field : fieldMap.keySet()) { 
            fieldNames.add(field); 
        }
        // if fieldSet are passed into second param then add into the container
        if (fieldSetMembers != null && !fieldSetMembers.isEmpty()) {
            for (Schema.FieldSetMember field : fieldSetMembers) { 
                if (!fieldNames.contains(field.getFieldPath().toLowerCase()))
                    fieldNames.add(field.getFieldPath().toLowerCase()); 
            }
        }
        return (new List<String>(fieldNames));   
    }

    /**
     * Returns unique look up Ids from the List of sobject
     * @sobjectList List of sobject
     * @fieldName Look up field api name
     */
    public static Set<Id> getLookupIds(List<SObject> sobjectList, String fieldName) {
        Set<Id> ids = new Set<Id>();
        
        for (SObject sobj : sobjectList) {
            if (sobj.get(fieldName) != null)
                ids.add((Id)sobj.get(fieldName));
        }

        return ids;
    }

    /**
     * Returns unique external Ids from the List of sobject
     * @sobjectList List of sobject
     * @fieldName external Id field api name
     */
    public static Set<String> getExternalIds(List<SObject> sobjectList, String fieldName) {
        Set<String> extIds = new Set<String>();
        
        for (SObject sobj : sobjectList) {
            if (!String.isEmpty((String)sobj.get(fieldName)))
                extIds.add((String)sobj.get(fieldName));
        }

        return extIds;
    }

}