@isTest
global class CDSSearchServiceMockTest implements WebServiceMock {
    global String calloutType;
   
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            system.debug('++++ inside do invoke');
            system.debug('++++ calloutType');
            system.debug('++++ calloutType +++ '+ calloutType);
            system.debug('++++ endpoint +++ '+ endpoint);
            if(endpoint == 'CDSContactSearchService.com'){
                system.debug('++++ inside call out type');
                
                CDSSearchServiceWsdl.CDS_Output_Detail_element [] outputDetailsArray = 
                    new List<CDSSearchServiceWsdl.CDS_Output_Detail_element>();
                
                CDSSearchServiceWsdl.CDS_Output_Detail_element outputDetails = new CDSSearchServiceWsdl.CDS_Output_Detail_element();
                outputDetails.Source_System_ID='1';
                outputDetails.Title='CEO';
                outputDetails.First_Name='Test';
                outputDetails.Last_Name='last';
                outputDetails.Contact_Email='ap@test.com';
                outputDetails.Contact_Phone='098-098-0987';
                outputDetails.Job_Function='Developer';
                outputDetails.Account_Name='Test Acocunt';
                outputDetails.Account_Address='1 Market St';
                outputDetails.City='San Jose';
                outputDetails.State='CA';
                outputDetails.Country='US';
                outputDetails.ZIP_Code='34454';
                outputDetails.Party_ID='123456';
                outputDetails.PERSON_ID=12345;
                outputDetails.GLI_Account_ID='';
                outputDetails.Contact_Inactive=false; // Added by Shovon for CRM-6056
                outputDetailsArray.add(outputDetails);
                
                
                CDSSearchServiceWsdl.CDS_Output_Summary_element gse = 
                    new CDSSearchServiceWsdl.CDS_Output_Summary_element();
                gse.CDS_Output_Summary ='test';
                gse.CDS_Output_Detail = outputDetailsArray;     
                
                
                CDSSearchServiceWsdl.GLI_Contact_Output gco = new CDSSearchServiceWsdl.GLI_Contact_Output();
                gco.CDS_Output_Summary = new list<CDSSearchServiceWsdl.CDS_Output_Summary_element>{gse};
                    response.put('response_x', gco); 
                
            }else if(endpoint=='ECMSearchServiceWS.com'){
                recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' and isActive=true limit 1];
                
                Account acc = [select id, name, phone, billingcountry, billingstate, billingpostalcode, is_gli__c from account where name ='Child Test Account'];
                
                ECMSearchServiceWSDL.AddressSourceSystem ecmAddressSourceSystem = new ECMSearchServiceWSDL.AddressSourceSystem();
                ecmAddressSourceSystem.addresssourcesystemid = 'OTH'+ acc.Id;
                ecmAddressSourceSystem.AddressSourceSystemCode ='LGLSFDCGLI';
                
                
                ECMSearchServiceWSDL.AddressSourceSystems ecmAddressSourceSystems = new ECMSearchServiceWSDL.AddressSourceSystems();
                ecmAddressSourceSystems.AddressSourceSystem.add(ecmAddressSourceSystem);
                
                ECMSearchServiceWSDL.PartyAddress ecmPartyAddress = new ECMSearchServiceWSDL.PartyAddress();
                ecmPartyAddress.AddressSourceSystems = ecmAddressSourceSystems;
                
                ECMSearchServiceWSDL.Addresses ecmAddresses = new ECMSearchServiceWSDL.Addresses();
                ecmAddresses.PartyAddress.add(ecmPartyAddress);
                
                ECMSearchServiceWSDL.Party ecmParty = new ECMSearchServiceWSDL.Party();
                ecmParty.partyrowid='16063635';
                ecmParty.FullName ='MARSHALL MOTOR GROUP LTD';
                ecmParty.Addresses = ecmAddresses;
                
                ECMSearchServiceWSDL.Party[] partyArray = new list<ECMSearchServiceWSDL.Party>();
                partyArray.add(ecmParty);
                
                ECMSearchServiceWSDL.Parties parties = new ECMSearchServiceWSDL.Parties();
                parties.Party = partyArray;
                
                ECMSearchServiceWSDL.SearchResults result = new  ECMSearchServiceWSDL.SearchResults();
                result.Parties = parties;
                
                ECMSearchServiceWSDL.SourceSystem sourceSystem = new ECMSearchServiceWSDL.SourceSystem();
                sourceSystem.SourceSystemId='1';
                sourceSystem.SourceSystemCode='2';
            }else if(endpoint=='ECMSearchServiceParty.com'){
                recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' and isActive=true limit 1];
                
                Account acc = [select id, name, phone, billingcountry, billingstate, billingpostalcode, is_gli__c from account where name ='Child Test Account'];
                
                ECMSearchPartyWSDL.AddressSourceSystem [] ecmAddressSourceSystemArray = new List<ECMSearchPartyWSDL.AddressSourceSystem>();
                ECMSearchPartyWSDL.AddressSourceSystem ecmAddressSourceSystem = new ECMSearchPartyWSDL.AddressSourceSystem();
                ecmAddressSourceSystem.addresssourcesystemid = 'OTH'+ acc.Id;
                ecmAddressSourceSystem.AddressSourceSystemCode ='LGLSFDCGLI';
                ecmAddressSourceSystemArray.add(ecmAddressSourceSystem);
                
                ECMSearchPartyWSDL.ArrayOfAddressSourceSystem ecmAddressSourceSystems = new ECMSearchPartyWSDL.ArrayOfAddressSourceSystem();
                ecmAddressSourceSystems.AddressSourceSystem = ecmAddressSourceSystemArray;
                
                ECMSearchPartyWSDL.PartyAddress [] ecmPartyAddressArray = new List<ECMSearchPartyWSDL.PartyAddress>();
                ECMSearchPartyWSDL.PartyAddress ecmPartyAddress = new ECMSearchPartyWSDL.PartyAddress();
                ecmPartyAddress.AddressSourceSystems = ecmAddressSourceSystems;
                ecmPartyAddressArray.add(ecmPartyAddress);
                
                
                ECMSearchPartyWSDL.ArrayOfPartyAddress ecmAddresses = new ECMSearchPartyWSDL.ArrayOfPartyAddress();
                ecmAddresses.PartyAddress=ecmPartyAddressArray;
                
                ECMSearchPartyWSDL.Party ecmParty = new ECMSearchPartyWSDL.Party();
                ecmParty.partyrowid='16063635';
                ecmParty.FullName ='MARSHALL MOTOR GROUP LTD';
                ecmParty.Addresses = ecmAddresses;
                
                ECMSearchPartyWSDL.RetrievePartyResults partyResult = new ECMSearchPartyWSDL.RetrievePartyResults();
                partyResult.Party = ecmParty;
                
                response.put('response_x', partyResult);
                
            }
            
        }
}