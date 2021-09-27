/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class FavoriteConfigurationStruct {
    global FavoriteConfigurationStruct() {

    }
global class SaveFavoriteRequestDO {
    global Id cartId {
        get;
        set;
    }
    global Apttus_Config2__FavoriteConfiguration__c favoriteConfigurationSO {
        get;
        set;
    }
    global List<Integer> lineNumbers;
    global SaveFavoriteRequestDO() {

    }
}
global class SaveFavoriteResponseDO extends Apttus_Config2.CPQStruct.APIResponseDO {
    global Apttus_Config2__FavoriteConfiguration__c favoriteConfigurationSO;
    global List<Integer> processedLineNumbers;
    global SaveFavoriteResponseDO() {

    }
}
}
