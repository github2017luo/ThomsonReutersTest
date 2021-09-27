public without sharing Class ESC_LiveChatUpdateTriggerHandler{    
    public static void onAfterUpdate(List<LiveChatTranscript> newLiveChatList){
            
            ESC_addChatToCaseFeed.postToFeed(newLiveChatList );
    }
    
    public static void onAfterUpdate2(List<LiveChatTranscript> newchatList, Map<Id,LiveChatTranscript> newLiveChatMap){
    ESC_ChatUtility.changeCaseOwnerTransfer(newchatList,newLiveChatMap);
    }
}