public with sharing class OpportunityPricingCreateController {

    public List<Opportunity_Product_Type__c> listOpportunityPricing{get;set;}
    public Id OpportunityId;
    public Map<Integer,Opportunity_Product_Type__c> mapOpportunityPricingtoInsert = new map<Integer,Opportunity_Product_Type__c>();
    

    public OpportunityPricingCreateController(ApexPages.StandardController controller) {
       OpportunityId = ApexPages.currentpage().getParameters().get('OpportunityId');
       listOpportunityPricing = new List<Opportunity_Product_Type__c>();
    
       
       listOpportunityPricing.add(new Opportunity_Product_Type__c (Opportunity__c = OpportunityId ));
       listOpportunityPricing.add(new Opportunity_Product_Type__c (Opportunity__c = OpportunityId));
       listOpportunityPricing.add(new Opportunity_Product_Type__c (Opportunity__c = OpportunityId));
       
}
     public pagereference Save(){
     try{
         System.debug(AppUtil.IsEmpty(listOpportunityPricing[0].Product_Category__c)+'*****');
         if(AppUtil.IsEmpty(listOpportunityPricing[0].Product_Category__c)){ 
           throw new customException('Atleast one Product Category is required.');
         
         }else{

             mapOpportunityPricingtoInsert.put(0,listOpportunityPricing[0]);
         }
         
         for(Integer i=1; i<listOpportunityPricing.size(); i++){ 
           if(AppUtil.IsEmpty(listOpportunityPricing[i].Product_Category__c) &&
               (!AppUtil.IsEmpty(listOpportunityPricing[i].Product_Type__c) || listOpportunityPricing[i].Incremental_Amount__c!=null || 
               listOpportunityPricing[i].Renewal_Amount__c!=null)){
                   Integer j = i+1;
                   throw new customException('Product Category is required for Opportunity Pricing '+j+'.');
           }else{
                if(!AppUtil.IsEmpty(listOpportunityPricing[i].Product_Category__c) ||
                     !AppUtil.IsEmpty(listOpportunityPricing[i].Product_Type__c) || listOpportunityPricing[i].Incremental_Amount__c!=null || 
               listOpportunityPricing[i].Renewal_Amount__c!=null){
                 mapOpportunityPricingtoInsert.put(i,listOpportunityPricing[i]);
              }
           }
         
         }
         if(!mapOpportunityPricingtoInsert.IsEmpty()){
         Insert mapOpportunityPricingtoInsert.values();
        }
        
     }catch(Exception oException){
       ApexPages.addMessages(oException);
       return null;
     }
     return new Pagereference('/'+OpportunityId );
    }
   

    public pagereference Cancel(){
            return new Pagereference('/'+OpportunityId ); 
    }

    public pagereference SaveandNew(){
             save();
             mapOpportunityPricingtoInsert.clear();
             listOpportunityPricing.clear();
             listOpportunityPricing.add(new Opportunity_Product_Type__c (Opportunity__c = OpportunityId ));
             listOpportunityPricing.add(new Opportunity_Product_Type__c (Opportunity__c = OpportunityId));
             listOpportunityPricing.add(new Opportunity_Product_Type__c (Opportunity__c = OpportunityId));  
             return new Pagereference('/apex/OpportunityPricingCreate?OpportunityId='+OpportunityId );
    }
    
    public void Addmore(){
        listOpportunityPricing.add(new Opportunity_Product_Type__c (Opportunity__c = OpportunityId ));
    }
    public class customException extends Exception{}
}