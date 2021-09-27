/**
    @description Proposal data layer class for DCP projects.
    CHANGE HISTORY
    ================================================
    Date            Developer           Description
    2021-04-14      Benjamin Her        DCP-1414 Initial Creation
    2021-07-19      Vishnu Santhosh     DCP-2144 Added 'getProposalLineItems' method
 */
public without sharing class DCPProposal{
    public static final string STAGE_PRESENTED = 'Presented';
    public static final string LINESTATUS_NEW = 'New';
    
    /**
        @description Stores the queried proposal
     */
    public static List<Apttus_Proposal__Proposal__c> propList;

    /**
        @description Stores the queried proposal
     */
    public static List<Apttus_Proposal__Proposal_Line_Item__c> lineItemsList;
    
    /**
        @description Run queries on Proposal object
        @param propIds List of proposal ids to query
        @return Returns the queried proposal
     */
    public static List<Apttus_Proposal__Proposal__c> getProposal(List<id> propIds){
        propList=   
                [SELECT id, Apttus_Proposal__Primary__c,APTS_Approval_Segment__c,APTS_Payment_Option__c,DocuSign_Envelope_ID__c, 
                (SELECT id, APTS_Current_Holdings__c FROM Apttus_QPConfig__Configurations__r WHERE Apttus_Config2__Status__c = 'Finalized')
                FROM Apttus_Proposal__Proposal__c
                WHERE id IN : propIds
                WITH SECURITY_ENFORCED];
                
        return propList;
    }    
    /**
        @description Run queries on Proposal object
        @param oppId Opportunity Id used to filter
        @param ssdId SSD Id used to filter
        @return Returns the presented proposal from Opp and SSD
     */
    public static List<Apttus_Proposal__Proposal__c> getPresentedProposal(Id oppId, Id ssdId){
        propList=   
                [SELECT id, Apttus_Proposal__Primary__c, APTS_Approval_Segment__c,Display_in_CXD_Renewals__c,DocuSign_Envelope_ID__c,Digital_Quote_Type__c, APTS_Payment_Option__c, CurrencyIsoCode
                FROM Apttus_Proposal__Proposal__c
                WHERE Apttus_Proposal__Opportunity__c =: oppId
                AND APTS_SSD_bill_to__c =: ssdId
                AND Apttus_Proposal__Approval_Stage__c =: STAGE_PRESENTED
                WITH SECURITY_ENFORCED];
                
        return propList;
    }    
    /**
        @description Run queries on Proposal object
        @param oppId Opportunity Id used to filter
        @param ssdId SSD Id used to filter
        @return Returns the presented proposal from Opp and SSD
     */
    public static List<Apttus_Proposal__Proposal__c> getPresentedProposalWithCart(Id oppId, Id ssdId){
        propList=   
                [SELECT id, Apttus_Proposal__Primary__c,APTS_Approval_Segment__c,APTS_Payment_Option__c, 
                (SELECT id, APTS_Current_Holdings__c FROM Apttus_QPConfig__Configurations__r WHERE Apttus_Config2__Status__c = 'Finalized')
                FROM Apttus_Proposal__Proposal__c
                WHERE Apttus_Proposal__Opportunity__c =: oppId
                AND APTS_SSD_bill_to__c =: ssdId
                AND Apttus_Proposal__Approval_Stage__c =: STAGE_PRESENTED
                WITH SECURITY_ENFORCED];
                
        return propList;
    }
    
    /**
    @description To retrieve proposal line items using proposal id.
    @param proposalId Id to query
    @return List of proposal line items
    */
    public static List<Apttus_Proposal__Proposal_Line_Item__c> getProposalLineItems(Id proposalId){
    lineItemsList = [   SELECT  Id, 
                                Name, 
                                Apttus_Proposal__Product__r.Name,
                                Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c,
                                Apttus_Proposal__Product__r.Id

                        FROM Apttus_Proposal__Proposal_Line_Item__c
                        WHERE Apttus_Proposal__Proposal__c=:proposalId
                        AND Apttus_QPConfig__LineStatus__c=:LINESTATUS_NEW
                        WITH SECURITY_ENFORCED];
    return lineItemsList;
    }

                        
    /**
        @description Updates Proposal object
        @param propUpdateList List of proposal ids to update
    
    public static void updateProposal(List<Apttus_Proposal__Proposal__c> propUpdateList){
        Database.SaveResult[] results = Database.update(propUpdateList,false);
    }
     */
    
}