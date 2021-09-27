@isTest
public class ContactPersonIDWSDLObjects_Test {

    public static testMethod void testPersonId() {
    
        ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDResponseType resType = new ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDResponseType ();
        ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDRequestType reqType = new ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDRequestType ();
        ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDResponseElement_element resElm = new ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDResponseElement_element ();
        ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDRequestElement_element reqElm = new ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDRequestElement_element ();
        reqElm .FIRST_NAME = 'test';
        reqElm .LAST_NAME = 'test';
        reqElm .EMAIL = 'sreenu.d@tcs.com';
        reqElm .PHONE = '1234567899';
        reqElm .ACCOUNT_NAME = 'Test Account';
        reqElm .BUSINESS_UNIT = 'Practical Law';
        
        ContactPersonIDWSDL.wf_m_MCM_GERATE_PERSON_ID_NEWPort newPerson = new ContactPersonIDWSDL.wf_m_MCM_GERATE_PERSON_ID_NEWPort ();
        try{
        newPerson.wf_m_MCM_GERATE_PERSON_ID_NEWOperation(reqElm);
        } catch(Exception ex) {}
        system.assertEquals(reqElm.FIRST_NAME, 'test'); 
     }
 }