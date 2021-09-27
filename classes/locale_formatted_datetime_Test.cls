@isTest
private class locale_formatted_datetime_Test {
    
    static testMethod void test_logic() {
        //test for English (United States) format
        List<User> userUpdate = new List<User>(); //list for holding user updates
        userUpdate.add(new User(Id = UserInfo.getUserId(), LocaleSidKey = 'en_US')); //set the locale for the running user to English (United States)
        update userUpdate; //make the update
        Locale_Formatted_DateTime_Controller controller = new Locale_Formatted_DateTime_Controller();
        controller.date_time = Date.valueOf('2007-1-1'); //set the datetime variable to 1 January 2007
        String test_value = controller.getTimeZoneValue(); //run the logic and format the datetime value
        //System.assertEquals('1/1/2007', test_value); //validate the results
        
       
    }
}