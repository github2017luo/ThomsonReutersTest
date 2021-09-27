@isTest
public class ECMSearchServiceWSDL_Test {
    
    public static testMethod void ECMSearchServiceWSDLMethod () {
        ECMSearchServiceWSDL.EAIHeader eAIhed = new ECMSearchServiceWSDL.EAIHeader();
        ECMSearchServiceWSDL.Hierarchy hiera= new ECMSearchServiceWSDL.Hierarchy();
         ECMSearchServiceWSDL.AddressIdentifiers addId= new ECMSearchServiceWSDL.AddressIdentifiers();
         ECMSearchServiceWSDL.SICCodes sicco= new ECMSearchServiceWSDL.SICCodes();
         ECMSearchServiceWSDL.PartyAttribute parAtr= new ECMSearchServiceWSDL.PartyAttribute();
         ECMSearchServiceWSDL.PartyAttributes partsAtr = new ECMSearchServiceWSDL.PartyAttributes();
        ECMSearchServiceWSDL.PartyAddress parAdd= new ECMSearchServiceWSDL.PartyAddress();
        parAdd.AddressRowId = '1';
        parAdd.AddressType ='city';
        parAdd.AddressLine1 ='1';
        parAdd.AddressLine2 = '2';
        parAdd.AddressLine3 = '3';
        parAdd.AddressLine4 = '4';
        parAdd.City = 'Bangalore';
        parAdd.ZipPostalCode = '565656';
        parAdd.County = 'INDIA';
        parAdd.State = 'KA';
        parAdd.Country = 'IN';
        parAdd.AddressIdentifiers = addId;
        parAdd.TaxVATExemptionIndicator = 'Y';
        parAdd.SICCodes = sicco;
        parAdd.PartyAttributes = partsAtr;
        parAdd.PrimaryAddressIndicator = 'test';
        parAdd.PartyLegalStatus = 'test'; 
        ECMSearchServiceWSDL.Addresses add = new ECMSearchServiceWSDL.Addresses();
        list<ECMSearchServiceWSDL.PartyAddress> parAddList = new list<ECMSearchServiceWSDL.PartyAddress>();
        add.PartyAddress = parAddlist;
        ECMSearchServiceWSDL.Hierarchies Hira = new ECMSearchServiceWSDL.Hierarchies();
        list<ECMSearchServiceWSDL.Hierarchy> hirList = new list<ECMSearchServiceWSDL.Hierarchy>();
        hira.Hierarchy = hirList;
        ECMSearchServiceWSDL.PartyAddressIdentifier paraddId = new ECMSearchServiceWSDL.PartyAddressIdentifier();
        paraddId.PartyAddressIdentifierType = 'test';
        paraddId.PartyAddressIdentifierValue = 'test1';
        paraddId.PartyAddressIdentifierCategory = 'test2';
        ECMSearchServiceWSDL.SearchResults serRess= new ECMSearchServiceWSDL.SearchResults();
        ECMSearchServiceWSDL.SearchPartyResponse spres= new ECMSearchServiceWSDL.SearchPartyResponse();
        spres.SearchPartyResponseResult = serRess; 
        ECMSearchServiceWSDL.GetRequest greq = new ECMSearchServiceWSDL.GetRequest();
        greq .EAIHeader = eAIhed ; 
        greq.RowId = '1'; 
        greq.SourceSystemCode = 'test';
        greq.SourceSystemId = 'test1';
        greq.Username = 'Sreenu';
        greq.Password = 'pass';
        greq.AuditToken = 'ad'; 
        greq.Header = 'header';
        ECMSearchServiceWSDL.AddressSourceSystem  addsrcsys= new ECMSearchServiceWSDL.AddressSourceSystem();
        addsrcsys.AddressSourceSystemId = 'id';
        addsrcsys.AddressSourceSystemCode = 'test';
       
       
        
       // ECMSearchServiceWSDL.PartyAddress parAdd= new ECMSearchServiceWSDL.PartyAddress();
        ECMSearchServiceWSDL.PartyIdentifiers parId= new ECMSearchServiceWSDL.PartyIdentifiers();
        ECMSearchServiceWSDL.SearchParty serPar= new ECMSearchServiceWSDL.SearchParty();
        
        ECMSearchServiceWSDL.GetResults gResu= new ECMSearchServiceWSDL.GetResults();
        ECMSearchServiceWSDL.SICCode sicc= new ECMSearchServiceWSDL.SICCode();
        
        ECMSearchServiceWSDL.GetPartyResponse gparRes = new ECMSearchServiceWSDL.GetPartyResponse();
        ECMSearchServiceWSDL.SearchRequest serReq= new ECMSearchServiceWSDL.SearchRequest();
        ECMSearchServiceWSDL.AddressSourceSystems addSrcSyss= new ECMSearchServiceWSDL.AddressSourceSystems();
        ECMSearchServiceWSDL.Party part= new ECMSearchServiceWSDL.Party();
        ECMSearchServiceWSDL.SBUs SBU = new ECMSearchServiceWSDL.SBUs();
        ECMSearchServiceWSDL.Parties parts = new ECMSearchServiceWSDL.Parties();
        ECMSearchServiceWSDL.PartyIdentifier partsId = new ECMSearchServiceWSDL.PartyIdentifier();
        
        ECMSearchServiceWSDL.SBU sb = new ECMSearchServiceWSDL.SBU();
        ECMSearchServiceWSDL.SourceSystems srcSys = new ECMSearchServiceWSDL.SourceSystems();
        
        ECMSearchServiceWSDL.GetParty gPart= new ECMSearchServiceWSDL.GetParty();
        ECMSearchServiceWSDL.SourceSystem srcsys1 = new ECMSearchServiceWSDL.SourceSystem();
        try {
        ECMSearchServiceWSDL.IcglV1PortTypePort icg = new ECMSearchServiceWSDL.IcglV1PortTypePort();
        icg.SearchParty(eAIhed, 'Test', 'AP', 'End', 'TestEnd', 'ad', 'Chicago', 'IL', 'US', '6162-6251', 1, 1, '', '', '', '');
        }
        catch(exception ex) {
        string str = ex.getMessage();
        //system.assert(str.contains('Methods defined as TestMethod do not support Web service callouts, test skipped'));
        }
        
        
    }
 }