public with sharing class APTS_FL_PricingCallbackMethods { 
    
    public static Map<String,List<String>> getflcodeMap(){
            Map<String,List<String>> flcodeMap=new Map<String,List<String>>();  
            List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
            for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
                String flvalue= pb.value__c;               
                flcodeMap.put(pb.name,pb.value__c.split(','));
            }
            System.debug('flcode'+flcodeMap);
            return flcodeMap;
    }
    public static void setYear2_3Price(List<Apttus_Config2__LineItem__c> bundleItems){
        Map<String,List<String>> flcodeMap=getflcodeMap();
        List<Apttus_Config2__LineItem__c> lineItemList = new List<Apttus_Config2__LineItem__c>();
        for(Apttus_Config2__LineItem__c lineItem : bundleItems){
            if(flcodeMap.get('PPC MANAGEMENT').contains(lineItem.APTS_CAT_L5__c)) { //SOC- 6201 -added by gayatri on 01/11/2018
                lineItem.APTS_Year_2_3_Price__c = lineItem.Apttus_Config2__NetPrice__c;
                lineItemList.add(lineItem);
            }
        }                
    }
     
    public static void setDirectoriesBasePrice(List<Apttus_Config2__LineItem__c> lineItems){  
        List<Apttus_Config2__LineItem__c> lineItem = new List<Apttus_Config2__LineItem__c>();           
        for(Apttus_Config2__LineItem__c liList :lineItems ){
            System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
            system.debug('Line Item Business Unit >>>'+liList.APTS_Proposal_Business_Unit__c);
            system.debug('Line Item PAGEO Price >>>'+liList.APTS_PAGEO_Price__c);
            if(liList.APTS_Proposal_Business_Unit__c == 'FindLaw' && liList.APTS_PAGEO_Price__c!=null && liList.APTS_PAGEO_Price__c != 0) { //DOC-9406: Chintan Jadwani
                liList.Apttus_Config2__BasePrice__c= liList.APTS_PAGEO_Price__c;  
                    if(liList.Apttus_Config2__LineStatus__c=='New' || liList.Apttus_Config2__LineStatus__c=='Renewed'){
                        liList.APTS_Year_2_3_Price__c=liList.Apttus_Config2__BasePrice__c;
                    }             
                    
            }
           // if(liList.APTS_Exposure_Pack_Disc__c!=null && liList.Apttus_Config2__LineType__c=='Product/Service'){
              //liList.Apttus_Config2__AdjustmentAmount__c=liList.APTS_Exposure_Pack_Disc__c;
            //}
            
            lineItem.add(liList);
        }                   
    }
    //This method is to default contract term for Findlaw 
    public static void findlawdefaultContractTerm(List<Apttus_Config2__LineItem__c> bundleItems, Map<Decimal, List<Apttus_Config2__LineItem__c>> lineNumberToOptionsMap, Apttus_Config2__ProductConfiguration__c cartRec){        
    Decimal contractTerm = null;
        Map<String, Decimal> termMap = new Map<String, Decimal>{'1 Month'=> 1, '2 Months'=>2, '3 Months'=>3, '4 Months'=>4, '5 Months'=>5, '6 Months'=>6, '7 Months'=>7, '8 Months'=>8, '9 Months'=>9, '10 Months'=>10, 
                                                                '11 Months'=>11, '1 Year'=>12, '2 Years'=>24, '3 Years'=>36, '4 Years'=>48, '5 Years'=>60, '10 Years'=>120};
        for(Apttus_Config2__LineItem__c lineItem : bundleItems){         
           
            //DOC-9560 : Jinal Bhatt           
            if (lineItem.APTS_Contract_Term__c == null) {
                lineItem.APTS_Contract_Term__c = lineItem.APTS_Contract_Term_Default__c;
                
                if (lineItem.Apttus_Config2__ChargeType__c=='Subscription Fee' && lineItem.Apttus_Config2__AdjustmentType__c == null) {
                    lineItem.Apttus_Config2__AdjustmentType__c = '% Discount';
                }
                
            }    
            //End DOC-9560   
                  
            if(lineNumberToOptionsMap.containsKey(lineITem.Apttus_Config2__LineNumber__c)){
                for(Apttus_Config2__LineItem__c optionLineItem : lineNumberToOptionsMap.get(lineItem.Apttus_Config2__LineNumber__c)){
                    if(optionLineItem.APTS_Contract_Term__c != lineItem.APTS_Contract_Term__c){
                        optionLineItem.APTS_Contract_Term__c = lineItem.APTS_Contract_Term__c;                          
                    }
                    system.debug('test term : 1 : '+optionLineItem.APTS_Contract_Term__c+' : '+optionLineItem.Apttus_Config2__ProductId__r.Media_High_Level__c);
                    if(optionLineItem.APTS_Contract_Term__c != NULL && (optionLineItem.APTS_Contract_Term__c.containsIgnoreCase('YEAR') || optionLineItem.APTS_Contract_Term__c.containsIgnoreCase('MONTH')) 
                        && (optionLineItem.Apttus_Config2__ProductId__r.Media_High_Level__c == 'Online' || optionLineItem.Apttus_Config2__ProductId__r.Media_High_Level__c == 'Software')){
                        //Decimal tempVal = termMap.get(optionLineItem.APTS_Contract_Term__c);
                        Decimal tempVal = optionLineItem.APTS_Contract_Term_Whole_Years__c;
                        contractTerm  = (contractTerm==null)?tempVal:((contractTerm>tempVal)?tempVal:contractTerm);
                        system.debug('test term if'); //added as part of descope
                    }
                }     
            }      
            if(lineItem.Apttus_Config2__PriceType__c == 'One Time'){
                lineItem.APTS_Contract_Term__c = null;                
            }
            
             //DOC-9560 : Jinal Bhatt
            if(lineItem.Apttus_Config2__AdjustmentType__c == null && lineItem.Apttus_Config2__ChargeType__c == 'Standard Price'){
                lineItem.Apttus_Config2__AdjustmentType__c = '% Discount';
            } //End DOC-9650
            system.debug('test term : '+lineItem.APTS_Contract_Term__c+' : '+lineItem.Apttus_Config2__ProductId__r.Media_High_Level__c);
            if(lineItem.APTS_Contract_Term__c != NULL && (lineItem.APTS_Contract_Term__c.containsIgnoreCase('YEAR') || lineItem.APTS_Contract_Term__c.containsIgnoreCase('MONTH')) 
                && (lineItem.Apttus_Config2__ProductId__r.Media_High_Level__c == 'Online' || lineItem.Apttus_Config2__ProductId__r.Media_High_Level__c == 'Software')){
                //Decimal tempVal = termMap.get(lineItem.APTS_Contract_Term__c);
                Decimal tempVal = (lineItem.APTS_Contract_Term_Whole_Years__c==null)?0:lineItem.APTS_Contract_Term_Whole_Years__c;
                contractTerm  = (contractTerm==null)?tempVal:((contractTerm>tempVal)?tempVal:contractTerm);
                
                system.debug('test term if');  //added as part of descope
            }
        }
    cartRec.APTS_Least_Contract_Term__c  = contractTerm; //added as part of descope
        system.debug('cartRec.APTS_Least_Contract_Term__c : '+contractTerm+' : '+cartRec.APTS_Least_Contract_Term__c);
    }
  
   public static void yoypriceUpdate(List<Apttus_Config2__LineItem__c> yoyLineItems,List<Apttus_Config2__PriceMatrixEntry__c> priceMatrixEntryList){    
        Map<String,List<String>> flcodeMap=getflcodeMap();
        List<Id> lineItemIds = new List<Id>();
        Set<Id> productIds = new Set<Id>();
        Map<String, Apttus_Config2__PriceMatrixEntry__c> entryMap = new Map<String, Apttus_Config2__PriceMatrixEntry__c>();
        Map<Decimal, Decimal> bundleMap = new Map<Decimal, Decimal>();
        Map<Decimal, Decimal> optionsMap = new Map<Decimal, Decimal>();
        Map<String, Map<Decimal, Decimal>> rangeMap = new Map<String, Map<Decimal, Decimal>>();
        Map<String, Map<Decimal, Decimal>> optionrangeMap = new Map<String, Map<Decimal, Decimal>>();
        Map<id,Boolean> noPriceMatrixMap=new Map<id,Boolean>();
        if(!yoyLineItems.isEmpty()){
            for(Apttus_Config2__LineItem__c liList : yoyLineItems){ 
                system.debug('has lineitem records with line status as NEW'+'PBN  '+liList.Apttus_Config2__ParentBundleNumber__c);
                if(liList.APTS_Proposal_Business_Unit__c=='FindLaw'){
                        if(liList.Apttus_Config2__LineType__c=='Product/Service' && liList.Apttus_Config2__ProductId__c!=null && liList.Apttus_Config2__ParentBundleNumber__c == null && liList.Apttus_Config2__OptionId__c==null){
                            bundleMap.put(liList.Apttus_Config2__PrimaryLineNumber__c,liList.Apttus_Config2__LineNumber__c);
                            system.debug('bundleMap'+bundleMap);
                        }
                }
            }
         }
            Boolean noPricematrix = true;
            if(!priceMatrixEntryList.isEmpty()){
            system.debug('priceMatrixEntryList--'+priceMatrixEntryList);
                for(Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry : priceMatrixEntryList){
                noPricematrix = true;
                    if(priceMatrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension2Id__r.Name == 'Priced Number of Attorneys'){
                        system.debug('Inside Diamension'+priceMatrixEntry.Apttus_Config2__Dimension2Value__c);
                        noPricematrix = false;        
                    }
                    system.debug('#### Price Matrix > Price List Item ID >'+priceMatrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__c);
                    noPriceMatrixMap.put(priceMatrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__c,noPricematrix);
                    if(priceMatrixEntry.Apttus_Config2__Dimension2Value__c!=null){
                        Map<Decimal,Decimal> idMap = new Map<Decimal,Decimal>();
                        Map<Decimal,Decimal> optionidMap = new Map<Decimal,Decimal>();
                        if(rangeMap.get(priceMatrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__c)!=null){
                            idMap=rangeMap.get(priceMatrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__c);
                        }
                        if(optionrangeMap.get(priceMatrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__c)!=null){
                            optionidMap=optionrangeMap.get(priceMatrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__c);
                        }                   
                     //   system.debug('priceMatrixEntry.Apttus_Config2__PriceOverride__c'+priceMatrixEntry.Apttus_Config2__PriceOverride__c);
                        system.debug('priceMatrixEntry.Apttus_Config2__Dimension2Value__c'+priceMatrixEntry.Apttus_Config2__Dimension2Value__c);                   
                            if(priceMatrixEntry.Apttus_Config2__Dimension2Value__c =='Option' || priceMatrixEntry.Apttus_Config2__Dimension3Value__c =='Option' || priceMatrixEntry.Apttus_Config2__Dimension4Value__c =='Option')  {
                                if(priceMatrixEntry.Apttus_Config2__Dimension2Value__c =='Option'){
                                    optionidMap.put(Decimal.valueof(-1),priceMatrixEntry.Apttus_Config2__AdjustmentAmount__c);
                                }
                                else{
                                    optionidMap.put(Decimal.valueof(priceMatrixEntry.Apttus_Config2__Dimension2Value__c),priceMatrixEntry.Apttus_Config2__AdjustmentAmount__c);
                                }
                        }   else{ 
                                if(priceMatrixEntry.Apttus_Config2__Dimension2Value__c!= null && priceMatrixEntry.Apttus_Config2__Dimension2Value__c!=''){
                                    idMap.put(Decimal.valueof(priceMatrixEntry.Apttus_Config2__Dimension2Value__c),priceMatrixEntry.Apttus_Config2__AdjustmentAmount__c);
                                }
                                else{
                                    idMap.put(Decimal.valueof(-1),priceMatrixEntry.Apttus_Config2__AdjustmentAmount__c);
                                }
                        }
                                rangeMap.put(priceMatrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__c,idMap);
                                optionrangeMap.put(priceMatrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__c,optionidMap);
                    }
                }
                system.debug('noPriceMatrixMap ---'+noPriceMatrixMap);
                for(Apttus_Config2__LineItem__c lineItem : yoyLineItems){
                    system.debug('### Line Item Price List Item ID >>>'+lineItem.Apttus_Config2__PriceListItemId__c);
                      if(!noPriceMatrixMap.isEmpty() && noPriceMatrixMap.containsKey(lineItem.Apttus_Config2__PriceListItemId__c) && !noPriceMatrixMap.get(lineItem.Apttus_Config2__PriceListItemId__c)){
                        system.debug('Noprice value entered IFF===>'+nopricematrix);
                        Map<Decimal,Decimal> yoyMap = new Map<Decimal,Decimal>(); 
                        if(lineItem .Apttus_Config2__LineType__c=='Product/Service'){   
                            yoyMap=rangeMap.get(lineItem.Apttus_Config2__PriceListItemId__c); 
                        }
                        else{
                            yoyMap=optionrangeMap.get(lineItem.Apttus_Config2__PriceListItemId__c);
                        }
                        system.debug('yoyMap Price list'+lineItem.Apttus_Config2__PriceListItemId__c);
                        system.debug('yoyMap'+yoyMap);                  
                        List<Decimal> yoyList = New List<Decimal>();
                        if(yoyMap!=null && yoyMap.size()>0){                        
                            yoyList.addAll(yoyMap.keySet());
                            yoyList.sort();
                            if(yoyList!= null && yoyList.size()==1 && yoyList[0]==-1){
                                lineItem.APTS_Year_2_3_Price__c=yoyMap.get(yoyList[0]);
                            }
                            else{
                            Decimal previousYoy=0;
                                for(Decimal yoy : yoyList){           
                                    system.debug('previousYoy@@'+previousYoy);               
                                    system.debug('yoy no of attorny New@@'+lineItem.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c);  
                                    system.debug('yoy complete New@@'+yoy);                  
                                    if(previousYoy<=lineItem.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c){
                                        system.debug('yoy inside if New@@'+yoyMap.get(yoy)); 
                                        lineItem.APTS_Year_2_3_Price__c=yoyMap.get(yoy);
                                        system.debug('lineItem.APTS_Year_2_3_Price__c=========>'+lineItem.APTS_Year_2_3_Price__c);
                                        if(yoy == lineItem.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c){
                                            Break;
                                        }
                                    }                               
                                    else{                         
                                        Break;
                                    }
                                        previousYoy =yoy;
                                }
                            }
                        }  
                    }
                    else{   
                        system.debug('Noprice value entered ELSE===>'+nopricematrix);
                        system.debug('lineItem id====>'+lineItem.id);
                        lineItem.APTS_Year_2_3_Price__c=lineItem.Apttus_Config2__PriceListItemId__r.APTS_FL_Renewal_List_Price__c; 
                        system.debug('APTS_Year_2_3_Price__c@@'+lineItem.APTS_Year_2_3_Price__c); 
                        system.debug('APTS_Year_2_3_Price__c@@'+lineItem.Apttus_Config2__PriceListItemId__r.APTS_FL_Renewal_List_Price__c);             
                    }                   
                    if(!bundleMap.isEmpty() && lineItem.Apttus_Config2__LineType__c == 'Option' && lineItem.Apttus_Config2__ParentBundleNumber__c != null && lineItem.Apttus_Config2__LineNumber__c == bundleMap.get(lineItem.Apttus_Config2__ParentBundleNumber__c)){
                        if(!optionsMap.isEmpty() && optionsMap.containskey(lineItem.Apttus_Config2__LineNumber__c) && lineItem.APTS_Year_2_3_Price__c!=null){           
                            optionsMap.put(lineItem.Apttus_Config2__LineNumber__c,optionsMap.get(lineItem.Apttus_Config2__LineNumber__c)+lineItem.APTS_Year_2_3_Price__c);
                        }
                        else if((optionsMap.isEmpty() || !optionsMap.containskey(lineItem.Apttus_Config2__LineNumber__c))&& lineItem.APTS_Year_2_3_Price__c!=null){
                            optionsMap.put(lineItem.Apttus_Config2__LineNumber__c,lineItem.APTS_Year_2_3_Price__c);
                        }                   
                    }
                }
                    
                    for(Apttus_Config2__LineItem__c lineItem : yoyLineItems){
                if(lineItem.Apttus_Config2__LineType__c=='Product/Service' && lineItem .Apttus_Config2__ProductId__c!=null && lineItem.Apttus_Config2__ParentBundleNumber__c == null && lineItem.Apttus_Config2__OptionId__c==null && !optionsMap.isEmpty() && optionsMap.containskey(lineItem.Apttus_Config2__LineNumber__c)){
                    system.debug('entered into bunlde price stamping loop '+optionsMap.get(lineItem.Apttus_Config2__LineNumber__c));
                    lineItem.APTS_Year_2_3_Price__c=optionsMap.get(lineItem.Apttus_Config2__LineNumber__c);                        
                }
                if(flcodeMap.get('PPC MANAGEMENT').contains(lineItem.APTS_CAT_L5__c)) { 
                        if(lineItem.Apttus_Config2__LineType__c=='Product/Service'){
                        lineItem.APTS_Year_2_3_Price__c = lineItem.Apttus_Config2__NetPrice__c;
                        }
                    }
            }
                    
                    
                    
              
        }
    }
}