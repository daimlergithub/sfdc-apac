({
	showToast: function(mode, type, message) {
        console.log("entered into toast");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: mode,
            type: type,
            message: message
        });
        toastEvent.fire();
        $A.get("e.force:refreshView").fire();
    }
})