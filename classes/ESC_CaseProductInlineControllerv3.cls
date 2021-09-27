/***********************************************
Name : ESC_CaseProductInlineControllerv3
Description : Adds new rows to add additional Case_Product
return Type : void
 ***********************************************/
Global with sharing class ESC_CaseProductInlineControllerv3 {

    public List<CPClass> cpList{get;set;}
    @TestVisible private Integer mcount = -1;
    public Boolean showbutton{get;set;}
    public Boolean refreshPage {get; set;} 
    public String caseid {get; set;} 
    public String pageUrl {set;}
    public String products {get; set;}
    public String selectedCriteria {get; set;}
    public String primaryProduct {get; set;}
    public integer primaryProductIndex {get; set;}
    public String searchTerm {get; set;}
    public String selectedProduct {get;set;}
    public Boolean showCapabiity { get; set;}
    public Boolean showVersion { get; set;}
    public Boolean showPrimary { get; set;}
    public String selectedCapability {get; set;}
    public String selectedVersion {get; set;}
    public Boolean isCaseClosed {get; set;}

    @TestVisible private ApexPages.StandardController controller {get; set;}
    @TestVisible private Case c;

    Public List<Schema.FieldSetMember> dispfieldset = new List<Schema.FieldSetMember>();
    Public Static List<Schema.FieldSetMember> searchfieldset = new List<Schema.FieldSetMember>();
    Public Static ESC_ProductFieldSetting__c fldSetting;
    Public Static ESC_ProductLineItemFieldSetting__c productLIfldsetting;
    public string getPrimaryPDCTX(){
        system.debug('getPrimaryPDCTX:' + primaryProduct);
        return primaryProduct;
    }
    public class CPClass{
        public ESC_Case_Product__c cp{get;set;}
        public Integer count{get;set;}
        public Boolean edit{get;set;}
    }
    public List<Schema.FieldSetMember> getFields() {
        return dispfieldset;
    }
    public ESC_CaseProductInlineControllerv3 (ApexPages.StandardController controller){
this.controller = controller;
init();
    }
    
    public void init(){
        mcount = 0;
            primaryProduct ='';   
        cpList = new List<CPClass>();
        primaryProductIndex = -1;
        
        this.c = (Case) controller.getRecord();
        Map<string,Boolean> fieldVisibilityMap= ESC_UserUtilityClass.getobjectFieldAccessMap('ESC_Case_Product__c');
        system.debug('fieldVisibilityMap'+fieldVisibilityMap);
        showCapabiity = fieldVisibilityMap.get('product_capability__c');
        showVersion =  fieldVisibilityMap.get('product_version__c');
        showPrimary = fieldVisibilityMap.get('is_primary__c');
        caseId = c.Id;
        List<Case> lstCase = new List<Case>();
        if(Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isQueryable()){
         lstCase = [Select Id, isClosed from Case where id = :caseId LIMIT 1];
        }
        if(lstCase != null && lstCase.size() > 0){
            isCaseClosed = lstCase[0].isClosed;
        }
        fldSetting = ESC_ProductFieldSetting__c.getInstance(UserInfo.getProfileID());
        productLIfldsetting= ESC_ProductLineItemFieldSetting__c.getInstance(UserInfo.getProfileID());
        if(productLIfldsetting != null && productLIfldsetting.ESC_DisplayProdLItemFieldset__c != null){
            dispfieldset = ESC_Utility.readFieldSet(productLIfldsetting.ESC_DisplayProdLItemFieldset__c,'ESC_Case_Product__c');
        }
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : dispfieldset) {
            query += f.getFieldPath() + ', ';
        }
        
        system.debug('query with field set>>>>>'+query);
        query += 'Id, Name,Is_Primary__c,Case__c,Product__c,Product_Capability__c,Product_Version__c,Product_Code__c  from ESC_Case_Product__c where Case__c = ';
        query+=':caseId order by lastmodifieddate';//':'+c.Id;
        for(ESC_Case_Product__c cp : Database.query(String.escapeSingleQuotes(query))){
            mcount++;
            system.debug('mcount' + mcount);
            CPClass cObj = new CPClass();
            cObj.count = mcount;
            cObj.cp = cp;
            cObj.edit = false;
            cpList.add(cObj); 

            if(cp.Is_Primary__c ){
                primaryProduct = cp.id;
                primaryProductIndex = mcount ; 
                system.debug('primaryProductIndex' + primaryProductIndex);
            }

        }   

        addRows();
        selectedCriteria = getsearchfielddata();
    }

    /***********************************************
Name : getAllProducts
Description : gets all products in json form 
return Type : void
     ***********************************************/
    public string getAllProducts(){
      if (Schema.sObjectType.Product2.isAccessible()){
        List<Product2> productList = [Select id,name from Product2 where IsActive = true];
      }
        return '';
    }

    public String getsearchfielddata(){
        if(fldSetting != null && fldSetting.ESC_ProductSearchFieldset__c != null){
            searchfieldset = ESC_Utility.readFieldSet(fldSetting.ESC_ProductSearchFieldset__c,'Product2');
        }
        String temp='';    
        for(Schema.FieldSetMember f : searchfieldset) {
            temp = temp == ''?f.getFieldPath():  temp + ' or ' + f.getFieldPath();

        }
        return temp;
    }
    @RemoteAction
    Global static List<Product2> searchProduct(String searchTerm) {
        List<Product2> productList = new List<Product2>();
        ESC_ProductFieldSetting__c fldSetting = ESC_ProductFieldSetting__c.getInstance(UserInfo.getProfileID());
        if(fldSetting != null && fldSetting.ESC_ProductSearchFieldset__c != null){
            searchfieldset = ESC_Utility.readFieldSet(fldSetting.ESC_ProductSearchFieldset__c,'Product2');
        }
        String temp = '';
        List<String> lstflds = new List<String>();
        for(Schema.FieldSetMember f : searchfieldset) {
            temp = temp == ''?f.getFieldPath():  temp + ',' + f.getFieldPath();
            lstflds.add(f.getFieldPath());
        }
        String temps = '';
        if(searchTerm.length() >=2 ){
            //string fieldsToBeReturned = 'id, Name ,ProductCode ';
            string fieldsToBeReturned = temp;
            for(String s:lstflds){
                temps = temps =='' ? s + ' like \'%'+String.escapeSingleQuotes(searchTerm) +'%\'': temps + ' or ' + s + ' like \'%'+String.escapeSingleQuotes(searchTerm) +'%\'';
            }
            string filterSecondary = temps;
            //string filterSecondary =  ' name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\' or ProductCode like \'%' + //String.escapeSingleQuotes(searchTerm) + '%\'';
            string limitClause = ' limit 2000';
            string mainSearchKeyword = '\'*' +String.escapeSingleQuotes(searchTerm)+'*\'';
            string query = 'FIND '+mainSearchKeyword +' IN ALL FIELDS RETURNING Product2('+fieldsToBeReturned+' where '+filterSecondary+')' +limitClause;
            System.debug('query>>>'+query );
            productList = search.query(query)[0];
            System.debug('searchList Name is: '+productList );
            // List<Product2> productList = Database.query('Select Id, Name from Product2 where name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\'');
            String temp2;
            for(Product2 pdct : productList){
                //pdct.Name = '[Name : '+pdct.name +'] [ProductCode : ' + pdct.ProductCode+']';
                temp2='';
                for(String s:lstflds){
                    temp2 = temp2 == ''? '['+s+' : '+pdct.get(s) +']':temp2 + ' '+'['+s+' : '+pdct.get(s) +']';
                }
                pdct.Name = temp2;
            }}
        return productList;
    }

    public List<SelectOption> getCapabilities() {
        System.debug('selectedProduct is: '+ selectedProduct );
        List<SelectOption> options = new List<SelectOption>();
        if(string.isNotBlank(selectedProduct)){
            for(ESC_Product_Capability__c pc: [Select Id, Name from ESC_Product_Capability__c where ESC_Product__c = :selectedProduct]){
                options.add(new SelectOption(pc.id,pc.name));
            }
        }

        return options;
    }

    public List<SelectOption> getVersions() {
        System.debug('selectedProduct is: '+ selectedProduct );
        List<SelectOption> options = new List<SelectOption>();
        if(string.isNotBlank(selectedProduct)){
            for(ESC_Product_Version__c pc: [Select Id, Name from ESC_Product_Version__c where ESC_Product__c = :selectedProduct]){
                options.add(new SelectOption(pc.id,pc.name));
            }
        }
        return options;
    }

    /***********************************************
Name : addRows
Description : Adds new rows to add additional Case Products
return Type : void
     ***********************************************/
    public void addRows(){

        mcount++;
        selectedProduct ='';
        searchTerm ='';
        Integer i =0;
        Boolean flag = false;
        if((cpList.size() >0 && string.isNotBlank(cpList.get(cpList.size()-1).cp.id)) || cpList.size() ==0){
            CPClass cObj = new CPClass();
            cObj.count = mcount;
            cObj.cp = new ESC_Case_Product__c();
            cObj.edit = true;
            cpList.add(cObj); 
        }
    }


    /***********************************************
Name : delRows
Description : Deletes rows
return Type : void
     ***********************************************/
    public void delRows(){
         TRY{
        List<ESC_Case_Product__c> deletedCP = new List<ESC_Case_Product__c>();
        String rowIdString = ApexPages.currentPage().getParameters().get('delrowid');
        Integer rowId = Integer.valueOf(rowIdString)-1;
        if(cpList.get(rowId).cp.Id != null){
            deletedCP.add(cpList.get(rowId).cp);
        }  
        cpList.remove(rowId);
        mcount--;
       
       if (Schema.sObjectType.ESC_Case_Product__c.isDeletable()){
            delete deletedCP;
       }
            init();
        }
        catch(Exception ex){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,ex.getmessage()));
        }
    }

    /***********************************************
Name : cancelRows
Description : This method is called on click of cancel button to change the inputtext field to outputtext field
return Type : void
     ***********************************************/
    public void cancel(){
        String rowIdString = ApexPages.currentPage().getParameters().get('cancelrowid');
        Integer rowId = Integer.valueOf(rowIdString)-1;

        try{
            cpList.get(rowId).edit = false; 
        }
        catch(Exception ex){
            rowId = cpList.size()-1;
            cpList.get(rowId).edit = false; 
        }
        if(string.isBlank(cpList.get(rowId).cp.id)){
            cpList.remove(rowId);
        }


    }

    /***********************************************
Name : editRows
Description : This method is called on click of edit button to change the outputtext field to inputtext field
return Type : void
     ***********************************************/
     
     public void populateModifiedRowData(integer rowID, string recordID){
         system.debug(recordID+' @@have To Modify at rowid: '+rowid);
        init();
     }
    public void edit(){
        String rowIdString = ApexPages.currentPage().getParameters().get('editrowid');


        for(CPClass cpObj:cpList ){
            cpObj.edit = false;
        }
        Integer rowId = Integer.valueOf(rowIdString)-1;
        cpList.get(rowId).edit = True;
        selectedProduct = cpList.get(rowId).cp.Product__c;
        selectedVersion = cpList.get(rowId).cp.Product_Version__c;
        selectedCapability = cpList.get(rowId).cp.Product_Capability__c;
        searchTerm = ([select name from Product2 where id = : selectedProduct])[0].name;
        System.debug('rowId is : '+ rowId + ' listSIze: ' +cpList.size() );
        if(string.isBlank(cpList.get(cpList.size()-1).cp.id) && rowId !=cpList.size()-1) {
            cpList.remove(cpList.size()-1);
        }
    }

    /***********************************************
Name : saveRelatedRecord
Description : This method is used to save a record in edit mode. 
return Type : void
     ***********************************************/
    public void saverelatedrecord(){
        System.debug('rowId is : '+ ApexPages.currentPage().getParameters().get('saverowid') );
        System.debug('saverelatedrecord is called: '+ cpList.size() +cpList );
        String rowIdString = ApexPages.currentPage().getParameters().get('saverowid');
        Integer rowId = Integer.valueOf(rowIdString);
        List<ESC_Case_Product__c> toUpdateList = new List<ESC_Case_Product__c>();
        ESC_Case_Product__c selectedCP = new ESC_Case_Product__c();
        if(selectedProduct.length() ==18){
            try{
                cpList.get(rowId).edit = false; 
                selectedCP =  cpList.get(rowId - 1 ).cp; 
            }
            catch(Exception ex){
                rowId = cpList.size()-1;
                cpList.get(rowId).edit = false; 
                selectedCP =  cpList.get(rowId ).cp; 
                System.debug('Exception1 '+ ex.getmessage() );
            }
            try{
            System.debug('cpList:- '+cpList);
                //ESC_Case_Product__c selectedCP =  cpList.get(rowId ).cp;  
                System.debug('selectedCP '+selectedCP );
                if(selectedCP != null){
                    if(selectedCP.case__c == null){
                        selectedCP.case__c = c.Id;
                    }
                    selectedCP.Product__c = selectedProduct;
                    selectedCP.Product_Version__c = selectedVersion;
                    selectedCP.Product_Capability__c = selectedCapability;
                    toUpdateList.add(selectedCP);
                    string optOutID = string.isBlank(selectedCP.id)? 'xxxxxxxxxxxxxxxxxx':selectedCP.id;
                    system.debug('rowId' + rowId);
                    system.debug('primaryProductIndex' + primaryProductIndex);
                    system.debug('seelcted id' + optOutID);
                    system.debug('primaryProduct old' + primaryProduct);
                    if(selectedCP.Is_Primary__c == true ){
                        if( string.isNotBlank(primaryProduct) && primaryProductIndex !=-1 && primaryProductIndex != rowId ){
                            ESC_Case_Product__c toModifyOld =  cpList.get(primaryProductIndex).cp;
                            toModifyOld.Is_Primary__c = false;
                            for(ESC_Case_Product__c ecp: [select Is_Primary__c from ESC_Case_Product__c where Is_Primary__c = true and case__c = :c.Id and id != :optOutID ]){

                                ecp.Is_Primary__c = false;
                                toUpdateList.add(ecp);
                                system.debug('ecp' + ecp);

                            }

                        }
                    }


          if (Schema.sObjectType.ESC_Case_Product__c.isUpdateable() || Schema.sObjectType.ESC_Case_Product__c.isCreateable()){
                    upsert toUpdateList ;
          } 
                    if(selectedCP.Is_Primary__c == true ){
                        primaryProductIndex = rowId;

                        primaryProduct = selectedProduct;
                    }
                    else if(rowId == primaryProductIndex){
                        primaryProductIndex = -1;
                        primaryProduct ='';
                    }
                    populateModifiedRowData(rowId , toUpdateList[0].id);

                    System.debug('toUpdateList '+toUpdateList );
                    addRows();

                }}
            catch(Exception ex){
                System.debug('Exception2 '+ ex.getmessage() );
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,ex.getmessage()));
                /*  if(rowId == cpList.size()-1)
{
cpList.remove(rowId);
}
addRows(); */
            }
        }
        else{
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,ESC_DataTableEntity.getLabelValue('ESC_InvalidProduct') )); 
        }
    }


   /* public PageReference shownewPrimary(){      
        //refreshPage=true;
        //addRows();
        system.debug('inside ShownewPrimary()');
        PageReference pageRef = new PageReference('/apex/ESC_CaseProductInline?id=' + caseId);
        pageRef.setRedirect(true);
        system.debug(pageRef);
        return pageRef;
    }*/

    public void getlatestdata(){
        fldSetting = ESC_ProductFieldSetting__c.getInstance(UserInfo.getProfileID());
        if(fldSetting != null && fldSetting.ESC_DisplayFieldsetName__c != null){
            dispfieldset = ESC_Utility.readFieldSet(fldSetting.ESC_DisplayFieldsetName__c,'Product2');
        }
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : dispfieldset) {
            query += ' product__r.'+String.escapeSingleQuotes(f.getFieldPath()) + ', ';
        }
       // caseId = String.escapeSingleQuotes(caseId);
        query += 'Id, Name,Is_Primary__c,Case__c,Product__c,Product_Capability__c,Product_Version__c,Product_Code__c  from ESC_Case_Product__c where Case__c = ';
        query+=':caseId';//':'+c.Id;
        
        for(ESC_Case_Product__c cp : Database.query(String.escapeSingleQuotes(query))){
            mcount++;
            system.debug('mcount' + mcount);
            CPClass cObj = new CPClass();
            cObj.count = mcount;
            cObj.cp = cp;
            cObj.edit = false;
            cpList.add(cObj); 

            if(cp.Is_Primary__c ){
                primaryProduct = cp.id;
                primaryProductIndex = mcount ; 
                system.debug('primaryProductIndex' + primaryProductIndex);
            }

        }   
    }
}