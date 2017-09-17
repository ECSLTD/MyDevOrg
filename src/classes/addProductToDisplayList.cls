global class addProductToDisplayList{
    
       
    WebService static void addProductToList(string id) {
	    List<Product_Box__c> ProductBoxList = new List<Product_Box__c>();
	    Products_DisplayList__c pdl;
	    
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
	    List<Products_DisplayList__c> pdls;
	 if (pbe != null){
	 	  pdls =[select Id,IsActive__c,Status__c,Box_Name__c,Product2Id__c,
                 (Select Id, IsDeleted, Name, CreatedDate, CreatedById, 
                         LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate,
                         Products_DisplayList__c, IsActive__c, Number_of_Tickets__c,
                         Number_of_Tickets_Remaining__c, Status__c, Ticket_Price__c From Product_Boxes__r where IsActive__c =true )
                         From Products_DisplayList__c
                         where ProductCode__c =:pbe.Product2.ProductCode and Product2Id__c =:pbe.Product2Id];
     
	     If(pdls == null || pdls.isEmpty()!= false){                     
		     pdl = new Products_DisplayList__c();
		     pdl.Name =pbe.Product2.Name;
		     pdl.ProductId__c =String.valueOf(pbe.Product2Id);
		     pdl.Product2Id__c=pbe.Product2Id;
		     pdl.Product_Description__c=pbe.Product2.Description;
		     pdl.ProductCode__c=pbe.Product2.ProductCode;
		     pdl.Product_Image__c=pbe.Product2.Product_Image__c;
		     pdl.Status__c='Open';
		     pdl.IsActive__c=true;
		     pdl.Product_Price__c=pbe.UnitPrice;
		     insert pdl;
	     }
     
	 }

    system.debug('>>>> pdls : ' + pdls);
    system.debug('>>>> pdl : ' + pdl);
    
    
    boolean isBox1Exist =false;
    boolean isBox2Exist =false;
    boolean isBox3Exist =false;
    
	if(pdls!=null && pdls.size()>0){
     for(Products_DisplayList__c pl : pdls){
     	 for(Product_Box__c p : pl.Product_Boxes__r){
		    if( p.Name=='Box1' && (pl.IsActive__c = true) && (p.IsActive__c = true && p.Status__c =='Open')){
		        isBox1Exist=true;
		    }
		    if(p.Name=='Box2' && (pl.IsActive__c = true) && (p.IsActive__c = true && p.Status__c =='Open')){
		        isBox2Exist=true;
		    }
		    if(p.Name=='Box3' && (pl.IsActive__c = true) && (p.IsActive__c = true && p.Status__c =='Open')){
		        isBox3Exist=true;
		    }
     	 }
     }
     system.debug('>>>>for pdls : ' + pdls);
	}
	
	
	if(isBox1Exist!=true && pdl != null && pbe.Product2.Products_Box1__c != false ){
         ProductBoxList.add(AddBoxToProductDisplyList(pbe,pdl,'Box1'));
	}
   if(isBox2Exist!=true && pbe.Product2.Products_Box2__c != false && pdl!=null){
         ProductBoxList.add(AddBoxToProductDisplyList(pbe,pdl,'Box2'));
    }
    if(isBox3Exist!=true && pbe.Product2.Products_Box3__c != false && pdl!=null){
         ProductBoxList.add(AddBoxToProductDisplyList(pbe,pdl,'Box3'));
    }
    if(ProductBoxList != null && ProductBoxList.size() > 0){
    	insert ProductBoxList;
    }
    
    }
   public static Product_Box__c AddBoxToProductDisplyList(PricebookEntry pbe ,Products_DisplayList__c pdl,String BoxName)
   {
     	 Product_Box__c pbox = new Product_Box__c();
     	 pbox.Products_DisplayList__c =pdl.Id;
     	 pbox.Status__c='Open';
         pbox.IsActive__c=true;
         if(BoxName=='Box1'){
	     pbox.Ticket_Price__c=pbe.Product2.Products_Box1_Ticket_Value__c;
	     pbox.Number_of_Tickets__c=pbe.UnitPrice/pbe.Product2.Products_Box1_Ticket_Value__c;
	     pbox.Number_of_Tickets_Remaining__c=pbe.UnitPrice/pbe.Product2.Products_Box1_Ticket_Value__c;
	     pbox.Name =BoxName;
         }
         if(BoxName=='Box2'){
         pbox.Ticket_Price__c=pbe.Product2.Products_Box2_Ticket_Value__c;
         pbox.Number_of_Tickets__c=pbe.UnitPrice/pbe.Product2.Products_Box2_Ticket_Value__c;
         pbox.Number_of_Tickets_Remaining__c=pbe.UnitPrice/pbe.Product2.Products_Box2_Ticket_Value__c;
         pbox.Name =BoxName;
         }
         if(BoxName=='Box3'){
         pbox.Ticket_Price__c=pbe.Product2.Products_Box3_Ticket_Value__c;
         pbox.Number_of_Tickets__c=pbe.UnitPrice/pbe.Product2.Products_Box3_Ticket_Value__c;
         pbox.Number_of_Tickets_Remaining__c=pbe.UnitPrice/pbe.Product2.Products_Box3_Ticket_Value__c;
         pbox.Name =BoxName;
         }
       return pbox;
   }

 public static Product_Box__c AddBoxToDisplyList(Products_DisplayList__c pdl,String BoxName)
   {
         Product_Box__c pbox = new Product_Box__c();
         pbox.Products_DisplayList__c =pdl.Id;
         pbox.Status__c='Open';
         pbox.IsActive__c=true;
         if(BoxName=='Box1'){
         pbox.Ticket_Price__c=pdl.Product2Id__r.Products_Box1_Ticket_Value__c;
         pbox.Number_of_Tickets__c=pdl.Product_Price__c/pdl.Product2Id__r.Products_Box1_Ticket_Value__c;
         pbox.Number_of_Tickets_Remaining__c=pdl.Product_Price__c/pdl.Product2Id__r.Products_Box1_Ticket_Value__c;
         pbox.Name =BoxName;
         }
         if(BoxName=='Box2'){
         pbox.Ticket_Price__c=pdl.Product2Id__r.Products_Box2_Ticket_Value__c;
         pbox.Number_of_Tickets__c=pdl.Product_Price__c/pdl.Product2Id__r.Products_Box2_Ticket_Value__c;
         pbox.Number_of_Tickets_Remaining__c=pdl.Product_Price__c/pdl.Product2Id__r.Products_Box2_Ticket_Value__c;
         pbox.Name =BoxName;
         }
         if(BoxName=='Box3'){
         pbox.Ticket_Price__c=pdl.Product2Id__r.Products_Box3_Ticket_Value__c;
         pbox.Number_of_Tickets__c=pdl.Product_Price__c/pdl.Product2Id__r.Products_Box3_Ticket_Value__c;
         pbox.Number_of_Tickets_Remaining__c=pdl.Product_Price__c/pdl.Product2Id__r.Products_Box3_Ticket_Value__c;
         pbox.Name =BoxName;
         }
       return pbox;
   }



}