// This class is created to send attachments containing Tarifador in the file name in email during LATAM Approval Process

Public with sharing class EmailQuoteAttachments{

    public Id thisQuoteId {get; set; }
    public String AttName;       
           
    public String fetchAttachment() {
    String attaId = '';
        //list<Attachment> attachLst = [Select Id, Name, CreatedDate From Attachment Where ParentId = :thisQuoteId  Order By CreatedDate DESC ];
        for(Attachment attach : [Select Id, Name, CreatedDate From Attachment Where ParentId = :thisQuoteId Order By CreatedDate DESC]){
            if(attach.Name.containsIgnoreCase('Tarifador')){
                AttName = attach.Name;
                attaId = attach.Id;
                break;
            }else{
                attaId = attach.Id;
            }
        }
        return attaId ; 
    }  
    
    public String atId;
    public String getatId(){
        string strAttId = fetchAttachment();  
        return strAttId;
    }
   
    public void setatId(String atId)
    {
        this.atId = atId;
    } 
    
    public String getAttName(){
        fetchAttachment();
        String  attachName = AttName;
        return attachName;  
    }
    
    public void setAttName(String Name){
        this.AttName = Name;
    }   
        
}