public with sharing class CustomAccount {

    public string myFilter { get  ; set ; }
    private List<Account> accounts;

  
   public List<Account> CustomAccountFilterTest() {
   
           system.debug('myFilter ' + myFilter );
          accounts= [select name,Id from Account where name like   :myFilter +'%'  ];
           return accounts;
      }

      public List<Account> getAccounts() {
            return CustomAccountFilterTest();
      }
    
    public void setmyFilter ( )
    {
        this.myFilter = myFilter;
    } 
    public string getmyFilter ( )
    {
        system.debug('this.myFilter' + this.myFilter);
        return this.myFilter;
    } 
    
}