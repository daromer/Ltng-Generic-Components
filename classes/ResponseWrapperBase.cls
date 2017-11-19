global virtual class ResponseWrapperBase {
    
    @AuraEnabled
    global Boolean success {get;set;}    
    @AuraEnabled
    global Error[] errors {get;set;}
    @AuraEnabled
    global Info config{get;set;}
    
    public ResponseWrapperBase(){
        success = true; 
        errors = new list<Error>();
        config = new Info();
    }
    
    global class SiteInfoWrapper{
        global string BaseUrl{get{return (Network.getNetworkId () !=null)? Site.getBaseUrl() : URL.getSalesforceBaseUrl().toExternalForm();}}
    }
    
    global class TimeZoneWrapper{
        global string Id {get;set;}        
        global string DisplayName{get;set;}
        public TimeZoneWrapper(TimeZone init){
            this.Id = init.getID();
            this.DisplayName = init.getDisplayName();
        }
    }
    global class UserInfoWrapper{
        global string Name{get;set;}
        global string UserId{get;set;}
        global string UserName{get;set;}
        global string FirstName{get;set;}
        global string LastName{get;set;}
        global string Locale{get;set;}
        global string ProfileId{get;set;}
        global string ProfileName{get;set;}
        global string SessionId{get;set;}        
        global string UiTheme{get;set;}
        global string Email{get;set;}
        global string UiThemeDisplayed{get;set;}
        global string UserType{get;set;}
        global string UserRoleId{get;set;}
        global string UserRoleName{get;set;}  
        global string ContactId{get;set;}
        global TimeZoneWrapper TimeZone{get;set;}
	}
    private static UserInfoWrapper getUserInfoCache{get;set;}
    private static UserInfoWrapper getUserInfo(){
        if (getUserInfoCache == null){
            getUserInfoCache = new UserInfoWrapper();
        	getUserInfoCache.UserId = UserInfo.getUserId();
            getUserInfoCache.UserName = UserInfo.getUserName();
            getUserInfoCache.FirstName = UserInfo.getFirstName();
            getUserInfoCache.LastName = UserInfo.getLastName();
            getUserInfoCache.Locale = UserInfo.getLocale();
            getUserInfoCache.ProfileId = UserInfo.getProfileId();
            getUserInfoCache.SessionId = UserInfo.getSessionId();
            getUserInfoCache.UiTheme = UserInfo.getUiTheme();
            getUserInfoCache.Email = UserInfo.getUserEmail();
            getUserInfoCache.UiThemeDisplayed = UserInfo.getUiThemeDisplayed();
            getUserInfoCache.UserType = UserInfo.getUserType();
            getUserInfoCache.UserRoleId = UserInfo.getUserRoleId();
            getUserInfoCache.TimeZone = new TimeZoneWrapper( UserInfo.getTimeZone()  );
            for(User u: [Select Name,Profile.Name, UserRole.Name, ContactId from User where id=:userinfo.getuserid() limit 1]){
                getUserInfoCache.Name = u.Name;
                getUserInfoCache.ProfileName = u.Profile.Name;
                getUserInfoCache.UserRoleName = u.UserRole.Name;                
                getUserInfoCache.ContactId = u.ContactId;
            }
		}
        return getUserInfoCache;
    }
    
    global class Info{
        global UserInfoWrapper UserInfo {get;private set;}                
        global SiteInfoWrapper SiteInfo {get;private set;}
        public Info(){
            UserInfo = getUserInfo();
            SiteInfo = new SiteInfoWrapper();
        }
    }
    
    global class Error{
        @AuraEnabled
        global string message{get;set;}
        @AuraEnabled
        global string staticTrace{get;set;}
        @AuraEnabled
        global string[] fields{get;set;}
        
        public Error(){}
        public Error(string message){this.message = message; this.staticTrace = null; this.fields = null;}
        public Error(string message, string staticTrace){this.message = message; this.staticTrace = staticTrace; this.fields = null;}
        public Error(string message, string staticTrace, string[] fields){this.message = message; this.staticTrace = staticTrace; this.fields = fields;}
        public Error(Database.Error ex){ this.message = ex.getMessage(); this.fields = ex.getFields(); this.staticTrace = string.valueOf(ex.getStatusCode()); }
    }
    
    public void addError(Exception ex){this.errors.add(new Error(ex.getMessage(), ex.getStackTraceString(), null));}
    public void addError(Database.Error ex){this.errors.add(new Error(ex));}    
    public void addError(string message){this.errors.add(new Error(message));}
    public void addError(string message, string staticTrace){this.errors.add(new Error(message, staticTrace));}
    public void addError(string message, string staticTrace, string[] fields){this.errors.add(new Error(message, staticTrace, fields));}
    public string toJSON(){ return JSON.serialize(this); }
}