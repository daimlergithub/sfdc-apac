public class UserHelperMY {
    
    public static void createGroup(List<User> newUserList){
        UserHelperBase.createGroup(newUserList);
    }
    
    public static void AfterInsertANDUpdateMethod(list<User> usersList,boolean isInsert,boolean isUpdate){
        UserHelperBase.AfterInsertANDUpdateMethod(usersList,Trigger.Isinsert,Trigger.isUpdate);
    }
    
    public static void ShareUsersToDealersAfterInsertAndUpdate(List<User> userlist,boolean flag, List<User> oldusrlst){
         UserHelperBase.ShareUsersToDealersAfterInsertAndUpdate(userlist,Trigger.isupdate,oldusrlst);
    }
}