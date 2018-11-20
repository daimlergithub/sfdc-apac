({
	myAction : function(component, event, helper) {
		var dataType = component.get("v.fieldtype");
        var selectedAnswer = component.get("v.selectedAnswer");
        console.log(dataType);
        if(dataType == "Picklist")
            component.set("v.IsPicklistbool",true);
        else if(dataType == "Multi-select Picklist")
            component.set("v.IsMultiPicklistbool",true);
        else if(dataType == "Prepopulate"|| dataType=="Read-Only")
            component.set("v.IsformattedText",true);
        else
            component.set("v.IsInputbool",true);
	}
})