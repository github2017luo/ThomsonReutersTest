public without sharing class ESC_EliteContactNoUpdateCtlr{
    public  Contact con = new Contact();
    public String contNumber{get;set;}
    public Boolean showBtn{get;set;}
    public ESC_Create_Contact_Number__c createConNum;
    String idConURL;
    public ESC_EliteContactNoUpdateCtlr(ApexPages.StandardController controller) {
        showBtn=false;
        idConURL=ApexPages.currentPage().getParameters().get('id');
        if((Schema.sObjectType.Contact.isAccessible() || Schema.sObjectType.Contact.isQueryable())){
          con = [SELECT Id,ESC_Contact_Number__c from Contact WHERE Id = :idConURL];
          
        }
    }
 
    public  pagereference updateNum(){
        createConNum = ESC_Create_Contact_Number__c.getValues('Contact Number');
         try{
        
            if((con.ESC_Contact_Number__c==null || con.ESC_Contact_Number__c=='') && createConNum !=null && createConNum.ESC_Contact_Number__c!=null ){
                    updateContactNumber(createConNum.ESC_Contact_Number__c);
                    
                
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Contact Number already exist on Contact.Please close the tab.');
                ApexPages.addMessage(myMsg);
                return null;
            }
        }catch(Exception ex){
        
            system.debug('Exception : ' + ex.getMessage() + ':' + ex.getLineNumber());
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        PageReference parentPage = new PageReference('/' + idConUrl);
        parentPage.setRedirect(true);
        return parentPage;
    }
    
    public void updateContactNumber(string contactNumber){
    integer incrementConNumber;
    
    con.ESC_Contact_Number__c = contactNumber;
    if((Schema.sObjectType.Contact.isAccessible() || Schema.sObjectType.Contact.isUpdateable())){
        update con;
    }
    updateuser();                
                     
       incrementConNumber = integer.valueOf(contactNumber) +1;
            createConNum.ESC_Contact_Number__c =''+incrementConNumber;
            if((Schema.sObjectType.ESC_Create_Contact_Number__c.isAccessible() || Schema.sObjectType.ESC_Create_Contact_Number__c.isUpdateable())){
                update createConNum;
                
            }
                    
        
    }
    public void updateuser(){
    List<User> u =new List<User>();
        
    if(Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isQueryable()){
            u = [SELECT ID, ContactId, Contact.Firstname,FederationIdentifier,Contact.Lastname, ProfileId, Profile.Name FROM User WHERE ContactID = :idConURL LIMIT 1];
       }
       system.debug('@@ user u : ' + u);
       if(u!=null && u.size() >0 && (u[0].FederationIdentifier ==null || u[0].FederationIdentifier =='') && (Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isUpdateable())){
           u[0].FederationIdentifier = string.valueOf(createConNum.ESC_Contact_Number__c);
           update u[0];
       }
       
       
    }
}