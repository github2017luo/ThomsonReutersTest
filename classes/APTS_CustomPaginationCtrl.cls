/**
* Class for the implementing pagination on OnlineContacts.Page that extends the 
* implements Iterator 
*
* @author  TCS
* @version 2020-06-19
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2020-06-19   Poonam Garg             Created 
* =============================================================================
*/
public class  APTS_CustomPaginationCtrl implements Iterator<list<OnlineContactsController.APLIWrapper>>
{ 
   list<OnlineContactsController.APLIWrapper> InnerList{get; set;}
   list<OnlineContactsController.APLIWrapper> ListRequested{get; set;}

   Integer i {get; set;} 
   public Integer setPageSize {get; set;} 
   

   public APTS_CustomPaginationCtrl (List<OnlineContactsController.APLIWrapper> lstAccWr)
   {
       InnerList = new list<OnlineContactsController.APLIWrapper>(); 
       ListRequested = new list<OnlineContactsController.APLIWrapper>();     
       InnerList = lstAccWr;
       setPageSize = 100;
       i = 0; 
   }   

   public boolean hasNext(){ 
       system.debug('I am in hasNext' + i);
       system.debug('InnerList.size()' + InnerList.size());
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
           System.debug('show previous');
           return true; 
       }
   }   

   public list<OnlineContactsController.APLIWrapper> next(){ 
           
       system.debug('i value is ' + i);
       ListRequested = new list<OnlineContactsController.APLIWrapper>(); 
       integer startNumber;
       integer size = InnerList.size();
       System.debug('sizeOfList'+ size);
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
       System.debug(ListRequested.size());
       return ListRequested;
   } 
   
   public list<OnlineContactsController.APLIWrapper> previous(Integer pageNum){  
       /*Set<Integer> setPageNums =new Set<Integer>{10,20,30,40,50,60,70,80,90};
       if(setPageNums .contains(pageNum)){
           i=InnerList.size() + setPageSize;
       }*/
       integer startNumber=0;    
       ListRequested = new list<OnlineContactsController.APLIWrapper>();  
       system.debug('i value is previous before =====' + i); //200
       //i=i+1;
       integer size = InnerList.size();   //1241
       System.debug('sizeOfList'+ size);
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
           i = (i - setPageSize) ; // 199-100=99 ---i
           
       }
       
       system.debug('i value is previous =====' + i);//99 + 1=100
       system.debug('i value is 2previous ==== ' + (i - setPageSize)); //100-100=0
       
       for(integer start = (i - setPageSize); start < i  ; ++start)
       {
           ListRequested.add(InnerList[start]);
       }  
       return ListRequested;
   }
   public list<OnlineContactsController.APLIWrapper> OnclickDigit(Integer pageNo){ 
       ListRequested = new list<OnlineContactsController.APLIWrapper>(); 
       system.debug('i value is =====' + i);
       integer size = InnerList.size(); 
       System.debug('sizeOfList'+ size);
       Integer startno=0;
       if( size<=pageNo*setPagesize){
           startno=pageNo*setPagesize- setpagesize;
           i=size ; //
        }   
        else{
            i=pageNo*setPagesize;
            startno=pageNo*setPagesize- setpagesize;
        }   
       system.debug('i value is previous =====' + i);
       system.debug('i value is 2previous ==== '+startno);
       
       for(integer start = startNo; start < i; ++start)
       {
           ListRequested.add(InnerList[start]);
       } 
       return ListRequested;
   }    
   public list<OnlineContactsController.APLIWrapper> addOnlineContacts(Integer addRec){ 
       ListRequested = new list<OnlineContactsController.APLIWrapper>(); // To return
       system.debug('i value is =====' + i);
       integer size = InnerList.size(); //total rec on the list
       System.debug('sizeOfList'+ size);
       Integer startno=0;
       //Check if size of list < page size i.e size is less than or equal to 100
       if(size<=setPageSize){
            startNo=0;
            i=size;
           System.debug('Size is less than 100');
        }
        // if size is more than 100
        else{
            Integer pageNo=(size-addrec)/setPageSize+ 1;
            startNo=(pageNo - 1)*setPageSize;
            // find i
            if((size-startNo)> setPageSize){
                i=pageNo * setPageSize;
            }
            else{
                i=size;
            }
        }
        system.debug('i value is previous =====' + i);
        system.debug('i value is 2previous ==== '+startno);
        for(Integer start=startno; start< i ; start ++){
                ListRequested.add(InnerList[start]);
            }
       
             
       return ListRequested;
   }     
}