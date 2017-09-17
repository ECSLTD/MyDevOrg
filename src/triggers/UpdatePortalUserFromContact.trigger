trigger UpdatePortalUserFromContact on Contact (after update) {

 /*List<User> updateUserList = new List<User>();
 Map<Id,User> UsersMap = new Map<Id, User>([select ContactId,Email,FirstName,LastName,
                                       Title,Phone,Street,State,PostalCode,Country,City 
                                       From User where ContactId in : Trigger.NewMap.keySet()]);
System.Debug('Trigger.NewMap.KeySet() : '+ Trigger.NewMap.KeySet());
System.Debug('UsersMap : '+ UsersMap);
   for (User u : UsersMap.values()){
   	
         if (u!=null && u.ContactId !=null) {
         	      System.Debug('ContactId : ' + u.ContactId);
                Contact c = trigger.newMap.get(u.ContactId);
                 System.Debug('Contact : ' + c);
                if(c!=null){
	                u.Email = c.Email;
	                u.FirstName=c.FirstName;
	                u.LastName=c.LastName;
	                u.Title=c.Title;
	                u.Phone =c.Phone;
	                u.Street=c.MailingStreet;
	                u.State=c.MailingState;
	                u.PostalCode=c.MailingPostalCode;
	                u.Country= c.MailingCountry;
	                u.City=c.MailingCity;
	                
	               updateUserList.add(u);
                }
            }
        }
System.Debug('updateUserList : ' + updateUserList);
        if((updateUserList != null)&& (updateUserList.size() > 0)){
         
          update updateUserList;
        
        }*/
 
     }