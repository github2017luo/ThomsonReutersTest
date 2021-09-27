/**
     * @description APTS_OrderQueuetoESIUtility
   */
public without sharing class APTS_OrderQueuetoESIUtility{
      /**
       * @description switchToMonthlyAmount 
       * @param billFreq
       * @param listAmount
       * @return Decimal
       * Doc -15792
     */
    public static Decimal switchToMonthlyAmount(String billFreq, Decimal listAmount){
        if(billFreq =='Yearly' && listAmount!=null){
            listAmount = listAmount/12;
        }
        return listAmount;
    }
     /**
       * @description queryoftrialslist 
       * @param oppid
       * @return Ent_Trial__c
       * Doc -15792
   */
    public static List<Ent_Trial__c> queryoftrialslist(Id oppid)
    {   
        List<Ent_Trial__c> trialslist = new List<Ent_Trial__c>();
        if(Schema.sObjectType.Ent_Trial__c.isAccessible() && Schema.sObjectType.Ent_Trial__c.isQueryable())
        {
           
            trialslist = [SELECT Id FROM Ent_Trial__c WHERE Convert_to_Sale__c = true AND Opportunity__c=:oppid];
        }
        return trialslist;
    }  
}