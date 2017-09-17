public class PaymentDetails {

    public PPPaymentDetailsRequest PaymentDetailRequest    {get;set;}
    public PPPaymentDetailsResponse PaymentDetailResponse   {get;set;} 
    public PPResponseEnvelope RespEnvp                      {get;set;}

    public string MainMessage                               {get;set;} 
    public String payKey                                    {get;set;}
    public String transactionId                             {get;set;}
    public String trackingId                                {get;set;}
    
    public String CommonParametersObjName                   {get;set;}
    public String APICredentialObjName                      {get;set;}
    
    public PPPaymentInformation PaymentInfo                 {get;set;}
    public List<PPFundingTypeInfo> FundingTypeInfo          {get;set;}
    
    public List<PaymentDetailInfo> outParameterList         {get;set;}
       
    public Boolean IsResponse                        {get;set;}
    public Boolean IsErr                                    {get;set;}
    public Fulfillment__c fulfil;
    public PaymentDetails(){
        
        PaymentDetailResponse = new PPPaymentDetailsResponse();
        outParameterList = new List<PaymentDetailInfo>();
        FundingTypeInfo = new List<PPFundingTypeInfo>();    
        fulfil = new Fulfillment__c();    
    }

    public boolean SavePaymentDetail(string strPayKey){

        MainMessage = '';
        IsErr = false;
        IsResponse = false ;
        CommonParametersObjName='MycommonParams';
        APICredentialObjName='PaypalSaandbox';
        PaymentDetailRequest = new PPPaymentDetailsRequest(CommonParametersObjName);
        PaymentDetailRequest.PayKey = strPayKey;
        PaymentDetailRequest.TrackingId = trackingId;
        PaymentDetailRequest.TransactionId = transactionId;
        // create the Adaptive Toolkit object instance w/ API Credentials
        PPAdaptiveToolkit toolkit = new PPAdaptiveToolkit(APICredentialObjName);
        try {
            outParameterList.clear();
            System.Debug(Logginglevel.INFO, '==>Request' + PaymentDetailRequest);
            PaymentDetailResponse = toolkit.paymentDetails(PaymentDetailRequest );
            System.Debug(Logginglevel.INFO, '==>response' + PaymentDetailResponse);
            RespEnvp = PaymentDetailResponse.getResponseEnvelope();
            System.debug('===========>Ack' + RespEnvp);
            
            //FundingTypeInfo.clear();
            FundingTypeInfo = PaymentDetailResponse.FundingtypeList;
            system.debug(' PaymentDetailResponse.PaymentInformationList.size ' + PaymentDetailResponse.PaymentInformationList.size());
            fulfil =[Select f.TransactionStatus__c, f.TransactionId__c, f.TrackingId__c, f.Telephone_Extension_Code__c, 
                            f.SystemModstamp, f.Status__c, f.Sender_Transaction_Status__c, f.Sender_TransactionID__c,
                            f.Sender_Email__c, f.Reverse_All_Parallel_Payments_On_Error__c, f.Return_Url__c, 
                            f.Response_Timestamp__c, f.Response_Envelope__c, f.ResponseEnvelope_CorrelationId__c, 
                            f.ResponseEnvelope_Build__c, f.ResponseEnvelope_Ack__c, f.ResponseEnvelopeTimestamp__c, 
                            f.Refunded_Amount__c, f.Receiver_Email__c, f.Primary__c, f.Preapproval_Key__c, f.Phone_Number__c, 
                            f.Pending_Refund__c, f.Payment_Type__c, f.Payment_SubType__c, f.PaymentExecStatus__c, 
                            f.Pay_Key__c, f.Name, f.Memo__c, f.Log_Default_Shipping_Address__c, f.LastModifiedDate, 
                            f.LastModifiedById, f.LastActivityDate, f.IsDeleted, f.InvoiceId__c, f.Id, f.Fees_Payer__c, 
                            f.Currency_Code__c, f.CreatedDate, f.CreatedById, f.Country_Code__c, f.Correlation_Id__c, 
                            f.Contact__c, f.Cancel_Url__c, f.Build__c, f.Amount__c, f.Action_Type__c 
                            From Fulfillment__c f
                            where f.Pay_Key__c=:strPayKey];
        system.debug('get fulfil' + fulfil);
       if(fulfil!=null)
       {
       	   system.debug('get PaymentDetailResponse : ' + PaymentDetailResponse);
             fulfil.Cancel_Url__c=PaymentDetailResponse.CancelUrl;
             fulfil.Currency_Code__c=PaymentDetailResponse.CurrencyCode;
             fulfil.Memo__c=PaymentDetailResponse.Memo;
             fulfil.Return_Url__c=PaymentDetailResponse.ReturnUrl;
             fulfil.Sender_Email__c = PaymentDetailResponse.SenderEmail;
             fulfil.Status__c=PaymentDetailResponse.Status;
             fulfil.Action_Type__c=PaymentDetailResponse.ActionType;
             fulfil.Fees_Payer__c=PaymentDetailResponse.FeesPayer;
             fulfil.Reverse_All_Parallel_Payments_On_Error__c= String.valueOf(PaymentDetailResponse.ReverseAllParallelPaymentsOnError);
           //  fulfil.Preapproval_Key__c=PaymentDetailResponse.PreapprovalKey;
           //  fulfil.Log_Default_Shipping_Address__c = PaymentDetailResponse.LogDefaultShippingAddress;
             fulfil.ResponseEnvelope_Ack__c=RespEnvp.Ack;
             fulfil.Correlation_Id__c =RespEnvp.CorrelationId;
             fulfil.Build__c=RespEnvp.Build;
             fulfil.Response_Timestamp__c=RespEnvp.StringTimestamp;

            system.debug('get PaymentDetailResponse.PaymentInformationList : ' + PaymentDetailResponse.PaymentInformationList);
            for(Integer index=0;index < PaymentDetailResponse.PaymentInformationList.size();index++){
            	PaymentInfo = PaymentDetailResponse.PaymentInformationList.get(index);
                fulfil.TransactionId__c =  PaymentInfo.TransactionId;
                fulfil.TransactionStatus__c = PaymentInfo.TransactionStatus;
                fulfil.Refunded_Amount__c =  PaymentInfo.RefundedAmount;
                fulfil.Pending_Refund__c = PaymentInfo.PendingRefund;
                fulfil.Receiver_Email__c = PaymentInfo.Receiver.Email;
                fulfil.Amount__c = PaymentInfo.Receiver.Amount;
                fulfil.Payment_Type__c = PaymentInfo.Receiver.PaymentType;
                fulfil.Primary__c = PaymentInfo.Receiver.Primary;
                //fulfil.InvoiceId__c = PaymentInfo.Receiver.InvoiceId;
                fulfil.Sender_TransactionID__c = PaymentInfo.senderTransactionID;
                fulfil.Sender_Transaction_Status__c = PaymentInfo.senderTransactionStatus;
            }
            system.debug('upsert fulfil' + fulfil);
            update fulfil;
            IsResponse = true;
             
            
        }
                  
        }catch (PPFaultMessageException ex) {
            System.debug('PPFaultMessageException =>' + ex);
            RespEnvp = ex.ResponseEnvelope;
            IsErr = true;
            List<PPErrorData> errlist = ex.ErrorList;
            for( PPErrorData err: errList ){
                   MainMessage += err.ErrorId + ' : ' + err.Message + '<br>';
            }
        }catch(System.Exception e){
            MainMessage = e.getmessage();
        }    
        return IsResponse;
    }
}