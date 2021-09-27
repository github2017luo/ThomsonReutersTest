@isTest
public class ECMSearchPartyWSDLTest {

    public static testMethod void ECMSearchPartyWSDLMethod(){
        
        ECMSearchPartyWSDL.ESIHEADER eAIhed = new ECMSearchPartyWSDL.ESIHEADER();
        ECMSearchPartyWSDL.Hierarchy hiera= new ECMSearchPartyWSDL.Hierarchy();
        ECMSearchPartyWSDL.ArrayOfPartyAddressIdentifier addId= new ECMSearchPartyWSDL.ArrayOfPartyAddressIdentifier();
        ECMSearchPartyWSDL.ArrayOfSICCode sicco= new ECMSearchPartyWSDL.ArrayOfSICCode();
        ECMSearchPartyWSDL.ArrayOfPartyAttribute parAtr= new ECMSearchPartyWSDL.ArrayOfPartyAttribute();
        //ECMSearchPartyWSDL.PartyAttributes partsAtr = new ECMSearchPartyWSDL.PartyAttributes();
        ECMSearchPartyWSDL.PartyAddress parAdd= new ECMSearchPartyWSDL.PartyAddress();

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
        //parAdd.PartyAttributes = partsAtr;
        parAdd.PrimaryAddressIndicator = 'test';
        parAdd.PartyLegalStatus = 'test'; 
        
        ECMSearchPartyWSDL.ArrayOfPartyAddress add = new ECMSearchPartyWSDL.ArrayOfPartyAddress();
        list<ECMSearchPartyWSDL.ArrayOfPartyAddress> parAddList = new list<ECMSearchPartyWSDL.ArrayOfPartyAddress>();
        //add.PartyAddress = parAddlist;
        
        ECMSearchPartyWSDL.ArrayOfHierarchy Hira = new ECMSearchPartyWSDL.ArrayOfHierarchy();
        list<ECMSearchPartyWSDL.ArrayOfHierarchy> hirList = new list<ECMSearchPartyWSDL.ArrayOfHierarchy>();
        //hira.Hierarchy = hirList;
        
        ECMSearchPartyWSDL.PartyAddressIdentifier paraddId = new ECMSearchPartyWSDL.PartyAddressIdentifier();
        paraddId.PartyAddressIdentifierType = 'test';
        paraddId.PartyAddressIdentifierValue = 'test1';
        paraddId.PartyAddressIdentifierCategory = 'test2';
        
        ECMSearchPartyWSDL.RetrievePartyResults serRess= new ECMSearchPartyWSDL.RetrievePartyResults();
        ECMSearchPartyWSDL.RetrievePartyRequest greq = new ECMSearchPartyWSDL.RetrievePartyRequest();
        greq.ESIHeader = eAIhed ; 
        greq.PartyId = '1'; 
        greq.SourceSystemCode = 'test';
        greq.SourceSystemId = 'test1';
        greq.Username = 'Sreenu';
        greq.Password = 'pass';
        greq.AuditToken = 'ad'; 
        //greq.Attribute3 = 'header';
        ECMSearchPartyWSDL.AddressSourceSystem  addsrcsys= new ECMSearchPartyWSDL.AddressSourceSystem();
        addsrcsys.AddressSourceSystemId = 'id';
        addsrcsys.AddressSourceSystemCode = 'test';
       
       
        
       // ECMSearchPartyWSDL.PartyAddress parAdd= new ECMSearchPartyWSDL.PartyAddress();
        ECMSearchPartyWSDL.ArrayOfPartyAddressIdentifier parId= new ECMSearchPartyWSDL.ArrayOfPartyAddressIdentifier();
        ECMSearchPartyWSDL.SICCode sicc= new ECMSearchPartyWSDL.SICCode();
        
        ECMSearchPartyWSDL.ArrayOfAddressSourceSystem addSrcSyss= new ECMSearchPartyWSDL.ArrayOfAddressSourceSystem();
        ECMSearchPartyWSDL.Party part= new ECMSearchPartyWSDL.Party();
        ECMSearchPartyWSDL.ArrayOfSBU SBU = new ECMSearchPartyWSDL.ArrayOfSBU();
        ECMSearchPartyWSDL.ArrayOfPartyIdentifier partsId = new ECMSearchPartyWSDL.ArrayOfPartyIdentifier();
        
        ECMSearchPartyWSDL.SBU sb = new ECMSearchPartyWSDL.SBU();
        ECMSearchPartyWSDL.ArrayOfSourceSystem srcSys = new ECMSearchPartyWSDL.ArrayOfSourceSystem();
        ECMSearchPartyWSDL.ArrayOfSourceSystem srcsys1 = new ECMSearchPartyWSDL.ArrayOfSourceSystem();
        
        try{
            ECMSearchPartyWSDL.MDMV1PortTypePort mdm = new ECMSearchPartyWSDL.MDMV1PortTypePort();
            mdm.RetrieveParty(eAIhed, '1234', 'Admin', 'Password', 'AuditToken', null, null, null);
        }catch(exception e){
            string str = e.getMessage();
        }
        
        
        
    }
}