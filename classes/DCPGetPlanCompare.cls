/********************************************************************************
Class Name 		: DCPGetPlanCompare
@description	: Request Structure for PlanCompare
********************************************************************************
===============================================================================
Date                         Developer              Description
27-06-2021                   Dinesh Kumar           Initial Creation
26-08-2021                   Sudhanshu Upadhayay    DCP-3943(Plan compare)
********************************************************************************
*/

public without sharing class DCPGetPlanCompare{
    private static final string STR_OPPID = 'oppId';
    private static final string STR_SSDID = 'ssdId';
    private static DCPPlanCompareResponse response;
    
    /**
@description Pulls DCPPlanCompareResponse data
@param reqParameter Request parameter pull from URL
@return Returns DCPPlanCompareResponse data
*/
    public static DCPPlanCompareResponse getDCPPlanCompareResponse(Map<String, String> reqParameter){
        
        if(reqParameter == null || reqParameter.isEmpty()){
            throw new DCCustomException('Request Parameters do not exist');
        }
        
        queryData(reqParameter);
        
        return populateDCPPlanCompareResponse();
    }
    
    private static void queryData(Map<String, String> reqParameter){
        string oppId;
        string ssdId;
        
        if(reqParameter.containsKey(STR_OPPID) && String.isNotBlank(reqParameter.get(STR_OPPID))
           && reqParameter.containsKey(STR_SSDID) && String.isNotBlank(reqParameter.get(STR_SSDID))){
               
               oppId = reqParameter.get(STR_OPPID);
               ssdId = reqParameter.get(STR_SSDID);
               response = DCPDBCategory.getCBCats(oppId, ssdId);
           }
        else{
            throw new DCCustomException('Error with request parameter. Parameter is missing or blank');
        }
    }
    
    private static DCPPlanCompareResponse populateDCPPlanCompareResponse(){
        return response;
    }
    
}