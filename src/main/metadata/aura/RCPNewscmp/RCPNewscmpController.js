({
    //on load,handling spinner
    handleloader : function(component,event,helper) {
      component.set("v.spinner",false);
    },
    //this function is a automatic call on success of inserting a record
    handleSuccess : function(component, event, helper){	
        component.set("v.message","");
        var payload = event.getParams().response;  
        var recdID=payload.id;
        component.set("v.recId",recdID);
        component.set("v.recordId",recdID);
        var isSave = component.get("v.isSave");
        if(!isSave){
        	helper.fileOpen(component,event,helper);      
        }
        else{
            helper.redirectAndMessage(component,event,helper);
        }
    },
    //show all errors to insert a record 
    handleError : function(component, event, helper) { 
        component.set("v.flag",false);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "Review the errors on this page.",
            "type": "error"
        });
        toastEvent.fire();
    },    
    //validations before inserting a record
    handleSave : function(component, event, helper) {
		helper.handleCustomErrors(component, event, helper);
        var button =event.getSource();
		var clicked = event.getSource().getLocalId();
		if(clicked == 'savebutton')        
        	component.set("v.isSave",true);
        if(clicked == 'saveandnextbutton'){
            component.find("DocStatus_FileUpload__c").set("v.value", true); 
        }        
        var message = component.get("v.message");
        if(!message){
            //button.set("v.label","Saving...");
            component.set("v.flag",true);
            var submit = component.find("newsForm").submit();
            component.set("v.message","");
        }
    },
    //on success of a file upload includes navigation --standard action
    handleUploadFinished :function(component,event,helper){    
        //helper.redirectAndMessage(component,event,helper);
        //helper.updateField(component,event,helper);
        helper.getUploadedFiles(component,event,helper);
    },
    //to delete uploaded file from news before saving
    deleteFile : function(component, event, helper) {
    	helper.deleterecordHelper(component,event); 
    },
    //on cancel redirecting to home page
    handleCancel : function(component, event, helper) {
        var url = location.href;  // entire url including querystring - also: window.location.href;
        var baseURL = url.substring(0, url.indexOf('/', 14));
        window.open( baseURL +  '/one/one.app?source=aloha#/sObject/News__c/list?filterName=Recent',"_parent");
    },
    //on cancel at file stage redirect record deatil page
    handleCancelFile : function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recId"),
            "slideDevName": "detail"
        });
        navEvt.fire();
        helper.updateField(component,event,helper);
    },    
    //on complete saving a record (details+fileuplaod) includes naviting to detail page
    DoneAction : function(component, event, helper) {
        //window.open('/'+component.get("v.recId"),"_parent");
        helper.redirectAndMessage(component,event,helper);
        helper.updateField(component,event,helper);
    },
})