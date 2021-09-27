public class ObjectDataViewerController{

    public String objectType{get;set;}
    public String identifier{get;set;}
    public sObject thissObject{get; set;}
    public List<SelectOption> sObjectTypes{get;set;}
    public List<SelectOption> recOptions{get;set;}
    public Id multiOption{get;set;}
    private Map<String, Schema.SObjectField> objectFields;
    private List<sObject> multiResults;
    
    public Id getThissObjectId(){
        return thissObject == null?null: (Id)thissObject.get('Id');
    }

    public boolean getHasResults(){
        return thissObject!=null;
    }

    public boolean getHasMultiResults(){
        return (multiResults != null && (multiResults.size()>1));
    }

    public String getFieldName(){
    
        if('Case'.equalsIgnoreCase(objectType))
            return 'Case Number';
        if('Contact'.equalsIgnoreCase(objectType))
            return 'Contact Name';
        if('Account'.equalsIgnoreCase(objectType))
            return 'Account Name';
        return null;   
    }
    
    public void resetForm(){
        thissObject = null;
        multiResults = null;
    }
    
    public ObjectDataViewerController(){
        
        sObjectTypes = new List<SelectOption>();
        sObjectTypes.add(new SelectOption('Case','Case'));
        sObjectTypes.add(new SelectOption('Account','Account'));
        sObjectTypes.add(new SelectOption('Contact','Contact'));
        objectType='Case';
    }
    
    public PageReference getDetails(){

        multiResults = database.query(getSOQL());
        if(multiResults != null){
            if(multiResults.size() == 1)
                thissObject = multiResults[0];
            else{
                recOptions = new List<Selectoption>();
                recOptions.add(new SelectOption('', ' - Select One -'));
                for(sObject o: multiresults){
                    recOptions.add(new SelectOption((String)o.get('Id'), (String)o.get('Name')));
                }
            }
        }
        return null;
    }
    
    public void setResults(){
    
        if(multiOption == null) return;
        system.debug(multiOption);
        for(sObject o: multiresults)
            if((Id)o.get('Id') == multiOption){
                thisSobject = o;
                break;
            }
        system.debug(thissObject);
    }
    
    public Component.Apex.PageBlockSection getDetailedFieldInformation(){
    
        if(thissObject == null)
            return null;
        Component.Apex.PageBlockSection pbSection = new Component.Apex.PageBlockSection();
        pbSection.title = 'All Fields';
        pbSection.collapsible = true;
        pbSection.columns = 2;
        pbSection.showHeader = true;
        
        for(String s : objectFields.keySet()){
            //if(Schema.DisplayType.address.name().equalsIgnoreCase(objectFields.get(s).getDescribe().getType().name())) continue;
            if(Schema.DisplayType.address == objectFields.get(s).getDescribe().getType()) continue;
            Component.Apex.PageBlockSectionItem pbsi = new Component.Apex.PageBlockSectionItem();
            Component.Apex.OutputText olbl = new Component.Apex.OutputText();
            olbl.value = '<b>'+objectFields.get(s).getDescribe().getLabel()+' ('+s+')</b>';
            olbl.escape=false;
            pbsi.childComponents.add(olbl);
            Component.Apex.OutputField opfld = new Component.Apex.OutputField();
            opfld.expressions.value = '{!thissObject.'+s+'}';
            pbsi.childComponents.add(opfld);
            pbSection.childComponents.add(pbsi);
        }
        return pbSection;
    }
    
    private String getSOQL(){
    
        objectFields = Schema.getGlobalDescribe().get(objectType).getDescribe().fields.getMap();
        String fieldAPIs = '';
        for(String s : objectFields.keySet())
           fieldAPIs += ' ,' + s;
        fieldAPIs = fieldAPIs.substring(2);
        String query = 'select '+fieldAPIs;
        query+=' from ' + objectType;
        query+=' where ' + getKeyField() + ' = \'' + identifier + '\'';
        return query;
    }
    
    private String getKeyField(){
    
        if('Case'.equalsIgnoreCase(objectType))
            return 'CaseNumber';
        if('Contact'.equalsIgnoreCase(objectType))
            return 'Name';
        if('Account'.equalsIgnoreCase(objectType))
            return 'Name';
        return null;
    }
}