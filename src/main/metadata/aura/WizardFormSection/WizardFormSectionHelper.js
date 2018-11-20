({// Create a form given the set of fields
    createForm: function(component, fields) {
        debugger;
        var size=component.get("v.size");
        var realComponents =[];
        for (var i in fields)
        {
            //fields.forEach(function(c){
            var y=["lightning:layoutitem",{"flexibility":"auto","size":size,"padding":"around-small"}];
            var x= [];
            x.push("lightning:inputField");
            if(fields[i]=="null"){
                if(i == "AccountId")
                {
                    x.push({"fieldName": i,
                            "value": component.get("v.AccId"),
                            "aura.id":i,
                            "onchange":component.getReference("c.getAccId")    
                           });
                }
                else{
                   x.push({"fieldName": i,
                        "aura.id":i
                       }); 
                }
            }
            else{
                x.push({"fieldName": i,
                        "value": fields[i],
                        "aura.id":i
                       });
            }
            realComponents.push(y);
            realComponents.push(x);
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
                    }
                                      );
                    component.set("v.body",z);
                } else if (status === "INCOMPLETE") {
                    //TODO: notify
                    alert('Not Done');
                } else {
                    alert('Error');
                }
            }
        );
    },
    
})