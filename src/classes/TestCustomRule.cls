@isTest
private class TestCustomRule {

  public  static testMethod void testFilterPosi() {
        // TO DO: implement unit test
    decimal getmyFilterTest;
    List<Merchandise__c> merchandises;
    CustomMerchandiseFilter cmf = new CustomMerchandiseFilter();
    cmf.myFilter=20.00;
    cmf.setmyFilter();
    merchandises = cmf.getMerchandises();
    System.assert(merchandises .size() > 0);
    getmyFilterTest=cmf.getmyFilter();

      }  
      public  static testMethod void testFilterNeg() {
        // TO DO: implement unit test
    decimal getmyFilterTest;
    List<Merchandise__c> merchandises;
    CustomMerchandiseFilter cmf = new CustomMerchandiseFilter();
    cmf.myFilter= -1.00;
    cmf.setmyFilter();
    merchandises = cmf.getMerchandises();
    System.assert(merchandises .size() == 0,merchandises.size());
    getmyFilterTest=cmf.getmyFilter();

      } 
        public  static testMethod void testFilterZero() {
        // TO DO: implement unit test
    decimal getmyFilterTest;
    List<Merchandise__c> merchandises;
    CustomMerchandiseFilter cmf = new CustomMerchandiseFilter();
    cmf.myFilter= 0.00;
    cmf.setmyFilter();
    merchandises = cmf.getMerchandises();
    System.assert(merchandises .size() == 0,merchandises.size());
    getmyFilterTest=cmf.getmyFilter();

      } 

}