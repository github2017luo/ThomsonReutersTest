/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DataHandler implements Apttus_WebStore.RemoteDispatcher.DispatchInterface {
    global DataHandler() {

    }
global class MailContent {
    global Boolean bccSender {
        get;
        set;
    }
    global List<String> ccAddresses {
        get;
        set;
    }
    global Id contactId {
        get;
        set;
    }
    global String displayName {
        get;
        set;
    }
    global String htmlBody {
        get;
        set;
    }
    global String plainBody {
        get;
        set;
    }
    global String replyTo {
        get;
        set;
    }
    global String subject {
        get;
        set;
    }
    global String templateName {
        get;
        set;
    }
    global List<String> toAddresses {
        get;
        set;
    }
    global Boolean useSignature {
        get;
        set;
    }
    global Id whatId {
        get;
        set;
    }
    global MailContent() {

    }
}
}
