@IsTest
public class TestUtil {

public static List<Profile> profiles = new List<Profile>();
public static Profile HighVolumeprofile = new Profile();
public static Profile Standardprofile = new Profile();

public static void Init(){
	
	profiles = [Select Id,Name From Profile];
	for(Profile p : profiles){
		if(p.name=='High Volume Customer Portal'){
			HighVolumeprofile=p;
		}else if(p.name=='Standard User')
		{
			Standardprofile=p;
		}
		
	}
}

public static User standrardUser(){

 User u = new User(alias = 'test123', email='StandardUser11@email.com',
      emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
      localesidkey='en_US', profileid = Standardprofile.Id, country='United States',
      timezonesidkey='America/Los_Angeles', username='StandardUser11@email.com');
    //insert u;

   return u;
   
}

public static Account CreateAcccount(String strName){

     Account a = new Account(
          Name = strName
          );
     // insert a;
      
     return a;

}
 public static Contact CreateContact(Account acc){
 	
 	 Contact c = new Contact(LastName = 'Contact Last Name', AccountId = acc.Id);
     //insert c;
     
     return c;
         
 }
 public static User createCustomerUser(ID contactId,String username, String lastName )
    {

		  User user = new User();
		  user.ProfileID = HighVolumeprofile.Id;
		  user.EmailEncodingKey = 'ISO-8859-1';
		  user.LanguageLocaleKey = 'en_US';
		  user.TimeZoneSidKey = 'America/New_York';
		  user.LocaleSidKey = 'en_US';
		  user.FirstName = 'first';
		  user.LastName = lastName;
		  user.Username = username;   
		  user.CommunityNickname = lastName;
		  user.Alias = 't1';
		  user.Email = 'no@email.com';
		  user.IsActive = true;
		  user.ContactId = contactId;
		  return user;
    }
}