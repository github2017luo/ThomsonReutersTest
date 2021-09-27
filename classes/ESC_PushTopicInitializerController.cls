public class ESC_PushTopicInitializerController {
 
 public string selectedPushTopic {get; set;}
 
 public string getjsonPT(){
     return JSON.serialize(selectedPushTopic);
 }
}