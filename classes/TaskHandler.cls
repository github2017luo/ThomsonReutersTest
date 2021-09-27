public Class TaskHandler{


    public static void PopulateActivityTypeonEmail(List<Task> listtasks){
        
                    user currentuser= new User();
                    currentuser=[Select Id,Sub_Bu__c from User where Id=:userinfo.getuserId()];
                    if(LCRMGenericComponent.validateUserBU(currentuser.Sub_Bu__c)){
                        for(Task tasksubbu:listtasks){
                       
                            /*if(tasksubbu.LCRM_Sub_BU__c == null || tasksubbu.LCRM_Sub_BU__c ==''){
                                tasksubbu.LCRM_Sub_BU__c=currentuser.Business_Unit__c;
                            } */
                            
                            if(tasksubbu.Type=='Email' && (currentuser.Sub_Bu__c=='Elite' || currentuser.Sub_Bu__c=='UKI')){
                                tasksubbu.LCRM_Activity_Type__c= 'Email Outbound';
                                
                                }
                        }
                    } 
     
             
     }





















}