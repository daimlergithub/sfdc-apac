({
    //Initialisation function
    doInit : function(component, event, helper) {
        //Set iconName to be shown on the UI
        var mapiconObject= component.get('v.iconMap');
        var mapiconKey = component.get('v.tileHeading');
        var iconName = mapiconObject[mapiconKey];
        component.set('v.iconName',iconName);       
    }
})