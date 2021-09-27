/**

* =============================================================================
*/   
public with sharing class CNLeadRelationshipViewController {
	//Private variables
	private static final String sClassName = 'CNLeadRelationshipViewController';
	public  List<CNData.CNRelationship> debugemail{get;set;}
	public string redirectURL{get;set;}
	public Boolean showOAuth{get;set;}
	public string sHREF{get;set;}
	//Private variables
	private transient String sDownloadType;  //pdf or excel
	public  String sCompanyCNID{get;set;}
	public  String sContactCNID{get;set;}
	//search variables
	public transient string searchText{get;set;} 
	public transient string searchTextcoll{get;set;} 
	//public string searchType{get;set;} 
	//public string searchCurrentTab{get;set;}
	List<object> cachedSearch{get;set;}
	List<object> cachedSearchColl{get;set;}
	public transient Boolean searchName{get;set;}
	public transient Boolean searchTitle{get;set;}
	public transient Boolean searchEmail{get;set;}
	public transient Boolean searchLocation{get;set;}
	public CNPaginator paginator {get; set;}
	public integer innerpageSize{get;set;}  
	//
	public transient Boolean ShowContactRecency{get;set;}
	public transient Boolean ShowContactSource{get;set;}
	public transient Boolean ShowContactEmailData{get;set;}
	public transient Boolean ShowContactPhoneData{get;set;}
	public transient Boolean ShowContactTitle{get;set;}
	public transient Boolean ShowContactRelationshipStrength{get;set;}
	public transient Boolean enableContactActionColumn{get;set;}
	public transient Boolean ShowColleagueRecency{get;set;}
	public transient Boolean ShowColleagueSource{get;set;}
	public transient Boolean ShowColleagueEmailData{get;set;}
	public transient Boolean ShowColleaguePhoneData{get;set;}
	public transient Boolean ShowColleagueTitle{get;set;}
	public transient Boolean ShowColleagueRelationshipStrength{get;set;}
	public transient Boolean ShowColleagueLocation{get;set;}
	public transient string cookie{get;set;}
	//
	public transient string sColleagueCNID{get;set;} 
	private String sMode;  //load, elist or blank
	private string token;
	public boolean noAccount{get;set;}
	//Public variables
	public Account oAcct {get; set;}
	public CNPaginator colleaguePaginator {get; set;}  
	public CNPaginator contactPaginator {get; set;} 
	public  CNPaginator colleagueDetailPaginator {get; set;}  
	public  CNPaginator contactDetailPaginator {get; set;}   

	public   List<CNData.CNRelationship> relationshipsForColleague {get; set;}  //inner table data for a given colleague - current paged
	public   List<CNData.CNRelationship> relationshipsForContact {get; set;}  //inner table data for a given contact - current paged

	public   List<CNData.CNRelationship> relationshipsForColleagueUnPaged {get; set;}  //inner table data for a given colleague
	public   List<CNData.CNRelationship> relationshipsForContactUnPaged {get; set;}  //inner table data for a given contact

	public transient CNData.CNRelationship hiddenColleagueRelationshipExpanded {get; set;}  //most recently expanded colleague relationship
	public transient CNData.CNRelationship hiddenContactRelationshipExpanded {get; set;}  //most recently expanded contact relationship

	public transient Boolean isDownloadMode {get; set;}
	public transient Boolean serviceDown {get; set;} 
	public transient Boolean showPageLoadingMsg {get; set;}  
	public transient String sSelectedTab {get; set;}
	public String sAcctId;
	public  string noDataMessage{get;set;}
	public transient Boolean useGlobalSearch {get; set;}
	public transient Boolean isSensitiveData {get; set;} 
	/* Added SOW#32 - M.Eaton */  
	public  transient Boolean showContactEmail {get; set;}
	public  transient Boolean showContactPhone {get; set;}
	//


	//
	public  String actionDelimiter {get; set;} 

	/*Pagination vars for inner tables*/
	public string innerColleagueID{get;set;}
	public string innerContactID{get;set;}
	public integer iTotalInnerPages{get; set;} //total records/innerdatacount
	public integer iTotalInnerRecords{get; set;} //actual returned record count
	public integer iCurrentInnerPage;
	public integer getiCurrentInnerPage(){  	
		return iCurrentInnerPage;
	}
	public void setiCurrentInnerPage(integer val){
		iCurrentInnerPage = val;
		if(iCurrentInnerPage!=0){
			if(iCurrentInnerPage>5 && iCurrentInnerPage>iStartInnerPage){
				system.debug('hit setiCurrentInnerPage ');
				integer sets = 0;
				integer pSize = 5;
				while((iCurrentInnerPage-pSize)>=1){
					sets++;
					pSize= pSize+5;
				}
				iStartInnerPage = (sets*5)+1;
				iEndInnerPage = (iStartInnerPage+5<=iTotalInnerPages)?iStartInnerPage+5:iTotalInnerPages;
				system.debug('hit setiCurrentInnerPage iEndInnerPage=' + iEndInnerPage);
			}else{
				//go back to first page
				iStartInnerPage = ((iCurrentInnerPage-4)>0)?iCurrentInnerPage-4:1;
				iEndInnerPage = iCurrentInnerPage;
			}
			innerpagebynumber();
		}
	} 
	//
	public integer iStartInnerPage{get; set;} //low display# on paginator
	public integer iEndInnerPage{get; set;} //high display# on paginator
	//**** 
	public integer iTotalInnerPagescoll{get; set;} //total records/innerdatacount
	public integer iTotalInnerRecordscoll{get; set;} //actual returned record count
	private integer iCurrentInnerPagecoll;
	public integer getiCurrentInnerPagecoll(){  	
		return iCurrentInnerPagecoll;
	}
	public void setiCurrentInnerPagecoll(integer val){
		iCurrentInnerPagecoll = val;
		if(iCurrentInnerPagecoll!=0){
			if(iCurrentInnerPagecoll>5&& iCurrentInnerPagecoll>iStartInnerPagecoll){
				system.debug('hit setiCurrentInnerPagecoll ');
				integer sets = 0;
				integer pSize = 5;
				while((iCurrentInnerPagecoll-pSize)>=1){
					sets++;
					pSize = pSize +5;
				}
				iStartInnerPagecoll = (sets*5)+1;
				iEndInnerPagecoll = (iStartInnerPagecoll+5<=iTotalInnerPagescoll)?iStartInnerPagecoll+5:iTotalInnerPagescoll;
				system.debug('hit setiCurrentInnerPagecoll iEndInnerPagecoll=' + iEndInnerPagecoll);
			}else{
				//go back to first page  			
				iStartInnerPagecoll = ((iCurrentInnerPagecoll-4)>0)?iCurrentInnerPagecoll-4:1;
				iEndInnerPagecoll = iCurrentInnerPagecoll;
			}
			innerpagebynumbercoll();
		}
	} 
	//
	public integer iStartInnerPagecoll{get; set;} //low display# on paginator
	public integer iEndInnerPagecoll{get; set;} //high display# on paginator
	//*****
	/* CONSTRUCTORS */

	//public constructor  
	public CNLeadRelationshipViewController(ApexPages.StandardController controller) {
		System.debug('constructor starts');
		string err =  ApexPages.currentPage().getParameters().get('error');
	  	if(err == null){
			noAccount = false;
			Lead oOpp = (Lead) controller.getRecord();
			Lead oOp = [select id,name,Company from Lead where Id=:oOpp.Id];
			List<Account> oAcctl = [select id,name from Account where Name=:oOp.Company order by createddate desc limit 1];
			if(oAcctl.size()>0){
				this.sAcctId = oAcctl[0].Id;
				oAcct = oAcctl[0];
				system.debug('#$&$#^& accountid=' + this.sAcctId);
				this.oAcct = [Select Id, Name, BDP_ID__c,Website from Account where Id=:sAcctId];
			}else{
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Data Available (102)');
				ApexPages.addMessage(myMsg);
				return;
			}
			System.debug('input acct: ' + oAcct);
			CNData.sortBy = 'scoreDesc';
			CNData.innerSortBy = 'innerscoreDesc';
			CNData.whichSort = 'outer';
			iTotalInnerPages=0;
			iTotalInnerRecords=0;
			iCurrentInnerPage=0;
			iStartInnerPage=0;
			iEndInnerPage=0;	
			iTotalInnerPagescoll=0;
			iTotalInnerRecordscoll=0;
			iCurrentInnerPagecoll=0;
			iStartInnerPagecoll=0;
			iEndInnerPagecoll=0;
			innerpageSize = Integer.valueOf(CNAppUtils.getAppCustomSetting().Inner_Relationship_Data_Display_Size__c);
			noDataMessage = CNAppUtils.getAppCustomSetting().Data_Sensitive_Display_Value__c;
			//get configuration settings for display
			CN_App_Settings__c cnapp = [SELECT Enable_Contact_Add_Action__c,Enable_Contact_Search_Action__c,Show_Colleague_Email_Data__c,Show_Colleague_Location__c,Show_Colleague_Phone_Data__c,Show_Colleague_Recency__c,Show_Colleague_Relationship_Strength__c,Show_Colleague_Source__c,Show_Colleague_Title__c,Show_Contact_Email_Data__c,Show_Contact_Location__c,Show_Contact_Phone_Data__c,Show_Contact_Recency__c,Show_Contact_Relationship_Strength__c,Show_Contact_Source__c,Show_Contact_Title__c,Show_Email_Data__c,Show_Phone_Data__c FROM CN_App_Settings__c];
			ShowContactRecency = cnapp.Show_Contact_Recency__c;
			ShowContactSource = cnapp.Show_Contact_Source__c;
			ShowContactEmailData = cnapp.Show_Contact_Email_Data__c;
			ShowContactPhoneData = cnapp.Show_Contact_Phone_Data__c;
			ShowContactTitle = cnapp.Show_Contact_Title__c;
			ShowContactRelationshipStrength = cnapp.Show_Contact_Relationship_Strength__c;
			enableContactActionColumn = cnapp.Enable_Contact_Add_Action__c || cnapp.Enable_Contact_Search_Action__c;
			ShowColleagueRecency = cnapp.Show_Colleague_Recency__c;
			ShowColleagueSource = cnapp.Show_Colleague_Source__c;
			ShowColleagueEmailData = cnapp.Show_Colleague_Email_Data__c;
			ShowColleaguePhoneData = cnapp.Show_Colleague_Phone_Data__c;
			ShowColleagueTitle = cnapp.Show_Colleague_Title__c;
			ShowColleagueRelationshipStrength = cnapp.Show_Colleague_Relationship_Strength__c;
			ShowColleagueLocation = cnapp.Show_Colleague_Location__c;
			
			 
			System.debug('constructor CNContactRelationshipViewController starts');
		  	string id=ApexPages.currentPage().getParameters().get('id');
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
					init();	
					CNData.innerSortBy = 'innerscoreDesc';
					CNData.whichSort = 'outer';		
				}else{
					createHREF(id); //either we have no token or it is expired
				}				
			}else{		 
				if(CNAppUtils_14.AUTHTOKEN != null){
					init();
					CNData.innerSortBy = 'innerscoreDesc';
					CNData.whichSort = 'outer';
				}else{
					createHREF(id);	
					doAuthorize(sHREF);				
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
	public void innerlast(){
		system.debug('innerlast iCurrentInnerPage= ' + iCurrentInnerPage);
		iCurrentInnerPage = iTotalInnerPages;
		iEndInnerPage=iTotalInnerPages;	
		iStartInnerPage=(iTotalInnerPages>5)?iTotalInnerPages/5:1;
		innerpagebynumber();
	}
	public void innerfirst(){
		system.debug('innerfirst iCurrentInnerPage= ' + iCurrentInnerPage);
		iCurrentInnerPage = 1;  	
		iStartInnerPage=1;
		iEndInnerPage=(iTotalInnerPages<5)?iTotalInnerPages:5;
		innerpagebynumber();
	}
	public void innernext(){
		system.debug('innernext iCurrentInnerPage= ' + iCurrentInnerPage);
		iCurrentInnerPage = (iCurrentInnerPage<iTotalInnerPages)?iCurrentInnerPage +1:iTotalInnerPages;
		integer curriStartInnerPage = iStartInnerPage;
		iStartInnerPage = (curriStartInnerPage<iCurrentInnerPage+5)?curriStartInnerPage:curriStartInnerPage+5;	 
		iEndInnerPage=iStartInnerPage+5;	
		innerpagebynumber();
	}
	public void innerprevious(){
		system.debug('innerprevious iCurrentInnerPage= ' + iCurrentInnerPage);
		iCurrentInnerPage = (iCurrentInnerPage>0)?iCurrentInnerPage -1:1;
		integer curriStartInnerPage = iStartInnerPage;
		iStartInnerPage = (curriStartInnerPage>iCurrentInnerPage)?curriStartInnerPage:curriStartInnerPage-5;	 
		iEndInnerPage=iStartInnerPage+5;
		innerpagebynumber();
	}
	public void innerElipsis(){
		system.debug('innerEllipses iCurrentInnerPage= ' + iCurrentInnerPage);
		iStartInnerPage=(iCurrentInnerPage<iTotalInnerPages)?iStartInnerPage:iStartInnerPage;
		iCurrentInnerPage=iStartInnerPage;	
		iEndInnerPage=(iStartInnerPage+5<iTotalInnerPages)?iStartInnerPage+5:iStartInnerPage+math.mod(iTotalInnerPages,5);
		innerpagebynumber();
	}
	public void innerbackElipsis(){
		system.debug('innerbackElipsis iCurrentInnerPage= ' + iCurrentInnerPage);
		iStartInnerPage=(iStartInnerPage-5>0)?iStartInnerPage-5:1;
		iCurrentInnerPage=iStartInnerPage+5;	
		iEndInnerPage=iStartInnerPage+5;
		innerpagebynumber();
	} 
	public integer getinnerEndOfPages(){  	 
		return ((iTotalInnerPages-iCurrentInnerPage)>0)?1:0; 
	}
	public integer getinnerEndOfPagesCol(){  	 
		return ((iTotalInnerPagescoll-iCurrentInnerPagecoll)>0)?1:0; 
	}
	//****
	public void innerlastcoll(){
		system.debug('innerlastcoll iCurrentInnerPagecoll= ' + iCurrentInnerPagecoll);
		iCurrentInnerPagecoll = iTotalInnerPagescoll;
		iEndInnerPagecoll=iTotalInnerPagescoll;	
		iStartInnerPagecoll=(iTotalInnerPagescoll>5)?iTotalInnerPagescoll/5:1;
		innerpagebynumbercoll();
	}
	public void innerfirstcoll(){
		system.debug('innerfirstcoll iCurrentInnerPagecoll= ' + iCurrentInnerPagecoll);
		iCurrentInnerPagecoll = 1;  	
		iStartInnerPagecoll=1;
		iEndInnerPagecoll=(iTotalInnerPagescoll<5)?iTotalInnerPagescoll:5;
		innerpagebynumbercoll();
	}
	public void innernextcoll(){
		system.debug('innernextcoll iCurrentInnerPagecoll= ' + iCurrentInnerPagecoll);
		iCurrentInnerPagecoll = (iCurrentInnerPagecoll<iTotalInnerPagescoll)?iCurrentInnerPagecoll +1:iTotalInnerPagescoll;
		integer curriStartInnerPagecoll = iStartInnerPagecoll;
		iStartInnerPagecoll = (curriStartInnerPagecoll<iCurrentInnerPagecoll+5)?curriStartInnerPagecoll:curriStartInnerPagecoll+5;	 
		iEndInnerPagecoll=iStartInnerPagecoll+5;	
		innerpagebynumbercoll();
	}
	public void innerpreviouscoll(){
		system.debug('innerpreviouscoll iCurrentInnerPagecoll= ' + iCurrentInnerPagecoll);
		iCurrentInnerPagecoll = (iCurrentInnerPagecoll>0)?iCurrentInnerPagecoll -1:1;
		integer curriStartInnerPagecoll = iStartInnerPagecoll;
		iStartInnerPagecoll = (curriStartInnerPagecoll>iCurrentInnerPagecoll)?curriStartInnerPagecoll:curriStartInnerPagecoll-5;	 
		iEndInnerPagecoll=iStartInnerPagecoll+5;
		innerpagebynumbercoll();
	}
	public void innerElipsiscoll(){
		system.debug('innerEllipsescoll iCurrentInnerPagecoll= ' + iCurrentInnerPagecoll);
		iStartInnerPagecoll=(iCurrentInnerPagecoll<iTotalInnerPagescoll)?iStartInnerPagecoll:iStartInnerPagecoll;
		iCurrentInnerPagecoll=iStartInnerPagecoll;	
		iEndInnerPagecoll=(iStartInnerPagecoll+5<iTotalInnerPagescoll)?iStartInnerPagecoll+5:iStartInnerPagecoll+math.mod(iTotalInnerPagescoll,5);
		innerpagebynumbercoll();
	}
	public void innerbackElipsiscoll(){
		system.debug('innerbackElipsis iCurrentInnerPage= ' + iCurrentInnerPagecoll);
		iStartInnerPagecoll=(iStartInnerPagecoll-5>0)?iStartInnerPagecoll-5:1;
		iCurrentInnerPagecoll=iStartInnerPagecoll+5;	
		iEndInnerPagecoll=iStartInnerPagecoll+5;
		innerpagebynumbercoll();
	} 
	public integer getinnerEndOfPagescoll(){  	 
		return ((iTotalInnerPagescoll-iCurrentInnerPagecoll)>0)?1:0; 
	}

	//****
	public void innerpagebynumber(){  	
		system.debug('entered innerpagebynumber');
		system.debug('iCurrentInnerPage=' + iCurrentInnerPage);     
		// offset is low end start# in list for the next slice eg for page 2 it would be 10 (0 based list)
		// so for 10 base 0,10,20,30
		integer offset = (iCurrentInnerPage*innerpageSize)-innerpageSize;

		//   slice list index vals should be for 10 base 0-9,10-19,20-29,30-39
		//end val should be list.size()-1     
		if(relationshipsForContactUnPaged!=null){
			iTotalInnerPages = (math.mod(relationshipsForContactUnPaged.size(),innerpageSize)>0)?(relationshipsForContactUnPaged.size()/innerpageSize)+1:(relationshipsForContactUnPaged.size()/innerpageSize);
			integer iend=(relationshipsForContactUnPaged.size()>(offSet+innerpageSize))?innerpageSize:(math.Mod(relationshipsForContactUnPaged.size(),innerpageSize));
			relationshipsForContact.clear();
			for(integer i=0;i<innerpageSize;i++){ 
				if(i+offset<relationshipsForContactUnPaged.size()){         
					relationshipsForContact.add(relationshipsForContactUnPaged[i+offSet]);
				}
			}      
		}    
	}
	public void debug(){}
	public void innerpagebynumbercoll(){  	
		system.debug('entered innerpagebynumbercoll');
		system.debug('iCurrentInnerPagecoll=' + iCurrentInnerPagecoll);     
		// offset is low end start# in list for the next slice eg for page 2 it would be 10 (0 based list)
		// so for 10 base 0,10,20,30
		integer offset = (iCurrentInnerPagecoll*innerpageSize)-innerpageSize;

		//   slice list index vals should be for 10 base 0-9,10-19,20-29,30-39
		//end val should be list.size()-1
		if(relationshipsForColleagueUnPaged!=null){
			iTotalInnerPagescoll = (math.mod(relationshipsForColleagueUnPaged.size(),innerpageSize)>0)?(relationshipsForColleagueUnPaged.size()/innerpageSize)+1:(relationshipsForColleagueUnPaged.size()/innerpageSize);
			//should be 10 or the mod value if last page
			integer iend=(relationshipsForColleagueUnPaged.size()>(offSet+innerpageSize))?innerpageSize:(math.Mod(relationshipsForColleagueUnPaged.size(),innerpageSize));
			relationshipsForColleague.clear();
			for(integer i=0;i<innerpageSize;i++){
				if(i+offset<relationshipsForColleagueUnPaged.size()){                 
					relationshipsForColleague.add(relationshipsForColleagueUnPaged[i+offSet]); 
				} 
			}           
		} 
	}
	public void innerSortDataBycoll(){
		//this is complicated by the paging, we need to sort the full list and then return the first page
		//design requirements are result of each sort starts view on first page again 
		//we also need to load correct innerTableData from the Map
		try{  	
			string currSort = CNData.innersortBy;
			CNData.whichSort = 'inner';   	
			sColleagueCNID = ApexPages.currentPage().getParameters().get('colleagueCNID');
			system.debug('got page parameter and sColleagueCNID is now:' + sColleagueCNID); 
			sContactCNID = ApexPages.currentPage().getParameters().get('contactCNID'); 
			system.debug('got page parameter and sContactCNID is now:' + sContactCNID); 
			if(relationshipsForColleagueUnPaged!=null){
				if(relationshipsForColleagueUnPaged.size()>0){
					CNData.innerSortBy = colleaguePaginator.getinnerSortBy();
					if(currSort.contains('score') || currSort.contains('email') || currSort.contains('recency')){
						relationshipsForColleagueUnPaged.sort(); 
					}			    
					if(currSort.contains('location')){
						system.debug(' entered into location sort');
						List<CNData.CNRelationship> blankLocations = new List<CNData.CNRelationship>();
						List<CNData.CNRelationship> normalLocations = new List<CNData.CNRelationship>();
						for(CNData.CNRelationship c : relationshipsForColleagueUnPaged){			            
							if(c.colleague.workingLocation!=null){
								if(c.colleague.workingLocation.trim()==''){
									blankLocations.add(c);
								}else{
									normalLocations.add(c);
								}
							}else{
								blankLocations.add(c);
							}        
						}
						system.debug('normal Locations list size:' + normalLocations.size());
						system.debug('blank Locations list size:' + blankLocations.size());
						normalLocations.sort();

						normalLocations.addAll(blankLocations);//this should put them at end
						relationshipsForColleagueUnPaged.clear();
						relationshipsForColleagueUnPaged.addAll(normalLocations);
					}
					//    
					// 
					if(currSort.contains('name')){
						//
						system.debug(' entered into name sort');
						List<CNData.CNRelationship> emailNames = new List<CNData.CNRelationship>();
						List<CNData.CNRelationship> normalNames = new List<CNData.CNRelationship>();

						for(CNData.CNRelationship c : relationshipsForColleagueUnPaged){			        
							string compare = '';
							if(c.contact!=null){
								compare = c.contact.lastName + c.contact.firstName;
							}else{ 
								compare = c.colleague.lastName + c.colleague.firstName;
							}
							if(compare.contains('@')||compare==''){
								emailNames.add(c);
								system.debug('email names=' + compare + 'record=' + c);
							}else{
								normalNames.add(c);
							}
						}
						system.debug('normal names list size:' + normalNames.size());
						system.debug('email names list size:' + emailNames.size());
						normalNames.sort(); 
						CNData.innersortBy = (currSort.contains('Asc'))?'inneremailAsc':'inneremailDesc'; 

						CNData.whichSort = 'inner'; 
						emailNames.sort(); 
						debugemail = new   List<CNData.CNRelationship>();
						debugemail.addAll(emailNames);
						normalNames.addAll(emailNames);//this should put them at end			      
						relationshipsForColleagueUnPaged.clear();
						relationshipsForColleagueUnPaged.addAll(normalNames);			            
					}  
					if(currSort.contains('title')){
						system.debug(' entered into title sort');
						List<CNData.CNRelationship> blankTitles = new List<CNData.CNRelationship>();
						List<CNData.CNRelationship> normalTitles = new List<CNData.CNRelationship>();

						for(CNData.CNRelationship c : relationshipsForColleagueUnPaged){
							if(c.contact!=null){  
								if(c.contact.title!=null){       
									if(c.contact.title.trim()==''){
										blankTitles.add(c);
									}else{
										normalTitles.add(c);
									}
								}else{
									blankTitles.add(c);
								}
							}else{
								if(c.colleague.title!=null){
									if(c.colleague.title.trim()==''){
										blankTitles.add(c);
									}else{
										normalTitles.add(c);
									}
								}else{
									blankTitles.add(c);
								}
							}
						}
						normalTitles.sort();			       
						normalTitles.addAll(blankTitles);//this should put them at end
						relationshipsForColleagueUnPaged.clear();
						relationshipsForColleagueUnPaged.addAll(normalTitles);	 
					} 		
					for(integer i=0;i<relationshipsForColleague.size();i++){
						relationshipsForColleague[i]=relationshipsForColleagueUnPaged[i]; 
					}
				}
				CNData.whichSort = 'outer'; 
				innerfirstcoll();//navigate to first page visually 
			}
		}catch(Exception oExp){
			CNAppUtils.handleException(new CNData.CNExceptionInfo(oExp, ApexPages.Severity.ERROR, 
					sClassName, 'innerSortDataBy()', 
					'AccountId: ' + sAcctId + ', sMode: ' + sMode, true, true, sClassName));
		}
	}
	public void innerSortDataBy(){
		//this is complicated by the paging, we need to sort the full list and then return the first page
		//design requirements are result of each sort starts view on first page again 
		//we also need to load correct innerTableData from the Map
		try{  	
			string currSort = CNData.innersortBy;
			CNData.whichSort = 'inner';   	
			sColleagueCNID = ApexPages.currentPage().getParameters().get('colleagueCNID');
			system.debug('got page parameter and sColleagueCNID is now:' + sColleagueCNID); 
			sContactCNID = ApexPages.currentPage().getParameters().get('contactCNID'); 
			system.debug('got page parameter and sContactCNID is now:' + sContactCNID); 
			if(relationshipsForContactUnPaged!=null){
				if(relationshipsForContactUnPaged.size()>1){			  		
					CNData.innerSortBy = contactPaginator.getinnerSortBy(); 
					if(currSort.contains('score') || currSort.contains('email') || currSort.contains('recency')){
						relationshipsForContactUnPaged.sort(); 
					}

					if(currSort.contains('location')){
						system.debug(' entered into location sort');
						List<CNData.CNRelationship> blankLocations = new List<CNData.CNRelationship>();
						List<CNData.CNRelationship> normalLocations = new List<CNData.CNRelationship>();
						for(CNData.CNRelationship c : relationshipsForContactUnPaged){ 
							if(c.colleague.workingLocation!=null){
								if(c.colleague.workingLocation.trim()==''){
									blankLocations.add(c);
								}else{
									normalLocations.add(c);
								}
							}else{
								blankLocations.add(c);
							}        
						}
						system.debug('normal Locations list size:' + normalLocations.size());
						system.debug('blank Locations list size:' + blankLocations.size());
						normalLocations.sort();

						normalLocations.addAll(blankLocations);//this should put them at end
						relationshipsForContactUnPaged.clear();
						relationshipsForContactUnPaged.addAll(normalLocations);
					}
					//    
					// 
					if(currSort.contains('name')){
						//
						system.debug(' entered into name sort');
						List<CNData.CNRelationship> emailNames = new List<CNData.CNRelationship>();
						List<CNData.CNRelationship> normalNames = new List<CNData.CNRelationship>();

						for(CNData.CNRelationship c : relationshipsForContactUnPaged){ 
							string compare = '';
							if(c.contact!=null){
								compare = c.contact.lastName + c.contact.firstName;
							}else{ 
								compare = c.colleague.lastName + c.colleague.firstName;
							}
							if(compare.contains('@')||compare==''){
								emailNames.add(c);
							}else{
								normalNames.add(c);
							}
						}
						system.debug('normal names list size:' + normalNames.size());
						system.debug('email names list size:' + emailNames.size());
						normalNames.sort();			       		       
						CNData.innersortBy = (currSort.contains('Asc'))?'inneremailAsc':'inneremailDesc';
						emailNames.sort(); 
						normalNames.addAll(emailNames);//this should put them at end
						relationshipsForContactUnPaged.clear();
						relationshipsForContactUnPaged.addAll(normalNames);

					}  
					if(currSort.contains('title')){
						system.debug(' entered into title sort');
						List<CNData.CNRelationship> blankTitles = new List<CNData.CNRelationship>();
						List<CNData.CNRelationship> normalTitles = new List<CNData.CNRelationship>();

						for(CNData.CNRelationship c : relationshipsForContactUnPaged){
							if(c.contact!=null){  
								if(c.contact.title!=null){       
									if(c.contact.title.trim()==''){
										blankTitles.add(c);
									}else{
										normalTitles.add(c);
									}
								}else{
									blankTitles.add(c);
								}
							}else{
								if(c.colleague.title!=null){
									if(c.colleague.title.trim()==''){
										blankTitles.add(c);
									}else{
										normalTitles.add(c);
									}
								}else{
									blankTitles.add(c);
								}
							}
						}
						normalTitles.sort();			       
						normalTitles.addAll(blankTitles);//this should put them at end
						relationshipsForContactUnPaged.clear();
						relationshipsForContactUnPaged.addAll(normalTitles);	
					}
					for(integer i=0;i<relationshipsForContact.size();i++){
						relationshipsForContact[i]=relationshipsForContactUnPaged[i]; 
					}			
				}	 
				CNData.whichSort = 'outer'; 
				innerfirst();//navigate to first page visually   
			}	

		}catch(exception oExp){
			CNAppUtils.handleException(new CNData.CNExceptionInfo(oExp, ApexPages.Severity.ERROR, 
					sClassName, 'innerSortDataBy()', 
					'AccountId: ' + sAcctId + ', sMode: ' + sMode, true, true, sClassName));
		}
	} 
	//For a given colleague CNID, loads the contacts information from CN
	public void loadContactsForSingleColleague() {
		if(token!=null){
			CNAppUtils_14.AUTHTOKEN = token;			
		}
		User u = [SELECT BDP_OAuth_Expires_At__c,BDP_OAuth_Token__c FROM User where id=:UserInfo.getUserId()];
		if(u.BDP_OAuth_Token__c != null){
			CNAppUtils_14.AUTHTOKEN = u.BDP_OAuth_Token__c;
		}
		try {
			System.debug('loadContactsForSingleColleague started');       
			sColleagueCNID = ApexPages.currentPage().getParameters().get('ColleagueCNID');
			system.debug('sColleagueCNID: '+ sColleagueCNID);
			CNData.CNWebserviceResult oResult = CNServices_14.fetchRelationshipsForColleague(sColleagueCNID, sCompanyCNID, 
					CNAppUtils.getAppCustomSetting().Data_Cache_Size__c.intValue(), 0);
			this.relationshipsForColleague = oResult.listRelationships;
			this.hiddenColleagueRelationshipExpanded = getColleagueRelationship(sColleagueCNID, true);  
			CNData.CNRelationship relationshipExpanded = getColleagueRelationship(sColleagueCNID, false);
			if (relationshipExpanded.expanded == false) {
				relationshipExpanded.expanded = true;
			}
			else {
				relationshipExpanded.expanded = false;
			}      
			//
			colleaguepaginator.setinnerSortBy('innersortDesc'); 
			if(relationshipsForColleague.size()>innerpageSize){
				if(math.Mod(relationshipsForColleague.size(),innerpageSize)>0){
					iTotalInnerPagescoll=(relationshipsForColleague.size()/innerpageSize)+1;
				}else{
					iTotalInnerPagescoll=(relationshipsForColleague.size()/innerpageSize);
				}
			}else{
				iTotalInnerPagescoll=1;
			}
			iTotalInnerRecordscoll=relationshipsForColleague.size();	  	  
			relationshipsForColleagueUnPaged=new List<CNData.CNRelationship>(relationshipsForColleague);
			innerSortDataBy();
			//take first page
			relationshipsForColleague.clear();	
			integer en = (relationshipsForColleagueUnPaged.size()>=innerpageSize)?innerpageSize:relationshipsForColleagueUnPaged.size();		   
			for(integer i=0;i<en;i++){
				relationshipsForColleague.add(relationshipsForColleagueUnPaged[i]); //remember 0 based!!	  
			}
			System.debug('loadContactsForSingleColleague finished');
			CNData.innersortBy = 'innerscoreDesc';
			colleaguepaginator.setinnersortBy('innerscoreDesc');
			iCurrentInnerPagecoll=1;
			iStartInnerPagecoll=1;
			iEndInnerPagecoll=(iTotalInnerPagescoll>5)?5:iTotalInnerPagescoll;	
		}
		catch (Exception oExp) {
			CNAppUtils.handleException(new CNData.CNExceptionInfo(oExp, ApexPages.Severity.ERROR, 
					sClassName, 'loadContactsForSingleColleague()', 
					'AccountId: ' + sAcctId + ', sMode: ' + sMode, true, true, sClassName));
		}            
	}  
	//For a given contact CNID, loads the colleagues information from CN
	// creates full and current page lists plus defult page and sort settings in innerTableData class  
	//it then returns the pagelist as current. every time this is called   
	public void loadColleaguesForSingleContact() {
		if(token!=null){
			CNAppUtils_14.AUTHTOKEN = token;			
		}
		User u = [SELECT BDP_OAuth_Expires_At__c,BDP_OAuth_Token__c FROM User where id=:UserInfo.getUserId()];
		if(u.BDP_OAuth_Token__c != null){
			CNAppUtils_14.AUTHTOKEN = u.BDP_OAuth_Token__c;
		}
		try {
			System.debug('loadColleaguesForSingleContact started');      
			sContactCNID = ApexPages.currentPage().getParameters().get('contactCNID');
			System.debug('sContactCNID: ' + sContactCNID);     
			CNData.CNWebserviceResult oResult = CNServices_14.fetchRelationshipsForContactCNID(sContactCNID, 
					CNAppUtils.getAppCustomSetting().Data_Cache_Size__c.intValue(), 0, false);
			this.relationshipsForContact = oResult.listRelationships;
			this.hiddenContactRelationshipExpanded = getContactRelationship(sContactCNID, true);  
			CNData.CNRelationship relationshipExpanded = getContactRelationship(sContactCNID, false);
			if (relationshipExpanded.expanded == false) {
				relationshipExpanded.expanded = true;
			}
			else {
				relationshipExpanded.expanded = false;
			}
			//

			contactPaginator.setinnerSortBy('innersortDesc');          
			System.debug('relationships loaded: ' + relationshipsForContact.size());      
			//      
			if(relationshipsForContact.size()>innerpageSize){
				if(math.Mod(relationshipsForContact.size(),innerpageSize)>0){
					iTotalInnerPages=(relationshipsForContact.size()/innerpageSize)+1;
				}else{
					iTotalInnerPages=(relationshipsForContact.size()/innerpageSize);
				}
			}else{
				iTotalInnerPages=1;
			}
			iTotalInnerRecords=relationshipsForContact.size();	  	  
			relationshipsForContactUnPaged=new List<CNData.CNRelationship>(relationshipsForContact);
			innerSortDataBy();
			//take first page
			relationshipsForContact.clear();
			integer en = (relationshipsForContactUnPaged.size()>=innerpageSize)?innerpageSize:relationshipsForContactUnPaged.size();		   
			for(integer i=0;i<en;i++){
				relationshipsForContact.add(relationshipsForContactUnPaged[i]); //remember 0 based!!
			}	
			System.debug('loadColleaguesForSingleContact finished'); 
			CNData.innersortBy = 'innerscoreDesc';
			contactPaginator.setinnersortBy('innerscoreDesc');
			iCurrentInnerPage=1;
			iStartInnerPage=1;
			iEndInnerPage=(iTotalInnerPages>5)?5:iTotalInnerPages;	
		}
		catch (Exception oExp) {
			CNAppUtils.handleException(new CNData.CNExceptionInfo(oExp, ApexPages.Severity.ERROR, 
					sClassName, 'loadColleaguesForSingleContact()', 
					'AccountId: ' + sAcctId + ', sMode: ' + sMode, true, true, sClassName));
		}            
	} 

	//Returns true if any errors were found while processing the request
	public Boolean getErrorsFound() {
		return ApexPages.getMessages().size() > 0;
	}

	//Returns the app setting from custom setting
	public CN_App_Settings__c getAppSetting() {
		return CNAppUtils.getAppCustomSetting();
	}

	//Returns true if the page is displayed using enhanced list view
	public Boolean getIsEnhancedList() {
		return sMode == 'elist';
	}

	//Decides if the colleague table should be displayed or not on the page
	public Boolean getDisplayColleagueTable() {
		if (getIsEnhancedList()) {
			return true;
		}
		else { 
			return (colleaguePaginator!=null)?colleaguePaginator.getSize() > 0:false;
		}
	}

	//Decides if the contact table should be displayed or not on the page
	public Boolean getDisplayContactTable() {
		if (getIsEnhancedList()) {
			return true;
		}
		else {
			return (contactPaginator!=null)?contactPaginator.getSize() > 0:false;
		}
	}
	//Search current list for input test from search box on Tab
	public void resetSearchCon(){
		//get params
		string searchCurrentTab = ApexPages.currentPage().getParameters().get('searchCurrentTab');
		string searchType = ApexPages.currentPage().getParameters().get('searchType'); 		 
		system.debug('searchCurrentTab=' + searchCurrentTab);
		system.debug('searchType=' + searchType);
		if(searchType=='Contact'){	
			if(cachedSearch!=null){			
				if(cachedSearch.size()>0){
					contactPaginator.oListHandler.listData.clear();
					contactPaginator.oListHandler.listData.addAll(cachedSearch);
					contactPaginator.oListHandler.iTotalRecords = cachedSearch.size();
					contactPaginator.pageNo = '1';
					contactPaginator.specificPage();
				}
			} 
		} 
		searchtext = '';  		 
	}
	public void searchListsCon(){		
		//get params
		string searchCurrentTab = ApexPages.currentPage().getParameters().get('searchCurrentTab');
		string searchType = ApexPages.currentPage().getParameters().get('searchType'); 		 
		system.debug('searchCurrentTab=' + searchCurrentTab);
		system.debug('searchType=' + searchType);		
		//do we need to restore for a subsequent search on same base set of data?
		if(cachedSearch!=null){
			if(cachedSearch.size()>0){
				CNData.CNRelationship t = (CNData.CNRelationship)cachedSearch[0];
				if(t.contact!=null){
					contactPaginator.oListHandler.listData.clear();
					contactPaginator.oListHandler.listData.addAll(cachedSearch);  
					contactPaginator.oListHandler.iTotalRecords = cachedSearch.size();
					contactPaginator.first();
				}
			}
		} 
		if(searchText!='' && searchCurrentTab == 'Account'){
			searchText = searchText.trim();
			if(searchType=='Contact'){
				if(contactPaginator!=null){ 					
					system.debug('searching for Contacts in SF Account Tab');
					//cache current page
					cachedSearch = new List<object>(contactPaginator.oListHandler.listData);			
					//iterate list and find all names containing searchText
					List<object> searchResultList = new List<object>();
					for(object r: contactPaginator.oListHandler.ListData){
						CNData.CNRelationship rr = (CNData.CNRelationship)r;
						if(rr.contact.lastName.startsWithIgnoreCase(searchtext)||rr.contact.lastName==searchtext){
							searchResultList.add(r);
						}
						if(rr.contact.title!=null){
							if(rr.contact.title.startsWithIgnoreCase(searchtext)||rr.contact.title==searchtext){
								searchResultList.add(r);
							}
						}
					}
					if(searchResultList.size()>0){
						contactPaginator.oListHandler.listData.clear();
						contactPaginator.oListHandler.listData.addAll(searchResultList);
						contactPaginator.oListHandler.iTotalRecords = searchResultList.size();
						contactPaginator.first();		
					}else{
						if(cachedSearch!=null){
							if(cachedSearch.size()>0){		
								contactPaginator.oListHandler.listData.clear();
								contactPaginator.oListHandler.listData.addAll(cachedSearch);
								contactPaginator.oListHandler.iTotalRecords = cachedSearch.size();
								contactPaginator.first();
							}	
						}	
						cachedSearch.clear();	 				 
						searchtext = '';//'No Results...';
						contactPaginator.first();
						showPopup();		 
					}
					return;
				}	
			} 
		}
	}
	public void resetSearchColl(){
		string searchCurrentTab = ApexPages.currentPage().getParameters().get('searchCurrentTab');
		string searchType = ApexPages.currentPage().getParameters().get('searchType'); 		 
		system.debug('coll searchCurrentTab=' + searchCurrentTab);
		system.debug('coll searchType=' + searchType);		
		if(searchType=='Colleague'){
			if(cachedSearchColl!=null){
				if(cachedSearchColl.size()>0){	 	
					colleaguePaginator.oListHandler.listData.clear();
					colleaguePaginator.oListHandler.listData.addAll(cachedSearchColl);
					colleaguePaginator.oListHandler.iTotalRecords = cachedSearchColl.size(); 
					colleaguePaginator.first();
				}
			}
		}
		searchtextcoll = '';
	}
	public void searchListsColl(){
		//get params
		string searchCurrentTab = ApexPages.currentPage().getParameters().get('searchCurrentTab');
		string searchType = ApexPages.currentPage().getParameters().get('searchType'); 		 
		system.debug('coll searchCurrentTab=' + searchCurrentTab);
		system.debug('coll searchType=' + searchType);		
		//do we need to restore for a subsequent search on same base set of data?
		if(cachedSearchColl!=null){
			if(cachedSearchColl.size()>0){
				CNData.CNRelationship t = (CNData.CNRelationship)cachedSearchColl[0];
				if(t.colleague!=null){
					colleaguePaginator.oListHandler.listData.clear();
					colleaguePaginator.oListHandler.listData.addAll(cachedSearchColl);
				}
			}
		} 
		if(searchTextcoll!='' && searchCurrentTab == 'Account'){
			searchTextcoll = searchTextcoll.trim();
			if(searchType=='Colleague'){
				if(colleaguePaginator!=null){ 					
					system.debug('searching for Colleagues in SF Account Tab');
					//cache current page
					cachedSearchColl = new List<object>(colleaguePaginator.oListHandler.listData);			
					//iterate list and find all names containing searchText
					List<object> searchResultList = new List<object>();
					for(object r: colleaguePaginator.oListHandler.ListData){
						CNData.CNRelationship rr = (CNData.CNRelationship)r;
						if(rr.colleague.lastName.startsWithIgnoreCase(searchtextcoll)||rr.colleague.lastName==searchtextcoll){
							searchResultList.add(r);
						}
						if(rr.colleague.title!=null){
							if(rr.colleague.title.startsWithIgnoreCase(searchtextcoll)||rr.colleague.title==searchtextcoll){
								searchResultList.add(r);
							}	
						}
					}
					if(searchResultList.size()>0){
						colleaguePaginator.oListHandler.listData.clear();
						colleaguePaginator.oListHandler.listData.addAll(searchResultList);	
						colleaguePaginator.oListHandler.iTotalRecords = searchResultList.size();
						colleaguePaginator.first();		
					}else{	
						if(cachedSearchColl!=null){						
							if(cachedSearchColl.size()>0){		
								colleaguePaginator.oListHandler.listData.clear();
								colleaguePaginator.oListHandler.listData.addAll(cachedSearchColl);
								colleaguePaginator.oListHandler.iTotalRecords = cachedSearchColl.size();
								colleaguePaginator.first();
							}	
						}	
						cachedSearchColl.clear();	 
						searchtextcoll = '';//'No Results...';	
						colleaguePaginator.first();
						showPopup();	 
					}
					return;
				}	
			}
		} 	 
	}
	/* PRIVATE METHODS */

	//Initializes various parameters to load the page
	public void init() {  	 
		system.debug('*** Called into init ***');
		if(ApexPages.getMessages().size() > 0){return;}
		//this.useGlobalSearch = CNAppUtils.isChatterEnabled();
		//system.debug('*** checked chatter ***' + this.useGlobalSearch);
		//this.sSelectedTab = ApexPages.currentPage().getParameters().get('t');
		//system.debug('*** checked selected tab ***');
		//if (skipExecution()== true) return;
		//system.debug('*** past skip execution ***');
		if (CNAppUtils.validateAppSettings() == false) return;
		system.debug('*** validated settings ***');
		if (CNAppUtils.isServiceActive() == false) {
			system.debug('*** Service is down ***');
			serviceDown = true;
			return;
		}else{
			this.serviceDown = false;
		}
		system.debug('*** service is up ***');
		// Initialize UI display settings

		/*if (getIsEnhancedList()) { 
			this.colleaguePaginator = new CNPaginator(new CNEnhancedListColleageService(oAcct.Id));
			this.contactPaginator = new CNPaginator(new CNEnhancedListContactService(oAcct.Id));
			this.sCompanyCNID = CNServices_14.CNCompanyID;//new CNAppUtils.CNWebServiceQueueHandler(oAcct.Id, null, null, this.oAcct.BDP_ID__c).sCompanyCNID;  
		}
		else {  */
			//[CR-070] - MEaton - Add 10,000 LIMIT to query  
			//loads colleagues

			String sEmailDomain = CNAppUtils.getTopDomain([SELECT Email FROM Contact WHERE Email != NULL AND AccountId =: sAcctId LIMIT 10000]);
			system.debug('invoking Colleague relationship service with email domain: ' + sEmailDomain);
			if(sEmailDomain==''){
				//see if website url is on account
				Account act = [SELECT Website FROM Account where id =:oAcct.Id ];
				if(act.Website!=''){
					sEmailDomain = act.Website.replace('http://','abc@'); 
				}
			}
			CNData.CNCompany comp1;
			if(CNServices_14.CNCompanyID==null){
				comp1 = CNServices_14.fetchCompany(sEmailDomain);
				if(comp1==null){		  
					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Data Available (102)');
					ApexPages.addMessage(myMsg);
					return;	 
				}				
			}	

			this.sCompanyCNID = CNServices_14.CNCompanyID;//oColleagueService.companyCNID;	
			CNCompanyColleageRelationshipService oColleagueService; 
			try{ 
				oColleagueService = new CNCompanyColleageRelationshipService(sAcctId,this.sCompanyCNID, oAcct.Name, sEmailDomain);      
			}catch(Exception oException){
				String sMoreInfo = 'Lead SFDC Id: '; 
				CNAppUtils.handleException(new CNData.CNExceptionInfo(oException, ApexPages.Severity.ERROR, 
						sClassName, 'init()',
						sMoreInfo, false, true, 'Load Lead Relationship Info init failed'));
				return;
			}
			system.assertNotEquals(oColleagueService,null,'Colleague Service is null');  
			system.debug('@#$!@#oColleagueService.iTotalRecords=' + oColleagueService.iTotalRecords);
			CNData.CNCompany comp =  CNServices_14.fetchCompany(sEmailDomain);    //pulll back company while colleague is not functioning

			this.colleaguePaginator = new CNPaginator(oColleagueService);  
			//loads contacts
			//    system.debug('invoking contact relationship service with records: ' + oColleagueService.listContactRelationships);

			CNCompanyContactRelationshipService oContactService = new CNCompanyContactRelationshipService(sAcctId, sCompanyCNID, oColleagueService.listContactRelationships, oColleagueService.iTotalContactRecords);
			system.debug('******CNCompanyContactRelationshipService call :' + sAcctId + ' ' + sCompanyCNID + ' ' + oColleagueService.listContactRelationships + ' ' +oColleagueService.iTotalContactRecords);

			//      
			system.debug('$#@%@#$^%# oContactService: ' + oContactService);
			oContactService.iTotalRecords = oContactService.listData.size();

			this.contactPaginator = new CNPaginator(oContactService);

			System.debug('making contacts API call from colleague service - end');
			//      
		//}
		/*this.isDownloadMode = false;      
		this.sDownloadType = ApexPages.currentPage().getParameters().get('downloadType');
		if (this.sDownloadType != null) {
			this.isDownloadMode = true;    
		}*/
		relationshipsForColleague = new List<CNData.CNRelationship>();
		relationshipsForContact = new List<CNData.CNRelationship>();    
		CNData.innerSortBy = 'innerscoreDesc';
		//
		/*if (CNAppUtils.getContactEnableSearchAction() && CNAppUtils.getContactEnableAddAction()) {
			this.actionDelimiter = ' | ';  //set action menu delimiter character
		}
		else {
			this.actionDelimiter = '';    //remove action menu delimiter character
		}*/


	}

	//Fetches relationships for a given colleague CNID this is the drill down 
	//tring to replace index with CNID so the paging and sorting don't muddle us up
	public CNData.CNRelationship getColleagueRelationship(String sColleagueCNID, Boolean bIsHidden) {  	 
		System.debug('finding hidden row for CNID: ' + sColleagueCNID);
		for (CNData.CNRelationship rel : colleaguePaginator.getRelationships()) {
			System.debug('rel.colleague.CNID: ' + rel.colleague.CNID);
			if (rel.colleague.CNID == sColleagueCNID) { 
				if (bIsHidden) {
					if (rel.display == false) {
						System.debug('colleague rel: ' + rel);            
						return rel;
					}
				}
				else {
					System.debug('colleague rel: ' + rel);
					return rel;
				}
			}
		}  
		System.debug('returning null');
		return null;
	}  
	//Fetches relationships for a given contact CNID
	public CNData.CNRelationship getContactRelationship(String sContactCNID, Boolean bIsHidden) {
		System.debug('finding hidden row for CNID: ' + sContactCNID);
		CNData.innersortBy = 'innersortDesc'; 
		CNData.whichSort = 'outer';   
		for (CNData.CNRelationship rel : contactPaginator.getRelationships()) {
			if (rel.contact.CNID == sContactCNID) {
				if (bIsHidden) {
					if (rel.display == false){
						System.debug('contact rel: ' + rel); 
						return rel;
					}
				}
				else {          
					System.debug('contact rel: ' + rel);
					return rel;
				}
			}
		}    
		return null;
	}

	//Checks if the controller logic should be skipped
	public Boolean skipExecution() {
		sMode = ApexPages.currentPage().getParameters().get('mode');
		System.debug('sMode: ' + sMode);
		if (sMode == 'load' || sMode == 'elist') {
			System.debug('not skipping execution');
			this.showPageLoadingMsg = false;
			return false;
		}
		this.showPageLoadingMsg = true;
		return true;
	}

	/* INNER CLASSES */
/*
	public class CNEnhancedListColleageService extends CNEnhancedListHandler {
		//Private variables
		private String sAcctId;

		/* CONSTRUCTORS */
	/*		public CNEnhancedListColleageService(String sAcctId) {
			this.sAcctId = sAcctId;
			this.tabName = 'Colleague';
			System.debug('sAcctId: ' + sAcctId);
			initSetController();
		}

		/* PUBLIC METHODS */
		/*		public override String getQueryString() {
			String sQuery = CNAppUtils.prepareRelationshipSOQL('Colleague', sAcctId, null, -1, sSortBy, sSortDirection, sStartsWith);
			return sQuery;
		}

		//Loads queue handler record from custom object
		public override void loadQueueHandler() {
			if (oQueueHandler == null) {
				this.oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(sAcctId, null, null, 'Colleague');
			}
		} 

		public override List<CNData.CNRelationship> massageRelationships(List<CN_Relationship__c> listRelationshipInSObject) {
			List<CNData.CNRelationship> listRels =  CNAppUtils.convertCustomObjectToColleagueRelationship(listRelationshipInSObject, true);
			List<CNData.CNRelationship> listMassagedRels = new List<CNData.CNRelationship>();
			//due to paging we need to handle index and hiddenRowIndex values so they 
			//sequence correctly for current page/recordset not keep going 1-10  
			//so assign cnid as the index here and in javascript match on that    
			//gmc integer iAlternateIndex = (CNAccountRelationshipViewController.localIndex>0)?CNAccountRelationshipViewController.localIndex:0; //starts at 0

			for (CNData.CNRelationship oRel : listRels) {
				oRel.display = true;
				oRel.enhancedList = true;
				oRel.index = integer.valueOf(oRel.colleague.CNID);//iAlternateIndex++;
				listMassagedRels.add(oRel);

				CNData.CNColleague oHiddenCol = new CNData.CNColleague();
				oHiddenCol.CNID = oRel.colleague.CNID;
				oHiddenCol.firstName = oRel.colleague.firstName;
				oHiddenCol.lastName = oRel.colleague.lastName;
				oHiddenCol.emailAddresses = oRel.colleague.emailAddresses;

				CNData.CNRelationship oHiddenRelationship = new CNData.CNRelationship();
				oHiddenRelationship.colleague = oHiddenCol;
				oHiddenRelationship.display = false;
				//
				oHiddenRelationship.setShowColleagueEmailData(false);
				oHiddenRelationship.setShowColleagueLocation(false);
				oHiddenRelationship.setShowColleaguePhoneData(false);
				oHiddenRelationship.setShowColleagueRecency(false);
				oHiddenRelationship.setShowColleagueRelationshipStrength(false);
				oHiddenRelationship.setShowColleagueSource(false);
				oHiddenRelationship.setShowColleagueTitle(false);
				oHiddenRelationship.setShowContactEmailData(false);
				oHiddenRelationship.setShowContactLocation(false);
				oHiddenRelationship.setShowContactPhoneData(false);
				oHiddenRelationship.setShowContactRecency(false);
				oHiddenRelationship.setShowContactRelationshipStrength(false);
				oHiddenRelationship.setShowContactSource(false);
				oHiddenRelationship.setShowContactTitle(false);
				oHiddenRelationship.setShowEmailData(false);
				oHiddenRelationship.setShowPhoneData(false);
				oHiddenRelationship.setshowContactEmail(false);
				oHiddenRelationship.setshowContactPhone(false);   
				//
				oHiddenRelationship.index = integer.valueOf(oHiddenCol.CNID);//iAlternateIndex++;
				listMassagedRels.add(oHiddenRelationship);	        
			}
			return listMassagedRels;          
		}
	}
/*
	public class CNEnhancedListContactService extends CNEnhancedListHandler {
		//Private variables
		private String sAcctId;

		/* CONSTRUCTORS */
/*		public CNEnhancedListContactService(String sAcctId) {
			this.sAcctId = sAcctId;
			this.tabName = 'Contact';
			System.debug('sAcctId: ' + sAcctId);
			initSetController();
		}

		/* PUBLIC METHODS */
/*		public override String getQueryString() {
			String sQuery = CNAppUtils.prepareRelationshipSOQL('Contact', sAcctId, null, -1, sSortBy, sSortDirection, sStartsWith);
			List<CN_Relationship__c> listRels = (List<CN_Relationship__c>) Database.query(sQuery + ' limit 1');
			if (listRels.size() == 1) {
				CNPaginator.displayLastUpdateDate = listRels.get(0).Last_Modification_Time__c != null;
			}
			return sQuery;
		}

		//Loads queue handler record from custom object
		public override void loadQueueHandler() {
			if (oQueueHandler == null) {
				this.oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(sAcctId, null, null, 'Contact');
			}
		} 

		public override List<CNData.CNRelationship> massageRelationships(List<CN_Relationship__c> listRelationshipInSObject) {
			List<CNData.CNRelationship> listRels = CNAppUtils.convertCustomObjectToContactRelationship(listRelationshipInSObject, true);
			List<CNData.CNRelationship> listMassagedRels = new List<CNData.CNRelationship>();
			//Integer iAlternateIndex = 0;
			for (CNData.CNRelationship oRel : listRels) {
				System.debug('oRel: ' + oRel);

				oRel.display = true;    
				oRel.enhancedList = true;
				oRel.index = integer.valueOf(oRel.contact.CNID);//iAlternateIndex++;
				listMassagedRels.add(oRel);

				if (oRel.contact.LastModificationTimeAlt != null) {
					CNPaginator.displayLastUpdateDate = true;
				}

				CNData.CNContact oHiddenCont = new CNData.CNContact();
				oHiddenCont.CNID = oRel.contact.CNID;
				oHiddenCont.firstName = oRel.contact.firstName;
				oHiddenCont.lastName = oRel.contact.lastName;
				oHiddenCont.emailAddresses = oRel.contact.emailAddresses;

				CNData.CNRelationship oHiddenRelationship = new CNData.CNRelationship();
				oHiddenRelationship.contact = oHiddenCont;
				oHiddenRelationship.display = false;
				oHiddenRelationship.index = integer.valueOf(oHiddenCont.CNID);//iAlternateIndex++;
				listMassagedRels.add(oHiddenRelationship); 
			}
			return listMassagedRels;
		}

	}  */

}