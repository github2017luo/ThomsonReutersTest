/*
======================================================================================================================
CLASS NAME:    QuotePrimaryQuoteUpdation
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-31        Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
public class QuotePrimaryQuoteUpdation{
    public static boolean isRun=true;
    public static void updatePrimaryQuote(MAP<ID,ID> mapOpptyQuote){
     try{
 isRun=false;
     /* set<Quote> quoteset=new set<Quote>([select id,opportunityid from quote where Primary_Quote__c=true and opportunityid in:QuoteOpptymap.Keyset()]);
      map<id,id> mapOpptyQuote=new map<id,id>();
      for(quote oQte :quoteset){
            mapOpptyQuote.put(oQte.opportunityid,oQte.id);
      }*/
/*system.debug('***mapOpptyQuote.Keyset() ' + mapOpptyQuote.Keyset());-- commented to reduce character for s2e optimization */
      List<OpportunityProductDetail__c> OpdListtobeupdated= new List<OpportunityProductDetail__c>();
      list<OpportunityProductDetail__c> opdList = new list<OpportunityProductDetail__c>([select id,Opportunity__c,Primary_Quote__c from OpportunityProductDetail__c where Opportunity__c IN:mapOpptyQuote.Keyset()]);
/*system.debug('****opdList' + opdList);-- commented to reduce character for s2e optimization */
         for(OpportunityProductDetail__c oOpd:opdList){
          oOpd.Primary_Quote__c = mapOpptyQuote.get(oOpd.Opportunity__c);
          OpdListtobeupdated.add(oOpd);
         } 
          if (OpdListtobeupdated.size() > 0){
         update OpdListtobeupdated; 
        }
       }
     catch(Exception e){
/*System.debug(e+'*********'+e.getmessage());-- commented to reduce character for s2e optimization */
      }
   }
      
    public static void syncPurchasedOrderDate(MAP<ID,datetime> QuoteOpptymap){
        isRun= false;
/*System.debug('updateSynCQuote **'+QuoteOpptymap);-- commented to reduce character for s2e optimization */
        try{
            opportunity tempOptyList;
            list<opportunity> oOpty = new list<opportunity>();
            for(Id id: QuoteOpptymap.keySet()){
                tempOptyList = new opportunity();
                tempOptyList.Approved_Date_Time__c = QuoteOpptymap.get(id);
                tempOptyList.id = id;
                oOpty.add(tempOptyList);
            }
            update oOpty;
        }
        catch(Exception e){
/*System.debug(e+'*********'+e.getmessage()+'********* line number '+e.getLineNumber());-- commented to reduce character for s2e optimization */
        }
    }
    
    /*******************************************************************
        Purpose     : updateOpptyStage- To update the stage of opportubity to 100% if Quote status is 'Order Completed'
    ********************************************************************/
    public static void updateOpptyStage(set<id> setOpptyIds){
        isRun= false;
        list<opportunity> opptyList = new list<opportunity>();
        try{
            list<Opportunity> opptyStageList = new list<Opportunity>();
            opptyStageList = [select StageName, id from Opportunity where id In : setOpptyIds];
            for(Opportunity opp : opptyStageList){
                opportunity oppty = new opportunity();
                oppty.Id = opp.id;
                if(opp.StageName != '95%')
                    oppty.StageName = '95%';
                opptyList.add(oppty);
            }
            if(!opptyList.isEmpty())
                update opptyList;
        }
        catch(Exception e){
/*System.debug(e+'error in updateOpptyStage*********'+e.getmessage()+'updateOpptyStage ********* line number '+e.getLineNumber());*/
        }
    }
}