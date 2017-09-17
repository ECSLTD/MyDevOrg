trigger CalculatePoints on Fulfillment__c (after update,before update) {
	

   if(trigger.isBefore && trigger.isUpdate)
   {

	Set<String> conIds = new  Set<String>(); 
	system.debug('Trigger.newMap.values()' + trigger.newMap.values());
     for(Fulfillment__c  fulfil : trigger.newMap.values()){
         if(fulfil.Contact__c != null){
              conIds.add(fulfil.Contact__c);
          }
     }
   
    System.debug('contactIds' + conIds);
    Double intPoints;
    List<Fulfillment__c> updatedfulList = new List<Fulfillment__c>();
    List<Contact> contactList = new List<Contact>();
   
    Map<String,cashpoint__c> cpsList = new Map<String,cashpoint__c>();
    cashpoint__c cps = new cashpoint__c(); 
    Contact con = new Contact();
                  
   /*  FulListWithContact =[Select f.TransactionStatus__c, f.TransactionId__c, f.TrackingId__c, f.Status__c, 
                                 f.Sender_Transaction_Status__c, f.Sender_TransactionID__c, f.Sender_Email__c, 
                                 f.Return_Url__c, f.ResponseEnvelope_Ack__c, f.Refunded_Amount__c, f.Receiver_Email__c,
                                 f.Primary__c, f.Preapproval_Key__c, f.Phone_Number__c, f.Pending_Refund__c, 
                                 f.Pay_Key__c, f.Name, f.InvoiceId__c, f.Id, f.Currency_Code__c, f.CreatedDate, 
                                 f.Country_Code__c, f.Contact__r.Points__c, f.Contact__r.Id, f.Contact__c, 
                                 f.Amount__c,f.Process__c, f.Action_Type__c,f.Payment_Type__c From Fulfillment__c f
                                 where Id IN :trigger.newMap.keySet()]; */
                                 
     Map<Id,Contact> contactMap = new Map<Id,Contact>(
                                        [Select c.Points__c, c.Points_Used__c 
                                          From Contact c 
                                          where Id IN: conIds]);
                                          
    System.debug('contactMap' + contactMap);
                       
     for(cashpoint__c cpoint : [select Name,Points__c from cashpoint__c]){
     	
     	cpsList.put(cpoint.Name,cpoint);
     }
   
      
     for(Fulfillment__c  fulfil : trigger.newMap.values()){
         if((fulfil.TransactionStatus__c == 'COMPLETED')
          && (fulfil.Status__c == 'COMPLETED') 
          && (fulfil.Sender_Transaction_Status__c == 'COMPLETED') 
          && (fulfil.Amount__c > 0) 
          &&  (fulfil.Receiver_Email__c == 'seller_1336254598_biz@gmail.com')
          && (fulfil.Payment_Type__c=='SERVICE')
          && (fulfil.Process__c!='Done')  
          && (fulfil.Action_Type__c=='PAY' ))
            {
            	if(fulfil.Currency_Code__c != null || fulfil.Currency_Code__c !='')
            	{
           		system.debug('calc fulfil' + fulfil);
 
                   cps =cpsList.get(fulfil.Currency_Code__c);
                   con=contactMap.get(fulfil.Contact__c);
                      system.debug( '  con.Points__c >> '+   con.Points__c);
                   if(con != null && cps !=null)
                   {
	                   system.debug('cps' + cps);
	                   system.debug('cps.Points__c * fulfil.Amount__c>> '+ cps.Points__c * fulfil.Amount__c);
	                   //add points to the contact 
	                   double conPoints= cps.Points__c * fulfil.Amount__c;
	                   double addPoints= con.Points__c + conPoints ;
	                   system.debug( '  con.Points__c >> '+   con.Points__c);
	                   con.Points__c =addPoints;
	                   system.debug( '  con.Points__c >> '+   con.Points__c);
	                   contactList.add(con);
	                   fulfil.Process__c='Done';
                   }
                   
            	}
              
            }
     }
     system.debug('updatedfulList >>'+ contactList);
     update contactList;

     system.debug('After update updatedfulList >>'+ contactList);
  }
}