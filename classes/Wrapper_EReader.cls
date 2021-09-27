/**
 * Contains methods for making E-Reader WS callout.
 * Contains the methods which will process the request and response.
 *
 * @author  Anshita Sharma
 * @version  2013-07-11
 */
 
global with sharing class Wrapper_EReader {
  public class EReaderException extends Exception {}
  public static final string WebServiceName = 'E-Reader';  
  public WS_EReader.EReaderWSSoap wsPort {
        get {
            if(! Test.isRunningTest()){
              WS_EReader.EReaderWSSoap port = new WS_EReader.EReaderWSSoap();
              WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);
              port.inputHttpHeaders_x = new Map<String, String>();
              port.endpoint_x = oWebServiceSettings.Endpoint__c;
              port.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
              Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
              string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
              port.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
              port.outputHttpHeaders_x = new Map<String,String>();   
              return port;  
      }else{
        return new Wrapper_EReader.EReaderWSSoapTester();
      }
        }
        private set;
    }
    
    public static String[] generateAccessEReaderWS(Id oppId) {
     system.debug('inside generateAccessEReaderWS');
      String[] result = new String[2];
        result[0] = '1';
        result[1]= 'Se han generado los accesos E-Reader con éxito!';        
      try {
        Wrapper_EReader ws = new Wrapper_EReader();
        integer resultNum= ws.generateAccessEReader(oppId);
        
        if(resultNum==2){
          result[0] = '2';
            result[1]= 'No hay detalle de product!';
        }
        
        if(resultNum==3){
          result[0] = '3';
            result[1]= 'No hay entitlement asociado a algun producto!';
        }
        
        if(resultNum==4){
          result[0] = '4';
            result[1]= 'Algun contacto no tiene mail asignado!';
        }
        
      } catch(Exception e) {
          system.debug(logginglevel.error, '>>> Error generating access e-reader: ' + e.getMessage());
          result[0] = '0';
          //result[1] = 'Se produjo un error generando accesos e-reader: \n' + e.getmessage();
          result[1] = 'Se produjo un error generando accesos e-reader.Consulte los registros para obtener más detalles.';
          IntegrationLogger.addMessage(e.getMessage(), oppId, 'Opportunity', '', 'Outbound','Create E-Reader',false);          
        }
        return result;
    }
    
    public integer generateAccessEReader(Id oppId) {
      
      system.debug(logginglevel.info, '### Generate Access E-Reader...');
      
      List<OpportunityProductDetail__c> details = new List<OpportunityProductDetail__c>();
      Set<Id> productIds = new Set<Id>();
      List<Opportunity_Product_Detail_Contact__c> contactDetails = new List<Opportunity_Product_Detail_Contact__c>();
     
      // prepare request
      system.debug(logginglevel.info, '>>> Obtaining opportunity product details...');
     /* for(OpportunityProductDetail__c detail : [select id, (select Contact__c, Email__c from Opportunity_Product_Detail_Contacts__r), Opportunity_Line_Item_Id__c, Opportunity__c, Contact__c, Contact__r.FirstName, Contact__r.LastName,
            Contact__r.email, Product__c, Product__r.SAP_Product__c, Product__r.name from OpportunityProductDetail__c where Opportunity__c = :oppid and Contact__c != null]) {
           
           for(Opportunity_Product_Detail_Contact__c detailContact : detail.Opportunity_Product_Detail_Contacts__r){
               contactDetails.add(detailContact);
          
            // For the query of Entitlements
            productIds.add(detail.Product__c);
            
            details.add(detail);
           }
      }*/
    
      //Query from opp product details   
      for(OpportunityProductDetail__c detail : [select id, Opportunity_Line_Item_Id__c, Opportunity__c, Contact__c, Contact__r.FirstName, Contact__r.LastName,
            Contact__r.email, Product__c, Product__r.SAP_Product__c, Product__r.name from OpportunityProductDetail__c where Opportunity__c = :oppid and Contact__c != null]) {           
            // For the query of Entitlements
            productIds.add(detail.Product__c);
            
            details.add(detail);
           
      }
      //Query from opp product details contact
      for(Opportunity_Product_Detail_Contact__c prodConDetail : [Select id, Product_Detail__c, Contact__c,contact__r.firstName,contact__r.lastname,contact__r.email, SAP_Contact_ID__c from Opportunity_Product_Detail_Contact__c where Product_Detail__c= :details]){
          contactDetails.add(prodConDetail );
          system.debug('opportunity product detail contact list ::'+ contactDetails);
          system.debug('Opp Prod Cont Detail Size ::'+ contactDetails.size());
      }
    //If there is no detail
    if(productIds.size()<=0) return 2;
    
    system.debug(logginglevel.info, '>>> products : ' + productIds);
    system.debug(logginglevel.info, '>>> Opp Prod Details : ' + details);
        
    // query Entitlements
    Map<Id, List<EntitlementProduct__c>> entitlements = new Map<Id, List<EntitlementProduct__c>>();
    for(EntitlementProduct__c ep : [select id, entitlement__r.name, product__c from EntitlementProduct__c
      where product__c in :productIds order by product__c]) {
      
        if(!entitlements.containsKey(ep.product__c))
            entitlements.put(ep.product__c, new List<EntitlementProduct__c>());
        entitlements.get(ep.product__c).add(ep);
      }
      
    //If there is no detail 
    if(entitlements.size()<=0) return 3;
    
    Map<Id, Contact> contacts = new Map<Id, Contact>();
    List<String> messages = new List<String>();
    
    for(OpportunityProductDetail__c d : details) {
      if(d.contact__r.email == '')
        return 4;
    }
    
    // Call webservice
      
    for(OpportunityProductDetail__c d : details) {
        
      for(Opportunity_Product_Detail_Contact__c oppProdDetCon : contactDetails) { 
      if(entitlements.containsKey(d.product__c)) {
        
        for(EntitlementProduct__c ep : entitlements.get(d.product__c)) {
            String wsResponse = null;
            List<OnlineContact> onlContacts = new List<OnlineContact>();
            
            try {
              system.debug(logginglevel.info, '>>> Call WS...\nFirstName:'+d.contact__r.firstName+'\nLastName:'+d.contact__r.lastName+'\nEmail:'+d.contact__r.email+'\nEntitlement:'+ep.entitlement__r.name+'\nMaterialDesc:'+d.product__r.name);
              
              wsResponse = wsPort.CreateOnlineContact(
                'LATM', 
                /*d.contact__r.firstName, 
                d.contact__r.lastName, 
                d.contact__r.email,*/
                
                oppProdDetCon.contact__r.firstName, 
                oppProdDetCon.contact__r.lastName, 
                oppProdDetCon.contact__r.email,
                
                'EREADER', 
                'true', 
                ep.entitlement__r.name, 
                d.product__r.name
              );
            } catch (Exception e) {
              throw new EReaderException('Error llamando WS: ' + e.getmessage());
            }
            
            try {
              // parse XML response 
              XMLReader reader = new XMLReader();
              onlContacts = reader.parseXML(wsResponse);
              
              for(OnlineContact oc : onlContacts) {
                contacts.put(d.Contact__c, new Contact(Id = d.Contact__c, App_User_GUID__c = oc.getAppUserGuid()));
                messages.addAll(oc.getMessages());
              }
              
            } catch (Exception e) {
              system.debug(logginglevel.error, '>>> ERROR parsing XML: ' + e.getmessage());
              throw new EReaderException('Error parsing XML: ' + e.getmessage());
            }
            
        }
      }
      }
    }  
    
    // Save Result
        try {
        system.debug(logginglevel.info, '>>> Save '+contacts.size()+' User GUIDs on contacts...');
        update contacts.values();
        
    } catch (Exception e) {
      system.debug(logginglevel.error, '>>> ERROR saving GUIDs on contacts: ' + e.getmessage());
      throw new EReaderException('Error llamando WS: ' + e.getmessage());
    }
    
    // Display the error messages
    if(!messages.isEmpty()) {
      system.debug(logginglevel.warn, '>>> ERRORES generating E-Reader access for opportunity ' + messages);
      String sss = 'test';
      for(String s : messages)
        sss += s + '\n';      
      throw new EReaderException(sss);
    }
    
      return 1;
    }
    
    public class EReaderWSSoapTester extends WS_EReader.EReaderWSSoap {
      public override virtual String CreateOnlineContact(String productId,String firstName,String lastName,String email,String applicationId,String allowContactEmails,String materialNumber,String materialDescription) {
        return '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><ns3:TocHeader xmlns:ns3="http://toc.schemas.thomson.com/headers/2006-02-01" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns1="http://tlr.schemas.thomson.com/headers/2006-02-01" xmlns:ns2="http://ecom.toc.schemas.thomson.com/headers/2007-06-01" softwareName="" softwareId="" versionXsd=""><ns3:Message><ns3:Id><ns3:MessageId>8d42cc06-950f-4b8f-a4c3-675c7ada3d5d</ns3:MessageId><ns3:MessageGroupId xsi:nil="true" /><ns3:TimeStamp>2012-08-23T08:28:50.091-0500</ns3:TimeStamp></ns3:Id><ns3:X><ns1:RootId>i0adc45960000013953abc4ac68ba0781</ns1:RootId><ns1:ParentId xsi:nil="true" /><ns1:UserId xsi:nil="true" /><ns1:SessionId xsi:nil="true" /><ns1:BusinessUnit xsi:nil="true" /><ns1:ProductFeature xsi:nil="true" /><ns2:ServerName>eccsoa009-11.int.westgroup.com</ns2:ServerName><ns2:ServiceVersion>12.05</ns2:ServiceVersion></ns3:X></ns3:Message></ns3:TocHeader></soapenv:Header><soapenv:Body><ns1:CreateOnlineContactResponse xmlns:ns1="http://ecom.toc.services.thomson.com/1.0/entitlement" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><confirmations xsi:nil="true" /><trackingId>i0adc45960000013953abc4af68ba0782</trackingId><onlineContact><contactId xsi:nil="true" /><firstName>Cristian</firstName><lastName>Marrapodi</lastName><email>cristian.marrapodi@thomsonreuters.com</email><phone xsi:nil="true" /><contactType xsi:nil="true" /><status xsi:nil="true" /><createDate xsi:nil="true" /><companyId xsi:nil="true" /><sourceId xsi:nil="true" /><account xsi:nil="true" /><endDate xsi:nil="true" /><entitlements><applicationId>EREADER</applicationId><inactivatable>true</inactivatable><logonName xsi:nil="true" /><status>ACTIVE</status><appUserId>9995002374</appUserId><appUserPassword>086C1063345054</appUserPassword><appUserRefId xsi:nil="true" /><appUserGuid>i0adc1e100000013953abc5e4ce0ada07</appUserGuid><accessStartDate xsi:nil="true" /><accessEndDate xsi:nil="true" /><lastLogonDate xsi:nil="true" /><registered>false</registered><transparent>false</transparent><authenticationSystem /><authId /><appUserRefIdNickName xsi:nil="true" /><appUserRefIdPrimary xsi:nil="true" /><authFirstName xsi:nil="true" /><authLastName xsi:nil="true" /><authEmail xsi:nil="true" /><lastPasswordChangeDate xsi:nil="true" /><statusReason xsi:nil="true" /><detailsIncomplete>true</detailsIncomplete><subscriptions><number xsi:nil="true" /><material><materialNumber>40065649</materialNumber><description>CICLO DE ACTUAL IMPOSIT AGROPECU NC 2011</description><materialType /><internalDescription xsi:nil="true" /></material><soldToAccount /><applicationId>EREADER</applicationId><lines xsi:nil="true" /><type /><bandRange xsi:nil="true" /><licenseKeyCode xsi:nil="true" /><mlaNumber xsi:nil="true" /><purchaseOrder xsi:nil="true" /><startDate xsi:nil="true" /><endDate xsi:nil="true" /><trialOffer>false</trialOffer><rentalSub>false</rentalSub><status>SUCCESS</status><message>Material 40065649 not configured for ebook access.</message></subscriptions></entitlements><position xsi:nil="true" /><initials xsi:nil="true" /><unit xsi:nil="true" /><activity xsi:nil="true" /><onlineContactType xsi:nil="true" /><onlineContactTypeDescription xsi:nil="true" /><summerAssociateYear xsi:nil="true" /><warningFlag xsi:nil="true" /><allowContactEmails>true</allowContactEmails><gradDate xsi:nil="true" /><contactStatus>SUCCESS</contactStatus><requestId></requestId></onlineContact></ns1:CreateOnlineContactResponse></soapenv:Body></soapenv:Envelope>';
      }
    }
    
    public class OnlineContact {
      public String fname {get;set;}
      public String lname {get;set;}
      public String email {get;set;}
      public boolean allowContactEmails {get;set;}
      public List<Entitlement> entitlements {get;set;}
      public OnlineContact() {
        this.entitlements = new List<Entitlement>();
      }
      public String getAppUserGuid() {
        return !entitlements.isEmpty() ? entitlements[0].appUserGuid : '';
      }
      public void log() {
        system.debug(logginglevel.info, '------- ONLINE CONTACT ');
        system.debug(logginglevel.info, '- fname: ' + fname);
        system.debug(logginglevel.info, '- lname: ' + lname);
        system.debug(logginglevel.info, '- email: ' + email);
        system.debug(logginglevel.info, '- allowContactEmails: ' + allowContactEmails);
        for(Entitlement e : entitlements)
          e.log();
        system.debug(logginglevel.info, '---------------------');
      }
      public List<String> getMessages() {
        List<String> msg = new List<String>();
        for(Entitlement e : this.entitlements) {
          msg.addAll(e.getSubscriptionMessages());
        }
        return msg;
      }
    }
    
    public class Entitlement {
      public String applicationId {get;set;}
      public String status {get;set;}
      public String appUserId {get;set;}
      public String appUserPassword {get;set;}
      public String appUserGuid {get;set;}
      public List<Subscription> subscriptions {get;set;}
      public Entitlement() {
        this.subscriptions = new List<Subscription>();
      }
      public void log() {
        system.debug(logginglevel.info, '     ------- ENTITLEMENT ');
        system.debug(logginglevel.info, '     - applicationId: ' + applicationId);
        system.debug(logginglevel.info, '     - status: ' + status);
        system.debug(logginglevel.info, '     - appUserId: ' + appUserId);
        system.debug(logginglevel.info, '     - appUserPassword: ' + appUserPassword);
        system.debug(logginglevel.info, '     - appUserGuid: ' + appUserGuid);
        for(Subscription s : subscriptions)
          s.log();
        system.debug(logginglevel.info, '     ---------------------');
      }
      public List<String> getSubscriptionMessages() {
        List<String> msg = new List<String>();
        for(Subscription s : this.subscriptions) {
          if(s.hasStatusMessage())
            msg.add(s.message);
        }
        return msg;
      }
    }
    
    public class Subscription {
      public String applicationId {get;set;}
      public String status {get;set;}
      public String message {get;set;}
      public Material mater {get;set;}
      public Subscription() {
        this.mater = new Material();
      }
      public void log() {
        system.debug(logginglevel.info, '        ------- SUBSCRIPTION ');
        system.debug(logginglevel.info, '        - applicationId: ' + applicationId);
        system.debug(logginglevel.info, '        - status: ' + status);
        system.debug(logginglevel.info, '        - message: ' + message);
        mater.log();
        system.debug(logginglevel.info, '        ---------------------');
      }
      public boolean hasStatusMessage() {
        return this.message != null;
      }
    }
    
    public class Material {
      public String materialNumber {get;set;}
      public String description {get;set;}
      public void log() {
        system.debug(logginglevel.info, '           ------- MATERIAL ');
        system.debug(logginglevel.info, '           - materialNumber: ' + materialNumber);
        system.debug(logginglevel.info, '           - description: ' + description);
        system.debug(logginglevel.info, '           ---------------------');
      }
    }
    
    public class XMLReader {
      
      public List<OnlineContact> parseXML(String wsResponse) {
        system.debug(logginglevel.info, '>>> Parsing XML...');
        system.debug('>>> ' + wsResponse);
        return parseCDATA(wsResponse);
      }
      
      public List<OnlineContact> parseCDATA(String s) {
        system.debug(logginglevel.info, '>>> Parsing CDATA...');
        List<OnlineContact> res = new List<OnlineContact>();
        
        Dom.Document doc = new Dom.Document();
        doc.load(s);
        
        Dom.Xmlnode root = doc.getRootElement();
        system.debug(logginglevel.info, '>>> root: ' + root.getName());
        Dom.Xmlnode body = root.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
        system.debug(logginglevel.info, '>>> body: ' + body);
        Dom.Xmlnode onlResponse = body.getChildElement('CreateOnlineContactResponse', 'http://ecom.toc.services.thomson.com/1.0/entitlement');
        
        for(Dom.Xmlnode child : onlResponse.getChildElements()) {
          if(child.getName() == 'onlineContact') {
            OnlineContact oc = parseOnlineContact(child);
            res.add(oc);
          }
      }
      
      return res;
      }
      
   @TestVisible   private OnlineContact parseOnlineContact(Dom.XmlNode node) {
        OnlineContact oc = new OnlineContact();
        system.debug(logginglevel.info, '>>> Parsing ONLINE CONTACT');
        oc.fname = node.getChildElement('firstName', null).getText();
        oc.lname = node.getChildElement('lastName', null).getText();
        oc.email = node.getChildElement('email', null).getText();
        oc.allowContactEmails = Boolean.valueOf(node.getChildElement('allowContactEmails', null).getText());
        
        for(Dom.Xmlnode child : node.getChildElements()) {
          if(child.getName() == 'entitlements') {
            oc.entitlements.add(parseEntitlement(child));
          }
      }
      oc.log();    
        return oc;
      }
      
      private Entitlement parseEntitlement(Dom.XmlNode node) {
        system.debug(logginglevel.info, '>>> Parsing ENTITLEMENT');
        Entitlement e = new Entitlement();
        e.applicationId = node.getChildElement('applicationId', null).getText();
        e.status = node.getChildElement('status', null).getText();
        e.appUserId = node.getChildElement('appUserId', null).getText();
        e.appUserPassword = node.getChildElement('appUserPassword', null).getText();
        e.appUserGuid = node.getChildElement('appUserGuid', null).getText();
        
        for(Dom.Xmlnode child : node.getChildElements()) {
          if(child.getName() == 'subscriptions') {
            e.subscriptions.add(parseSubscription(child));
          }
      }
      
        return e;
      }
      
      private Subscription parseSubscription(Dom.XmlNode node) {
        system.debug(logginglevel.info, '>>> Parsing SUBSCRIPTION');
        Subscription s = new Subscription();
        s.applicationId = node.getChildElement('applicationId', null).getText();
        s.status = node.getChildElement('status', null).getText();
        if(node.getChildElement('message', null) != null)
          s.message = node.getChildElement('message', null).getText();
        s.mater = parseMaterial(node.getChildElement('material', null));
        return s;
      }
      
      private Material parseMaterial(Dom.XmlNode node) {
        system.debug(logginglevel.info, '>>> Parsing MATERIAL');
        Material m = new Material();
        m.materialNumber = node.getChildElement('materialNumber', null).getText();
        m.description = node.getChildElement('description', null).getText();
        return m;
      }
      
      private void showChilds(Dom.Xmlnode root) {
        system.debug(logginglevel.info, '>>> Showing childs of ' + root.getName());
        for(Dom.Xmlnode child : root.getChildElements()) {
        system.debug(logginglevel.info, '>>> *child: ' + child.getName() + '  *ns:' + child.getNamespace());
      }
      }
    }
    
  /*  static testmethod void test() {
      Account a = TestTools.getBuinessAccountForTest();
        a.BillingCity = 'Mar del Plata';
        a.BillingStreet = 'Colon 2393';
        a.Zona_de_Cobranza__c = 'La placita';
        insert a;
        
        Contact cont = TestTools.getContactForTest();
        cont.accountId = a.id;
        insert cont;
        
        Opportunity op = TestTools.getOpportunity([select id from RecordType where sobjectType = 'Opportunity' and developerName = 'Suscripcion'].id);
        op.accountId = a.id;
        op.Fecha_Inicio_Suscripcion__c = system.today().addDays(-1);
        op.Fecha_Finalizacion_Suscripcion__c = system.today();
        op.type = 'VIP';
        insert op;
        
        Product2 prod = TestTools.getProduct();
        insert prod;
        
        Entitlement__c e = TestTools.getEntitlement();
        insert e;
        
        EntitlementProduct__c ep = TestTools.getEntitlementProduct(prod.id, e.id);
        insert ep;
        
        Pricebook2 book = TestTools.getPricebookStandard();
        
        PricebookEntry entry = TestTools.getPricebookEntry(book.id, prod.id);   
        insert entry;
        
        OpportunityLineItem li = TestTools.getOpportunityLineItem(op.id, entry.id);
        insert li;
        
        OpportunityProductDetail__c d = TestTools.getdetailLineItem(op.id, li.id, cont.id);
        d.product__c = prod.id;
        insert d;
        
        Test.startTest();
          Wrapper_EReader.generateAccessEReaderWS(op.id);
        Test.stopTest();
    }  */
}