global class TestSAP1
{
   // @future(callout=true)
    public static void SampleOrder()
    {   
 
       /*FqComSfdcSampleorder.Header_element Header = new FqComSfdcSampleorder.Header_element();
        Header.Ship_To_Name= 'test';
        FqComSfdcSampleorder.Item_element Item = new  FqComSfdcSampleorder.Item_element();
        Item.Material_Num='';
        FqComSfdcSampleorder.Text_element Text = new FqComSfdcSampleorder.Text_element();
        Text.Subject='test';
        List<FqComSfdcSampleorder.Item_element> items = new List<FqComSfdcSampleorder.Item_element>();
        items.add(item);
        FqComSfdcSampleorder.SI_Async_SampleOrder_OutPort stub = new FqComSfdcSampleorder.SI_Async_SampleOrder_OutPort();
          stub.inputHttpHeaders_x = new Map<String, String>();
         String username = 'PIAPPLSFDC';
         String password = 'initpass1';
  
         Blob headerValue = Blob.valueOf(username + ':' + password);
         String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        
          stub.inputHttpHeaders_x.put('Authorization','authorizationHeader');
          stub.timeout_x=120000;
      //  stub.inputHttpHeaders_x.put('UserdName', UserId );
      //  stub.inputHttpHeaders_x.put('Password',Password );
         stub.SI_Async_SampleOrder_Out(Header,items,Text);
         system.debug('stub : ' + stub);
        // System.debug('test ' + stub.SI_Async_SampleOrder_Out(Header,items,Text));
            */   
  SampleComSfdcSampleorder.Header_element Header = new SampleComSfdcSampleorder.Header_element();
        Header.Ship_To_Name= 'test';
        SampleComSfdcSampleorder.Item_element Item = new  SampleComSfdcSampleorder.Item_element();
        Item.Material_Num='';
        SampleComSfdcSampleorder.Text_element Text = new SampleComSfdcSampleorder.Text_element();
        Text.Subject='test';
        List<SampleComSfdcSampleorder.Item_element> items = new List<SampleComSfdcSampleorder.Item_element>();
        items.add(item);
        SampleComSfdcSampleorder.SI_Async_SampleOrder_OutPort stub1 = new SampleComSfdcSampleorder.SI_Async_SampleOrder_OutPort();
       
         String username = 'PIAPPLSFDC';
         String password = 'initpass1';
         stub1.inputHttpHeaders_x= new map<string,string>();
        string cred = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password));
         stub1.inputHttpHeaders_x.put('User id ',username );
         stub1.inputHttpHeaders_x.put('Password ',password );
       //  stub1.inputHttpHeaders_x.put('Authorization',cred);
         stub1.timeout_x = 120000;
        stub1.SI_Async_SampleOrder_Out(Header,items,Text);
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
    }
}