/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ControllerNoticeBoard {
    global ianb__NoticeBoardSettings__c BannerSettings {
        get;
    }
    global String BannerTitle {
        get;
    }
    global Boolean hideHeader {
        get;
        set;
    }
    global Boolean IsPreviewMode {
        get;
        set;
    }
    global String NoticeBoardID {
        get;
    }
    global String NotificationPrefix {
        get;
    }
    global List<ianb__Notification__c> Notifications {
        get;
    }
    global Integer PendingNotices {
        get;
    }
    global List<ianb.RecipientNotice> Recipients {
        get;
    }
    global Boolean TargetNewTab {
        get;
    }
    global ControllerNoticeBoard() {

    }
    global void SetDisplayedStatus() {

    }
    global void SetOpenedStatus() {

    }
    global Boolean getHasRecipients() {
        return null;
    }
}
