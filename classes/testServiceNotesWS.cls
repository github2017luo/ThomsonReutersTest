@isTest
public class testServiceNotesWS
{
    public static testMethod void testServiceNotesWS()
    {
        ServiceNotesWS testObj = new ServiceNotesWS();
        ServiceNotesWS.GetServiceNoteItems_element testObj2 = new ServiceNotesWS.GetServiceNoteItems_element();
        ServiceNotesWS.GetServiceNoteItemsResponse_element testObj3 = new ServiceNotesWS.GetServiceNoteItemsResponse_element();
        ServiceNotesWS.GetServiceNoteDetail_element testObj4 = new ServiceNotesWS.GetServiceNoteDetail_element();
        ServiceNotesWS.GetServiceNoteDetailResponse_element testObj5 = new ServiceNotesWS.GetServiceNoteDetailResponse_element();
        ServiceNotesWS.ServiceNote_v3_0Port testObj6 = new ServiceNotesWS.ServiceNote_v3_0Port();
        testObj6.GetServiceNoteItems('sys',new Decimal[]{0},System.Date.Today(),System.Date.Today());
        testObj6.GetServiceNoteDetail('sys', 'sys');
    }
}