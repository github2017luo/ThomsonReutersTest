public class LotusUser{
private static LotusUser instance = null;
//public boolean isLotUser{get;private set;}
public boolean isLotUser = false;
    private LotusUser(){
    List<LOTUS_Region_and_Segmentation_Rule__mdt> listLotusProfile = new List<LOTUS_Region_and_Segmentation_Rule__mdt>([select MasterLabel, User_Segment__c from LOTUS_Region_and_Segmentation_Rule__mdt]);
            Map<String,LOTUS_Region_and_Segmentation_Rule__mdt> mapSegment = new Map<String,LOTUS_Region_and_Segmentation_Rule__mdt>();
            LIST<String> SegmentList= new LIST<String>();
            for(LOTUS_Region_and_Segmentation_Rule__mdt mdt:listLotusProfile)
            {
                mapSegment.put(mdt.MasterLabel,mdt);
                System.debug('@@printing mapsegment'+mapSegment);
            }
            String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
            user currentuserSegment = [Select Segment__c from User where Id=:userinfo.getuserId()];
            System.debug('@@printing currentuserSegment'+currentuserSegment);
            if(mapSegment.size()>0 && mapSegment.keyset().contains(profileName))
            {
                SegmentList = mapSegment.get(profileName).User_Segment__c.split(';');
                System.debug('@@printing SegmentList'+SegmentList);
                if(SegmentList.contains(currentuserSegment.Segment__c))
                {
                    isLotUser = true;
                }
            }
            else{
                isLotUser = false;
            }
    }
    public static boolean getLotusUser(){
        if(instance == null){
            instance = new LotusUser();
        }
        return instance.isLotUser;
    }
}