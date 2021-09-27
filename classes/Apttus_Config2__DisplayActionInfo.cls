/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DisplayActionInfo implements System.Comparable {
    global Apttus_Config2__ConfigCustomDisplayActions__c ActionSO {
        get;
    }
    global Boolean IsCustom {
        get;
    }
    global Boolean IsEnabled {
        get;
        set;
    }
    global String OnClickJavaScript {
        get;
        set;
    }
    global System.PageReference TargetPageReference {
        get;
        set;
    }
    global DisplayActionInfo(Apttus_Config2__ConfigCustomDisplayActions__c actionSO) {

    }
}
