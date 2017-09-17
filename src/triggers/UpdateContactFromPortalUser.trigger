trigger UpdateContactFromPortalUser on User (after update) {

 /*Map<ID,Contact> updateContactList = new Map<ID,Contact>();
   for (User u : Trigger.new){
         if (u!=null && u.ContactId!=null) {
                Contact c = new Contact(Id=u.ContactId);
                c.Email = u.Email;
                c.FirstName=u.FirstName;
                c.LastName=u.LastName;
                c.Title=u.Title;
                c.Phone =u.Phone;
                c.MailingStreet=u.Street;
                c.MailingState=u.State;
                c.MailingPostalCode=u.PostalCode;
                c.MailingCountry= u.Country;
                c.MailingCity=u.City;
                
               updateContactList.Put(c.ID,c);
            }
        }*/

        if((Trigger.newMap.Keyset()!= null)&& (Trigger.newMap.Keyset().size() > 0)){
         
             UpdateMyAccount.updateContact( Trigger.newMap.Keyset());
        }
 
     }