/******************************************************************************************
* Class         : OmniCallToOLCFetchOnlineContactsWrapper
* @description  : test
* @param        : NA
* @return       : NA
* Created Date  : 07-May-2021
* Author        : TCS Developer 
* ****************************************************************************************/
 
public  without sharing class OmniCallToOLCFetchOnlineContactsWrapper {
   
/******************************************************************************************
* WrapperClass Name : ESIHeaderCls
* Created Date      : 07-May-2021
* @param            : NA
* @description      : Wrapper
* @return           : NA
* Author            : TCS Developer 
* ****************************************************************************************/
    public class ESIHeaderCls {
        /**
        * @description applicationId
        */
        public string applicationId {get; set;}
        /**
        * @description ESIHeaderCls
        * @param appId
        */
        public ESIHeaderCls(string appId) {
            applicationId = appId;
        }
    }
    
   
/******************************************************************************************
* WrapperClass Name : AccountCls
* Created Date      : 07-May-2021
* Author            : TCS Developer 
* @param            : NA
* @description      : Wrapper
* @return           : NA
* ****************************************************************************************/
    
    public class AccountCls {
        /**
         * @description accountNumber
         */
        public string accountNumber {get; set;}
        /**
         * @description AccountCls
         * @param accId
         */
        public AccountCls(string accId) {
            accountNumber = accId;
        }
    }
        
/******************************************************************************************
* WrapperClass Name : CallInviteCol
* Created Date      : 07-May-2021
* @description      : Wrapper
* @param            : NA
* Author            : TCS Developer 
* @return           : NA
* ****************************************************************************************/
    public class CallInviteCol {
        /**
        * @description eSIHeader
        */
        public ESIHeaderCls ESIHeader {get;set;}
        /**
        * @description account
        */
        public accountCls account {get;set;}
        /**
        * @description userGuidDomain
        */
        public string userGuidDomain {get; set;}
        /**
        * @description onlineContactFilter
        */
        public OnlineContactFilterCls OnlineContactFilter{ get; set;}
        /**
        * @description CallInviteCol
        * @param esih
        * @param acch
        */
        public CallInviteCol(eSIHeaderCls esih, accountCls acch) {
            ESIHeader = esih;
            account = acch;
            OnlineContactFilter = new OnlineContactFilterCls();
        }
    }

/******************************************************************************************
* WrapperClass Name : OnlineContactFiltercls
* Created Date      : 07-May-2021
* @description      : Wrapper
* @param            : NA
* Author            : TCS Developer 
* @return           : NA
* ****************************************************************************************/
    public class OnlineContactFiltercls {
        /**
         * @description checkPrism
         
         */
        public string checkPrism {get;set;}
        /**
         * @description OnlineContactFilterCls
         */
        public OnlineContactFilterCls() {
            checkPrism = 'false';
        }
    }

  
}