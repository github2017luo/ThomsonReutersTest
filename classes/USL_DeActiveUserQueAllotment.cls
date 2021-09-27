public class USL_DeActiveUserQueAllotment {
    
    @invocablemethod
    public static void checkDeActiveUser(list<ID> casesId){
        list<ID> caseIds = new list<ID>();
        string queuelist= System.Label.ESC_CustomerServiceQueue;
        
        List<case> cOwners= [select Id, origin,ownerId from case where id IN : casesId ];
        //caseIds.clear();
        for(case cOwner :cOwners ){
            system.debug('Queue-->'+cOwner.ownerId);
            caseIds.add(cOwner.ownerId);
        }
        List<QueueSobject> queues = [SELECT Id,QueueId,SobjectType FROM QueueSobject where QueueId IN :caseIds and SobjectType = 'case'];
        system.debug('queues'+queues);
        
        list<ID> gId = new list<ID>();
        for(QueueSobject gids :queues){
            gId.add(gids.QueueId);
        }
        system.debug('gId'+gId);
        List<Groupmember>  gMember = [SELECT ID,GroupId,UserOrGroupId from Groupmember where GroupId IN :gId];
        
        List<Id> grp = new List<Id>();
        list<ID> uId = new list<ID>();
        for(Groupmember gids :gMember){
            uId.add(gids.UserOrGroupId);
            grp.add(gids.GroupId);
        }
        List<User> users = [select id from user where isActive = true and id IN :uId];
        system.debug('users.size()-->'+users.size());
        if(users.size()==0){
            Group grpName = [SELECT Id,Name FROM Group where type='Queue' AND DeveloperName =: System.Label.ESC_CustomerServiceQueue];
            system.debug('names of queues -->' + grpName);
            for(case cOwner :cOwners ){
                cOwner.ownerId = grpName.Id;
            }
            update cOwners;
            
            
        }else{
            system.debug('Users active in the queue'); 
        }
            /*for(user usr :users){
            if(usr.id != Null){
            system.debug('Users are active'); 
            flag = true;
            }else{
            system.debug('Users are Deactive');  
            flag = false;
            }
            }
            */
        
    }
    
}