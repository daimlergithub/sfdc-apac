/**
** Wrap service for retail tasks to share.
** 1. Shares "Contract" retail tasks to active users of active dealers, who have both read access to the related person account and vehicle.
** 2. Shares "Retail Activity" retail tasks to active users of the related dealer and the active dealers with the same CRM Code.
** 3. Shares "Service" retail tasks to active users of the related dealer and the active dealers with the same CRM Code.
** 
** Created By: Sushma
** Date: 23-02-2018
**/
public with sharing class RetailTaskSharingWrapServiceBase {
    public RetailTaskSharingWrapServiceBase() {
    }

  
}