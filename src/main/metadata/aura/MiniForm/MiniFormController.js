({
    doInit : function(component, event, helper) {
        const layoutType = component.get('v.layoutType');
        // Set the layout type if we have one
        if (layoutType === 'Compact' || layoutType === 'Full') {
            const miniForm = component.find('MiniForm');
            debugger;
            miniForm.set('v.layoutType', layoutType);
        }
        const fieldList = component.get('v.fieldList').split(',');
        component.set('v.fieldListArray', fieldList);
        
    }
})