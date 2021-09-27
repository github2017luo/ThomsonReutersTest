/********************************************************************************
Class Name : DCPRenewalProductWrapper 
@description : Wrapper for DCPRenewalProduct Class 
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                           Developer                 Description
15-07-2021                  Vishnu Santhosh           DCP-2144 | Initial Creation
15-07-2021                  Vishnu Santhosh           DCP-2215 | Migrated changes made by Sudhanshu from DCPRenewalProductDetails class.
*********************************************************************************/ 
public virtual class DCPRenewalProductWrapper {
    
    public String productName;
    public String qualifier;
    //DCP-2115 (Added productid and isEdge flag for wrapper class)
    //Added By: Sudhanshu Upadhayay
    public String productId;
    public boolean isEdge;

    /**
    @description Constructor for DCPRenewalProductWrapper to avoid code coverage issue
    */
    public DCPRenewalProductWrapper(){
        System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DCPRenewalProductWrapper *** >> ' );
    }
}