trigger BulkProduct2 on Product2 (before update,before insert) {

   /* Map<Id,Product2>  Product2List = new Map<Id,Product2>([select Id,Product_Image__r.Image_url__c,Image_url__c from Product2
                                      where Id IN :Trigger.newMap.KeySet()]);
   Map<Id,Product_Image__c>  ProductImageList = new Map<Id,Product_Image__c>([select Id,Image_url__c from Product_Image__c]);
   system.debug( 'Product2List : ' + Product2List);
    Product2 oldP2 = new Product2();
    for (Product2  p : Trigger.newMap.values()) {
    	 system.debug( 'values : ' +Trigger.newMap.values());
         system.debug( 'old : ' +Trigger.oldMap.get(p.Id).Product_Image__c);
         system.debug( 'new : ' +Trigger.newMap.get(p.Id).Product_Image__c);
         oldP2 = Trigger.newMap.get(p.Id);
        if(Trigger.newMap.get(p.Id).Product_Image__c !=Trigger.oldMap.get(p.Id).Product_Image__c)
        {
        	system.debug( 'update value : ' + ProductImageList.get(p.Id).Image_url__c);
            p.Image_url__c = Product2List.get(p.Id).Image_url__c;
          // updateProduct2.add(p);
        
        }
   }*/
}