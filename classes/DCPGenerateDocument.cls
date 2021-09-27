/********************************************************************************
Class Name : DCPGenerateDocument
@description : This class is used to generate Document.
***************************************************************************************

Modification Details
Date                  Description                                            Owner
19/05/2021            Class Created                                          By Herin Acharya
09/08/2021            Added logic to use Findlaw order form                  Benjamin Her
*********************************************************************************/
public without sharing class DCPGenerateDocument {

    private static boolean isFindlaw = false;
       /**
    @description call the conga generate document method
    @param requestBody will contain "cartId" as a parameter.
    @return Returns string in case of success OR thows execption in case of failure
    */
    public static string generateDoc(Map<String,String> requestBody){
        String generatedDocId = '';

        if(requestBody.containskey('proposalId') && !String.isBlank(requestBody.get('proposalId'))){
            try {
                Id proposalId = Id.valueOf(requestBody.get('proposalId'));
                
                //Added to check weather cart is finalized or not
                Boolean isFinalized = isCartFinalized(proposalId);
                if(!isFinalized){
                    return ('CartNotFinalized');
                }
                // Cheking if template is available or not

                Id templateId = getTemplateId();
                if(templateId == null){
                    return('TemplateNotFound');
                }
                else{
                    String accessLevel = 'Read only';
                    String docFormat = 'PDF';
                    String apiServerURL = System.Url.getSalesforceBaseUrl().toExternalForm() + 
                                        '/services/Soap/u/51.0/' + UserInfo.getOrganizationId();
                    String sessionId = UserInfo.getSessionId();
                    
                    
                  

                    generatedDocId = Apttus_Proposal.MergeWebService.generateDoc(templateId,proposalId,
                                                                            accessLevel, docFormat, 
                                                                            sessionId, apiServerURL);
                    return ('Success');

                }               
            } catch (Exception ex) {
                
                
               throw new DCCustomException(ex.getStackTraceString()); 
                
            }
        }else{
            return('ImproperRequestFormat');
        }
    }

    private static Id getTemplateId(){
        list<Apttus__APTS_Template__c > templateList = new list<Apttus__APTS_Template__c > ();       

        String orderFormName = (isFindlaw) ? System.Label.Digital_FOF : System.Label.Digital_OF;

        if (Schema.sObjectType.Apttus__APTS_Template__c.isAccessible()) {
            templateList = [SELECT Id FROM Apttus__APTS_Template__c
                WHERE Name =: orderFormName
                AND Apttus__IsActive__c = TRUE LIMIT 1
            ];

            if(templateList.size() > 0){
                return templateList[0].id;
            }else{
                return null;
            }
        }else{
            return null;
        }
    }
    
    private static boolean isCartFinalized(Id proposalId){
        
       List<Apttus_Config2__ProductConfiguration__c> listCart = new List<Apttus_Config2__ProductConfiguration__c>();
       listCart  = [Select Id,Apttus_Config2__Status__c,APTS_Proposal_Business_Unit__c from Apttus_Config2__ProductConfiguration__c 
                    where Apttus_QPConfig__Proposald__c =:proposalId and
                    Apttus_Config2__Status__c = 'Finalized' WITH SECURITY_ENFORCED limit 1];
       
       if(!listCart.isempty()){
           isFindlaw = listCart[0].APTS_Proposal_Business_Unit__c == 'FindLaw' ? true : false;
           return true;
       }else{
           return false;
       }
        
    }

}