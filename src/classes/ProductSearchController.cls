public with sharing class ProductSearchController {
 
  // the soql without the order and limit
  private String soql {get;set;}
  // the collection of Products to display
  public List<Products_DisplayList__c> Products {get;set;}
 
  // the current sort direction. defaults to asc
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }
 
  // the current field to sort by. defaults to last name
  public String sortField {
    get  { if (sortField == null) {sortField = 'Name'; } return sortField;  }
    set;
  }
 
  // format the soql for display on the visualforce page
  public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
    set;
  }
    String Status ='Open';
  // init the controller and display some sample data when the page loads
  public ProductSearchController() {
  	
    soql = 'select Name,ProductImage__c,Product2Id__c,Number_of_Tickets__c,Number_of_Tickets_Remaining__c,';
    soql=soql +' Ticket_Price__c,img_width__c,img_height__c,Box_Name__c,Product_Description__c ,'; 
    soql=soql +' (Select Id, Name, IsActive__c, Number_of_Tickets__c, Number_of_Tickets_Remaining__c, Status__c, Ticket_Price__c From Product_Boxes__r where IsActive__c =true order by Name asc) '; 
    soql=soql+' from Products_DisplayList__c where Product2Id__c != null and Status__c= \''+String.escapeSingleQuotes(Status)+'\' and IsActive__c !=false';
    runQuery();
  }
 
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }
 
  // runs the actual query
  public void runQuery() {
 
    try {
      Products= Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20');
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
    }
 
  }
 
  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {
 
    String productName = Apexpages.currentPage().getParameters().get('productname');
    String lastName = Apexpages.currentPage().getParameters().get('lastname');
    String accountName = Apexpages.currentPage().getParameters().get('accountName');
    String technology = Apexpages.currentPage().getParameters().get('technology');
 
      soql = 'select Name,ProductImage__c,Product2Id__c,Number_of_Tickets__c,Number_of_Tickets_Remaining__c,';
    soql=soql +' Ticket_Price__c,img_width__c,img_height__c,Box_Name__c,Product_Description__c ,';
    soql=soql +' (Select Id, Name, IsActive__c, Number_of_Tickets__c, Number_of_Tickets_Remaining__c, Status__c, Ticket_Price__c From Product_Boxes__r where IsActive__c =true order by Name asc) ';   
    soql=soql+' from Products_DisplayList__c where Product2Id__c != null and Status__c='+ String.escapeSingleQuotes(Status) +' and IsActive__c !=false';
    if (!productName.equals(''))
      soql += ' and Name LIKE \''+String.escapeSingleQuotes(productName)+'%\'';
    /*if (!lastName.equals(''))
      soql += ' and lastname LIKE \''+String.escapeSingleQuotes(lastName)+'%\'';
    if (!accountName.equals(''))
      soql += ' and account.name LIKE \''+String.escapeSingleQuotes(accountName)+'%\'';  
    if (!technology.equals(''))
     // soql += ' and interested_technologies__c includes (\''+technology+'\')';
   */
    // run the query again
    runQuery();
 
    return null;
  }
 
  // use apex describe to build the picklist values
  public List<String> technologies {
    get {
      if (technologies == null) {
 
        technologies = new List<String>();
      /* Schema.DescribeFieldResult field = Contact.interested_technologies__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          technologies.add(f.getLabel());
          
          */
 
      }
      return technologies;          
    }
    set;
  }
  
    // the current field to sort by. defaults to last name
  public String productId {
    get  { if (productId == null ||productId =='' )
    	    {
    	       productId = 'NoId'; 
    	     } 
    	       return productId;  }
    set {
            productId = value;}
  }
  
    public boolean displayPopup {get; set;}     
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
  
  public void BuyTicket(){
  	
  	displayPopup = true; 
  	productId='test';
  	
  }
  
  
  
  
 
}