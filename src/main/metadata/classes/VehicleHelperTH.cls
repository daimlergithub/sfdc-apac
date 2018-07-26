/**************************************************************************************************************************************************
* Class:                            vehicleHelperTH
* Description:                      This class will share all vehicle products records to the respective dealers
on after insert context.
@methods Description            
* --------------------------------------------------------------------------------------------------------------------------------------------------
* Date                              Name                        Modification Description
* Created Date : 2018-6-6    Dhanamjaya D                       Created  

=====================================================================================================================================================*/
public class VehicleHelperTH{
    public static Id vehicleProductrecordid = RecordTypeAccessService.getRecordTypeId('vehicle__C','Vehicle Product');
    public static void shareRecordsWithDealers(List<vehicle__c> listvehicle){
        Map<id,String>  idwithndcode=new Map<id,String>();
        List<Vehicle__share> vehshare=new List<vehicle__share>();
        for(vehicle__c veh:[Select id,createdby.dealer_nd_code__C,RecordTypeId from vehicle__c where id IN:listvehicle and recordtypeid=:vehicleProductrecordid]){
            if(Userinfo.getUserType()=='PowerPartner'){
                idwithndcode.put(veh.id,'TH'+veh.createdby.dealer_nd_code__C); 
            }
        
    }
           for(Group g:[select Name from group where name IN : idwithndcode.values() ]){
           for(Id id:idwithndcode.keyset()){
               if(idwithndcode.get(id)==g.name){
                   vehshare.add(new vehicle__share(ParentId=id,AccessLevel='EDIT',RowCause=Schema.vehicle__share.RowCause.Manual,UserOrGroupId=g.id));
               }    
           } 
        }
        if(vehshare.size()>0){
              DMLManagerService.insertAsSystem(vehshare);
        }
    }
}