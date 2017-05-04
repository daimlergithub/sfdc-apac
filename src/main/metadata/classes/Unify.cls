global class Unify{

    webService static String getExtension() {
        String result = '';
        result = [select Extension from User where id = :UserInfo.getUserId()].Extension;
        String JSONString = JSON.serialize(result);
        return JSONString;
		
    }
}
