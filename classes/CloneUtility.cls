/**
*	{Purpose} - Utility class used to clone all the creatable fields on objects for use with Apex Cloning
*             This utility class is used in the following Apex class
*               - LeadClonewithRelatedListController    
*			  Test code coverage provided by the following class:
*				- LeadClonewithRelatedListControllerTest
*
*	CHANGE HISTORY
*	=============================================================================
*	Date		Name			Description
*	20181018	Vivek Ravi		Created
*	=============================================================================
**/

public  class CloneUtility {

 
    // Returns a dynamic SOQL statement for the whole object, includes only creatable fields 
    // since we will be inserting a cloned result of this query
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
        String selects = '';
        
        if(whereClause == null || whereClause == ''){
            return null;
        }
        
        //get a map of field names and field tokens
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        List<String> selectFields = new List<String>();
        
        if(fMap!=null){
            for(Schema.SObjectField ft : fMap.values()){ //loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); //describe each field (fd)
                if(fd.isAccessible())
				{
					selectFields.add(fd.getName());
                }
            }
        }
        
        if(!selectFields.isEmpty()){
            for (string s: selectFields){
                selects += s + ',';
            }
            if(selects.endsWith(',')){
                selects = selects.substring(0,selects.lastIndexOf(','));
            }            
        }
        
        return 'SELECT ' + selects+ ' FROM ' + objectName + ' WHERE ' + whereClause;
    }
 
}