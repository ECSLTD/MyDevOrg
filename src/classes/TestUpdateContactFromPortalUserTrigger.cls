@isTest
private class TestUpdateContactFromPortalUserTrigger {
    static testMethod void testSingleInsert(){
         TestUtil.Init();
         Account a = TestUtil.CreateAcccount('TestAccount');
         insert a;
         Contact contact = TestUtil.CreateContact(a);
         insert contact;
         User u =TestUtil.createCustomerUser(contact.Id,'testuser1@tester.com','TestUser');
         insert u;
          u.LastName= 'Update Contact';
          u.email='newemail23@gmail.com';
          update u;
          u=[select lastname,email,contactId from User where Id=:u.ID];
          Contact c=[select lastname,email from Contact where Id=:u.contactId];
          system.assertEquals(u.lastname,c.lastname);
          system.assertEquals(u.email,c.email);
      
    }

static testMethod void testBulkInsert() {
    
      List<Contact> contacts = new List<Contact>();
      List<User> users= new List<User>();
      List<User> Updateusers= new List<User>();
      TestUtil.Init();
      Account a = TestUtil.CreateAcccount('TestAccount');
      insert a;
      
     for (Integer i=0;i<200;i++) {
             Contact contact = TestUtil.CreateContact(a);
             contacts.add(contact);
        }
     insert contacts;
     
       for (Integer i=0;i<200;i++) {
             User u =TestUtil.createCustomerUser(contacts[i].Id,String.valueof(i)+'testuser12@tester.com','TestUser'+String.valueof(i));
             users.add(u);
        }
        insert users;
    
     
      for (Integer i=0;i<200;i++) {
           User u = new User(Id=users[i].Id);
              u.Title = 'Mr';
              u.email= String.valueOf(i)+'newemail@gmail.com';
          Updateusers.add(u);
    
      }
    
      update Updateusers; 

}
}