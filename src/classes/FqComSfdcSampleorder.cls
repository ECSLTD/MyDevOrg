public class FqComSfdcSampleorder {
    public class Text_element {
        public String Subject;
        public String Requested_By;
        public String Created_By;
        public String Special_Notes;
        private String[] Subject_type_info = new String[]{'Subject','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] Requested_By_type_info = new String[]{'Requested_By','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] Created_By_type_info = new String[]{'Created_By','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] Special_Notes_type_info = new String[]{'Special_Notes','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://firstquality.com/SFDC/SampleOrder','false','false'};
        private String[] field_order_type_info = new String[]{'Subject','Requested_By','Created_By','Special_Notes'};
    }
    public class Header_element {
        public String Ship_To_Name;
        public String Ship_To_Name2;
        public String Ship_To_Street;
        public String Ship_To_City;
        public String Ship_To_Region;
        public String Ship_To_PostalCode;
        public String Ship_To_Country;
        public String Ship_To_TelNo;
        public String Ship_To_FaxNo;
        public String Customer_PONum;
        public String Customer_PODate;
        public String Req_DelDate;
        public String SalesArea_Identifier;
        private String[] Ship_To_Name_type_info = new String[]{'Ship_To_Name','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] Ship_To_Name2_type_info = new String[]{'Ship_To_Name2','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] Ship_To_Street_type_info = new String[]{'Ship_To_Street','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] Ship_To_City_type_info = new String[]{'Ship_To_City','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] Ship_To_Region_type_info = new String[]{'Ship_To_Region','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] Ship_To_PostalCode_type_info = new String[]{'Ship_To_PostalCode','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] Ship_To_Country_type_info = new String[]{'Ship_To_Country','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] Ship_To_TelNo_type_info = new String[]{'Ship_To_TelNo','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] Ship_To_FaxNo_type_info = new String[]{'Ship_To_FaxNo','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] Customer_PONum_type_info = new String[]{'Customer_PONum','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] Customer_PODate_type_info = new String[]{'Customer_PODate','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] Req_DelDate_type_info = new String[]{'Req_DelDate','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] SalesArea_Identifier_type_info = new String[]{'SalesArea_Identifier','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://firstquality.com/SFDC/SampleOrder','false','false'};
        private String[] field_order_type_info = new String[]{'Ship_To_Name','Ship_To_Name2','Ship_To_Street','Ship_To_City','Ship_To_Region','Ship_To_PostalCode','Ship_To_Country','Ship_To_TelNo','Ship_To_FaxNo','Customer_PONum','Customer_PODate','Req_DelDate','SalesArea_Identifier'};
    }
    public class Item_element {
        public String Material_Num;
        public String Order_Qty;
        public String Sales_UOM;
        private String[] Material_Num_type_info = new String[]{'Material_Num','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] Order_Qty_type_info = new String[]{'Order_Qty','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] Sales_UOM_type_info = new String[]{'Sales_UOM','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://firstquality.com/SFDC/SampleOrder','false','false'};
        private String[] field_order_type_info = new String[]{'Material_Num','Order_Qty','Sales_UOM'};
    }
    public class DT_SampleOrder_Out {
        public FqComSfdcSampleorder.Header_element Header;
        public FqComSfdcSampleorder.Item_element[] Item;
        public FqComSfdcSampleorder.Text_element Text;
        private String[] Header_type_info = new String[]{'Header','http://firstquality.com/SFDC/SampleOrder',null,'1','1','false'};
        private String[] Item_type_info = new String[]{'Item','http://firstquality.com/SFDC/SampleOrder',null,'0','-1','false'};
        private String[] Text_type_info = new String[]{'Text','http://firstquality.com/SFDC/SampleOrder',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://firstquality.com/SFDC/SampleOrder','false','false'};
        private String[] field_order_type_info = new String[]{'Header','Item','Text'};
    }
    public class SI_Async_SampleOrder_OutPort {
        public String endpoint_x = 'http://sfpid.firstquality.com:80/XISOAPAdapter/MessageServlet?channel=:BS_Salesforce:CC_Salesforce_SOAP_Sender&Sender.Service=BS_Salesforce&Interface=http%3A%2F%2Ffirstquality.com%2FSFDC%2FSampleOrder%5ESI_Async_SampleOrder_Out';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://firstquality.com/SFDC/SampleOrder', 'FqComSfdcSampleorder'};
        public void SI_Async_SampleOrder_Out(FqComSfdcSampleorder.Header_element Header,FqComSfdcSampleorder.Item_element[] Item,FqComSfdcSampleorder.Text_element Text) {
            FqComSfdcSampleorder.DT_SampleOrder_Out request_x = new FqComSfdcSampleorder.DT_SampleOrder_Out();
            request_x.Header = Header;
            request_x.Item = Item;
            request_x.Text = Text;
            FqComSfdcSampleorder.DT_SampleOrder_Out response_x;
            Map<String, FqComSfdcSampleorder.DT_SampleOrder_Out> response_map_x = new Map<String, FqComSfdcSampleorder.DT_SampleOrder_Out>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://sap.com/xi/WebService/soap1.1',
              'http://firstquality.com/SFDC/SampleOrder',
              'MT_SampleOrder_Out',
              '',
              '',
              'FqComSfdcSampleorder.DT_SampleOrder_Out'}
            );
           // response_x = response_map_x.get('response_x');
          //  return response_x;
        }
    }
}