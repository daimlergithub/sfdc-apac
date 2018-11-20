({
    handleUploadFinished: function (component, event) {
       	$A.get('e.force:refreshView').fire();
        if(component.get("v.fromVal")=='news') 
            $A.get('e.force:refreshView').fire();        
    }
})