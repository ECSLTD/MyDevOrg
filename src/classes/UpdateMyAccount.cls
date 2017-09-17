public class UpdateMyAccount {


public static List<User> UserList;
public static List<Contact> ContactList = new  List<Contact>();

@future
public static void updateContact(Set<ID> UsersSet)
{
   UserList=[select ContactId,Street,PostalCode,Country,City,State,Email,lastname,FirstName,Title,Phone  from User where  ID IN :UsersSet];
   System.debug('UserList: ' + UserList);
   
    for (User u : UserList){
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
                
               ContactList.add(c);
            }
        }
   
   
   if (ContactList!= null && ContactList.size() > 0){
      update ContactList;
   }
}

}