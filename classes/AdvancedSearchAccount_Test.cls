/**
 * Validates the functionality provided by the AdvancedSearchAccount class
 *
 * @author  John De Santiago
 * @version 2012-08-03
 */
@IsTest
private class AdvancedSearchAccount_Test {

    /**
     * Tests that the CompareTo method is aware of the supported
     * fields values
     */
    private static testMethod void testSortByComparison() {
        //Setup Test
        AdvancedSearchAccount oAdvancedSearchAccount1 = new AdvancedSearchAccount();
        oAdvancedSearchAccount1.SortAscending = true;
        oAdvancedSearchAccount1.Name = 'Test';
        
        AdvancedSearchAccount oAdvancedSearchAccount2 = new AdvancedSearchAccount();
        oAdvancedSearchAccount2.Name = 'Test 2';
        
        //Execute Test
        Test.startTest();
        oAdvancedSearchAccount1.SortBy = '';
        integer iCompare = oAdvancedSearchAccount1.compareTo(oAdvancedSearchAccount2);
        
        oAdvancedSearchAccount1.SortBy = 'Name';
        iCompare = oAdvancedSearchAccount1.compareTo(oAdvancedSearchAccount2);
        
        oAdvancedSearchAccount1.SortBy = 'Name2';
        iCompare = oAdvancedSearchAccount1.compareTo(oAdvancedSearchAccount2);
        
        oAdvancedSearchAccount1.SortBy = 'Name3';
        iCompare = oAdvancedSearchAccount1.compareTo(oAdvancedSearchAccount2);
        
        oAdvancedSearchAccount1.SortBy = 'SAPAccountNumber';
        iCompare = oAdvancedSearchAccount1.compareTo(oAdvancedSearchAccount2);
        
        oAdvancedSearchAccount1.SortBy = 'Phone1';
        iCompare = oAdvancedSearchAccount1.compareTo(oAdvancedSearchAccount2);
        
        oAdvancedSearchAccount1.SortBy = 'AddressLine1';
        iCompare = oAdvancedSearchAccount1.compareTo(oAdvancedSearchAccount2);
        
        oAdvancedSearchAccount1.SortBy = 'City';
        iCompare = oAdvancedSearchAccount1.compareTo(oAdvancedSearchAccount2);
        
        oAdvancedSearchAccount1.SortBy = 'State';
        iCompare = oAdvancedSearchAccount1.compareTo(oAdvancedSearchAccount2);
        
        oAdvancedSearchAccount1.SortBy = 'NumberOfAttorneyLocations';
        iCompare = oAdvancedSearchAccount1.compareTo(oAdvancedSearchAccount2);
        
        oAdvancedSearchAccount1.SortBy = 'NumberOfAttorneyOrg';
        iCompare = oAdvancedSearchAccount1.compareTo(oAdvancedSearchAccount2);
        
        oAdvancedSearchAccount1.SortBy = 'TotalActiveSubs';
        iCompare = oAdvancedSearchAccount1.compareTo(oAdvancedSearchAccount2);
        
        oAdvancedSearchAccount1.SortBy = 'TotalLapsedSubs';
        iCompare = oAdvancedSearchAccount1.compareTo(oAdvancedSearchAccount2);
        
        oAdvancedSearchAccount1.SortBy = 'ContactName';
        iCompare = oAdvancedSearchAccount1.compareTo(oAdvancedSearchAccount2);
        
        oAdvancedSearchAccount1.SortBy = 'ZipCode';
        iCompare = oAdvancedSearchAccount1.compareTo(oAdvancedSearchAccount2);
        
        Test.stopTest();    
    }
    
    /**
     * Validates the custom implementation of CompareTo on the AdvancedSearchAccount
     * object which is used to sort data based on the specified direction and field name
     */
    private static testMethod void testCompareTo() {
        //Setup Test
        
        AdvancedSearchAccount oAdvancedSearchAccount1 = new AdvancedSearchAccount();
        oAdvancedSearchAccount1.SortAscending = true;
        oAdvancedSearchAccount1.Name = 'Test';
        oAdvancedSearchAccount1.TotalActiveSubs = 10;
        
        AdvancedSearchAccount oAdvancedSearchAccount2 = new AdvancedSearchAccount();
        oAdvancedSearchAccount2.Name = 'Test 2';
        oAdvancedSearchAccount2.TotalActiveSubs = 20;
        
        AdvancedSearchAccount oAdvancedSearchAccount3 = new AdvancedSearchAccount();
        oAdvancedSearchAccount3.Name = 'Test 3';
        oAdvancedSearchAccount3.TotalActiveSubs = 3;
        
        //Execute Test
        Test.startTest();
        
        oAdvancedSearchAccount1.SortBy = 'Name';
        integer iCompare1 = oAdvancedSearchAccount1.compareTo(oAdvancedSearchAccount2);
        
        oAdvancedSearchAccount1.SortBy = 'TotalActiveSubs';
        integer iCompare2 = oAdvancedSearchAccount1.compareTo(oAdvancedSearchAccount2);
        
        oAdvancedSearchAccount1.SortBy = 'TotalActiveSubs';
        integer iCompare3 = oAdvancedSearchAccount1.compareTo(oAdvancedSearchAccount3);
        
        Test.stopTest();
        
        //Validate Test
        System.assert(iCompare1 < 0, 'Expected comparison to indicate that the Name is less than the current value');
        System.assert(iCompare2 < 0, 'Expected comparison to indicate that the TotalActiveSubs value is greater than the current value');
        System.assert(iCompare3 > 0, 'Expected comparison to indicate that the TotalActiveSubs value is less than current value');
    }
}