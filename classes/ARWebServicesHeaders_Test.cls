@isTest//(seeAllData=true)
public class ARWebServicesHeaders_Test{
     public static testmethod void testARWebServicesHeaders(){
         Test.startTest();
             ARWebServicesHeaders arSerHObj = new ARWebServicesHeaders();
             ARWebServicesHeaders.TocHeader_element tocHeadEle = new ARWebServicesHeaders.TocHeader_element();
             ARWebServicesHeaders.Id_element idEle = new ARWebServicesHeaders.Id_element();
             ARWebServicesHeaders.Message_element msgEle = new ARWebServicesHeaders.Message_element();
             ARWebServicesHeaders.X_element xEle = new ARWebServicesHeaders.X_element();
         Test.stopTest();
     }
}