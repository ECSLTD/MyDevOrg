global class BatchImplementation implements Database.Batchable<sObject>{
   
   String myFilter ='a';
   //String qs = 'select Id,Name,Product_Group__c from Product2 where Name Like \'%'+filterby+'%\'  order by ' + sortFullExp;
   String query ='select name,Id from Account where Name like \'%'+String.ValueOf(0)+'%\'';
   List<Account> acounts;
	global Database.querylocator start(Database.BatchableContext BC){
	            return Database.getQueryLocator(query);}	
	            
	/*  global Iterable<Account> start(Database.BatchableContext info){ 
	  	accounts = ObjectSerialization();
       return accounts; 
   }  */
	            
	 global void execute(Database.BatchableContext BC, List<sObject> scope){
	    List<Account> accns = new List<Account>();
	
	  /* for(sObject s : scope){Account a = (Account)s;
	        if(a.OwnerId==fromUserId){
	            a.OwnerId=toUserId;
	            accns.add(a);
	            }
	        }*/
	//ObjectSerialization obs = new ObjectSerialization();
	system.debug('scope >>> ' + scope);
	ObjectSerialization.TestGovLimitStatements(scope);
	//update accns;	
	    
	}
		
	global void finish(Database.BatchableContext BC){
	/*	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		
		mail.setToAddresses(new String[] {email});
		mail.setReplyTo('batch@acme.com');
		mail.setSenderDisplayName('Batch Processing');
		mail.setSubject('Batch Process Completed');
		mail.setPlainTextBody('Batch Process has completed');
		
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
		}
}