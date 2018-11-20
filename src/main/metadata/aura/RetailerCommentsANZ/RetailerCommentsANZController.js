({
    doInit:function(component,event){
        
        var action = component.get('c.retailComments')
        action.setParams({
            customerId:component.get("v.recordId")
        });
          action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.AccountlinkRec",response.getReturnValue());
                console.log(response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            
          });
         $A.enqueueAction(action);
    },    
	handleClick : function(component, event, helper) {
		var btn = event.getSource();
        var name = btn.get('v.name');       
        console.log(name);
         	if(name=='Edit')
            component.set('v.edit',false); 
			else if(name=='Cancel')
            component.set('v.edit',true);
            else if(name=='Save')
            {              
             var action = component.get('c.retailComments')
		     action.setParams({
      		      customerId:component.get("v.recordId")
		        });   
             action.setCallback(this, function (response) {
     	      	var state = response.getState();
        	    if (state === "SUCCESS") {
                    component.set("v.AccountlinkRec",response.getReturnValue());
                    console.log(response.getReturnValue());
               		var toastEvent = $A.get("e.force:showToast");
      				toastEvent.setParams({
            		title : 'Success Message',
            		message: 'The Retailer Comments updated successfully.',
            		duration:'1500',
            		key: 'info_alt',
            		type: 'success',
            		mode: 'pester'
        			});
       			toastEvent.fire();
     			component.set('v.edit',true); 
     
            } else if (state === "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
        		toastEvent.setParams({
            	title : 'Error Message',
            	message:'Cannot Create/Edit Retailer Comments.',
            	duration:' 5000',
            	key: 'info_alt',
            	type: 'error',
            	mode: 'pester'
      			});
        		toastEvent.fire();
            	component.set('v.edit',false);    
            }
       		});
        	$A.enqueueAction(action);           
            }  
    },

    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    hideSpinner : function(component,event,helper){
       component.set("v.Spinner", false);
    }
})