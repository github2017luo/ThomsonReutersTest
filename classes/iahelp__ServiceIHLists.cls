/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ServiceIHLists {
    global ServiceIHLists() {

    }
global enum KnownTreeOps {JITFetching, NodeOrdering}
global class ListingItem implements System.Comparable {
    global String ActionCode {
        get;
        set;
    }
    global String Cols {
        get;
        set;
    }
    global String Icon {
        get;
        set;
    }
    global String IconLabel {
        get;
        set;
    }
    global String IconTitle {
        get;
        set;
    }
    global String Id {
        get;
        set;
    }
    global String Label {
        get;
        set;
    }
    global String Parameters {
        get;
        set;
    }
    global String RowState {
        get;
        set;
    }
    global String SortValue {
        get;
        set;
    }
    global String StyleClass {
        get;
        set;
    }
    global String SupportedDrops {
        get;
        set;
    }
    global String Title {
        get;
        set;
    }
    global ListingItem() {

    }
    global Integer compareTo(Object compareTo) {
        return null;
    }
}
global interface TreeNodeSupplier {
    List<iahelp.ServiceIHLists.ListingItem> getTreeNodes(String param0, Integer param1);
}
global interface TreeOpsSupplier extends iahelp.ServiceIHLists.TreeNodeSupplier {
    List<iahelp.ServiceIHLists.KnownTreeOps> SupportedOperations();
}
}
