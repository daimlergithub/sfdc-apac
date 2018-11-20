({
    showDetails : function(component, event, helper) {
        var lastUpdB = component.get("v.lastUpdateBy");
        var lastUpdWhen = component.get("v.lastUpdateDate");
        var lineId = "#" + component.get("v.lineId");
        // Replace with custom component with proper formatting
        var message = "Last updated by:" + lastUpdB+"\n by:"+lastUpdWhen;
        component.find('overlayLib').showCustomModal({
            header: "Detailed status",
            body: message,
            referenceSelector: lineId,
            cssClass: "popoverclass"
        });
    }
})