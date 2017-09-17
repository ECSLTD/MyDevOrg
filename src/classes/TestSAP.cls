global class TestSAP
{
    @future(callout=true)
    public static void SampleOrder()
    {   
 
       /* FqComSfdcSampleorder.Header_element Header = new FqComSfdcSampleorder.Header_element();
        Header.Ship_To_Name= 'test';
        FqComSfdcSampleorder.Item_element Item = new  FqComSfdcSampleorder.Item_element();
        Item.Material_Num='';
        FqComSfdcSampleorder.Text_element Text = new FqComSfdcSampleorder.Text_element();
        Text.Subject='test';
        List<FqComSfdcSampleorder.Item_element> items = new List<FqComSfdcSampleorder.Item_element>();
        items.add(item);
        FqComSfdcSampleorder.SI_Async_SampleOrder_OutPort stub = new FqComSfdcSampleorder.SI_Async_SampleOrder_OutPort();
          stub.inputHttpHeaders_x = new Map<String, String>();
          String UserId = 'PIAPPLSFDC';
          String Password = 'initpass1';
         // String encodedAuthDetails = EncodingUtil.base64Encode(Blob.valueOf(UserId+':'+Password));
          //stub.inputHttpHeaders_x.put('Authorization','Basic ' + encodedAuthDetails );
        stub.inputHttpHeaders_x.put('UserId', UserId );
        stub.inputHttpHeaders_x.put('Password',Password );
           //stub.SI_Async_SampleOrder_Out(Header,items,Text);
         System.debug(stub.SI_Async_SampleOrder_Out(Header,items,Text));*/
         
         
     HttpRequest req = new HttpRequest();
     req.setEndpoint('http://sfpid.firstquality.com:80/XISOAPAdapter/MessageServlet?channel=:BS_Salesforce:CC_Salesforce_SOAP_Sender&amp;Sender.Service=BS_Salesforce&amp;Interface=http%3A%2F%2Ffirstquality.com%2FSFDC%2FSampleOrder%5ESI_Async_SampleOrder_Out');
     req.setMethod('POST');
     
     // Specify the required user name and password to access the endpoint
     // As well as the header and header information
 
     String username = 'PIAPPLSFDC';
     String password = 'initpass1';
  
     Blob headerValue = Blob.valueOf(username + ':' + password);
     String authorizationHeader = 'BASIC ' +
     EncodingUtil.base64Encode(headerValue);
     req.setHeader('Authorization', authorizationHeader);
     string strSetbody ='<sam:MT_SampleOrder_Out><Header><Ship_To_Name>Test</Ship_To_Name>'
                         + '<Ship_To_Name2>?</Ship_To_Name2></Header>'           
                         +' <Item><Material_Num>Test</Material_Num></Item>'
                         + '<Text><Subject>Test</Subject></Text></sam:MT_SampleOrder_Out> ';
                         
     req.setbody(strSetbody);  
     req.setTimeout(120000);                   
     // Create a new http object to send the request object
     // A response object is generated as a result of the request  
     system.debug('req : ' + req);
     Http http = new Http();
     http.send(req);

//     HTTPResponse res = http.send(req);
    // System.debug(res.getBody());
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
    }
}