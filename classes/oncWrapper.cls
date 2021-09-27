public class oncWrapper implements comparable{
        public Boolean isSelected {get; set;}        
        public string materialNo {get; set;}
        public string assetNo {get; set;}
        public Online_Contacts__c onlineContact {get; set;}  
        public Boolean isNewContact {get; set;}
        public string Action {get; set;}
        public string PrevAction {get; set;}
        public string prevEmail {get; set;}
        public Boolean eventIdToDelete{get;set;}
        public Boolean eventIdToEdit{get;set;}
        public Boolean evnetIdToAdd{get;set;}
        public Boolean eventIdToUndo{get;set;}
        public enum SORT_BY {
                FirstName,LastName,Email
        }
        
       
    //Variable to decide the member on which sorting should be performed
    public static SORT_BY sortBy = SORT_BY.FirstName;
        public oncWrapper(){
            isSelected = False;
            materialNo = '';
            assetNo = '';
            PrevAction='';
            isNewContact = False;
            eventIdToEdit= False;
            eventIdToDelete = False;
            evnetIdToAdd = False;
            eventIdToUndo = False;
            onlineContact = new Online_Contacts__c();
        }
        public Integer compareTo(Object compareTo) 
    {
        oncWrapper oncWrapper = (oncWrapper) compareTo;
        if (onlineContact.First_Name__c == oncWrapper.onlineContact.First_Name__c) return 0;
        if (onlineContact.First_Name__c > oncWrapper.onlineContact.First_Name__c) return 1;
        return -1;        
    }
    
    /*public Integer compareTo(Object objToCompare) {
        oncWrapper oncWrapper = (oncWrapper) objToCompare;
        if(sortBy == SORT_BY.FirstName )
        {
            return onlineContact.First_Name__c.compareTo(oncWrapper.onlineContact.First_Name__c);
        }
        else if(sortBy == SORT_BY.LastName)
        {
            return onlineContact.Last_Name__c.compareTo(oncWrapper.onlineContact.Last_Name__c);
        }
        else if(sortBy == SORT_BY.Email)
        {
         return onlineContact.Email__c.compareTo(oncWrapper.onlineContact.Email__c);
        }
        return -1;   
    }*/
    }