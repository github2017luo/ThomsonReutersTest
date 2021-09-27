/**============================================================================================
    Name                : ODTTrialManageResponseWrapper
    Description         : This class is developed as part of CXD-ODT project :DLT-13384,DLT-13386
                          It serves as a wrapper class for the Extend and End Trial Service wherein we are 
						  passing the details required for extension or end trial to OLC via ESI.
    Created Date        : 11/1/2018
    Author              : Ameeta Antonio
    Modification History:
    Date           Name                    Description
    11/1/2018     Ameeta Antonio            Created
==============================================================================================**/
public class ODTTrialManageResponseWrapper {

    public List<OnlineContact> onlineContact;       
    public String context;      
    public ESIHeader ESIHeader = new ESIHeader();
    
    public class OnlineContact {            
    public List<Entitlements> entitlements;         
    public String contactNumber;            
    public Account account = new Account();     
    }   
    
    public class Account {          
    public String accountNumber;
      
    }           
    
    public class Subscriptions {            
    public String trialReasonCode;          
    public String trialEndDate;         
    public String offerId;          
    public String dataOwner;        
    }       
    
    public class ExtensibleAttributes {         
    public String value;            
    public String key;      
    }       
    
    public class Entitlements {         
    public Subscriptions subscriptions = new Subscriptions();           
    public ExtensibleAttributes extensibleAttributes = new ExtensibleAttributes();      
    }       
    
    public class ESIHeader {            
    public String applicationId;        
    }       

}