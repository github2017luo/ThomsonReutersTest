/********************************************************************************
Class Name : DCPRenewalProposalWrapper
@description : Request Structure for Proposal Array
Modification Details
    Date             Description                                            Developer
21-04-2021        Class Created                                             Benjamin Her
05-05-2021        DCP-1124 | Added the selectedContractTerm variable        Herin Acharya
10-06-2021        DCP-1111 | Added the products variable                    Vishnu Santhosh 
30-06-2021        DCP-2439 | Suppressed PMD Warning - Too Many Fields       Vishnu Santhosh 
15-07-2021        DCP-2144 | Changed Wrapper of 'products' variable         Vishnu Santhosh 
27-07-2021        DCP-2680 | Added the DocusignID variable                  Priyanka Mondal
28-07-2021        DCP-2682 | Added contract type variable                   Himanshu Sharma 
*********************************************************************************/ 
//@SuppressWarnings('PMD.TooManyFields')
@SuppressWarnings('PMD.TooManyFields, PMD.ExcessivePublicCount')
public class DCPRenewalProposalWrapper{
   
   // Will change the data type of the variables  if needed
   public id proposalId;
   public id cartId;
   public decimal defaultRenewalRate;
   public boolean isPrimary;
   public boolean isEditable;
   public string proposalType;
   public string marketSegment;
   public string billingFrequency;
   public decimal currentMonthlyPrice;
   public decimal newMonthlyPrice;
   public decimal retailPrice;
   public String currencyCode;
   public String docusignid;
   public integer quantity;
   public List<DCPOfferDetails> offerDetails;
   public String paymentMethod;
   public String selectedContractTerm;
   public List<DCPRenewalProductWrapper> products;
   public String contractType;

   /**
    * @description Constructor
    */
   public DCPRenewalProposalWrapper(){
       offerDetails = new List<DCPOfferDetails>();
       products = new List<DCPRenewalProductWrapper>();
   }
      
}