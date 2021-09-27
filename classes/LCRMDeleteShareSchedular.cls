global Class LCRMDeleteShareSchedular //implements Schedulable
{ 
    // Added this method to cover the code in test class: DPS-14173.
    global LCRMDeleteShareSchedular(){}
    /* START: DPS-14173 - Commented this Class.
    global void execute(SchedulableContext  sc)
    {        
        Database.executeBatch(New LCRMCaseShareDelete(), Integer.valueof(Label.LCRM_Delete_Share_Batch_Size.trim()));
    }
	END: DPS-14173 - Commented this Class. */
}