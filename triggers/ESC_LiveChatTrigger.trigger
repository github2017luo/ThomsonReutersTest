trigger ESC_LiveChatTrigger on LiveChatTranscript (after insert,after update) {

ESC_LiveChatTriggerHandler.callLivechatHandler();

}