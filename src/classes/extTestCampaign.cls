public class extTestCampaign{

    public Test_Campaign__c camp;
    
     public List<Question__c> QuestionList {get; set;} 
    
    public extTestCampaign(ApexPages.StandardController stdController) {
         this.camp = (Test_Campaign__c)stdController.getRecord();
          //Questions();
    }
  
    
    //This method uses a simple SOQL query to return a List of Questions
    public List<cQuestions> getQuestions() {
 
        if(QuestionList == null) {
            QuestionList = new List<Question__c>();
            system.debug('test :' + this.camp);
            QuestionList  = [Select q.Select_Option__c, q.Name, (Select Name From Answers__r) From Question__c q where q.Test_Campaign__c ='a0AG0000007zoejMAA'];
        }
        
       // for(Question__c q : QuestionList   )
       // {
           // system.debug('QuestionList test :' + q.Answers__r);
           // for(Answer__c a: q.Answers__r)
           // {
           //    system.debug('Answertest :' + a.Name);
           // }
           
        // }
               List<cQuestions> cq  = new List<cQuestions>();
               cQuestions test;
               for(Question__c q: QuestionList)
               {
                 cq.add(new cQuestions(q));
               }
         
        return cq;
    }


    public class cQuestions {  
    
             public String qName {get; set;}  
             public String qType{get; set;}  
             List<SelectOption> optionsItem = new List<SelectOption>();

             public  cQuestions (Question__c q) {  
                     qName = q.Name; 
                     qType=q.Select_Option__c; 
                     system.debug('qName '+ q.Name);
                     system.debug('Select_Option__c'+ q.Select_Option__c);
                     system.debug('q.Answers__r'+ q.Answers__r);
                      
                     for(Answer__c a: q.Answers__r)
                       {
                          system.debug('a.Name'+ a.Name);
                          optionsItem.add(new selectOption(a.Name, a.Name));
                       }

             }  
    public List<SelectOption> options{ get 
       {
            return optionsItem;
       } 
    }

             
    
        }
  
}