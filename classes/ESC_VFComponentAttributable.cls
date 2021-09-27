public interface ESC_VFComponentAttributable {
List<string>  getIapiNames();
List<string>  getIapiNamesMissedMileStoneCalculatedFields();   
Map<string, Object> getICalculateFieldsMap();           
string getIobjectName();                
string getIblockName();   
string getIblockLocalName();
Boolean  getIshowAccept();  
Boolean  getIshowApproval();             
Boolean getISortASC();
string getIpushTopicName();             
string getIOwnerInfo();   
integer getIsortDefCol();
integer getIHideColumn();
 List<string> getIownerIdentifiers();   
Boolean getIisUserBlock();    
Boolean getIisFirstHidden();  
Boolean getIisQueueBlock();             
Boolean getIisPaginationEnabled();
Boolean getIHasToShowAccept();
List<SObject> getIsecondaryResultObj();
string getIoverRideNames();             
List<string> getIapiNoTruncate();       
string getIfullQuery();                 
 List<SObject> getIresultObj();         
Map<string, string> getIapiNamesMap();  
string getIobjectPrefix();              
List<Integer> getInonTruncateColumns(); 
 List<string> getItruncateColumnsSize();
Map<string,string> getIColumnsDimensions();
string getIstyleclass();                
Map<string,Boolean> getIvisibilityList(); 
           
}