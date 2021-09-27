/* Class: LTGS_NewOpportunity_Test
 * Purpose: To cover all the scenarios of classe:LTGS_NewOpportunity.
 * Created: 02/26/2019
 * Author: Vaishali Gayatri 
 * 
 */
@Istest(SeeAllData=false)

public class LTGS_NewOpportunity_Test {
    @IsTest(SeeAllData= false)
/********************************************************************************************************
 setdata: Method to create dummy Account and Contact.
********************************************************************************************************/    
    public static void setdata(){
        Account acc = new Account();
        acc.Name = 'Apple';
        
        insert acc;
           Contact con = new Contact();
           con.AccountId=acc.id;
           con.FirstName='Test';
           con.LastName='Contact';
           insert con;
        
       
        
       LTGS_NewOpportunity.getSObjDetails(con.id); 
       LTGS_NewOpportunity.getOppRecordTypeID();
            
    }
    

}