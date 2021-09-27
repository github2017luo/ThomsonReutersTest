@isTest(seeAllData=false)
public class DCPConstantsTest {
    
    @isTest public static void testDCPConstants(){
        test.starttest();
         DCPConstants dcp;
         dcp = new DCPCOnstants();
         system.assert(DCPConstants.NA!=null,'NOT APPLICABLE');
         system.assert(DCPConstants.USD_CURRENCYCODE!=null,'USD');
         system.assert(DCPConstants.CAD_CURRENCYCODE!=null,'CAD');
         system.assert(DCPConstants.UE_CAN_PRINT!=null,'UE Store Canada PRINT');
         system.assert(DCPConstants.SALESORG_WEST!=null,'West');
         system.assert(DCPConstants.SALESORG_CARS!=null,'CARS');
         system.assert(DCPConstants.BU_USL!=null,'USL');
         system.assert(DCPConstants.BU_CANADA!=null,'Canada');
         system.assert(DCPConstants.USL_SSD_COMPANY_CODE!=null,'0010');
         system.assert(DCPConstants.APP_SCHEDULED!=null, 'Appointment Scheduled');
         system.assert(DCPConstants.BILL_TO!=null, 'BillTo');
         system.assert(DCPConstants.DIGITAL!=null, 'Digital');
         system.assert(DCPConstants.US!=null,'US');
        test.stoptest();
         
    }   

}