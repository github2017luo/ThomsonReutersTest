/*============================================================================================
    Name                : DCRecommendationDetailsResponse 
    Description         : This class is developed as part of CXD-Renewal project. This class acts as response class.
    Created Date        : 02/28/2019
    Created by          : Navleen Kaur
    History: 
    Date           Name                    Description   
    02/28/2019     Navleen Kaur            DLT-14147 : SLF][SFDC] Expose Small Law Recommendations to Sales Channel
    03/26/2019     Navleen Kaur            DLT-15710 : Expose Small Law Recommendations to Sales Channel - Integrate ESI Service
    05/06/2019     Navleen Kaur            DLT-16425 : Analytics Product Recommendation Ancillary Amount Data Type Change at SFDC
===============================================================================================*/
public class DCRecommendationDetailsResponse {
         public ESIHeader esiHeader;
         public CustomerDetails customerDetails; 
    public DCRecommendationDetailsResponse(){
        
    }     
     public class ESIHeader {
        public String applicationId;    
    }
     public class CustomerDetails{
        public String name;
        public String lastUpdatedDate;
        public Integer customerNumber;
        public Integer renewalDate;        
        public String alreadySimplified;
        public String currContractTerm;
        public Decimal currentMCV;
        public String upsellLevel;
        public String usageProfile;
        public Integer attorneyCount;
        public ExistingMaterials[] existingMaterials;
        public RecommandedMaterials[] recommandedMaterials;
    }
    public class ExistingMaterials{
        public String productTitle;
        public Integer targetQty;
        public Integer currentMaterialNum;
        public String currentServiceNum;       
        public Decimal bandPrice;
        public String aggRectxt;
        public Integer netTransactionCount;
        
    }
    public class RecommandedMaterials {
        public String productTitle;
        public Integer targetQty;
        public String rcmdSubsMaterialNumber;
        public String rcmdServiceNumber;
        public Decimal bandPrice;
        public String aggRectxt;
        public Decimal ancillaryAmount;
        public Integer declinesCNT;
        public String cmtFlag;
        public Integer finalRank;
    }
}