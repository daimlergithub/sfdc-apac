({
    starClick : function(component, event, helper) {
        if(component.get("v.profileCheck")){
        var colorOn = component.get("v.colorOn");
        var colorOff = component.get("v.colorOff");
        var el = event.target;
        var rating = 0;                
        while (el) {
            rating++;
            el.style.fill = colorOn;
            el = el.previousElementSibling;    		        
        }
        el = event.target.nextElementSibling;
        while (el) {
            el.style.fill = colorOff;
            el = el.nextElementSibling;    		        
        }
        component.set("v.rating", rating);
        
		var action=component.get("c.createRatingDB");
        action.setParams({
            'ratingDB': component.get("v.rating"),
            'AssigneeId': component.get("v.recordId")           
        });        
        action.setCallback(this, function(response) {
            if(response.getState()==="SUCCESS"){
                console.log("SUCCESS");
                helper.getRatingPoints(component);
            }
            else{
                console.log("error");
            }            
        });
        $A.enqueueAction(action);     
        }
    },
    doInit: function(component, event, helper){
        var action1 = component.get("c.getRatingOnLoad");
        action1.setParams({
            'fId': component.get("v.recordId")
        });
        action1.setCallback(this, function(response){
            if (response.getState() === "SUCCESS"){
                var rating = response.getReturnValue();
                console.log(rating);
                var svg = component.find("svg_content");
                var colorOn = component.get("v.colorOn");
                console.log(svg.getElement().children[0].children[0].children.length);
                while (rating > 0){
                    rating--;
                    svg.getElement().children[0].children[0].children[rating].style.fill = colorOn;
                }
                
            }
            else {
                console.log("error");
            }
        });
        $A.enqueueAction(action1);      
        
        helper.getRatingPoints(component);
        
        var action3 = component.get("c.getRatingEnableValue");
        action3.setStorable();
        action3.setParams({
            ideaId: component.get("v.recordId")           
        });
        action3.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {  
                component.set('v.profileCheck', response.getReturnValue());                
                console.log("SUCCESS");
            }
            else{
                console.log("error");
            }
        }); 
        $A.enqueueAction(action3);
    }
    
})