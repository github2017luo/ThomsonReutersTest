global class Ecom_AccountExecutiveSchedulable implements Schedulable
{   
    global void execute(SchedulableContext scContext)
    {      
        Ecom_AccountExecutiveBatch dmc = new Ecom_AccountExecutiveBatch();
        Database.executeBatch(dmc, 190);
        
    }
}