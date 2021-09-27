/**
* {Purpose} json parser for OAuth
* 
* @author   Glen Cunningham
* @version  2015-11-11
*/

/** 
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
* 2015-11-11    Glen Cunningham          Created     
* =============================================================================
*/
public class CNData_14_OAuth {

  public string access_token;
  public string signature;
  public string instance_url;
  public string id;
  public string token_type;
  public string issued_at;
  public string expirationTime;
  
  public static CNData_14_OAuth parse(String json) {
    return (CNData_14_OAuth) System.JSON.deserialize(json, CNData_14_OAuth.class);
  }
  
}