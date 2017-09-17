public class clsMyAccountController{

  public User  objUser;
  public String strUserType= UserInfo.getUserType();
  public PageReference MyAccount(){
       system.debug('My Account :' + strUserType.toLowerCase() );
         if(strUserType.toLowerCase() =='GuestUser'.toLowerCase())
         {
             return Page.samplesite;
         }
         
       return null;
  }
    
  public  User getUserDetails() {
     if(objUser== null && (strUserType.toLowerCase() !='GuestUser'.toLowerCase()))
     {
        objUser=[select lastname,email from User where Id=:UserInfo.getUserId()];  
     }
             system.debug('objUser :' + objUser );
     return objUser;
  }
  
 public PageReference save() {

          return null;
   }
    
}