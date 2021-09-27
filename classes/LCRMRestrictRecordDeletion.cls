/**
 * @Comment : LCRMRestrictRecordDeletion
 @description : invoked from
 **Apex trigger**
 OpportunityTrigger
 LeadBeforeEventListener
 ContactBeforeEventListener
 AccountBeforeEventListener
 *
 */
public class LCRMRestrictRecordDeletion{
    /**
     * @Comment : restrictRecordDeletion description
     * @description : restrictRecordDeletion description
     *
     * @param  sobjectList (List<sobject>): sobjectList
     */
    public static void restrictRecordDeletion(List<sobject> sobjectList){
        String objectName = '';
        if (sobjectList.size() > 0){
            //system.debug('@@@@printing objectlist'+sobjectList);
            objectName = sobjectList[0].getSObjectType().getDescribe().getName();

        }

        checkDeleteError(objectName, sobjectList);
    }

    /**
     * @Comment : checkDeleteError description
     * @description : checkDeleteError description
     * @param objectName (String): objectName
     * @param sobjectList (List<sobject>): sobjectList
     */
    public static void checkDeleteError(String objectName, List<sobject> sobjectList){
        Set<id> recordtypeIdSet = getRecordtypeSet();
        if (objectName == 'Account'){
            checkAccount(objectName, sobjectList, recordtypeIdSet);
        } else if (objectName == 'Opportunity'){
            checkOppty(objectName, sobjectList, recordtypeIdSet);
        } else if (objectName == 'Contact'){
            checkContact(objectName, sobjectList, recordtypeIdSet);
        } else if (objectName == 'Lead'){
            checkLead(objectName, sobjectList, recordtypeIdSet);
        }
    }

    /**
     * @Comment : checkOpptyLead description
     * @description : checkOpptyLead description
     * @param objectName (String): objectName
     * @param sobjectList (List<sobject>): sobjectList
     * @param recordtypeIdSet (set<Id>): recordtypeIdSet
     */
    public static void checkOppty(String objectName, List<sobject> sobjectList, set<Id> recordtypeIdSet){
        for (sobject obj : sobjectList){
            if (obj.getSObjectType().getDescribe().getName() == 'Opportunity'){
                Opportunity opp = (Opportunity)obj;
                if (LOTUS_Lightning_Profiles__c.getInstance(UserInfo.getProfileId()).Delete_Record_Permission__c == false && recordtypeIdSet.contains(opp.recordtypeid) && opp.LCRM_Integration_Source__c == 'Impartner' && opp.Is_GLI__c == true){
                    opp.addError(System.label.LCRM_restrict_record_deletion);//0012g00000TZkOiAAL
                }
            }

        }
    }

    /**
     * @Comment : checkAccount description
     * @description : checkAccount description
     * @param objectName (String): objectName
     * @param sobjectList (List<sobject>): sobjectList
     * @param recordtypeIdSet (set<Id>): recordtypeIdSet
     */
    public static void checkAccount(String objectName, List<sobject> sobjectList, set<Id> recordtypeIdSet){

        for (sobject obj : sobjectList){
            if (obj.getSObjectType().getDescribe().getName() == 'Account' && ((account)obj).LCRM_Integration_Source__c == 'Impartner' && recordtypeIdSet.contains(((account)obj).recordtypeid) && LOTUS_Lightning_Profiles__c.getInstance(UserInfo.getProfileId()).Delete_Record_Permission__c == false){

                //if (LOTUS_Lightning_Profiles__c.getInstance(UserInfo.getProfileId()).Delete_Record_Permission__c == false && recordtypeIdSet.contains(acc.recordtypeid) && acc.LCRM_Integration_Source__c == 'Impartner' && acc.is_GLI__C == true){
                ((account)obj).addError(System.label.LCRM_restrict_record_deletion);//0012g00000TZkOiAAL
                //}
            }
        }
    }

