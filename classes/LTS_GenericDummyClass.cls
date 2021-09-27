public without sharing class LTS_GenericDummyClass{
   
    @InvocableMethod(label='DummyCallInvoke' 
                    description='DummyCallInvoke')
    public static void dummymethod(){
        system.debug('Inside methodDummy');
    }
}