public class sendreferralEmail {

    public PageReference updateActivity() {
        string Accountid = apexpages.currentPage().getParameters().get('accountid');
        List<task> oActivity = [select id,type,activity_category__c,tracking_code__c,createddate from task 
                                where whatid=:Accountid 
                                //and type='Email' 
                                and createdbyid=:userinfo.getuserid() 
                                order by createddate desc Limit 1];
        //system.debug('***'+oActivity);
        if(!oActivity.isempty()){
           if(system.now().getTime()- oActivity[0].createddate.getTime()<30000){//30seconds
               oActivity[0].activity_category__c=Apputil.getURLParam(apexpages.currentPage(),'category','');
               oActivity[0].tracking_code__c=Apputil.getURLParam(apexpages.currentPage(),'tracking',''); 
                            
               update oActivity[0];
           }
        }  
        //return null;     
         return new pagereference('/'+Accountid);
    }

}