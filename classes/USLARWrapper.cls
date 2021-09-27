/**********************************
Class Name: USLARWrapper
**********************************/
/**
 * @description USLARwrapper class
 */
public class USLARWrapper {
    /**
     * @description totalOpenItemAmount
     * @return totalOpenItemAmount
     */
    public Double totalOpenItemAmount {get;set;} 
    /**
     * @description totalOpenItemAmountInvoiced
     * @return totalOpenItemAmountInvoiced
     */
    public Double totalOpenItemAmountInvoiced {get;set;} 
    /**
     * @description pastDueBalance
     * @return pastDueBalance
     */
    public Double pastDueBalance {get;set;} 
    /**
     * @description clearedItems
     * @return clearedItems
     */
    public List<ClearedItems> clearedItems {get;set;}
    /**
     * @description openedItems
     * @return openedItems
     */
    public List<OpenedItems> openedItems {get;set;}
    
/**
     * @description USLARWrapper
     
     */

public USLARWrapper(){
    system.debug(LoggingLevel.WARN, 'test');
}
    /**
     * @description USLARWrapper
     
     */
    public class ARrequest {
  /**AR Request Wrapper Starts**/
  /**
     * @description Justdesc
     * @return Justdesc
     */
         public EsiHeader esiHeader{get;set;}
         /**
     * @description Justdesc
     * @return Justdesc
     */
         public oAccount account{get;set;}
         /**
     * @description Justdesc
     * @return Justdesc
     */
         public Filter filter{get;set;}
       }

       /**
     * @description Justdesc
     * 
     */
    public class OAccount {
    /**
     * @description Justdesc
     * @return Justdesc
     */
        public String accountNumber{get;set;}
    }

    /**
     * @description Justdesc
     *
     */
    public class Filter {
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String fromDate{get;set;}
       /**
     * @description Justdesc
     * @return Justdesc
     */
        public String  toDate{get;set;}
       /**
     * @description Justdesc
     * @return Justdesc
     */
        public Boolean openItemsRequested{get;set;}
       /**
     * @description Justdesc
     * @return Justdesc
     */
        public Boolean clearedItemsRequested{get;set;}
       /**
     * @description Justdesc
     * @return Justdesc
     */
        public Boolean additionalTextRequested{get;set;}
        
          /**
     * @description Justdesc
     *@param frmdate
        @param todate
        @param openItems
        @param clearItems
        @param additionaltext
     */
        public Filter(String frmdate,String todate,Boolean openItems,Boolean clearItems,Boolean additionaltext){
            this.fromDate=frmdate;
            this.toDate=todate;
            this.openItemsRequested=openItems;
            this.clearedItemsRequested=clearItems;
            this.additionalTextRequested=additionaltext;
        }
    }
      /**
     * @description Justdesc
     * 
     */
    public class EsiHeader {
          /**
     * @description Justdesc
     * @return Justdesc
     */
        public String applicationId{get;set;}
          /**
     * @description Justdesc
     * @return Justdesc
     */
        public String companyId{get;set;}
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public String messageId{get;set;}
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public String configGroup{get;set;}
         /**
     * @description Justdesc
     * @param appid
     * @param comid
     * @param messId
     *@param configGrp
     */
        public EsiHeader(String appid,String comid,String messId,String configGrp){
            this.applicationId=appid;
            this.companyId=comid;
            this.messageId=messId;
            this.configGroup = configGrp;
        }
    }

      /**AR Request Wrapper ends**/
      /**AR respnse Wrapper starts**/
      
