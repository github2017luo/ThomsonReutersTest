/**
* {Purpose} – 
*     Visualforce controller to fetch colleagues information from ContactNet for a given contact.
*     It allows pagination based on parameters from custom setting.
*
* @author  Shah Kadirmohideen
* @version  2011-10-26
*/
  
/** 
* CHANGE HISTORY
* =============================================================================
* Date      Name          Description
* 2011-10-26  Shah Kadirmohideen    Created      
* 2012-01-20  Shah Kadirmohideen    Incorporated enhanced list (go to list) functionality related changes.
* 2012-10-05  Shah Kadirmohideen    Enhanced exception handling using handleException() method
* 2016-09-23	Denis Mitropolsky		Added invisible text field to fix the issue with form postback on Enter
* =============================================================================
*/
public with sharing class CNContactRelationshipViewController {
//page vars
	public string redirectURL{get;set;}	
	public Boolean showOAuth{get;set;}
	private ApexPages.StandardController localcontroller{get;set;}
	public string id{get;set;}	 
	public string sHREF{get;set;}
	//Private variables
	public   String sContId;
	private transient String sDownloadType;  //pdf or excel
	private string token;
	private String sMode;  //load, elist or blank
	private static final String sClassName = 'CNContactRelationshipViewController';
	//show/hide settings
	private Boolean ShowColleagueEmailData;
	public Boolean getShowColleagueEmailData(){ 
		return  ShowColleagueEmailData;  	
	}   
	public void setShowColleagueEmailData(Boolean v){
		ShowColleagueEmailData = v;
	}
	private Boolean ShowColleagueLocation;    						
	public Boolean getShowColleagueLocation(){ 
		return ShowColleagueLocation;    	
	}       
	public void setShowColleagueLocation(Boolean v){
		ShowColleagueLocation = v;
	}
	private Boolean ShowColleaguePhoneData;
	public Boolean getShowColleaguePhoneData(){
		return ShowColleaguePhoneData;  	
	}
	public void setShowColleaguePhoneData(Boolean v){
		ShowColleaguePhoneData = v;
	}  
	private Boolean ShowColleagueRecency;      
	public Boolean getShowColleagueRecency(){
		return ShowColleagueRecency;   	
	}         
	public void setShowColleagueRecency(Boolean v){
		ShowColleagueRecency = v;
	}
	private Boolean ShowColleagueRelationshipStrength;
	public Boolean getShowColleagueRelationshipStrength(){
		return ShowColleagueRelationshipStrength;  	
	}
	public void setShowColleagueRelationshipStrength(Boolean v){
		ShowColleagueRelationshipStrength = v;
	} 
	private Boolean ShowColleagueSource;      
	public Boolean getShowColleagueSource(){
		return ShowColleagueSource;
	}        
	public void setShowColleagueSource(Boolean v){
		ShowColleagueSource = v;
	}
	private Boolean ShowColleagueTitle;
	public Boolean getShowColleagueTitle(){
		return ShowColleagueTitle;   	
	}        
	public void setShowColleagueTitle(Boolean v){
		ShowColleagueTitle = v;
	}
	//Public variables
	public Contact cont {get; set;}
	public string searchText{get;set;} 
	public List<CNData.CNRelationship> cachedSearch{get;set;}

	public Boolean searchName{get;set;}
	public Boolean searchTitle{get;set;}
	public Boolean searchEmail{get;set;}
	public Boolean searchLocation{get;set;}
	public CNPaginator paginator {get; set;}  
	public transient Boolean isDownloadMode {get; set;}
	public transient Boolean serviceDown {get; set;}
	public transient Boolean showPageLoadingMsg {get; set;}    
	public integer iTotalInnerPages{get; set;} //total records/innerdatacount
	public integer iTotalInnerRecords{get; set;} //actual returned record count
	public integer innerpageSize{get;set;}
	private integer iCurrentInnerPage;  
	public integer getiCurrentInnerPage(){    
		return iCurrentInnerPage;
	}
	public void setiCurrentInnerPage(integer val){
		iCurrentInnerPage = val;
		if(iCurrentInnerPage!=0){
			innerpagebynumber();
		}
	}
  public string noDataMessage{get;set;}
  //
  public integer iStartInnerPage{get; set;} //low display# on paginator
  public integer iEndInnerPage{get; set;} //high display# on paginator  
  /* CONSTRUCTORS */

  public CNContactRelationshipViewController(ApexPages.StandardController controller) {
	localcontroller = controller;   
  	System.debug('constructor CNContactRelationshipViewController starts');
  	string err =  ApexPages.currentPage().getParameters().get('error');
  	if(err == null){
	  	id=ApexPages.currentPage().getParameters().get('id');
		token = ApexPages.currentPage().getParameters().get('token');
		if(token!=null){
			CNAppUtils_14.AUTHTOKEN = token; 
		}
		string e = ApexPages.currentPage().getParameters().get('expires');
		integer expires = (e!=null)?integer.valueOf(e):0;
		if(expires!=0){
			CNAppUtils_14.tokenExpires = expires;
		}
		showOAuth = false; 
		//get token 	
		User u = [SELECT BDP_OAuth_Expires_At__c,BDP_OAuth_Token__c FROM User where id=:UserInfo.getUserId()];
		if(u.BDP_OAuth_Token__c != null){
			if(u.BDP_OAuth_Expires_At__c < System.Now()){ //assume if we set the token we also set the time
				CNAppUtils_14.AUTHTOKEN = u.BDP_OAuth_Token__c;
				CNAppUtils_14.tokenExpires = expires;		
				System.debug('called init');
				this.sContId = ((Contact) controller.getRecord()).Id;
				CNData.sortBy = 'scoreDesc';
				CNData.whichSort = 'outer';
				iTotalInnerPages=0;
				iTotalInnerRecords=0;
				iCurrentInnerPage=0;
				iStartInnerPage=0;
				iEndInnerPage=0;
				innerpageSize = Integer.valueOf(CNAppUtils.getAppCustomSetting().Data_Display_Size__c);
				noDataMessage = CNAppUtils.getAppCustomSetting().Data_Sensitive_Display_Value__c;  
				init();
			}else{
				createHREF(id); //either we have no token or it is expired
			}
		}else{		 
			if(CNAppUtils_14.AUTHTOKEN != null){ 
				this.sContId = ((Contact) controller.getRecord()).Id;
				CNData.sortBy = 'scoreDesc';
				CNData.whichSort = 'outer';
				iTotalInnerPages=0;
				iTotalInnerRecords=0;
				iCurrentInnerPage=0;
				iStartInnerPage=0;
				iEndInnerPage=0;
				innerpageSize = Integer.valueOf(CNAppUtils.getAppCustomSetting().Data_Display_Size__c);
				noDataMessage = CNAppUtils.getAppCustomSetting().Data_Sensitive_Display_Value__c;  
				init();
			}else{
				createHREF(id); //either we have no token or it is expired						
			}
		}
  	}else{
  		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,err));
  		system.debug('returned error in call to oauth');
  	}
  } 
  public void createHREF(string id){
		showOAuth = true;
		String pageName = ApexPages.CurrentPage().getUrl(); 
		pageName = pageName.replaceFirst('/apex/','');
		pageName = EncodingUtil.urlEncode(pageName, 'UTF-8'); 
		string[] pageNameExtra = pageName.split('%3F',0);
		pageName = pageNameExtra[0]; 
        CN_App_Settings__c  csett = [SELECT OAUTH_URL__c,APP_OAUTH_CLIENTID__c FROM CN_App_Settings__c order by createddate desc limit 1];
        sHREF = csett.OAUTH_URL__c +'/identity/connect/authorize?client_id=' + csett.APP_OAUTH_CLIENTID__c + '&redirect_uri=';
		sHREF += EncodingUtil.urlEncode(system.URL.getSalesforceBaseUrl().toExternalForm() + '/apex/CNGetAuth','UTF-8');
		sHREF += '&scope=cnapi&response_type=code&state=' + pageName + '-' + id;
		System.debug('sHREF=' + sHREF);	
		redirectURL = sHREF;
		doAuthorize(sHREF);	
	}
	public PageReference doAuthorize(string url){ 
		PageReference pageRef = new PageReference(url); 
		pageRef.setRedirect(true); 
		system.debug('url for redirect=' + url);
		return pageRef; 
	}
  /* POPUP SUPPORT */
  public boolean displayPopup {get; set;}

  public void closePopup() {
	  displayPopup = false;
  }

  public void showPopup() {
	  displayPopup = true;
  }
  /* PUBLIC METHODS */
  public void processCheckChange(){

  }
  /* PUBLIC METHODS */

  public void innerlast(){
	  system.debug('called innerLastarrow() iTotalInnerPages=' + iTotalInnerPages);
	  iCurrentInnerPage = iTotalInnerPages; 
	  innerpagebynumber();
  }
  public void innerfirst(){
	  iCurrentInnerPage = 1;
	  innerpagebynumber();
  }
  public void innernext(){
	  iCurrentInnerPage = (iCurrentInnerPage<iTotalInnerPages)?iCurrentInnerPage +1:iTotalInnerPages;
	  innerpagebynumber();
  }
  public void innerprevious(){
	  iCurrentInnerPage = (iCurrentInnerPage>0)?iCurrentInnerPage -1:1;
	  innerpagebynumber();
  }
  public void innerElipsis(){
	  system.debug('called innerElipsis');
	  iStartInnerPage=(iStartInnerPage+5<iTotalInnerPages)?iStartInnerPage+5:iStartInnerPage;
	  iCurrentInnerPage=iStartInnerPage;  
	  iEndInnerPage=iStartInnerPage+5;
	  innerpagebynumber();
  }
  public void innerbackElipsis(){
	  system.debug('called innerbackElipsis');
	  iStartInnerPage=(iStartInnerPage-5>0)?iStartInnerPage-5:iStartInnerPage;
	  iCurrentInnerPage=iStartInnerPage+4;  
	  iEndInnerPage=iStartInnerPage+4;
	  system.debug('iStartInnerPage = ' + iStartInnerPage);
	  system.debug('iCurrentInnerPage = ' + iCurrentInnerPage);
	  innerpagebynumber();
  }  
  public integer getinnerEndOfPages(){     
	  return ((iTotalInnerPages-iCurrentInnerPage)>0)?1:0; 
  }
  public void innerpagebynumber(){
	  system.debug('called innerPageByNumber page value=' + iCurrentInnerPage);
	  paginator.pageNo = string.valueOf(iCurrentInnerPage);       
	  paginator.specificPage();       
	  iCurrentInnerPage = integer.valueOf(paginator.pageNo);
	  // iStartInnerPage = 1,6,11,16 etc  
	  if(iCurrentInnerPage-5 >0){
		  iStartInnerPage = (integer.valueOf(iCurrentInnerPage/5)*5)+1;
		  if(iStartInnerPage>iTotalInnerPages){
			  iStartInnerPage = iStartInnerPage-5;
		  }
	  }else{
		  iStartInnerPage = 1;
	  }

	  iEndInnerPage=((iTotalInnerPages-iStartInnerPage)>4)?iStartInnerPage+4:(iTotalInnerPages-iStartInnerPage)+1;
	  system.debug('after movement pageNo=' + paginator.pageNo);
	  system.debug('iCurrentInnerPage now equals =' + iCurrentInnerPage);
	  system.debug('iStartInnerPage =' + iStartInnerPage);
	  system.debug('iEndInnerPage =' + iEndInnerPage);
  }
  public void innerSortBy(){
	  iCurrentInnerPage=1;
	  innerpagebynumber(); 
	  paginator.sortDataBy();

  }

  //Returns true if any errors were found while processing the request
  public Boolean getErrorsFound() {
	  System.debug('page messages: ' + ApexPages.getMessages());
	  return ApexPages.getMessages().size() > 0;
  }

  //Returns true if the output table  can be displayed
  public Boolean getIsDisplayResultTable() {
	  if (paginator != null && paginator.getRelationships() != null) {
		  if (getIsEnhancedList()) {
			  return true;
		  }
		  else {
			  return paginator.getRelationships().size()>0;
		  }
	  }
	  return false;
  }

  //Returns true if the footer row can be displayed on enhanced list
  public Boolean getIsDisplayFooterRow() {
	  return getIsEnhancedList() && paginator != null && paginator.getRelationships() != null && paginator.getRelationships().size() == 0;
  }

  //Returns the app setting from custom setting
  public CN_App_Settings__c getAppSetting() {
	  return CNAppUtils.getAppCustomSetting();
  }

  //Returns true if the page is displayed using enhanced list view
  public Boolean getIsEnhancedList() {
	  return sMode == 'elist';
  }
    
  //Search current list for input test from search box on Tab
    public void search() {
	  //implement search
	  system.debug('CONTACTS entered search search test =' + searchText);
        try {
	  if(searchText.trim()!=''){
		  searchText = searchText.trim();
		  CN_App_Settings__c casett = [SELECT Show_Colleague_Title__c,Show_Contact_Title__c FROM CN_App_Settings__c];

          //cache current page
		  cachedSearch = new List<CNData.CNRelationship>(paginator.relationships);      
		  //iterate list and find all names containing searchText
		  List<CNData.CNRelationship> searchResultList = new List<CNData.CNRelationship>();     
          
		  for(object rr : paginator.oListHandler.listData ){   
			  CNData.CNRelationship r = (CNData.CNRelationship)rr;      
			  if(r.colleague.lastName.startsWithIgnoreCase(searchtext)||r.colleague.lastName==searchtext){
				  searchResultList.add(r); 
			  }
			  if(r.colleague.title!=null && casett.Show_Colleague_Title__c==true){
				  if(r.colleague.title.containsIgnoreCase(searchtext)||r.colleague.title==searchtext){
					  searchResultList.add(r); 
				  }
			  }
		  }

          if(searchResultList.size()>0){
			  paginator.relationships.clear();
			  paginator.relationships.addAll(searchResultList);
			  system.debug('CONTACTS found results' +   searchResultList.size()); 
			  iTotalInnerRecords = searchResultList.size();         
			  iTotalInnerPages=(math.mod(iTotalInnerRecords,innerpageSize)>0)?integer.valueOf(iTotalInnerRecords/innerpageSize)+1:iTotalInnerRecords/innerpageSize;
			  iCurrentInnerPage=1;
			  iStartInnerPage=1;
			  iEndInnerPage=iTotalInnerPages;
		  } else {
			  // no results
			  system.debug('CONTACTS no results'); 
			  if(cachedSearch.size()>0){		
				  paginator.relationships.clear();
				  paginator.relationships.addAll(cachedSearch);
			  }		
			  cachedSearch.clear();	 
			  searchtext = '';//'No Results...';	
			  innerfirst();
			  showPopup();
		  }
        }
        } catch(Exception oExp) {
            CNAppUtils.handleException(new CNData.CNExceptionInfo(
                oExp, 
                ApexPages.Severity.ERROR, 
                sClassName, 
                'search()', 
                'Search text: ' + searchText, 
                true, 
                true, 
                sClassName
            ));
        }
    }

    public void reset(){
		if(cachedSearch!=null){
			if(cachedSearch.size()>0){
				paginator.pageNo = '1';
				paginator.first();
				iTotalInnerRecords=paginator.getTotalRecords();
				iCurrentInnerPage=1;
				iStartInnerPage=1;
				iTotalInnerPages=(Math.mod(iTotalInnerRecords,innerpageSize)>0)?(iTotalInnerRecords/innerpageSize)+1:(iTotalInnerRecords/innerpageSize);
				iEndInnerPage=(iTotalInnerPages>5)?5:iTotalInnerPages; 
			}
		}
	searchtext = '';
}
  /* PRIVATE METHODS */
    
  //Initializes various parameters to load the page.
  private void init() {
	  if(token!=null && CNAppUtils_14.AUTHTOKEN == ''){
			CNAppUtils_14.AUTHTOKEN = token; 
		}
		User u = [SELECT BDP_OAuth_Expires_At__c,BDP_OAuth_Token__c FROM User where id=:UserInfo.getUserId()];
		if(u.BDP_OAuth_Token__c != null){
			CNAppUtils_14.AUTHTOKEN = u.BDP_OAuth_Token__c;
		}
	  if (CNAppUtils.validateAppSettings() == false){return;}    
	  if (CNAppUtils.isServiceActive() == false) {
		  serviceDown = true;
		  return;
	  }
	  //set app values
	  CN_App_Settings__c cnapp = [SELECT Show_Colleague_Email_Data__c,Show_Colleague_Location__c,
	                              Show_Colleague_Phone_Data__c,Show_Colleague_Recency__c,Show_Colleague_Relationship_Strength__c,
	                              Show_Colleague_Source__c,Show_Colleague_Title__c FROM CN_App_Settings__c limit 1];
	  setShowColleagueEmailData(cnapp.Show_Colleague_Email_Data__c);
	  setShowColleagueLocation(cnapp.Show_Colleague_Location__c);
	  setShowColleaguePhoneData(cnapp.Show_Colleague_Phone_Data__c);
	  setShowColleagueRecency(cnapp.Show_Colleague_Recency__c);
	  setShowColleagueRelationshipStrength(cnapp.Show_Colleague_Relationship_Strength__c);
	  setShowColleagueSource(cnapp.Show_Colleague_Source__c);
	  setShowColleagueTitle(cnapp.Show_Colleague_Title__c) ;   
	  //;
	  this.cont = [Select Id, Email, Name from Contact where Id=:sContId];
	  System.debug('input contact: ' + cont + ', sMode: ' + sMode);


	  if (CNAppUtils.isEmpty(cont.Email)) {
		  String sMsg = 'No Data Avaiable (101)';//'Contact email is required to fetch relationships from ContactNet.';
		  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, sMsg));
		  System.debug('sMsg=' + sMsg);
		  return;
	  }
	  CNContactRelationshipService crs = new CNContactRelationshipService(cont.Id, cont.Email);
	  if(crs!=null){
		  paginator = new CNPaginator(crs);
	  }else{
		  String sMsg = 'No Data Avaiable (101)';//'Contact email doesn\'t match a company in ContactNet.';
		  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, sMsg));
		  System.debug('sMsg=' + sMsg);
	  } 
	  if (paginator.getSize() == 0 && ApexPages.getMessages().size() == 0) {
		  String sMsg = 'No Data Avaiable (101)';//No relationship is found for this contact.';
		  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, sMsg));
		  System.debug('sMsg=' + sMsg);
	  }
	  //set initial pager values
	  System.debug('got to values');
	  iTotalInnerRecords=paginator.getTotalRecords();
	  iCurrentInnerPage=1;
	  iStartInnerPage=1;
	  iTotalInnerPages=(Math.mod(iTotalInnerRecords,innerpageSize)>0)?(iTotalInnerRecords/innerpageSize)+1:(iTotalInnerRecords/innerpageSize);
	  iEndInnerPage=(iTotalInnerPages>5)?5:iTotalInnerPages;    
  }   

}