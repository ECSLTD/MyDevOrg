public class ControllerBuyPoints {

    public StaticStrings STATICSTRINGS              {get;set;} 
    public PPPayRequest PayRequest                  {get;set;}
    public PPPayResponse PayResponse                {get;set;} 
    public PPResponseEnvelope RespEnvp              {get;set;}

    public String CommonParametersObjName           {get;set;}
    public String APICredentialObjName              {get;set;}
    public String ApprovalType                      {get;set;}
    public string MainMessage                       {get;set;} 
    public string SuccessMessage                    {get;set;}
    public string ErrorLanguage                     {get;set;} 
    public string DetailLevel                       {get;set;}
    public string FeesPayer                         {get;set;} 
    public string SenderEmail                       {get;set;} 
    public string TrackingId                       {get;set;}
    public Decimal Amount                          {get;set;}
    public Boolean IsDisplay                        {get;set;}

    public Boolean FundingTypeEcheck                {get;set;}
    public Boolean FundingTypeBalance               {get;set;}
    public Boolean FundingTypeCreditCard            {get;set;}
    public Boolean isConfirmed                      {get;set;}
    Fulfillment__c fulfil;
    public ControllerBuyPoints() {
        Receivers = new List<PPReceiver>();
        Receivers.add(new PPReceiver());
        STATICSTRINGS = new STATICSTRINGS();
        PaymentType=STATICSTRINGS.SIMPLE_PAYMENT;
        ActionType=STATICSTRINGS.ActionType_PAY;
        ApprovalType = 'Explicit Approval';
        FundingTypeEcheck = false;
        FundingTypeBalance = false;
        FundingTypeCreditCard = false;
        CommonParametersObjName='MycommonParams';
        APICredentialObjName='PaypalSaandbox';

    }
   
   public String ActionType {get;set;}
   public String PaymentType{get;set;}
   public string FeePayer{get;set;}
   
   
 public List<PPReceiver> Receivers{get;set;}
    
    public class StaticStrings{
        public string SIMPLE_PAYMENT    = 'Simple';
        public string PARALLEL_PAYMENT  = 'Parallel';
        public string CHAINED_PAYMENT   = 'Chained';
        
        public string EACHRECEIVER      = 'EACHRECEIVER';
        public string PRIMARYRECEIVER   = 'PRIMARYRECEIVER';
        public string SENDER            = 'SENDER';
        public string SECONDARYONLY     = 'SECONDARYONLY';
        
        public string ActionType_PAY = 'PAY';
        public string ActionType_PAY_PRIMARY = 'PAY_PRIMARY';
        public string ActionType_PAY_CREATE = 'CREATE';
    }
  
    public pagereference Pay(){
        PageReference page = null;
        MainMessage = '';
        
    

        // create request envelope and set the common request parameters
        PPPayRequest request = new PPPayRequest(CommonParametersObjName, SenderEmail); 
     //   system.debug('payRequest.TrackingId : ' + payRequest.TrackingId);
        request.TrackingId = fulfil.Id; //UserInfo.getUserId();//TrackingId;
        
        // set actionType
        request.ActionType =ActionType;

        // set success and cancel urls
        String host = ApexPages.currentPage().getHeaders().get('Host');
       // request.CancelUrl = 'https://' + host + '/PayApiTest?MainMessage=cancel';
        request.CancelUrl = 'https://' + host + fulfil.Contact__c;
       // request.ReturnUrl = 'https://' + host + '/apex/PayDetailTest?payKey=${payKey}';
       request.ReturnUrl = 'https://' + host + '/luckywinner/MyProfilePage?payKey=${payKey}';
       
        // set a note associated with the payment        
        request.Memo = 'PayApiTest';  
        // set receiver info in the request
        List<PPReceiver> receiverList = new List<PPReceiver>();

      PPReceiver rec = new PPReceiver();
           rec.Email ='seller_1336254598_biz@gmail.com';
           rec.InvoiceId ='';
           rec.PaymentType ='';
           rec.Amount=Amount;
           receiverList.add(rec);
        
        request.receiverList = receiverList;
        // set FeesPayer
        request.FeesPayer =FeesPayer;
        if (FundingTypeEcheck) {
            PPFundingTypeInfo info = new PPFundingTypeInfo();
            info.FundingType = 'ECHECK';
            request.FundingTypeList.add(info);
        }
        if (FundingTypeBalance) {
            PPFundingTypeInfo info = new PPFundingTypeInfo();
            info.FundingType = 'BALANCE';
            request.FundingTypeList.add(info);
        }
        
        if (FundingTypeCreditCard) {
            PPFundingTypeInfo info = new PPFundingTypeInfo();
            info.FundingType = 'CREDITCARD';
            request.FundingTypeList.add(info);
        }
        
        IsDisplay = false;
       
         // create the Adaptive Toolkit object instance w/ API Credentials
        PPAdaptiveToolkit toolkit = new PPAdaptiveToolkit(APICredentialObjName);
       
        try {
            System.Debug(Logginglevel.INFO, '==>Request' + request);
            PayResponse = toolkit.Pay(request);
            System.debug('PayResponse : ' +PayResponse);          
            IsDisplay = true;
            RespEnvp = PayResponse.ResponseEnvelope;
             System.debug('PayResponse.PaymentExecStatus.equalsIgnoreCase(Created): ' + PayResponse.PaymentExecStatus.equalsIgnoreCase('Created'));  
            if( PayResponse.PaymentExecStatus.equalsIgnoreCase('Created') ) {
                //Page = toolkit.commitpayment(PayResponse.payKey);
                updatefulfil(PayResponse);
                SuccessMessage = 'Payment Created - <a target="_self" href=' + toolkit.BaseAPIProfile.getPayPalLoginPage() 
                        +  '_ap-payment&paykey=' + PayResponse.payKey + '>click to approve</a> payKey - ' + PayResponse.payKey; 
               System.Debug('toolkit.BaseAPIProfile.getPayPalLoginPage() SuccessMessage  : '+ SuccessMessage );
            } else if( PayResponse.PaymentExecStatus.equalsIgnoreCase('Completed') ) {
                //Page = new pagereference(request.returnUrl); 
                 updatefulfil(PayResponse);
                SuccessMessage = 'Payment Completed - payKey - ' + PayResponse.payKey; 
            } else {
                 updatefulfil(PayResponse);
                IsDisplay = true;
                RespEnvp = PayResponse.getResponseEnvelope();
                MainMessage = 'Payment Execution Status returned from server is - ' + PayResponse.PaymentExecStatus;
            }
            
        }catch(PPFaultMessageException ex) {
            System.debug('PPFaultMessageException =>' + ex);
            IsDisplay = true;
            RespEnvp = ex.ResponseEnvelope;
            List<PPErrorData> errList = ex.ErrorList;
            for( PPErrorData err: errList ){
                MainMessage += err.ErrorId + ' : ' + err.Message + '<br>';
            }
             updatefulfil(PayResponse);
       }catch(System.Exception e){
            System.debug('System.Exception =>' + e);
            MainMessage = e.getMessage();
       } 
       System.debug('return page : ' + page);
       isConfirmed =true;
       return page;
    }
   public void Createfulfil(){
               //
         User userDetails  = new User();
         userDetails = [Select u.ContactId From User u where id ='005G0000002AV7C' limit 1];
       // userDetails = [Select u.ContactId From User u where id =:UserInfo.getUserId() limit 1];
        //
       system.debug('userDetails >> : ' + userDetails.ContactId);
       //Create fulfil to store payment transaction information.
       if(fulfil==null){
        fulfil = new Fulfillment__c(
                Name ='BuyPointsWeb',
                Contact__c = userDetails.ContactId
        );
                upsert fulfil;
       }

   }
   
   private void updatefulfil(PPPayResponse PayResponse ){
        
        fulfil.PaymentExecStatus__c =PayResponse.PaymentExecStatus;
        fulfil.Amount__c =Amount;
        fulfil.Pay_Key__c=PayResponse.payKey; 
        //fulfil.re
        upsert fulfil;
   }
   
   
}