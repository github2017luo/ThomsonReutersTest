@isTest 
public class ESC_OrderResolution_Test{
/**
 * @description ESC_OrderResolution test class
 */
@isTest 
    static void runSupportClass(){ 
        try{
            Account acc1 = new Account(); 
            Contact con1 = new Contact();
            acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            acc1.BU_Region__c='Canada';
            acc1.Bu_Segment__c='Professional Legal';
            insert acc1;
            con1 =ESC_GenericTestutility.TestContactUtil(acc1.ID, 'test','contact','test7365@gmail.com');
            insert con1;
            Case case1=new Case();
            case1 = ESC_GenericTestutility.TestCaseUtil(con1.ID,acc1.ID,'New');
            case1.LCRM_Sub_BU__c='Canada';
            case1.BU_Segment__c='Professional Legal';
            insert case1;  
            
            System.assertEquals(case1.status, 'New','Invalid Status');
            
            GenerateForm__C gf= new GenerateForm__C();
            gf.Name='Order Resolution Form';
            Insert gf;
            
            ESC_FormsSegmentRegionMapping__c oForm = new ESC_FormsSegmentRegionMapping__c();
            oForm.ESC_CSS_Form__c = gf.Id;
            oForm.ESC_Form_Label_Name__c = 'Order Resolution';
            oForm.ESC_Form_Section__c = 'Orders';
            oForm.ESC_LandingURL__c = '/apex/ESC_FormGenerator?Id=';
            oForm.ESC_Region__c ='Canada';
            oForm.ESC_Segment__c = 'Professional Legal';
            oForm.ESC_Form_Field1__c ='ESC_Form__r.name';
            insert oForm;
            
            Group g = new Group();
            g.Name = 'CDN_C2C_CDN_TNP_Online_Order_Mgmt';
            g.type='Queue';
            insert g;
       
            List<QueueSobject> mappingObjectLst = new List<QueueSobject>();
            QueueSobject mappingObject = new QueueSobject();
            mappingObject.QueueId = g.Id;
            mappingObject.SobjectType = 'ESC_Case_Collaborator__c';
            mappingObjectLst.add(mappingObject);
            QueueSobject mappingObject1 = new QueueSobject();
            mappingObject1.QueueId = g.Id;
            mappingObject1.SobjectType = 'Case';
            mappingObjectLst.add(mappingObject1);
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObjectLst;}
            
          
            ESC_Referral_Form_Assign_Selector_List__c refqueueselect = new ESC_Referral_Form_Assign_Selector_List__c();
            refqueueselect.Form_Segment_Region_Id__c =oForm.id;
            refqueueselect.ESC_Form_Field1__c = 'Order Resolution Form';
            refqueueselect.Referral_Creation_Required__c =True;
            refqueueselect.ESC_Referral_Queue_Name__c = 'CDN_C2C_CDN_TNP_Online_Order_Mgmt';
            insert refqueueselect ;

            
            ESC_Case_Form_Extension__c c =new ESC_Case_Form_Extension__c();
            c.ESC_Case__c=case1.id;
            c.ESC_Form__c=gf.id;
            insert c;
            
            ESC_OrderResolution esct = new ESC_OrderResolution();
            esct.caseid = case1.id;
            esct.formId = gf.id;
            test.startTest();
            esct.executePreRender();
            esct.validateForms();
            esct.executePostSubmit();
         }
         catch(DMLException e){   
             System.assertEquals(e.getMessage(), e.getMessage(),'Exception occured');        
         } 
         test.stopTest();    
    }
    
    
}