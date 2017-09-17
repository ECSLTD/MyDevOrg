/**
 * An apex page controller that exposes the site login functionality
 */
global class SiteLoginCustomController {
    public String username {get; set;}
    public String password {get; set;}
    public String CurrentUserName{get; set;}

    public PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
       // if (startUrl == null) startURL = (Site.getPrefix() == null ? '' : Site.getPrefix()) + '/home/home.jsp';
        if (startUrl == null) startURL = (Site.getPrefix() == null ? '' : Site.getPrefix()) + '/samplesite';
        return Site.login(username, password, startUrl);
    }
    
    public SiteLoginCustomController () {
       String userName = UserInfo.getUserName();
       User activeUser = [Select Email,Username,UserType From User where Username = : userName limit 1];
       String userEmail = activeUser.Email;
       CurrentUserName =UserInfo.getSessionId()+ ' ' +UserInfo.getUserType();
       }
    
    public static testMethod void testSiteLoginController () {
        // Instantiate a new controller with all parameters in the page
        SiteLoginCustomController controller = new SiteLoginCustomController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456';
                
        System.assertEquals(controller.login(),null);                           
    }     
}