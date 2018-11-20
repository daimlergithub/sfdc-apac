({
    doInit : function(component, event, helper) 
    {	
        component.set("v.oldRecord", JSON.parse(JSON.stringify(component.get("v.myObject")))); 
        var myObjectData = component.get("v.myObjectData");
        
        
    },
    
    handleCancel : function(component, event, helper) {
        component.set("v.recordEditForm",false);
        component.set("v.accountEditComp",false);
        
        
    },
    handleSave: function(component, event, helper){
        var recordId=component.get("v.sObjectId");
        
        //component.find(“submit”).click();
        
        var accountDetail=component.find("saveAccountRecord");
       	var saveRecordResult=accountDetail.saveRecord();
       // component.set("v.recordEditForm",false);
        //component.set("v.accountEditComp",false);
    },
    getMessage: function(component, event, helper){
    var msg=event.getParam("recordTypeName");
   //alert('enetered par');
        console.log('test '+event.getParam("recordTypeName"));
        if(msg=='Error'){
            component.set("v.accountEditComp",true);
        }else if(msg=='Success'){
            component.set("v.accountEditComp",false);
        }
    },
    
    handleSubmit: function(cmp, event, helper) {
        cmp.set('v.disabled', true);
    },
    
    
    
    handleSuccess: function(cmp, event, helper) {
        
        var appEvent = $A.get("e.c:retailPicker");
        
        appEvent.setParams({ "showRefresh" : "this is going to refresh" });
        appEvent.fire();
        cmp.set('v.recordEditForm', false);
        $A.get('e.force:refreshView').fire();
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({	title: "Success!",
                              message: "Record Updated",
                              type: "success",
                              duration: " 500"
                             });
        toastEvent.fire();
    }  
    
})