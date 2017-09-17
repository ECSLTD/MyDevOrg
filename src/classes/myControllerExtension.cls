public class myControllerExtension {


    private final Account account;

    public myControllerExtension(ApexPages.StandardController stdController) {
        this.account = (Account)stdController.getRecord();
       
    }

    

     public pagereference mysave()
    {
         system.debug('Account.Name: ' + Account.Name);

       //account.AccountNumber='TestAccount123';  
       account.Name=account.Name+ ' ' + account.AccountNumber;
     
      return null;
    }
   
   public String getGreeting() {
   	     
   	     string strhello ='Hello !!!';
   	     if(account != null && account.name != '')
   	     strhello = 'Hello ' + account.name + ' (' + account.id + ')';
   	     
        return strhello;
    }
    
    
    
}