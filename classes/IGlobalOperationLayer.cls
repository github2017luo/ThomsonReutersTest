/*** Interface 
/*** @Author: Harika Sai P And Divija Deepthi
/*** Created Date: 29 MAR 2019
/*** Purpose: This is an interface used for all generic operations as part of the framework.
/*** JIRA : DLT-15694 Create Global Data Layer - All our Sobjects operation should go with this layer */
/*** Change History  ******************************************************************************************************/
/*** Modified By    Modified Date    JIRA    
/*** HArika Sai P   24-06-2019       DLT-16854 [Tech Story] - Remove Unnecessary code lines from Proposal Automation and move to Dataoperation Layer*/
/**************************************************************************************************************************/

public interface IGlobalOperationLayer{

    //Generate PDF Document for the proposal using apttus mergeWebService.
    Id generatePDFDocument(Id templateId,Id quoteId,string exObjType); 
    // Created an Evnelope and sends it to DocuSign for each proposal in the list which is passed into this method
    void createEnvelopes(List<Apttus_Proposal__Proposal__c> listQuotes,string exObjType);
    //Performs bundling
    void performBundling(String groupId, List<Apttus_Config2__ProductConfiguration__c> configList,string exObjType);
    // finalizes cartf or Digital as of now
    void finalizeCart(ID cartId,string exObjType);
    // map to lookup opportunity owner based on Digital Firm value
    Id setTheDigitalOwnerAppSegment(string strDigtlFrm);//DLT-16854 Moved this method from digital classes to Layer.
    
}