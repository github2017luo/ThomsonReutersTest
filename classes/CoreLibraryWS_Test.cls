@ istest
public class CoreLibraryWS_Test{
  public static testMethod void testWebServiceSchema() {
    CoreLibraryWS testobj = new CoreLibraryWS();
    CoreLibraryWS.GetCoreLibraries_element testobj1= new CoreLibraryWS.GetCoreLibraries_element();
    CoreLibraryWS.CoreLibrary_v3_0Port testobj2= new CoreLibraryWS.CoreLibrary_v3_0Port();
    CoreLibraryWS.GetCoreLibrariesResponse_element testobj3= new CoreLibraryWS.GetCoreLibrariesResponse_element();
    CoreLibraryWS.GetCoreLibraryCodesResponse_element testobj4= new CoreLibraryWS.GetCoreLibraryCodesResponse_element();
    CoreLibraryWS.CoreLibrary testobj5= new CoreLibraryWS.CoreLibrary();
    CoreLibraryWS.GetCoreLibraryCodes_element testobj7= new CoreLibraryWS.GetCoreLibraryCodes_element();
  

    testobj2.GetCoreLibraries(1,'test');
    testobj2.GetAccountCoreLibraryMaterials('test',1,new CoreLibraryWS.CoreLibrary[]{});
    testobj2.GetCoreLibraryCodes(1);
    
    CoreLibraryWS.GetAccountCoreLibraryMaterials_element testobj8 = new CoreLibraryWS.GetAccountCoreLibraryMaterials_element();
    CoreLibraryWS.CoreLibraryMaterial testobj9 = new CoreLibraryWS.CoreLibraryMaterial();
    CoreLibraryWS.GetAccountCoreLibraryMaterialsResponse_element testobj10 = new CoreLibraryWS.GetAccountCoreLibraryMaterialsResponse_element();
   // testobj2.CalculatePda('test',new String[]{'test'},0,0);
    //testobj2.GetSubLineItem('test',0,'test','test','test','test','test');
       
  }
 }