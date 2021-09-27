/********************************************************************************
Class Name : DCPRenewalFindlawWrapper
@description : Request Structure for Findlaw Array
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                         Developer              Description
25-07-2021                  Herin Acharya          Initial Creation

*/ 
public class DCPFindlawProductsWrapper extends DCPRenewalProductWrapper{
    public decimal price;
    public string materialNumber;
    public List<FindlawSubProducts> listSubProducts;
    public List<String> contractNumbers;

    /**
    @description Constructor
    */
    public DCPFindlawProductsWrapper(){
        listSubProducts = new List<FindlawSubProducts>();
    }
    /**
    * @description Class for the Address details components.
    */
    public class FindlawSubProducts{
        public String lineItemId;
        public String practiceArea;
        public String geography;
    } 
}