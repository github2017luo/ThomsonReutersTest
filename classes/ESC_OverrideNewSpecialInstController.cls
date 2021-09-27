/*--**********************************
Page Name: OverrideNewSpecialInstrution
Purpose: Contoller for "OverrideNewSpecialInstrution" page  to override a new Special Instuction when invoked from New button
Author:Mousumi Panda
Date Created:18/05/2017
Date Updated:V0:
***********************************/

public class ESC_OverrideNewSpecialInstController {

string recordtypeid;
public Boolean errormessage{get;set;}
public String prefix;
Map<String, String> allParameters = new Map<String, String>();
public String parentId{get;set;}
//String Accountid;


    public ESC_OverrideNewSpecialInstController(ApexPages.StandardController controller) {
       allParameters = ApexPages.currentPage().getParameters();
       
       ESC_Static_Values__c escStatic1 = ESC_Static_Values__c.getValues('ContactNameId');
       ESC_Static_Values__c escStatic2 = ESC_Static_Values__c.getValues('AccountNameId');
       
        if(allParameters.containsKey(escStatic1.ESC_Value__C+'_lkid')){
                    parentId= allParameters.get(escStatic1.ESC_Value__C+'_lkid');
        }
         if(allParameters.containsKey(escStatic2.ESC_Value__C+'_lkid')){
                   parentId=allParameters.get(escStatic2.ESC_Value__C+'_lkid');
         } 
    }
    
     public PageReference redirctToSPInstruvtion(){
         errormessage=false; 
         if(allParameters.isEmpty() || !allParameters.containsKey('RecordType')){
             errormessage = true;
              return null;
          }
          else{
              String url='';
              for(String str: allParameters.keyset()){
                  url+='&'+str+'='+allParameters.get(str);
              }
              prefix = Schema.getGlobalDescribe().get('ESC_Special_Instruction__c').getDescribe().getKeyPrefix();
              return new PageReference('/'+prefix+'/e?'+url.substring(1));
          }
     
     }
    
    /*public PageReference onGoBack(){
        PageReference pageRef = new  PageReference('/'+parentId);
        pageRef.setRedirect(True);
        return pageRef;
    }*/

}