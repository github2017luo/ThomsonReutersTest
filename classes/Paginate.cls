/*
@Author: Radhika Pawar
@JIRA Story: CRM-6978
@Purpose: This Page is used for Displying pagination information for Credential and IP Address Restriction Webservices Response. 
@Version: 2017-10-16

* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
*                                                         
* =============================================================================

*/
/**This Paginate Class is the class that keeps track of all the pagination information */
public class Paginate {
    public Integer index {get;set;}
    public Integer pageNum {get;set;}
    public Integer totalPage {get;set;}
    public Integer totalResults {get;set;}
    public List<Pager> pageList {get;set;}
    public Boolean showPrevious {get;set;}
    public Boolean showNext {get;set;}
    public Boolean isAll {get;set;}
        
    public Paginate(Integer listSize, Integer pageSize){
        this.totalResults = listSize;
        System.debug('totalResults:-'+totalResults);
        pageSize = (pageSize > 0)?pageSize:10;
        System.debug('pageSize :-'+pageSize );
        this.totalPage = (Integer)Math.ceil((Double)listSize / (Double)pageSize);
        System.debug('totalPage :-'+totalPage );
        this.pageNum = 1;
        this.index = 0;
        this.isAll = (listSize == pageSize)?true:false;
        updateNumbers();
    }
    
    public void updateNumbers(){
        System.debug('**updateNumbers**');
        this.pageList = new List<Pager>();
        System.debug('this.totalPage:-'+this.totalPage);
        for(Integer i = 1; i < (this.totalPage + 1); i++){
            Boolean b = (i == pageNum)?true:false;
            this.pageList.add(new Pager(i, b));
        }
        System.debug('this.pageList:-'+this.pageList);
        this.showPrevious = (this.pageNum == 1)?false:true;
        this.showNext = (this.pageNum == this.totalPage)?false:true;
        this.index = this.pageNum - 1;
        System.debug('this.showPrevious:-'+this.showPrevious);
        System.debug('this.showNext :-'+this.showNext );
        System.debug('this.index:-'+this.index);
    }
        
    public void decrement(){
    System.debug('**decrement**');
        this.pageNum = this.pageNum - 1;
        updateNumbers();
    }
    
    public void increment(){
    System.debug('**increment**');
        this.pageNum++;
        updateNumbers();
    }

    public class Pager{
        public Integer pageNum {get;set;}
        public Boolean isActive {get;set;}
        
        public Pager(Integer num, Boolean active){
            this.pageNum = num;
            this.isActive = active;
        }
    }
}