/********************************************************************************************
    Class: ReservationTriggerHandler
    DevelopedBy: Shovon 
    Purpose: SFD-497
    *********************************************************************************************/
    public class ReservationTriggerHandler{
    public static void updateOpportunityOnReservationUpdate(List<Reservation__c> ListReservation, Map<Id, Reservation__c> MapNewReservation, Map<Id, Reservation__c> MapOldReservation){
        List<Reservation__c> updatedReservationList = new List<Reservation__c>();
        List<Opportunity> updatedOpportunityList;
        for(Reservation__c r: ListReservation){
            if(r.Partner_Manager__c != MapOldReservation.get(r.Id).Partner_Manager__c){
                updatedReservationList.add(r);
            }
        }
        if(!updatedReservationList.isEmpty()){
            updatedOpportunityList = new List<Opportunity>([SELECT Id, Reservation_Number__c, Reservation_Manager__c FROM Opportunity WHERE Reservation_Number__c IN: updatedReservationList]);
        }
        if(updatedOpportunityList != null){
            for(Opportunity opp: updatedOpportunityList){
                opp.Reservation_Manager__c = MapNewReservation.get(opp.Reservation_Number__c). Partner_Manager__c;
            }
            Database.update(updatedOpportunityList, false);
        }
    
    }
    public static void mandatePartnerManagerOnApproval(List<Reservation__c> ListReservation, Map<Id, Reservation__c> MapOldReservation){
        for(Reservation__c r: ListReservation){
            if(r.Approval_Status__c == 'Approved'&& r.Approval_Status__c != MapOldReservation.get(r.Id).Approval_Status__c && r.Partner_Manager__c == null){
                String errorMsg = System.Label.Partner_Manager_mandatory_validation;
                r.addError(errorMsg);
            }
        }
    }
}