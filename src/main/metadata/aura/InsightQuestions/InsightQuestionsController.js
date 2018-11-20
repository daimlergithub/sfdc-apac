({
    myAction: function(component, event, helper) {
        var action = component.get('c.fetchQuestionbySurvey');
        action.setParams({
            context: component.get("v.Context"),
            surveyType: component.get("v.SurveyType"),
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.questions", response.getReturnValue());
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    handleClick: function(component, event, helper) {
        var eventName = event.getSource().get("v.name");
        console.log(eventName);
        if (eventName == "Edit")
            component.set("v.editMode", true);
        else if (eventName == "Cancel")
            component.set("v.editMode", false);
        else {
            var action = component.get('c.saveQuestions');
            var actionQuestions = component.get("v.questions");
            console.log(actionQuestions);
            action.setParams({
                context: component.get("v.Context"),
                surveyType: component.get("v.SurveyType"),
                recordId: component.get("v.recordId"),
                questionString: JSON.stringify(component.get("v.questions"))
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.questions", response.getReturnValue());
                    component.set("v.editMode", false);
                    var a = component.get('c.showToast');
                    $A.enqueueAction(a);
                }
            });
            $A.enqueueAction(action);
        }
    },

    showToast: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: 'Success Message',
            message: 'Insights are updated Successfully',
            duration: ' 5000',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true);
    },
    hideSpinner: function(component, event, helper) {
        component.set("v.Spinner", false);
    }
})