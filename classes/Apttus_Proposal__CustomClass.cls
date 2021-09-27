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
global class ActionParams {
    webService Boolean AddAutoFooter {
        get;
        set;
    }
    webService Boolean AddWatermark {
        get;
        set;
    }
    webService List<Apttus_Proposal.CustomClass.AttachmentInfo> Attachments {
        get;
        set;
    }
    webService String DocFileName {
        get;
        set;
    }
    webService List<Apttus_Proposal.CustomClass.ExternalLink> ExternalLinks {
        get;
        set;
    }
    webService String FooterText {
        get;
        set;
    }
    webService String HeaderText {
        get;
        set;
    }
    webService Id ParentId {
        get;
        set;
    }
    webService String ProtectionLevel {
        get;
        set;
    }
    webService Boolean RemoveWatermark {
        get;
        set;
    }
    webService String SessionId {
        get;
        set;
    }
    webService String SessionUrl {
        get;
        set;
    }
    global ActionParams() {

    }
}
global enum ActionType {ACTION_CLONE, ACTION_CREATE_AGREEMENT, ACTION_CREATE_FROM_ACCOUNT, ACTION_CREATE_FROM_OPPORTUNITY}
global class AttachmentInfo {
    webService Id RecordId {
        get;
        set;
    }
    webService String Title {
        get;
        set;
    }
    global AttachmentInfo() {

    }
}
global class ExternalLink {
    webService String Title {
        get;
        set;
    }
    webService String Url {
        get;
        set;
    }
    global ExternalLink() {

    }
}
global interface IQuoteLifecycleCallback {
    void afterClone(Apttus_Proposal__Proposal__c param0, Apttus_Proposal__Proposal__c param1);
    void afterCreateAgreement(Apttus_Proposal__Proposal__c param0, Apttus__APTS_Agreement__c param1);
    void afterCreateFromAccount(Apttus_Proposal__Proposal__c param0);
    void afterCreateFromOpportunity(Apttus_Proposal__Proposal__c param0);
}
global interface IQuoteLifecycleCallback2 extends Apttus_Proposal.CustomClass.IQuoteLifecycleCallback {
    void afterComplete(Apttus_Proposal__Proposal__c param0, Apttus_Proposal.CustomClass.ActionType param1);
    void afterComplete(Apttus__APTS_Agreement__c param0, Apttus_Proposal.CustomClass.ActionType param1);
}
global class MergeException extends Exception {
}
}
