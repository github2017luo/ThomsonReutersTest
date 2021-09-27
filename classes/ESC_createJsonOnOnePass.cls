public class ESC_createJsonOnOnePass{
    Public static String createJson(String uName){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('OnePassUserName', uName);
        gen.writeEndObject();
        system.debug(gen.getAsString());
        return gen.getAsString();
    }
    
}