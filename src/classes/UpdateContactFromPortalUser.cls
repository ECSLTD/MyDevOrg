global class UpdateContactFromPortalUser {
    @future
    public static void updateContacts(String userId) {
        User u = [select ContactId,Email,FirstName,LastName,Title 
                    from User
                    where Id=:userId];
                
        if (u!=null && u.ContactId!=null) {
            Contact c = new Contact(Id=u.ContactId);
            
            c.Email = u.Email;
            c.FirstName=u.FirstName;
            c.LastName=u.LastName;
            c.Title=u.Title;
            update c;
        }
    }
    
    static testMethod void testUpdateContacts() {   
        Test.startTest();   
        User u = [select Id,ContactId,FirstName from User where ContactId<>'' limit 1]; 
        
        u.FirstName='Bar';
        update u;
        
        Test.stopTest();
        
        Contact c = [select FirstName from Contact where Id=:u.ContactId];
        System.assertEquals(c.FirstName,u.FirstName);
    }
}