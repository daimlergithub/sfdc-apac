({
	closeBillModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.closeWindow", false);
        
    },
    closepopOver: function(component, event, helper) {
        // for Hide/Close Model,set the "enablepopupt1" attribute to "Fasle"  
        component.set("v.enable", false);
        
    },
    
    doInit : function(component, event, helper) {
        var device = $A.get("$Browser.formFactor");
        //alert("You are using a " + device);
        //alert('<<333');
		component.set("v.deviceaccessed", device);
        if (component.get("v.deviceaccessed") == 'DESKTOP'){
           component.set("v.isNotDesktp", 'false'); 
           console.log('<<enetedre into desktp');
        }else{
           component.set("v.isNotDesktp", 'true');  
            console.log('<<enetedre into mob');
        }
    },
})