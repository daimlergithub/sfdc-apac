/*
    Type:       Process controller Class
    Purpose:    Used for mass apporval on visual page
    HLD:        BRD-Release 1.3 CRs
    Used By:    MassApproveRetailCampaignController
                MassApproveToolKitController
    ---------------------------------------------------------------
    History:
    
    1. Cyril Created on 2014-10-17

*/
public class MyProcess{
    public Id workItemId {get; set;}
    public Boolean hasMyStep {get; set;}
    public static final Id ADMIN_ID = [Select Id from profile where Name = 'System Administrator' limit 1].Id;
    
    public MyProcess(Id targetId){
        List<ProcessInstance> processList = [
            Select Id, TargetObjectId, isDeleted, Status,
                (
                    Select Id, ProcessInstanceId, ActorId, Actor.Name, StepStatus, Comments
                    From StepsAndWorkItems
                    Where
                        StepStatus = 'Pending'  and
                        isDeleted = false
                    Order By
                        Createddate Desc
                    Limit 1
                )
            From ProcessInstance
            Where
                isDeleted = false and
                TargetObjectId = :targetId and
                Status = 'Pending'
            Order By
                Createddate Desc
            Limit 1
        ];
        hasMyStep = false;
        if (!(processList.isEmpty()) && !(processList[0].StepsAndWorkitems.isEmpty())) {
            workItemId = processList[0].StepsAndWorkitems[0].id;
            hasMyStep = (UserInfo.getUserId() == processList[0].StepsAndWorkitems[0].ActorId) || (UserInfo.getProfileId() == ADMIN_ID);
        }
    }
    
    public Boolean approve(String comment, Id workItemId) {
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setNextApproverIds(null);
        req.setWorkitemId(workItemId);
        req.setComments(comment);
        req.setAction('Approve');
        return Approval.process(req).isSuccess();
    }
}