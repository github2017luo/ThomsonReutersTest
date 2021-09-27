public with sharing class APTS_ProductAttributeValueTriggerHelper { 
    public static void setLineItemFieldsPA(List<Apttus_Config2__ProductAttributeValue__c> PANewObjects)
    {
        List<Apttus_Config2__ProductAttributeValue__c> getPAValues=new List<Apttus_Config2__ProductAttributeValue__c>();
        List<Apttus_Config2__LineItem__c> getLines= new List<Apttus_Config2__LineItem__c>();
        List<APTS_Product_Variant__c> detailsVariant= new List<APTS_Product_Variant__c>();
        Set<String> productDelivery=new Set<String>();
        List<Id> parentIds=new List<Id>();
        String AttrValueRecord;
        
        /*Populate fields on line items Code starts here*/
        
        for(Apttus_Config2__ProductAttributeValue__c PAValues:PANewObjects)            
        {   
            System.debug('PBU Value = '+PAValues.APTS_Proposal_Business_Unit_PAV__c);
            
            if(PAValues.APTS_Proposal_Business_Unit_PAV__c == 'Tax Professional')
            {
                Map<String, Object> fieldToValue = PAValues.getPopulatedFieldsAsMap();
             for (String str : fieldToValue.keyset()) 
             { 
                 System.debug('Value of the field = ' + str);
                 if((str!= 'lastmodifieddate') && (str!= 'id') && (str != 'systemmodstamp') && (str!= 'CreatedDate') && (str!= 'CreatedById') && (str!= 'CurrencyIsoCode') && (str!= 'IsDeleted') && (str!= 'LastModifiedById') && (str!= 'Apttus_Config2__LineItemId__c') && (str!= 'Name') && (str!= 'LastReferencedDate') && (str!= 'LastViewedDate') && (str!= 'LastActivityDate') && (str!= 'Name') && (str!='Apttus_Config2__IsTransient__c') && (str!='APTS_PPC_Mgmt_Fee_Override__c') && (str!='APTS_Proposal_Business_Unit_PAV__c') )
                 { 
                     if((fieldToValue.get(str)) != null)
                     {
                         AttrValueRecord = (String)fieldToValue.get(str);  
                        productDelivery.add(AttrValueRecord);
                         System.debug(str + '->' + fieldToValue.get(str)+'AttrValueRecord VAlue = '+AttrValueRecord);                                                                           
                     }
                     
                 } 
             }
             parentIds.add(PAValues.id);
         }
        }
        system.debug('*parentIds ='+ parentIds);
        system.debug('*Product Delivery = '+ productDelivery);
        try
        {
            if(Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()&&Schema.sObjectType.Apttus_Config2__LineItem__c.isQueryable()&& parentIds != null && parentIds.size()>0){
                getLines=[select id,Apttus_Config2__LineType__c, Apttus_Config2__ProductOptionId__r.Apttus_Config2__ComponentProductId__r.ProductCode, APTS_Proposal_Business_Unit__c,Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__AttributeValueId__r.APTS_Product_Delivery__c,APTS_Auto_Renew_Price_Basis__c,APTS_Renewal_Type__c,APTS_Product_Variant_ID__c,APTS_Product_Delivery__c,APTS_CUAS1__c from Apttus_Config2__LineItem__c where Apttus_Config2__AttributeValueId__c IN :parentIds AND APTS_Proposal_Business_Unit__c = 'Tax Professional' ];
            }
            system.debug('*Line Items = '+ getLines);
            
            
            List<String> productCode=new List<String>();
            
            if(getLines!=null && getLines.size()>0){ 
                for(Apttus_Config2__LineItem__c lines:getLines)
                {
                    if(lines.Apttus_Config2__LineType__c == 'Product/Service')
                    {
                        productCode.add(lines.Apttus_Config2__ProductId__r.ProductCode);
                    }
                    else if(lines.Apttus_Config2__LineType__c == 'Option')
                    {
                        productCode.add(lines.Apttus_Config2__ProductOptionId__r.Apttus_Config2__ComponentProductId__r.ProductCode);
                    }
                    
                    
                }
                
            }
            
            system.debug('*Product Code ='+ productCode);
            if(Schema.sObjectType.APTS_Product_Variant__c.isAccessible()&&Schema.sObjectType.APTS_Product_Variant__c.isQueryable() && productDelivery != null && productDelivery.size()> 0 ){    
                detailsVariant=[select id,APTS_Product_ID__c,APTS_Product_Delivery__c,APTS_Auto_Renew_Price_Basis__c,APTS_Auto_Renew_Price_Percentage__c, APTS_Bridge_Eligibility__c,APTS_Partial_Year_Charge_Eligible__c,APTS_Renewal_Type__c,APTS_Product_Variant_ID__c,APTS_CUAS1__c from APTS_Product_Variant__c where APTS_Product_ID__c IN :productCode and APTS_Product_Delivery__c IN :productDelivery ];
            }
            system.debug('*Product Variants = '+ detailsVariant);
            
            
            List<Apttus_Config2__LineItem__c> updateLines=new List<Apttus_Config2__LineItem__c>();
            
            if(detailsVariant!=null && detailsVariant.size()>0 && getLines!=null && getLines.size()>0)
            {    
                system.debug('*Inside IF block for updating LIne Items');
                for(Apttus_Config2__LineItem__c line:getLines) //L1B, L2O1, L3O2
                {
                    system.debug('*Inside for Line items line == '+line);
                    for(APTS_Product_Variant__c items:detailsVariant) //P1B, P2O1, P3O2
                    {
                        for(String pavValue: productDelivery)//PD1B, PD2O
                        {
                        system.debug('*pavValue =='+pavValue);
                        system.debug('*LineItem Option Product Code '+line.Apttus_Config2__ProductOptionId__r.Apttus_Config2__ComponentProductId__r.ProductCode);
                        system.debug('*LineItem Bundle Product Code '+line.Apttus_Config2__ProductId__r.ProductCode);
                        system.debug('*Inside for Line items items.APTS_Product_ID__c =='+items.APTS_Product_ID__c);
                        system.debug('*Inside Product Variant Items =='+items);
                        if(((line.APTS_Proposal_Business_Unit__c=='Tax Professional' && line.Apttus_Config2__LineType__c == 'Product/Service' && line.Apttus_Config2__ProductId__r.ProductCode == items.APTS_Product_ID__c) || (line.Apttus_Config2__LineType__c == 'Option' && line.Apttus_Config2__ProductOptionId__r.Apttus_Config2__ComponentProductId__r.ProductCode == items.APTS_Product_ID__c)) && /*line.testAttr1__c*/ pavValue == items.APTS_Product_Delivery__c)
                        {
                            system.debug('*Inside if main check before'+line);
                            
                            line.APTS_Auto_Renew_Price_Basis__c=items.APTS_Auto_Renew_Price_Basis__c;
                            line.APTS_Auto_Renew_Price_Percentage__c=items.APTS_Auto_Renew_Price_Percentage__c;
                            line.APTS_Bridge_Eligibility__c=items.APTS_Bridge_Eligibility__c;
                            line.APTS_Partial_Year_Charge_Eligible__c=items.APTS_Partial_Year_Charge_Eligible__c;
                            line.APTS_Renewal_Type__c=items.APTS_Renewal_Type__c;
                            line.Apttus_product_variant__c=items.id;
                            line.APTS_Product_Variant_ID__c = items.APTS_Product_Variant_ID__c;
                            line.APTS_Product_Delivery__c = items.APTS_Product_Delivery__c;
                            line.APTS_CUAS1__c = items.APTS_CUAS1__c;
                            
                            updateLines.add(line);
                            system.debug('*Inside if main check after update'+line);
                            
                        }
                    }
                    }
                }
            }
            system.debug('Line Item Information'+getLines);
            
            if(updateLines!= null && updateLines.size() > 0) 
            {
                update updateLines;
            } 
        }
        catch(Exception e) 
        {
            System.debug('setLineItemFieldsPA error ' + e.getMessage() );
        }
        /*Populate fields on line items Code ends here*/
    }
}