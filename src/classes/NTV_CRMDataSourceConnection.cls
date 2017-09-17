/**
* This class handles queries and searches of the external data
**/
public with sharing class NTV_CRMDataSourceConnection  {
//public with sharing class NTV_CRMDataSourceConnection extends DataSource.Connection {
    // connection information
   /* private DataSource.ConnectionParams connectionParams;
    
    /**
    * connection information.
    **/
   /* public NTV_CRMDataSourceConnection(DataSource.ConnectionParams connectionParams) {
        this.connectionParams = connectionParams;
    }*/

    /**
    *  
    **/
   /* public override List<DataSource.Table> sync() {
        return new List<DataSource.Table>();
    } */

    /**
    *   
    **/
   /* public override DataSource.TableResult query( DataSource.QueryContext contexts) {
        DataSource.TableResult result;
        // Load the object specific driver and query.
        NTV_CRMDataSourceDriver driver = loadDriver(contexts.tableSelection.tableSelected);
        if (driver != null) {
            result = driver.query(contexts);
        }
        return result;
    }*/

    /**
    *   
    **/
    /*public override List<DataSource.TableResult> search(DataSource.SearchContext contexts) {
        List<DataSource.TableResult> results = new List<DataSource.TableResult>();
        return results;
    }*/

    /**
    *
    **/
   /* public override List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext context) {
        List<DataSource.UpsertResult> result;
        // Load the object specific driver and query.
        NTV_CRMDataSourceDriver driver = loadDriver(context.tableSelected);

        if (driver != null) {
            result = driver.upsertRows(context);
        }
        return result;
    }*/

    /**
    *
    **/
   /* public override List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext context) {
        List<DataSource.DeleteResult> result;
        // Load the object specific driver and query.
        NTV_CRMDataSourceDriver driver = loadDriver(context.tableSelected);

        if (driver != null) {
            result = driver.deleteRows(context);
        }
        return result;
    }*/

    /**
    * load the object driver that has been registered with driver registery.
    *
    * @param sobjectName Exernal object name without __x at the end.
    **/
   /* private NTV_CRMDataSourceDriver loadDriver(final String externalObjectName) {
        DataSource_Driver_Registry__c settings = (DataSource_Driver_Registry__c) DataSource_Driver_Registry__c.getValues(externalObjectName);
        NTV_CRMDataSourceDriver driver;
        
        if (settings != null) {
            driver = (NTV_CRMDataSourceDriver) Type.forName(settings.className__c).newInstance();
            driver.setConnection(connectionParams);
        }else{
            System.debug('Fatal Error '+ externalObjectName+' custom settings entry not defined in DataSource_Driver_Registry__c');
            throw new NTV_BaseException('Fatal Error '+ externalObjectName+' custom settings entry not defined in DataSource_Driver_Registry__c');
        }
        return driver;
    }*/
}