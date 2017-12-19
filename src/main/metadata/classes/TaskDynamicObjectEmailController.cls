public without sharing class TaskDynamicObjectEmailController {
    public String objectName{get;set;}
    public String url{get;set;}
    public Task task{get;set;}
    public TaskDynamicObjectEmailController(){
        task=[select Id,CreatedBy.Name,Owner.Name,What.Name,whatId,Subject,Priority from Task order by LastModifiedDate desc limit 1];
        objectName=task.whatId.getSObjectType().getDescribe().getLabel();
        url='https://login.i.daimler.com/internet/login?brand=daimler&TYPE=33554432&REALMOID=06-160844b0-6917-1029-860b-8500d09a0cb3&GUID=&SMAUTHREASON=0&METHOD=GET&SMAGENTNAME=$SM$zWIKXAtyqiyXqNMtzUX5MQEuVrjU9gQ5IKuB2lqvcxilo8rxrro%2buYfKSYN8%2bzZ7&TARGET=$SM$HTTPS%3a%2f%2fcdtools%2ei%2edaimler%2ecom%2faffwebservices%2fredirectjsp%2fredirect%2ejsp%3fSPID%3dhttps%3a%2f%2fdaimlerasia%2emy%2esalesforce%2ecom%3fso%3d00D28000000WG36%26ProtocolBinding%3durn%3aoasis%3anames%3atc%3aSAML%3a2%2e0%3abindings%3aHTTP-POST%26SMPORTALURL%3dhttps$%3A$%2F$%2Fcdtools%2ei%2edaimler%2ecom$%2Faffwebservices$%2Fpublic$%2Fsaml2sso';
    }
}