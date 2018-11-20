({
	doInit : function(component, event, helper) {
		let createRecordEvent = $A.get("e.force:createRecord");
        let parameters = {};
        parameters.entityApiName = "Lead__c";
        createRecordEvent.setParams(parameters);
        createRecordEvent.fire(); 
	}
})