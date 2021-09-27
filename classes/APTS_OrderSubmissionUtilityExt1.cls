/**
 * @description Helper class for APTS_OrderQueueToESI    
 */
public with sharing class APTS_OrderSubmissionUtilityExt1{
      
        /**
         * @description createMLAHeader
         * @param order
         * @param mlaBundle
         * @param mlaOption
         * @return CreateOrderRequest.MLAHeader 
         */
        public static CreateOrderRequest.MLAHeader createMLAHeader(Apttus_Config2__Order__c order,Apttus_Config2__OrderLineItem__c mlaBundle, String mlaOption){
            CreateOrderRequest.MLAHeader mlaHeader=new CreateOrderRequest.MLAHeader();
            mlaHeader.mlaOption = mlaOption;
            mlaHeader.soldTo=order.APTS_SSD_Sold_To__r.Source_System_Account_Number__c; 
            mlaHeader.material= mlaBundle.Apttus_Config2__ProductId__r.ProductCode;   
            //skgif(MLAbundle.APTS_Bridge_Discount_Number__c!=null && mlaBundle.APTS_Bridge_Length__c!=null)   
            if(order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c == 'SCS'){
                /*if(mlaBundle.APTS_New_Bridge_Discount__c!=null){
                    mlaHeader.agreementNetPrice=string.valueof(mlaBundle.APTS_Bridge_Monthly_Charge__c);
                }else{   
                    if(mlaBundle .Apttus_Config2__NetPrice__c!=null){   
                        mlaHeader.agreementNetPrice=string.valueof((mlaBundle .Apttus_Config2__NetPrice__c).setscale(2));  
                    } 
                }*/
                mlaHeader.agreementNetPrice = returnNetPBundleSCS(mlaBundle, mlaHeader);
            }
            if(order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c == 'Canada'){
                /*if  (mlaBundle.APTS_New_Bridge_Discount__c!=null){ 
                    mlaHeader.agreementNetPrice=string.valueof(mlaBundle.APTS_Bridge_Monthly_Charge__c.setscale(2));   
                }   
                else{    //DOC 804 Agreement Net Price/12 for Yearly Billing Frequency  
                    if(mlaBundle .Apttus_Config2__NetPrice__c!=null){
                        mlaHeader.agreementNetPrice= string.valueof(mlaBundle.Apttus_Config2__NetPrice__c.setscale(2));  
                    } 
                    if(mlaBundle .Apttus_Config2__NetPrice__c!=null && mlaBundle .Apttus_Config2__BillingFrequency__c=='Yearly'){   
                        mlaHeader.agreementNetPrice=string.valueof((mlaBundle .Apttus_Config2__NetPrice__c/12).setscale(2));  
                    }   
                } */
                
                mlaHeader.agreementNetPrice = returnNetPBundleCAN(mlaBundle, mlaHeader);
            }
            
            if (MLAbundle.APTS_Decentralized__c==true && MLAHeader.mlaOption!='Modify') {                           
               MLAHeader.determineBillPayer='D';    
               MLAHeader.determineBillTo='D';   
            } else if (MLAbundle.APTS_Decentralized__c==false && MLAHeader.mlaOption!='Modify') {               
               MLAHeader.determineBillPayer= 'C';   
               MLAHeader.determineBillTo='C';   
            } 
            System.debug(LoggingLevel.WARN,'############## mlaHeader'+mlaHeader);
            return mlaHeader;              
        }
    
        /** 
        * @description returnNetPBundleSCS
        * @return returnNetPBundleSCS
        * @param mlaBundle
        * @param mlaHeader
        */
        public static string returnNetPBundleSCS(Apttus_Config2__OrderLineItem__c mlaBundle, CreateOrderRequest.MLAHeader mlaHeader){
            if(mlaBundle.APTS_New_Bridge_Discount__c!=null){
                mlaHeader.agreementNetPrice=string.valueof(mlaBundle.APTS_Bridge_Monthly_Charge__c);
            }else{   
                if(mlaBundle .Apttus_Config2__NetPrice__c!=null){   
                    mlaHeader.agreementNetPrice=string.valueof((mlaBundle.Apttus_Config2__NetPrice__c).setscale(2));  
                } 
            }
            return mlaHeader.agreementNetPrice;
        }
    
        /** 
        * @description returnNetPBundleCAN
        * @return returnNetPBundleCAN
        * @param mlaBundle
        * @param mlaHeader
        */
        public static string returnNetPBundleCAN(Apttus_Config2__OrderLineItem__c mlaBundle, CreateOrderRequest.MLAHeader mlaHeader){
            if(mlaBundle.APTS_New_Bridge_Discount__c!=null && mlaBundle.APTS_Bridge_Monthly_Charge__c != null){
                if (mlaBundle.Apttus_Config2__BillingFrequency__c=='Yearly' ){ //DOC-16395
                    mlaHeader.agreementNetPrice=string.valueof((mlaBundle.APTS_Bridge_Monthly_Charge__c/12).setscale(2));}
                else{
                    mlaHeader.agreementNetPrice=string.valueof(mlaBundle.APTS_Bridge_Monthly_Charge__c.setscale(2));}  
            }   
            else{    //DOC 804 Agreement Net Price/12 for Yearly Billing Frequency  
                if(mlaBundle .Apttus_Config2__NetPrice__c!=null){
                    mlaHeader.agreementNetPrice= string.valueof(mlaBundle.Apttus_Config2__NetPrice__c.setscale(2));  
                } 
                if(mlaBundle .Apttus_Config2__NetPrice__c!=null && mlaBundle .Apttus_Config2__BillingFrequency__c=='Yearly'){   
                    mlaHeader.agreementNetPrice=string.valueof((mlaBundle .Apttus_Config2__NetPrice__c/12).setscale(2));  
                }   
            }
            System.debug(LoggingLevel.WARN,'############## mlaHeader.agreementNetPrice'+mlaHeader.agreementNetPrice);
            return mlaHeader.agreementNetPrice;
        }
        
        /**
         * @description createMLAHeaderDB
         * @param order
         * @param mlaBundle
         * @param mlaOption
         * @return CreateOrderRequest.MLAHeader 
         */
        public static CreateOrderRequest.MLAHeader createMLAHeaderDB(Apttus_Config2__Order__c order,APTS_Dynamic_Bundle__c mlaBundle, String mlaOption){
            CreateOrderRequest.MLAHeader mlaHeader=new CreateOrderRequest.MLAHeader();
            mlaHeader.mlaOption = mlaOption;
            mlaHeader.soldTo=order.APTS_SSD_Sold_To__r.Source_System_Account_Number__c; 
            mlaHeader.material= mlaBundle.APTS_Bundle_Primary_Material__c;   
            //skgif(mlaBundle.APTS_Bridge_Discount_Number__c!=null && mlaBundle.APTS_Bridge_Length__c!=null) 
            if(order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c == 'SCS'){
                /*if(mlaBundle.APTS_Bridge_Monthly_Charges__c != null){
                    mlaHeader.agreementNetPrice=string.valueof(mlaBundle.APTS_Bridge_Monthly_Charges__c);
                }else{      
                    mlaHeader.agreementNetPrice= string.valueof(mlaBundle.APTS_Net_Price__c); 
                }*/
                mlaHeader.agreementNetPrice = returnBundleValSCS(mlaBundle, mlaHeader);
            }
    
            if(order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c == 'Canada'){
                /*if  (mlaBundle.APTS_Bridge_Monthly_Charges__c != null){ 
                    mlaHeader.agreementNetPrice=string.valueof(mlaBundle.APTS_Bridge_Monthly_Charges__c.setscale(2));   
                }   
                else{    //DOC 804 Agreement Net Price/12 for Yearly Billing Frequency              
                    mlaHeader.agreementNetPrice= string.valueof(mlaBundle.APTS_Net_Price__c);   
                    if(mlaBundle .APTS_Net_Price__c!=null && mlaBundle.APTS_Billing_Frequency__c=='Yearly'){   
                        mlaHeader.agreementNetPrice=string.valueof((mlaBundle .APTS_Net_Price__c/12).setscale(2));  
                    }   
                }  */ 
                mlaHeader.agreementNetPrice = returnBundleValCAN(mlaBundle, mlaHeader);
            }
            
            if(mlaBundle.APTS_Decentralized__c == true && mlaOption != 'Modify'){                       
                mlaHeader.determineBillPayer = 'D';
                mlaHeader.determineBillTo = 'D';
            }else if(mlaBundle.APTS_Decentralized__c == false && mlaOption != 'Modify'){             
                mlaHeader.determineBillPayer = 'C';
                mlaHeader.determineBillTo = 'C';
            }      
            System.debug(LoggingLevel.WARN,'############## mlaHeader'+mlaHeader);
            return mlaHeader;              
        }
    
        /** 
         * @description returnBundleValSCS
         * @return returnBundleValSCS
         * @param mlaBundle
         * @param mlaHeader
        */
        public static string returnBundleValSCS(APTS_Dynamic_Bundle__c mlaBundle, CreateOrderRequest.MLAHeader mlaHeader){
            if(mlaBundle.APTS_Bridge_Monthly_Charges__c != null){
                mlaHeader.agreementNetPrice=string.valueof(mlaBundle.APTS_Bridge_Monthly_Charges__c);
            }else{      
                mlaHeader.agreementNetPrice= string.valueof(mlaBundle.APTS_Net_Price__c); 
            }  
            return mlaHeader.agreementNetPrice;
        }
    
        /** 
         * @description returnBundleValCAN
         * @return returnBundleValCAN
         * @param mlaBundle
         * @param mlaHeader
        */
        public static string returnBundleValCAN(APTS_Dynamic_Bundle__c mlaBundle, CreateOrderRequest.MLAHeader mlaHeader){
            if  (mlaBundle.APTS_Bridge_Monthly_Charges__c != null){ 
                mlaHeader.agreementNetPrice=string.valueof(mlaBundle.APTS_Bridge_Monthly_Charges__c.setscale(2));   
            }   
            else{    //DOC 804 Agreement Net Price/12 for Yearly Billing Frequency              
                mlaHeader.agreementNetPrice= string.valueof(mlaBundle.APTS_Net_Price__c);   
                if(mlaBundle .APTS_Net_Price__c!=null && mlaBundle.APTS_Billing_Frequency__c=='Yearly'){   
                    mlaHeader.agreementNetPrice=string.valueof((mlaBundle .APTS_Net_Price__c/12).setscale(2));  
                }   
            }
            return mlaHeader.agreementNetPrice;
        }
        
        /**
           * @description assignDealLines
           * @return assignDealLines
           * @param lNo
           * @param recType
           * @param mapDecimalValues
           */
          public static CreateOrderRequest.lineItems assignDealLines(integer lNo,string recType,Map<Decimal,Decimal> mapDecimalValues) {
            Decimal cno;
            Decimal cln;
            Decimal quantity;
            cno = mapDecimalValues.get(1);
            cln = mapDecimalValues.get(2);
            quantity = mapDecimalValues.get(3);
            CreateOrderRequest.lineItems ln = new CreateOrderRequest.lineItems();         
            ln.recordType = recType;
            ln.lineNumber = (lNo != 0? string.valueof(lNo) : '');
            ln.existingSub = (cno != 0? string.valueof(cno) : '');
            ln.existingSubLine = (cln != 0? string.valueof(cln) : '');
            ln.quanity = (quantity != 0? string.valueOf(quantity).substringBefore('.') : '');
            System.debug(LoggingLevel.WARN,'############## ln'+ln);
            return ln;
            
        }
        
        /**
         * @description returnDecimalMap
         * @return returnDecimalMap
         * @param pOne
         * @param pTwo
         * @param pThree
         */
        public static Map<Decimal,Decimal> returnDecimalMap(Decimal pOne,Decimal pTwo,Decimal pThree){
            Decimal cno=1;
            Decimal cln=2;
            Decimal quantity=3;
            Map<Decimal,Decimal> mapValues = new Map<Decimal,Decimal>();
            mapValues.put(cno,pOne);
            mapValues.put(cln,pTwo);
            mapValues.put(quantity,pThree);
            System.debug(LoggingLevel.WARN,'############## mapValues'+mapValues);
            return mapValues;
        }
        
        /**
         * @description returnStringMap
         * @return returnStringMap
         * @param pOne
         * @param pTwo
         * @param pThree
         */
        public static Map<String,String> returnStringMap(String pOne,String pTwo,String pThree){
            Map<String,String> mapValues = new Map<String,String>();
            mapValues.put('tLen',pOne);
            mapValues.put('period',pTwo);
            mapValues.put('percInc',pThree);
            System.debug(LoggingLevel.WARN,'############## mapValues'+mapValues);
            return mapValues;
        }
        
        /**
         * @description termUtil
         * @return termUtil
         * @param strMap 
         * @param bValue
         * @param uRate
         */ 
        public static CreateOrderRequest.terms termUtil(Map<String,String> strMap, Decimal bValue, Decimal uRate) {
            string tLen = strMap.get('tLen');
            string period = strMap.get('period');
            string percInc = strMap.get('percInc');
            CreateOrderRequest.terms term = new CreateOrderRequest.terms();
            term.termLength= tLen;
            term.period= period;
            term.percentIncrease= percInc;
            term.baseValue= bValue;
            term.userRate= uRate;
            System.debug(LoggingLevel.WARN,'############## term'+term);
            return term;
        }
    }