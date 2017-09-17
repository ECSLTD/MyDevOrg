/**
* Provider class for CRM API.
**/
global with sharing class NTV_CRMDataSourceProvider {
//global with sharing class NTV_CRMDataSourceProvider extends DataSource.Provider {
    
    /**
    *  Declares the types of authentication that can be used
    *  to access the external system
    **/   
    /*public override List<DataSource.AuthenticationCapability> getAuthenticationCapabilities() {
        List<DataSource.AuthenticationCapability> capabilities = new List<DataSource.AuthenticationCapability>();
        capabilities.add( DataSource.AuthenticationCapability.BASIC );

        return capabilities;
    }*/

    /**
    *  Declares the functional capabilities that the
    *  external system supports.
    **/
   /* public override List<DataSource.Capability> getCapabilities() {
        List<DataSource.Capability> capabilities = new List<DataSource.Capability>();
        capabilities.add(DataSource.Capability.ROW_QUERY);
        capabilities.add(DataSource.Capability.ROW_CREATE);
        capabilities.add(DataSource.Capability.ROW_UPDATE);
        capabilities.add(DataSource.Capability.ROW_DELETE);
        capabilities.add(DataSource.Capability.REQUIRE_ENDPOINT);
        //capabilities.add(DataSource.Capability.SEARCH);
        return capabilities;
    }*/

    /**
    *  Declares the associated DataSource.Connection class.
    **/
    /*public override DataSource.Connection getConnection(DataSource.ConnectionParams connectionParams) {
        return new NTV_CRMDataSourceConnection(connectionParams);    }*/
}