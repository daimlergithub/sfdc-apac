({ 
  	doInit : function(component, event, helper) 
	{
        try
        {
            component.set("v.oldRecord", JSON.parse(JSON.stringify(component.get("v.myObject"))));    
        }
        catch (e) 
        {
            var errMsg ='Something is wrong : '    + e ;
            helper.showToast('sticky', 'Error', errMsg);
        }
       
	},
    
    handleSuccess : function(component,event,helper)
    {
        try
        {
            var addressObj = component.get("v.myObject");
            var messageToDisplay = "Address updated";
            
            if(!(addressObj.Id))
            {
                try
                {
                    
                    var objResponse = event.getParams().response;
                    addressObj.Id = objResponse.id;
                    
                    var addressCreatedEvent = component.getEvent("AddressCreated");
                    addressCreatedEvent.setParam("createdRecord",addressObj);
                    addressCreatedEvent.fire();
                    
                    messageToDisplay = "New Address created";
                }
                catch(e)
                {
                    var errMsg ='Something is wrong : '    + e ;
            		helper.showToast('sticky', 'Error', errMsg);
                }
            }
            
            component.set("v.AddEditAddress",false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({	title: "Success!",
                                    message: messageToDisplay,
                                    type: "success",
                                  duration: "0.9"
                                });
            toastEvent.fire();
        }
        catch (e) 
        {
            var errMsg ='Something is wrong : '    + e ;
            helper.showToast('sticky', 'Error', errMsg);
        }
    },
    
    
	closeEdit : function(component, event, helper)  
    {
        component.set("v.oldRecord", JSON.parse(JSON.stringify(component.get("v.myObject"))));        
        component.set("v.AddEditAddress",false);
	},
    
    fieldValChange : function(component, event, helper) 
    {
        var fieldName = event.getSource().get("v.fieldName");
        var value = event.getSource().get("v.value");
       
        var addressObj = component.get("v.oldRecord"); 
        addressObj[fieldName] = value;
        console.log(fieldName +" : ",addressObj[fieldName]);
	},
    
     
})