/**
 * Validates the functionality provided by the TerritoryUtil class
 *
 * @author  John De Santiago
 * @version 2011-06-23
 */
@IsTest
private class TerritoryUtil_Test {

    /**
     * Validates the mapAccountTerritoryMembers method
     */
    private static testMethod void testMapAccountTerritoryMembers() {
        //Setup Test
        Account oAccountA = UnitTest.getAccountInstance();
        oAccountA.RecordTypeId = AccountUtil.CustomerRecordTypeId;
        insert oAccountA;
        
        Account oAccountB = UnitTest.getAccountInstance();
        oAccountB.RecordTypeId = AccountUtil.ProspectRecordTypeId;
        insert oAccountB;
        
        UserTerritory2Association   oUserTerritory = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association   WHERE IsActive=true LIMIT 1];
        UserTerritory2Association   oUserTerritory2 = [SELECT Id, Territory2Id, UserId FROM UserTerritory2Association   WHERE IsActive=true LIMIT 1];
        
        User oUser = [SELECT Id, Name FROM User WHERE Id=:oUserTerritory.UserId];
        system.debug('oUser '+oUser);
        Territory2 oTerritory = [SELECT Id FROM Territory2 WHERE Id=:oUserTerritory.Territory2Id];
        Territory2 oTerritory2 = [SELECT Id FROM Territory2 WHERE Id=:oUserTerritory2.Territory2Id];
        
        Group oGroup = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory.Id AND Type='Territory' LIMIT 1];
        system.debug('---'+oGroup );

        Group oGroup2 = [SELECT Id, RelatedId FROM Group WHERE RelatedId=:oTerritory2.Id AND Type='Territory' LIMIT 1];
                        system.debug('---'+oGroup2 );
        AccountShare oAccountShareA = new AccountShare();
        oAccountShareA.AccountId = oAccountA.Id;
        oAccountShareA.UserOrGroupId = oGroup.Id;
        oAccountShareA.AccountAccessLevel='Read';
        oAccountShareA.OpportunityAccessLevel='Read';
        //oAccountShareA.RowCause='TerritoryManual';
        insert oAccountShareA;
        AccountShare oAccountShareB = new AccountShare();
        oAccountShareB.AccountId = oAccountA.Id;
        oAccountShareB.UserOrGroupId = oGroup2.Id;
         oAccountShareB.AccountAccessLevel='Edit';
         oAccountShareB.OpportunityAccessLevel='Edit';
         //oAccountShareA.RowCause='TerritoryManual';
        insert oAccountShareB;
        
        AccountShare oAccountShareC = new AccountShare();
        oAccountShareC.AccountId = oAccountB.Id;
        oAccountShareC.UserOrGroupId = oGroup.Id;
         oAccountShareC.AccountAccessLevel='Edit';
         oAccountShareC.OpportunityAccessLevel='Edit';
         //oAccountShareA.RowCause='TerritoryManual';
        insert oAccountShareC;
        
        //Execute Test
        Test.startTest();
        
        //Test: Account Territory Hierarcy
        TerritoryUtil oUtil = new TerritoryUtil();
        oUtil.mapAccountShares(new set<Id>{oAccountA.Id,oAccountB.Id});
        oUtil.mapActiveUsers();
        oUtil.mapTerritories();
        oUtil.mapTerritoryMembers();
        List<User> listTerritoryMembers = oUtil.listAccountTerritoryMembers(oAccountA.Id);
        System.assertNotEquals(2, listTerritoryMembers.size());
        System.assertEquals(oAccountShareC.OpportunityAccessLevel, 'Edit');
        Test.stopTest();
    }
}