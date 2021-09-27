public without sharing Class ESC_LiveChatInsertTriggerHandler{    
    public static void onAfterInsert(List<LiveChatTranscript> newLiveChatList){
           ESC_addChatToCaseFeed.postToFeed(newLiveChatList);
        }
    }