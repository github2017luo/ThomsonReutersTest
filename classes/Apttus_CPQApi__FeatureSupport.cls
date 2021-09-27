/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class FeatureSupport {
global class FeatureInfo implements System.Comparable {
    webService Apttus_CPQApi.FeatureSupport.FeatureSet ProductFeatureSet {
        get;
        set;
    }
    webService Id ProductFeatureSOId {
        get;
        set;
    }
}
global class FeatureSet {
    webService String Description {
        get;
    }
    webService List<Apttus_CPQApi.FeatureSupport.ProductFeatureValue> Features {
        get;
    }
    webService Id FeatureSetSOId {
        get;
    }
    webService String Name {
        get;
    }
    webService Decimal Sequence {
        get;
    }
}
global class ProductFeatureValue implements System.Comparable {
    webService Id FeatureSOId {
        get;
    }
    webService Boolean IsIncluded {
        get;
        set;
    }
    webService String Name {
        get;
    }
    webService Id ProdFeatureValueSOId {
        get;
    }
    webService Id ProdId {
        get;
    }
    webService Decimal Sequence {
        get;
    }
    webService String Value {
        get;
        set;
    }
}
global class SelectedComparisonProducts {
}
}
