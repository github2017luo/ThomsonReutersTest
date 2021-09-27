public without sharing class Acritas_CaseFieldsMappingWrapper{

    public String acctnum { get; set; }
    public String invoicenumber { get; set; }
    public String productname { get; set; }
    public String firstname { get; set; }
    public String surname { get; set; }
    public String address { get; set; }
    public String postcode { get; set; }
    public String town { get; set; }
    public String country { get; set; }
    public Acritas_CaseFieldsMappingWrapper(){
            system.debug('Inside constructor');
        }
    
}