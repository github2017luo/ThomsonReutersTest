trigger ESC_EmailCaseRouting on EmailMessage (after insert,before delete) {
    ESC_EmailMsgTriggerHandler.callEmailMsgHandler();
}