Public class USLSubbillingplanwrapper{

   public class Billingrequestwrapper{
    public EsiHeader esiHeader{get;set;}
    public SubscriptionDetails subscriptionDetails{get;set;}
    }
   public class EsiHeader {
        public String applicationId{get;set;}    //ESCU
        public String messageId{get;set;}    //messageId3
        public String companyId{get;set;}    //west       
         public EsiHeader(String appid,String comid){
            this.applicationId=appid;
            this.companyId=comid;
        }
    }
   public class SubscriptionDetails {
        public String subscriptionNumber{get;set;}   //subscriptionNumber14
        public String subscriptionLineItem{get;set;} //subscriptionLineItem15
       public SubscriptionDetails(String subnum,string sublineitem){
          this.subscriptionNumber=subnum;
         this.subscriptionLineItem=sublineitem;
     }
    
   }
  
  Public class Billingresponsewrapper{
    public cls_billPlanHeader billPlanHeader{get;set;}
    public list<cls_billPlanDetails> billPlanDetails{get;set;}
    public cls_statusDetails[] statusDetails{get;set;}
    }
    public class cls_billPlanHeader {
        public String subscriptionNumber{get;set;}  //subscriptionNumber175
        public List<cls_subscriptionLines> subscriptionLines{get;set;}
        public cls_billPlanInfo billPlanInfo{get;set;}
        public String endDate{get;set;} //2018-09-22
    }
    public class cls_subscriptionLines {
        public String subscriptionLineNumber{get;set;}   //subscriptionLineNumber251
    }
    public class cls_billPlanInfo {
        public String billPlanNumber{get;set;}   //billPlanNumber297
        public String billPlanStartDate{get;set;}    //2018-09-22
        public String billPlanEndDate{get;set;}  //2018-09-22
        public String billPlanType{get;set;} //billPlanType298
        public String billPlanDescription{get;set;}  //billPlanDescription299
    }
    public class cls_billPlanDetails {
        public String settlementDate{get;set;}   //2018-09-24
        public String billItemStartDate{get;set;}    //2018-09-24
        public String billItemEndDate{get;set;}  //2018-09-24
        public String billItemPrice{get;set;}    //billItemPrice210
        public String billCurrency{get;set;} //currency211
        public String block{get;set;}    //block212
        public String billItemStatus{get;set;}   //billItemStatus213
        public String billItemType{get;set;} //billItemType214
        public String manaulDateInd{get;set;}    //manaulDateInd215
        public String correctionDateInd{get;set;}    //correctionDateInd216
        public String paymentTerms{get;set;} //paymentTerms217
        public String dateCategory{get;set;} //dateCategory218
    }
    public class cls_statusDetails {
        public String statusCode{get;set;}   //statusCode222
        public String statusDescription{get;set;}    //statusDescription223
        public String statusDetailMessage{get;set;}  //statusDetailMessage224
    }

}