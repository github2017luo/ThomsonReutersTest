/* Class: TRStore_CreateProposalApexQueue
* Purpose: Queueable Job to create proposal records for three different sites like USL, Tax Professional, Canada
* Created: 05/27/2020
* Author: Avudaiappan A
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2020-05-27   Avudaiappan A     DUE-2952   Creating a queueable class to run the rest API for create proposal records in a threshold limit
* 2021-05-24   Avudaiappan A     DCP-1982   Code Refactoring for USL Support and PMD
* =============================================================================
*/
/********************************************************************************************************
    *  @description  TRStore_CreateProposalApexQueue - QueueJob to Create the proposal record in UE Proposal Object
*********************************************************************************************************/
    
public class TRStore_CreateProposalApexQueue implements Queueable {
  private integer threshold;
    private string priceListName;
    private  string site;
    private  boolean isAllSite = false;
/********************************************************************************************************
    *  @description  TRStore_CreateProposalApexQueue - Constructor
    *  @param site - site to be coming in
*********************************************************************************************************/
 
    public TRStore_CreateProposalApexQueue (string site){
        
        threshold = Integer.valueof(static_values__c.getValues('thresholdLimit').value__c);
        this.site = site;
        if(String.isNotBlank(site) && site == 'All'){
            isAllsite = true;
        }  
        priceListName = (string.isnotBlank(site) &&(site.equalsIgnoreCase('UECAPR') || site.equalsIgnoreCase('All')) )?Static_Values__c.getValues('TRStorePricelistCA').Value__c:Static_Values__c.getValues('PriceListName').Value__c;
        
    }
/********************************************************************************************************
    *  @description  execute - Execute method to compile the logic
    *  @param context - batch
*********************************************************************************************************/
 
    public void execute(QueueableContext context) {
        if(isAllSite){
            TRStore_CreateProposalAPI.createProposal(priceListName,threshold, 'UECAPR');
             priceListName = Static_Values__c.getValues('PriceListName').Value__c;
           
             TRStore_CreateProposalAPI.createProposal(priceListName,threshold, 'UEUSTP');
        } else if(this.site == 'UEUSPR'){
            TRStore_CreateProposalAPI.createProposal(priceListName,threshold, 'UEUSPR');
        } else{
             TRStore_CreateProposalAPI.createProposal(priceListName,threshold, site);
   
            }
      }
    

}