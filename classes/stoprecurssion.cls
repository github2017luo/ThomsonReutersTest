/* @@Description:Class is created to avoid 'Maximum Depth Exceeded' exception while performing operations afterInsert and afterUpdate
                 on Opportunity while updating Child_Opportunity_Amount_Subtotal__c field on Master Opportunity with sum of the Amount 
                 fields on Child Opportunities
   @@Requirement:Mastersaf
   @@Author:     Sujana Vechalapu*/  
    
    public class stoprecurssion{
        public static boolean flag=true;
        public static boolean runonce(){
            if(flag){
                flag=false;
            }
            else {
                return flag;
            }
            return true;
        }
    }