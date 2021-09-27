/**
 * Provides specific helper methods for pagination
 *
 * @author  Srikanth Kuruva
 * @version 2012-05-15
 */
public class CustomSetController
{
    private List<Object> liObject{get; set;}
    private Integer liObjectSize{get; set;}
    private Integer iPageSize{get; set;}
    private Boolean bHasNext{get; set;}
    private Boolean bHasPrevious{get; set;}
    private Integer iCurrentPageNumber{get; set;}
    private Integer iTotalPages{get; set;}
    
    //public List<Object> CurrentRecordList{get; set;}
    
    public CustomSetController(List<Object> liObj, Integer iSize)
    {
        iPageSize = iSize;
        this.liObject = liObj;
        liObjectSize  = liObj.size();
        iCurrentPageNumber = 1;
        iTotalPages = Integer.valueof(Math.ceil((double)liObjectSize/(double)iPageSize));
        setHasNextHasPreviousValues();
        getCurrentRecordList();        
    }
    
    private void setHasNextHasPreviousValues()
    {
        
        system.debug('liObjectSize:'+liObjectSize);
        system.debug('iCurrentPageNumber:'+iCurrentPageNumber);
        system.debug('iTotalPages:'+iTotalPages);
        bHasNext = false;
        bHasPrevious = false;
        if(liObjectSize != 0) 
        {
            if(iCurrentPageNumber != 1)
            {
                bHasPrevious = true;
            }
            if(iCurrentPageNumber != iTotalPages)
            {
                bHasNext = true;
            }
        }
    }
    public List<object> Next()
    {
        iCurrentPageNumber++;
        setHasNextHasPreviousValues();
        return getCurrentRecordList();
    }    
    public List<object> Previous()
    {
        iCurrentPageNumber--;
        setHasNextHasPreviousValues();
        return getCurrentRecordList();
    }
    public Boolean gethasNext()
    {
        return bHasNext;
    }
    public Boolean gethasPrevious()
    {
        return bHasPrevious;
    }
    public List<Object> getCurrentRecordList()
    {
        List<Object> liTempObject = new List<Object>();
        Integer iStartIndex = (iCurrentPageNumber-1)*iPageSize;
        Integer iLastIndex = Math.min(iCurrentPageNumber*iPageSize,liObjectSize);
        for(Integer iCounter = iStartIndex; iCounter < iLastIndex; iCounter++)
        {
                liTempObject.add(liObject.get(iCounter));
        }
        return liTempObject;
    }
    public List<Object> getAllRecords()
    {
        return liObject;
    }    
}