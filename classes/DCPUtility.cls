/**
    @description Utility class for DCP projects.
    CHANGE HISTORY
    ================================================
    Date            Developer           Description
    2021-04-14      Benjamin Her        DCP-1414 Initial Creation
    2021-05-03      Vishnu Santhosh     DCP-1118 Added the null case
    2021-05-06      Herin Acharya       DCP-1124 Added the removeSpecialChar parameter in method 'formatName'
	2021-07-28		Himanshu Sharma		DCP-2682 Added new to online (NTO)
 */
public without sharing class DCPUtility{
    
    private static final List<String> PRINT_PRODUCTS = System.Label.Digital_Print_Product_Family.split(',');
    private static final List<String> FINDLAW_PRODUCTS = System.Label.Digital_FindLaw_Product.split(',');
    
    /**
    @description To set an emptry string '' if the parameter is null
    @param data String variable that is to be checked for null case.
    @return Null string if the parameter is null else the the string is returned.
    */
    public static String nullCheck(String data){
        if(data == null){
            return '';
        }
        else{
            return data;
        }
    }
    /**
        @description Intended for names, removes special characeters and capitalizes the first letter of each word. 
        @param name String value which is to be cleaned and formatted.
        @param removeAllSpecialChar Used to avoid the removal of special characters(For some scenarios)
        @return Returns a clean and properly capitalized name
     */
    public static String formatName(String name, boolean removeAllSpecialChar){
        
        if(name == null){
            return '';
        }
        String str = name;
        List<String> formattedString = new List<String>();
        
        //Removes all characters except for Alphanumeric and spaces
        
        if(removeAllSpecialChar){
            str = str.replaceAll('[^a-zA-Z0-9\\s+]', '');
        }else{
            str = str.replaceAll('[^a-zA-Z0-9\\s+&]', '');
        }
        
        //Splits the string by spaces, if applicable
        List<String> stringList = str.split(' ');

        //Iterate over List of string, capitalize and rebuild string.
        for(String s : stringList){
            s = s.toLowerCase().capitalize();
            formattedString.add(s);
        }
        
        return String.join(formattedString,' ');
    }
    
     /**
        @description Determines if a customer is new to online (NTO)
        NTO Customer Critera: No account number exists OR account number exists but all assets are Print products
        @param cart Cart record
        @return Returns true/false depending on whether the customer is considered an NTO customer
     */
    public static boolean isNTOCustomer(Apttus_Config2__ProductConfiguration__c cart) {
        List<String> findLawProducts = new List<String>();
        for(String str : FINDLAW_PRODUCTS){
            str = '%'+str+'%';
            findLawProducts.add(str);
        }
        Integer nonPrintAssetCount = [
            SELECT count() FROM Apttus_Config2__AssetLineItem__c
            WHERE APTS_SSD_Bill_To__r.id =: cart.Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__c
            AND Apttus_Config2__AssetStatus__c = 'Activated'
            AND Apttus_Config2__ProductId__r.Family NOT IN: PRINT_PRODUCTS
            AND (NOT Apttus_Config2__ProductId__r.Name LIKE: findLawProducts)
            Limit 1
            
        ]; // DLT-21264 added the asset status condition

        //If account number exists and the account contains an asset for a non-Print product, return FALSE
        if (String.isNotBlank(cart.Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__r.Source_System_Account_Number__c) &&
            nonPrintAssetCount > 0) {
            return false;
        }

        //Return true as customer is considered NTO customer.
        return true;

    } //end of isNTOCustomer() method 
    
}