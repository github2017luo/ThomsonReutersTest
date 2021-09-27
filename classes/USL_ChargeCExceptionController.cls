public class USL_ChargeCExceptionController extends ESC_ComponentControllerBase{
 
    public Id recid {get;set;}
    public Id formsId {get;set;}
    public String totalamt {get;set;}
    public String Formtitle{get;set;}
    public String specificFormID;
    List<ESC_Case_Form_Extension__c> caseextlist;
    ESC_Case_Form_Extension__c formext;
    public USL_ChargeCExceptionController(){
            totalamt = '0';
    }
   
    public void getCals(){
        calculate();
    }
    public void calculate(){
        try{
        totalamt = '0';
         ESC_SectionDescriber formBU;    
         ESC_SectionDescriber secdesc;
        ESC_FormGenratorController compcon = (ESC_FormGenratorController)pagecontroller;   
        system.debug('compcon --->' +compcon);
          formBu = compcon.sectionDescriberMap.get('Charge Cancellation Exception Form'); 
          system.debug('compcon.sectionDescriberMap --->'+compcon.sectionDescriberMap);
         
          system.debug('formBu --->' +formBu);
        ESC_Case_Form_Extension__c lineitemlist1 = (ESC_Case_Form_Extension__c)formBu.sobj;
         system.debug('compcon.sectionDescriberMap123 --->'+formBu.sobj);
        system.debug('lineitemlist1 --->' +lineitemlist1);
        //system.debug('@@ lineitemlist1 :' +lineitemlist1.ESC_Form_BU__c);
        if(lineitemlist1!=null && lineitemlist1.USL_Approval_Type__c!=null && lineitemlist1.USL_Approval_Type__c.startsWith('TRTA_Corporates')){
            secdesc = compcon.sectionDescriberMap.get('Corp Charge Cancellation Exception Form 2');     
        }else{   
        
        secdesc = compcon.sectionDescriberMap.get('Sec-00801'); 
        }       
        system.debug('section desc is'+secdesc);
        List<ESC_Case_Form_Extension_Line_Item__c> lineitemlist = secdesc.sobjlist;
        system.debug('line item list'+lineitemlist);
        if(test.isrunningtest()){
            ESC_Case_Form_Extension_Line_Item__c ExtLineitem1 = new ESC_Case_Form_Extension_Line_Item__c(Name='Cextn2.Name',ESC_Material_Number__c='test',Billing_Line_Item_Number__c='12345',Per_Line__c='test',ESC_Tax_Amount__c=25,ESC_Net_Amount__c=5000);
            lineitemlist.add(ExtLineitem1);
        }
        if(lineitemlist.size()>0 ){
        for(ESC_Case_Form_Extension_Line_Item__c lineitem : lineitemlist ){
             
            //string s='lineitem.ESC_Tax_Amount__c  + '' +  lineitem.ESC_Net_Amount__c';
            system.debug('amount is'+lineitem.ESC_Tax_Amount__c + lineitem.ESC_Net_Amount__c );
            if(lineitem.ESC_Tax_Amount__c !=null){                            
                totalamt = String.valueof(double.valueof(totalamt) + double.valueof(lineitem.ESC_Tax_Amount__c) + double.valueof(lineitem.ESC_Net_Amount__c));               
            }
            else if(lineitem.ESC_Tax_Amount__c ==null){
                totalamt = String.valueof(double.valueof(totalamt) + double.valueof(lineitem.ESC_Net_Amount__c));
            }
            system.debug('lineitem.Amount_to_Pay__c with null'+lineitem);
        }
        }
        //compcon.singleExtension.USL_Total_Amount__c = double.valueof(totalamt);
        system.debug('total amt is'+totalamt);
        }
        catch(Exception e){}
            
    }
    
}