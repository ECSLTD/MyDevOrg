global class BackupaddProductToDisplayList{
    
    WebService static void addProductToList(string id) {
        List<Products_DisplayList__c> ProductsDisplayList = new List<Products_DisplayList__c>();
        PricebookEntry pbe = [Select p.UseStandardPrice,p.UnitPrice, 
                              p.SystemModstamp,p.ProductCode, 
                              p.Product2Id,p.Pricebook2Id, 
                              p.Name,p.LastModifiedDate, 
                              p.LastModifiedById,p.IsDeleted, 
                              p.IsActive,p.Id,p.CreatedDate,
                              p.Product2.Name,
                              p.CreatedById,p.Product2.Products_Box3_Ticket_Value__c,
                              p.Product2.Products_Box2_Ticket_Value__c, p.Product2.Products_Box1_Ticket_Value__c,
                              p.Product2.Products_Box3__c, p.Product2.Products_Box2__c, 
                              p.Product2.Products_Box1__c, p.Product2.Auto_Add_to_List__c,
                              p.Product2.Product_Image__c,p.Product2.IsActive, 
                              p.Product2.Description,p.Product2.ProductCode
                              From PricebookEntry p where Product2Id =:id];
    
        system.debug('pbe :' + pbe );
     List<Products_DisplayList__c> pdls =[select Id,IsActive__c,Status__c,Box_Name__c From Products_DisplayList__c
                                          where ProductCode__c =:pbe.Product2.ProductCode];
    system.debug('>>>> pdls : ' + pdls);
    
    boolean isBox1Exist =false;
    boolean isBox2Exist =false;
    boolean isBox3Exist =false;
    
    if(pdls!=null && pdls.size()>0){
     for(Products_DisplayList__c p : pdls){
        if((p.Box_Name__c=='Box1') && (p.IsActive__c = true && p.Status__c =='Open')){
            isBox1Exist=true;
        }
        if(p.Box_Name__c=='Box2' && (p.IsActive__c = true && p.Status__c =='Open')){
            isBox2Exist=true;
        }
        if(p.Box_Name__c=='Box3' && (p.IsActive__c = true && p.Status__c =='Open')){
            isBox3Exist=true;
        }
     }
     system.debug('>>>>for pdls : ' + pdls);
    }
    if(isBox1Exist!=true){
         ProductsDisplayList.add(AddProductToDisplyList(pbe,'Box1'));
    }
  if(isBox2Exist!=true){
         ProductsDisplayList.add(AddProductToDisplyList(pbe,'Box2'));
    }
    if(isBox3Exist!=true){
         ProductsDisplayList.add(AddProductToDisplyList(pbe,'Box3'));
    }

        if(ProductsDisplayList != null && ProductsDisplayList.size() > 0){
            insert ProductsDisplayList;
        }
    
    }
   public static Products_DisplayList__c AddProductToDisplyList(PricebookEntry pbe ,String BoxName)
   {
     Products_DisplayList__c pdl = new Products_DisplayList__c();
     pdl.Name =pbe.Product2.Name;
     pdl.ProductId__c =String.valueOf(pbe.Product2Id);
     pdl.Product2Id__c=pbe.Product2Id;
     pdl.Product_Description__c=pbe.Product2.Description;
     pdl.ProductCode__c=pbe.Product2.ProductCode;
     pdl.Product_Image__c=pbe.Product2.Product_Image__c;
     pdl.Status__c='Open';
     pdl.IsActive__c=true;
     pdl.Product_Price__c=pbe.UnitPrice;
     if(pbe.Product2.Products_Box1__c = true && BoxName =='Box1' ){
         pdl.Ticket_Price__c=pbe.Product2.Products_Box1_Ticket_Value__c;
         pdl.Number_of_Tickets__c=pbe.UnitPrice/pbe.Product2.Products_Box1_Ticket_Value__c;
         pdl.Number_of_Tickets_Remaining__c=pbe.UnitPrice/pbe.Product2.Products_Box1_Ticket_Value__c;
         pdl.Box_Name__c='Box1';
     }
     if(pbe.Product2.Products_Box2__c = true && BoxName =='Box2'){
         pdl.Ticket_Price__c=pbe.Product2.Products_Box2_Ticket_Value__c;
         pdl.Number_of_Tickets__c=pbe.UnitPrice/pbe.Product2.Products_Box2_Ticket_Value__c;
         pdl.Number_of_Tickets_Remaining__c=pbe.UnitPrice/pbe.Product2.Products_Box2_Ticket_Value__c;
         pdl.Box_Name__c='Box2';
     }
     if(pbe.Product2.Products_Box3__c = true && BoxName =='Box3'){
         pdl.Ticket_Price__c=pbe.Product2.Products_Box3_Ticket_Value__c;
         pdl.Number_of_Tickets__c=pbe.UnitPrice/pbe.Product2.Products_Box3_Ticket_Value__c;
         pdl.Number_of_Tickets_Remaining__c=pbe.UnitPrice/pbe.Product2.Products_Box3_Ticket_Value__c;
         pdl.Box_Name__c='Box3';
     }
     return pdl;
     
   }

}