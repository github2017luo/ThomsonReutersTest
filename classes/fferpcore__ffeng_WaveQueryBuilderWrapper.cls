/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class ffeng_WaveQueryBuilderWrapper {
    global List<String> columns {
        get;
    }
    global String datasetCurrentVersionId {
        get;
    }
    global String datasetId {
        get;
    }
    global List<String> filterConditions {
        get;
    }
    global List<List<String>> orders {
        get;
    }
    global ffeng_WaveQueryBuilderWrapper() {

    }
    global virtual fferpcore.ffeng_WaveQueryBuilderWrapper addColumns(List<String> columnsName) {
        return null;
    }
    global virtual fferpcore.ffeng_WaveQueryBuilderWrapper addFilterConditions(List<String> filterConditions) {
        return null;
    }
    global virtual fferpcore.ffeng_WaveQueryBuilderWrapper addOrders(List<List<String>> addOrders) {
        return null;
    }
    global virtual String execute() {
        return null;
    }
    global virtual fferpcore.ffeng_WaveQueryBuilderWrapper loadDataset(String datasetId, String currentVersionId) {
        return null;
    }
}
