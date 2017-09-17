public with sharing class CustomMerchandiseList {

      private final List<Merchandise__c> merchandises;
      public String myFilter { get; set; }

   public CustomMerchandiseList() {
           merchandises = [select name,Price__c from Merchandise__c where Price__c < 30.99 ];
           
      }

      public List<Merchandise__c> getMerchandises() {
            return merchandises ;
      }

}