public class GGO_Special_instruction_Capture {
    public static void AccountSICapture(list<Case> newCase){
        
        System.debug('AccountSICapture');
    list<id> lstAccountIds= new list <id>();
    map<Id,List<ESC_Special_Instruction__c>> mapSIAcc =new map<Id,List<ESC_Special_Instruction__c>>();
    //list<Case> listCase= new list<Case>();
    for(case c :newCase){
        if( (c.AccountId!=null)&&(c.Is_GLI__c==False)){
    lstAccountIds.add(c.AccountId);
                }
         }
    if (lstAccountIds.size()>0){      
    list<ESC_Special_Instruction__c> si1= new list<ESC_Special_Instruction__c>([Select id,Name,ESC_Account__c,ESC_Instructions__c,ESC_Category_Account__c From ESC_Special_Instruction__c where ESC_Account__c IN:lstAccountIds AND (ESC_Category_Account__c='TLC' OR ESC_Category_Account__c='Bejerman Customized Customer') AND ESC_Status__c='Active']);
    System.debug('$$ESC_Special_Instruction__c'+si1);
        
       for (ESC_Special_Instruction__c si:si1){
           
        if(!mapSIAcc.containskey(si.ESC_Account__c)){
            mapSIAcc.put(si.ESC_Account__c, new List<ESC_Special_Instruction__c>{si});
        }
        
        else{
            mapSIAcc.get(si.ESC_Account__c).add(si);
            }
            //update S1;
       }
       
        
       
       for(case c1:newCase){
      // case c2 = new case(id=c1.id);
       System.debug('$$Map'+c1.AccountId+mapSIAcc);
       
         if(mapSIAcc.containsKey(c1.AccountId)) {
         for(ESC_Special_Instruction__c si:mapSIAcc.get(c1.AccountId)){
                if(si.ESC_Category_Account__c == 'TLC'){
                    c1.GGO_TLC__c = si.ESC_Category_Account__c +' - '+si.ESC_Instructions__c;
                    System.debug('$$TLC'+c1.GGO_TLC__c);
                } if(si.ESC_Category_Account__c =='Bejerman Customized Customer'){
                    c1.GGO_Bejerman_Customized_Customer__c=True;
                }
          }
        }
        //listCase.add(c1);
          //   System.debug('$$caselist'+listCase);
        
        // listCase.add(c1);
        }
      /**  update listCase;**/
          
       //if(listCase.size()>0){
           // update listCase;
        //}
         }
      } 
    }