    /**
     * @description Justdesc
     * 
     */
    public class Clearedallitems{
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public List<openedItems> oitem{get;set;}
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public List<clearedItems> citem{get;set;}
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public Double totalOpenItemAmount{get;set;} //198.41
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public Double totalOpenItemAmountInvoiced{get;set;} //198.41
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public Double pastDueBalance{get;set;}
   }  
    /**
     * @description Justdesc
     * 
     */
    public class OpenItem{
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public Double totalOpenItemAmount{get;set;} //198.41
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public Double totalOpenItemAmountInvoiced{get;set;} //198.41
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public Double pastDueBalance{get;set;}  //198.41
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public openedItems oopenedItems{get;set;}
    
    }
     /**
     * @description Justdesc
     *
     */
    public class OpenedItems{
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public String currencycode {get;set;}
      //lcrm team
       /**
     * @description Justdesc
     * @return Justdesc
     */ 
        public ctrlAccount account {get;set;}      //6119597521
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public String referencekey{get;set;}    //0837758008
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String postingDate{get;set;} //30/01/2018
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public double amount{get;set;}  //198.41
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String lineNumber{get;set;}  //001
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String subItemNumber{get;set;}  //001
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public string reasonCode{get;set;}
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String debitCreditInd{get;set;}  //S
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public string dunningArea{get;set;}
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public string dunningBlock{get;set;}
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public string shipTo{get;set;}
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String servicesRenderedDate{get;set;}    //01/30/2018
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String pdfLinkInd{get;set;}  //X
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String netArrers{get;set;}   //57
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public AR_document document{get;set;}
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String shortDescription{get;set;}    //FL CASES 3D V226 p 813-V227 p 725
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String longDescription{get;set;} //FL CASES 3D V226 p 813-V227 p 725 
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String baselineDate{get;set;}    //02/15/2018
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String pastDueFlag{get;set;} //1
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public string processingStatus{get;set;}
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public boolean isSelected{get;set;}
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public double newAmount{get;set;}
        //Added by LCRM Team
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String salesOrg{get;set;}
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public Date dueDt {get;set;}
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public String disputeamount {get;set;}
    }
     /**
     * @description Justdesc
     *
     */
     public class AR_document {
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String type{get;set;}//YS
        /** * @description account
     * @return account
     */
        public Accountref account{get;set;}
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String docNumber{get;set;}   //6119597521
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String docDate{get;set;}
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String additionalPdfDocumentId{get;set;}//01/30/2018
        //LCRM Team Added
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String referenceNumber{get;set;}
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public String documentDesc {get;set;}
    }
    //LCRM Team  
     /**
     * @description Justdesc
     *
     */   
    public class CtrlAccount {  
         /**
     * @description Justdesc
     * @return Justdesc
     */    
       public String companyId {get;set;} 
    }
 /**
     * @description Justdesc
     
     */
 public class OCleareditems{
      /**
     * @description Justdesc
     * @return Justdesc
     */
    public Integer totalOpenItemAmount{get;set;}    //0
     /**
     * @description Justdesc
     * @return Justdesc
     */
    public Integer totalOpenItemAmountInvoiced{get;set;}    //0
     /**
     * @description Justdesc
     * @return Justdesc
     */
    public Integer pastDueBalance{get;set;} //0
     /**
     * @description Justdesc
     * @return Justdesc
     */
    public List<clearedItems> oclearedItems{get;set;}
 } 
 /**
 * @description Justdesc
 */
    public class ClearedItems{
       // public String arnumber{get;set;}
        //Added by LCRM Team
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String currencycode {get;set;}
        //End
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public ctrlclearedAccount account{get;set;}
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public string referencekey{get;set;}
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String postingDate{get;set;} //01/30/2018
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public double amount{get;set;}  //129.43
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String lineNumber{get;set;}
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String dueDate{get;set;} //01/30/2018
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String reasonCode{get;set;}
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String debitCreditInd{get;set;}  //H
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String dunningArea{get;set;}
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String allocationNumber{get;set;}    //CC AR AUTO CLEA
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String clearingDate{get;set;}    //01/30/2018
        /**
     * @description Justdesc
     * @return Justdesc
     */
        public String clearingDocumentNumber{get;set;}  //1200500002
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public string dunningBlock{get;set;}
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public String dunningLevel{get;set;}    //0
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public string paymentMethod{get;set;}
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public String netArrers{get;set;}   //0
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public string specialGeneralLedgerInd{get;set;}
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public AR_cldocument document{get;set;}
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public boolean isSelected{get;set;} //DSS-607
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public String shortDescription{get;set;}    //Customer AR clearing
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public String longDescription{get;set;} //PAYMENT RECEIVED - THANK YOU 
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public String baselineDate{get;set;}    //01/30/2018
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public String subItemNumber{get;set;}  //001
        //LCRm team     
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public String salesOrg{get;set;}
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public String disputeamount {get;set;}
    }
     /**
     * @description Justdesc
     * 
     */
    public class CtrlclearedAccount {
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public String companyId {get;set;}
        //public String currency{get;set;}
    }
 /**
     * @description Justdesc
     
     */
    public class Accountref {
         /**
     * @description Justdesc
     * @return Justdesc
     */
        public sourceOrTargetReference[] sourceOrTargetReference{get;set;}
    }
     /**
     * @description AR_cldocument
     * 
     */
    public class AR_cldocument {
         /**
     * @description type
     * @return type
     */
        public String type{get;set;}    //DX
         /**
     * @description account
     * @return account
     */
        public Accountref account{get;set;}
         /**
     * @description docNumber
     * @return docNumber
     */
        public String docNumber{get;set;}   //1200500002
         /**
     * @description docDate
     * @return docDate
     */
        public String docDate{get;set;} //01/30/2018
         /**
     * @description referenceNumber
     * @return referenceNumber
     */
        public String referenceNumber{get;set;}
         /**
     * @description referenceID
     * @return referenceID
     */
        public String additionalPdfDocumentId{get;set;}//CC AR AUTO CLEAR
        //LCRM Team Added
        /**
     * @description referenceID
     * @return referenceID
     */
        public String documentDesc {get;set;}
    }
    /**
     * @description SourceOrTargetReference
     * 
     */
   public class SourceOrTargetReference{
       /**
     * @description referenceID
     * @return referenceID
     */
        public string referenceID{get;set;}
    }
    /**
     * @description ARdetailreq
     
     */
    public class ARdetailreq{
        public String invoiceNumber;
        /**
     * @description esiHeader
     * @return esiHeader
     */
        public EsiHeader esiHeader{get;set;}
    }
    /**
     * @description ARdetail
     * 
     */
 public class ARdetail{
     /**
     * @description details
     * @return details
     */
    public cls_details[] details{get;set;}
   }
    @TestVisible class Cls_details {
        /**
     * @description invoiceHeader
     * @return invoiceHeader
     */
        public cls_invoiceHeader invoiceHeader{get;set;}
        /**
     * @description invoiceLines
     * @return invoiceLines
     */
        public cls_invoiceLines[] invoiceLines{get;set;}
    }
    @TestVisible class Cls_invoiceHeader {
         /**
     * @description amount
     * @return amount
     */
        public double amount{get;set;}  //             5483.66
         /**
     * @description netAmount
     * @return netAmount
     */
        public String netAmount{get;set;}   //             5124.92
        /**
     * @description invoiceLedgerItems
     * @return invoiceLedgerItems
     */
        public cls_invoiceLedgerItems[] invoiceLedgerItems{get;set;}
    }
    @TestVisible class Cls_invoiceLedgerItems {
        /**
     * @description taxAmount
     * @return taxAmount
     */
        public String taxAmount{get;set;}   //           358.74
    }
    @TestVisible class Cls_invoiceLines {
        //public string invnumber{get;set;}
        /**
     * @description description
     * @return description
     */
        public String description{get;set;} //FIND: PRMLW & FCTV
        /**
     * @description quantity
     * @return quantity
     */
        public String quantity{get;set;}    //2.0
        /**
     * @description netPrice
     * @return netPrice
     */
        public String netPrice{get;set;}    //10.0
        /**
     * @description taxAmount
     * @return taxAmount
     */
        public double taxAmount{get;set;}   //0.7
        /**
     * @description poNumber
     * @return poNumber
     */
        public String poNumber{get;set;}    //000010
        /**
     * @description lineNumber
     * @return lineNumber
     */
        public String lineNumber{get;set;}  //1
        /**
     * @description document
     * @return document
     */
        public cls_document document{get;set;}
        /**
     * @description netPerUnitDocCurr
     * @return netPerUnitDocCurr
     */
        public String netPerUnitDocCurr{get;set;}   //5.0
        /**
     * @description taxPerUnitDocCurr
     * @return taxPerUnitDocCurr
     */
        public String taxPerUnitDocCurr{get;set;}   //0.35
         /**
     * @description materialNumber
     * @return materialNumber
     */
        public String materialNumber{get;set;}  //000000000030003166
        /**
     * @description serviceDate
     * @return serviceDate
     */
        public String serviceDate{get;set;} //01/01/2006
    }  
    /**
     * @description docserviceDatenumber
     * 
     */ 
    @TestVisible class Cls_document {
         /**
     * @description docnumber
     * @return docnumber
     */
        public String docnumber{get;set;}   //0081000000
    }
     /**
     * @description Status
     * 
     */
    public class Status{
    public cls_processStatus processStatus;
    }
     /**
     * @description Cls_processStatus
     * 
     */
    public class Cls_processStatus {
        public String statusCode;   //400
        public String statusDescription;    //Uknown Application
        public String statusDetailMessage;  //Invalid Application Id found for retrieving Invoice Details
    }
     /**
     * @description Responsewrapper
     * 
     */ 
    public class Responsewrapper{
        /**
     * @description responsewrapper
     * 
     */
        public responsewrapper () {
            system.debug(LoggingLevel.WARN, 'test'); 
        }
        /**
     * @description responseBodyJSON
     * @return responseBodyJSON
     */
        public String responseBodyJSON { get; set; }
        /**
     * @description isSuccess
     * @return isSuccess
     */
        public Boolean isSuccess { get; set; }
        /**
     * @description errorMessage
     * @return errorMessage
     */
        public String errorMessage { get; set; }
    }

}