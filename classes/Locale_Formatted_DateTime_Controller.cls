/*

This Apex Class can be used to format the DateTime format into the current user's locale.
It is being used in visualforce component "Locale_Formatted_DateTime".
In order to translate the date into an specific locale, you just need to provide it into the map inside the method MapValues() below.

 @author  Sudhir Kumar
 @version 02-Sep-2013


*/



public class Locale_Formatted_DateTime_Controller {
    
    public DateTime date_time { get; set; } //property that reads the datetime value from the component attribute tag
    public String locale_formatted_date_time_value ;
    public String datetime_format;
    
    //returns the properly formatted datetime value
    
    public String getTimeZoneValue() {
        if(date_time != null){    
            Map<String, String> mappedValues = new Map<String, String>(); //map for holding locale to datetime format
            mappedValues = MapValues(); //populate the map with all the locale specific datetime formats
            String user_locale = UserInfo.getLocale(); //grab the locale of the user
            String datetime_format = 'M/d/yyyy'; //variable for the datetime format defaulted to the US format
            
            system.debug('user_locale:' +user_locale);
            
            if (mappedValues.containsKey(user_locale)) { //if the map contains the correct datetime format
            
            
                datetime_format = mappedValues.get(user_locale); //grab the datetime format for the locale
            }
    
            String locale_formatted_date_time_value = date_time.format(datetime_format);  //create a string with the proper format            
            return locale_formatted_date_time_value; //return the string
        }
        else return null;
    }
    
    //populate a map with locale values and corresponding datetime formats
    private Map<String, String> MapValues() {
        Map<String, String> locale_map = new Map<String, String>(); //holds the locale to timedate formats
        locale_map.put('en_US', 'M/d/yyyy');
        locale_map.put('es', 'd/MM/yyyy');
        locale_map.put('pt_BR', 'dd/MM/yyyy');

        return locale_map; //return the map
    }

}