    /**
     * @Comment : checkContact description
     * @description : checkContact description
     * @param objectName (String): objectName
     * @param sobjectList (List<sobject>): sobjectList
     * @param recordtypeIdSet (set<Id>): recordtypeIdSet
     */
    public static void checkContact(String objectName, List<sobject> sobjectList, set<Id> recordtypeIdSet){

        for (sobject obj : sobjectList){
            if (obj.getSObjectType().getDescribe().getName() == 'Contact' && ((contact)obj).LCRM_Integration_Source__c == 'Impartner' && recordtypeIdSet.contains(((contact)obj).recordtypeid) && LOTUS_Lightning_Profiles__c.getInstance(UserInfo.getProfileId()).Delete_Record_Permission__c == false){
                Contact con = (Contact)obj;
                //if (LOTUS_Lightning_Profiles__c.getInstance(UserInfo.getProfileId()).Delete_Record_Permission__c == false && recordtypeIdSet.contains(con.recordtypeid) && con.LCRM_Integration_Source__c == 'Impartner'){
                ((contact)obj).addError(System.label.LCRM_restrict_record_deletion);//0012g00000TZkOiAAL
                //}

            }

        }
    }

    /**
     * @Comment : checkLead description
     * @description : checkLead description
     * @param objectName (String): objectName
     * @param sobjectList (List<sobject>): sobjectList
     * @param recordtypeIdSet (set<Id>): recordtypeIdSet
     */
    public static void checkLead(String objectName, List<sobject> sobjectList, set<Id> recordtypeIdSet){

        for (sobject obj : sobjectList){
            if (obj.getSObjectType().getDescribe().getName() == 'Lead' && LOTUS_Lightning_Profiles__c.getInstance(UserInfo.getProfileId()).Delete_Record_Permission__c == false && recordtypeIdSet.contains(((Lead)obj).recordtypeid) && ((Lead)obj).LCRM_Integration_Source__c == 'Impartner' && ((Lead)obj).Is_GLI__c == true){
                ((Lead)obj).addError(System.label.LCRM_restrict_record_deletion);//0012g00000TZkOiAAL
            }
        }
    }

    /**
     * @Comment : getRecordtypeSet description
     * @description : getRecordtypeSet description
     * @return Set<id>void: Return description
     */
    public static Set<id> getRecordtypeSet(){
        Set<id> recordtypeIdSet = new Set<id>();
        Id gLIAccountRecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
        Id gLIContactRecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('GLI_Contact').getRecordTypeId();
        //Id gLIContactCDSRecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('GLI_Contact_CDS').getRecordTypeId();
        //GLI_Pipeline_Opportunity
        Id gLIPipelineOpportunityRecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('GLI_Pipeline_Opportunity').getRecordTypeId();
        Id gLILeadRecordtypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('GLI').getRecordTypeId();

        recordtypeIdSet.add(gLIAccountRecordtypeId);
        recordtypeIdSet.add(gLIContactRecordtypeId);
        recordtypeIdSet.add(gLIPipelineOpportunityRecordtypeId);
        recordtypeIdSet.add(gLILeadRecordtypeId);
        //recordtypeIdSet.add(gLIContactCDSRecordtypeId);

        return recordtypeIdSet;
    }
    
     /**
     * @Comment : assignLeadValues
     * @description : assignLeadValues before inserting
     * @param objectName (String): objectName
     * @param sobjectList (List<sobject>): sobjectList
     * @param recordtypeIdSet (set<Id>): recordtypeIdSet
     */
    public static void assignLeadValues(List<sobject> sobjectList){
     Id gLILeadRecordtypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('GLI').getRecordTypeId();
        for (sobject obj : sobjectList){
            if (obj.getSObjectType().getDescribe().getName() == 'Lead' && ((Lead)obj).LCRM_Integration_Source__c == 'Impartner' && 
            ((((Lead)obj).recordtypeid)==gLILeadRecordtypeId)&& (((Lead)obj).BU_Segment__c=='Corporate')){

                
                     ((Lead)obj).ECC_Top_Named_Corporations__c='Not on this list';

                }
                if (obj.getSObjectType().getDescribe().getName() == 'Lead' && ((Lead)obj).LCRM_Integration_Source__c == 'Impartner' && 
            ((((Lead)obj).recordtypeid)==gLILeadRecordtypeId)&&(((Lead)obj).BU_Segment__c=='Professional Legal')){
                     ((Lead)obj).ECC_Top_Named_Law_Firms__c='Not on this list';
                                          
                }
            }
        }
    

}