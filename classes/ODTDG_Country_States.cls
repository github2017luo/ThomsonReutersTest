/*
Author : Mallikarjuna Rao
Date: May 2021
Description: This  class is a webservice to return the country and state related details.
Returns: JSON object data class WrapperCountry
@description webservice to return the country and state related details 
*/
/********************************************************************************************************
*  @description ODTDG_Country_States : to Retrieve already added users / Invited users in Trial
*********************************************************************************************************/
@RestResource (urlMapping='/ODTDGCountryStates/*')
global class ODTDG_Country_States {
    
    /********************************************************************************************************
*  @description getCountryRegions: This method returns the related country details 
* @return WrapperCountry as a service response we will share the country or state details if any 
*********************************************************************************************************/ 
    @HTTPGet
    global static WrapperCountry getCountryRegions(){
        
        RestRequest countryRequest = RestContext.request;
        
        Map<String,String> countryParams = countryRequest.params;
        String country = countryParams.get('countryCode');        
        
        ODTDG_AEMdata js = new ODTDG_AEMdata(country);
        js.parse();
        List<ODTDG_AEMdata.Countries> c = js.allCountries;
        List<ODTDG_AEMdata.States> s = js.allStates;
        WrapperCountry wapCou = new WrapperCountry(c,s);
        return wapCou;            
    }
    
  /********************************************************************************************************
*  @description WrapperCountry: Wrapper class for country details 
*********************************************************************************************************/ 
    global class WrapperCountry{
        
/********************************************************************************************************
*  @description countries : Wrapper class for country details 
*********************************************************************************************************/
        global List<ODTDG_AEMdata.Countries> countries {set;get;}   
/********************************************************************************************************
*  @description states : Wrapper class for country details 
*********************************************************************************************************/     
        global List<ODTDG_AEMdata.States> states {set;get;} 
        
        /********************************************************************************************************
        *  @description WrapperCountry: Constructor for country details 
        * @param c : country list
        * @param s : state list
        *********************************************************************************************************/        
        public  WrapperCountry(List<ODTDG_AEMdata.Countries> c, List<ODTDG_AEMdata.States> s){           
            
            this.countries = c;            
            this.states = s;
        }
    }
    
}