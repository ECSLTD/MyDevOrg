public class clsCampaignWizardController{

    public Test_Campaign__c  objTestCampagin;
    public Question__c objQuestion;
    public Answer__c objAnswer;
    public String QuestionId;
    public String AnswerRowId;
    public List<Question__c> QuestionList= new List<Question__c>();
    public List<Answer__c > AnswersList= new List<Answer__c >();

  public clsCampaignWizardController(){
         objAnswer= new Answer__c();
         AnswersList.add(objAnswer);
  }
    
  public Test_Campaign__c  getTestCampaign() {
     if(objTestCampagin== null) objTestCampagin= new Test_Campaign__c ();
     return objTestCampagin;
  }

   public Question__c getQuestion() {
      if(objQuestion == null)
      { objQuestion = new Question__c();
      objQuestion.Test_Campaign__c=objTestCampagin.Id;}
      system.debug('objQuestion result: '+ objQuestion  );
      return objQuestion;
   }
  public List<Question__c> getQuestions() {
      return QuestionList;
   }
   public void SaveAndNewQuestion() {
  
      upsert objQuestion;
      SaveAllAnswers();
      QuestionList.add(objQuestion);
      objQuestion = new Question__c();
      objQuestion.Test_Campaign__c=objTestCampagin.Id;
      AnswersList= new List<Answer__c >();
      objAnswer= new Answer__c();
      answersList.add(objAnswer);
   }
   public void EditQuestion() {
      QuestionId=ApexPages.currentPage().getParameters().get('QuestionId');
     for(Question__c qus : QuestionList) {
            if (qus.Id == QuestionId) {  
                objQuestion= qus;
                 return;
               }}
   }
   public List<Answer__c> getAnswers() {
      if(objAnswer== null) {objAnswer= new Answer__c();
         answersList.add(objAnswer);
      }
    return answersList ;
   }

  
    public void AddAnswer() {
    
         if (objQuestion.Id==null)
         {
         system.debug('objQuestion.Id' + objQuestion.Id + objQuestion.Test_Campaign__c );
           objQuestion.Test_Campaign__c =objTestCampagin.Id;
         }
         //upsert objQuestion;
         //SaveAllAnswers();
         objAnswer= new Answer__c();
         answersList.add(objAnswer);
    }
    public void SaveAllAnswers() {
         
           for(Answer__c a : answersList ) {
            if (a.Id == null) {  
                a.Question__c= objQuestion.Id;
               }
         }
        upsert answersList ;
        
    }
    

  public PageReference step1() {
   system.debug('objTestCampagin' + objTestCampagin.Id);
       if (objTestCampagin.Id==null)
      {
        insert objTestCampagin;
      }        
       else{
        update objTestCampagin;
     }
       system.debug('objTestCampagin' + objTestCampagin.Id);
      return Page.CampaignWizardQuestionDetails;
   }

   public PageReference step2() {
   
       if (objQuestion.Id==null)
       {
         objQuestion.Test_Campaign__c =objTestCampagin.Id;
         insert objQuestion;
       }        
        else{
         update objQuestion;
      }
      SaveAllAnswers();
       system.debug('objQuestion' + objQuestion.Id);
      return Page.CampaignWizardQuestionDetails;
   }
 
      public PageReference step3() {
   
      return Page.campaignwizardLatestdetails;
      
      return null;
   }
   public void DeleteAnswer() {
   
   system.debug('answersList :' + answersList  );
   List<Answer__c> LatestAnswerList = new List<Answer__c>();
    
         AnswerRowId  = ApexPages.currentPage().getParameters().get('AnswerRowId');
         if (AnswerRowId == ''){
         AnswerRowId=null; }

          system.debug('AnswerRowId ' + AnswerRowId );
   for(Answer__c a : answersList ) {
       system.debug('String.valueOf(a.Id)' + String.valueOf(a.Id));
        if ((String.valueOf(a.Id) == AnswerRowId) ) {   
          system.debug('Delete ' + a);
           if (a.Id!=null)Delete a;
        }
        else
        {
           LatestAnswerList.add(a);
         }
      }
      answersList  = new List<Answer__c>();
      answersList =LatestAnswerList;
        system.debug('Delete answersList  ' + answersList );

   }
   public PageReference save() {

      // redirecting to elsewhere.  
    
      PageReference opptyPage = new PageReference('/' +
                                                  objTestCampagin.id);
      opptyPage.setRedirect(true);

      return opptyPage;
   }
    
}