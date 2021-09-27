/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SObjectDescribeInfo {
    webService List<Apttus_Proposal.SObjectDescribeInfo.FieldInfo> FieldInfos {
        get;
    }
    webService Apttus_Proposal.SObjectDescribeInfo.SObjectInfo ObjectInfo {
        get;
    }
    webService List<Apttus_Proposal.SObjectDescribeInfo.ReferenceInfo> ReferenceInfos {
        get;
    }
    webService List<Apttus_Proposal.SObjectDescribeInfo.RelationshipInfo> RelationshipInfos {
        get;
    }
global class FieldInfo {
    webService String FieldLabel {
        get;
    }
    webService String FieldName {
        get;
    }
    webService String FieldType {
        get;
    }
    webService Boolean IsCustom {
        get;
    }
    webService Boolean IsNameField {
        get;
    }
    webService Boolean IsUpdateable {
        get;
    }
    webService Integer Precision {
        get;
    }
    webService String ReferenceTo {
        get;
    }
    webService Integer Scale {
        get;
    }
    webService String TagName {
        get;
    }
}
global class ReferenceInfo {
    webService String FieldLabel {
        get;
    }
    webService String FieldName {
        get;
    }
    webService String ReferenceTo {
        get;
    }
    webService String TagName {
        get;
    }
}
global class RelationshipInfo {
    webService String FieldName {
        get;
    }
    webService Boolean IsCascadeDelete {
        get;
    }
    webService String RelatedTo {
        get;
    }
    webService String RelationshipLabel {
        get;
    }
    webService String RelationshipName {
        get;
    }
    webService String TagName {
        get;
    }
}
global class SObjectInfo {
    webService String SObjectLabel {
        get;
    }
    webService String SObjectLabelPlural {
        get;
    }
    webService String SObjectName {
        get;
    }
    webService String TagName {
        get;
    }
}
}
