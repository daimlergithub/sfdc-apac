({
    handleUploadFinished: function (cmp, event) {
        //var uploadedFiles = event.getParam("files");
        //alert("Files uploaded : " + uploadedFiles.length);
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();  
    }
})