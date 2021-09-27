@isTest
public class CDSSearchServiceTest {
    
    public static testMethod void CDSSearchMethod(){
        try{
        CDSSearchService.GLI_Contact_Port gcp = new CDSSearchService.GLI_Contact_Port();
        gcp.GLI_Contact_Operation('Lead','1234','TestFirst','TestLast','test@123.com','123-456-9876',30,30);
        }catch(Exception e){
        string str = e.getMessage();
        }
        CDSSearchServiceWsdl.CDS_Output_Detail_element cdsOutputElement = new CDSSearchServiceWsdl.CDS_Output_Detail_element();
        cdsOutputElement.Source_System_ID = '12345';
        cdsOutputElement.Title = 'test';
        cdsOutputElement.First_Name  = 'test';
        cdsOutputElement.Last_Name= 'testLast';
        cdsOutputElement.Contact_Email= 'test@123.com';
        cdsOutputElement.Contact_Phone = '123456789';
        cdsOutputElement.Job_Function = 'Developer';
        cdsOutputElement.Account_Name = 'Test Account';
        cdsOutputElement.Account_Address = 'a 303';
        cdsOutputElement.City = 'San Jose';
        cdsOutputElement.State ='CA';
        cdsOutputElement.Country ='US';
        cdsOutputElement.ZIP_Code ='12345';
        cdsOutputElement.Party_ID ='54323';
        cdsOutputElement.PERSON_ID =32332321;
        cdsOutputElement.GLI_Account_ID = '434324234'; 
        
        CDSSearchServiceWsdl.GLI_Contact_Input gci = new CDSSearchServiceWsdl.GLI_Contact_Input();
        gci.Search_Type='Lead';
        gci.Global_Ultimate_Parent_ID='23321321';
        gci.First_Name='First';
        gci.Last_Name='Test';
        gci.Email_ID='abc@test.com';
            gci.Phone='121212';
        gci.GLI_Max_Count_Results=10;
        gci.Non_GLI_Max_Count_Results =10;
        
        CDSSearchServiceWsdl.CDS_Output_Summary_element gse = new CDSSearchServiceWsdl.CDS_Output_Summary_element();
        gse.CDS_Output_Summary ='test';
        gse.CDS_Output_Detail = null;
        
        CDSSearchServiceWsdl.GLI_Contact_Output gco = new CDSSearchServiceWsdl.GLI_Contact_Output();
        gco.CDS_Output_Summary=null;
        
        
    }
}