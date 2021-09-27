/*
===============================================================================
GenericSort
===============================================================================

PURPOSE: To sort a non-primitive List            

FUNCTIONALITY: It has static methods to sort sobject List asc or Desc

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2012-01-15    Partha                  Created
                                            
===============================================================================
*/

public class GenericSort{
     /**
   * Static method which sorts the sobject List
   *
   * @param  items    Sobject List
   * @param  sortField  Field API Name by which list will be sorted
   * @param  order      sort order- asc or Desc 
   * @return Sobject List  
   */
    public  static List<sObject> sortList(List<sObject> items, String sortField, String order){        
        Boolean isSortFieldReference = false;
        Map<Id,String> referenceName;
        if(items.size()>0){
        if(items[0].getSObjectType().getDescribe().fields.getMap().get(sortField).getDescribe().getType().Name() == 'REFERENCE'){
            isSortFieldReference = true;
            referenceName = new Map<Id,String>();
            Set<Id> referenceIds = new Set<Id>();
            for(sObject s:items){
                referenceIds.add((Id)s.get(sortField));
            }
            List<Schema.Sobjecttype> objType = items[0].getSObjectType().getDescribe().fields.getMap().get(sortField).getDescribe().getReferenceTo();
            String objectType = objType[0].getDescribe().getName();

            //Query the related objects for the name and populate the Id -> Name map
            String queryString = 'select Id, Name from ' + objectType + ' where ID IN :referenceIDs';
            for(sObject s:Database.query(queryString)){
            // DevAngel - EDIT - if the reference field is null then we will not have a result, so we need to "create one"
                if (s.get('Name') == null) {
                    referenceName.put((Id)s.get('Id'), 'n/a');
                } else {
                    referenceName.put((Id)s.get('Id'),(String)s.get('Name'));
                }
            }
        }
        List<cObject> resultList = new List<cObject>();
        Map<object, List<cObject>> objectMap = new Map<object, List<cObject>>();
        for(sObject ob:items){
            if(isSortFieldReference == false){
                if(objectMap.get(ob.get(sortField)) == null){
                    objectMap.put(ob.get(sortField), new List<cObject>());
                }
                cObject o = new cObject(ob);
                objectMap.get(ob.get(sortField)).add(o);
            }else{
                if(objectMap.get(referenceName.get((Id)ob.get(sortField))) == null){
                    objectMap.put(referenceName.get((Id)ob.get(sortField)), new List<cObject>());
                }
                cObject o = new cObject(ob);
                objectMap.get(referenceName.get((Id)ob.get(sortField))).add(o);
            }
        }
        List<object> keys = new List<object>(objectMap.keySet());
        keys.sort();
        for(object key:keys){
            resultList.addAll(objectMap.get(key));
        }
        items.clear();
        if(order.toLowerCase() == 'asc'){
            for(cObject ob:resultList){
                items.add(ob.obj);
            }
        }else if(order.toLowerCase() == 'desc'){
            for(integer i = resultList.size()-1; i >= 0; i--){
                items.add(resultList[i].obj);
            }
        }
        }
        return items;
    }
    /* inner Class */
    public class cObject{
        sObject obj {get; set;}
        public cObject(sObject obj){
            this.obj = obj;
        }
    }
    
}