/*==========================================================================================================
    Purpose: Test Class from AttributeValueCombinationTrigger,AttributeValueCombTrigHandlerAttributeValueCombTrigHelper.
    
    Change History: created
    
    Developer : Shailesh Patel 

    Modification History: NA
    
===============================================================================================================*/
@isTest
Public Class AttributeValueCombinationTriggerTest{
    
    @isTest static void testMethodTrigger(){
        
        List<APTS_Attribute_Value__c> listAttri = new List<APTS_Attribute_Value__c>();
        APTS_Attribute_Value__c  caval0 = New APTS_Attribute_Value__c ();
        caval0.Name='test'; 
        listAttri.add(caval0);
        
        APTS_Attribute_Value__c  caval1 = New APTS_Attribute_Value__c ();
        caval1.Name='test'; 
        listAttri.add(caval1);
        
        APTS_Attribute_Value__c  caval2 = New APTS_Attribute_Value__c ();
        caval2.Name='test'; 
        listAttri.add(caval2);
        
        APTS_Attribute_Value__c  caval3 = New APTS_Attribute_Value__c ();
        caval3.Name='test'; 
        listAttri.add(caval3);
        
        insert listAttri;
        
        List<APTS_Attribute_Value_Combination__c>  comList = New List<APTS_Attribute_Value_Combination__c> ();
        
        APTS_Attribute_Value_Combination__c  com = New APTS_Attribute_Value_Combination__c ();
        com.Name  ='test';
        com.APTS_Attribute_Value0__c =caval0.id;
        com.APTS_Attribute_Value1__c=caval1.id;
        com.APTS_Attribute_Value2__c=caval2.id;
        com.APTS_Attribute_Value3__c=caval3.id;
        comList.add(com); 
        
        APTS_Attribute_Value_Combination__c  com1 = New APTS_Attribute_Value_Combination__c ();
        com1.Name  ='test';
        com1.APTS_Attribute_Value0__c =caval0.id;
        com1.APTS_Attribute_Value1__c=caval1.id;
        com1.APTS_Attribute_Value2__c=null;
        com1.APTS_Attribute_Value3__c=caval3.id;
        comList.add(com1);
        insert comList ;
        
        APTS_Attribute_Value_Combination__c comQuery = [Select id,APTS_Attribute_Value0__r.Name,APTS_Attribute_Value1__r.Name,
                                                    APTS_Attribute_Value2__r.Name,APTS_Attribute_Value3__r.Name,Attribute0_Name__c,
                                                    Attribute1_Name__c,Attribute2_Name__c,Attribute3_Name__c from 
                                                    APTS_Attribute_Value_Combination__c where id =:com.id];
        
        System.assertEquals(comQuery.APTS_Attribute_Value0__r.Name, comQuery.Attribute0_Name__c);
        System.assertEquals(comQuery.APTS_Attribute_Value1__r.Name, comQuery.Attribute1_Name__c);
        System.assertEquals(comQuery.APTS_Attribute_Value2__r.Name, comQuery.Attribute2_Name__c);
        System.assertEquals(comQuery.APTS_Attribute_Value3__r.Name, comQuery.Attribute3_Name__c);
        
        com.APTS_Attribute_Value3__c=caval2.id;
        update com;
        
        APTS_Attribute_Value_Combination__c comQuery1 = [Select id,Attribute3_Name__c,APTS_Attribute_Value3__r.Name from APTS_Attribute_Value_Combination__c  where id=:com.id];
        System.assertEquals(comQuery1.APTS_Attribute_Value3__r.Name, comQuery1.Attribute3_Name__c);
        
    }
}