/**
* @author:        Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
* @company:       TCS
* @Date:          2020-02-03
* @Description:   A test class to test Campaign Custom Lookup functionality.
* @see 
* changelog
*/
@isTest
public class TR_TestCampaignLookupController {
      
    /**
    This method is used to set up the test data .
    * <p>since 47.0 (Force.com ApiVersion)</p>
    * <p>
    * changelog
    * <br> - 2020-02-03 Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
    * <br> -- Created
    * </p>
    * @author   Jayanth Kumar
    * @date     2020-02-03 
    */
    
    @testSetup static void setupTestData(){
        
        campaign cmp = new campaign();
        cmp.name = 'test';
        //cmp.OwnerId = usr.Id;
        cmp.StartDate = System.Today();
        cmp.EndDate =System.Today()+5;
        cmp.Status='Planned';
        cmp.IsActive=true;
        insert cmp;
    }
    
     /**
    * This method is used to test Custom Lookup functionality .
    * <p>since 47.0 (Force.com ApiVersion)</p>
    * <p>
    * changelog
    * <br> - 2020-02-03 Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
    * <br> -- Created
    * </p>
    * @author   Jayanth Shivanna
    * @date     2020-02-03  
    */
    
    @isTest static void testCampaignCustomLookupController (){
        
        TR_CampaignLookupController.fetchCampaignValues([SELECT Name FROM Campaign LIMIT 1].Name,'');
        System.assert([SELECT Name FROM Campaign]!=null,'Campaign name not found');
    }
    
        /**
    * This method is used to test Custom Lookup functionality with NULL Id.
    * <p>since 47.0 (Force.com ApiVersion)</p>
    * <p>
    * changelog
    * <br> - 2020-02-03 Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
    * <br> -- Created
    * </p>
    * @author   Jayanth Shivanna
    * @date     2020-02-03 
    */
    
    @isTest static void testCampaignCustomLookupControllerNullId(){ 
        try{
            TR_CampaignLookupController.fetchCampaignValues(null,'');
        }catch(Exception ex){
            System.assertNotEquals(ex.getMessage(), null);
        }
    }  
}