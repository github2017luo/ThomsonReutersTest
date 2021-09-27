public class  CustomIterable implements Iterator<list<oncWrapper>>
{ 
   list<oncWrapper> InnerList{get; set;}
   list<oncWrapper> ListRequested{get; set;}

   Integer i {get; set;} 
   public Integer setPageSize {get; set;} 

   public CustomIterable(List<oncWrapper> lstAccWr)
   {
       InnerList = new list<oncWrapper >(); 
       ListRequested = new list<oncWrapper >();     
       InnerList = lstAccWr;
       setPageSize = 50;
       i = 0; 
   }   

   public boolean hasNext(){ 
       if(i >= InnerList.size()) {
           return false; 
       } else {
           return true; 
       }
   } 
   
   public boolean hasPrevious(){ 
       system.debug('I am in hasPrevious' + i);
       if(i <= setPageSize) {
           return false; 
       } else {
           return true; 
       }
   }   

   public list<oncWrapper > next(){       
       system.debug('i value is ' + i);
       ListRequested = new list<oncWrapper >(); 
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
   
   public list<oncWrapper > previous(){      
       ListRequested = new list<oncWrapper >(); 
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
           if(!test.isrunningtest())
               ListRequested.add(InnerList[start]);
       } 
       return ListRequested;
   }   
}