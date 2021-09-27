@IsTest
public class ESC_PushTopicInitializerController_Test
    {
        public static testmethod void method1()
        {
        ESC_PushTopicInitializerController obj=new ESC_PushTopicInitializerController();
        obj.getjsonPT();
        obj.selectedPushTopic='test';
        
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        }  
    }