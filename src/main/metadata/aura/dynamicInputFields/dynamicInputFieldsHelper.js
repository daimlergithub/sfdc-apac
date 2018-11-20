({
    helperFun: function(component, event, helper) {
        var targetCmp = event.getSource();
        var tobeLogged = {
        'targetCmp.get("v.fieldName")': targetCmp.get("v.fieldName"),
        'targetCmp.get("v.value")': targetCmp.get("v.value")
        }  
        console.table(tobeLogged);
        var cmpEvent = component.getEvent("onchange");
        cmpEvent.setParams({
            "fieldAPINAME" : targetCmp.get("v.fieldName"),
            "fieldValue" : targetCmp.get("v.value")
        });
        cmpEvent.fire();
    },
    
    // Create a form given the set of fields
    createForm: function(component, fields, defaultValues) {
        //alert('create form'+JSON.stringify(fields));
        debugger;
        var size=component.get("v.layoutSize");
        var realComponents =[];
        for (var i = 0; i < fields.length; i++) {	
            var curField = fields[i];
            var curVal = defaultValues[curField];
            
            // TODO: do we need a change event?
            var options = {
                "fieldName": curField,
                "aura.id": curField,
                "onchange": component.getReference("c.inputValuePass")
            }
            
            if (curVal) {
                options.value = curVal;
            }
            
            var outside = ["lightning:layoutitem",{"flexibility":"auto","size":size,"padding":"around-small"}];
            var inside = ["lightning:inputField", options];
           
            realComponents.push(outside);
            realComponents.push(inside);
        };
        
        $A.createComponents(
            realComponents,
            function(components, status, errorMessage) {
                if (status === "SUCCESS") {
                    var z = [];
                    components.forEach(function(comp,index){
                        if(index%2 == 0){
                            comp.set("v.body",components[index+1]);
                            z.push(comp);
                        }
                    });
                    component.set("v.body",z);
                } else if (status === "INCOMPLETE") {
                    //TODO: notify
                    alert('Not Done');
                } else {
                    alert('Error');
                }
            }
        );
    }
})