/********************************************************************************************
ClassName: ManageBillingAccountsController
Description: This class is used for implementing the business logic for Add Billing Account to Master Opportunity.
DevelopedBy: TCS Offshore, Kolkata 
Revision:
Fixed Defect#:
*********************************************************************************************/
public class ManageBillingAccountsController{

    public Opportunity opp{get;set;}       
    public List<OpportunityLineItem> lstOppLineItem {get;set;}
    public List<wrapBillingAccount> lstwrapBillAcc {get;set;}
    public List<Billing_Account_Split__c> selectedBillAcc{get;set;}    
    public List<Billing_Account_Split__c> lstBA{get;set;}  
    public Integer intCountCurrentBA;
    public String baId {get;set;}      
    public String strProdTotPrice {get;set;}
    public String strOppTotPrice {get;set;}
    public String strNumOfPro {get;set;}
    public String strUserCurrency {get;set;} 
    public String strOppCurrency {get;set;}
    public String strIsCommaCurrUser {get;set;}
    
    String strMasterOppId;
    String strMasterOppDesc; 
    public ManageBillingAccountsController(ApexPages.StandardSetController controller) {
        try {
            baId = '';
            strMasterOppId = '';
            strProdTotPrice = '';
            strNumOfPro = '';             
            strMasterOppDesc = '';   
            strIsCommaCurrUser = '';       
            
            strUserCurrency = [SELECT DefaultCurrencyIsoCode FROM User WHERE id =: UserInfo.getUserId()].DefaultCurrencyIsoCode;            

            if(ApexPages.currentPage().getParameters().get('id') != null){

                strMasterOppId = ApexPages.currentPage().getParameters().get('id');
                strMasterOppDesc = [SELECT Description FROM Opportunity WHERE Id =: strMasterOppId].Description;
            }   
            else{
                System.Debug('Master Opportunity id is not found. Constructor = ManageBillingAccountsCtrl, class = ManageBillingAccountsCtrl.');
            }      
            //lstBA = [SELECT Id,Name,Account__c, CurrencyIsoCode, PO_Number__c, E_Billing_Contact__c, Boleto_Contact__c, Product_1__c, Product_1_Sales_Price__c, Product_1_Quantity__c, Product_2__c, Product_2_Sales_Price__c, Product_2_Quantity__c, Product_3__c, Product_3_Sales_Price__c, Product_3_Quantity__c, Subtotal_Amount__c, Percentage_MO_Amount__c, Opportunity_Notes__c, Invoice_Notes__c FROM Billing_Account_Split__c WHERE Billing_Account_Split__c.Master_Opportunity__c =:strMasterOppId];
            lstOppLineItem = [SELECT OpportunityId, Product2Id, PricebookEntry.Product2.Name, ListPrice, UnitPrice, Quantity, Subtotal, Discount, TotalPrice, MOLI_id__c FROM OpportunityLineItem WHERE OpportunityId =: strMasterOppId ORDER BY Lastmodifieddate DESC LIMIT 3];
            System.Debug('*****lstOppLineItem '+ lstOppLineItem);
            Decimal decProdTotPrice = 0.00;
            
            for(OpportunityLineItem oppLI : lstOppLineItem)
            {
                if(oppLI.TotalPrice != null && String.valueOf(oppLI.TotalPrice).trim() != ''){
                     decProdTotPrice += oppLI.TotalPrice;
                }
            }           
            
            strProdTotPrice = String.ValueOf(decProdTotPrice);
            if(strUserCurrency == 'BRL' || strUserCurrency == 'ARS' || strUserCurrency == 'CLP' ||
               strUserCurrency == 'PYG' || strUserCurrency == 'UYU'){
               strIsCommaCurrUser = '1';
            }
            
            loadData();         
            strOppCurrency = String.ValueOf(opp.CurrencyIsoCode);
            
            if(strUserCurrency == strOppCurrency){
                strOppTotPrice = strProdTotPrice;
            }
            else{               
                
                CurrencyType objOppCurrType = [Select IsoCode, ConversionRate From CurrencyType WHERE IsoCode =: opp.CurrencyIsoCode];
                CurrencyType objUserCurrType = [Select IsoCode, ConversionRate From CurrencyType WHERE IsoCode =: strUserCurrency];
                
                Decimal decConvertAmt = 0.00;
                Decimal decUserCR = 0.000000;
                Decimal decOppCR = 0.000000;
                
                decOppCR = objOppCurrType.ConversionRate;
                decUserCR = objUserCurrType.ConversionRate;              
                
                //system.debug('*******decUserCR='+decUserCR);
                //system.debug('*******decOppCR='+decOppCR);
                //system.debug('*******decProdTotPrice='+decProdTotPrice);
                
                if(decUserCR == decOppCR){
                    strOppTotPrice = strProdTotPrice;
                    //system.debug('*******Step 1='+strOppTotPrice);
                }
                else{
                    decConvertAmt = (decUserCR/decOppCR)*decProdTotPrice;
                    strOppTotPrice = String.ValueOf(decConvertAmt);   
                    //system.debug('*******Step 2='+strOppTotPrice);                 
                }                
            }           
        }
        catch(Exception ex) {
            System.Debug('Exception occured. Constructor = ManageBillingAccountsCtrl, class = ManageBillingAccountsCtrl, ERROR='+ ex);
        }
    }
    
