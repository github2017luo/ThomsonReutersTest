public class ManageTopics
{
    public String sSelectedField5 {get;set;}
    public String sSelectedField6 {get;set;}
    public String sSelectedField7 {get;set;}
    public String sSelectedField8 {get;set;}
    
    public String sSelectedOperator5 {get;set;} 
    public String sSelectedOperator6 {get;set;}
    public String sSelectedOperator7 {get;set;} 
    public String sSelectedOperator8 {get;set;}
    
    public String sSearchValue5 {get;set;} 
    public String sSearchValue6 {get;set;}
    public String sSearchValue7 {get;set;} 
    public String sSearchValue8 {get;set;}
    
    public List<String> listTrainingTopicFields = new List<String>();
    public List<tTrainingTopic> listMatchingTopics {get;set;}
    public List<Training_Topic__c> listSelectedTopicsAll {get;set;}
    public Map<Id, Contact> mapSelectedTopics {get;set;}
    public Boolean bMatchesFound {get; set;}
    public Boolean bSelectedTopics {get; set;}
    public Boolean bDoneAddingTopics {get; set;}
    
    public Map<String,string> mapFields = new Map<string,string>();
    public Map<String,string> mapNameKey = new Map<string,string>();
    public Map<String,Schema.DisplayType> mapfieldsAndTypes = new Map<String,Schema.DisplayType>();
    public List<SelectOption> listOperatorFields = new List<SelectOption>();
    public List<SelectOption> listCategories = new List<SelectOption>();
    
    Integer counter;
    List<String> tempList1 = new List<String>();
    List<String> tempList2 = new List<String>();
    
    public Id TrainingEventId = System.currentPageReference().getParameters().get('id');
    public String TECIds = System.currentPageReference().getParameters().get('TECIds');
    
    public class tTrainingTopic
    {
        public Training_Topic__c tTrainingTopic{get;set;}
        public Boolean bSelected{get;set;}        
        
        public tTrainingTopic(Training_Topic__c tt)
        {
            tTrainingTopic = tt;
            bSelected = false;
        }
    }
    
    public ManageTopics(ApexPages.StandardController controller)
    {
        bMatchesFound = false;        
        mapFields = AppUtil2.getFieldNameList('Training_Topic__c', mapFields, mapNameKey, mapfieldsAndTypes);
		sSelectedField5 = 'Category';
		sSelectedOperator5 = 'contains';
        for (String sField : mapNameKey.Values())
        {
            if(sField == 'Topic')
            {
                listTrainingTopicFields.add(sField);
            }
        }
    }
    
    public List<SelectOption> getlistTrainingTopicFields()
    {
        List<SelectOption> listFieldOptions = new List<SelectOption>();
        listFieldOptions.add(new SelectOption('--None--','--None--'));
        for(Integer i=0;i<listTrainingTopicFields.size();i++)
        {
            listFieldOptions.add(new SelectOption(listTrainingTopicFields[i],listTrainingTopicFields[i]));
        }
        return listFieldOptions;
    }
    
    public list<SelectOption> getlistOperatorFields(){
       //listOperatorFields = AppUtil2.populateOperators(mapfieldsAndTypes.get(sSelectedField5));
       listOperatorFields = AppUtil2.populateOperators(Schema.DisplayType.STRING);
       return listOperatorFields;
    }
    
    public list<SelectOption> getlistCategories(){
    	listCategories.add(new SelectOption('%','--All--'));
       for(AggregateResult ar : [select Category__c from Training_Topic__c group by Category__c])
       {
       		String category = (String)ar.get('Category__c');
			listCategories.add(new SelectOption(category,category));
       }       
       return listCategories;
    }
    
    /*public void getSelectedTopics()
    {
        mapSelectedTopics = new Map<Id, Training_Topic__c>();
        List<Id> listTrainingTopicIds = new List<Id>();
        for(Training_Event_Topic__c TrainingEventTopic : [SELECT Id, Contact_Name__c FROM Training_Event_Topic__c where Training_Event__c = :TrainingEventId])
        {
            listContactIds.add(TrainingEventTopic.);
        }
        
        if(!listContactIds.isEmpty())
        {
            mapSelectedContacts = new Map<Id, Contact>([SELECT Id, Name, FirstName, LastName, SAP_Account_Number__c FROM Contact where Id in :listContactIds]);
        }       
    }*/
    
    public pageReference findResults()
    {
        bMatchesFound = true;
        listMatchingTopics = new List<tTrainingTopic>();
        String sQueryString = 'SELECT Id, Topic__c, Name, Category__c FROM Training_Topic__c where CreatedDate <> null ';        
        if(sSearchValue5!=null && sSearchValue5!='' && sSelectedField5!='--None--')
        {
            counter = 1;
            sQueryString += AppUtil2.queryForText(mapFields.get(sSelectedField5),sSelectedOperator5,sSearchValue5);
        }   
          
        if(sSearchValue6!=null && sSearchValue6!='' && sSelectedField6!='--None--')
        {
            counter = 2;
            sQueryString += AppUtil2.queryForText(mapFields.get(sSelectedField6),sSelectedOperator6,sSearchValue6);
        }
        if(listSelectedTopicsAll != null)
        	sQueryString += ' and Id not in :listSelectedTopicsAll ';  
        sQueryString += ' order by Name';
        if(counter == 1 || counter == 2)
        {
	        Training_Topic__c[] templistMatchingTopics = Database.query(sQueryString);
	        for(Training_Topic__c ttempTopic : templistMatchingTopics)
	        {
	            listMatchingTopics.add(new tTrainingTopic(ttempTopic));
	        }
        }
        return null;
    }
    
    public pageReference AddTopicstoTraining()
    {
    	List<Training_Topic__c> listSelectedTopics = new List<Training_Topic__c>();
        //if(listSelectedTopicsAll == null)
        	//listSelectedTopicsAll = new List<Training_Topic__c>();
    	bDoneAddingTopics = true;
        for(tTrainingTopic tt : listMatchingTopics) 
        {
            if(tt.bSelected == true) 
            {
                listSelectedTopics.add(tt.tTrainingTopic);
            }
        }
        if(!listSelectedTopics.isEmpty())
        {
        	if(listSelectedTopicsAll == null)
        		listSelectedTopicsAll = new List<Training_Topic__c>();
        	listSelectedTopicsAll.addAll(listSelectedTopics);
	    	List<Training_Event_Topic__c> listTrainingEventTopics = new List<Training_Event_Topic__c>();            
	        Training_Event_Topic__c TrainingEventTopic;        
	        
	        for(Training_Topic__c tt : listSelectedTopics)
	        {
	        	for(String s : TECIds.split(','))
	        	{
	        		if (s!= '' && s != null)
	        		{
		            	TrainingEventTopic = new Training_Event_Topic__c();
			            TrainingEventTopic.Training_Topic__c = tt.Id;
			            TrainingEventTopic.Training_Event_Contact__c = (Id)s; 
			            listTrainingEventTopics.add(TrainingEventTopic);
	        		}
	        	}
	        }
	        //system.debug(listTrainingEventTopics);
			insert listTrainingEventTopics;
        }
    	return null;
    }
    public pageReference enterSelectedTopicsTab()
    {
    	bMatchesFound = false;
        bSelectedTopics = true;
    	return null;
    }
    public pageReference enterAddTopicsTab()
    {
    	bMatchesFound = true;
        bSelectedTopics = false;
    	return findResults();
    }
    public pageReference searchSelectedTopics()
    {
        //
        return null;
    }
}