public without sharing class ESC_CaseDescriptionUpdate{

        /*
This method will be invoked by SNOW Flow for Case Description field update

*/
    @InvocableMethod(label='Update Description on Case' description='Update description')
    public static List<string> CaseRefCreation(List<string> DescriptionFieldUpdate){
        system.debug('@@ Before description Field Update : ' + DescriptionFieldUpdate);
        List<string> DescriptionUpdated = new List<string>();
        for(string descUpdate: DescriptionFieldUpdate){
        descUpdate = descUpdate.replaceAll('<br/>', '\n');
        descUpdate  = descUpdate.replaceAll('<b>', '');
        descUpdate = descUpdate.replaceAll('</b>', '');
        descUpdate = descUpdate.replaceAll('<br>', '\n');
        descUpdate = descUpdate.replaceAll('<p>', '');
        descUpdate = descUpdate.replaceAll('</p>', '');
            DescriptionUpdated.add(descUpdate);
            
        }
        
        system.debug('@@ After description Field Update : ' + DescriptionUpdated);
        return DescriptionUpdated;
    }
  

}