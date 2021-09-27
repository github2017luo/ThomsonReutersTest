/**
* @description
* Class: DCPConstants
* Created: 06/17/2021
* Author: Kavya Ganagaraju
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 06/17/2021   Kavya G          DCP-1693    Created
* =============================================================================
*/
/** 
 * @description : This is the class to serve constant values
 */ 
public without sharing class DCPConstants {
    //Currency ISO Codes
    Public Static final String USD_CURRENCYCODE = 'USD';
    Public Static final String CAD_CURRENCYCODE = 'CAD'; 

    //Lead Region
    Public Static final String UE_CAN_PRINT = 'UE Store Canada PRINT';

    //Sales Orgs
    Public Static final String SALESORG_WEST = 'West';
    Public Static final String SALESORG_CARS = 'CARS';

    //Business Units
    Public Static final String BU_USL    = 'USL';
    Public Static final String BU_CANADA = 'Canada';

    //Country Code
    Public Static final String US = 'US';
    Public Static final String CA = 'CA';


    //SSD Company Code

    Public Static final String USL_SSD_COMPANY_CODE = '0010';

    //Opportunity StageNames

    Public static final String APP_SCHEDULED = 'Appointment Scheduled';

    //other
    Public Static final String NA = 'NOT APPLICABLE';
    Public Static final String BILL_TO = 'BillTo';
    Public Static final String DIGITAL = 'Digital';
    /** 
     * @description : Constructor
     */ 
    public DCPConstants(){
        system.debug(LoggingLevel.INFO,'DCP Constant Class constructor');
    }
    
}