({
	getRatingPoints : function(component) {

		var action2 = component.get("c.getPointsCount");
        action2.setParams({
            ideaId: component.get("v.recordId")           
        });
        action2.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {  
                component.set('v.ideaScore', response.getReturnValue());
                console.log("SUCCESS");
            }
            else{
                console.log("error");
            }
        }); 
        $A.enqueueAction(action2);

	}
})