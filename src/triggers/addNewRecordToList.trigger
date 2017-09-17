trigger addNewRecordToList on Products_DisplayList__c (after update) {
    
     Set<Id> pd2List = new Set<Id>();
     for(Products_DisplayList__c  pdList : Trigger.newMap.values()){
         if(pdList.Product2Id__c != null){
              pd2List.add(pdList.Product2Id__c);
            }
     }
    system.debug('Trigger.newMap.values() : '+ Trigger.newMap.values());
    system.debug('pd2List : '+ pd2List);
   Map<Id,Product2> pbe = new Map<Id,Product2>([Select 
                                                p.SystemModstamp, p.Products_Sold__c, p.Products_Box3__c, 
                                                p.Products_Box3_Ticket_Value__c, p.Products_Box2__c, 
                                                p.Products_Box2_Ticket_Value__c, p.Products_Box1__c, 
                                                p.Products_Box1_Ticket_Value__c, p.Product_Image__c, p.ProductImage__c, 
                                                p.ProductCode, p.Name, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, 
                                                p.IsActive, p.Id, p.Family, p.Description, p.CreatedDate, p.CreatedById, 
                                                p.Auto_Add_to_List__c,(Select Id, Name, Pricebook2Id, Product2Id, UnitPrice, IsActive, UseStandardPrice, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, ProductCode, IsDeleted From PricebookEntries where IsActive = true)
                                                 From Product2 p where Id IN : pd2List ]);
     
   List<Products_DisplayList__c> NewpdList = new List<Products_DisplayList__c>();                          
   for (Products_DisplayList__c  pdl : Trigger.newMap.values()) {
         system.debug('price book rate UnitPrice : ' + pbe.get(pdl.Product2Id__c).PricebookEntries[0].UnitPrice);
         
         Products_DisplayList__c pdlo = new Products_DisplayList__c();
         /*Product2 pd2 = new Product2();
         pd2= pbe.get(pdl.Product2Id__c).Product2Id;*/
         system.debug('>>>>>>>>>>>>..   pd2 >>>>>>>>>>: '+ pbe.get(pdl.Product2Id__c));
         if(pbe.get(pdl.Product2Id__c).Products_Box1__c = True  && pdl.Number_of_Tickets_Remaining__c ==0 && pdl.Status__c =='closed'
                    && Trigger.oldMap.get(pdl.ID).Number_of_Tickets_Remaining__c != pdl.Number_of_Tickets_Remaining__c )
                {
                 pdlo.Name =pbe.get(pdl.Product2Id__c).Name;
                 pdlo.ProductId__c =String.valueOf(pbe.get(pdl.Product2Id__c).Id);
                 pdlo.Product2Id__c = pbe.get(pdl.Product2Id__c).PricebookEntries[0].Product2Id ;
                 pdlo.Product_Description__c=pbe.get(pdl.Product2Id__c).Description;
                 pdlo.ProductCode__c=pbe.get(pdl.Product2Id__c).ProductCode;
                 pdlo.Product_Image__c=pbe.get(pdl.Product2Id__c).Product_Image__c;
                 pdlo.Status__c='Open';
                 pdlo.IsActive__c=true;
                 pdlo.Product_Price__c=pbe.get(pdl.Product2Id__c).PricebookEntries[0].UnitPrice;
                 if(pbe.get(pdl.Product2Id__c).Products_Box1__c = true && pdl.Box_Name__c =='Box1' ){
                     pdlo.Ticket_Price__c=pbe.get(pdl.Product2Id__c).Products_Box1_Ticket_Value__c;
                     system.debug('pbe.get(pdl.Product2Id__c).Products_Box1_Ticket_Value__c; : ' + pbe.get(pdl.Product2Id__c).Products_Box1_Ticket_Value__c);
                     pdlo.Number_of_Tickets__c=pbe.get(pdl.Product2Id__c).PricebookEntries[0].UnitPrice/pbe.get(pdl.Product2Id__c).Products_Box1_Ticket_Value__c;
                     pdlo.Number_of_Tickets_Remaining__c=pbe.get(pdl.Product2Id__c).PricebookEntries[0].UnitPrice/pbe.get(pdl.Product2Id__c).Products_Box1_Ticket_Value__c;
                     pdlo.Box_Name__c='Box1';
                 }
                 if(pbe.get(pdl.Product2Id__c).Products_Box2__c = true && pdl.Box_Name__c =='Box2'){
                     pdlo.Ticket_Price__c=pbe.get(pdl.Product2Id__c).Products_Box2_Ticket_Value__c;
                     pdlo.Number_of_Tickets__c=pbe.get(pdl.Product2Id__c).PricebookEntries[0].UnitPrice/pbe.get(pdl.Product2Id__c).Products_Box2_Ticket_Value__c;
                     pdlo.Number_of_Tickets_Remaining__c=pbe.get(pdl.Product2Id__c).PricebookEntries[0].UnitPrice/pbe.get(pdl.Product2Id__c).Products_Box2_Ticket_Value__c;
                     pdlo.Box_Name__c='Box2';
                 }
                 if(pbe.get(pdl.Product2Id__c).Products_Box3__c = true && pdl.Box_Name__c =='Box3'){
                     pdlo.Ticket_Price__c=pbe.get(pdl.Product2Id__c).Products_Box3_Ticket_Value__c;
                     pdlo.Number_of_Tickets__c=pbe.get(pdl.Product2Id__c).PricebookEntries[0].UnitPrice/pbe.get(pdl.Product2Id__c).Products_Box3_Ticket_Value__c;
                     pdlo.Number_of_Tickets_Remaining__c=pbe.get(pdl.Product2Id__c).PricebookEntries[0].UnitPrice/pbe.get(pdl.Product2Id__c).Products_Box3_Ticket_Value__c;
                     pdlo.Box_Name__c='Box3';
                 }
                 
                   system.debug('pdlo : ' + pdlo);
                   if(pdlo != null){
                   	
                    NewpdList.add(pdlo);       	
                   } 
            
        }
        
        insert   NewpdList;
        
    
  }


}