/**
* Line Item trigger helper holding logic for Corporate business unit quotes 
* @author  TCS
*/
/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                            Description 
* 2019-01-18   Keerthana Thallam                 Created(DOC-3562,DOC-4352)
* =============================================================================
*/
public with sharing class APTS_CORP_LineItemTriggerHelper { 

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
            if(lineItem.APTS_Contract_Term__c!=null &&(lineItem.APTS_Contract_Term__c=='1 Year' || lineItem.APTS_Contract_Term__c=='2 Years' || lineItem.APTS_Contract_Term__c=='3 Years' || lineItem.APTS_Contract_Term__c=='4 Years' || lineItem.APTS_Contract_Term__c=='5 Years') && (lineItem.Apttus_Config2__LineStatus__c =='New' || lineItem.Apttus_Config2__LineStatus__c =='Renewed')){
              system.debug('entered term check');
              multiYearLineItems.add(lineItem);
            }      
        }
        
        for(Apttus_Config2__LineItem__c lineItem:multiYearLineItems){
            
           dollarValues=new List<Decimal>();
           multiYearPrices=new List<Decimal>();
           calculatedYear1Price=0.0;
           yoy2=(lineItem.APTS_Years_2_Plus_Adjustment__c!=null)?Integer.valueOf(lineItem.APTS_Years_2_Plus_Adjustment__c):0;
           yoy1Renewal=(lineItem.APTS_Yr_1_Renewal_Adjustment__c!=null)?Integer.valueOf(lineItem.APTS_Yr_1_Renewal_Adjustment__c):0;
           contractTerm=(lineItem.APTS_Contract_Term_Whole_Years__c).intValue();
           
           if(lineItem.Apttus_Config2__LineStatus__c =='New' && (lineItem.APTS_Term_Type__c!='ProRate' && lineItem.APTS_Term_Type__c!='Co-Term and ProRate')){
                  lineItem.APTS_Calculated_Year_1__c=lineItem.Apttus_Config2__NetPrice__c; 
                  calculatedYear1Price=lineItem.Apttus_Config2__NetPrice__c;                                
           }
           if(lineItem.Apttus_Config2__LineStatus__c =='Renewed' && lineItem.Apttus_Config2__AdjustmentType__c==null && (lineItem.APTS_Term_Type__c!='ProRate' && lineItem.APTS_Term_Type__c!='Co-Term and ProRate')){
                  lineItem.APTS_Calculated_Year_1__c=(((lineItem.Apttus_Config2__NetPrice__c*yoy1Renewal)/100)+lineItem.Apttus_Config2__NetPrice__c).setScale(2);    
                  calculatedYear1Price=(((lineItem.Apttus_Config2__NetPrice__c*yoy1renewal)/100)+lineItem.Apttus_Config2__NetPrice__c).setScale(2);                                
           }  
           if(lineItem.Apttus_Config2__LineStatus__c =='Renewed' && lineItem.Apttus_Config2__AdjustmentType__c!=null && lineItem.Apttus_Config2__AdjustmentType__c=='Price Override' && (lineItem.APTS_Term_Type__c!='ProRate' && lineItem.APTS_Term_Type__c!='Co-Term and ProRate')){
                  lineItem.APTS_Calculated_Year_1__c=lineItem.Apttus_Config2__NetPrice__c;    
                  calculatedYear1Price=lineItem.Apttus_Config2__NetPrice__c;                                
           } 
           if((lineItem.Apttus_Config2__LineStatus__c =='New' ||lineItem.Apttus_Config2__LineStatus__c =='Renewed') && (lineItem.APTS_Term_Type__c=='ProRate' || lineItem.APTS_Term_Type__c=='Co-Term and ProRate')){
                  if(lineItem.APTS_Start_Date__c!=null && lineItem.APTS_End_Date__c!=null){
                    lineItem.APTS_Calculated_Year_1__c=((lineItem.Apttus_Config2__NetPrice__c /365)*((lineItem.APTS_Start_Date__c.daysBetween(lineItem.APTS_End_Date__c))+1)).setScale(2);
                  }
                  else{
                    lineItem.APTS_Calculated_Year_1__c=lineItem.Apttus_Config2__NetPrice__c;    
                  }
                    calculatedYear1Price=lineItem.Apttus_Config2__NetPrice__c;  
           }          
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
 
    //DOC-1187 - In this method instead of Integer coverting it in to Decimal
    public static Decimal calculateMinYoy(List<Decimal> dollarValuesList){
        List<Decimal> yoyList=new List<Decimal>();
        //List<Integer> yoyList=new List<Integer>();
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
              //yoyList.add((((dollarValuesList.get(i+1)-dollarValuesList.get(i))*100)/dollarValuesList.get(i)).intValue());
              yoyList.add((((dollarValuesList.get(i+1)-dollarValuesList.get(i))*100)/dollarValuesList.get(i)).setScale(2));
            }
        }
        yoyList.sort();
        System.debug('yoyList:'+yoyList);
        return yoyList[0];
    
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
    //DOC-4586 starts,added the below method as part of DOC-4586
    public static void populateAllApprovalsRequiredforCorp(List<Apttus_Config2__LineItem__c> lineItemsList){
           
           for(Apttus_Config2__LineItem__c lineItem : lineItemsList) {
              lineItem.APTS_Short_Term_Bridge_Approval__c = FALSE;
           } 
           
           for(Apttus_Config2__LineItem__c lineItem : lineItemsList) {
                if(lineItem.APTS_Contract_Term__c!=null && lineItem.APTS_Contract_Term__c == 'Short Term Trial' && lineItem.APTS_Bridge__c != NULL 
                       && lineItem.APTS_Bridge__c != '7 Days' && lineItem.APTS_Bridge__c != '14 Days' 
                       && lineItem.APTS_Bridge__c != '28 Days'){
                         //Start : DOC-8089: Replace Corporate Investigative with Corporate Strategic, Corporate Global7
                         if(lineItem.APTS_Approval_Segment__c != null 
                         && (lineItem.APTS_Approval_Segment__c.contains('Corporate Strategic') 
                             || lineItem.APTS_Approval_Segment__c.contains('Corporate SMB') 
                             || lineItem.APTS_Approval_Segment__c.contains('Corporate Large') 
                             || lineItem.APTS_Approval_Segment__c.contains('Corporate Global7'))){
                            lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                            lineItem.APTS_Short_Term_Bridge_Approval__c = TRUE;
                         }
                }
                
                //DOC-4328 starts,DOC-11287, Removing Integer and consider as in Decimal
                if(lineItem.APTS_Years_2_Plus_Adjustment__c !=null && lineItem.APTS_Calculated_Min_YOY__c <= 3.00 && lineItem.APTS_Calculated_Min_YOY__c != null){                                    
                //if(lineItem.APTS_Years_2_Plus_Adjustment__c !=null && Integer.valueOf(lineItem.APTS_Calculated_Min_YOY__c ) <= 3 && lineItem.APTS_Calculated_Min_YOY__c != null){                                    
                    lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';   
                    lineItem.APTS_Minimum_YoY_Increase__c = true;    
                    lineItem.APTS_Corporate_Approval_Required__c =true;                    
                }
                //DOC-4328 ends
           }
    }
    //DOC-4586 ends
}