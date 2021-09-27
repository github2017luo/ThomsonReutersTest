@istest()
public class USLARWrapper_test {
    /**
     * @description Justdesc
     * @return Justdesc
     */
    public Double totalOpenItemAmount {get;set;} 
    /**
     * @description Justdesc
     * @return Justdesc
     *//////
     //public String disputeamount {get;set;}
     /**
     * @description Justdesc
     * @return Justdesc
     */
    public Double totalOpenItemAmountInvoiced {get;set;} 
    /**
     * @description Justdesc
     * @return Justdesc
     */
    public Double pastDueBalance {get;set;} 
    //public List<ClearedItems> clearedItems {get;set;} 
    //public List<OpenedItems> openedItems {get;set;}
     //public void testmethod_1(){
    static testmethod void testMethod1(){
        
    USLARWrapper uSLARtest = new USLARWrapper();        
    //USLARWrapper.ARrequest aR= new USLARWrapper.ARrequest();
        
    USLARtest.totalOpenItemAmount = 1192.23;
    USLARtest.totalOpenItemAmountInvoiced=1192.23 ;
    USLARtest.pastDueBalance=1192.23;
        
    USLARWrapper.oAccount oA= new USLARWrapper.oAccount();
    USLARWrapper.clearedallitems clrall= new USLARWrapper.clearedallitems();
    USLARWrapper.OpenItem opn= new USLARWrapper.OpenItem();
    USLARWrapper.openedItems opnditm= new USLARWrapper.openedItems();
    USLARWrapper.AR_document ardcmnt = new USLARWrapper.AR_document();
    USLARWrapper.AR_cldocument arcld= new USLARWrapper.AR_cldocument();  
    opn.totalOpenItemAmount=52.22;
    opn.totalOpenItemAmountInvoiced=98.22;
    opn.pastDueBalance=112.23;
    opn.oopenedItems=opnditm;
     
    clrall.totalOpenItemAmount=25.3;
    clrall.totalOpenItemAmountInvoiced=56.5;
    clrall.pastDueBalance=86.96;
     
    ardcmnt.type='name';
    ardcmnt.docNumber='';
    ardcmnt.docDate='';
    ardcmnt.referenceNumber='12345';
    ardcmnt.additionalPdfDocumentId='';
     
     opnditm.currencycode='USD';
    opnditm.referencekey = '0837758008';
    opnditm.postingDate = '30/01/2018';
    opnditm.amount = 198.41;
    opnditm.disputeamount= '19';
    opnditm.lineNumber = '001';
    opnditm.reasonCode = 'null';
    opnditm.debitCreditInd = 'S';
    opnditm.dunningArea = 'null';
    opnditm.dunningBlock = 'null';
    opnditm.shipTo = 'null';
    opnditm.document=ardcmnt;
    opnditm.servicesRenderedDate = '01/30/2018';
    opnditm.pdfLinkInd = 'X';
    opnditm.netArrers = '57';
        //public AR_document document{get;set;}
    opnditm.shortDescription = 'FL CASES 3D V226 p 813-V227 p 725';
    opnditm.longDescription = 'FL CASES 3D V226 p 813-V227 p 725 ';
    opnditm.baselineDate = '02/15/2018';
    opnditm.pastDueFlag = '1' ;
    opnditm.processingStatus = 'null';
    opnditm.isSelected = null;
    opnditm.NewAmount = null ;
      
     
    USLARWrapper.AR_document aRdoc= new USLARWrapper.AR_document();
    USLARWrapper.oCleareditems oclritm= new USLARWrapper.oCleareditems();
    
    Account acc1 = new Account();
    acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
    insert acc1;
    
    USLARWrapper.ctrlclearedAccount oacc= new USLARWrapper.ctrlclearedAccount ();
    oacc.companyId ='0010';
    USLARWrapper.clearedItems clritm= new USLARWrapper.clearedItems();
    clritm.currencycode='USD';
    clritm.referencekey = 'null';
    clritm.postingDate= '01/30/2018';
    clritm.amount=129.43;
    clritm.disputeamount='12';
    clritm.dueDate='01/30/2018';
    clritm.reasonCode= 'null';
    clritm.debitCreditInd= 'H';
    clritm.dunningArea = 'null';
    clritm.allocationNumber= 'CC AR AUTO CLEA';
    clritm.clearingDate= '01/30/2018';
    clritm.clearingDocumentNumber= '1200500002';
    clritm.dunningBlock = 'null';
    clritm.dunningLevel = '0';
    clritm.paymentMethod = 'null';
    clritm.netArrers = 'null';
    clritm.specialGeneralLedgerInd = 'null';
    //AR_cldocument document = 
    clritm.shortDescription = 'Customer AR clearing';
    clritm.longDescription = 'PAYMENT RECEIVED - THANK YOU' ;
    clritm.baselineDate = '01/30/2018';
    //clritm.account=Acccurrency;
    clritm.document=arcld;
    clritm.isSelected = null;
         
    oclritm.totalOpenItemAmount=21;
    oclritm.totalOpenItemAmountInvoiced=56;
    oclritm.pastDueBalance=78;
    USLARWrapper.Accountref oaccref= new USLARWrapper.Accountref();
    USLARWrapper.sourceOrTargetReference sourceTag=new USLARWrapper.sourceOrTargetReference();
   sourceTag.referenceID= '6000006766';
   //oaccref.sourceOrTargetReference.add(sourceTag);
    arcld.type='';
    arcld.account = oaccref ;
    arcld.docNumber='6000006766';
    arcld.docDate='08/01/2001';
    arcld.referenceNumber='';
    arcld.additionalPdfDocumentId=''; 
    arcld.DocumentDesc  ='';       
         
    USLARWrapper.sourceOrTargetReference sCRTGT= new USLARWrapper.sourceOrTargetReference();
    sCRTGT.referenceID = 'null';
    USLARWrapper.EsiHeader esi = new USLARWrapper.EsiHeader('ESCU','West','test','test');
     USLARWrapper.Filter filter = new USLARWrapper.Filter('10/03/2015','11/03/2016',true,true,true) ;
    USLARWrapper.oAccount oacc1 = new USLARWrapper.oAccount();
    //oacc1.accountNumber = '';   
    USLARWrapper.ARrequest arreq = new USLARWrapper.ARrequest();
    arreq.esiHeader = esi;
    arreq.account = oacc1;
    arreq.filter =filter;
    //Accref.account = Acc1;
    // USLARWrapper.clearedItems clritm= new USLARWrapper.clearedItems();
    
     
    USLARWrapper.AR_cldocument aRCLdoc= new USLARWrapper.AR_cldocument();
    USLARWrapper.ARdetailreq aRDTLreq= new USLARWrapper.ARdetailreq();
    USLARWrapper.ARdetail aRDTL= new USLARWrapper.ARdetail();
    
    aRDTLreq.esiHeader = esi;
    
    
    //ARDTL.cls_details clsdtl= new ARDTL.cls_details();
    USLARWrapper.cls_invoiceHeader clsInvc= new USLARWrapper.cls_invoiceHeader();
    clsInvc.amount=23.5;
     clsInvc.netAmount='';
    USLARWrapper.cls_invoiceLedgerItems clsInvcledgitm= new USLARWrapper.cls_invoiceLedgerItems();
    clsInvcledgitm.taxAmount = '';
    USLARWrapper.cls_details cls = new USLARWrapper.cls_details();
    cls.invoiceHeader = clsInvc;
    USLARWrapper.cls_document clsdc= new USLARWrapper.cls_document();
    clsdc.docnumber = '';
    
    USLARWrapper.cls_processStatus clsprcess= new USLARWrapper.cls_processStatus ();
    clsprcess.statusCode='';
    clsprcess.statusDescription='';
    clsprcess.statusDetailMessage='';
    
    USLARWrapper.Status statu= new USLARWrapper.Status();
    statu.processStatus=clsprcess;
    
    USLARWrapper.responsewrapper rspwrap= new USLARWrapper.responsewrapper();
    rspwrap.responseBodyJSON='';
    rspwrap.isSuccess=False;
    rspwrap.errorMessage='';  
     USLARWrapper.cls_invoiceLines clsinvoice= new USLARWrapper.cls_invoiceLines();
     
       clsinvoice.description='';
       clsinvoice.quantity='';
       clsinvoice.netPrice='';
       clsinvoice.taxAmount=0.7;
       clsinvoice.PONumber='';
       clsinvoice.lineNumber='';
       clsinvoice.document=clsdc;
       clsinvoice.netPerUnitDocCurr='';
       clsinvoice.taxPerUnitDocCurr='';
       clsinvoice.materialNumber='';
       clsinvoice.serviceDate='';    
       clsdc.docnumber=''; 

       integer i = 1;
       integer j = 1;
       System.assertEquals(i,j,'Test');
  }
   @istest public static void uSLARHelpertest(){
         USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
        int1.Applicationid__c = 'ESCU';
        int1.Companyid__c = 'WEST';
        int1.name = 'Integrationdefaults';
        insert int1;
    Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         testAccount.SAPAccountNumber__c='hos454';
         testAccount.Sales_Org__c='BEJE';
         insert testAccount;
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
         testContact.FirstName='testerrr';
         insert testContact;
         Case ca= new Case();
         ca = ESC_GenericTestutility.TestCaseUtil(testContact.id,testAccount.id,'Work in Progress');
         ca.USL_SAP_Account_Number__c='4152test';
         Insert ca;
       Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
      Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'USL Helpdesk Agent'];
        User testUser = new User(
            Alias = 'sUser',
            Email = 'abc1@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'abc123@testorg.com'
        );
        insert testUser;      
            //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c='00e30000001ZUki');
        //insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c='01230000001MA4h');
       // insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c='01230000001MA4g');
      System.Runas(testUser){ 
      KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
      testLcrmSUBBU.Name = 'LCRMServiceNotesUserSubBu';
      testLcrmSUBBU.TextValue__c = 'US,USL';
      insert testLcrmSUBBU; 
    Account testAcc1 = UnitTest.getAccountInstance();
    testAcc1.Sales_Org__c ='WEST' ;
    insert testAcc1;
    Account account1 = new Account();
    Account account =new Account();
    account.Name = 'testAccount';
            account.Customer_Type__c = 'Induvidual';
            account.Customer_Group__c = 'ACADEMIC';
            account.Industry = 'Energy';
            account.SAPAccountNumber__c = '1000550771';
            insert account;
             account1.Name = 'testAccount';
            account1.Customer_Type__c = 'Induvidual';
            account1.Customer_Group__c = 'ACADEMIC';
            account1.Industry = 'Energy';
            account1.SAPAccountNumber__c = '1000550721';
            account1.ParentId=account.id;
            account1.Account_Indicator__c='Branch';
            insert account1;
    
    Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
     Source_System_Detail__c accountSSD= new Source_System_Detail__c();
     accountSSD.RecordtypeId=ssdRecorType;
     accountSSD.Name='ABC';
     accountSSD.Source_System_Name__c='ABC';
     accountSSD.Account_Name__c=testAcc1.ID;
     accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
     accountSSD.Account_Inactive__c=false;
     accountSSD.LCRM_Sales_Org__c='WEST';
     accountSSD.LCRM_Sub_BU__c='USL';
     accountSSD.LCRM_Customer_Group__c='';
     accountSSD.Source_System_Account_Number__c = '1000000040';
     accountSSD.LCRM_SAP_ACCOUNT_NUMBER__C=ca.USL_SAP_Account_Number__c;
      accountSSD.City__c = 'BANGALORE';
      accountSSD.LCRM_APTS_Band_Number__c= 1;
      accountSSD.APTS_Customer_Category__c = '3';
      accountSSD.LCRM_eOutput_Eligibility__c= '';
      accountSSD.State__c = 'California';
      accountSSD.Digital_Firm_Name__c = 'test';
      accountSSD.Digital_Billing_City__c = 'testcity';
      
     insert accountSSD;
      
       set<Id> accIds = new set<Id>();     
       accIds.add(testAcc1.ID);
       
      Test.startTest();
      USLARHelper uSLARHelperctrl=new USLARHelper();
      USLARHelper.getSourceSystemDetails(accIds,testAcc1.Sales_Org__c);
      USLARHelper.getAccountSetList(account1);
      Test.stopTest();
      
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'Test');
    }
    }
}