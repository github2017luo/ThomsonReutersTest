public class USL_writeOffController extends ESC_ComponentControllerBase{
 
    public string recid {get;set;}
    public string formsId {get;set;}
    public String totalamt {get;set;}
    public String Formtitle{get;set;}
    public String specificFormID;
    List<ESC_Case_Form_Extension__c> caseextlist;
    public ESC_Case_Form_Extension__c formext;
    public case caseAcc;
    USL_Integration_Defaults__c intval;
    public USL_writeOffController(){
            totalamt = '0';
            
    
    }
   public void getCals(){
        calculate();
    }
    public void calculate(){
        totalamt = '0';
        caseAcc = new Case();
        ESC_SectionDescriber formBU;            
        ESC_FormGenratorController compcon = (ESC_FormGenratorController)pagecontroller;      
        ESC_SectionDescriber secdesc;
        formBu = compcon.sectionDescriberMap.get('Sec-0070'); 
        ESC_Case_Form_Extension__c lineitemlist1 = (ESC_Case_Form_Extension__c)formBu.sobj;
        //system.debug('@@ lineitemlist1 :' +lineitemlist1.ESC_Form_BU__c);
        if(lineitemlist1!=null && lineitemlist1.ESC_Form_BU__c!=null && lineitemlist1.ESC_Form_BU__c.startsWith('Tax Profs')){
            secdesc = compcon.sectionDescriberMap.get('Sec-0081'); 
            
        }else{
            secdesc = compcon.sectionDescriberMap.get('Sec-0080'); 
            
        }
        List<ESC_Case_Form_Extension_Line_Item__c> lineitemlist = secdesc.sobjlist;
        for(ESC_Case_Form_Extension_Line_Item__c lineitem : lineitemlist ){
            system.debug('amount is'+lineitem.Amount_to_Pay__c);
            if(lineitem.Amount_to_Pay__c !=null){
            totalamt = String.valueof(double.valueof(totalamt) + double.valueof(lineitem.Amount_to_Pay__c));
           
            }
            else
            system.debug('lineitem.Amount_to_Pay__c with null'+lineitem);
        }
         compcon.singleExtension.USL_Total_Amount__c = double.valueof(totalamt);
        system.debug('total amt is'+totalamt);
   
            
    }
    
}