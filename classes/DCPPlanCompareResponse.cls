/**
    @description Response wrapper for Json response
    
    ================================================
    Date            Developer           Description   
    2021-06-29      Dinesh             DCP-2214 | Initial Creation
 */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class DCPPlanCompareResponse{
    
    public string status;
    public integer code;
    public string message;
    public DCPObjects data;
    /**
        @description  
     */
    public DCPPlanCompareResponse(){
        data = new DCPObjects();
    }

    /**
        @description  
     */
    public class DCPObjects{
        
        public List<DCPProductPlan> offerProductPlan;
        /**
        @description  
         */
        public DCPObjects(){
            offerProductPlan = new List<DCPProductPlan>();
        }
    }

    /**
    @description  
    */
    public class DCPProductPlan{

        public String proposalId;
        public String proposalType;
        public integer featurecount;
        public List<DCPDBCategoryWrapper > dbCatData;

        /**
        @description  
         */
        public DCPProductPlan(){
            dbCatData = new List<DCPDBCategoryWrapper >();
        }

    }
    
    
}