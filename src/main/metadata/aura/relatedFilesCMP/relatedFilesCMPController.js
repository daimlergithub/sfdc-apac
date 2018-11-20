({
    doInit : function(component, event, helper) {
        //alert(component.get("v.newsId"));
        helper.loadHelper(component);        
    },
    deleteFile : function(component, event, helper) {
    	helper.deleterecordHelper(component,event); 
    }
})