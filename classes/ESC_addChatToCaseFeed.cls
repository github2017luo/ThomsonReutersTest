public without sharing class ESC_addChatToCaseFeed {
    
    public static void postToFeed(List<LiveChatTranscript> transcripts) { 
        List<FeedItem> posts = new List<FeedItem>();
        Map<String,String> mapcasesub= new Map<String,String>();
        Map<String,String> mapparent= new Map<String,String>();
        List<string> transcriptcaseID=new list<string>();
        List<case> casesub = new List<Case>();
        
        for(LiveChatTranscript transcrt: transcripts){
            if(transcrt.caseId!=null){
                transcriptcaseID.add(transcrt.caseId);
                mapparent.put(transcrt.id,transcrt.caseId);
                    }
        }
        
        
        if(transcriptcaseID.size()>0 && (Schema.sObjectType.case.isAccessible() || Schema.sObjectType.case.isQueryable())){
            casesub=[select id,casenumber,subject  from case  where id in  : transcriptcaseID];
        }
        
        if(casesub.size()>0){
            for(Case c:casesub){
                mapcasesub.put(c.id,c.subject);
            }
            for(LiveChatTranscript trans: transcripts){
                FeedItem post = new FeedItem();
                post.Body = System.Label.ESC_TranscriptFeed+ ' ' +trans.Name+' : '+mapcasesub.get(mapparent.get(trans.id));
                post.ParentId = trans.caseId;
                posts.add(post);
            }
            if(posts.size()>0){
                insert posts;
            }
        }
    }
}