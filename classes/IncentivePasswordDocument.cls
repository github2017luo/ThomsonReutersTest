/*
======================================================================================================================
CLASS NAME: IncentivePasswordDocument  
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-11-12        Niket                   This class is used to get the details for promopassword document.
======================================================================================================================
*/
public class IncentivePasswordDocument{
    public list<incentive_password__c> oPasswordList{get;set;}
    public incentive_password__c oPassword{get;set;}
    public incentive_promotion__c oPromotion{get;set;}
    public string accountName{get;set;}
    public string productName{get;set;}
    public string sToday{get;set;}
    public string sEndDate{get;set;}
    public string promotionCretedBy{get;set;}   
    public string passwordCretedBy{get;set;}
    public string actualStartToday{get;set;}
    public IncentivePasswordDocument (){
        oPasswordList = new list<incentive_password__c>();
        oPassword= new incentive_password__c();
        oPromotion = new incentive_promotion__c();
        productName=''; 
        sToday=system.today().format();
        if(ApexPages.currentPage().getParameters().get('Type')=='Promo'){
        if(ApexPages.currentPage().getParameters().get('Pid') != null){
            oPromotion = [select
                            id,account__r.name,Promotion_type__c,Domain_Name__c,End_Date__c,title__C,description__C,Assigned_To__r.Name,product_type__c,CreatedBy.Name,owner.name
                          from
                             incentive_promotion__c
                          where
                              id =: ApexPages.currentPage().getParameters().get('Pid')];                           
            oPasswordList = [Select 
                            Start_Date__c, Promotion__c,  Password__c, Name, Id, End_Date__c, CreatedDate, Contact__c,Owner.Name,CreatedBy.Name, Contact__r.Name
                        from 
                            Incentive_Password__c 
                        where 
                            Promotion__c =: ApexPages.currentPage().getParameters().get('Pid')];
                            
           if(oPasswordList.size()>0){
               if(oPasswordList[0].End_date__C != null){                 
                   sEndDate=oPasswordList[0].End_date__C.Format(); 
               }  
                if(oPasswordList[0].Start_Date__c != null){
                   actualStartToday=oPasswordList[0].Start_Date__c.Format();
               }
           }                  
        }        
      }
        else{
            if(ApexPages.currentPage().getParameters().get('Type')=='Individual'){
                if(ApexPages.currentPage().getParameters().get('Pid') != null){
                    oPassword = [Select 
                                    Start_Date__c, Promotion__c, Password__c, Name, Id, End_Date__c, CreatedDate,Owner.Name, Contact__c, Contact__r.Name,CreatedBy.Name,createdbyid
                                from 
                                    Incentive_Password__c 
                                where 
                                    id =: ApexPages.currentPage().getParameters().get('Pid')];
                    oPromotion = [select
                                    id,account__r.name,Promotion_type__c,Domain_Name__c,End_Date__c,title__C,description__C,Assigned_To__r.Name,product_type__c,CreatedBy.Name,createdbyid
                                  from
                                     incentive_promotion__c
                                  where
                                      id =: oPassword.Promotion__c];
                   if(oPassword.End_date__C != null)                      
                  sEndDate= oPassword.End_date__C.Format();                                    
                   if(oPassword.Start_Date__c != null)
                      actualStartToday=oPassword.Start_Date__c.Format();   
                }               
            }       
        }

        accountName= oPromotion.account__r.name;
        productName= oPromotion.product_type__c;
        promotionCretedBy= oPromotion.CreatedBy.Name;
        passwordCretedBy= oPassword.CreatedBy.Name;  
                 
    }   
}