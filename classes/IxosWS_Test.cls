@istest
Public with Sharing class IxosWS_Test{
    private static testMethod void testController(){
    
        IxosWS testObj =new IxosWS();
        IxosWS.GetIXOSDocumentDetails_element testObj4 =new IxosWS.GetIXOSDocumentDetails_element();
        IxosWS.GetIXOSDocumentDetailsResponse_element  testObj2 =new IxosWS.GetIXOSDocumentDetailsResponse_element ();
        
        List<IxosWSObjects.DocumentHeader> IxObj = new List<IxosWSObjects.DocumentHeader>();
        List<String> str = new List<String>();
        
        IxosWS.IXOSDocument_v2_0Port testObj3 =new IxosWS.IXOSDocument_v2_0Port();
        testObj3.inputHttpHeaders_x = new Map<String,String>();
        testObj3.outputHttpHeaders_x = new Map<String,String>();
        testObj3.clientCertName_x = '';
        testObj3.clientCert_x = '';
        testObj3.clientCertPasswd_x = '';
        testObj3.timeout_x = 0;
        
        try{
            testObj3.GetIXOSDocumentDetails('test', IxObj,'test','test','test','test',system.today(),system.today(),str);
        }
        catch(exception ex){
        }
        
        
    }
}