/*
    Type:       Test Class
    Purpose:    Test
    ---------------------------------------------------------------
    History:

    27-June-2013 Stephano Shi (Breakingpoint)    Created

*/
@isTest
public class UtilFieldApiByObjMap_TestClass{
    
    static testmethod void runUtilFieldApiByObjMap(){
    	UtilFieldApiByObjMap m = new UtilFieldApiByObjMap();
    	Map<String, Schema.SObjectField> fieldMap = m.getFieldNameMap('Account'); 
    }
}