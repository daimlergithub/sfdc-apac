({
	helperFun: function(component, event, helper) {
        var targetCmp = event.getSource();  
        console.log('targetCmp.get("v.fieldName")-->',targetCmp.get("v.fieldName"));
        console.log('targetCmp.get("v.value")-->',targetCmp.get("v.value"));
        var cmpEvent = component.getEvent("onchange");
        cmpEvent.setParams({
            "fieldAPINAME" : targetCmp.get("v.fieldName"),
            "fieldValue" : targetCmp.get("v.value")
        });
        cmpEvent.fire();
    },
})