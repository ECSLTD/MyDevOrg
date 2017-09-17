@isTest
public class NTV_TestSObjectFieldMap {
    // Fields that should be ignored when creating objects
    public static Map<String, Set<String>> FIELDS_TO_IGNORE = new Map<String, Set<String>> {
        // fields to ignore for all SObjects
        'standard' => new Set<String> {
            'ownerid', 'lastmodifiedbyid', 'createdbyid', 'lastmodifieddate', 'createddate'
        },
        'user' => new Set<String> {
            'isActive','delegatedapproverId','callcenterId','contactid',
            'delegatedapproverid','managerid','userroleid','federationidentifier'
        },
        'now_tv_subscription__c' => new Set<String> {
            'service_price_currency__c'
        },
        'account' => new Set<String> {
            'name'
        },
        'case' => new Set<String> {
          'territory__c', 'classification__c'
        }
    };  
}