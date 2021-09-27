/**********************************************************************
Copyright @ 2019 TATA CONSULTANCY SERVICES.
---------------------------------------------------------------------------------------
Author, Navpreet Kaur
----------------------------------------------------------------------------------------
Purpose : Callback class to 
**********************************************************************/
global with sharing class APTS_ProductAttributeCallback implements Apttus_Config2.CustomClass.IProductAttributeCallback {
    
    //String userdetail;
    public Apttus_Config2__ProductConfiguration__c cartRec;
    /**
    * Callback at the beginning of the attribute call.
    * Use the start method to initialize state
    * @param cart the cart object
    */
    global void start(Apttus_Config2.ProductConfiguration cart) 
    {
        System.debug(' Product Attribute Callback Start method called');
        System.debug(' cart '+cart);
        /*userdetail = [Select Segment__c From User Where Id = :UserInfo.getUserId()][0].Segment__c;
        System.debug('userdetail : '+userdetail);*/
        cartRec = cart.getConfigSO();
    }
    
    /**
    * Callback to set defaults for the new product attribute value sobject
    * @param parentItem the parent line item associated with the product attribute value
    * @param attrValueSO the product attribute value sobject to set defaults for
    */
    global void setDefaults(Apttus_Config2.LineItem parentItem, Apttus_Config2__ProductAttributeValue__c attrValueSO) {
        // default based on quote type
        system.debug('SET Defaults');
        System.debug('parentItem '+parentItem);       
        System.debug('attrValueSO '+attrValueSO);  
        
        

        try
        {
            Apttus_Config2__LineItem__c lineItem=parentItem.getLineItemSO();
            Id parentIds= lineItem.id;
            system.debug('PBU'+lineItem.APTS_Proposal_Business_Unit__c);
            system.debug('PBU1'+lineItem);
            system.debug('ConfigPBU'+cartRec.APTS_Proposal_Business_Unit__c);
            //if(userdetail == 'Professional Tax' && userdetail != null)
            if(cartRec.APTS_Proposal_Business_Unit__c == 'Tax Professional')
            {
            system.debug('Line Item ID '+parentIds);
            
        List<String> listProductCode=new List<String>();
        List<APTS_Bundle_Variant__c> bundleVariant = new List<APTS_Bundle_Variant__c>();
        List<APTS_Product_Variant__c> productVariant = new List<APTS_Product_Variant__c>();
        Apttus_Config2__LineItem__c getLines;
            
        /*
        String queryEditor='select id,APTS_Proposal_Business_Unit__c,APTS_Product_Code__c,Apttus_Config2__ProductId__c,Apttus_Config2__LineType__c,Apttus_Config2__OptionId__c,Apttus_Config2__OptionId__r.ProductCode,Apttus_Config2__HasOptions__c from Apttus_Config2__LineItem__c where id=\''+parentIds+'\' LIMIT 1';
        */
        if(Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()&&Schema.sObjectType.Apttus_Config2__LineItem__c.isQueryable()){
        getLines=[select id,APTS_Proposal_Business_Unit__c,APTS_Product_Code__c,Apttus_Config2__ProductId__c,Apttus_Config2__LineType__c,Apttus_Config2__OptionId__c,Apttus_Config2__OptionId__r.ProductCode,Apttus_Config2__HasOptions__c from Apttus_Config2__LineItem__c where id=: parentIds /*and APTS_Proposal_Business_Unit__c = 'Tax Professional'*/ LIMIT 1];}
        
        //Apttus_Config2__LineItem__c getLines=Database.query(queryEditor);
        
        String parentProductCode=getLines.APTS_Product_Code__c;
        String optionProductCode=getLines.Apttus_Config2__OptionId__r.ProductCode;
        
        system.debug('Option Product Code: '+optionProductCode);
        system.debug('Parent Product Code: '+parentProductCode);
         system.debug('Business Unit: '+getLines.APTS_Proposal_Business_Unit__c);
        
        listProductCode.add(parentProductCode);
        listProductCode.add(optionProductCode);
        system.debug('List of Product Codes: '+listProductCode);
        if(listProductCode !=null && listProductCode.size()>0)
        {
            if(Schema.sObjectType.APTS_Bundle_Variant__c.isAccessible()&&Schema.sObjectType.APTS_Bundle_Variant__c.isQueryable() && getLines.APTS_Proposal_Business_Unit__c == 'Tax Professional'){
            bundleVariant=[select id,Name,APTS_Bundle_Product_Delivery__c,APTS_Component_Product_Delivery__c,APTS_Component_Product_EPMID__c from APTS_Bundle_Variant__c  where Name in :listProductCode];}
        
        //Product Variant
            if(Schema.sObjectType.APTS_Product_Variant__c.isAccessible()&&Schema.sObjectType.APTS_Product_Variant__c.isQueryable() && getLines.APTS_Proposal_Business_Unit__c == 'Tax Professional'){
            productVariant=[select id,Name,APTS_Product_Delivery__c,APTS_Product_ID__c,APTS_Product_Variant_ID__c from APTS_Product_Variant__c where APTS_Product_ID__c IN :listProductCode];}
        }
        
        system.debug('Bundle Variant Data: '+bundleVariant);
        system.debug('Product Variant Data: '+productVariant);
       
        
        if(bundleVariant!=null && bundleVariant.size()>0 && getLines.APTS_Proposal_Business_Unit__c == 'Tax Professional')
        {
            system.debug('Inside IF ');
            for(APTS_Bundle_Variant__c bundle :bundleVariant)
            {
                system.debug('Inside FOR ');
                if(getLines.Apttus_Config2__HasOptions__c==true && getLines.APTS_Product_Code__c==bundle.Name)
                {
                    system.debug('Inside IF Inner Product Check ');
                    attrValueSO.Tax_Prof_Bundle__c=bundle.APTS_Bundle_Product_Delivery__c;
                    system.debug('Attribute Value Main Bundle: '+attrValueSO);
                }
                else if(getLines.Apttus_Config2__HasOptions__c==false&& getLines.Apttus_Config2__OptionId__r.ProductCode==bundle.APTS_Component_Product_EPMID__c)
                {
                    system.debug('Inside IF Inner Option Check ');
                    attrValueSO.Tax_Prof_Product_Delivery_Online_Intern__c=bundle.APTS_Component_Product_Delivery__c;
                    system.debug('Attribute Value Option Line: '+attrValueSO);
                }
            }
            
        }
        //DOC-9328: 
        if(productVariant!=null && productVariant.size()>0 && getLines.APTS_Proposal_Business_Unit__c == 'Tax Professional')
        {
            system.debug('Size of PV = '+productVariant.size());
            if(productVariant.size() == 1)
            {
                for(APTS_Product_Variant__c prodVariant :productVariant){
                if(prodVariant.APTS_Product_Delivery__c == 'Download'){
                attrValueSO.Tax_Prof_Download__c =  prodVariant.APTS_Product_Delivery__c;
                }
                else if(prodVariant.APTS_Product_Delivery__c == 'eBook'){
                attrValueSO.Tax_Prof_eBook__c = prodVariant.APTS_Product_Delivery__c;
                }
                else if(prodVariant.APTS_Product_Delivery__c == 'e-Flex'){
                attrValueSO.Tax_Prof_e_Flex__c = prodVariant.APTS_Product_Delivery__c;
                }
                else if(prodVariant.APTS_Product_Delivery__c == 'HTML'){
                attrValueSO.Tax_Prof_HTML__c = prodVariant.APTS_Product_Delivery__c;
                }
                else if(prodVariant.APTS_Product_Delivery__c == 'Online/Internet'){
                attrValueSO.Tax_Prof_Product_Delivery_Online_Intern__c = prodVariant.APTS_Product_Delivery__c;               
                }
                else if(prodVariant.APTS_Product_Delivery__c == 'PDF'){
                attrValueSO.Tax_Prof_PDF__c = prodVariant.APTS_Product_Delivery__c;
                }
                else if(prodVariant.APTS_Product_Delivery__c == 'Softbound'){
                attrValueSO.Tax_Prof_Softbound__c = prodVariant.APTS_Product_Delivery__c;
                }
                else if(prodVariant.APTS_Product_Delivery__c == 'Pick 5'){
                attrValueSO.APTS_CPChoice_Pick5__c = prodVariant.APTS_Product_Delivery__c;
                }
            system.debug('Attribute Value: '+attrValueSO);
            }
            }
        }
        }
        
        
        
        }
        catch(Exception e) 
        {
                    System.debug('PAB: setDefaults error ' + e.getMessage() );
        }
        
    }
    
    /**
    * Callback after all batches of product attributes are processed
    * Use the finish method to release state
    */
    global void finish() {
        // do nothing
        System.debug(' Product Attribute Callback finish method called');
    }
}