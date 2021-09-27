/**
 * @description Helper class for APTS_OrderQueueToESI    
 */
@SuppressWarnings('PMD') 
public with sharing class APTS_OrderSubmissionUtilityExt5 {
    /**
     * @description assignOnlineContactType
     * @return OnlineContactType
     * @param onlinecon1
     * @param materialBrandCodeMap
     * @param onlineContact
     */
    public static CreateOrderRequest.onlineContacts assignOnlineContactType(Online_Contacts__c onlinecon1, Map < string, string > materialBrandCodeMap, CreateOrderRequest.onlineContacts onlineContact) {

        if (onlinecon1.Type__c == 'Admin' && !materialBrandCodeMap.isEmpty() && materialBrandCodeMap.containsKey(onlinecon1.Material__c) && materialBrandCodeMap.get(onlinecon1.Material__c) == '064') {
            onlineContact.onlineContactType = '0230';
        } else if (onlinecon1.Position__c == 'Attorney') {
            onlineContact.onlineContactType = '0100';
        } else if (onlinecon1.Position__c == 'Clerk') {
            onlineContact.onlineContactType = '0050';
        } else if (onlinecon1.Position__c == 'Judge') {
            onlineContact.onlineContactType = '0080';
        } else if (onlinecon1.Position__c == 'Librarian') {
            onlineContact.onlineContactType = '0060';
        } else if (onlinecon1.Position__c == 'Non-Attorney') {
            onlineContact.onlineContactType = '0090';
        } else if (onlinecon1.Position__c == 'Paralegal') {
            onlineContact.onlineContactType = '0030';
        } else if (onlinecon1.Position__c == 'Administrator') {
            onlineContact.onlineContactType = '0290';
        } else if (onlinecon1.Position__c == 'Analyst') {
            onlineContact.onlineContactType = '0310';
        } else if (onlinecon1.Position__c == 'Supervisor') {
            onlineContact.onlineContactType = '0280';
        } else if (onlinecon1.Position__c == 'Clear Administrator') {
            onlineContact.onlineContactType = '0290';
        } else if (onlinecon1.Position__c == 'Clear Analyst') {
            onlineContact.onlineContactType = '0310';
        } else if (onlinecon1.Position__c == 'Clear Investigator') {
            onlineContact.onlineContactType = '0300';
        } else if (onlinecon1.Position__c == 'Clear Supervisor') {
            onlineContact.onlineContactType = '0280';
        } else if (onlinecon1.Position__c == 'Clear Technical') {
            onlineContact.onlineContactType = '0270';
        } else if (onlinecon1.Position__c == 'Summer Associates') {
            onlineContact.onlineContactType = '0270';
        }
        //Start:GLP-583
        else if (onlinecon1.Position__c == 'Proview Ent IP') {
            onlineContact.onlineContactType = '0900';
        }
        //End- GLP-583 

        onlineContact.phone = null;
        onlineContact.phoneExtension = null;
        onlineContact.contactNumber = onlinecon1.ContactID__c;

        return onlineContact;
    }
}