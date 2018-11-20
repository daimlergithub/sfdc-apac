({
    myAction: function(component, event, helper) {
        var action = component.get('c.fetchAccountById');
        action.setParams({
            recordId: component.get("v.recordId"),
            surveyType: component.get("v.SurveyType")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.custQuestions", response.getReturnValue());
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})