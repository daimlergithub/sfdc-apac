({
    init : function(component, event, helper) { 
        var fetchFields = component.get("c.getResponse");
        fetchFields.setParams({
            "market":'',
            "recordType":'',
            "componentName":'ServiceRetailTask',
            "recordId":component.get("v.recordId")
        });
        fetchFields.setCallback(this, function(resp) {
            var valRes = resp.getState();
            var toastTitle ;
            var toastMessage ;
            var toastType;
            var toastDuration="500";
            if(valRes === 'SUCCESS'){
                var returnValue = resp.getReturnValue();
                if (returnValue!=null && returnValue!='undefined') {
                    const tableColumns = returnValue.lstDataTableColumns;
                    const rows = returnValue.lstDataTableData;
                    const lookupfields=returnValue.LookUpFields;
                    component.set("v.data",rows);   
                    component.set("v.Tablecolumns",tableColumns);
                    component.set("v.Allcolumns",returnValue.lstAllColumns);
                    rows.forEach(row => {
                        row.Id = '/' + row.Id;
                        for (const col in row) {
                        const curCol = row[col];
                        if (curCol != 'RecordType' && typeof curCol === 'object') {
                        const newVal = curCol.Id ? ('/' + curCol.Id) : null;
                        helper.flattenStructure(row, col + '.', curCol,helper);
                        if (newVal === null) {
                        delete row[col];
                    } else {
                                 row[col] = newVal;
                                 }
                                 }
                                 }
                                 });
                }
            }else{
                toastTitle = "ERROR!";
                toastMessage = 'Something went wrong, Please check with your admin';
                toastType = "error";
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({	title: toastTitle,
                                      message: toastMessage,
                                      type: toastType,
                                      duration: toastDuration
                                     });
                toastEvent.fire();
            }    
        });
        $A.enqueueAction(fetchFields);
    }
})