global class  ODT_Pagination implements Iterator<list<ODT_TrialReInitiate.contactsWrapper>>
{ 
   list<ODT_TrialReInitiate.contactsWrapper> InnerList{get; set;}
   list<ODT_TrialReInitiate.contactsWrapper> ListRequested{get; set;}

   Integer i {get; set;} 
   public Integer setPageSize {get; set;} 

   public ODT_Pagination (List<ODT_TrialReInitiate.contactsWrapper> lstAccWr)
   {
       InnerList = new list<ODT_TrialReInitiate.contactsWrapper>(); 
       ListRequested = new list<ODT_TrialReInitiate.contactsWrapper>();     
       InnerList = lstAccWr;
       setPageSize = 10;
       i = 0; 
   }   

   global boolean hasNext(){ 
       if(i >= InnerList.size()) {
           return false; 
       } else {
           return true; 
       }
   } 
   
   global boolean hasPrevious(){ 
       system.debug('I am in hasPrevious' + i);
       if(i <= setPageSize) {
           return false; 
       } else {
           return true; 
       }
   }   

   global list<ODT_TrialReInitiate.contactsWrapper> next(){       
       system.debug('i value is ' + i);
       ListRequested = new list<ODT_TrialReInitiate.contactsWrapper>(); 
       integer startNumber;
       integer size = InnerList.size();
       if(hasNext())
       {  
           if(size <= (i + setPageSize))
           {
               startNumber = i;
               i = size;
           }
           else
           {
               i = (i + setPageSize);
               startNumber = (i - setPageSize);
           }
           
           system.debug('i value is =====' + i);
           system.debug('i value is 2==== ' + (i - setPageSize));
           
           for(integer start = startNumber; start < i; start++)
           {
               ListRequested.add(InnerList[start]);
           }
       } 
       return ListRequested;
   } 
   
   global list<ODT_TrialReInitiate.contactsWrapper> previous(){      
       ListRequested = new list<ODT_TrialReInitiate.contactsWrapper>(); 
       system.debug('i value is previous before =====' + i);
       integer size = InnerList.size(); 
       if(i == size)
       {
           if(math.mod(size, setPageSize) > 0)
           {    
               i = size - math.mod(size, setPageSize);
           }
           else
           {
               i = (size - setPageSize);
           } 
       }
       else
       {
           i = (i - setPageSize);
       }
       
       system.debug('i value is previous =====' + i);
       system.debug('i value is 2previous ==== ' + (i - setPageSize));
       
       for(integer start = (i - setPageSize); start < i; ++start)
       {
           ListRequested.add(InnerList[start]);
       } 
       return ListRequested;
   }   
}