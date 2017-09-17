/**
* Add any CRM data creation function here, please.
* 
* @Author MR/Abhi
**/

@isTest
public class NTV_TestCRMDataFactory {
  
  public static List<Account> createAccounts(Id recordTypeId, Integer recordSize) {
    Map<String, Object> customValues = new Map<String, Object>();
    if (recordTypeId != null) {
      customValues.put('RecordTypeId', recordTypeId);
    }
    List<Account> accounts = (List<Account>) NTV_TestDataFactory.createSObjects(recordSize, 'Account', 
                                              customValues);
    return accounts;
  }

  public static List<Account> createAccounts(Integer recordSize) {
    return createAccounts(NULL, recordSize);
  }

  public static List<Contact> createContacts(Id recordTypeId, Id accountId, Integer recordSize) {
    Map<String, Object> customValues = new Map<String, Object>();
    if (recordTypeId != null) {
      customValues.put('RecordTypeId', recordTypeId);
    }
    if (accountId != null) {
      customValues.put('AccountId', accountId);
    }
    List<Contact> contacts = (List<Contact>) NTV_TestDataFactory.createSObjects(recordSize, 'Contact', 
                                              customValues);
    return contacts;
  }

  public static List<Contact> createContacts(Id accountId, Integer recordSize) {
    return createContacts(NULL, accountId, recordSize);
  }

  public static DataSource.QueryContext createContext(DataSource.Filter filter, DataSource.TableSelection tableSelection, DataSource.FilterType filterType, String columnName, String columnValue, String tableSelected){
    DataSource.QueryContext context = new DataSource.QueryContext();
    
    filter.columnName = columnName;
    filter.columnValue = columnValue;

    filter.type = filterType;

    tableSelection.tableSelected = tableSelected;
    tableSelection.filter = filter;
    context.TableSelection = tableSelection;

    return context;
  }

  public static DataSource.upsertContext createUpsertContext(String tableSelected){
    DataSource.upsertContext context = new DataSource.upsertContext();
    
    //context.rows = new list<context.rows>();
    context.tableSelected = tableSelected;

    return context;
  }
  
  public static DataSource.Filter createFilter(String columnName, String columnValue, DataSource.FilterType filterType){
    DataSource.Filter filter = new DataSource.Filter();

    filter.columnName = columnName;
    filter.columnValue = columnValue;
    filter.type = filterType;

    return filter;

  }
  
}