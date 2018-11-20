({
	doInit: function (component, event, helper) {
        const fields = component.get('v.inputFieldList');
        const defaultValuesRaw = component.get('v.defaultValues');
        const defaultValues = {};
        for(var i = 0; i < defaultValuesRaw.length; i++) {
            var split = defaultValuesRaw[i].split('||');
            //TODO fix if no ||
            defaultValues[split[0]] = split[1];
        }
        
        helper.createForm(component, fields, defaultValues);
	},
    
    inputValuePass : function(component, event, helper) {
		helper.helperFun(component, event, helper );	
	},
})