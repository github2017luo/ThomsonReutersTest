/**
* {Purpose} � This class provides a json parser for the api call releaseinfo
* 
* @author   Glen Cunningham
* @version  2015.12.01
* 
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description 
*2015-12-01		Glen Cunningham 		created
* =============================================================================
*/
public class CNData_14_Version {

	public String LastUpdateTime;
	public String LastUpdateDate;
	public String CopyrightYear;
	public String Version;

	
	public static CNData_14_Version parse(String json) {
		if(json!=''){
			return (CNData_14_Version) System.JSON.deserialize(json, CNData_14_Version.class);
		}
		return null;
	}
}