global class LATAM_BatchToCreateindicator implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        string query = '';
        String st = String.valueOf(system.today());
        query=' select id,Name,Apttus_Proposal__Proposal_Name__c,OwnerId,Auto_Renewal_Quote__c,Apttus_Proposal__Opportunity__r.Source_System_Detail__c,APTS_SSD_bill_to__c, ';
        query+=' CurrencyIsoCode,APTS_SSD_Ship_to__c,APTS_SSD_Sold_To__c,APTS_Payer__c,';                
        query+=' APTS_Order_Confirmation_Contact__c,Apttus_Proposal__Primary_Contact__c,APTS_Approval_Segment__c,';                
        query+=' (select id, Related_Quote_Proposal__c ,APTS_Proposal_Business_Unit__c , Apttus_QPConfig__AssetLineItemId__r.Renewal_quote_created__c, ';
        query+='  Apttus_QPConfig__NetPrice__c, Apttus_QPConfig__AssetLineItemId__r.Apttus_QPConfig__ProposalId__c, ';
        query+='  Apttus_QPConfig__AssetLineItemId__r.APTS_SSD_Bill_To__c,Apttus_QPConfig__AssetLineItemId__r.APTS_SSD_Ship_to__c,APTS_SSD_ship_to__c,';
        query+='  Apttus_QPConfig__AssetLineItemId__r.APTS_Proposal_Business_Unit__c,Apttus_QPConfig__AssetLineItemId__r.APTS_SSD_Sold_To__c,';
        query+='  Apttus_QPConfig__AssetLineItemId__r.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__c , ';
        query+='  Apttus_QPConfig__AssetLineItemId__r.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Primary_Contact__c, ';
        query+='  Apttus_QPConfig__AssetLineItemId__r.Apttus_QPConfig__ProposalId__r.CurrencyIsoCode ';
        
        query+=' from Apttus_Proposal__R00N70000001yUfBEAU__r) ';
        query+=' from Apttus_Proposal__Proposal__c '; 
        query+=' where Apttus_Proposal__Approval_Stage__c=\'Draft\' and Apttus_QPConfig__IsSystemGenerated__c =true and DAY_ONLY(createdDate)= ' + st + ' and Apttus_Proposal__Proposal_Name__c Like \'%Renew%\' ';
        
        system.debug('Query'+query); 
        try{return Database.getQueryLocator(query);
           }catch(exception ex){
               system.debug('Error Message: '+ex.getMessage());
               system.debug('Error Cause'+ex.getCause());
               system.debug('Error Line Number'+ex.getLineNumber());
               system.debug('Error stack'+ex.getStackTraceString());
               return Database.getQueryLocator(query);
           }
    }
    
    global void execute(Database.BatchableContext bc,List<Apttus_Proposal__Proposal__c> proposalsRec){
        system.debug('###Inside Execute'+proposalsRec);
        String businessUnitOfRenewalQuote =''; 
        //RecordType rtCanada = [select Id from RecordType where Name = 'void Renewal Proposal' and SobjectType = 'Apttus_Proposal__Proposal__c' limit 1];        
        PriceBook2 priceBookCanada = [Select id, name From pricebook2 WHERE Name= 'TR Pricebook' LIMIT 1];
        
        List<Apttus_Config2__AssetLineItem__c> AssetsList =new List<Apttus_Config2__AssetLineItem__c>();
        Set<ID> AssetIds = new Set<ID>();              
        List<Apttus_Proposal__Proposal_Line_Item__c > listOfPropoLIS=new List<Apttus_Proposal__Proposal_Line_Item__c >();
        List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
        Set<Id> setOfOpptyID = new Set<ID>();
        List<Opportunity> listOfOppty = new List<Opportunity>();
        Map<Id,Apttus_Proposal__Proposal__c> mapOfOpptyIDProposal = new Map<Id,Apttus_Proposal__Proposal__c>();   
        try{
            
            if(proposalsRec.size()>0){               
                for(Apttus_Proposal__Proposal__c propObj : proposalsRec){                                      
                    system.debug('###Inside For Loop'+propObj.ID);
                    propObj.Auto_Renewal_Quote__c= true;
                    
                    system.debug('KS--> Proposal Name '+propObj.Apttus_Proposal__Proposal_Name__c);
                    if (propObj.Apttus_Proposal__Proposal_Name__c.containsignorecase('Canada')){
                        businessUnitOfRenewalQuote = 'Canada';
                    }
                    system.debug('KS--> businessUnitOfRenewalQuote '+businessUnitOfRenewalQuote);
                    system.debug('###Prop line item '+propObj.Apttus_Proposal__R00N70000001yUfBEAU__r);
                    
                    List<Apttus_Proposal__Proposal_Line_Item__c> listOfPLIS = propObj.Apttus_Proposal__R00N70000001yUfBEAU__r;
                    for(Apttus_Proposal__Proposal_Line_Item__c Pl : listOfPLIS){
                        system.debug('###Inside 2nd For Loop'+Pl.ID);                        
                        
                        //Update Prop line item
                        Pl.APTS_Proposal_Business_Unit__c = Pl.Apttus_QPConfig__AssetLineItemId__r.APTS_Proposal_Business_Unit__c;
                        Pl.APTS_SSD_ship_to__c = Pl.Apttus_QPConfig__AssetLineItemId__r.APTS_SSD_Ship_to__c;  
                        
                        //Update Proposal
                        propObj.APTS_SSD_bill_to__c = Pl.Apttus_QPConfig__AssetLineItemId__r.APTS_SSD_Bill_To__c;
                        propObj.APTS_SSD_Ship_to__c = Pl.Apttus_QPConfig__AssetLineItemId__r.APTS_SSD_Ship_to__c;
                        propObj.APTS_SSD_Sold_To__c = Pl.Apttus_QPConfig__AssetLineItemId__r.APTS_SSD_Sold_To__c;  
                        
                        listOfPropoLIS.add(pl);
                        
                        AssetIds.add( Pl.Apttus_QPConfig__AssetLineItemId__c);
                        system.debug('###Assets Line'+AssetIds);
                    }                    
                    
                    if(propObj.Apttus_Proposal__Opportunity__c!=Null){
                        setOfOpptyID.add(propObj.Apttus_Proposal__Opportunity__c);
                        mapOfOpptyIDProposal.put(propObj.Apttus_Proposal__Opportunity__c,propObj);
                        System.debug('###Harsh opportunity Set'+setOfOpptyID);
                        System.debug('###Harsh opportunity MAps'+mapOfOpptyIDProposal);                       
                    }
                    
                    if(businessUnitOfRenewalQuote == 'Canada'){                        
                        propObj.APTS_Proposal_Business_Unit__c='Canada';      
                        propObj.CurrencyIsoCode = 'CAD';
                        //Commented by Kruti Shah for DOC-11523
                        //propObj.RecordTypeId=rtCanada.id;                              
                        //propObj.Apttus_Proposal__Approval_Stage__c ='Void';                         
                    } 
                    propList.add(propObj);
                }
            }
            
            // update proposalsRec;   
            if(propList.size()>0){
                System.debug('KS--> Proposal List Update '+propList);
                update propList;
            }
            
            //Update Proposal Line Items
            if(listOfPropoLIS.size()>0){
                System.debug('KS--> Proposal Line Item List Update '+listOfPropoLIS);
                update listOfPropoLIS;                
            }
            
            //Update Asset Line Items
            for(Apttus_Config2__AssetLineItem__c Ast : [Select id,Renewal_quote_created__c 
                                                        from Apttus_Config2__AssetLineItem__c 
                                                        where id in : AssetIds]){
                                                            system.debug('###Assets Line'+Ast.ID);
                                                            Ast.Renewal_quote_created__c=true;
                                                            AssetsList.add(Ast);
                                                        }
            
            if(AssetsList.size()>0){
                System.debug('KS--> Asset Line Item List Update '+AssetsList);
                update AssetsList;
            }
            
            //Update Opportunity
            if(setOfOpptyID != null && setOfOpptyID.size() >0){
                System.debug('###Harsh opportunity Set Inside IF'+setOfOpptyID);
                
                String businessUnitOfRenewalOppty = '';
                listOfOppty = [SELECT Id,Name,Source_System_Detail__c,Win_Loss__c,Primary_Quote__c,OwnerId,CurrencyIsoCode                               
                               From Opportunity Where ID in :setOfOpptyID ];
                
                System.debug('###Harsh List of oppty'+listOfOppty );
                for(Opportunity oppRec: listOfOppty){
                    
                    if (oppRec.Name.containsignorecase('Canada')){
                        businessUnitOfRenewalOppty = 'Canada';
                    }
                    
                    if(businessUnitOfRenewalOppty == 'Canada'){
                        oppRec.Pricebook2Id = priceBookCanada.Id;
                        oppRec.Name = 'Auto-Renewal Opportunity';
                        oppRec.Is_GLI__c = true;
                        oppRec.LCRM_Sub_BU__c = 'Canada';
                    }
                    
                    Apttus_Proposal__Proposal__c relatedProp = mapOfOpptyIDProposal.get(oppRec.Id);  
                    System.debug('RelatedProp'+relatedProp);
                    oppRec.Primary_Quote__c= relatedProp.Id;
                    oppRec.Source_System_Detail__c = relatedProp.APTS_SSD_Sold_To__c;                                       
                    oppRec.StageName ='Appointment Scheduled';                    
                    oppRec.CurrencyIsoCode=relatedProp.CurrencyIsoCode;
                    oppRec.OwnerId = relatedProp.OwnerId;                    
                }                
                update listOfOppty;                
            }            
            
        }
        catch(Exception ex){
            system.debug('Error Message: '+ex.getMessage());
            system.debug('Error Line Number'+ex.getLineNumber());
            system.debug('Error stack'+ex.getStackTraceString());
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
    
}