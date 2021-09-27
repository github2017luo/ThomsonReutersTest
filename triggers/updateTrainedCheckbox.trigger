trigger updateTrainedCheckbox on Training_Event_Contact__c (before insert, before update) {
    for (Training_Event_Contact__c tec : trigger.new)
    {
        if (tec.User_trained_Date__c != null)
        {
            if (tec.User_trained_Date__c <= System.Today())
                tec.Trained__c = true;
             else
                 tec.Trained__c = false;    
        }
        else
        {
            tec.Trained__c = false;
        }
    }   
}