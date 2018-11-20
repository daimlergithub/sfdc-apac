({
    doInit : function(component, event, helper) {
        helper.InitLoad(component);        
    },
    subscribeNews : function(component, event, helper) {
        helper.subsNews(component,true);        
    },
    unsubscribeNews : function(component, event, helper) {
        helper.subsNews(component,false);        
    }
})