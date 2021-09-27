/**
 * {Purpose} � This class parses a oauth json response 
 * 
 * @author   Glen Cunningham
 * @version  2015-15-12
 */

/** 
 * CHANGE HISTORY
 * =============================================================================
 * Date          Name                    Description
 * =============================================================================
 *
 */
public class CNOAuthToken {
	
	public String access_token;
	public Integer expires_in;
	public String token_type;

	
	public static CNOAuthToken parse(String json) {
		return (CNOAuthToken) System.JSON.deserialize(json, CNOAuthToken.class);
	}
}