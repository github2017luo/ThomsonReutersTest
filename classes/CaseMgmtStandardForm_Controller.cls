public class CaseMgmtStandardForm_Controller {

Public Case objCase {get;set;}
Public List<Case> lstCase;
Public String strSalesOrg {get;set;}
Public String strsource {get;set;}
Public String strIssue {get;set;}
Public String strReason {get;set;}
Public String strNameoftheaccount{get;set;}
Public String strName{get;set;}
Public String strLastName{get;set;}
Public String strCustomerID{get;set;}
Public String strEmail{get;set;}
Public String strAreaCode{get;set;}
Public String strTelphone{get;set;}
Public String strTimeAvailability{get;set;}
Public String strProduct{get;set;}
Public String strActiveSubscription{get;set;}
Public String strComments{get;set;}
Public String strDatatoModify{get;set;}
Public String strPreviousData{get;set;}
Public String strNewData{get;set;}
Public String strCity{get;set;}
Public String strState{get;set;}
Public String strZipCode{get;set;}
Public String straddfutureshipments{get;set;}
Public String strShippingAddess{get;set;}
Public String strInvoiceNumber{get;set;}
Public String strInvoiceDate{get;set;}
Public String strPaymentAmount{get;set;}
Public String strPaymentDate{get;set;}
Public String strlancode{get;set;}
Public String strSalesorgCode{get;set;}
Public boolean blnIsAdmReaMod{get;set;}
Public boolean blnIsDisReaNoRec{get;set;}
Public boolean blnIsBilReaNoRecOfBil{get;set;}
Public boolean blnIsBilReaPayNote{get;set;}
Public boolean blnCheckValidate{get;set;}
public Double randomOP;
public String strRandomOP{get;set;}
public String strUserInput{get;set;}
private boolean blnCheckCaptcha;
public String strCaseSubject='';


    public CaseMgmtStandardForm_Controller(ApexPages.StandardController controller){
     
        //strSalesOrg = apexpages.currentpage().getparameters().get('salesorg');
        strsource = apexpages.currentpage().getparameters().get('source');
        //strSalesOrg = strSalesOrg.toUpperCase();
        if(strsource == 'AR'){
        strlancode = 'ES';
        objCase = new Case(Sales_Org__c = 'LLEY');
        strSalesorgCode='LLEY';
        }
        else if(strsource == 'UY'){
        strlancode = 'ES';
        objCase = new Case(Sales_Org__c = 'LLUR');
        strSalesorgCode='LLUR';
        }
        else if(strsource == 'PY'){
        strlancode = 'ES';
        objCase = new Case(Sales_Org__c = 'LLPA');
        strSalesorgCode='LLPA';
        }
        
        lstCase = new list<Case>();
        blnIsAdmReaMod = false;
        blnIsDisReaNoRec = false;
        blnIsBilReaNoRecOfBil = false;
        blnIsBilReaPayNote = false;
        blnCheckValidate = false;
        randomOP = Math.ceil(Math.random()*10000);
        strRandomOP = String.valueOf(Integer.valueOf(randomOP));
     }
    
    public void spin() {
        long now = datetime.now().gettime();
         while(datetime.now().gettime()-now<50);
         // Busy loop for 500 ms
        renderSection();
    }
    
    Public void renderSection(){
    
        blnIsAdmReaMod = false;
        blnIsDisReaNoRec = false;
        blnIsBilReaNoRecOfBil = false;
        blnIsBilReaPayNote = false;
        
        if((strIssue == 'Administrative' && strReason == 'Modification of Data' && strlancode == 'EN') || (strIssue == 'Administrativo' && strReason == 'Modificación de datos' && strlancode == 'ES')){
            blnIsAdmReaMod = true;
            blnIsDisReaNoRec = false;
            blnIsBilReaNoRecOfBil = false;
            blnIsBilReaPayNote = false;
        }
        else if((strIssue == 'Distribution' && strReason == 'No reception' && strlancode == 'EN') || (strIssue == 'Distribución' && strReason == 'No recepción' && strlancode == 'ES')){
            blnIsAdmReaMod =false;
            blnIsDisReaNoRec = true;
            blnIsBilReaNoRecOfBil = false;
            blnIsBilReaPayNote = false;
        }
        /*else if((strIssue == 'Billing' && strReason == 'No reception of bill' && strlancode == 'EN') || (strIssue == 'Facturación' && strReason == 'No recepción de la factura' && strlancode == 'ES')){
            blnIsAdmReaMod =false;
            blnIsDisReaNoRec = false;
            blnIsBilReaNoRecOfBil = true;
            blnIsBilReaPayNote = false;
        }
        else if((strIssue == 'Billing' && strReason == 'Payment notification' && strlancode == 'EN') || (strIssue == 'Facturación' && strReason == 'Notificación de pago' && strlancode == 'ES')){
            blnIsAdmReaMod =false;
            blnIsDisReaNoRec = false;
            blnIsBilReaNoRecOfBil = false;
            blnIsBilReaPayNote = true;
        }*/
        else if((strIssue == 'Administrative' && strReason == 'No reception of bill' && strlancode == 'EN') || (strIssue == 'Administrativo' && strReason == 'No recepción de la facture' && strlancode == 'ES')){
            blnIsAdmReaMod =false;
            blnIsDisReaNoRec = false;
            blnIsBilReaNoRecOfBil = true;
            blnIsBilReaPayNote = false;
        }
        else if((strIssue == 'Administrative' && strReason == 'Billing/Adjustments/Refunds' && strlancode == 'EN') || (strIssue == 'Administrativo' && strReason == 'Facturación / Ajustes / Reintegros' && strlancode == 'ES')){
            blnIsAdmReaMod =false;
            system.debug('blnIsDisReaNoRec '+blnIsDisReaNoRec );
            blnIsDisReaNoRec = false;
            blnIsBilReaNoRecOfBil = false;
            blnIsBilReaPayNote = true;
        }
        
        else{
            System.Debug('****None of the value combination matches****');
        } 
    } 
    
     public PageReference saveCasedata(){
         String strIssueEng='';
         List<Case_Picklist_Values__C> cpValues = Case_Picklist_Values__C.getall().values();
         for(Case_Picklist_Values__C cpv:cpValues){
             //System.debug('Case_Picklist_Values__c ---->'+cpv.Picklist_Value_Spanish__c+' strIssue---->'+strIssue);
             if(cpv.Picklist_Value_Spanish__c.equals(strIssue)){
                 strIssueEng = cpv.Picklist_Value_English__c;
             }
         }
        /* //Change by AG 23-Feb-2017 Start
        if(strIssue == 'Solicitud de Baja de Suscripciones'){
            objCase.ANZ_Issue__c = 'CAC- '+ strIssue;
        
        }
        else{
            objCase.ANZ_Issue__c = 'CAC - '+ strIssue;
        }
        //Change by AG 23-Feb-2017 End
        */ 
        //added by AG start
        if(strIssueEng == 'Solicitud de Baja de Suscripciones'){
            objCase.ANZ_Issue__c = 'CAC- '+ strIssueEng;
            strCaseSubject = 'CAC- '+ strIssueEng; //added by ag 27-Mar
        }
        else{
            objCase.ANZ_Issue__c = 'CAC - '+ strIssueEng;
            strCaseSubject = 'CAC - '+ strIssueEng; //added by ag 27-Mar
        }
        //added by AG End   
         //objCase.ANZ_Issue__c = 'CAC - '+ strIssue; 
         //added by ag start
         String strReasonEng='';
         for(Case_Picklist_Values__C cpv:cpValues){
             System.debug('Case_Picklist_Values__C ---->'+cpv.Picklist_Value_Spanish__c+' strReason---->'+strReason);
             if(cpv.Picklist_Value_Spanish__c.equals(strReason)){
                 strReasonEng = cpv.Picklist_Value_English__c;
             }
         }
         strCaseSubject = strCaseSubject + ' - ' + strReason; //added by ag 27-Mar
         //added by AG end     
         //objCase.Reason__c = strReason; //commented by ag
         objCase.Reason__c = strReasonEng;
         objCase.SuppliedEmail = strEmail;
         List<Account> lstAccount = new List<Account>();
                         
         Integer intCount = 0;
         if(strCustomerID!=null){
             intCount=database.countQuery('SELECT count() FROM Account WHERE Tax_Number__c<>null and Tax_Number__c =: strCustomerID limit 1');
         }
                         
         if(intCount == 1){                
             lstAccount = [SELECT id, Tax_Number__c 
                             FROM Account 
                             WHERE Tax_Number__c =: strCustomerID limit 1];
         }
         if(!lstAccount.isEmpty()){
             //for(Account ac: lstAccount){
                 //objCase.AccountId = ac.id;
                 objCase.AccountId = lstAccount[0].id;
                 
             //}
         }
         RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName= 'Site_Originated' limit 1];
         objCase.RecordTypeId= rt.Id;
         objCase.Description =  'Issue:'+ objCase.ANZ_Issue__c + '; ' + 
                                'Reason:'+ objCase.Reason__c + '; ' + 
                                 Label.Name_of_the_account_in_which_the_invoice_was_issued + strNameoftheaccount + '; '+
                                Label.Name+ strName + '; ' + 
                                Label.Last_Name_Label + strLastName + '; ' +
                                Label.Customer_ID + strCustomerID + '; ' +
                                Label.Email_Custom_Label+ strEmail + '; ' +
                                Label.Area_Code + strAreaCode + '; ' +
                                Label.Telephone + strTelphone + '; ' +
                                Label.Time_Availability + strTimeAvailability + '; ' +
                                Label.Product_Custom_Label + strProduct + '; ' +
                                Label.Active_Subscription + strActiveSubscription + '; ' +
                                Label.Comments + strComments + '; ' ;
        
        
          if(blnIsAdmReaMod == true){
             objCase.Description = objCase.Description  + Label.Data_to_Modify + strDatatoModify + '; ' +
                                                          Label.Previous_Data + strPreviousData + '; ' +
                                                          Label.New_Data + strNewData + '; ' +
                                                          Label.City + strCity + '; ' +
                                                          Label.State + strState + '; ' +
                                                          Label.Zip_Code + strZipCode + '; ' ;                                                      
                                                 
          }
            
          else if(blnIsDisReaNoRec == true)  {
             objCase.Description = objCase.Description  + Label.Do_you_want_to_keep_this_address_for_future_shipments + straddfutureshipments + '; ' +
                                                          Label.Shipping_Addess + strShippingAddess+ '; ' ;
                                                          
          
          }
          
          else if(blnIsBilReaNoRecOfBil == true)  {
             objCase.Description = objCase.Description  + Label.Invoice_Number+ strInvoiceNumber+ '; ' +
                                                          Label.Invoice_Date+ strInvoiceDate+ '; ' ;
                                                          
          
          }
          
          else if(blnIsBilReaPayNote == true)  {
             objCase.Description = objCase.Description  + Label.Payment_Amount+ strPaymentAmount+ ';' +
                                                          Label.Payment_Date+ strPaymentDate+ ';' ;
          
          }
          
          else{
            System.Debug('****Comment field not populated****');
        }
            
            
         
         objCase.Status = 'New';
         objCase.Origin = 'Web';
         objCase.Product__c = strProduct;
         objCase.Subject = strCaseSubject;
         Boolean redCheck=false;   
         try{
            if(!checkValidate() && checkCaptcha()){
                //checkCaptcha();
                refreshCaptcha();
                lstCase.add(objCase);//added
                if(!lstCase.isEmpty() && lstCase.size() > 0){
                     Database.SaveResult[] resultCase=Database.Insert(lstCase, false);
                    System.Debug('*****Case Insert Successful from saveCasedata method.resultCase'+resultCase);
                     if(resultCase[0].isSuccess()){     
                        CaseTeamTemplate objCaseTeamTemplate = [SELECT Id,Name FROM CaseTeamTemplate where name='CAC – Canal General'];     
                        CaseTeamTemplateRecord objCaseTeamTemplateRecord=new CaseTeamTemplateRecord();      
                        objCaseTeamTemplateRecord.ParentId = resultCase[0].getId();     
                        objCaseTeamTemplateRecord.TeamTemplateId = objCaseTeamTemplate.Id;      
                        Database.SaveResult result = Database.Insert(objCaseTeamTemplateRecord);        
                        System.Debug('*****Case Insert Successful from saveCasedata method.');  
                        redCheck=true;
                        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Case Saved Successfully'));
                    }
                }
            }
            
         } catch(Exception ex){
             System.Debug('*****Case Insert Failed from saveCasedata method: '+ex.getMessage());
         }
         
         for(Integer i=0;i<900;i++){}
         if(redCheck==true){
             PageReference retURL;
             if(strsource == 'AR'){
                 retURL = new PageReference('https://www.thomsonreuters.com.ar/es/atencion-al-cliente.html');
             } 
             else if(strsource == 'UY'){
                 retURL = new PageReference('https://www.laley.com.uy');
             } 
             else if(strsource == 'PY'){
                 retURL = new PageReference('https://www.laley.com.py ');
             }    
             retURL.setRedirect(true);
             return retURL;
         }
         return null;
     
    }
    
    public List<SelectOption> getCaseSalesOrg(){
        List<SelectOption> options = new List<SelectOption>();
               
        options.add(new SelectOption('LLEY','LLEY'));
        options.add(new SelectOption('LLUR','LLUR'));
        options.add(new SelectOption('LLPA','LLPA'));
        return options;
    }
    
    public List<SelectOption> getCaseIssue(){
        List<SelectOption> options = new List<SelectOption>();
           
        options.add(new SelectOption('','--- None ---'));
        List<Case_Picklist_Values__c> lstCaseIssue = New List<Case_Picklist_Values__c>(Case_Picklist_Values__c.getAll().values());
        
        Map<String, Case_Picklist_Values__c> mapIssues = new Map<String, Case_Picklist_Values__c>();
        for(Case_Picklist_Values__c issue : lstCaseIssue) {
            if((issue.Picklist_Field_Name_English__c == Label.Issue) || (issue.Picklist_Field_Name_Spanish__c == Label.Issue)){
                mapIssues.put(issue.name, issue);
            }
        }
        
        List<String> issueNames = new List<String>();
        issueNames.addAll(mapIssues.keySet());
        issueNames.sort();
        
        
        for (String issueName : issueNames) {
            Case_Picklist_Values__c issue = mapIssues.get(issueName);
            if(strlancode == 'EN'){
                options.add(new SelectOption(issue.Picklist_Value_English__c, issue.Picklist_Value_English__c));
            }
            else if(strlancode == 'ES'){
                options.add(new SelectOption(issue.Picklist_Value_Spanish__c, issue.Picklist_Value_Spanish__c));
            }
        }
        //lstoptionsStates.clear();
        
        /*options.add(new SelectOption('Administrativo','Administrativo'));       
        options.add(new SelectOption('Billing','Billing'));
        options.add(new SelectOption('Distribution','Distribution'));       
        options.add(new SelectOption('Online/Proview','Online/Proview'));*/
        return options;
    }
    
    public List<SelectOption> getCaseReason(){
        system.debug('*****Issue:'+strIssue);
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('','--- None ---'));
        List<Case_Picklist_Values__c> lstCaseReason = New List<Case_Picklist_Values__c>(Case_Picklist_Values__c.getAll().values());
        
        Map<String, Case_Picklist_Values__c> mapReason = new Map<String, Case_Picklist_Values__c>();
        for(Case_Picklist_Values__c reason : lstCaseReason) {
            if((reason.Picklist_Field_Name_English__c == Label.Reason_for_Case) || (reason.Picklist_Field_Name_Spanish__c == Label.Reason_for_Case)){
                mapReason.put(reason.name, reason);
            }
        }
        
        List<String> ReasonNames = new List<String>();
        ReasonNames.addAll(mapReason.keySet());
        ReasonNames.sort();
        
        
        for (String reasonName : ReasonNames) {
            Case_Picklist_Values__c reason = mapReason.get(reasonName);
            if(strlancode == 'EN'){
                if(strIssue == reason.Controlling_Picklist_Values_English__c && strIssue == 'Administrative'){
                    options.add(new SelectOption(reason.Picklist_Value_English__c, reason.Picklist_Value_English__c));
                }
                else if(strIssue == reason.Controlling_Picklist_Values_English__c && strIssue == 'Online/Proview'){
                    options.add(new SelectOption(reason.Picklist_Value_English__c, reason.Picklist_Value_English__c));
                }
                else if(strIssue == reason.Controlling_Picklist_Values_English__c && strIssue == 'Distribution'){
                    options.add(new SelectOption(reason.Picklist_Value_English__c, reason.Picklist_Value_English__c));
                }
                else if(strIssue == reason.Controlling_Picklist_Values_English__c && strIssue == 'Billing'){
                    options.add(new SelectOption(reason.Picklist_Value_English__c, reason.Picklist_Value_English__c));
                }
                else if(strIssue == reason.Controlling_Picklist_Values_English__c && strIssue == 'Annulment of purchase of books'){
                    options.add(new SelectOption(reason.Picklist_Value_English__c, reason.Picklist_Value_English__c));
                }
                else if(strIssue == reason.Controlling_Picklist_Values_English__c && strIssue == 'Access to digital services'){
                    options.add(new SelectOption(reason.Picklist_Value_English__c, reason.Picklist_Value_English__c));
                }
                else if(strIssue == reason.Controlling_Picklist_Values_English__c && strIssue == 'Suggestions'){
                    options.add(new SelectOption(reason.Picklist_Value_English__c, reason.Picklist_Value_English__c));
                }
                else if(strIssue == reason.Controlling_Picklist_Values_English__c && strIssue == 'Training'){
                    options.add(new SelectOption(reason.Picklist_Value_English__c, reason.Picklist_Value_English__c));
                }
                else if(strIssue == reason.Controlling_Picklist_Values_English__c && strIssue == 'Functional / technical inquiries'){
                    options.add(new SelectOption(reason.Picklist_Value_English__c, reason.Picklist_Value_English__c));
                }
                else if(strIssue == reason.Controlling_Picklist_Values_English__c && strIssue == 'Unsubscribe request'){
                    options.add(new SelectOption(reason.Picklist_Value_English__c, reason.Picklist_Value_English__c));
                }
                
            }
            else if(strlancode == 'ES'){
                if(strIssue == reason.Controlling_Picklist_Values_Spanish__c && strIssue == 'Administrativo'){
                    options.add(new SelectOption(reason.Picklist_Value_Spanish__c, reason.Picklist_Value_Spanish__c));
                }
                else if(strIssue == reason.Controlling_Picklist_Values_Spanish__c && strIssue == 'Online/Proview'){
                    options.add(new SelectOption(reason.Picklist_Value_Spanish__c, reason.Picklist_Value_Spanish__c));
                }
                else if(strIssue == reason.Controlling_Picklist_Values_Spanish__c && strIssue == 'Distribución'){
                    options.add(new SelectOption(reason.Picklist_Value_Spanish__c, reason.Picklist_Value_Spanish__c));
                }
                else if(strIssue == reason.Controlling_Picklist_Values_Spanish__c && strIssue == 'Facturación'){
                    options.add(new SelectOption(reason.Picklist_Value_Spanish__c, reason.Picklist_Value_Spanish__c));
                }
                else if(strIssue == reason.Controlling_Picklist_Values_Spanish__c && strIssue == 'Anulación de compra de libros'){
                    options.add(new SelectOption(reason.Picklist_Value_Spanish__c, reason.Picklist_Value_Spanish__c));
                }
                else if(strIssue == reason.Controlling_Picklist_Values_Spanish__c && strIssue == 'Acceso a Servicios Digitales'){
                    options.add(new SelectOption(reason.Picklist_Value_Spanish__c, reason.Picklist_Value_Spanish__c));
                }
                else if(strIssue == reason.Controlling_Picklist_Values_Spanish__c && strIssue == 'Sugerencias'){
                    options.add(new SelectOption(reason.Picklist_Value_Spanish__c, reason.Picklist_Value_Spanish__c));
                }
                else if(strIssue == reason.Controlling_Picklist_Values_Spanish__c && strIssue == 'Entrenamiento'){
                    options.add(new SelectOption(reason.Picklist_Value_Spanish__c, reason.Picklist_Value_Spanish__c));
                }
                else if(strIssue == reason.Controlling_Picklist_Values_Spanish__c && strIssue == 'Consultas Funcionales / Técnicas'){
                    options.add(new SelectOption(reason.Picklist_Value_Spanish__c, reason.Picklist_Value_Spanish__c));
                }
                else if(strIssue == reason.Controlling_Picklist_Values_Spanish__c && strIssue == 'Solicitud de baja de suscripciones'){
                    options.add(new SelectOption(reason.Picklist_Value_Spanish__c, reason.Picklist_Value_Spanish__c));
                }
            }
        }
        
        /*if(strIssue == 'Online/Proview'){
            options.add(new SelectOption('Access','Access'));           
            options.add(new SelectOption('Display','Display'));         
            options.add(new SelectOption('Functional Inquiry','Functional Inquiry'));
            options.add(new SelectOption('Newsletter','Newsletter'));
            options.add(new SelectOption('OnePass','OnePass'));
            options.add(new SelectOption('Technical Inquiry','Technical Inquiry'));
        }
        else if(strIssue == 'Administrative' || strIssue == 'Administrativo'){
            options.add(new SelectOption('Inquiries','Inquiries'));
            options.add(new SelectOption('Modificación de datos','Modificación de datos'));
        }
        else if(strIssue == 'Distribution'){
            options.add(new SelectOption('Exchange','Exchange'));
            options.add(new SelectOption('No reception','No reception'));
        }
        else if(strIssue == 'Billing'){
            options.add(new SelectOption('Collections/Refunds','Collections/Refunds'));         
            options.add(new SelectOption('No reception of bill','No reception of bill'));
            options.add(new SelectOption('Payment notification','Payment notification'));
        }*/
        
        return options;
    }
    
    public List<SelectOption> getCaseproduct(){
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('','--- None ---'));
        List<Case_Picklist_Values__c> lstCaseProduct = New List<Case_Picklist_Values__c>(Case_Picklist_Values__c.getAll().values());
        
        Map<String, Case_Picklist_Values__c> mapProduct = new Map<String, Case_Picklist_Values__c>();
        for(Case_Picklist_Values__c prod : lstCaseProduct) {
            if((prod.Picklist_Field_Name_English__c == Label.Product_Custom_Label) || (prod.Picklist_Field_Name_Spanish__c == Label.Product_Custom_Label)){
                mapProduct.put(prod.name, prod);
            }
        }
        
        List<String> ProductNames = new List<String>();
        ProductNames.addAll(mapProduct.keySet());
        ProductNames.sort();
        
        
        for (String ProductName : ProductNames) {
            Case_Picklist_Values__c Product = mapProduct.get(ProductName);
            if(strlancode == 'EN'){
                options.add(new SelectOption(Product.Picklist_Value_English__c, Product.Picklist_Value_English__c));
            }
            else if(strlancode == 'ES'){
                options.add(new SelectOption(Product.Picklist_Value_Spanish__c, Product.Picklist_Value_Spanish__c));
            }
        }
        /*   
        options.add(new SelectOption('No applicable','No applicable'));
        options.add(new SelectOption('Legal One','Legal One'));
        options.add(new SelectOption('Legal OneLibros','Legal OneLibros'));
        options.add(new SelectOption('Libros','Libros'));     
        options.add(new SelectOption('Seminarios','Seminarios'));
        options.add(new SelectOption('Software Legal','Software Legal')); 
        options.add(new SelectOption('Software T&A','Software T&A'));
        options.add(new SelectOption('Suscripción Legal','Suscripción Legal'));
        options.add(new SelectOption('Suscripción T&A','Suscripción T&A'));
        */        
        return options;
    }

    public List<SelectOption> getCaseActiveSubscription(){
        List<SelectOption> options = new List<SelectOption>();
        
        //options.add(new SelectOption('','--- None ---'));
        List<Case_Picklist_Values__c> lstActiveSubscription = New List<Case_Picklist_Values__c>(Case_Picklist_Values__c.getAll().values());
        
        Map<String, Case_Picklist_Values__c> mapActiveSubscription = new Map<String, Case_Picklist_Values__c>();
        for(Case_Picklist_Values__c actSub : lstActiveSubscription) {
            if((actSub.Picklist_Field_Name_English__c == Label.Active_Subscription) || (actSub.Picklist_Field_Name_Spanish__c == Label.Active_Subscription)){
                mapActiveSubscription.put(actSub.name, actSub);
            }
        }
        
        List<String> ActiveSubscriptionNames = new List<String>();
        ActiveSubscriptionNames.addAll(mapActiveSubscription.keySet());
        ActiveSubscriptionNames.sort();
        
        
        for (String ActiveSubscriptionName : ActiveSubscriptionNames) {
            Case_Picklist_Values__c ActiveSubscription = mapActiveSubscription.get(ActiveSubscriptionName);
            if(strlancode == 'EN'){
                options.add(new SelectOption(ActiveSubscription.Picklist_Value_English__c, ActiveSubscription.Picklist_Value_English__c));
            }
            else if(strlancode == 'ES'){
                options.add(new SelectOption(ActiveSubscription.Picklist_Value_Spanish__c, ActiveSubscription.Picklist_Value_Spanish__c));
            }
        }
        /*
        options.add(new SelectOption('Seleccione','Seleccione'));
        options.add(new SelectOption('SI','SI'));       
        options.add(new SelectOption('NOSeleccione','NOSeleccione'));
        options.add(new SelectOption('NO','NO')); 
        */
        return options;
    }
    
    public List<SelectOption> getCaseTimeAvailability(){
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('','--- None ---'));
        List<Case_Picklist_Values__c> lstTimeAvailability = New List<Case_Picklist_Values__c>(Case_Picklist_Values__c.getAll().values());
        
        Map<String, Case_Picklist_Values__c> mapTimeAvailability = new Map<String, Case_Picklist_Values__c>();
        for(Case_Picklist_Values__c timeAvl : lstTimeAvailability) {
            if((timeAvl.Picklist_Field_Name_English__c == Label.Time_Availability) || (timeAvl.Picklist_Field_Name_Spanish__c == Label.Time_Availability)){
                mapTimeAvailability.put(timeAvl.name, timeAvl);
            }
        }
        
        List<String> TimeAvailabilityNames = new List<String>();
        TimeAvailabilityNames.addAll(mapTimeAvailability.keySet());
        TimeAvailabilityNames.sort();
        
        
        for (String TimeAvailabilityName : TimeAvailabilityNames) {
            Case_Picklist_Values__c TimeAvailability = mapTimeAvailability.get(TimeAvailabilityName);
            if(strlancode == 'EN'){
                options.add(new SelectOption(TimeAvailability.Picklist_Value_English__c, TimeAvailability.Picklist_Value_English__c));
            }
            else if(strlancode == 'ES'){
                options.add(new SelectOption(TimeAvailability.Picklist_Value_Spanish__c, TimeAvailability.Picklist_Value_Spanish__c));
            }
        }
        /*
        options.add(new SelectOption('8:00 - 11:00','8:00 - 11:00'));
        options.add(new SelectOption('11:00 - 15:00','11:00 - 15:00'));       
        options.add(new SelectOption('15:00 - 18:00','15:00 - 18:00'));
        */
        return options;
    }
    
    public List<SelectOption> getCaseDatatoModify(){
        List<SelectOption> options = new List<SelectOption>();
        

        options.add(new SelectOption('','--- None ---'));
        List<Case_Picklist_Values__c> lstDatatoModify = New List<Case_Picklist_Values__c>(Case_Picklist_Values__c.getAll().values());
        
        Map<String, Case_Picklist_Values__c> mapDatatoModify = new Map<String, Case_Picklist_Values__c>();
        for(Case_Picklist_Values__c datMod : lstDatatoModify) {
            if((datMod.Picklist_Field_Name_English__c == Label.Data_to_Modify) || (datMod.Picklist_Field_Name_Spanish__c == Label.Data_to_Modify)){
                mapDatatoModify.put(datMod.name, datMod);
            }
        }
        
        List<String> DatatoModifyNames = new List<String>();
        DatatoModifyNames.addAll(mapDatatoModify.keySet());
        DatatoModifyNames.sort();
        
        
        for (String DatatoModifyName : DatatoModifyNames) {
            Case_Picklist_Values__c DatatoModify = mapDatatoModify.get(DatatoModifyName);
            if(strlancode == 'EN'){
                options.add(new SelectOption(DatatoModify.Picklist_Value_English__c, DatatoModify.Picklist_Value_English__c));
            }
            else if(strlancode == 'ES'){
                options.add(new SelectOption(DatatoModify.Picklist_Value_Spanish__c, DatatoModify.Picklist_Value_Spanish__c));
            }
        }
        /*
        options.add(new SelectOption('Celular','Celular')); 
        options.add(new SelectOption('Modificación de medio de pago (tarjeta de crédito)','Modificación de medio de pago (tarjeta de crédito)')); 
        options.add(new SelectOption('Modificación de medio de pago (débito directo)','Modificación de medio de pago (débito directo)'));
        options.add(new SelectOption('Dirección de correo en el que recibe la factura','Dirección de correo en el que recibe la factura')); 
        options.add(new SelectOption('Dirección de correo asociada al servicio online','Dirección de correo asociada al servicio online')); 
        options.add(new SelectOption('Dirección de correo asociada a Proview','Dirección de correo asociada a Proview')); 
        options.add(new SelectOption('Teléfono principal','Teléfono principal')); 
        */
        return options;
    }  
    
    public List<SelectOption> getAddressForFutureShipments(){
        List<SelectOption> options = new List<SelectOption>();
        

        options.add(new SelectOption('','--- None ---'));
        List<Case_Picklist_Values__c> lstAddressForFutureShipments = New List<Case_Picklist_Values__c>(Case_Picklist_Values__c.getAll().values());
        
        Map<String, Case_Picklist_Values__c> mapAddressForFutureShipments = new Map<String, Case_Picklist_Values__c>();
        for(Case_Picklist_Values__c addrFutShp : lstAddressForFutureShipments) {
            if((addrFutShp.Picklist_Field_Name_English__c == Label.Do_you_want_to_keep_this_address_for_future_shipments) || (addrFutShp.Picklist_Field_Name_Spanish__c == Label.Do_you_want_to_keep_this_address_for_future_shipments)){
                mapAddressForFutureShipments.put(addrFutShp.name, addrFutShp);
            }
        }
        
        List<String> AddressForFutureShipmentsNames = new List<String>();
        AddressForFutureShipmentsNames.addAll(mapAddressForFutureShipments.keySet());
        AddressForFutureShipmentsNames.sort();
        
        
        for (String AddressForFutureShipmentsName : AddressForFutureShipmentsNames) {
            Case_Picklist_Values__c AddressForFutureShipments = mapAddressForFutureShipments.get(AddressForFutureShipmentsName);
            if(strlancode == 'EN'){
                options.add(new SelectOption(AddressForFutureShipments.Picklist_Value_English__c, AddressForFutureShipments.Picklist_Value_English__c));
            }
            else if(strlancode == 'ES'){
                options.add(new SelectOption(AddressForFutureShipments.Picklist_Value_Spanish__c, AddressForFutureShipments.Picklist_Value_Spanish__c));
            }
        }
        return options;
    }  
    
    public List<SelectOption> getStateValues(){
        List<SelectOption> lstoptionsStates = new List<SelectOption>();
        
        lstoptionsStates.add(new SelectOption('', '-- None --'));
        
        List<LatAm_Country_and_States__c> lstLatAmCountryStates = New List<LatAm_Country_and_States__c>(LatAm_Country_and_States__c.getAll().values());
        
        Map<String, LatAm_Country_and_States__c> states = new Map<String, LatAm_Country_and_States__c>();
        for(LatAm_Country_and_States__c state : lstLatAmCountryStates) {
            if (state.country_code__c == strsource) {
                states.put(state.name, state);
            }
        }
        
        List<String> stateNames = new List<String>();
        stateNames.addAll(states.keySet());
        stateNames.sort();
        
        
        for (String stateName : stateNames) {
            LatAm_Country_and_States__c state = states.get(stateName);
            lstoptionsStates.add(new SelectOption(state.State_Name__c, state.State_Name__c));
        }
        //lstoptionsStates.clear();
        return lstoptionsStates;
    } 
    
    public boolean checkValidate(){
        blnCheckValidate = false;
        
        if(strIssue == null || strIssue == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingIssue));
            blnCheckValidate = true;
        }
        if(strReason == null || strReason == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingReason));
            blnCheckValidate = true;
        }
        if(strNameoftheaccount == '' || strNameoftheaccount == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingAccountName));
            blnCheckValidate = true;
        }
        if(strName == '' || strName == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingName));
            blnCheckValidate = true;
        }
        if(strLastName == '' || strLastName == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingLastName));
            blnCheckValidate = true;
        }
        if(strCustomerID == '' || strCustomerID == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingCustomerID));
            blnCheckValidate = true;
        }
        if(strEmail == '' || strEmail == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingEmail));
            blnCheckValidate = true;
        }
        //added by ag 16-feb-2017 start //[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4} 
        if(!Pattern.matches('^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$', strEmail)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingEmail));
            blnCheckValidate = true;
        }
        //added by ag 16-feb-2017 end
        if(strAreaCode == '' || strAreaCode == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingAreaCode));
            blnCheckValidate = true;
        }
        if(strTelphone == '' || strTelphone == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingTelephone));
            blnCheckValidate = true;
        }
        if(strTimeAvailability == '' || strTimeAvailability == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingTimeAvailability));
            blnCheckValidate = true;
        }
        if(strProduct == '' || strProduct == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingProduct));
            blnCheckValidate = true;
        }
        if(strActiveSubscription == '' || strActiveSubscription == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingSubscription));
            blnCheckValidate = true;
        }
        if(strComments == '' || strComments == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingComments));
            blnCheckValidate = true;
        }
        

        if(strIssue == 'Administrativo' && strReason == 'Modificación de datos'){
            if(strDatatoModify == '' || strDatatoModify == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingData));
                blnCheckValidate = true;
            }
            if(strPreviousData == '' || strPreviousData == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingPreviousData));
                blnCheckValidate = true;
            }
            if(strNewData == '' || strNewData == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingNewData));
                blnCheckValidate = true;
            }
            if(strCity == '' || strCity == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingCity));
                blnCheckValidate = true;
            }
            if(strState == '' || strState == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingState));
                blnCheckValidate = true;
            }
            if(strZipCode == '' || strZipCode == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.MissingZipcode));
                blnCheckValidate = true;
            }
        }
        
        if(strIssue == 'Distribution' && strReason == 'No reception'){
            if(straddfutureshipments == '' || straddfutureshipments == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.FutureShipmentConfirmation));
                blnCheckValidate = true;
            }
            if(strShippingAddess == '' || strShippingAddess == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.SippingAddress));
                blnCheckValidate = true;
            }
        }

        if(!blnCheckValidate){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.InfoValidation));
            //ApexPages.currentPage().getParameters().put('source','AR');
        }
        
        return blnCheckValidate;        
    }
    
    public boolean checkCaptcha(){
        blnCheckCaptcha = false;
        System.debug('@@generated Captcha '+randomOP+ 'String value of Captcha '+strRandomOP);
        System.debug('@@User entered Captcha '+strUserInput);
        if(String.isBlank(strUserInput)){
            blnCheckCaptcha = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.BlankCAPTCHA));
        }
        else if(strUserInput.equals(strRandomOP)){
            System.debug('@@Inside ~If~ block of checking Captcha'+ strUserInput.equals(strRandomOP));
            blnCheckCaptcha = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.CorrectCAPTCHA));
        }
        else{
            blnCheckCaptcha = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,Label.IncorrectCAPTCHA));
        }
        return blnCheckCaptcha;
    }
            
    public void refreshCaptcha(){
        randomOP = Math.ceil(Math.random()*10000);
        if((Integer.valueOf(randomOP))<1000){       
            randomOP = randomOP + 1000;     
        }
        strRandomOP = String.valueOf(Integer.valueOf(randomOP));
    }
}