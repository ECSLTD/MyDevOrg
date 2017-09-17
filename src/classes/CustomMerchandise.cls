public with sharing class CustomMerchandise {

      private final Merchandise__c merchandises;
  
   public CustomMerchandise() {
            merchandises = [select name from Merchandise__c where Price__c = 30.99 ];
            
      }

      public Merchandise__c getMerchandises() {
            return merchandises ;
      }

}