@isTest
public class IDQContactCreateObjects_Test { 

    public static testMethod void testIDQ() {
        IDQContactCreateObjects.WS_CREATE_EXISTING_CONTACTResponseElement_element resElm = new IDQContactCreateObjects.WS_CREATE_EXISTING_CONTACTResponseElement_element ();
        IDQContactCreateObjects.WS_CREATE_EXISTING_CONTACTRequestType reqType = new IDQContactCreateObjects.WS_CREATE_EXISTING_CONTACTRequestType (); 
        IDQContactCreateObjects.WS_CREATE_EXISTING_CONTACTResponseType resType = new IDQContactCreateObjects.WS_CREATE_EXISTING_CONTACTResponseType ();
        IDQContactCreateObjects.WS_CREATE_EXISTING_CONTACTRequestElement_element reqElm = new IDQContactCreateObjects.WS_CREATE_EXISTING_CONTACTRequestElement_element ();
        
        IDQContactCreate.wf_m_MCM_EXISTING_CONTACT_CREATEPort conCreate = new IDQContactCreate.wf_m_MCM_EXISTING_CONTACT_CREATEPort ();
        try {
            resElm = conCreate.wf_m_MCM_EXISTING_CONTACT_CREATEOperation(reqElm);
        }
        catch(Exception ex) {}
        
    }
 }