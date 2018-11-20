/* File Name   : strike_responseData -->
<!-- Description : strike_responseData Apex class -->
<!-- Copyright   : Infosys Limited Copyright (c) 2018  -->
<!-- @author     : Sarath -->
<!-- Author Modification & Ver.Date : Sarath & 23-June-2018  */
public with sharing class strike_responseData {
    public Boolean isSuccess;
    public Map<String, Object> results;
    public String errMsg;

    public strike_responseData() {
        this.isSuccess = true;
        this.results = new Map<String, Object>();
    }

    public void addError(String errMsg){
        this.errMsg = errMsg;
        this.isSuccess = false;
    }

    public String getJsonString() {
        return strike_utilities.serializeWithoutNamespace(this);
    }
}