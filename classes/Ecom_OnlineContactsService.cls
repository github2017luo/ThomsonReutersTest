/** CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Jira        Description
 * 2018-05-20   Ramesh Reddy/Raviteja   DLT-9777    [NEW CUSTOMER - Buy Plan SL] Create Online Contacts
 * 2018-08-28   Shiva Sri Arun Koralla  DLT-11729   [Tech story] [Code Scan] Fix Ecom_OnlineContactsService
 * 2020-02-20   David Hoel              DLT-19135   [CORP Westlaw] Add Bundle to cart.
 * 2020-06-22   Brenda Shields          DLT-20246   Update Online Contact Service with correct Materials numbers 
 * ==================================================================================================================================   
 */

public without sharing class Ecom_OnlineContactsService {
    public static String productPricingModel = 'Banded';

    public void checkContacts(String proposalId, Boolean contractNotInsync, String jurisdiction) {
        if (contractNotInsync) {
            // delete records and create new one
            Apttus_Proposal__Proposal__c proposal = [
                SELECT id, Apttus_Proposal__Account__c, 
                    (SELECT id FROM Customer_Master_Contacts__r),
                    (SELECT id FROM Online_Contacts__r) 
                FROM Apttus_Proposal__Proposal__c WHERE id = :proposalId
            ];

            if (proposal.Customer_Master_Contacts__r != null && !proposal.Customer_Master_Contacts__r.isEmpty() 
                && Schema.sObjectType.Customer_Master_Contacts__c.isDeletable() ) {
                    delete proposal.Customer_Master_Contacts__r;
            }

            if (proposal.Online_Contacts__r != null && !proposal.Online_Contacts__r.isEmpty() 
                && Schema.sObjectType.Online_Contacts__c.isDeletable() ) {
                    delete proposal.Online_Contacts__r;
            }

            createMasterContact(proposalId, jurisdiction);            
        } else {
            // check the name/email and do update if required
            Apttus_Proposal__Proposal__c proposal = [
                SELECT id, Name,Apttus_Proposal__Account__c,APTS_SSD_ship_to__c, APTS_Order_Confirmation_Contact__c, 
                    APTS_Order_Confirmation_Contact__r.FirstName, APTS_Order_Confirmation_Contact__r.LastName, 
                    APTS_Order_Confirmation_Contact__r.Email, APTS_Order_Confirmation_Contact__r.Phone,
                    (SELECT id, First_Name__c, Last_Name__c, Email_Address__c, Phone__c FROM Customer_Master_Contacts__r),
                    (SELECT id, First_Name__c, Last_Name__c, Email__c FROM Online_Contacts__r ) 
                FROM Apttus_Proposal__Proposal__c WHERE id = :proposalId
            ];
            if (proposal.Customer_Master_Contacts__r != null && !proposal.Customer_Master_Contacts__r.isEmpty() ) {
                Customer_Master_Contacts__c masterContact = proposal.Customer_Master_Contacts__r[0];

                if (masterContact.First_Name__c != proposal.APTS_Order_Confirmation_Contact__r.FirstName 
                    || masterContact.Last_Name__c != proposal.APTS_Order_Confirmation_Contact__r.LastName 
                    || masterContact.Email_Address__c != proposal.APTS_Order_Confirmation_Contact__r.Email) {
                        updateAllContacts(proposal);   
                   } else if (masterContact.Phone__c != proposal.APTS_Order_Confirmation_Contact__r.Phone) {
                       masterContact.Phone__c = proposal.APTS_Order_Confirmation_Contact__r.Phone;

                        // Check if the user has update access on the Customer Master Contacts object.
                        if (Schema.sObjectType.Customer_Master_Contacts__c.isUpdateable()) { update masterContact; }
                   }    //end of else if
            } 
        }   //end of else condition
    }   //end of the method
    
    // Adding Master Contacts
    public void createMasterContact(String proposalId, String jurisdiction) {
        Apttus_Proposal__Proposal__c proposal = [
            SELECT Id, Name,Apttus_Proposal__Account__c, APTS_SSD_ship_to__c, Previous_Order_Confirmation_SSD_Contact__c, APTS_Contact_Validation_Flag__c,
                APTS_Order_Confirmation_Contact__c, APTS_Order_Confirmation_Contact__r.FirstName, APTS_Order_Confirmation_Contact__r.LastName, 
                APTS_Order_Confirmation_Contact__r.Email, APTS_Order_Confirmation_Contact__r.Phone
            FROM Apttus_Proposal__Proposal__c WHERE Id = :proposalId
        ];
        List<Apttus_Proposal__Proposal_Line_Item__c> lineItems = [
            SELECT Id, Name, APTS_Number_of_Attorneys__c, Apttus_Proposal__Product__c, Apttus_Proposal__Product__r.Name, 
                Apttus_Proposal__Product__r.DC_Jurisdiction__c, Apttus_QPConfig__PrimaryLineNumber__c, 
                Apttus_Proposal__Product__r.APTS_Cat_L5__c, Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c, 
                Apttus_Proposal__Product__r.Subscription_Number__c, Apttus_Proposal__Product__r.Apttus_Config2__Uom__c, 
                Apttus_Proposal__Product__r.ProductCode, Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c, 
                Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c, Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c, 
                Apttus_Proposal__Proposal__c, Apttus_Proposal__Proposal__r.Name, Apttus_QPConfig__ProductOptionId__c, APTS_Subscription_Number_Override__c,
                APTS_Service_Number_Override__c
            FROM Apttus_Proposal__Proposal_Line_Item__c 
            WHERE (Apttus_Proposal__Proposal__c = :proposalId AND Apttus_QPConfig__LineStatus__c != 'Amended' 
            AND Apttus_QPConfig__LineStatus__c != 'Cancelled' AND Apttus_QPConfig__LineStatus__c != 'Renewed') 
            ORDER BY Apttus_Proposal__Product__r.ProductCode ASC Nulls Last
        ];
                                                           
        String pwdMaterial = '';   
        for (Apttus_Proposal__Proposal_Line_Item__c line : lineItems) {
            if ((!validateProductLLCode((line.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c+line.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c), System.Label.OCExcludedLowerLevelCodes)) && line.Apttus_Proposal__Product__r.APTS_Cat_L5__c != 'L5_L1445_FP') {
                if (line.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '06' 
                    || line.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' 
                    || line.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13') {
                        pwdMaterial += (line.Apttus_Proposal__Product__r.productCode + ',');
                }
            }    
        }
        System.debug('=proposal==========>' + proposal.APTS_Order_Confirmation_Contact__r.FirstName);

        Customer_Master_Contacts__c masterContact = new  Customer_Master_Contacts__c();
        masterContact.First_Name__c = proposal.APTS_Order_Confirmation_Contact__r.FirstName;
        masterContact.Last_Name__c = proposal.APTS_Order_Confirmation_Contact__r.LastName;
        masterContact.Email_Address__c = proposal.APTS_Order_Confirmation_Contact__r.Email;
        masterContact.Phone__c = proposal.APTS_Order_Confirmation_Contact__r.Phone;
        masterContact.Contact__c = proposal.APTS_Order_Confirmation_Contact__c;
        masterContact.Quote__c = proposal.Id;
        masterContact.Contact_SDD__c = proposal.Previous_Order_Confirmation_SSD_Contact__c;  
        masterContact.Customer_Type_Description__c = 'EML PSWD CONTACT';
        masterContact.Material__c = pwdMaterial;
        System.debug('====check master contact====' + masterContact);

        // Check if the user has create access on the Customer Master Contacts object.
        if (Schema.sObjectType.Customer_Master_Contacts__c.isCreateable()) { insert masterContact; }
        
            createOnlineContacts(proposal, lineItems, jurisdiction);
            List<Apttus_Proposal__Proposal__c> proposList = new list<Apttus_Proposal__Proposal__c>();
            
            for (Apttus_Proposal__Proposal__c propos : [
                SELECT id, APTS_SSD_ship_to__c, APTS_Contact_Validation_Flag__c 
                FROM Apttus_Proposal__Proposal__c WHERE id = :proposal.Id ]) {
                    propos.APTS_Contact_Validation_Flag__c = true;
                    proposList.add(propos);
            }

            // Check if the user has update access on the Quote/Proposal object.
            if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()) { update proposList; }
    }
    
    // Adding Password holders
    public void createOnlineContacts(Apttus_Proposal__Proposal__c proposal, List<Apttus_Proposal__Proposal_Line_Item__c> lineItems, String jurisdiction) {         
        List<Online_Contacts__c> onlineContacts = new List<Online_Contacts__c>();
        
        // only for standalone and bundle products : DLT-19135
        for (Apttus_Proposal__Proposal_Line_Item__c line : lineItems) {
            Online_Contacts__c onc = new Online_Contacts__c();

            // check line item type
            // DLT-20246 replace APTS_Subscription_Number_Override__c with APTS_Service_Number_Override__c
            if (line.Apttus_QPConfig__ProductOptionId__c == null && line.APTS_Service_Number_Override__c != null) {
                // if is Bundle product
                onc.Material__c = line.APTS_Service_Number_Override__c;
            } else if (line.Apttus_QPConfig__ProductOptionId__c == null && line.APTS_Service_Number_Override__c == null) {
                // else if is Standalone product
                onc.Material__c = line.Apttus_Proposal__Product__r.ProductCode;
            } else { continue; }    // else is Option product

            onc.First_Name__c = proposal.APTS_Order_Confirmation_Contact__r.FirstName;
            onc.Last_Name__c = proposal.APTS_Order_Confirmation_Contact__r.LastName;
            onc.Email__c = proposal.APTS_Order_Confirmation_Contact__r.Email; 
            onc.QuoteId__c = proposal.Id;
            onc.Account__c = proposal.Apttus_Proposal__Account__c;
            onc.APTS_Source_System_Detail__c = proposal.APTS_SSD_ship_to__c;
            onc.Type__c = 'Admin'; 
            onc.Sftwr_Admin__c = true;
            onc.Contact_Name__c = proposal.APTS_Order_Confirmation_Contact__c;
            onc.Position__c = 'Attorney';   // for bundle && options ignore
            onc.ProductId__c = line.Apttus_Proposal__Product__c;
            onc.QuoteLineItem__c = line.Id;          
			//onc.Material__c = line.Apttus_Proposal__Product__r.ProductCode;
            onc.Is_Banded_Product__c  =  productPricingModel.equalsIgnoreCase(line.Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c) ? true : false ;

            if (line.Apttus_Proposal__Product__r.Name == 'West LegalEdcenter') {
                onc.WLEc_Juris__c = jurisdiction;
            }
            onlineContacts.add(onc); 
        }

        // Check if the user has create access on the Online Contacts object.
        if (!onlineContacts.isEmpty() && Schema.sObjectType.Online_Contacts__c.isCreateable()) { insert onlineContacts; }
    }
    
    public void updateAllContacts(Apttus_Proposal__Proposal__c proposal) {
        if (proposal.Customer_Master_Contacts__r != null && !proposal.Customer_Master_Contacts__r.isEmpty() ) {
            Customer_Master_Contacts__c masterContact = proposal.Customer_Master_Contacts__r[0];
            masterContact.First_Name__c = proposal.APTS_Order_Confirmation_Contact__r.FirstName;
            masterContact.Last_Name__c = proposal.APTS_Order_Confirmation_Contact__r.LastName;
            masterContact.Email_Address__c = proposal.APTS_Order_Confirmation_Contact__r.Email;
            masterContact.Phone__c = proposal.APTS_Order_Confirmation_Contact__r.Phone;

            // Check if the user has update access on the Customer Master Contacts object.
            if (Schema.sObjectType.Customer_Master_Contacts__c.isUpdateable()) { update masterContact; }
        }

        if (proposal.Online_Contacts__r != null && !proposal.Online_Contacts__r.isEmpty() ) {
            for (Online_Contacts__c  onlineContact : proposal.Online_Contacts__r) {
                onlineContact.First_Name__c = proposal.APTS_Order_Confirmation_Contact__r.FirstName;
                onlineContact.Last_Name__c = proposal.APTS_Order_Confirmation_Contact__r.LastName;
                onlineContact.Email__c = proposal.APTS_Order_Confirmation_Contact__r.Email; 
            }

            // Check if the user has update access on the Online Contacts object.
            if (Schema.sObjectType.Online_Contacts__c.isUpdateable()) {
                update proposal.Online_Contacts__r;
            }
        }
    }
    
    public boolean validateProductLLCode(String llCode, String label) {
        if ( String.isNotBlank(llCode) && String.isNotBlank(label) ) {
            return label.containsIgnoreCase(llCode);
        }

        return false;
    }
}