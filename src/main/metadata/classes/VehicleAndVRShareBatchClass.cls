global class VehicleAndVRShareBatchClass implements Database.Batchable<sobject>,database.stateful
{
    public static List<string> dealerGCCodeList = new list<string>();
    public static List<string> dealerNDCodeList = new List<string>();
    public static Map<string,string> groupNdCodeMap = new Map<string,string>();
    public static Map<string,string> groupGcCodeMap = new Map<string,string>();
    public static List<Vehicle_Relationship__Share> updateVRShareList = new List<Vehicle_Relationship__Share>();
    public static List<Vehicle__Share> updateVehShareList = new List<Vehicle__Share>();
    public static list<Vehicle_Relationship__c> vehRelList = new list<Vehicle_Relationship__c>();
    global database.QueryLocator start(database.BatchableContext bc)
    { 
        string query = 'Select Id, Vehicle_ID__c, Contact__c,Owner_Dealer__r.Dealer_GC_Code__c,Owner_Dealer__r.Dealer_ND_Code__c,Owner_Dealer__r.Dealer_Type__c from Vehicle_Relationship__c where Owner_Dealer__r.Dealer_GC_Code__c in '+'(\'GC0037971\',\'GC0011433\',\'GC0037972\',\'GC0011434\')'+' and MD__C =' +'\'KR\' and Recordtype.Name = ' +'\'Vehicle Relationship Retail\'';
        return database.getQueryLocator(query);
        //'(\'GC0011422\',\'GC0011430\',\'GC0037972\',\'GC0037972\')
    }
    global void execute(database.BatchableContext bc,List<Vehicle_Relationship__c> scope)
    {
        dealerGCCodeList.add('GC0011422');
        dealerGCCodeList.add('GC0011430');
        dealerGCCodeList.add('GC0037972');
        dealerGCCodeList.add('GC0037971');
        Set<string> ndCodeList = New Set<String>();
        List<Account> accntList = [select Id, Dealer_ND_Code__c, Dealer_GC_Code__c, Dealer_Type__c from Account where Recordtype.Name = 'Dealer' and Dealer_GC_Code__c =:dealerGCCodeList and MD__c = 'KR'];
        for(Account acc : accntList){
        
           ndCodeList.add(acc.Dealer_ND_Code__c);
        }
        
        
        List<group> grpList = [select Id, Name, Type from Group where Name in :ndCodeList];
        if(!accntList.isEmpty() && accntList != null && !grpList.isEmpty() && grpList != null)
        {
            for(group gr : grpList)
            {
                for(Account acc : accntList)
                {
                    if(acc.Dealer_Type__c == 'Company' && gr.Name == acc.Dealer_ND_Code__c)
                    {
                        groupGcCodeMap.put(acc.Dealer_GC_Code__c,gr.Id);
                    }
                    
                    if(acc.Dealer_Type__c == 'outlet' && gr.Name == acc.Dealer_ND_Code__c)
                    {
                        groupNdCodeMap.put(acc.Dealer_ND_Code__c,gr.Id);
                    }
                }
            }
        }
        if(!scope.isEmpty() && scope != null)
        {
            for(Vehicle_Relationship__c vehRel : scope)
            {
                if((groupNdCodeMap.get(vehRel.Owner_Dealer__r.Dealer_ND_Code__c))!=null && groupNdCodeMap != null)
            {
                Vehicle_Relationship__Share vehicleRelationShare = new Vehicle_Relationship__Share();
                vehicleRelationShare.AccessLevel = 'Edit';
                vehicleRelationShare.UserOrGroupId = groupNdCodeMap.get(vehRel.Owner_Dealer__r.Dealer_ND_Code__c);
                vehicleRelationShare.ParentId = vehRel.Id;
                updateVRShareList.add(vehicleRelationShare);   
    
                Vehicle__Share vehicleShare = new Vehicle__Share();
                vehicleShare.AccessLevel = 'Edit';
                vehicleShare.UserOrGroupId = groupNdCodeMap.get(vehRel.Owner_Dealer__r.Dealer_ND_Code__c);
                vehicleShare.ParentId = vehRel.Vehicle_ID__c;
                updateVehShareList.add(vehicleShare);
            }
            if((groupGcCodeMap.get(vehRel.Owner_Dealer__r.Dealer_GC_Code__c))!=null && groupGcCodeMap != null)
            {
                
                Vehicle_Relationship__Share vehicleRelationShare = new Vehicle_Relationship__Share();
                vehicleRelationShare.AccessLevel = 'Edit';
                vehicleRelationShare.UserOrGroupId = groupGcCodeMap.get(vehRel.Owner_Dealer__r.Dealer_GC_Code__c);
                vehicleRelationShare.ParentId = vehRel.Id;
                updateVRShareList.add(vehicleRelationShare);   
    
                Vehicle__Share vehicleShare = new Vehicle__Share();
                vehicleShare.AccessLevel = 'Edit';
                vehicleShare.UserOrGroupId = groupGcCodeMap.get(vehRel.Owner_Dealer__r.Dealer_GC_Code__c);
                vehicleShare.ParentId = vehRel.Vehicle_ID__c;
                updateVehShareList.add(vehicleShare);
            }
        }
        
        if(!updateVRShareList.isEmpty() && updateVRShareList != null)
        {
            insert updateVRShareList;
        }
        if(!updateVehShareList.isEmpty() && updateVehShareList != null)
        {
            insert updateVehShareList;
        }
    }
    }
    global void finish(database.BatchableContext bc)
    {
                    
    }
}