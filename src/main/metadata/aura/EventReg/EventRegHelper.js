({
    checkEvent : function(component) {
        var action = component.get("c.validate");
        action.setParams({
            eventId: component.get("v.recordId")  
        });
        action.setCallback(this, function(response){
            var state = response.getState();	
            if (state === "SUCCESS") { 
                var resp = response.getReturnValue();
                var evnt=resp.event;
               	var times=resp.timebool;
                var entries;
                component.set("v.flag", evnt.Expired__c);
                var numRegistrations = evnt.Number_of_Registrations__c;
                var entriesList=evnt.Event_Registrations__r;
                if(entriesList!= "undefined" &&  entriesList!=null){
                    entries=entriesList.length;
                }
                else{
                    entries=0;
                }
                //Controlling the registration for certain period - Code Start
                if(times[0]=='true'){
                    component.set("v.message","");
                    component.set("v.flag", false);
                    if(times[1]=='true'){
                        component.set("v.message","");
                        component.set("v.flag", false);
                        //Limited seats for registration events- Code Start
                        if(entries<numRegistrations){
                            component.set("v.message","");
                            component.set("v.flag", false);
                        }else{
                            component.set("v.flag",true);
                            component.set("v.message","We are sorry that registrations for this event are over."); 
                        }
                        //Limited seats for registration events- Code End
                    }else{
                        component.set("v.flag",true);
                        component.set("v.message","Registration is closed!"); 
                    }
                }else{
                    component.set("v.flag",true);
                    component.set("v.message","Registrations for this event are not yet opened."); 
                }
                //Controlling the registration for certain period - Code End
            }
            else {
                if(stateOfAction === "ERROR")
                {
                    var error = resp.getError();
                    component.set("v.message",error[0].message); 
                }
            }
        });
        $A.enqueueAction(action);
    },
})