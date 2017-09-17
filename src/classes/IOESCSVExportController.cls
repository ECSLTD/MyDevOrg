public with sharing class IOESCSVExportController {

     public list<Account> transactionList=new  List<Account>();
     public list<Account> alltransList=new  List<Account>();
     
     public list<Account> arryTransactions {get;set;}
     public list<string> listId=new list<string>();
     ApexPages.StandardSetController testc;
     PageReference pgReturnPage;
     integer i=0;
   
     public IOESCSVExportController (ApexPages.StandardSetController cntlr){
         testc=cntlr;
        arryTransactions = cntlr.getSelected();
        transactionList=[select Name, Id from Account where Id IN:arryTransactions ];
       
    }
        public void updateAllTransactions()
    {
        system.debug('-------updateAllTransactions--------'); 
         system.debug('test');
         
         String aId = apexpages.currentpage().getParameters().get('fcf'); 
       pgReturnPage = new PageReference('/001?fcf='+aId);
       pgReturnPage.setRedirect(true);

       // testc.cancel();
        
    }
    
 
    
}