global class NitroRolesToGroups {
/* skg
   @future(callout=true)    
   public static void transferData() {      

        // CONFIGURATION
        // SFDC: need to add a new endpoint into SFDC to enable this. 
        // Setup->Security->Remote site settings. endpoint = http://wwwadmin.bunchball.net
        // NITRO: Site > Groups - Check "Groups are automatically created when a user joins"
        
        // Get the list of users, whether they're active, and their role. 
        //List <User> userList = [Select Id, Name, isActive, UserRoleId from User WHERE UserRoleId != null];
        List <User> userList = [Select Id, Name, isActive, UserRoleId from User WHERE UserRoleId != null ORDER BY Name OFFSET 0];
        
        // Keep a list of used roles, we'll only query for these instead of all of them. 
        Set <Id> userRoles = new Set<Id>();
        
        // Use this list to get the Nitro UserIds. 
        List <Id> userIdList = new List<Id>();
        
        // Go through all the users in the list. 
        for (User u: userList) {
        //    System.debug (u.Name + ' ' + u.isActive + ' ' + u.UserRoleId);
            
            // Add to the list of all the used roles
            if (u.UserRoleId != null) {
                userRoles.add(u.UserRoleId);
            }
            
            // Add to the list of all the userIds, so we can convert them to Nitro User Ids. 
            userIdList.add(u.Id);
        }
        
        System.debug ('****Rolecounter: ' + userRoles.size());
        
        // Convert the userId list to Nitro UserIds. 
        List <User> uList = nitro.NitroCommonUtility.getNitroUserIds(userIdList);  
        // Make a Map to make it usable. 
        Map<ID, String> userNameMap = new Map<ID, String>();
        for (User u: uList) {
            userNameMap.put(u.Id, u.UserName);
        //    System.debug ('*** ' + u.Id + ' ' + u.UserName);
        }
        
        // Need to convert each RoleId into a role name. Make a map of ID to RoleName. 
        Map<ID, String> roleMap = new Map<ID, String>();
        List <UserRole> roleList = [SELECT Id, Name FROM UserRole WHERE Id in :userRoles];
        for (UserRole r: roleList) {
            roleMap.put(r.Id, r.Name);
        //    System.debug (r.Id + ' ' + r.Name);
        }
        
        // Now we have all the data that we need. 
        
        // Fire all this data out the door in a POST to a script on bunchball.net
        String request = '';
        String isActive = '0';
        for (User u: userList) {
            if (u.isActive && u.UserRoleId != null || !u.isActive) {
                if (u.isActive) {
                    isActive = '1';
                }
                else {
                    isActive = '0';
                }
                request += '&u=' + userNameMap.get(u.Id) + '|' + isActive + '|' + roleMap.get(u.UserRoleId);
            }
        }
        
        // Only continue if we have something to send.  
        if (request != '') {
            // Add Nitro data that we need to able to login: apiKey, secretKey, server
            nitro__Nitro_Configuration__c NitroConfigData = nitro__Nitro_Configuration__c.getInstance('nitro');
            if (NitroConfigData == null) {
                return;
            }
          
            String apiKey = NitroConfigData.nitro__API_Key__c;
        //    String secretKey = NitroConfigData.nitro__API_Secret__c;            
            String adminName = NitroConfigData.nitro__Admin_Name__c;            
            String adminPassword = NitroConfigData.nitro__Admin_Password__c;    
            String server = nitro.NitroCommonUtility.constructPath(NitroConfigData.nitro__Subdomain__c, 'ENDPOINT');
            request = apiKey + '|' + adminName + '|' + adminPassword + '|' + server + '***' + request;
        
        //    System.debug (request);
            
            // Hit a custom script running on the bb.net server.
        //    String endpoint = 'https://assets.bunchball.net/customers/n4sf/roles2groupslauncher.php';
        String endpoint = 'http://wwwadmin.bunchball.net/assets/customers/n4sf/roles2groupslauncher.php';
                
            // Setup a new HTTP Request
            HttpRequest req = new HttpRequest(); 
            req.setMethod('POST');
            req.setEndpoint(endpoint);
            req.setTimeout(120000);
            req.setBody(request);
        //    System.debug('*** makeAPICallout() request: ' + request);
            
            // Create a new HTTP object
            Http http = new Http();
            HTTPResponse resp = null;
            resp = http.send(req);
        //    System.debug('*** makeAPICallout() response: ' + resp.getBody());
        }
       
   } */
}