/*
===============================================================================
LCRMOpportunitySplitController
===============================================================================

PURPOSE: Controller Class for LCRMOpportunitySplit Page

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2017-01-29      Rajesh                  Created 
===============================================================================
*/

public Class LCRMOpportunitySplitController{

    public Map<String,LCRM_Opportunity_Split__c> tempOppSplitMap{get;set;}
    public Map<String,OppProdByCat> oppProdByCatMap{get;set;}
    public Map<String,List<String>> oppProdIDByTeamMemIDMap{get;set;}
    public Map<ID,Decimal> oppProdIDByAmtMap{get;set;}
    public List<OppTeam> OppTeamList{get;set;}
    public Decimal totalAmount{get;set;}
    public Decimal totalSalesCredit{get;set;}
    public String splitIDClicked{get;set;}
    public String oppProdIDClicked{get;set;}
    public Boolean toggleFlag{get;set;}//used to maximize and minimize header
    public Decimal NewPerVal{get;set;}
    String oppID;
    public Boolean editFlag{get;set;}
    public String excludeAction{get;set;}
    public Opportunity opp{get;set;}   
    public String errorMsg{get;set;} 
     
    public LCRMOpportunitySplitController() {
    }
    
    //constructor
    public LCRMOpportunitySplitController(ApexPages.StandardController controller) {
        toggleFlag = true;
        oppProdByCatMap = new Map<String,OppProdByCat>();
        if(apexpages.currentpage().getparameters().get('id')!=null && apexpages.currentpage().getparameters().get('id')!=''){
            oppID = apexpages.currentpage().getparameters().get('id');
        }
        try{
            //query Opp record
            opp = [SELECT ID, Name, LCRM_Split_On__c, StageName, Is_GLI__c, CurrencyIsoCode FROM OPPORTUNITY WHERE ID =:oppID];
            oppID = opp.ID;
        }catch(Exception e){
            errorMsg = System.Label.LCRM_Split_WrongOppID;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error,errorMsg);
            ApexPages.addMessage(myMsg);
        }
        ID userID = UserInfo.getUserId();
        editFlag = false;
        //check if logged in user is assigned custom permission 'Edit_Custom_Split'
        List<SetupEntityAccess> setupEntities = [SELECT SetupEntityId FROM SetupEntityAccess 
                                                 WHERE SetupEntityId in 
                                                (SELECT Id FROM CustomPermission WHERE DeveloperName = 'Edit_Custom_Split') AND  
                                                 ParentId IN 
                                                 (SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId())];
        System.debug('setupEntities : '+setupEntities);
        if(setupEntities !=null && setupEntities.size()>0){
            editFlag = true;
        }
        excludeAction = '';
    }

    //methods to load data and called from Page Action
    public void loadData(){
        //if(opp!=null && opp.LCRM_Split_On__c == true){
        //validate data before displaying splits info
        validateOppBeforeLoad();
        System.debug('errorMsg : '+errorMsg);
        if(opp!=null && (errorMsg==null || errorMsg=='')){
            Map<ID, LCRM_Opportunity_Product_Clone__c> oppProdCloneMap = getOppProdCloneData();
            Map<ID,LCRM_Opportunity_Team_Clone__c> oppTeamCloneMap = getOppTeamCloneData();            
            List <LCRM_Opportunity_Split__c> oppSplitList = [SELECT ID, 
                        LCRM_Opportunity_Product_Clone__c,
                        LCRM_Opportunity_Product_Clone__r.LCRM_Action__c, 
                        LCRM_Opportunity_Team_Clone__c,
                        LCRM_Percent__c,
                        LCRM_Sales_Credit__c 
                        FROM LCRM_Opportunity_Split__c
                        WHERE 
                        LCRM_Opportunity__c =: opp.ID
                        ];
            oppProdIDByAmtMap = new Map<ID,Decimal>();
            //loop to create OppId to Amount map
            for(LCRM_Opportunity_Product_Clone__c osTemp : oppProdCloneMap.values()){
                oppProdIDByAmtMap.put(osTemp.ID,osTemp.LCRM_Incremental_Amount__c);
            }
            tempOppSplitMap = new Map<String,LCRM_Opportunity_Split__c>();
            //loop to create map of OLICloneID+OTeamCloneID -> Split record
            for(LCRM_Opportunity_Split__c osTemp : oppSplitList){
                tempOppSplitMap.put(osTemp.LCRM_Opportunity_Product_Clone__c+''+osTemp.LCRM_Opportunity_Team_Clone__c, osTemp);
            }
            //populate wrappers
            populateData(oppProdCloneMap.values(), oppTeamCloneMap.values());
        }
    }
    
    //method to fetch data from KeyValueStore(custom setting) based on label and split the value by comma and return as set
    public List<String> getCustomSettingData(String keyLabel){
        List<String> dataList = (KeyValueListStore__c.getValues(keyLabel) == null || 
                                   KeyValueListStore__c.getValues(keyLabel).TextValue__c == null || 
                                   KeyValueListStore__c.getValues(keyLabel).TextValue__c == '')?
                                   new List<String>():
                                   KeyValueListStore__c.getValues(keyLabel).TextValue__c.split(',');
        return dataList;
    }
    
    //method to validate filter conditions before splits is loaded on page and throw error if filter conditions not met
    public void validateOppBeforeLoad(){
        if(opp.Is_GLI__c == false){
            errorMsg = System.Label.LCRMOpptyNotGli;
        }
        Set<String> excludeStages = new Set<String>();
        excludeStages.addAll(getCustomSettingData('LCRMSplit_ExcludeStages'));
        
        List<String> ExcludeActionList = getCustomSettingData('LCRMSplit_ExcludeActions');
        
        List<String> maxProdLimitList = getCustomSettingData('LCRMSplit_ProdLimit');
        Integer maxProdLimit = (maxProdLimitList!=null && maxProdLimitList.size()>0)?Integer.valueOf(maxProdLimitList[0]):0;
        
        List<String> maxTeamLimitList = getCustomSettingData('LCRMSplit_TeamLimit');
        Integer maxTeamLimit = (maxTeamLimitList!=null && maxTeamLimitList.size()>0)?Integer.valueOf(maxTeamLimitList[0]):0;
        
        Integer countProd = 0;
        Integer countTeam = 0;
        if(opp!=null){
            countProd = [SELECT COUNT() FROM OpportunityLineItem WHERE OpportunityId = :oppID AND LCRM_Action__c NOT IN :ExcludeActionList];
            countTeam = [SELECT COUNT() FROM OpportunityTeamMember WHERE OpportunityId  = :oppID];
        }
        System.debug('maxTeamLimitList : '+maxTeamLimitList+' maxProdLimit : '+maxProdLimit);
        System.debug('maxTeamLimitList : '+maxTeamLimitList+' maxTeamLimit : '+maxTeamLimit);
        System.debug('excludeStages : '+excludeStages);
        System.debug('editFlag  : '+editFlag+' opp.LCRM_Split_On__c : '+opp.LCRM_Split_On__c+' opp.StageName : '+opp.StageName+':'+excludeStages.contains(opp.StageName)+' countProd : '+countProd+' countTeam : '+countTeam);
        /*if((editFlag == false && opp.LCRM_Split_On__c == false) || (opp.LCRM_Split_On__c == false && excludeStages.contains(opp.StageName)) || countProd == 0 || countTeam == 0){
            //Check min OLI/Oteam records with Stage & Action Conditions
            errorMsg = System.Label.LCRM_Split_NoSplit;
        }else if(countProd > maxProdLimit){
            //check for max Prod limit
            errorMsg = System.Label.LCRM_Split_ProdLimitError;
        }else if(countTeam  > maxTeamLimit){
            //check for max Opp Team Limit
            errorMsg = System.Label.LCRM_Split_TeamLimitError;
        }*/
           if((editFlag == false && opp.LCRM_Split_On__c == false) || (opp.LCRM_Split_On__c == false && excludeStages.contains(opp.StageName)) || countProd == 0 || countTeam == 0){
            //Check min OLI/Oteam records with Stage & Action Conditions 
            if(countProd == 0){      
                errorMsg = System.Label.LCRMOpptyWithoutProducts;      
            }
            else if(countTeam == 0){
                errorMsg = System.Label.LCRMOpptyWithoutTeamMember;
            }
            else if ( (opp.LCRM_Split_On__c == false && excludeStages.contains(opp.StageName))){
                errorMsg = System.Label.LCRMOpptyInvalidStageForSplit;
            }
            else{
                errorMsg = System.Label.LCRMOpptySplitSupportError;
            }  
        }
        else if(countProd > maxProdLimit){
            //check for max Prod limit
            errorMsg = System.Label.LCRM_Split_ProdLimitError;
        }else if(countTeam  > maxTeamLimit){
            //check for max Opp Team Limit
            errorMsg = System.Label.LCRM_Split_TeamLimitError;
        }

        //add page message if errorMsg is not blank
        if(errorMsg!=null && errorMsg!=''){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error,errorMsg);
            ApexPages.addMessage(myMsg);
            return;
        }        
           
    }
    
    //methods to load data from OLI Clone object and return map
    public Map<Id,LCRM_Opportunity_Product_Clone__c> getOppProdCloneData(){
        List<String> ExcludeActionList = getCustomSettingData('LCRMSplit_ExcludeActions');
        
        Map<Id,LCRM_Opportunity_Product_Clone__c> oppProdCloneMap = new Map<Id,LCRM_Opportunity_Product_Clone__c>([SELECT ID,
                    LCRM_Product__r.LCRM_Product_Set__c,
                    LCRM_Product_Segment__c,
                    LCRM_Product__r.Name, 
                    LCRM_Opp_Prod_ID__c,
                    LCRM_Opportunity__c,
                    LCRM_Product__r.LCRM_Product_Category__c, 
                    LCRM_Action__c, 
                    LCRM_Current_ACV__c, 
                    LCRM_New_ACV_SalesPrice__c, 
                    LCRM_Incremental_Amount__c
                    //LCRM_Split_Count__c
                    FROM LCRM_Opportunity_Product_Clone__c WHERE LCRM_Opportunity__c = :oppID AND
                    LCRM_Action__c NOT IN :ExcludeActionList
                    ORDER BY 
                    LCRM_Product__r.LCRM_Product_Set__c NULLS LAST,
                    LCRM_Product__r.LCRM_Product_Category__c NULLS LAST,
                    LCRM_Product__r.Name
                    ]);
        return oppProdCloneMap;
    }
    
    //methods to load data from Opp Team Clone object and return map
    public Map<ID, LCRM_Opportunity_Team_Clone__c> getOppTeamCloneData(){
        Map<ID,LCRM_Opportunity_Team_Clone__c> oppTeamCloneMap = new Map<ID,LCRM_Opportunity_Team_Clone__c>([SELECT ID,
                    LCRM_User__c,
                    LCRM_User__r.Name,
                    LCRM_Rep_Function__c
                    FROM LCRM_Opportunity_Team_Clone__c 
                    WHERE 
                    LCRM_Opportunity__c = :oppID
                    ORDER BY 
                    LCRM_User__r.Name
                    ]); 
        return oppTeamCloneMap;
    }
    
    /*public void generateSplitTemp(){
        List<LCRM_Opportunity_Split__c> oSplitList = new List<LCRM_Opportunity_Split__c>();
        DELETE [SELECT ID FROM LCRM_Opportunity_Split__c where LCRM_Opportunity_Product_Clone__r.LCRM_Opportunity__c=:oppID];
        List<LCRM_Opportunity_Team_Clone__c> oTeamList = [SELECT ID FROM LCRM_Opportunity_Team_Clone__c where LCRM_Opportunity__c=:oppID];
        List<LCRM_Opportunity_Product_Clone__c> oProdList = [SELECT ID,LCRM_Incremental_Amount__c FROM LCRM_Opportunity_Product_Clone__c where LCRM_Opportunity__c=:oppID];
        for(LCRM_Opportunity_Team_Clone__c oTeam : oTeamList){
            for(LCRM_Opportunity_Product_Clone__c oProd : oProdList){
                LCRM_Opportunity_Split__c oSplit = new LCRM_Opportunity_Split__c();
                oSplit.LCRM_Opportunity_Team_Clone__c = oTeam.ID;
                oSplit.LCRM_Opportunity_Product_Clone__c = oProd.ID;
                oSplit.LCRM_Percent__c = 0;
                oSplitList.add(oSplit);
            }
        }
        insert oSplitList;
    }*/
    
    //method to insert split & clone records when user click Opportunity Split for the first time
    public PageReference generateSplit(){
        List<String> ExcludeActionList = getCustomSettingData('LCRMSplit_ExcludeActions');
               
        List<OpportunityTeamMember> oTeamList = [SELECT ID, OpportunityID, TeamMemberRole, UserID FROM OpportunityTeamMember where OpportunityID=:oppID];
        List<LCRM_Opportunity_Team_Clone__c> oTeamCloneList = new List<LCRM_Opportunity_Team_Clone__c>();
        //loop to insert Opp Team Clone REcords
        for(OpportunityTeamMember oTeam : oTeamList){
            LCRM_Opportunity_Team_Clone__c oTTemp = new LCRM_Opportunity_Team_Clone__c();
            oTTemp.LCRM_Opp_Team_ID__c = oTeam.ID;
            oTTemp.LCRM_Opportunity__c = oTeam.OpportunityID;
            oTTemp.LCRM_Rep_Function__c = oTeam.TeamMemberRole;
            oTTemp.LCRM_User__c = oTeam.UserID;
            oTeamCloneList.add(oTTemp);
        }
        if(oTeamCloneList.size()>0){
            insert oTeamCloneList;
        }
        System.debug('oTeamCloneList : '+oTeamCloneList);
        List<OpportunityLineItem> oProdList = [SELECT ID, CurrencyIsoCode, OpportunityID, LCRM_Action__c, LCRM_Current_ACV__c, LCRM_Incremental_Amount__c, LCRM_New_ACV_SalesPrice__c, LCRM_Product_Category__c, Product_Category__c,LCRM_Product_Segment__c, Product2ID,Product2.Name FROM OpportunityLineItem where OpportunityID=:oppID AND LCRM_Action__c NOT IN :ExcludeActionList];
        List<LCRM_Opportunity_Product_Clone__c> oProdCloneList = new List<LCRM_Opportunity_Product_Clone__c>();
        //loop to insert OLI Clone records
        for(OpportunityLineItem oProd : oProdList){
            LCRM_Opportunity_Product_Clone__c oPTemp = new LCRM_Opportunity_Product_Clone__c();
            oPTemp.LCRM_Opp_Prod_ID__c = oProd.ID;
            oPTemp.LCRM_Opportunity__c = oProd.OpportunityID;
            oPTemp.LCRM_Action__c = oProd.LCRM_Action__c;
            oPTemp.LCRM_Current_ACV__c = oProd.LCRM_Current_ACV__c;
            oPTemp.LCRM_New_ACV_SalesPrice__c = oProd.LCRM_New_ACV_SalesPrice__c;
            oPTemp.LCRM_Product__c = oProd.Product2Id;
            oPTemp.LCRM_Product_Segment__c = oProd.LCRM_Product_Segment__c;
            oPtemp.CurrencyIsoCode = oProd.CurrencyIsoCode;
            oProdCloneList.add(oPTemp);
        }
        if(oProdCloneList.size()>0){
            insert oProdCloneList;
        }
        System.debug('oProdCloneList : '+oProdCloneList);
        List<LCRM_Opportunity_Split__c> oSplitList = new List<LCRM_Opportunity_Split__c>();
        oTeamCloneList = [SELECT ID, LCRM_Opportunity__c FROM LCRM_Opportunity_Team_Clone__c where LCRM_Opportunity__c=:oppID];
        oProdCloneList = [SELECT ID,LCRM_Incremental_Amount__c, CurrencyIsoCode FROM LCRM_Opportunity_Product_Clone__c where LCRM_Opportunity__c=:oppID];
        System.debug('oTeamCloneList : '+oTeamCloneList);
        System.debug('oProdCloneList : '+oProdCloneList);
        //loop to insert Split records
        for(LCRM_Opportunity_Team_Clone__c oTeam : oTeamCloneList){
            for(LCRM_Opportunity_Product_Clone__c oProd : oProdCloneList){
                LCRM_Opportunity_Split__c oSplit = new LCRM_Opportunity_Split__c();
                oSplit.LCRM_Opportunity_Team_Clone__c = oTeam.ID;
                oSplit.LCRM_Opportunity_Product_Clone__c = oProd.ID;
                oSplit.LCRM_Opportunity__c = oTeam.LCRM_Opportunity__c;
                oSplit.LCRM_Percent__c = 0;
                oSplit.CurrencyIsoCode = oProd.CurrencyIsoCode;
                oSplitList.add(oSplit);
            }
        }
        System.debug('oSplitList : '+oSplitList);
        insert oSplitList;
        opp.LCRM_Split_On__c = true;
        update opp;
        PageReference pageRef = new PageReference('/apex/LCRMOpportunitySplit?id='+opp.ID);
        return pageRef;
    }
    
    /*public void updateSplitCell(){
        String oppProdID = oppProdIDClicked;
        String splitID = splitIDClicked;
        Integer newVal = Integer.valueOf(NewPerVal);
        //System.debug('oppProdID  : '+oppProdID +' splitID  : '+splitID+' newVal : '+newVal);
        for(LCRM_Opportunity_Split__c osTemp : tempOppSplitMap.values()){
            if(oppProdID!=null && oppProdID!='' && osTemp.LCRM_Opportunity_Product_Clone__c == oppProdID){
                //updatePerValues(osTemp,newVal);
                osTemp.LCRM_Percent__c = newVal;
            }
            if(splitID!=null && splitID!='' && osTemp.LCRM_Opportunity_Product_Clone__c == splitID){
                //updatePerValues(osTemp,newVal);
                osTemp.LCRM_Percent__c = newVal;
            }
        }
        refreshBeforeSave();
    }*/
    
    //methods called on clicking Apply button from UI to refresh data as per new entries
    public void refreshBeforeSave(){
        Map<String,Integer> oldSplitValMap = new Map<String,Integer>();
        System.debug('oppProdByCatMap : '+oppProdByCatMap);
        //loop to update split percent values as per header entries
        for(OppProdByCat opCatTemp : oppProdByCatMap.values()){
            for(OppProd opTemp : opCatTemp.oppProdList){
                if(opTemp.NewPerVal != null && opTemp.NewPerVal != ''){
                    for(String str : oppProdIDByTeamMemIDMap.get(opTemp.oppProdClone.ID)){
                        if(tempOppSplitMap.get(opTemp.oppProdClone.ID+''+str)!=null && tempOppSplitMap.get(opTemp.oppProdClone.ID+''+str).LCRM_Percent__c == 0){
                            oldSplitValMap.put(tempOppSplitMap.get(opTemp.oppProdClone.ID+''+str).ID,Integer.ValueOf(tempOppSplitMap.get(opTemp.oppProdClone.ID+''+str).LCRM_Percent__c));
                            //updatePerValues(tempOppSplitMap.get(opTemp.oppProdClone.ID+''+str),Integer.valueOf(opTemp.NewPerVal));
                            System.debug('@@@ '+Integer.valueOf(opTemp.NewPerVal));                            
                            tempOppSplitMap.get(opTemp.oppProdClone.ID+''+str).LCRM_Percent__c = Integer.valueOf(opTemp.NewPerVal);
                            System.debug('@@@ '+tempOppSplitMap.get(opTemp.oppProdClone.ID+''+str).LCRM_Percent__c);
                        }
                    }
                    opTemp.NewPerVal = '';
                }
            }
        }
        System.debug('oldSplitValMap : '+oldSplitValMap);
        //loop to update split percent values as per entries in specific cell
        for(OppTeam otTemp : OppTeamList){
            for(OppSplitByCat osByCatTemp : otTemp.oppSplitByCatList){
                for(OppSplit osTemp : osByCatTemp.oppSplitList){
                    Integer percent = null;
                    System.debug('osTemp.oppSplitClone.ID@@@ '+osTemp.oppSplitClone);
                    if(oldSplitValMap.keySet().contains(osTemp.oppSplitClone.ID)){
                        percent = oldSplitValMap.get(osTemp.oppSplitClone.ID);
                        System.debug('percent@@@ '+percent);
                        if(osTemp.oppSplitClone!=null && osTemp.NewPerVal !=null && percent!=null && Integer.valueOf(osTemp.NewPerVal) != percent){
                            //updatePerValues(osTemp.oppSplitClone,Integer.valueOf(osTemp.NewPerVal));
                            osTemp.oppSplitClone.LCRM_Percent__c = Integer.valueOf(osTemp.NewPerVal);
                            System.debug('@@@osTemp.NewPerVal '+Integer.valueOf(osTemp.NewPerVal)); 
                        }else{
                            osTemp.NewPerVal = (osTemp.oppSplitClone.LCRM_Percent__c==null)?'0':String.valueOf(osTemp.oppSplitClone.LCRM_Percent__c);
                          System.debug('osTemp.NewPerVal@@@ '+osTemp.NewPerVal);
                        }
                    }
                    if(osTemp.oppSplitClone!=null && osTemp.NewPerVal !=null && osTemp.oppSplitClone.LCRM_Percent__c!=null && Integer.valueOf(osTemp.NewPerVal) != osTemp.oppSplitClone.LCRM_Percent__c){
                        //updatePerValues(osTemp.oppSplitClone,Integer.valueOf(osTemp.NewPerVal));
                        osTemp.oppSplitClone.LCRM_Percent__c = Integer.valueOf(osTemp.NewPerVal);
                        System.debug('ERROR:::: osTemp.oppSplitClone.LCRM_Percent__c@@ '+osTemp.oppSplitClone.LCRM_Percent__c);
                    }
                }
            }
        }
        Map<ID, LCRM_Opportunity_Product_Clone__c> oppProdCloneMap = getOppProdCloneData();
        Map<ID,LCRM_Opportunity_Team_Clone__c> oppTeamCloneMap = getOppTeamCloneData();            
        populateData(oppProdCloneMap.values(), oppTeamCloneMap.values());
    }
    
    //methods called on clicking Save from UI to update records in database
    public void Save(){
        refreshBeforeSave();
        System.debug('Save List : '+tempOppSplitMap.values());
        update tempOppSplitMap.values();
    }
    
    //method to populate Wrapper classes from the queried data 
    public void populateData(//List<LCRM_Opportunity_Split__c> oppSplitList, 
                             List<LCRM_Opportunity_Product_Clone__c> oppProdCloneList,
                             List<LCRM_Opportunity_Team_Clone__c> oppTeamCloneList){
        totalAmount = 0;
        OppTeamList = new List<OppTeam>();
        totalSalesCredit = 0;
        Set<String> OppTeamSet = new Set<String>();
        oppProdIDByTeamMemIDMap = new Map<String,List<String>>();
        Map<String,OppTeam> OppTeamMap = new Map<String,OppTeam>();
        oppProdByCatMap = new Map<String,OppProdByCat>();
        //outer loop for OLI Clone records
        for(LCRM_Opportunity_Product_Clone__c oppProdTemp : oppProdCloneList){
            String category = (oppProdTemp.LCRM_Product__r.LCRM_Product_Set__c == null || oppProdTemp.LCRM_Product__r.LCRM_Product_Set__c=='')?'blank#1':oppProdTemp.LCRM_Product__r.LCRM_Product_Set__c;
            String oppProdID = oppProdTemp.ID;
            String prodName = oppProdTemp.LCRM_Product__r.Name;
            String prodFamily = oppProdTemp.LCRM_Product__r.LCRM_Product_Category__c;
            String prodAction = oppProdTemp.LCRM_Action__c;
            Decimal prodCurrACV = oppProdTemp.LCRM_Current_ACV__c;
            Decimal prodNewACV = oppProdTemp.LCRM_New_ACV_SalesPrice__c;
            Decimal prodIncAmt = oppProdTemp.LCRM_Incremental_Amount__c;
            
            OppProdByCat oppProdByCatTemp;
            if(oppProdByCatMap.get(category)!=null){
                oppProdByCatTemp = oppProdByCatMap.get(category);
            }else{
                oppProdByCatTemp = new OppProdByCat();
                oppProdByCatTemp.category = category;
            }
            
            OppProd tempOppProd = new OppProd();
            tempOppProd.oppProdClone = oppProdTemp;
            oppProdByCatTemp.oppProdList.add(tempOppProd);
            oppProdByCatTemp.salesCreditTotalList.add(0);
            
            oppProdByCatTemp.prodIncAmtTotal += prodIncAmt;
            totalAmount += prodIncAmt;
            
            oppProdByCatMap.put(category,oppProdByCatTemp);
            
            Integer indexNo = 0;
            Boolean flag = false;
            for(OppProd tempStr : oppProdByCatTemp.oppProdList){
                if(tempStr.oppProdClone.ID == oppProdID){
                    flag = true;
                    break;
                }
                indexNo++;
            }
            //System.debug('flag : '+flag);
            //System.debug('indexNo : '+indexNo);
            List<String> teamMemIDList = new List<String>();
            oppProdIDByTeamMemIDMap.put(oppProdID,teamMemIDList);
            //inner loop for Opp Team REcords 
            for(LCRM_Opportunity_Team_Clone__c oppTeamTemp : oppTeamCloneList){
                String oppTeamId = oppTeamTemp.ID;
                String oppTeamName = oppTeamTemp.LCRM_User__r.Name;
                String oppTeamRepFunct = oppTeamTemp.LCRM_Rep_Function__c;
                LCRM_Opportunity_Split__c osTemp = tempOppSplitMap.get(oppProdTemp.ID+''+oppTeamTemp.ID);
                String splitID = 'NA';
                Integer oppSplitPer = 0;
                Decimal oppSplitCredit = 0;
                if(osTemp !=null){
                    splitID = osTemp.ID;
                    oppSplitPer = (osTemp.LCRM_Percent__c==null)?0:Integer.valueOf(osTemp.LCRM_Percent__c);
                    oppSplitCredit = (oppSplitPer*prodIncAmt)/100;
                }else{
                    osTemp = new LCRM_Opportunity_Split__c();
                }
                //System.debug('oppSplitCredit : '+oppSplitCredit);
                //System.debug('indexNo : '+indexNo+' size : '+oppProdByCatTemp.salesCreditTotalList.size());
                Decimal val = oppProdByCatTemp.salesCreditTotalList.get(indexNo);
                oppProdByCatTemp.salesCreditTotalList.set(indexNo,val+oppSplitCredit);
                oppProdByCatTemp.subTotal += oppSplitCredit;
                //System.debug('salesCreditTotalList : '+oppProdByCatTemp.salesCreditTotalList);
                OppTeam oTTemp;
                if(!OppTeamMap.keySet().contains(oppTeamId)){
                    oTTemp = new OppTeam(oppTeamId, oppTeamName, oppTeamRepFunct, oppSplitCredit);
                    OppTeamList.add(oTTemp);
                    OppTeamMap.put(oppTeamId,oTTemp);
                    totalSalesCredit += oppSplitCredit;
                }else{
                    oTTemp = OppTeamMap.get(oppTeamId);
                    oTTemp.totalSales += oppSplitCredit;
                    totalSalesCredit += oppSplitCredit;
                }
                if(oTTemp.oppSplitByCatList ==null){
                    oTTemp.oppSplitByCatList = new List<OppSplitByCat>();
                    OppSplitByCat splitCatTemp = new OppSplitByCat();
                    splitCatTemp.category = category;
                    oTTemp.categorySet.add(category);
                    oTTemp.oppSplitByCatList.add(splitCatTemp);
                }
                if(!oTTemp.categorySet.contains(category)){
                    OppSplitByCat splitCatTemp = new OppSplitByCat();
                    splitCatTemp.category = category;
                    oTTemp.categorySet.add(category);
                    oTTemp.oppSplitByCatList.add(splitCatTemp);
                }
                
                //System.debug('prodName : '+prodName);
                //System.debug('category : '+category);
                //System.debug('OppTeamList before : '+OppTeamList);
                //loop OppSplitByCat records to find index for specific category
                for(OppSplitByCat catTemp : oTTemp.oppSplitByCatList){
                    //System.debug('catTemp.category : '+catTemp.category);
                    if(catTemp.category == category){
                        //System.debug('catSize : '+catTemp.catSize);
                        catTemp.subTotal += oppSplitCredit;
                        //System.debug('catSize1 : '+catTemp.catSize);
                        OppSplit osplitTemp = new OppSplit();
                        osplitTemp.NewPerVal = String.valueOf(osTemp.LCRM_Percent__c);
                        osplitTemp.SalesCredit = oppSplitCredit;
                        osplitTemp.oppSplitClone = osTemp;
                        catTemp.oppSplitList.add(osplitTemp);
                        break;
                    }
                }
                teamMemIDList.add(oppTeamId);
            }
        }
        System.debug('OppTeamList : '+OppTeamList);
    }
    
    //method to get OppProdByCat wrapper data to display on UI
    public List<OppProdByCat> getOppProdByCatList(){
        //List<OppProdByCat> OppProdByCatList = new List<OppProdByCat>();
        //for(String  tempString : catList){
        //    OppProdByCatList.add(oppProdByCatMap.get(tempString));
        //}
        //System.debug('OppProdByCatList : '+OppProdByCatList);
        //return OppProdByCatList;
        return oppProdByCatMap.values();
    }
    
    //method to format decimal values as per user locale
    public String getDynamicFormatString()
    {
        Decimal value = 1000.10;
        String formattedValue = value.format();
        String thousandSep = formattedValue.substring(1,2);
        String decimalSep = formattedValue.substring(5,6);
        //return '{0,number,#'+thousandSep+'###'+thousandSep+'###'+thousandSep+'###'+thousandSep+'###'+thousandSep+'##0'+decimalSep+'00}';
        return '{0,number,#'+thousandSep+'###'+thousandSep+'###'+thousandSep+'###'+thousandSep+'###'+thousandSep+'##0}';
    }
    
    //method to return URL of Opp
    public PageReference Cancel(){
        PageReference pageRef = new PageReference('/'+opp.ID);
        return pageRef;
    }
    
    //wrapper to display row of team member
    public class OppTeam{
        public String memID{get;set;}
        public String name{get;set;}
        public String repFunct{get;set;}
        public Decimal totalSales{get;set;}
        public Set<String> categorySet{get;set;}
        public List<OppSplitByCat> oppSplitByCatList{get;set;}
        public Integer counter{get;set;}
        public oppTeam(){
            memID = '';
            name = '';
            repFunct = '';
            totalSales = 0;
            counter = 0;
            categorySet = new Set<String>();
            oppSplitByCatList = new List<OppSplitByCat>();
        } 
        public oppTeam(String memID, String name, String repFunct, Decimal totalSales){
            this.memID = memID;
            this.name = name;
            this.repFunct = repFunct;
            this.totalSales = totalSales;
            categorySet = new Set<String>();
            oppSplitByCatList = new List<OppSplitByCat>();
        } 
    }
    
    //wrapper to display header rows
    public class OppProdByCat{
        public String category{get;set;}
        //public List<LCRM_Opportunity_Product_Clone__c> oppProdCloneList{get;set;}
        public List<OppProd> oppProdList{get;set;}
        public Decimal prodIncAmtTotal{get;set;}
        public List<Decimal> salesCreditTotalList{get;set;}
        public Decimal subTotal{get;set;}
        
        public OppProdByCat(){
            prodIncAmtTotal = 0;
            subTotal = 0;
            category = '';
            //oppProdCloneList = new List<LCRM_Opportunity_Product_Clone__c>();
            oppProdList = new List<OppProd>();
            salesCreditTotalList = new List<Decimal>();
        }
    }
    
    //wrapper to hold single Opp Prod Clone
    public class OppProd{
        public LCRM_Opportunity_Product_Clone__c oppProdClone{get;set;}
        public String NewPerVal{get;set;}
        public OppProd(){
            NewPerVal='';
            oppProdClone = new LCRM_Opportunity_Product_Clone__c();
        }
    }
    
    //wrapper to hold split records by category
    public class OppSplitByCat{
        public String category{get;set;}
        public Decimal subTotal{get;set;}
        public List<OppSplit> oppSplitList{get;set;}
        //public List<LCRM_Opportunity_Split__c> oppSplitsList{get;set;}
        public OppSplitByCat(){
            category = '';
            subTotal = 0;
            oppSplitList = new List<OppSplit>();
            //oppSplitsList = new List<LCRM_Opportunity_Split__c>();
        }
    }
    
    //wrapper to hold single split record
    public class OppSplit{
        public LCRM_Opportunity_Split__c oppSplitClone{get;set;}
        public String NewPerVal{get;set;}
        public Decimal SalesCredit{get;set;}
        public OppSplit(){
            NewPerVal='';
            SalesCredit = 0;
            oppSplitClone = new LCRM_Opportunity_Split__c();
        }
    }
}