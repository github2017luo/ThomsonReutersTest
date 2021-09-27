/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class CustomClass {
    global CustomClass() {

    }
global class CustomFieldDO {
    global String Name {
        get;
    }
    global Object Value {
        get;
    }
}
global class GuidanceCollDO {
    global List<Apttus_DealMgr__DealPercentileRange__c> ColorBands {
        get;
    }
    global List<Decimal> ColorBandValues {
        get;
    }
    global Id ContextId {
        get;
    }
    global List<Apttus_DealMgr.CustomClass.CustomFieldDO> CustomFields {
        get;
    }
    global String CustomMeasureFieldLabel {
        get;
    }
    global String CustomMeasureFieldName {
        get;
    }
    global Decimal DealColorBandSequence {
        get;
    }
    global List<String> DimensionLabels {
        get;
    }
    global List<String> DimensionValues {
        get;
    }
    global String Measure {
        get;
    }
    global String MeasureType {
        get;
    }
    global Decimal MeasureValue {
        get;
    }
}
global interface IDealGuidanceCallback {
    Set<String> getFieldNames(String param0);
    Decimal getMeasureValue(SObject param0, String param1);
}
global interface IDealGuidanceCallback2 extends Apttus_DealMgr.CustomClass.IDealGuidanceCallback {
    Set<Id> getProductGroupIdsForProducts(Set<Id> param0);
    Set<Id> getProductIdsForGroup(Id param0);
}
global interface IDealOptimizerCallback {
    Apttus_DealMgr.CustomClass.ScoreResultDO scoreDeal(Id param0);
}
global class ScoreResultDO {
    global Boolean IsSuccess {
        get;
        set;
    }
    global ScoreResultDO() {

    }
}
}
