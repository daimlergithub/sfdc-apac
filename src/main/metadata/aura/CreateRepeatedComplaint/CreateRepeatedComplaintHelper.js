({
	getSObjRecordWithAllFieldValues : function(component, event) {
		let sObjectRecordId = component.get('v.recordId');
        
        let action = component.get("c.getSObjRecordWithAllFields");
        action.setParams({ recordId : sObjectRecordId });

        var result;
        action.setCallback(this, function(response) {        
        	var state = response.getState();
            if(state === "SUCCESS") {
                result = response.getReturnValue();
                console.log('current SObject ', result);
                this.cloneSObject(component, event, result);
            }
        });
        
        $A.enqueueAction(action);

	},
    
    cloneSObject : function(component, event, defaultValues) {
        
        let createRecordEvent = $A.get("e.force:createRecord");
        let parameters = {};
        parameters.entityApiName = component.get('v.sObjectName');//sObjectName "Case";
        
        if(component.get('v.sObjectName') == 'Case') {
            defaultValues.ParentId = defaultValues.Id;
        }
        
        delete defaultValues.Id;
        parameters.defaultFieldValues = defaultValues;
        createRecordEvent.setParams(parameters);
        createRecordEvent.fire();
    }
})