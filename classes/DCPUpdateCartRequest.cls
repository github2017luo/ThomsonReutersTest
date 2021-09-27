/********************************************************************************
Class Name : DCPUpdateCartRequest 
@description : This is the wrapper for Update Cart Request 
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                           Developer                    Description
02-06-2021                  Vishnu Santhosh            DCP - 1781 |Initial Creation
*********************************************************************************/ 

@SuppressWarnings('PMD.AvoidGlobalModifier')
global class DCPUpdateCartRequest {

    global String cartId;
    global Integer bandedQuantity;
    global String contractTerm;
    global List<PerSeatProductDetails> perSeatProducts;
    
    /**
    @description Constructor for DCPUpdateCartRequest
    */  
    public DCPUpdateCartRequest(){
        perSeatProducts = new List<PerSeatProductDetails>();
    }
    /**
    @description Class for PerSeat Product LineItem 
    */
    global class PerSeatProductDetails {
        public String lineItemId;
        public Integer perSeatQuantity;
    }   
}