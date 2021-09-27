/******************************************************************
 * @description ODTDG_AEMdata: class for state country list call
 ******************************************************************/
public with sharing class ODTDG_AEMdata {
    
    String jsonobj;
    public List<States> allStates = new List<States>();
    public List<Countries> allCountries = new List<Countries>();
    List<Country__c> counts {set;get;}   
    List<Country_Region__c> stats {set;get;}   

/********************************************************************************************************
*  @description ODTDG_AEMdata: Method to list state 
*  @param country : this will accept the country 
*********************************************************************************************************/ 
    public ODTDG_AEMdata(String country){
        List<String> allCons;
        if(country!=null){
            allCons = country.Split(','); 
        }
        if(Schema.sObjectType.Country__c.isQueryable()){
        List<Country__c> countryList = [Select Name, Country_Code__c from Country__c where Country_Code__C IN :allCons And IsActive__c= true];
        this.counts = countryList;
        }
        if(Schema.sObjectType.Country_Region__c.isQueryable()){
        List<Country_Region__c> stateList = [Select Name,Region_Code__c, Region_Name__c,Country_Code__c from Country_Region__c where Country_Code__c IN :allCons And IsActive__c= true ];
        this.stats = stateList;
        }
    }



/********************************************************************************************************
*  @description Countries : Constructor for countries
*********************************************************************************************************/ 
    public class Countries {        
        public String name;
        public String countryCode;       
    }    

/********************************************************************************************************
*  @description States : Constructor for state list
*********************************************************************************************************/
    public class States {        
        public String name;
        public String stateCode;
        public String state;
        public String countryCode;        
    }
 
    
/********************************************************************************************************
*  @description parse : mapping country and state
* @return String : return value
*********************************************************************************************************/
    public String parse(){
        
        if(counts!=null && !counts.isEmpty()){
            for(Country__c c:counts)
            {
                Countries ct = new Countries();
                ct.Name = c.Name;
                ct.countryCode = c.Country_Code__c;
                
                allCountries.add(ct);
            }
        }
        
        jsonobj = JSON.serializePretty(allCountries);
        
        if(stats!=null && !stats.isEmpty()) {
            
            for(Country_Region__c s:stats)
            {
                States st = new States();
                st.Name = s.Name;
                st.countryCode = s.Country_Code__c;
                st.stateCode = s.Region_Code__c;
                st.state = s.Region_Name__c;
                allStates.add(st);
            }
        }
        
        jsonobj = jsonobj+','+JSON.serializePretty(allStates); 
        
        return jsonobj;    
    }
    
    
}