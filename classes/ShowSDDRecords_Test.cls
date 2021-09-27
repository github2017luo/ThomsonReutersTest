/*
======================================================================================================================
TEST CLASS NAME: ShowSDDRecords_Test
======================================================================================================================
PURPOSE:    ShowSDDRecords class.

CHANGE HISTORY:
======================================================================================================================
  DATE                  NAME                           DESC

2018/06/08            CXD ODT                
======================================================================================================================
*/
@istest
public class ShowSDDRecords_Test{
    
    public static testMethod void testSDDRecordsController(){
        
        Account a = New Account();
        a.Name = 'Test Account';
        insert a;
        ShowSDDRecords sddComp = New ShowSDDRecords();
        sddComp.setrecordId(a.id);
        sddComp.getrecordId();
        sddComp.getPageNameVal();
        sddComp.setpageNameVal('contactsList');
        sddComp.getSelected();
        sddComp.changeToSDD();
        sddComp.queryData();
        sddcomp.selectedOptionVal = 'existing';
        sddcomp.getOpportunities();
        sddcomp.blankOptionVal();
        sddcomp.isClosedPopup();
        sddcomp.newCustomerRedirect();
    }
}