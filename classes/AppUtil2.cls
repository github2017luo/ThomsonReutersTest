/**
 * Has the following methods
 * 1.) Gets the fields for the required object
 * 2.) Returns the operator values for a given displayType(string or number etc)
 * 3.) Returns the query string for the selected field, operator and value.
 *
 * @author  Srikanth Kuruva
 * @version  2012-01-30
 */
global class AppUtil2
{
    private static Map<String, Schema.SObjectType> mapGlobalObject ;
    public static map<string,string> getFieldNameList(String objname, Map<String,string> mapFields, Map<String,string> mapNameKey, Map<String,Schema.DisplayType> mapfieldsAndTypes ){
       mapGlobalObject = Schema.getGlobalDescribe() ;
       map<String,string> mapoffields = new map<string,string>();
       list<list<String>> result = new list<list<string>>();

        //Get the token for this object
        Schema.SObjectType s = mapGlobalObject.get(objName) ;
        Map<String, Schema.SObjectField> fMap = s.getDescribe().fields.getMap() ;
        List<Schema.SObjectField> fTokens = fMap.values() ;
        for( Integer i = 0 ; i < fTokens.size() ; i++ ){
        Schema.DescribeFieldResult f = fTokens.get(i).getDescribe() ;
        if( f.isAccessible() ) {
                 if(f.getType()!=Schema.DisplayType.REFERENCE && f.getType()!=Schema.DisplayType.ID){
                 mapoffields.put(f.getLabel(),f.getname());
                 mapfieldsAndTypes.put(f.getLabel(),f.getType());
                 mapNameKey.put(f.getname(),f.getLabel());
                 }
                 else if(f.getType()==Schema.DisplayType.REFERENCE){
                 List<Schema.SObjectType> acc = f.getReferenceTo();
                 Map<String, Schema.SObjectField> ff = acc[0].getDescribe().fields.getMap() ;
                 List<Schema.SObjectField> fTokens1 = fMap.values() ;
                 for( Integer j = 0 ; j < fTokens1.size() ; j++ ){
                 Schema.DescribeFieldResult f1 = fTokens1.get(j).getDescribe() ;
                 if(f1.isNameField()){
                 String relLabel = f.getRelationshipName()+' '+f1.getName();
                 String relName = f.getRelationshipName()+'.'+f1.getName();
                 if(relLabel.indexof('__r')!=-1){
                 relLabel = relLabel.subString(0,relLabel.indexOf('__r'));
                 relLabel += ' Name';
                 }
                 mapoffields.put(relLabel,relName);
                 mapfieldsAndTypes.put(relLabel,f.getType());
                 mapNameKey.put(relName,relLabel);
                 }
                 }
                 }
            }
       }
        return mapoffields;  
    }
    
    public static List<SelectOption> populateOperators(Schema.DisplayType sDisplayType)
    {
        List<SelectOption> operatorList;
        if(sDisplayType==Schema.DisplayType.STRING || sDisplayType==Schema.DisplayType.PICKLIST
          ||sDisplayType==Schema.DisplayType.TEXTAREA ||sDisplayType==Schema.DisplayType.REFERENCE)
        {           
           operatorList = new List<SelectOption>();
           operatorList.add(new SelectOption('--None--','--None--'));
           operatorList.add(new SelectOption('equals','equals'));
           operatorList.add(new SelectOption('not equal to','not equal to'));
           operatorList.add(new SelectOption('starts with','starts with'));
           operatorList.add(new SelectOption('contains','contains'));
           operatorList.add(new SelectOption('includes','includes'));
           //operatorList.add(new SelectOption('does not contain','does not contain'));
           //operatorList.add(new SelectOption('less than','less than'));
           //operatorList.add(new SelectOption('greater than','greater than'));
           //operatorList.add(new SelectOption('less or equal','less or equal'));
           //operatorList.add(new SelectOption('greater or equal','greater or equal'));           
        }
        /*else if(sDisplayType==Schema.DisplayType.BOOLEAN){
           operatorList = new List<SelectOption>();
           operatorList.add(new SelectOption('--None--','--None--'));
           operatorList.add(new SelectOption('equals','equals'));
           operatorList.add(new SelectOption('not equal to','not equal to'));
        }
        else if(sDisplayType==Schema.DisplayType.DATE||sDisplayType==Schema.DisplayType.DATETIME||sDisplayType==Schema.DisplayType.INTEGER||sDisplayType==Schema.DisplayType.DOUBLE||sDisplayType==Schema.DisplayType.PERCENT||sDisplayType==Schema.DisplayType.CURRENCY){
           operatorList = new List<SelectOption>();
           operatorList.add(new SelectOption('--None--','--None--'));
           operatorList.add(new SelectOption('equals','equals'));
           operatorList.add(new SelectOption('not equal to','not equal to'));
           operatorList.add(new SelectOption('less than','less than'));
           operatorList.add(new SelectOption('greater than','greater than'));
           operatorList.add(new SelectOption('less or equal','less or equal'));
           operatorList.add(new SelectOption('greater or equal','greater or equal'));           
       }
       else{
           operatorList = new List<SelectOption>();
           operatorList.add(new SelectOption('not equal to','not equal to'));
       }*/
   return operatorList;
   }
   
   public static List<String> getValueList(string sCommaSeperatedValue, string sDelimiter)      
   {
     List<String> listCommaSeperatedValue = new List<String>();
     for (String s : sCommaSeperatedValue.split(sDelimiter))
     {
        if (s != null)
        listCommaSeperatedValue.add('\''+s.trim()+'\'');
     }
     return listCommaSeperatedValue;
   }
   
    public static String queryForText(String field,String operator,String srchValue)
    {
        String sQueryString = '';
        if(operator=='equals')
        {
            sQueryString = ' and '+field+' = ';
            srchValue = '\''+srchValue+'\'';
        }
        else if(operator=='not equal to')
        {
            sQueryString = ' and '+field+' <> ';
            srchValue = '\''+srchValue+'\'';
        }
        else if(operator=='starts with')
        {
            sQueryString = ' and '+field+' like ';
            srchValue = '\''+srchValue+'%\'';
        }
        else if(operator=='contains')
        {
            sQueryString = ' and '+field+' like ';
            srchValue = '\'%'+srchValue+'%\'';
        }
        else if(operator=='includes')
        {
            sQueryString = ' and '+field+' in ';            
        }
        else if(operator=='does not contain')
        {
            srchValue = '%'+srchValue+'%';
            /*tempConList1 = new List<String>();
            Contact[] tempCon = Database.query('Select id from Contact where '+field+' like :srchValue order by Name');
            for(Integer i=0;i<tempCon.size();i++)
            tempConList1.add(tempCon[i].id);
            sQueryString = ' and id not in :tempConList1';*/
        }
        
        else if(operator=='less than')
            sQueryString = ' and '+field+' < ';
        else if(operator=='greater than')
            sQueryString = ' and '+field+' > ';
        else if(operator=='less or equal')
            sQueryString = ' and '+field+' <= ';
        else if(operator=='greater or equal')
            sQueryString = ' and '+field+' >= ';
        if(operator == 'includes')
        {
            sQueryString += AppUtil2.getValueList(srchValue,',');
        }
        else if(operator!='does not contain')
            sQueryString += srchValue;          
        return sQueryString;
    }
   
   /*public static String queryForNumbers(String field,String operator,String srchValue, Schema.DisplayType sDisplayType){
    String sQueryString = '';
    srchValue = srchValue.trim();
    if(sDisplayType==Schema.DisplayType.DATE){
    if((srchValue.toLowerCase().startsWith('this') || srchValue.toLowerCase().startsWith('last') || srchValue.toLowerCase().startsWith('next'))){
    srchValue = srchValue.trim();
    String[] dateFormat = srchValue.split(' ');
    try{
    Integer n = Integer.ValueOf(dateFormat[1]);
    srchValue = srchValue.replace(dateFormat[1],'n');
    srchValue = srchValue.replace(' ','_');
    srchValue += ':'+n;
    }
    catch(Exception e){
    srchValue = srchValue.replace(' ','_');
    }
    }
    else if(srchValue!='today' && srchValue!='tomorrow' && srchValue!='yesterday'){
    String[] tempVal = srchValue.split('/');
    srchValue = tempVal[2]+'-';
    if(tempVal[0].length()==1)
    srchValue += '0'+tempVal[0]+'-';
    else
    srchValue += tempVal[0]+'-';
    if(tempVal[1].length()==1)
    srchValue += '0'+tempVal[1];
    else
    srchValue += tempVal[1];
    }
    }
               
    if(operator=='equals')
    sQueryString = ' and '+field+' = '+srchValue;
    else if(operator=='not equal to')
    sQueryString = ' and '+field+' <> '+srchValue;
    else if(operator=='less than')
    sQueryString = ' and '+field+' < '+srchValue;
    else if(operator=='greater than')
    sQueryString = ' and '+field+' > '+srchValue;
    else if(operator=='less or equal')
    sQueryString = ' and '+field+' <= '+srchValue;
    else if(operator=='greater or equal')
    sQueryString = ' and '+field+' >= '+srchValue;
    return sQueryString;
    }


    
public static String queryForDateTime(String field,String operator,String srchValue, List<String> tempConList2, Integer counter){
          String sQueryString = '';
          DateTime dtField1,dtField2;
          DateTime dummy1,dummy2;
          Boolean flag = false;
          try{
          if(srchValue.contains('AM') || srchValue.contains('PM')){
          String[] tempVal1 = srchValue.split(' ');
          String[] tempVal = tempVal1[0].split('/');
          Integer x1,x2,x3,y1,y2,y3;
          x1 = Integer.valueof(tempVal[1]);
          x2 = Integer.valueof(tempVal[0]);
          x3 = Integer.valueof(tempVal[2]);
          String[] timeStr = tempVal1[1].split(':');
          y1 = Integer.valueof(timeStr[0]);
          y2 = Integer.valueof(timeStr[1]);
          if(operator=='less than' || operator=='greater or equal' || operator=='equals' || operator=='not equal to')
          y3 = 0;
          else if(operator=='greater than' || operator=='less or equal')
          y3 = 59;
          if(srchValue.contains('PM'))
          y1 += 12;
          if(counter==1){
          dtField1 = DateTime.newInstance(x3,x2,x1,y1,y2,y3);
          dummy1 = dtField1.addSeconds(60);}
          if(counter==2){
          dtField2 = DateTime.newInstance(x3,x2,x1,y1,y2,y3);
          dummy2 = dtField2.addSeconds(60);}
          
         
          }
          else{
          if(srchValue.toLowerCase().startsWith('this') || srchValue.toLowerCase().startsWith('last') || srchValue.toLowerCase().startsWith('next') || srchValue=='today' || srchValue=='tomorrow' || srchValue=='yesterday'){
          flag = true;
          srchValue = srchValue.trim();
          String[] dateFormat = srchValue.split(' ');
          try{
          Integer n = Integer.ValueOf(dateFormat[1]);
          srchValue = srchValue.replace(dateFormat[1],'n');
          srchValue = srchValue.replace(' ','_');
          srchValue += ':'+n;
          }
          catch(Exception e){
          srchValue = srchValue.replace(' ','_');
          }
          }
          else{
          String[] tempVal = srchValue.split('/');
          srchValue = tempVal[2]+'-';
          if(tempVal[0].length()==1)
          srchValue += '0'+tempVal[0]+'-';
          else
          srchValue += tempVal[0]+'-';
          if(tempVal[1].length()==1)
          srchValue += '0'+tempVal[1];
          else
          srchValue += tempVal[1];
          
          if(operator=='greater than' || operator=='less or equal')
          srchValue += ' 23:59:59';
          else if(operator=='less than' || operator=='greater or equal' || operator=='equals' || operator=='not equal to')
          srchValue += ' 00:00:00';
          
          if(counter==1){
          dtField1 = DateTime.ValueOf(srchValue);
          dummy1 = dtField1.addHours(24);}
          if(counter==2){
          dtField2 = DateTime.ValueOfGmt(srchValue);
          dummy2 = dtField2.addHours(24);}
          
         
          }
          }
          if(flag){
          if(operator=='equals')
          sQueryString = ' and '+field+' = '+srchValue;
          else if(operator=='not equal to')
          sQueryString = ' and '+field+' <> '+srchValue;
          else if(operator=='less than')
          sQueryString = ' and '+field+' < '+srchValue;
          else if(operator=='greater than')
          sQueryString = ' and '+field+' > '+srchValue;
          else if(operator=='less or equal')
          sQueryString = ' and '+field+' <= '+srchValue;
          else if(operator=='greater or equal')
          sQueryString = ' and '+field+' >= '+srchValue;
          }
          else{
          if(operator=='equals')
          sQueryString = ' and '+field+' >= :dtField'+counter+' and '+field+' <= :dummy'+counter;
          if(operator=='not equal to'){
          Contact[] tempCon = Database.query('Select id from Opportunity where '+field+' >= :dtField'+counter+' and '+field+' <= :dummy'+counter);
          tempConList2 = new List<String>();
          for(Integer i=0;i<tempCon.size();i++)
          tempConList2.add(tempCon[i].id);
          sQueryString = ' and id not in :tempConList2';
          }
          if(operator=='greater than')
          sQueryString = ' and '+field+' > :dtField'+counter;
          else if(operator=='less or equal')
          sQueryString = ' and '+field+' <= :dtField'+counter;
          else if(operator=='less than')
          sQueryString = ' and '+field+' < :dtField'+counter;
          else if(operator=='greater or equal')
          sQueryString = ' and '+field+' >= :dtField'+counter;
          }
          }
          catch(Exception e){
          return sQueryString;
          }
          return sQueryString;
          }*/
}