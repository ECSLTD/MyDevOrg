/**
* This class similar to DataSource.connection class and it's method.
* Only reason we have this class is to delegate call to external object driver.
* External object driver will reduce amount of code in the NTV_DataSourceConnection class
* and make it easy readable and maintainable.
**/
public with sharing abstract class NTV_CRMDataSourceDriver {

   /* public static final String ACCOUNT_PROFILE_UUID = 'Account_Profile_UUID';

    private static final String NOT_IMPLEMENTED_EXCEPTION_MESSAGE = 'Error Not Implemented';
    public static final String EXTERNAL_ID = 'ExternalId';
    public static final String PROFILE_UUID = 'Profile_UUID';
    public static final String DELIMITER = ':';
    protected final String DISPLAY_URL = 'DisplayUrl';
    protected final String METHOD_GET = 'GET';
    protected final String METHOD_POST = 'POST';
    protected final String METHOD_PUT = 'PUT';
    protected final String CRM_API_ID_FIELD_LABEL = 'id';
    protected String proposition { get; private set;}
    protected String provider { get; private set;}

    protected String agentFederationID {
        get{
            return [Select FederationIdentifier FROM User WHERE Id =: UserInfo.getUserId() limit 1].FederationIdentifier;
        }
        private set;
    }

    // connection
    public DataSource.ConnectionParams connectionParams {get; private set;}

    public void setConnection(DataSource.ConnectionParams connectionParams) {
        this.connectionParams = connectionParams;
    }

    protected void fetchPropositionAndProvider(String profileUUID){
        Map<String, String> propositionProviderMap = NTV_Utils.getPropositionAndProviderForProfileUUID(profileUUID);
        String proposition, provider;
        if(propositionProviderMap != null){
            this.proposition = propositionProviderMap.get(NTV_CRMApiRequestUtil.PROPOSITION_HEADER_KEY);
            this.provider = propositionProviderMap.get(NTV_CRMApiRequestUtil.PROVIDER_HEADER_KEY);
        }
    }

    public virtual List<DataSource.TableResult> search(DataSource.QueryContext contexts) {
        throw new NTV_BaseException(NOT_IMPLEMENTED_EXCEPTION_MESSAGE);
    }

    public virtual DataSource.TableResult query(DataSource.QueryContext context) {
        String profileUUID;
        List<Map<String, Object>> resultRows;
        try{
            profileUUID = (String)this.getValueFromQueryFilter(context.tableSelection.filter, ACCOUNT_PROFILE_UUID);
            fetchPropositionAndProvider(profileUUID);
            Map<String, Object> response = performHttpCallout(profileUUID, this.proposition, this.provider);
            NTV_JsonUtil.findAndReplaceIsoDates(response);
            resultRows = transform(response, profileUUID);
        } catch (Exception ex){
            resultRows = new List<Map<String, Object>>();
            resultRows.add(new Map<String,Object>{'Error' => ex.getMessage(), PROFILE_UUID => profileUUID, EXTERNAL_ID =>'ERROR'});
        }

        return DataSource.TableResult.get(context, resultRows);
    }

    public virtual List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext upsertContext) {
        throw new NTV_BaseException(NOT_IMPLEMENTED_EXCEPTION_MESSAGE);
    }

    public virtual List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext deleteContext) {
        throw new NTV_BaseException(NOT_IMPLEMENTED_EXCEPTION_MESSAGE);
    }

    /**
    * transformer method for subclasses to build the result Rows in the `query function`
    * @param response deserialized json map
    * @param profileUUID profile UUID
    *
    */
   /* protected virtual List<Map<String,Object>> transform(Map<String, Object> response, String profileUUID) {
        throw new NTV_BaseException(NOT_IMPLEMENTED_EXCEPTION_MESSAGE);
    }*/

    /**
    * endpoint relative path setter for subclasses 
    * @param profileUUID profile UUID
    *
    */
   /* protected virtual String relativeEndpointPath(String profileId) {
        throw new NTV_BaseException(NOT_IMPLEMENTED_EXCEPTION_MESSAGE);
    }*/

    /**
    * call out method for subclasses
    * @param httpRequest 
    *
    */
   /* protected virtual Map<String, Object> performHttpCallout(String profileUUID, final String propositionVal, 
            final String providerVal) {
        throw new NTV_BaseException(NOT_IMPLEMENTED_EXCEPTION_MESSAGE);
    }*/

   /* protected List<Map<String,Object>> postFilterRecords(DataSource.Filter filter, List<Map<String,Object>> rows) {

        if (filter == null) {
            return rows;
        }

        DataSource.FilterType type = filter.type;
        List<Map<String,Object>> retainedRows = new List<Map<String,Object>>();
        if (type == DataSource.FilterType.NOT_) {
            // We expect one Filter in the subfilters.
            DataSource.Filter subfilter = filter.subfilters.get(0);
            for (Map<String,Object> row : rows) {
                if (!evaluate(filter, row)) {
                    retainedRows.add(row);
                }
            }
            return retainedRows;
        } else if (type == DataSource.FilterType.AND_) {
            // For each filter, find all matches; anything that matches ALL filters 
            // is returned.
            retainedRows = rows;
            for (DataSource.Filter subfilter : filter.subfilters) {
                retainedRows = postFilterRecords(subfilter, retainedRows);
            }
            return retainedRows;
        } else if (type == DataSource.FilterType.OR_) {
            // For each filter, find all matches. Anything that matches 
            // at least one filter is returned.
            for (DataSource.Filter subfilter : filter.subfilters) {
                List<Map<String,Object>> 
                    matchedRows = postFilterRecords(subfilter, rows);
                retainedRows.addAll(matchedRows);
            }
            return retainedRows;
        } else {
            // Find all matches for this filter in our collection of records.
            for (Map<String,Object> row : rows) {
                if (evaluate(filter, row)) {
                    retainedRows.add(row);
                }
            }
            return retainedRows;
        }
        return null;
    }

    private Boolean evaluate(DataSource.Filter filter, Map<String,Object> row) {
        
        String columnName = filter.columnName;
        Object expectedValue = filter.columnValue;
        Object foundValue = row.get(columnName);

        return NTV_Evaluator.evaluate(filter.type.name(), expectedValue, foundValue);
    }

    protected Object getValueFromQueryFilter(DataSource.Filter filter, String columnName) {

        Object columnValue;

        if (filter == null) {
            return columnValue;

        }

       if(String.isNotEmpty(filter.columnName) &&
                                filter.columnName.equalsIgnoreCase('ExternalId') &&
                                    filter.type == DataSource.FilterType.EQUALS && 
                                        String.isNotEmpty(String.ValueOf(filter.columnValue))){
                  columnValue = filter.columnValue;
                  return columnValue;
        } 
        if (String.isNotEmpty(filter.columnName) &&
                            filter.columnName.equalsIgnoreCase(columnName) &&
                            filter.type == DataSource.FilterType.EQUALS) {
                columnValue = filter.columnValue;
            return columnValue;
        }
        if (filter.subfilters != null) {
            for (DataSource.Filter subfilter : filter.subfilters) {
                columnValue = getValueFromQueryFilter(subfilter, columnName);
                if (columnValue != null) {
                    break;
                }
            }
        }
        return columnValue;
    }

    protected String extractOriginalExternalId(String orderIdExternalId) {
        String[] orderExternalIdParts = orderIdExternalId.split(DELIMITER);
        return orderExternalIdParts.get(0) + DELIMITER + orderExternalIdParts.get(1);
    }*/
}