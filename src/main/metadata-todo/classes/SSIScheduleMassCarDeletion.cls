/*
    Type:       SSI Schedule Smart Car Deletion
    Purpose:    Everyday at midnight, system will automatically delete "Smart" model car.
    User Story: 
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Patrick Zhang Created on 2013-11-14
*/
global class SSIScheduleMassCarDeletion implements Schedulable{

    private User sinotrust;

    global void execute(SchedulableContext sc){
        if(sinotrust == null){
            List<User> sList = [Select Id From User Where Profile.Name = 'BMBS Sinotrust User' And IsActive = true Limit 1];
            if (sList.size() > 0) {
                sinotrust = sList[0];
            }       
        }  
        List<SSI__c> smartCars;
        if (smartCars == null) {
            smartCars = new List<SSI__c>();
            for(List<SSI__c> ssis : [
                SELECT 
                    VehicleUSvin__c, 
                    VehicleModel__c, 
                    VehicleDesc__c, 
                    VehicleCBUCKD__c, 
                    Person__c, 
                    Ownertype__c, 
                    Original_HomeMobilePhone__c, 
                    OriginalOfficePhone__c, 
                    OriginalCustomerName__c, 
                    OfficePhone__c, 
                    Invoice_Month__c, 
                    InvoiceDate__c, 
                    HomeMobilePhone__c, 
                    HandoverDate__c, 
                    Dealer__c, 
                    DealerName__c, 
                    CustomerTitle__c, 
                    CustomerName__c, 
                    ContractDate__c, 
                    CompanyName__c,
                    //Barney lai 2014-3-14 start
                    Newly_Task_Id__c,
                    CarModelCheck_Status__c,
                    Comments__c,
                    Created_By_EP_Transaction__c,
                    DealerCheck_Status__c,
                    Encode_Dealer_Name__c,
                    Mark__c,
                    SSI_SourceId__c,
                    Status__c,
                    Survey_Finished__c,
                    SuspectCarModel_Review__c,
                    SuspectDealer_Review__c,
                    Suspect_Reason__c,
                    Updated_By_EP_Transactions__c,
                    VehicleID__c,
                    New_Used__c
                    //Barney lai 2014-3-14 start
                FROM SSI__c
                WHERE CreatedDate >= LAST_N_DAYS:60 AND VehicleDesc__c LIKE 'smart%']){
                for (SSI__c ssi : ssis) {
                      smartCars.add(ssi);
                }
            }
        }
        
        try{
            if(smartCars != null && smartCars.size() > 0){
                List<Smart_SSI__c> smarts = new List<Smart_SSI__c>();
                for (SSI__c ssi : smartCars) {
                    Smart_SSI__c smart = new Smart_SSI__c(                        
                        VehicleUSvin__c = ssi.VehicleUSvin__c , 
                        VehicleModel__c = ssi.VehicleModel__c , 
                        VehicleDesc__c = ssi.VehicleDesc__c , 
                        VehicleCBUCKD__c = ssi.VehicleCBUCKD__c , 
                        Person__c = ssi.Person__c , 
                        Ownertype__c = ssi.Ownertype__c , 
                        Original_HomeMobilePhone__c = ssi.Original_HomeMobilePhone__c, 
                        OriginalOfficePhone__c = ssi.OriginalOfficePhone__c , 
                        OriginalCustomerName__c = ssi.OriginalCustomerName__c , 
                        OfficePhone__c = ssi.OfficePhone__c ,  
                        InvoiceDate__c = ssi.InvoiceDate__c , 
                        HomeMobilePhone__c = ssi.HomeMobilePhone__c , 
                        HandoverDate__c = ssi.HandoverDate__c , 
                        Dealer__c = ssi.Dealer__c , 
                        DealerName__c = ssi.DealerName__c , 
                        CustomerTitle__c = ssi.CustomerTitle__c , 
                        CustomerName__c = ssi.CustomerName__c , 
                        ContractDate__c = ssi.ContractDate__c , 
                        CompanyName__c = ssi.CompanyName__c ,                       
                        //Barney lai 2014-3-14 start
                        Newly_Task_Id__c = ssi.Newly_Task_Id__c ,
                        CarModelCheck_Status__c = ssi.CarModelCheck_Status__c ,
                        Comments__c = ssi.Comments__c ,
                        Created_By_EP_Transaction__c = ssi.Created_By_EP_Transaction__c ,
                        DealerCheck_Status__c = ssi.DealerCheck_Status__c ,
                        Encode_Dealer_Name__c = ssi.Encode_Dealer_Name__c ,
                        Mark__c = ssi.Mark__c ,
                        SSI_SourceId__c = ssi.SSI_SourceId__c ,
                        Status__c = ssi.Status__c ,
                        Survey_Finished__c = ssi.Survey_Finished__c ,
                        SuspectCarModel_Review__c = ssi.SuspectCarModel_Review__c ,
                        SuspectDealer_Review__c = ssi.SuspectDealer_Review__c ,
                        Suspect_Reason__c = ssi.Suspect_Reason__c ,
                        Updated_By_EP_Transactions__c = ssi.Updated_By_EP_Transactions__c ,
                        VehicleID__c = ssi.VehicleID__c,
                        New_Used__c = ssi.New_Used__c
                        //Barney lai 2014-3-14 end
                    );
                    if (sinotrust != null) {
                        smart.OwnerId = sinotrust.Id;
                    }
                    smarts.add(smart);
                }
                insert smarts;
                delete smartCars;
            }
        }catch(DmlException e){
            System.debug('An unexpected error has occured: ' + e.getMessage());
        }
    }
}