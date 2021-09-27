public with sharing class APTS_TaxProf_PricingCallbackMethods {   
    
    public static void updatepricemethod(List<Apttus_Config2__LineItem__c> lineitmlis){
        List<Product_Pricing__c> prodpricing = Product_Pricing__c.getAll().values();   
    }
    
    //Roma: Holds all defaulting value for Tax professional
    
    public static void defaultyoyincrease(List<Apttus_Config2__LineItem__c> lineitemlist){
        
        
        List<String> productIds = new  List<String>();
        for(Apttus_Config2__LineItem__c lineItem : lineitemlist){
            if(lineItem.APTS_Proposal_Business_Unit__c == 'Tax Professional'){
                
                //DOC-6390
                if(lineItem.APTS_Product_Code__c != null)
                    productIds.add(lineItem.APTS_Product_Code__c);
                System.debug(' TAX RK RenewalPI New Dev TEST *** ' + lineItem.APTS_Product_Code__c + '^^^ productIds ' +productIds);
                
                
                /*Roma
DOC: 3694
Defaulting of Contract Term and YOY2%
*/
                if(lineItem.APTS_Years_2_Plus_Adjustment__c == null && lineItem.Apttus_Config2__ChargeType__c=='Subscription Fee' && lineItem.Apttus_Config2__PriceType__c != 'One Time')
                    lineItem.APTS_Years_2_Plus_Adjustment__c = String.valueOf(lineItem.APTS_Years_2_Plus_Default__c);
                if(lineItem.APTS_Contract_Term__c == null && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.Apttus_Config2__ChargeType__c=='Subscription Fee' && lineItem.Apttus_Config2__PriceType__c != 'One Time')
                    lineItem.APTS_Contract_Term__c = '3 Years';
                //String.valueOf(lineItem.APTS_Contract_Term_Default__c); 
                if(lineItem.Apttus_Config2__BillingFrequency__c == null && lineItem.Apttus_Config2__LineStatus__c != 'Renewed')
                    lineItem.Apttus_Config2__BillingFrequency__c = 'Yearly';
                /*Roma
Renewal Price Increase
DOC- 6390 
*/     
                /*if(lineItem.Apttus_Config2__LineStatus__c == 'Renewed' && lineItem.APTS_Product_Variant_ID__c != null)
{
System.debug(' TAX RK Default TEST *** ' + lineItem.Apttus_Config2__AdjustmentAmount__c + 'RT **' + lineItem.Apttus_Config2__AdjustmentType__c + ' ** LS ** ' + lineItem.Apttus_Config2__LineStatus__c );
if(lineItem.APTS_Auto_Renew_Price_Basis__c != null && lineItem.APTS_Auto_Renew_Price_Percentage__c != null)
{
System.debug('AUTO RENEW *** '+ lineItem.APTS_Auto_Renew_Price_Basis__c
+'***APTTUS AUTO RENEW** '+lineItem.APTS_Auto_Renew_Price_Percentage__c);
lineItem.APTS_Yr_1_Renewal_Adjustment__c = String.valueOf(lineItem.APTS_Auto_Renew_Price_Percentage__c);
lineItem.Apttus_Config2__IsAssetPricing__c = true;


System.debug(' 22222 TAX RK Default TEST LIST PRICE *** ' + lineItem.APTS_Yr_1_Renewal_Adjustment__c + 'Apttus_Config2__IsAssetPricing__c*** ' +  lineItem.Apttus_Config2__IsAssetPricing__c);


}    
}*/
                //Date Calculation on cart
                
                if(lineItem.Apttus_Config2__LineStatus__c == 'New' && String.valueOf(lineItem.Apttus_Config2__StartDate__c) == null && String.valueOf(lineItem.Apttus_Config2__EndDate__c) == null)
                {
                    lineItem.Apttus_Config2__StartDate__c = System.Date.today().addMonths(1).toStartOfMonth();
                    lineItem.Apttus_Config2__EndDate__c = lineItem.Apttus_Config2__StartDate__c.addMonths(12).addDays(-1);
                    System.debug(' 22222 TAX START RK TEST *** ' + lineItem.Apttus_Config2__StartDate__c + 'RT END DATE **' + lineItem.Apttus_Config2__EndDate__c);          
                }
                if(String.valueOf(lineItem.Apttus_Config2__StartDate__c) != null && lineItem.Apttus_Config2__LineStatus__c == 'New' && (lineItem.APTS_Term_Type__c == 'Future Start Date' || lineItem.APTS_Term_Type__c == null ))
                {
                    lineItem.Apttus_Config2__EndDate__c = lineItem.Apttus_Config2__StartDate__c.addMonths(12).addDays(-1);
                    System.debug(' $$$$$ TERM TYPE TAX START RK TEST *** ' + lineItem.Apttus_Config2__StartDate__c + 'TERM TYPE ** ' + lineItem.APTS_Term_Type__c + 'RT END DATE **' + lineItem.Apttus_Config2__EndDate__c);          
                }
                if(lineItem.Apttus_Config2__LineStatus__c == 'Renewed' && lineItem.APTS_Contract_Term__c== null)
                {
                    lineItem.APTS_Contract_Term__c= '1 Year';
                    //lineItem.Apttus_Config2__EndDate__c =lineItem.Apttus_Config2__StartDate__c.addYears(1);
                }
            }
        }
        
        //DOC-6390
        /*if(!productIds.isEmpty() && productIds != null){
List<Apttus_Config2__LineItem__c> newLineItems = new List<Apttus_Config2__LineItem__c>();
List<APTS_Product_Variant__c> productVariantData = [select APTS_Product_Variant_ID__c,APTS_Product_ID__c,APTS_Auto_Renew_Price_Percentage__c,APTS_Auto_Renew_Price_Basis__c  from APTS_Product_Variant__c where APTS_Product_ID__c in :productIds limit 100];
System.debug(' 22222 TAX RK Default TEST % PRICE *** ' + productVariantData );
for(Apttus_Config2__LineItem__c lineItem : lineitemlist){
if(lineItem.Apttus_Config2__LineStatus__c == 'Renewed'){
for(APTS_Product_Variant__c pv:productVariantData)
{
if(lineItem.APTS_Product_Code__c == pv.APTS_Product_ID__c && pv.APTS_Auto_Renew_Price_Basis__c !=null && pv.APTS_Auto_Renew_Price_Percentage__c != null){
lineItem.APTS_Yr_1_Renewal_Adjustment__c = String.valueOf(pv.APTS_Auto_Renew_Price_Percentage__c);
lineItem.Apttus_Config2__IsAssetPricing__c = true;
//lineItem.Apttus_Config2__NetPrice__c = (lineItem.APTS_Asset_Net_Price__c + (lineItem.APTS_Asset_Net_Price__c * (lineItem.Apttus_Config2__ProductId__r.APTS_Auto_Renew__c/100))).setScale(2);
newLineItems.add(lineItem);
System.debug(' 22222 TAX RK Default TEST % PRICE *** ' + pv.APTS_Auto_Renew_Price_Percentage__c + ' *** PRICe INC '+lineItem.APTS_Yr_1_Renewal_Adjustment__c + 'ASSET NET PRICE *** '+ lineItem.APTS_Asset_Net_Price__c + 'Apttus_Config2__IsAssetPricing__c*** ' +  lineItem.Apttus_Config2__IsAssetPricing__c);
} 
}
} 
}
}*/
    }
    //-----------Developed as part of DOC-8995 By Poorva for Calucating Tiered Pricing for Tax Professional--------------
    public static void multiYearTieredPricing(List<Apttus_Config2__LineItem__c> lineItemsList) {
        
        Integer contractTerm;
        List<Decimal> dollarValues;
        List<Decimal> multiYearPrices;
        Decimal calculatedYear1Price;
        Integer calculatedMinYoy;
        Integer yoy2;
        Integer yoy1Renewal;
        List<Apttus_Config2__LineItem__c> multiYearLineItems=new List<Apttus_Config2__LineItem__c>();
        
        for(Apttus_Config2__LineItem__c lineItem:lineItemsList){
            system.debug('entered term check--'+lineItem.APTS_Contract_Term__c);
            if(lineItem.APTS_Contract_Term__c!=null 
               &&(lineItem.APTS_Contract_Term__c=='1 Year' || lineItem.APTS_Contract_Term__c=='2 Years' 
                  || lineItem.APTS_Contract_Term__c=='3 Years' || lineItem.APTS_Contract_Term__c=='4 Years' 
                  || lineItem.APTS_Contract_Term__c=='5 Years')
               && (lineItem.Apttus_Config2__LineStatus__c =='New' || lineItem.Apttus_Config2__LineStatus__c =='Renewed' 
                   || lineItem.Apttus_Config2__LineStatus__c =='Amended')) // Added by Kruti Shah(DOC-8900)
            {
                system.debug('entered term check');
                multiYearLineItems.add(lineItem);
            }      
        }
        
        System.debug('KS--> multiYearLineItems '+multiYearLineItems);
        for(Apttus_Config2__LineItem__c lineItem:multiYearLineItems){
            
            dollarValues=new List<Decimal>();
            multiYearPrices=new List<Decimal>();
            calculatedYear1Price=0.0;
            yoy2=(lineItem.APTS_Years_2_Plus_Adjustment__c!=null)?Integer.valueOf(lineItem.APTS_Years_2_Plus_Adjustment__c):0;
            yoy1Renewal=(lineItem.APTS_Yr_1_Renewal_Adjustment__c!=null)?Integer.valueOf(lineItem.APTS_Yr_1_Renewal_Adjustment__c):0;
            
            if(lineitem.Apttus_Config2__AssetLineItemId__c != null && lineItem.Apttus_Config2__LineStatus__c =='Amended'){
                //contractTerm = integer.valueOf(lineitem.Apttus_Config2__AssetLineItemId__r.APTS_Term_remaining_in_Years__c);            
            }else{ 
                if(lineItem.APTS_Contract_Term_Whole_Years__c ==  null){
                    contractTerm = contractTermMapping(lineItem.APTS_Contract_Term__c);   
                }else{
                    contractTerm = integer.valueOf(lineItem.APTS_Contract_Term_Whole_Years__c);
                }   
            }            
            
            system.debug('KS--> lineItem.APTS_Contract_Term_Whole_Years__c '+lineItem.APTS_Contract_Term_Whole_Years__c);
            System.debug('KS--> contractTerm '+contractTerm);
            
            if((lineItem.Apttus_Config2__LineStatus__c =='New' || lineItem.Apttus_Config2__LineStatus__c =='Amended')
                && (lineItem.APTS_Term_Type__c!='Future Start Date and Co-Term' && lineItem.APTS_Term_Type__c!='Co-Term')){
                if(lineItem.Apttus_Config2__LineType__c == 'Option' && lineItem.Apttus_Config2__PriceIncludedInBundle__c == true && lineItem.Apttus_Config2__ListPrice__c != NULL){
                    if(lineItem.Apttus_Config2__SellingFrequency__c == 'Monthly'){  
                        lineItem.APTS_Calculated_Year_1__c = lineItem.Apttus_Config2__ListPrice__c * 12;    
                        calculatedYear1Price = lineItem.Apttus_Config2__ListPrice__c * 12;  
                    }else if(lineItem.Apttus_Config2__SellingFrequency__c == 'Yearly'){ 
                        lineItem.APTS_Calculated_Year_1__c = lineItem.Apttus_Config2__ListPrice__c;     
                        calculatedYear1Price = lineItem.Apttus_Config2__ListPrice__c;   
                    } 
                }
                else{ if(lineItem.Apttus_Config2__NetPrice__c != null){
                    lineItem.APTS_Calculated_Year_1__c=lineItem.Apttus_Config2__NetPrice__c; 
                    calculatedYear1Price=lineItem.Apttus_Config2__NetPrice__c; }
                }
            }
            //Changes for coterm price calculation
            if((lineItem.Apttus_Config2__LineStatus__c =='New' || lineItem.Apttus_Config2__LineStatus__c =='Amended')
               && (lineItem.APTS_Term_Type__c=='Co-Term' 
                   || lineItem.APTS_Term_Type__c== 'Future Start Date and Co-Term')
               && lineItem.Apttus_Config2__StartDate__c != null && lineItem.Apttus_Config2__EndDate__c!= null){
                   
                   Date enddt = lineItem.Apttus_Config2__StartDate__c.addMonths(12).addDays(-1);
                   Integer daysInAyear = ((lineItem.Apttus_Config2__StartDate__c.daysBetween(enddt))+1);
                   Integer daysInContract =((lineItem.Apttus_Config2__StartDate__c.daysBetween(lineItem.Apttus_Config2__EndDate__c))+1) ;
                   Double calculatePrice = 0.0;
                   system.debug('$$PSEntered here :' );
                   if(lineItem.Apttus_Config2__SellingFrequency__c == 'Monthly'){
                       if(lineItem.Apttus_Config2__LineType__c == 'Option' && lineItem.Apttus_Config2__PriceIncludedInBundle__c == true && lineItem.Apttus_Config2__ListPrice__c != NULL){
                           calculatePrice = lineItem.Apttus_Config2__ListPrice__c * 12;
                       }
                       else if(lineItem.Apttus_Config2__NetUnitPrice__c != NULL){ 
                           calculatePrice = lineItem.Apttus_Config2__NetUnitPrice__c * 12;
                       }
                   }else if(lineItem.Apttus_Config2__SellingFrequency__c == 'Yearly' ){
                       if(lineItem.Apttus_Config2__LineType__c == 'Option' && lineItem.Apttus_Config2__PriceIncludedInBundle__c == true && lineItem.Apttus_Config2__ListPrice__c != NULL){
                           //calculatePrice = lineItem.Apttus_Config2__ListPrice__c/ lineItem.Apttus_Config2__SellingTerm__c;
                           calculatePrice  = lineItem.Apttus_Config2__ListPrice__c;
                       }
                       else if(lineItem.Apttus_Config2__NetUnitPrice__c != NULL){   
                           system.debug('$$PSEntered here : yearly not an option' );
                           //calculatePrice = lineItem.Apttus_Config2__NetPrice__c/ lineItem.Apttus_Config2__SellingTerm__c;
                           calculatePrice  = lineItem.Apttus_Config2__NetUnitPrice__c ;
                           //lineItem.Apttus_Config2__SellingTerm__c = 12;
                           //calculatePrice=lineItem.Apttus_Config2__NetPrice__c/daysInContract*daysInAyear;
                       }
                   }
                   
                   if(lineitem.APTS_Partial_Year_Charge_Eligible__c == 'Yes'){
                       if(lineItem.Apttus_Config2__LineType__c == 'Option' && lineItem.Apttus_Config2__PriceIncludedInBundle__c == true && lineItem.Apttus_Config2__ListPrice__c != NULL){
                           lineItem.APTS_Calculated_Year_1__c = lineItem.Apttus_Config2__ListPrice__c * ((lineItem.Apttus_Config2__StartDate__c.monthsBetween(lineItem.Apttus_Config2__EndDate__c)) + 1);
                       }
                       else if(lineItem.Apttus_Config2__NetPrice__c != NULL){
                           system.debug('$$PSEntered here price eligible yes : yearly not an option' );
                           lineItem.APTS_Calculated_Year_1__c = lineItem.Apttus_Config2__NetPrice__c;
                       }
                   }
                   else{
                       //lineItem.Apttus_Config2__SellingTerm__c = 12;
                       // lineItem.Apttus_Config2__BasePriceOverride__c = calculatePrice;
                       system.debug('$$PSEntered here price eligible no:' );
                       lineItem.APTS_Calculated_Year_1__c=calculatePrice;
                   }
                   calculatedYear1Price=calculatePrice;   
               }
            if(lineItem.Apttus_Config2__LineStatus__c =='Renewed' && lineItem.Apttus_Config2__AdjustmentType__c==null && (lineItem.APTS_Term_Type__c!='Co-Term'  && lineItem.APTS_Term_Type__c!='Future Start Date and Co-Term')){
                lineItem.APTS_Calculated_Year_1__c=(((lineItem.Apttus_Config2__NetPrice__c*yoy1Renewal)/100)+lineItem.Apttus_Config2__NetPrice__c).setScale(2);    
                calculatedYear1Price=(((lineItem.Apttus_Config2__NetPrice__c*yoy1renewal)/100)+lineItem.Apttus_Config2__NetPrice__c).setScale(2);                                
            }  
            if(lineItem.Apttus_Config2__LineStatus__c =='Renewed' && lineItem.Apttus_Config2__AdjustmentType__c!=null && lineItem.Apttus_Config2__AdjustmentType__c=='Price Override' && (lineItem.APTS_Term_Type__c!='Co-Term' && lineItem.APTS_Term_Type__c!='Future Start Date' && lineItem.APTS_Term_Type__c!='Future Start Date and Co-Term')){
                if(lineItem.Apttus_Config2__NetPrice__c != Null){
                lineItem.APTS_Calculated_Year_1__c=lineItem.Apttus_Config2__NetPrice__c;    
                calculatedYear1Price=lineItem.Apttus_Config2__NetPrice__c; }                               
            } 
            
            system.debug('KS-->calculatedYear1Price '+calculatedYear1Price);
            if(contractTerm==1){   
                lineItem.APTS_Calculated_Min_YOY__c=yoy2;
                lineItem.APTS_Calculated_Auto_Renewal__c=yoy2;
                if(lineItem.APTS_Calculated_Year_2__c!=null || lineItem.APTS_Calculated_Year_3__c!=null || lineItem.APTS_Calculated_Year_4__c!=null || lineItem.APTS_Calculated_Year_5__c!=null){
                    lineItem.APTS_Calculated_Year_2__c=null;
                    lineItem.APTS_Calculated_Year_3__c=null;
                    lineItem.APTS_Calculated_Year_4__c=null;
                    lineItem.APTS_Calculated_Year_5__c=null;
                }
            }           
            if(contractTerm==2){
                if(lineItem.APTS_Yr_2_Amount__c!=null){                  
                    lineItem.APTS_Calculated_Year_2__c=lineItem.APTS_Yr_2_Amount__c; 
                    lineItem.APTS_Is_Multi_Tiered_Pricing__c=true;                 
                    dollarValues.add(calculatedYear1Price);
                    dollarValues.add(lineItem.APTS_Yr_2_Amount__c);
                    lineItem.APTS_Calculated_Min_YOY__c=calculateMinYoy(dollarValues);
                    lineItem.APTS_Calculated_Auto_Renewal__c=4;
                }else if(lineItem.APTS_Yr_2_Amount__c==null){
                    multiYearPrices=getCalculatedMultiYearPrices(contractTerm,yoy2,calculatedYear1Price);
                    lineItem.APTS_Calculated_Year_2__c=multiYearPrices[0];
                    lineItem.APTS_Calculated_Min_YOY__c=yoy2;
                    lineItem.APTS_Calculated_Auto_Renewal__c=yoy2;
                }
                if(lineItem.APTS_Calculated_Year_3__c!=null || lineItem.APTS_Calculated_Year_4__c!=null || lineItem.APTS_Calculated_Year_5__c!=null){
                    lineItem.APTS_Calculated_Year_3__c=null;
                    lineItem.APTS_Calculated_Year_4__c=null;
                    lineItem.APTS_Calculated_Year_5__c=null;
                }              
            }
            if(contractTerm==3){
                if(lineItem.APTS_Yr_2_Amount__c!=null && lineItem.APTS_Yr_3_Amount__c!=null){                  
                    lineItem.APTS_Calculated_Year_2__c=lineItem.APTS_Yr_2_Amount__c;
                    lineItem.APTS_Calculated_Year_3__c=lineItem.APTS_Yr_3_Amount__c;  
                    lineItem.APTS_Is_Multi_Tiered_Pricing__c=true;                
                    dollarValues.add(calculatedYear1Price);
                    dollarValues.add(lineItem.APTS_Yr_2_Amount__c);
                    dollarValues.add(lineItem.APTS_Yr_3_Amount__c);
                    lineItem.APTS_Calculated_Min_YOY__c=calculateMinYoy(dollarValues);
                    lineItem.APTS_Calculated_Auto_Renewal__c=4;
                }else if(lineItem.APTS_Yr_2_Amount__c==null || lineItem.APTS_Yr_3_Amount__c==null){
                    multiYearPrices=getCalculatedMultiYearPrices(contractTerm,yoy2,calculatedYear1Price);
                    lineItem.APTS_Calculated_Year_2__c=multiYearPrices[0];
                    lineItem.APTS_Calculated_Year_3__c=multiYearPrices[1];
                    lineItem.APTS_Calculated_Min_YOY__c=yoy2;
                    lineItem.APTS_Calculated_Auto_Renewal__c=yoy2;
                }
                if(lineItem.APTS_Calculated_Year_4__c!=null || lineItem.APTS_Calculated_Year_5__c!=null){
                    lineItem.APTS_Calculated_Year_4__c=null;
                    lineItem.APTS_Calculated_Year_5__c=null;
                } 
            }
            if(contractTerm==4){
                if(lineItem.APTS_Yr_2_Amount__c!=null && lineItem.APTS_Yr_3_Amount__c!=null && lineItem.APTS_Yr_4_Amount__c!=null){                  
                    lineItem.APTS_Calculated_Year_2__c=lineItem.APTS_Yr_2_Amount__c;
                    lineItem.APTS_Calculated_Year_3__c=lineItem.APTS_Yr_3_Amount__c; 
                    lineItem.APTS_Calculated_Year_4__c=lineItem.APTS_Yr_4_Amount__c;   
                    lineItem.APTS_Is_Multi_Tiered_Pricing__c=true;              
                    dollarValues.add(calculatedYear1Price);
                    dollarValues.add(lineItem.APTS_Yr_2_Amount__c);
                    dollarValues.add(lineItem.APTS_Yr_3_Amount__c);
                    dollarValues.add(lineItem.APTS_Yr_4_Amount__c);
                    lineItem.APTS_Calculated_Min_YOY__c=calculateMinYoy(dollarValues);
                    lineItem.APTS_Calculated_Auto_Renewal__c=4;
                }else if(lineItem.APTS_Yr_2_Amount__c==null || lineItem.APTS_Yr_3_Amount__c==null || lineItem.APTS_Yr_4_Amount__c==null){
                    multiYearPrices=getCalculatedMultiYearPrices(contractTerm,yoy2,calculatedYear1Price);
                    lineItem.APTS_Calculated_Year_2__c=multiYearPrices[0];
                    lineItem.APTS_Calculated_Year_3__c=multiYearPrices[1];
                    lineItem.APTS_Calculated_Year_4__c=multiYearPrices[2];
                    lineItem.APTS_Calculated_Min_YOY__c=yoy2;
                    lineItem.APTS_Calculated_Auto_Renewal__c=yoy2;
                }
                if(lineItem.APTS_Calculated_Year_5__c!=null){
                    lineItem.APTS_Calculated_Year_5__c=null;
                }
                
            }
            if(contractTerm==5 && lineItem.APTS_Yr_2_Amount__c!=null && lineItem.APTS_Yr_3_Amount__c!=null && lineItem.APTS_Yr_4_Amount__c!=null && lineItem.APTS_Yr_5_Amount__c!=null){                  
                lineItem.APTS_Calculated_Year_2__c=lineItem.APTS_Yr_2_Amount__c;
                lineItem.APTS_Calculated_Year_3__c=lineItem.APTS_Yr_3_Amount__c; 
                lineItem.APTS_Calculated_Year_4__c=lineItem.APTS_Yr_4_Amount__c; 
                lineItem.APTS_Calculated_Year_5__c=lineItem.APTS_Yr_5_Amount__c;  
                lineItem.APTS_Is_Multi_Tiered_Pricing__c=true;              
                dollarValues.add(calculatedYear1Price);
                dollarValues.add(lineItem.APTS_Yr_2_Amount__c);
                dollarValues.add(lineItem.APTS_Yr_3_Amount__c);
                dollarValues.add(lineItem.APTS_Yr_4_Amount__c);
                dollarValues.add(lineItem.APTS_Yr_5_Amount__c);
                lineItem.APTS_Calculated_Min_YOY__c=calculateMinYoy(dollarValues);
                lineItem.APTS_Calculated_Auto_Renewal__c=4;
            }else if(contractTerm==5 && (lineItem.APTS_Yr_2_Amount__c==null || lineItem.APTS_Yr_3_Amount__c==null || lineItem.APTS_Yr_4_Amount__c==null || lineItem.APTS_Yr_5_Amount__c==null)){
                multiYearPrices=getCalculatedMultiYearPrices(contractTerm,yoy2,calculatedYear1Price);
                lineItem.APTS_Calculated_Year_2__c=multiYearPrices[0];
                lineItem.APTS_Calculated_Year_3__c=multiYearPrices[1];
                lineItem.APTS_Calculated_Year_4__c=multiYearPrices[2];
                lineItem.APTS_Calculated_Year_5__c=multiYearPrices[3];
                lineItem.APTS_Calculated_Min_YOY__c=yoy2;
                lineItem.APTS_Calculated_Auto_Renewal__c=yoy2;
            }
        }
    }
    public static List<Decimal> getCalculatedMultiYearPrices(Integer contractTerm,Integer yoy2,Decimal calculatedYear1Price){
        
        List<Decimal> priceList=new List<Decimal>();
        for(Integer i=0;i<contractTerm-1;i++){      
            if(priceList.isEmpty()){           
                priceList.add((((calculatedYear1Price*yoy2)/100)+calculatedYear1Price).setScale(2));             
            }else{
                priceList.add((((priceList.get(i-1)*yoy2)/100)+priceList.get(i-1)).setScale(2));
            }
        }
        return priceList;
    }
    public static Decimal calculateMinYoy(List<Decimal> dollarValuesList){
        
        List<Decimal> yoyList=new List<Decimal>();
        System.debug('Dollar values:'+dollarValuesList);
        // if(dollarValuesList.contains(0) || dollarValuesList.contains(0.0) || dollarValuesList.contains(0.00))
        // return 0;
        for(Integer i=0;i<dollarValuesList.size()-1;i++){
            if((i==0 && dollarValuesList[0]==0.00000 && dollarValuesList[i+1]!=0.00)||(dollarValuesList[i]==0.00 && dollarValuesList[i+1]!=0.00 ))
            {
                yoyList.add(100);
            }
            else if((i==0 && dollarValuesList[0]==0.00000 && dollarValuesList[i+1]==0.00) ||(dollarValuesList[i]==0.00 && dollarValuesList[i+1]==0.00 )){
                yoyList.add(0);
            }
            else{
                yoyList.add((((dollarValuesList.get(i+1)-dollarValuesList.get(i))*100)/dollarValuesList.get(i)).setScale(2));
            }
        }
        yoyList.sort();
        System.debug('yoyList:'+yoyList);
        return yoyList[0];
        
    }
    
    //Code written to calculate the contract term when whole contract term is null.
    public static Integer contractTermMapping(String contractTerm){
        Integer contract = 0;
        switch on contractTerm {
            when '1 Year' {
                contract = 1;
            }
            when '2 Years' {
                contract = 2;
            }
            when '3 Years' {
                contract = 3;
            }
            when '4 Years' {
                contract = 4;
            }
            when else {
                contract = 5;
            }
        }
        return contract;
    }
    
    public static void defaultingOptionLineItem(List<Apttus_Config2__LineItem__c> lineItemsList) {

    List<Apttus_Config2__LineItem__c> parentLineItems=new List<Apttus_Config2__LineItem__c>();
    List<Apttus_Config2__LineItem__c> optionLineItems=new List<Apttus_Config2__LineItem__c>();
    for(Apttus_Config2__LineItem__c lineItem:lineItemsList){
        if(lineItem.Apttus_Config2__LineType__c == 'Product/Service')
            parentLineItems.add(lineitem);
        else if(lineItem.Apttus_Config2__LineType__c == 'Option')
            optionLineItems.add(lineitem);
    }
    system.debug('Bundle Line Item ='+parentLineItems);
    system.debug('Option Line Item ='+optionLineItems);
    if(parentLineItems != null && parentLineItems.size()>0 && optionLineItems!=null && optionLineItems.size()>0){
        System.debug('Inside assignement block');
        for(Apttus_Config2__LineItem__c pLineItem : parentLineItems){
            system.debug('Parent Line Item'+pLineItem.Apttus_Config2__ProductId__c);
            for(Apttus_Config2__LineItem__c oLineItem : optionLineItems){
                system.debug('Parent Line Item'+oLineItem.Apttus_Config2__ProductId__c);
                if(oLineItem.Apttus_Config2__ProductId__c == pLineItem.Apttus_Config2__ProductId__c)
                {
                    //oLineItem.Apttus_Config2__AdjustmentType__c = pLineItem.Apttus_Config2__AdjustmentType__c;
                    //oLineItem.Apttus_Config2__AdjustmentAmount__c= pLineItem.Apttus_Config2__AdjustmentAmount__c;
                    oLineItem.APTS_Bridge__c= pLineItem.APTS_Bridge__c;
                    //oLineItem.APTS_Bridge_Discount__c= pLineItem.APTS_Bridge_Discount__c;
                    oLineItem.APTS_Contract_Term__c= pLineItem.APTS_Contract_Term__c;
                    oLineItem.APTS_Yr_1_Renewal_Adjustment__c= pLineItem.APTS_Yr_1_Renewal_Adjustment__c;
                    oLineItem.APTS_Years_2_Plus_Adjustment__c= pLineItem.APTS_Years_2_Plus_Adjustment__c;
                    oLineItem.Apttus_Config2__BillingFrequency__c= pLineItem.Apttus_Config2__BillingFrequency__c;
                    oLineItem.APTS_Renewal_Type__c= pLineItem.APTS_Renewal_Type__c;
                    oLineItem.APTS_Term_Type__c= pLineItem.APTS_Term_Type__c;
                    oLineItem.Apttus_Config2__StartDate__c= pLineItem.Apttus_Config2__StartDate__c;
                    oLineItem.Apttus_Config2__EndDate__c= pLineItem.Apttus_Config2__EndDate__c;              
                    
                }
                system.debug('Option Line Item after logic ends'+oLineItem);
            }
            system.debug('Parent Line Item after logic ends'+pLineItem);
        }
        
    }
 }
    
}