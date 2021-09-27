@isTest//(seeAllData=true)
public class ARWebServicesCommon_Test{
     public static testmethod void testARWebServicesCommon(){
         Test.startTest();
             ARWebServicesCommon arSerComObj = new ARWebServicesCommon();
             ARWebServicesCommon.ConfirmationResponse crObj = new ARWebServicesCommon.ConfirmationResponse();
             ARWebServicesCommon.EcomResponse ecRespObj = new ARWebServicesCommon.EcomResponse();
             ARWebServicesCommon.User_x uxObj = new ARWebServicesCommon.User_x();
             ARWebServicesCommon.Address  addObj = new ARWebServicesCommon.Address();
             ARWebServicesCommon.UserContext ucObj = new ARWebServicesCommon.UserContext();
             ARWebServicesCommon.EcomSystem esObj = new ARWebServicesCommon.EcomSystem();
             ARWebServicesCommon.EcomValidation evObj = new ARWebServicesCommon.EcomValidation();
             ARWebServicesCommon.EcomService eSerObj = new ARWebServicesCommon.EcomService();
             ARWebServicesCommon.EcomRequest eReqObj = new ARWebServicesCommon.EcomRequest();
             ARWebServicesCommon.CallbackEvent ebEventObj = new ARWebServicesCommon.CallbackEvent();
             ARWebServicesCommon.Notification notiObj = new ARWebServicesCommon.Notification();
             ARWebServicesCommon.EcomContext eConObj = new ARWebServicesCommon.EcomContext();
             ARWebServicesCommon.Confirmation confObj = new ARWebServicesCommon.Confirmation();
             ARWebServicesCommon.Ecom ecomObj = new ARWebServicesCommon.Ecom();
             ARWebServicesCommon.Property propObj = new ARWebServicesCommon.Property();
         Test.stopTest();
     }
}