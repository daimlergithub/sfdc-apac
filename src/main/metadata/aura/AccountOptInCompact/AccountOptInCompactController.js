({
    doInit :function(component, event, helper) {
        const fieldList = component.get('v.fieldList').split(',');
        component.set('v.fieldListArray', fieldList);
        component.set('v.formReady', true);
    },
    recordReady : function(component, event, helper) {
        const myData = component.get('v.optinRecord');
        const simpleData = {};
        for (var d in myData) {
            simpleData[d.toLowerCase()] = myData[d];
        };   
        const fieldList = component.get('v.fieldListArray');
        const result = [];
        var action = component.get("c.retrieveFieldLablesFromFieldList");
        action.setParams({
            'fieldList' : fieldList,
            'objName' : 'Account'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                const lblMap = response.getReturnValue();
                for (const prop in lblMap) {
                        var lbl = lblMap[prop];
                        // Known cosmetic to make fields shorter
                        lbl = ' '+lbl.replace('Opt In','').replace(' Function','').replace('Dealer ','');
                        result.push({ label: lbl,
                                     field: prop,
                                     icon: (simpleData[prop] ? 'action:approval':'action:close')});              
                }
            } else {
                // No labels get back...
                for (const prop in myData) {
                    if (prop != 'SystemModstamp' && prop != 'RecordTypeId' && prop != 'Id') {
                        result.push({ label: prop, field: prop, icon: (myData[prop] ? 'action:approval':'action:close')});
                    }
                }
            }
            component.set('v.valueList', result);
        });
        $A.enqueueAction(action);
        
    }
    
})