    /********************************************************************************************
    MethodName: addBillAcct
    Description: Method is used for adding a new Billing Account.
    DevelopedBy: TCS Offshore, Kolkata 
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
    public void addBillAcct() 
    {       
        try {
            Billing_Account_Split__c objBAnew = new Billing_Account_Split__c(Master_Opportunity__c = strMasterOppId, Opportunity_Notes__c = strMasterOppDesc);    
            /*------------SFD-1219/1220-----------------*/
            if(intCountCurrentBA == 0) {
                intCountCurrentBA = lstBA.size()+1;
            }
            else{
                intCountCurrentBA = intCountCurrentBA+1;
            }
            /*------------SFD-1219/1220-----------------*/
            lstwrapBillAcc.add(new wrapBillingAccount(objBAnew, '', '', createProductList(objBAnew)));
        }
        catch(Exception ex) {
            System.Debug('Exception occured. method = addBillAcct, class = ManageBillingAccountsCtrl, ERROR='+ ex);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(myMsg);
        }       
    }
    
    /********************************************************************************************
    MethodName: saveBillAccts
    Description: Method is used for only saving the Billing Accounts.
    DevelopedBy: TCS Offshore, Kolkata 
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
    public pagereference saveBillAccts() 
    {
        try {
            pagereference pr;        
            List<Billing_Account_Split__c> lstBillAcct = createBillingAcctList();
            
            if(lstBillAcct.size() > 0){
                Database.Upsert(lstBillAcct);
            }            
            
            pr = new pagereference('/apex/ManageBillingAccounts?id='+strMasterOppId);
            pr.setRedirect(true);
            return pr;            
        }    
        catch(Exception ex) {
            System.Debug('Exception occured. method = saveBillAccts, class = ManageBillingAccountsCtrl, ERROR='+ ex);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }        
    }
    
    /********************************************************************************************
    MethodName: saveCloseBillAccts
    Description: Method is used for saving the Billing Accounts and next redirect to master opportunity page.
    DevelopedBy: TCS Offshore, Kolkata 
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
    public pagereference saveCloseBillAccts()
    {
        try {
            pagereference pr;
            List<Billing_Account_Split__c> lstBillAcct = createBillingAcctList();            
            
            if(lstBillAcct.size() > 0){
                Database.Upsert(lstBillAcct);                                
            }
                
            pr = new pagereference('/apex/OpportunityDetail?id='+strMasterOppId);
            pr.setRedirect(true);
            return pr;
        }
        catch(Exception ex){           
            System.Debug('Exception occured. method = saveCloseBillAccts, class = ManageBillingAccountsCtrl, ERROR='+ ex); 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(myMsg); 
            return null;          
        } 
    }    
    
    /********************************************************************************************
    MethodName: deleteBillAcct
    Description: Method is used for deleting the Billing Account.
    DevelopedBy: TCS Offshore, Kolkata 
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
    public void deleteBillAcct() {
        //System.debug('In Delete Method');
        
        try {
            Integer iRowNum = Integer.ValueOf(ApexPages.currentPage().getParameters().get('rowNum'));
            //Integer iBlankRowNum = 0;
            iRowNum -= 1;
            
            if(baId != null && baId != '') {
                List<Billing_Account_Split__c> lstDeleteBA = [SELECT Id FROM Billing_Account_Split__c WHERE Id =: baId];
                if(lstDeleteBA.size() > 0 && lstDeleteBA != null) {
                    DELETE lstDeleteBA;
                }
                /*for(wrapBillingAccount objWrap: lstwrapBillAcc){
                    if(objWrap.objBillAcc.Id == null){
                        iBlankRowNum++;
                    }
                }*/
                loadData();
                /*System.Debug('****iBlankRowNum='+ iBlankRowNum);
                for(Integer i=0; i<iBlankRowNum; i++){
                    addBillAcct(); 
                    System.Debug('******Inside For Loop='+i);           
                }*/
            }
            else {
                //System.Debug('iRowNum='+ iRowNum); 
                lstwrapBillAcc.remove(iRowNum);
            }         
        }    
        catch(Exception ex) {
            System.Debug('Exception occured. method = deleteBillAcct, class = ManageBillingAccountsCtrl, ERROR='+ ex);
          //  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
          //  ApexPages.addMessage(myMsg);
        }
    }    
    
    /********************************************************************************************
    MethodName: loadData
    Description: Method is used for retrieving Master Opportunity and the Billing Accounts which are associated to master opportunity.
    DevelopedBy: TCS Offshore, Kolkata 
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
    private void loadData()
    {   
        opp = [select Id,Name, Opportunity_currency__c, CurrencyIsoCode, Oppty_Mgmt_Type__c, BA_Split_Amount_Subtotal__c, BA_Split_Amount_Subtotal_Variance__c, BA_Split_Variance_Status__c FROM Opportunity WHERE Id =: strMasterOppId];
        
        lstwrapBillAcc = new List<wrapBillingAccount>();
        intCountCurrentBA = 0;//SFD-1219/1220
        lstBA = [SELECT Id,Name,Account__c, CurrencyIsoCode, PO_Number__c, E_Billing_Contact__c, Boleto_Contact__c, Product_1__c, Product_1_Sales_Price__c, Product_1_Quantity__c, Product_2__c, Product_2_Sales_Price__c, Product_2_Quantity__c, Product_3__c, Product_3_Sales_Price__c, Product_3_Quantity__c, Subtotal_Amount__c, Percentage_MO_Amount__c, Opportunity_Notes__c, Invoice_Notes__c, OLI_id_1__c, OLI_id_2__c, OLI_id_3__c FROM Billing_Account_Split__c WHERE Billing_Account_Split__c.Master_Opportunity__c =:strMasterOppId];
        system.debug('****lstBA ='+lstBA);    
        for(Billing_Account_Split__c bilAcc : lstBA)
        {   
           String sSubTotal = String.ValueOf(bilAcc.Subtotal_Amount__c);
           String sAmtPer = String.ValueOf(bilAcc.Percentage_MO_Amount__c);
           
           if(strIsCommaCurrUser == '1'){
               sSubTotal = sSubTotal.replace('.', ',');
               sAmtPer = sAmtPer.replace('.', ',');
           }    
           
           lstwrapBillAcc.add(new wrapBillingAccount(bilAcc, sSubTotal, sAmtPer, createProductList(bilAcc)));
           //saveBillAccts();  
           system.debug('****lstwrapBillAcc='+lstwrapBillAcc);  
                
        }
    }
    
    /********************************************************************************************
    MethodName: createProductList
    Description: Method is used for preparing a wrapper class list of Opportunity product.
    DevelopedBy: TCS Offshore, Kolkata 
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
    private List<wrapProduct> createProductList(Billing_Account_Split__c objBA)
    {
       List<wrapProduct> lstWrapProduct = new List<wrapProduct>();
       List<wrapProduct> lstWrapProduct1 = new List<wrapProduct>();
       String strPriceNumber = '';
       String strPriceNumber1 = '';
       String strPriceNumber2 = '';
       String strPriceNumber3 = '';
       Integer intCountCurrentBAProd = 0;
       String productId = ''; 
           
       Billing_Account_Split__c objTempBA = new Billing_Account_Split__c(); 
       //List<Billing_Account_Split__c> lstBA1 = [SELECT Id,Name,Account__c, CurrencyIsoCode, PO_Number__c, E_Billing_Contact__c, Boleto_Contact__c, Product_1__c, Product_1_Sales_Price__c, Product_1_Quantity__c, Product_2__c, Product_2_Sales_Price__c, Product_2_Quantity__c, Product_3__c, Product_3_Sales_Price__c, Product_3_Quantity__c, Subtotal_Amount__c, Percentage_MO_Amount__c, Opportunity_Notes__c, Invoice_Notes__c FROM Billing_Account_Split__c WHERE Billing_Account_Split__c.Master_Opportunity__c =:strMasterOppId];
       if(lstBA.size() == 0 && lstBA.isEmpty()){
            for(Integer i=0; i < lstOppLineItem.size(); i++){  
               //String productPrice = '';
               if(i == 0){                         
                   if(lstOppLineItem[i].Product2Id != null){
                      productId = String.valueOf(lstOppLineItem[i].Product2Id);
                      objTempBA.OLI_id_1__c = lstOppLineItem[i].MOLI_id__c;
                   } 
                   if(objBA.Product_1_Sales_Price__c != null){
                      objTempBA.Product_1_Sales_Price__c = objBA.Product_1_Sales_Price__c;
                      objTempBA.id = objBA.id;
                      //objTempBA.OLI_id_1__c = lstOppLineItem[i].MOLI_id__c;
                   }
                   lstWrapProduct.add(new wrapProduct(productId, String.valueOf(lstOppLineItem[i].PricebookEntry.Product2.Name), '1', objTempBA, '1', lstOppLineItem[i].MOLI_id__c));
                   system.debug('****createProductList product 1='+lstWrapProduct);
               }
               else if(i == 1){    
                    if(lstOppLineItem[i].Product2Id != null){
                      productId = String.valueOf(lstOppLineItem[i].Product2Id);
                      objTempBA.OLI_id_2__c = lstOppLineItem[i].MOLI_id__c;
                   } 
                   if(objBA.Product_2_Sales_Price__c != null){
                      objTempBA.Product_2_Sales_Price__c = objBA.Product_2_Sales_Price__c;
                      objTempBA.id = objBA.id;
                      //objTempBA.OLI_id_2__c = lstOppLineItem[i].MOLI_id__c;
                   }
                   lstWrapProduct.add(new wrapProduct(productId, String.valueOf(lstOppLineItem[i].PricebookEntry.Product2.Name), '1', objTempBA, '2', lstOppLineItem[i].MOLI_id__c));
                   system.debug('****createProductList product 2='+lstWrapProduct);
               }
               else if(i == 2){
                   if(lstOppLineItem[i].Product2Id != null){
                      productId = String.valueOf(lstOppLineItem[i].Product2Id);
                      objTempBA.OLI_id_3__c = lstOppLineItem[i].MOLI_id__c;
                   }   
                   if(objBA.Product_3_Sales_Price__c != null){
                      objTempBA.Product_3_Sales_Price__c = objBA.Product_3_Sales_Price__c;
                      objTempBA.id = objBA.id;
                      //objTempBA.OLI_id_3__c = lstOppLineItem[i].MOLI_id__c;
                   }
                   lstWrapProduct.add(new wrapProduct(productId, String.valueOf(lstOppLineItem[i].PricebookEntry.Product2.Name), '1', objTempBA, '3', lstOppLineItem[i].MOLI_id__c));
                   system.debug('****createProductList product 3='+lstWrapProduct);
               }           
           }
       }
        /*------------SFD-1219/1220-----------------*/
       else{
           for(Billing_Account_Split__c bas : lstBA){
            /*------------SFD-1121-----------------*/
               strPriceNumber1 = bas.OLI_id_1__c;
               strPriceNumber2 = bas.OLI_id_2__c;
               strPriceNumber3 = bas.OLI_id_3__c;
            /*------------SFD-1121-----------------*/
               //break;
           }
           System.debug('******Product 1 id > strPriceNumber1:'+strPriceNumber1);
           System.debug('******Product 2 id > strPriceNumber2:'+strPriceNumber2);
           System.debug('******Product 3 id > strPriceNumber3:'+strPriceNumber3);
           
           for(OpportunityLineItem oli : lstOppLineItem){
              intCountCurrentBAProd = 0;
              System.debug('******Product 1 id > strPriceNumber1:'+strPriceNumber1);
               System.debug('******Product 2 id > strPriceNumber2:'+strPriceNumber2);
               System.debug('******Product 3 id > strPriceNumber3:'+strPriceNumber3);
              if(strPriceNumber1 != '' && strPriceNumber1 != null){
                  if(oli.MOLI_id__c == strPriceNumber1){
                       if(oli.Product2Id != null){
                          productId = String.valueOf(oli.Product2Id);
                          objTempBA.OLI_id_1__c = oli.MOLI_id__c;//SFD-1121
                       } 
                       if(objBA.Product_1_Sales_Price__c != null){
                          objTempBA.Product_1_Sales_Price__c = objBA.Product_1_Sales_Price__c;
                          objTempBA.id = objBA.id;
                          //objTempBA.OLI_id_1__c = oli.MOLI_id__c;
                       }
                       lstWrapProduct.add(new wrapProduct(productId, String.valueOf(oli.PricebookEntry.Product2.Name), '1', objTempBA, '1', oli.MOLI_id__c));
                       system.debug('****createProductList product 1='+lstWrapProduct);
                  }
                  intCountCurrentBAProd = intCountCurrentBAProd + 1;
              }
              System.debug('******Product 1 id > strPriceNumber1:'+strPriceNumber1);
           System.debug('******Product 2 id > strPriceNumber2:'+strPriceNumber2);
           System.debug('******Product 3 id > strPriceNumber3:'+strPriceNumber3);
              if(strPriceNumber2 != '' && strPriceNumber2 != null){
                  if(oli.MOLI_id__c == strPriceNumber2){
                       if(oli.Product2Id != null){
                          productId = String.valueOf(oli.Product2Id);
                          objTempBA.OLI_id_2__c = oli.MOLI_id__c;//SFD-1121
                       } 
                       if(objBA.Product_2_Sales_Price__c != null){
                          objTempBA.Product_2_Sales_Price__c = objBA.Product_2_Sales_Price__c;
                          objTempBA.id = objBA.id;
                          //objTempBA.OLI_id_2__c = oli.MOLI_id__c;
                       }
                       lstWrapProduct.add(new wrapProduct(productId, String.valueOf(oli.PricebookEntry.Product2.Name), '1', objTempBA, '2', oli.MOLI_id__c));
                       
                       system.debug('****createProductList product 2='+lstWrapProduct);
                  }
                  intCountCurrentBAProd = intCountCurrentBAProd + 1;
              }  
              System.debug('******Product 1 id > strPriceNumber1:'+strPriceNumber1);
           System.debug('******Product 2 id > strPriceNumber2:'+strPriceNumber2);
           System.debug('******Product 3 id > strPriceNumber3:'+strPriceNumber3);
              if(strPriceNumber3 != '' && strPriceNumber3 != null){
                  if(oli.MOLI_id__c == strPriceNumber3){
                       if(oli.Product2Id != null){
                          productId = String.valueOf(oli.Product2Id);
                          objTempBA.OLI_id_3__c = oli.MOLI_id__c;//SFD-1121
                       } 
                       if(objBA.Product_3_Sales_Price__c != null){
                          objTempBA.Product_3_Sales_Price__c = objBA.Product_3_Sales_Price__c;
                          objTempBA.id = objBA.id;
                          //objTempBA.OLI_id_3__c = oli.MOLI_id__c;
                       }
                       lstWrapProduct.add(new wrapProduct(productId, String.valueOf(oli.PricebookEntry.Product2.Name), '1', objTempBA, '3', oli.MOLI_id__c));
                       
                       system.debug('****createProductList product 3='+lstWrapProduct);
                  }
                  intCountCurrentBAProd = intCountCurrentBAProd + 1;
              } 
              system.debug('******intCountCurrentBA:>>'+intCountCurrentBA);
              system.debug('******intCountCurrentBAProd:>>'+intCountCurrentBAProd);
              system.debug('******lstBA.size():>>'+lstBA.size());
              system.debug('******lstOppLineItem.size():>>'+lstOppLineItem.size());
              if((strPriceNumber1 == ''  || strPriceNumber1 == null) && ((intCountCurrentBA > lstBA.size() && lstBA.size() != 0 && lstOppLineItem.size() > intCountCurrentBAProd) || lstOppLineItem.size() > intCountCurrentBAProd) && (oli.MOLI_id__c != strPriceNumber2) && (oli.MOLI_id__c != strPriceNumber3)){
                   if(oli.Product2Id != null){
                      productId = String.valueOf(oli.Product2Id);
                      objTempBA.OLI_id_1__c = oli.MOLI_id__c;//SFD-1121
                   } 
                   if(objBA != null){
                      objTempBA.Product_1_Sales_Price__c = objBA.Product_1_Sales_Price__c;
                      objTempBA.id = objBA.id;
                      //objTempBA.OLI_id_1__c = oli.MOLI_id__c;
                   }
                   lstWrapProduct.add(new wrapProduct(productId, String.valueOf(oli.PricebookEntry.Product2.Name), '1', objTempBA, '1', oli.MOLI_id__c));
                  
                  system.debug('****createProductList product 3='+lstWrapProduct); 
                  strPriceNumber1 = oli.MOLI_id__c;
                  continue;
              } 
              if((strPriceNumber2 == ''  || strPriceNumber2 == null) && ((intCountCurrentBA > lstBA.size() && lstBA.size() != 0 && lstOppLineItem.size() > intCountCurrentBAProd) || lstOppLineItem.size() > intCountCurrentBAProd)  && (oli.MOLI_id__c != strPriceNumber3) && (oli.MOLI_id__c != strPriceNumber1)){
                   if(oli.Product2Id != null){
                      productId = String.valueOf(oli.Product2Id);
                      objTempBA.OLI_id_2__c = oli.MOLI_id__c;//SFD-1121
                   } 
                   if(objBA != null){
                      objTempBA.Product_2_Sales_Price__c = objBA.Product_2_Sales_Price__c;
                      objTempBA.id = objBA.id;
                      //objTempBA.OLI_id_2__c = oli.MOLI_id__c;
                   }
                   lstWrapProduct.add(new wrapProduct(productId, String.valueOf(oli.PricebookEntry.Product2.Name), '1', objTempBA, '2', oli.MOLI_id__c));
                  
                  system.debug('****createProductList product 3='+lstWrapProduct); 
                  strPriceNumber2 = oli.MOLI_id__c;
                  continue;
              } 
              if((strPriceNumber3 == ''  || strPriceNumber3 == null) && ((intCountCurrentBA > lstBA.size() && lstBA.size() != 0 && lstOppLineItem.size() > intCountCurrentBAProd) || lstOppLineItem.size() > intCountCurrentBAProd)  && (oli.MOLI_id__c != strPriceNumber1) && (oli.MOLI_id__c != strPriceNumber2)){
                   if(oli.Product2Id != null){
                      productId = String.valueOf(oli.Product2Id);
                      objTempBA.OLI_id_3__c = oli.MOLI_id__c;//SFD-1121
                   } 
                   if(objBA != null){
                      objTempBA.Product_3_Sales_Price__c = objBA.Product_3_Sales_Price__c;
                      objTempBA.id = objBA.id;
                      //objTempBA.OLI_id_3__c = oli.MOLI_id__c;
                   }
                   lstWrapProduct.add(new wrapProduct(productId, String.valueOf(oli.PricebookEntry.Product2.Name), '1', objTempBA, '3', oli.MOLI_id__c));
                  
                  system.debug('****createProductList product 3='+lstWrapProduct); 
                  strPriceNumber3 = oli.MOLI_id__c;
                  continue;
              } 
              system.debug('****createProductList product all='+lstWrapProduct);   
           }
       }
        /*------------SFD-1219/1220-----------------*/
       return lstWrapProduct;      
    }
    
    /********************************************************************************************
    MethodName: createBillingAcctList
    Description: Method is used for preparing a Billing Account list for upsert.
    DevelopedBy: TCS Offshore, Kolkata 
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
    private List<Billing_Account_Split__c> createBillingAcctList()
    {
        List<Billing_Account_Split__c> lstBillAcct = new List<Billing_Account_Split__c>();
            
        for(wrapBillingAccount wba : lstwrapBillAcc)
        {                
            for(Integer i=0; i < wba.lstWrpPro.size(); i++)
            {                    
                
                    if(wba.lstWrpPro[i].productId != ''){
                        if(wba.lstWrpPro[i].priceNumber == '1'){
                            wba.objBillAcc.Product_1__c = wba.lstWrpPro[i].productId;
                            wba.objBillAcc.OLI_id_1__c = wba.lstWrpPro[i].strOLIid;
                        }
                        else if(wba.lstWrpPro[i].priceNumber == '2'){
                            wba.objBillAcc.Product_2__c = wba.lstWrpPro[i].productId;
                            wba.objBillAcc.OLI_id_2__c = wba.lstWrpPro[i].strOLIid;
                        }
                        else if(wba.lstWrpPro[i].priceNumber == '3'){
                            wba.objBillAcc.Product_3__c = wba.lstWrpPro[i].productId;
                            wba.objBillAcc.OLI_id_3__c = wba.lstWrpPro[i].strOLIid;
                        }   
                    }
                
                    if(wba.lstWrpPro[i].priceNumber == '1'){//SFD-1219/1220
                        if(wba.lstWrpPro[i].objBAS.Product_1_Sales_Price__c != null && wba.lstWrpPro[i].priceNumber == '1'){//SFD-1219/1220
                                wba.objBillAcc.Product_1_Sales_Price__c = wba.lstWrpPro[i].objBAS.Product_1_Sales_Price__c;
                                wba.objBillAcc.Product_1_Quantity__c = 1;
                                //wba.objBillAcc.OLI_id_1__c = wba.lstWrpPro[i].strOLIid;
                        }
                        else{
                            wba.objBillAcc.Product_1_Sales_Price__c = 0;
                        }
                    }
                    else if(wba.lstWrpPro[i].priceNumber == '2'){//SFD-1219/1220
                        if(wba.lstWrpPro[i].objBAS.Product_2_Sales_Price__c != null && wba.lstWrpPro[i].priceNumber == '2'){//SFD-1219/1220
                            wba.objBillAcc.Product_2_Sales_Price__c = wba.lstWrpPro[i].objBAS.Product_2_Sales_Price__c;
                            wba.objBillAcc.Product_2_Quantity__c = 1;
                            //wba.objBillAcc.OLI_id_2__c = wba.lstWrpPro[i].strOLIid;
                        }
                        else{
                            wba.objBillAcc.Product_2_Sales_Price__c = 0;
                        }
                    }
                    else if(wba.lstWrpPro[i].priceNumber == '3'){ //SFD-1219/1220
                        if(wba.lstWrpPro[i].objBAS.Product_3_Sales_Price__c != null && wba.lstWrpPro[i].priceNumber == '3'){//SFD-1219/1220
                            wba.objBillAcc.Product_3_Sales_Price__c = wba.lstWrpPro[i].objBAS.Product_3_Sales_Price__c;
                            wba.objBillAcc.Product_3_Quantity__c = 1;
                            //wba.objBillAcc.OLI_id_3__c = wba.lstWrpPro[i].strOLIid;
                        }
                        else{
                            wba.objBillAcc.Product_3_Sales_Price__c = 0;
                        }
                    }
                    /************Commented as a part of SFD-1121**********************************/
                    
                    /*else if(wba.lstWrpPro[i].objBAS.Product_1_Sales_Price__c == null && wba.lstWrpPro[i].productId != ''){
                        wba.objBillAcc.Product_1_Sales_Price__c = 0;
                    }
                    else if(wba.lstWrpPro[i].objBAS.Product_2_Sales_Price__c == null && wba.lstWrpPro[i].productId != ''){
                        wba.objBillAcc.Product_2_Sales_Price__c = 0;
                    }
                    else if(wba.lstWrpPro[i].objBAS.Product_3_Sales_Price__c == null && wba.lstWrpPro[i].productId != ''){
                        wba.objBillAcc.Product_3_Sales_Price__c = 0;
                    }*/
                    /************Commented as a part of SFD-1121**********************************/
                    
                    system.debug('****createBillingAcctList product iteration 0='+wba.objBillAcc.Product_1_Sales_Price__c);
                    system.debug('****createBillingAcctList product iteration 0='+wba.objBillAcc.Product_2_Sales_Price__c);
                    system.debug('****createBillingAcctList product iteration 0='+wba.objBillAcc.Product_3_Sales_Price__c);
                
            }                
            
            lstBillAcct.add(wba.objBillAcc);
        }
        
        return lstBillAcct;
    }
    
    /********************************************************************************************
    ClassName: wrapBillingAccount
    Description: Class represent a wrapper class which is used to display Billing Account list including opportunity product.
    DevelopedBy: TCS Offshore, Kolkata 
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
    public class wrapBillingAccount
    {
        public Billing_Account_Split__c objBillAcc {get; set;}       
        public String strSubTotal {get; set;}
        public String strAmtPercentage {get; set;}
        public List<wrapProduct> lstWrpPro {get; set;}
        
        public wrapBillingAccount(Billing_Account_Split__c objBA, String subTotal, String amtPer, List<wrapProduct> lstWpPro)
        {
            objBillAcc = objBA;
            strSubTotal = subTotal;
            strAmtPercentage = amtPer;
            lstWrpPro = lstWpPro;
        }
    }
    
    /********************************************************************************************
    ClassName: wrapProduct
    Description: Class represent a wrapper class which is used in class "wrapBillingAccount".
    DevelopedBy: TCS Offshore, Kolkata 
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
    public class wrapProduct
    {
        public String productId {get;set;}
        public String productName {get;set;}
        public String productQty {get;set;}
        //public String productPrice {get;set;}
        public Billing_Account_Split__c objBAS {get;set;}
        public String priceNumber {get;set;}
        public String strOLIid {get;set;}
        
        public wrapProduct(String pId, String pName, String pQty, Billing_Account_Split__c bas, String pNumber, String strLIid) {
            productId = pId;
            productName = pName;
            productQty = pQty;
            //productPrice = pPrice;            
            objBAS = bas;
            priceNumber = pNumber;
            strOLIid = strLIid;//SFD-1121
        }
    }
}