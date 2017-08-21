trigger CaseCommentTrigger on CaseComment (before update,before delete) 
{
    Id userids=userinfo.getUserId();
    Id roleId=userinfo.getUserRoleId();
    Id profileId=userinfo.getProfileId();
       
    String profilename=[Select Id,Name from UserRole where Id=:profileId].Name;
    String Market=[Select Market__c from User Where Id=:userids].Market__c;
    String rolename=[Select Id,Name from UserRole where Id=:roleId].Name;
        if((rolename == 'Call Center Operator' || rolename == 'Call Center Supervisor' || rolename == 'Manager' || profilename == 'MBK CCC Retail Operator' || profilename == 'MBK CCC Retail - Manager')  && Market=='KR')
            {
                if(trigger.isUpdate)
                    {
                        for(CaseComment cas: Trigger.new)   
                            {
                                cas.addError(system.label.You_don_t_have_permission_to_update_this_record);
                            }
                    }
                else
                    {
                        for(CaseComment cac: Trigger.old)
                            {
                               cac.addError(system.label.You_cannot_Delete_CaseComment);
                            }
                    }
            }
}