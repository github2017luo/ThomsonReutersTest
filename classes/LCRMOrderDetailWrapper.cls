/**
 * Wrapper Class generated using JSON payloads and supports the method to deserialize JSON response for LCRM_GetOrderDetail Service.
 *
 * @author  Seema Nagdev
 * @version 2017-11-10
 */

public with sharing class LCRMOrderDetailWrapper {

    /**OrderDetail Request Wrapper Starts**/
    public class OrdDetailRequest {
        public EsiHeader esiHeader;
        public String sourceSystem;
        public String targetSystem;
        public String business;
        public String orderNumber;
        public String iDocNumber;
        public String productId;
        public Accounts accounts;
        public UserDetails userDetails;
        public String language;
        public ExtensibleAttributes extensibleAttributes;

        public OrdDetailRequest() {
            esiHeader = new EsiHeader();
            sourceSystem = '';
            targetSystem = '';
            business = '';
            orderNumber = '';
            productId = '';
            iDocNumber = '';
            accounts = new Accounts();
            userDetails = new UserDetails();
            language = '';
            extensibleAttributes = new ExtensibleAttributes();
        }
    }
    public class EsiHeader {
        public String applicationId;
        public String transactionId;
        public String messageId;
        public String messageHistory;
        public String tracingId;
        public String timeStamp;
        public String instanceId;
        public String companyId;
        public String configGroup;
        public String payloadVersion;
        public String postBackURL;
        public ExtensibleAttributes extensibleAttributes;

        public EsiHeader() {
            applicationId = '';
            transactionId = '';
            messageId = '';
            messageHistory = '';
            tracingId = '';
            timeStamp = '';
            instanceId = '';
            companyId = '';
            configGroup = '';
            payloadVersion = '';
            postBackURL = '';
            extensibleAttributes = new ExtensibleAttributes();
        }
    }

    public class Accounts {
        public String accountNumber;
        public String companyId;
        public String industryCode;
        public String accountType;

        public Accounts() {
            accountNumber = '';
            companyId = '';
            industryCode = '';
            accountType = '';
        }
    }
    public class UserDetails {
        public String firstName;
        public String lastName;
        public String middleName;
        public String phone;
        public String extension;
        public String fax;
        public String emailAddress;
        public ExtensibleAttributes extensibleAttributes;
        public String locationAccount;
        public String contactNumber;
        public String contactType;
        public String userType;
        public String userId;
        public String secondaryUUID;
        public ExtensibleAttributes settings;

        public UserDetails() {
            firstName = '';
            lastName = '';
            middleName = '';
            phone = '';
            extension = '';
            fax = '';
            emailAddress = '';
            extensibleAttributes = new ExtensibleAttributes();
            locationAccount = '';
            contactNumber = '';
            contactType = '';
            userType = '';
            userId = '';
            secondaryUUID = '';
            settings = new ExtensibleAttributes();

        }
    }



    public class ExtensibleAttributes {
        public String systemIdentifier;
        public String key;
        public String value;

        public ExtensibleAttributes() {
            systemIdentifier = '';
            key = '';
            value = '';
        }
    }

    /**OrderDetail Request Wrapper Ends**/

    /**OrderDetail Response Wrapper Starts**/
    public class OrdResWrapper {
        public OrderHeader orderHeader;
        public List<OrderLine> orderLine;
    }

    public class OrderHeader {
        public String OrderNumber;
        public String sourceOrTargetReferenceNumber;
        public String orderTimestamp;
        public String purchaseOrderNumber;
        public String orderCurrency;
        public List<OrderAddress> orderAddress;
        public OrderedBy orderedBy;
        public String orderSource;
    }

    public class OrderAddress {
        public String firstName;
        public String lastName;
        public String middleName;
        public List < ExtensibleAttributes1 > extensibleAttributes;
        public String street1;
        public String region;
        public String postalcode;
        public String poBox;
        public Double shippingAmount;
        public String shipCarrier;
    }

    public class OrderedBy {
        public String OPoName;
    }

    public class OrderLine {
        public String orderLineNumber;
        public String sourceOrTargetReferenceLineNumber;
        public Double quantity; //Changed from Integer to Double as part of MCL-2334 Changes
        public Double netAmount;
        public Double taxAmount;
        public Double shippingAmount;
        public String shippingMethod;
        public Material_Z material;
        public String billingAccount;
        public List<ExtensibleAttributes1> extensibleAttributes;
    }

    public class ExtensibleAttributes1 {
        public String systemIdentifier;
        public String key;
        public String value;
    }

    public class Material_Z {
        public Material material;
    }

    public class Material {
        public String materialNumber;
        public String materialDescription;
        public String materialType;
    }


    /**OrderDetail Response Wrapper Ends**/
    /** Wrapper to Displyain VF**/
    public class OrderItems {
        public String MaterialDescription {get; set;}
        public Integer QuantityOrdered {get; set;}
        public String MaterialNumber {get; set;}
        public Double NetAmount {get; set;}
        public Id productId {get; set;}

        public OrderItems(OrderLine oOrdLine) {
            System.debug('Start oOrdLines-->');
            if (oOrdLine.material.material.materialDescription != null)
                MaterialDescription = oOrdLine.material.material.materialDescription;
            if (oOrdLine.quantity != null)
                QuantityOrdered = Integer.valueOf(oOrdLine.quantity); //MCL-2334 Changes
            if (oOrdLine.material.material.materialNumber != null) {
                if (oOrdLine.material.material.materialNumber.startsWith('0'))
                    MaterialNumber = oOrdLine.material.material.materialNumber.substring(10);
                else
                    MaterialNumber = oOrdLine.material.material.materialNumber;
            }
            if (oOrdLine.netAmount != null)
                NetAmount = oOrdLine.netAmount;
            //productId
        }
    }

    public static List < OrderItems > getMatchedValues(String jsonRes) {
        List < OrderItems > odItemlist = new List < OrderItems > ();
        OrdResWrapper odRes = new OrdResWrapper();
        OrderLine resOdLine = new OrderLine();
        try {
            odRes = (OrdResWrapper) System.JSON.deserialize(jsonRes, OrdResWrapper.class);
            if (odRes.OrderLine != null) {
                for (OrderLine odLine: odRes.OrderLine) {
                    odItemlist.add(new OrderItems(odLine));
                }
                getProducts(odItemlist);
            }
        } catch (Exception e) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Error: ' + e.getMessage()));
        }
        return odItemlist;
    }

    public static void getProducts(List <OrderItems> oOrderList) {
        if (oOrderList != null) {
            List <string > materialNumList = new List <string> ();
            List <product2> oProd = new list <product2> ();
            Map <string, id> materialnumIdMap = new Map <string, id> ();
            if(!oOrderList.isEmpty()){
                for (OrderItems oOrder: oOrderList) {
                    if (oOrder.MaterialNumber != null)
                        materialNumList.add(oOrder.MaterialNumber);
                }
            if(Schema.sObjectType.product2.isAccessible() && Schema.sObjectType.product2.isQueryable()){
                oProd = [select id, ProductCode from product2 where ProductCode in: materialNumList and IsActive = true];
            }
                if(!oProd.isEmpty()){
                    for (product2 p: oProd) {
                        materialnumIdMap.put(p.ProductCode, p.id);
                    }
                }
            
                for (OrderItems oOrder: oOrderList) {
                    if (oOrder.MaterialNumber != null) {
                        if (materialnumIdMap.containsKey(oOrder.MaterialNumber))
                            oOrder.productId = materialnumIdMap.get(oOrder.MaterialNumber);
                    }
                }
            }
        }
    }
}