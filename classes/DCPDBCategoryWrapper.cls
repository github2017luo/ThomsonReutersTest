/********************************************************************************
Class Name : DCPRenewalDBCatWrapper
@description : Request Structure for dbData Array
********************************************************************************
===============================================================================
Date                         Developer              Description
27-06-2021                   Dinesh Kumar           DCP-2214 | Initial Creation
23-08-2021                   Sudhanshu Upadhayay    DCP-3493 | Wrapper class for bundle/digital proposal/product map
********************************************************************************
*/
public class DCPDBCategoryWrapper {
    public String materialId;
    public String productPlanId;
    public String materialNumber;
    public String subscriptionNumber;
    public String materialDescription;
    public String internalDescription;
    public String jurisdiction;
    public String additionalInternalDescription;
    public String classificationValue;
    public Decimal classificationValueSortOrder;
    public String productGroup;
    public Decimal productGroupSortOrder;
    
    /**
    @description Constructor for DCPDBCategoryWrapper to solve coverage issue.
    */
    public DCPDBCategoryWrapper(){
        System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DCPDBCategoryWrapper *** ' );
    }
    
     /**
    @description  
    */
    public class DCPProductsByProposals{
        public string proposalId;// map for digital products by proposal
        public Map<string,List<string>> proposalToBundleProductsMap;//map for bundle products by proposal

        /**
        @description  
         */
        public DCPProductsByProposals(){
            proposalToBundleProductsMap = new Map<string,List<string>>();
        }

    }
   

}