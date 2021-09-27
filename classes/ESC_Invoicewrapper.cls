/**
     * @description Justdesc
     * 
     */
public without sharing class ESC_Invoicewrapper{
    
    public list<list<ESC_InvoiceListWrapper.openwrapper>> openwrapperlist1;
    public List<list<ESC_InvoiceListWrapper.clearedwrapper>> clearwrapperlist1 ;
    /**
     * @description Justdesc
     * @return Justdesc
     */
    public Date begindt{get;set;}  
    /**
     * @description Justdesc
     * @return Justdesc
     */  
    public Date enddt{get;set;}
    /**
     * @description Justdesc
     * @return Justdesc
     */
    public boolean isSuccess {get;set;}
    /**
     * @description Justdesc
     * @return Justdesc
     */
    public Paginate paginater {get;set;}
    /**
     * @description Justdesc
     * @return Justdesc
     */
    public Paginate clearpaginater {get;set;}
    /**
     * @description Justdesc
     * 
     */
    public ESC_Invoicewrapper(){
        clearwrapperlist1 = new List<list<ESC_InvoiceListWrapper.clearedwrapper>>();
        openwrapperlist1 = new list<list<ESC_InvoiceListWrapper.openwrapper>>();    
        system.debug(LoggingLevel.WARN,'begin and end date is'+begindt+'***'+enddt );
    }
    /**
     * @description Justdesc
     * @param oResponseopenlist
     * @param pageSize
     * @return just
     */
    public ESC_Invoicehelper.Openinvpagiwrapper populateOpenlist(list<USLARWrapper.openedItems> oResponseopenlist,integer pageSize){
        list<ESC_InvoiceListWrapper.openwrapper> openwrapperlist = new list<ESC_InvoiceListWrapper.openwrapper>();
        list<ESC_InvoiceListWrapper.openwrapper> openwrapperlist2 = new list<ESC_InvoiceListWrapper.openwrapper>();
        list<list<ESC_InvoiceListWrapper.openwrapper>> openwrapperlist1 = new list<list<ESC_InvoiceListWrapper.openwrapper>>();
        if(OResponseopenlist != null && OResponseopenlist.size() > 0){
            this.paginater = new Paginate(OResponseopenlist.size(), pageSize);                                
            for(USLARWrapper.openedItems open:OResponseopenlist){                                                
                openwrapperlist.add(new ESC_InvoiceListWrapper.openwrapper(false,open));                                                                
            }                
        }
        if(!openwrapperlist.IsEmpty()){
            List<ESC_InvoiceListWrapper.openwrapper> tempop = new List<ESC_InvoiceListWrapper.openwrapper>();
            Integer i = 0;
            for(ESC_InvoiceListWrapper.openwrapper opwrap : openwrapperlist){
                tempop.add(opwrap);
                i++;
                 if(i == pageSize){
                     openwrapperlist1.add(tempop);
                     tempop = new List<ESC_InvoiceListWrapper.openwrapper>();
                     i = 0;
                 }
            }
            if(!tempop.isEmpty()){
                openwrapperlist1.add(tempop);
            }
            openwrapperlist2 = openwrapperlist1.get(paginater.index);
        }
        ESC_Invoicehelper.Openinvpagiwrapper oppagwrap = new ESC_Invoicehelper.Openinvpagiwrapper(openwrapperlist2,paginater,openwrapperlist1);
        return oppagwrap;
    }
    /**
     * @description Justdesc
     * @param oResponseclearlist
     * @param pageSize
     * @return just
     */
    public ESC_Invoicehelper.Clearinvpagiwrapper  populateClearlist(List<USLARWrapper.clearedItems> oResponseclearlist,integer pageSize){
        list<ESC_InvoiceListWrapper.clearedwrapper> clearwrapperlist = new list<ESC_InvoiceListWrapper.clearedwrapper>();
        List<list<ESC_InvoiceListWrapper.clearedwrapper>> clearwrapperlist1 = new List<list<ESC_InvoiceListWrapper.clearedwrapper>>();
        list<ESC_InvoiceListWrapper.clearedwrapper> clearwrapperlist2 = new list<ESC_InvoiceListWrapper.clearedwrapper>();
        if(OResponseclearlist!=null && OResponseclearlist.size() > 0 ){                    
            this.clearpaginater = new Paginate(OResponseclearlist.size(), pageSize);
            for(USLARWrapper.clearedItems clear:OResponseclearlist){                        
                clearwrapperlist.add(new ESC_InvoiceListWrapper.clearedwrapper(false,clear)); 
                                                                                      
            }
            
            
        } 
        if(!clearwrapperlist.IsEmpty()){
            List<ESC_InvoiceListWrapper.clearedwrapper> tempop = new List<ESC_InvoiceListWrapper.clearedwrapper>();
            Integer i = 0;
            for(ESC_InvoiceListWrapper.clearedwrapper clwrap : clearwrapperlist){
                tempop.add(clwrap);
                i++;
                 if(i == pageSize){
                     clearwrapperlist1.add(tempop);
                     tempop = new List<ESC_InvoiceListWrapper.clearedwrapper>();
                     i = 0;
                 }
            }
            if(!tempop.isEmpty()){
                clearwrapperlist1.add(tempop);
            }
            clearwrapperlist2 = clearwrapperlist1.get(clearpaginater.index);
        }
        ESC_Invoicehelper.Clearinvpagiwrapper pagiwrap = new ESC_Invoicehelper.Clearinvpagiwrapper (clearwrapperlist2,clearpaginater,clearwrapperlist1);
        return pagiwrap;
    }
    
    
}