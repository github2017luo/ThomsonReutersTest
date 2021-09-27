public without sharing class TRstoreOrderConfirmationFrenchCon {


    public string proposalRecId{
                                get; 
                                set{
                                proposalRecId = value;
                                if(proposalRecId != null)
                                    fetchDetails();
                                
                                }
                                
                  }
    public LIST<productsTranslatedValues> productsWithFrTrans{get; set;}
    public Apttus_Proposal__Proposal__c quote{get; set;}
    public string shippingMethod{get; set;}
    public string lineItemCount{get; set;}
    public string shippingValue{get; set;}
    public MAP<string, string> translatedValuesMAP {get; set;}
  
  
  
    public void fetchDetails(){
            
          productsWithFrTrans = new LIST<productsTranslatedValues>();
          LIST<id> prodids= new LIST<id>();
           translatedValuesMAP = new MAP<string, string> ();
           
          quote = new Apttus_Proposal__Proposal__c();
          quote = [Select Id, name, APTS_Payment_Option__c,Language__c, APTS_Card_Type__c, CreditCard_LastFourDigits__c, Total_One_Time_Net_Price__c,APTS_Ground_Shipping__c,APTS_SSD_bill_to__c,APTS_SSD_ship_to__c,APTS_Order_Confirmation_Contact__r.Name,
                   APTS_SSD_bill_to__r.Source_System_Account_Number__c,APTS_SSD_bill_to__r.Number_Street__c,APTS_SSD_bill_to__r.City__c,APTS_SSD_bill_to__r.State__c,APTS_SSD_bill_to__r.Postal_Code__c,APTS_SSD_bill_to__r.Name,
                   APTS_SSD_ship_to__r.Source_System_Account_Number__c,APTS_SSD_ship_to__r.Number_Street__c,APTS_SSD_ship_to__r.City__c,APTS_SSD_ship_to__r.State__c,APTS_SSD_ship_to__r.Postal_Code__c,APTS_SSD_ship_to__r.Name from Apttus_Proposal__Proposal__c WHERE ID=: proposalRecId];
          
            
          LIST< Apttus_Proposal__Proposal_Line_Item__c > qlilist = new LIST<Apttus_Proposal__Proposal_Line_Item__c>([Select id, name,APTS_Product_Name__c, Apttus_QPConfig__NetPrice__c, Apttus_QPConfig__BaseExtendedPrice__c,Apttus_Proposal__Product__c, 
                                                                          Apttus_Proposal__Product__r.Format__c, Apttus_QPConfig__Frequency__c, APTPS_Quantity_Display__c, Product_URL__c FROM Apttus_Proposal__Proposal_Line_Item__c  WHERE Apttus_Proposal__Proposal__c =: proposalRecId ]);
          
        if(quote.APTS_Ground_Shipping__c != null && Static_Values__c.getAll().containsKey(quote.APTS_Ground_Shipping__c)){
           
            if(quote.APTS_Ground_Shipping__c == 'International best Rate'){
                shippingMethod = (quote.Language__c == 'English')?Static_Values__c.getValues('International best Rate').Value__c : Static_Values__c.getValues('International best RateFr').Value__c; 
                shippingValue = (quote.Language__c == 'English')?'Free':'Gratuit';
            }else if(quote.APTS_Ground_Shipping__c == 'International Expedited Rate'){
               shippingMethod = (quote.Language__c == 'English')?Static_Values__c.getValues('International Expedited Rate').Value__c : Static_Values__c.getValues('International Expedited RateFr').Value__c; 
               shippingValue = 'TBD'; 
            }
        } 
        
        Set<string> prodValues = new set<string>();
        
        if(!qlilist.isEmpty()){
           lineItemCount =  String.valueof(qlilist.size());
        }
           
         for( Apttus_Proposal__Proposal_Line_Item__c pl: qliList){
         
             prodids.add(pl.Apttus_Proposal__Product__c);
             prodValues.add(pl.Apttus_QPConfig__Frequency__c );
             
         }
        
         MAP<id, product2> relatedProducts = new MAP<id, product2>([Select id, name, Format__c,ProductCode, Apttus_Filter_Jurisdiction__c, Practice_Area__c, Stock__c ,DC_Short_Description__c,
                                                 (SELECT id, name, Format__c, Jurisdiction__c, Practice_Area__c, Pricing_Terms__c, Stock__c FROM Apttus_Config2__Translation__r )
                                                 FROM product2 WHERE ID IN: prodids ]);
           
         
         
         LIST<Language_Translations__mdt> languageMetadata = new LIST<Language_Translations__mdt>();
         
         languageMetadata  = [select id, MasterLabel, DeveloperName, QualifiedApiName, Eng_Values__c, Language__c, Translated_Value__c FROM Language_Translations__mdt 
                                 WHERE Eng_Values__c IN: prodValues ];
         
         for(Language_Translations__mdt lt: languageMetadata ){
             translatedValuesMAP.put(lt.Eng_Values__c , lt.Translated_Value__c );
         }
           
                                             
           //productsWithFrTrans                                      
        for( Apttus_Proposal__Proposal_Line_Item__c pl: qliList){
             
             product2 prod = new product2 ();
             string frq = pl.Apttus_QPConfig__Frequency__c;
             
             if(pl.Apttus_QPConfig__Frequency__c != null){
                    if(translatedValuesMAP.containsKey(pl.Apttus_QPConfig__Frequency__c )){
                        frq = translatedValuesMAP.get(pl.Apttus_QPConfig__Frequency__c );
                    }
                }
                 
             
             if(relatedProducts.containsKey(pl.Apttus_Proposal__Product__c))
                 prod = relatedProducts.get(pl.Apttus_Proposal__Product__c);
                 string format = prod.Format__c;
             if( prod != null){
                 for(Apttus_Config2__ProductTranslation__c pt: prod.Apttus_Config2__Translation__r ){
                     
                     Apttus_Config2__ProductTranslation__c pts = pt;
                      format = (!string.isBlank(pt.Format__c))?pt.Format__c : prod.Format__c ;
                     // string jurisdiction = (!string.isBlank(pt.Jurisdiction__c))?pt.Jurisdiction__c : prod.Jurisdiction__c ;
                     
                    
                 } 
                  productsWithFrTrans.add(new productsTranslatedValues(format, pl, prod, frq));
                  
             }     
         }                                        
                                                 
                                                
    }


    public class productsTranslatedValues{
        
     //   public id productId {get; set;}
        public string format{get; set;}
         public string Frequency{get; set;}
     //   public string jurisdiction{get; set;}
     //   public string pricingTerms{get; set;}
     //   public string practiceArea{get; set;}
        public Apttus_Proposal__Proposal_Line_Item__c qli{get; set;}
        public Product2 pdt{get; set;}
    
        public productsTranslatedValues( string f, Apttus_Proposal__Proposal_Line_Item__c  q, Product2 prod , string fq){
            
            qli = new Apttus_Proposal__Proposal_Line_Item__c ();
            
              
            format = f;
              Frequency =fq;
          //  productId = pid;
          ///  jurisdiction = j;
          //  pricingTerms = pt;
          //  practiceArea = pa;
            qli = q;
            pdt = prod;
        }
        
        
        
    }



}