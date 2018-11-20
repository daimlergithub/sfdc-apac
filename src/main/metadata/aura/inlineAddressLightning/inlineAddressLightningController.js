({
    
    recordUpdated: function(component, event, helper)  
    {
        if(!component.get("v.initOccured"))
        {
            helper.fetchFactFields(component, event, helper);
            component.set("v.initOccured",true);
        }
            
	},
    
    updateMaxAddressCount : function(component, event, helper) 
    {
        helper.checkLstAddressSize(component, event, helper);
    },
    
    handleAddressDelete : function(component, event, helper) 
    {
        var lstAddresses = component.get("v.lstAddresses");
        var index = event.getParam("indexDeleted");
		lstAddresses.splice(index, 1);
        component.set("v.lstAddresses",lstAddresses);
        helper.checkLstAddressSize(component, event, helper);
    },
    
    handleAddressCreation : function(component, event, helper) 
    {
        var lstAddresses = component.get("v.lstAddresses");
        lstAddresses.push(event.getParam("createdRecord"));
        component.set("v.lstAddresses",lstAddresses); 
        helper.checkLstAddressSize(component, event, helper);
    },
    

    createAddress : function(component,event,helper)
    {
        component.set("v.viewAddAddress","true");
    },
      
	navigateToCreateAddress : function(component, event, helper)
	{
        component.set("v.showAddAddress", true); 
	},
    
    closeAddAddress:function(component, event, helper)     
    {
        component.set("v.showAddAddress", false); 
    },    
})