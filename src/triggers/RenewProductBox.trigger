trigger RenewProductBox on Product_Box__c (after update) {

    Set<Id> pd2List = new Set<Id>();
    Map<ID,Product_Box__c> pbMap = new Map<ID,Product_Box__c>(
                                    [Select Name,IsActive__c,Status__c,p.Products_DisplayList__r.Box_Name__c, p.Products_DisplayList__r.Ticket_Price__c,
                                    p.Products_DisplayList__r.Status__c, p.Products_DisplayList__r.IsActive__c,
                                    p.Products_DisplayList__c From Product_Box__c p where p.ID in :Trigger.newMap.keySet()]);
                                    
	 for(Product_Box__c  pdList : pbMap.values()){
	      if(pdList.Products_DisplayList__r !=null){
	      	pd2List.add(pdList.Products_DisplayList__r.Id);
	      }
	 }
	 
    Map<ID,Products_DisplayList__c> productList = new Map<ID,Products_DisplayList__c>(
                                     [Select p.Product2Id__r.Products_Box3_Ticket_Value__c, 
                                     p.Product2Id__r.Products_Box2_Ticket_Value__c, p.Product2Id__r.Products_Box1_Ticket_Value__c,
                                     p.Product2Id__r.Products_Box3__c, p.Product2Id__r.Products_Box2__c, 
                                     p.Product2Id__r.Products_Box1__c, p.Product2Id__r.IsActive, p.Product_Price__c,
                                     p.Product2Id__c From Products_DisplayList__c p where Id in :pd2List]);
                                     
      List<Product_Box__c>  ProductBoxList = new List<Product_Box__c>(); 
                                        
     for(Product_Box__c  pdList : pbMap.values()){
     	system.debug('for pdList : '+ pdList);
     	  system.debug('for pdList.Products_DisplayList__r  : '+ pdList.Products_DisplayList__r );
     	   system.debug('for productList.get  : ' + productList.get(pdList.Products_DisplayList__r.Id));
         if(pdList.Products_DisplayList__r != null){
              
            if( pdList.Name=='Box1' && (pdList.Products_DisplayList__r.IsActive__c = true) && (pdList.IsActive__c <> true && pdList.Status__c =='Close')){
            	
                ProductBoxList.add(addProductToDisplayList.AddBoxToDisplyList(productList.get(pdList.Products_DisplayList__r.Id),'Box1'));
            }
            if( pdList.Name=='Box2' && (pdList.Products_DisplayList__r.IsActive__c = true) && (pdList.IsActive__c <> true && pdList.Status__c =='Close')){
                ProductBoxList.add(addProductToDisplayList.AddBoxToDisplyList(productList.get(pdList.Products_DisplayList__r.Id),'Box2'));
            }
            if( pdList.Name=='Box3' && (pdList.Products_DisplayList__r.IsActive__c = true) && (pdList.IsActive__c <> true && pdList.Status__c =='Close')){
                 ProductBoxList.add(addProductToDisplayList.AddBoxToDisplyList(productList.get(pdList.Products_DisplayList__r.Id),'Box3'));
            }
         }
     }
 
    system.debug('Trigger.newMap.values() : '+ Trigger.newMap.values());
    system.debug('pd2List : '+ pd2List);
   system.debug('ProductBoxList : '+ ProductBoxList);
   
   if(ProductBoxList != null && ProductBoxList.size()> 0)
   {
   	 insert ProductBoxList;
   }
   
}