public with sharing class CustomMerchandiseFilter {

    public Decimal myFilter { get  ; set ; }
    private List<Merchandise__c> merchandises;

  
   public List<Merchandise__c> CustomMerchandiseFilterTest() {
   
           merchandises = [select name,Price__c from Merchandise__c where Price__c < :myFilter];
           return merchandises ;
      }

      public List<Merchandise__c> getMerchandises() {
            return CustomMerchandiseFilterTest();
      }
    
    public void setmyFilter ( )
    {
        this.myFilter = myFilter;
    } 
    public Decimal getmyFilter ( )
    {
        return      this.myFilter;
    } 
    
}