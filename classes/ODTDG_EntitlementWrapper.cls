/********************************************************************************************************
*  
*  @description ODTDG_EntitlementWrapper : wrapper class to send as resp
*********************************************************************************************************/
@SuppressWarnings('PMD.AvoidGlobalModifier') 
global class ODTDG_EntitlementWrapper {

    public List<ODTDG_CustomerData.Error> errors;
    public StatusResp status;
    public RespDetails sfdcDetails;


   /* public Ent_Trial__c trialData;
    public List<Trial_Product__c> trialProdData;
    public List<Trial_Contact__c> trialContactsData;
    public List<Lead_Trial__c> leadTrailrecord;
    
    public  ODTDG_EntitlementWrapper(Ent_Trial__c e, List<Trial_Product__c> p, List<Trial_Contact__c> c, List<Lead_Trial__c> lt){           
        
        this.trialData = e;            
        this.trialProdData = p;
        this.trialContactsData = c;
        this.leadTrailrecord = lt;
    } */
/********************************************************************************************************
*  
*  @description ODTDG_EntitlementWrapper : constructor 
*********************************************************************************************************/

    public ODTDG_EntitlementWrapper(){

        errors = new List<ODTDG_CustomerData.Error>();

    }

/********************************************************************************************************
*  
*  @description StatusResp : response of status  
*********************************************************************************************************/

    public class StatusResp{
        public string respCode;
        public string respMsg;
        
/********************************************************************************************************
*  
*  @description StatusResp : constructor response of status  
*********************************************************************************************************/

        public StatusResp(){
            respCode ='';
            respMsg = '';
        }
        
    }

/********************************************************************************************************
*  
*  @description RespDetails :  response of record details   
*********************************************************************************************************/
public class RespDetails{
        public string trialId;
        public string entitleJobId;
        public list<TrialContacts> trialContacts;
    	public list<TrialProducts> trialProducts;
/********************************************************************************************************
*  
*  @description RespDetails :  constructor response of record details   
*********************************************************************************************************/
        
        public RespDetails(){
            trialId = '';
            entitleJobId ='';
            trialContacts = new list<TrialContacts>();
            trialProducts = new list<TrialProducts>();
        }
    }

/******************************************************************************************************** 
*  @description TrialContacts :  response of record details   
*********************************************************************************************************/
    public class TrialContacts{
        public String trialContactSfId;
        public string customerEmail;
        public string conStatus;
/******************************************************************************************************** 
*  @description TrialContacts :  constructor response of record details   
*********************************************************************************************************/
        public TrialContacts(){
            trialContactSfId = '';
            customerEmail = '';
            conStatus = '';
        }
    }
    
/******************************************************************************************************** 
*  @description TrialProducts :  response of record details   
*********************************************************************************************************/
    public class TrialProducts{
        public String trialProductSfId;
        public string productCode;
/******************************************************************************************************** 
*  @description TrialProducts :  constructor response of record details   
*********************************************************************************************************/
        public TrialProducts(){
            trialProductSfId = '';
            ProductCode = '';
        }
    }


}