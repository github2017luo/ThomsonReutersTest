/**
* @description Wrapper class for Order Submission
*/
public class APTS_Ordersubmissionwrapper{
    
    public String orderId;
    public String applicationId;
    public String companyId;
    public boolean isSuccess;
    public String loggerrecordId;
    public String orderNo;
     
    /**
     * @description APTS_Ordersubmissionwrapper
     */
    public APTS_Ordersubmissionwrapper(){ 
        orderId = '';
        applicationId = '';
        companyId = '';
        isSuccess = false;
        loggerrecordId = '';
        orderNo = '';
    }
}