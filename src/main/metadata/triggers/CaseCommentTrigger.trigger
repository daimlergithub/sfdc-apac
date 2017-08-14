trigger CaseCommentTrigger on CaseComment (before update,before delete) 
{
    Id userids=userinfo.getUserId();
    Id roleId=userinfo.getUserRoleId();
    String Market=[Select Market__c from User Where Id=:userids].Market__c;
    String rolename=[Select Id,Name from UserRole where Id=:roleId].Name;
        if((rolename == 'Call Center Operator' || rolename == 'Call Center Supervisor' || rolename == 'Manager')  && Market=='KR')
            {
                if(trigger.isUpdate)
                    {
                        for(CaseComment cas: Trigger.new)   
                            {
                                cas.addError('You cannot Update CaseComment');
                            }
                    }
                else
                    {
                        for(CaseComment cac: Trigger.old)
                            {
                               cac.addError('You cannot Delete CaseComment');
                            }
                    }
            }
}