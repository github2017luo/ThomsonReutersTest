public without sharing class USL_casequeueupdate{

 @InvocableMethod(label='USL_QueueNameupdate')
public static void lastqueueupdate(list<case> Newcase){
list<id> listownerid =new list<id>();
 list<case> updatecase =new list<case>();
  map<Id,String> mapqueue =new map<Id,String>();
for(case c :Newcase){
listownerid.add(c.OwnerId);
}

    list<group> listgroup =new list<group>([select id,Name from group where id In :listownerid]);
    
    system.debug('listgroup' +listgroup);
   if(listgroup.size()>0){
    for(group g:listgroup)
    {
        mapqueue.put(g.id,g.Name);
    }
    // system.debug('mapqueue' +mapqueue);
  // list<case> listcaseupdate= new list<case>([Select id,OwnerId from case where OwnerId IN:mapqueue.keyset()]); 
    //system.debug('listcaseupdate' +listcaseupdate);
      for(case c1:Newcase){
         system.debug('c1' +c1.OwnerId);
         case c2=new case();
         c2.id=c1.id;
        c2.USL_Last_Queue_Name__c=mapqueue.get(c1.OwnerId);
        
        updatecase.add(c2);
      }
      if(Schema.sObjectType.case.isAccessible() || Schema.sObjectType.case.isUpdateable()){
     update updatecase;
    }
    }
   } 

}