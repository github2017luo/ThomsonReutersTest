/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class CustomClass {
    global static String OUTPUTFORMAT_PDF;
    global static String OUTPUTFORMAT_XLSX;
    global CustomClass() {

    }
global class ActionParams {
    global String ActionName {
        get;
        set;
    }
    global Map<String,String> CustomParams {
        get;
        set;
    }
    global String OutputFormat {
        get;
        set;
    }
    global Id RecordId {
        get;
        set;
    }
    global String SessionId {
        get;
        set;
    }
    global String SessionUrl {
        get;
        set;
    }
    global ActionParams() {

    }
}
global class MergeData {
    global String Data {
        get;
        set;
    }
    global String Name {
        get;
        set;
    }
    global MergeData(String datasetName) {

    }
}
}
