trigger APTS_ZPNDSubmissionTrigger on APTS_ZPND_Submission__e (After Insert) {
    APTS_ZPNDSubmissionTriggerHandler.HandleSubTrigger(Trigger.new);
}