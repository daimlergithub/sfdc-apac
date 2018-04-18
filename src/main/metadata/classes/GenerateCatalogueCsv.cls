/*
Type: Apex class to Generate Catalogue data in CSV format and Upload in CRM content.
This Class is referenced from "Download Catalogue" button in DM request List Page.
---------------------------------------------------------------------------------------


26-11-2015 Created by Narasimha Gundurao
*/
global class  GenerateCatalogueCsv 
{
    
    // Class level variables Declaration
    public static list<DM_Request__c> DMRequests = new list<DM_Request__c>();
    public static list<Dealer_Locator__c> DlList = new list<Dealer_Locator__c>();
    public static list<String> Zipcodes = new list<String>();
    public static map<String,Account> AccPostCodeMap = new map<String,Account>();
    
    
    /**
*@Description :This method generates CSV file of  All the DM Requests with Status "To be Sent"
with related Dealer and Dm Request Information and Uploads the file into CRM Content Library,then changes 
the Status of DM requests to "Sent". Creates Task and assigns to the Logged In User with Link of the Generated file.
*@Date : 26/11/2015
*@param:None
*@return:This mehtod Returns String

*/ 
    webservice static String getDMRequests() 
    {
        if(!test.isRunningTest()){ 
            
            // Logic to check the previous download request time and avoid users to download File again within specific time period 
            DMCatalogueTimeStamp__c DMct = DMCatalogueTimeStamp__c.getInstance('PreviousRequestTime');
            datetime previousReq  = DMct.CatalogueDownloadTime__c;
            Decimal TimeDiffinMins =  (system.now().getTime() -  previousReq.getTime())/(1000.0*60.0) ; 
            system.debug('Difference bw requests is' + TimeDiffinMins); 
            
            if(TimeDiffinMins < 3)
            {
                return '<3';
            }
            
            
        }
        
        // Initialization of  Strings locally which are added as columns to CSV file
        string DealerName1 ='';
        string DealerAddress1 = '';
        string DealerPhone1 = '';
        String DealerName2 = '';
        String DealerAddress2 = '';
        string DealerPhone2 = '' ;
        String DealerName3 = '';
        String DealerAddress3 = '';
        string DealerPhone3 = '';
        string LabelPrintName = '';
        string CsvHeader;
        string generatedCSVFile = '';
        String fileRow = '';
        
        // Query to fetch all the DM Requests with Status = "to be sent"  limit 1000.
        DMRequests = [select id,TitleOfHonor__c,Status1__c,Status2__c,Status3__c,Zip_Code__c,Province__c,Additional_Address__c,Address__c,Name,Customer_Name__c,Customer_Name__r.ZipCode__c,Attention__c,
                      Customer_Name__r.Name,Customer_Name__r.RecordType.Name,Customer_Name__r.Company_Name__c,Expected_DM_Material1__r.Preliminary_Flag__c,Expected_DM_Material1__r.Label_Printing_Name__c ,Expected_DM_Material2__r.Preliminary_Flag__c,Expected_DM_Material3__r.Preliminary_Flag__c,
                      Customer_Name__r.Main_Dealer__r.Dealer_Address_CN__c,Customer_Name__r.Main_Dealer__r.Phone,Delivery_Type__c,Customer_Name__r.Main_Dealer__r.Name,
                      Expected_DM_Material2__r.Label_Printing_Name__c,Expected_DM_Material3__r.Label_Printing_Name__c, status__c,Expected_DM_Material1__r.Print_Due_Date__c,Expected_DM_Material2__r.Print_Due_Date__c,Expected_DM_Material3__r.Print_Due_Date__c from DM_Request__c where Status__c = 'to be sent' and md__c='JP' Limit 1000];
        
        
        if(!DMRequests.isEmpty())
        {
            // Loop through the DM requests list to fetch Zipcodes
            for (DM_request__c dmr : DMRequests) {
                
                if(dmr.Zip_Code__c != null)
                    Zipcodes.add(dmr.Zip_Code__c);
            }
            
            // Query to fetch Dealer Locator objects based on the Zip codes of DM Requests
            DlList = [select id ,Sequence_No__c,Dealer_Name__c,Dealer_Name__r.Branch_name__c,Dealer_Name__r.Dealer_Address_CN__c,Post_Code__c,Dealer_Name__r.Phone from Dealer_Locator__c where Post_Code__c in :Zipcodes Limit 1000 ];
            
            // Adding Column Headers for the CSV file
            CsvHeader = 'DM Number' + ',' + Label.Company_Name_Department_Title +',' + 'Customer Name' + ',' + 'Zip Code' + ',' + 'Province' +','+ Label.Address_1 + ',' +Label.Address_2 +','
                + 'Label Printing Name' +',' + Label.My_shop_Name +',' + Label.My_Shop_Address+ ',' + Label.MyShop_Phone +
                ',' + Label.Near_Dealer_1 +',' + Label.Near_Dealer_Address1 + ',' + Label.Near_Dealer_Phone1 +',' +Label.Near_Dealer_2 +',' + Label.Near_Dealer_Address2 +
                ',' + Label.Near_Dealer_Phone2 +',' + Label.Near_Dealer_3 +',' + Label.Near_Dealer_Address3 +',' + Label.Near_Dealer_Phone3 + ',' + 'Delivery Type' + '\n';
            
             generatedCSVFile =   CsvHeader;
            
            // Loop through DM request List to populate rows in CSV file.
            for(DM_request__c Dmr : DMRequests)
            { 
                
                if(Dmr.Status1__c == 'to be sent')  
                {
                    if(Dmr.Expected_DM_Material1__c != null && (Dmr.Expected_DM_Material1__r.Preliminary_Flag__c == false ||  (Dmr.Expected_DM_Material1__r.Preliminary_Flag__c == true && Dmr.Expected_DM_Material1__r.Print_Due_Date__c <= system.today() )) 
                       && (Dmr.Expected_DM_Material1__r.Label_Printing_Name__c != null && Dmr.Expected_DM_Material1__r.Label_Printing_Name__c != '' ))
                    {
                        LabelPrintName +=  Dmr.Expected_DM_Material1__r.Label_Printing_Name__c ;
                        Dmr.Status1__c = 'Success' ;   
                    }
                }
                
                LabelPrintName += '/';
                
                
                
                
                if(Dmr.Status2__c == 'to be sent' )
                {
                    if(Dmr.Expected_DM_Material2__c != null && (Dmr.Expected_DM_Material2__r.Preliminary_Flag__c == false ||  (Dmr.Expected_DM_Material2__r.Preliminary_Flag__c == true && Dmr.Expected_DM_Material2__r.Print_Due_Date__c <= system.today() )) 
                       && (Dmr.Expected_DM_Material2__r.Label_Printing_Name__c != null && Dmr.Expected_DM_Material2__r.Label_Printing_Name__c != '' ))
                    {
                        LabelPrintName +=  Dmr.Expected_DM_Material2__r.Label_Printing_Name__c ;
                        Dmr.Status2__c = 'Success' ;
                    }
                }
                
                LabelPrintName += '/';
                
                if(Dmr.Status3__c == 'to be sent') 
                {
                    if(Dmr.Expected_DM_Material3__c != null && (Dmr.Expected_DM_Material3__r.Preliminary_Flag__c == false ||  (Dmr.Expected_DM_Material3__r.Preliminary_Flag__c == true && Dmr.Expected_DM_Material3__r.Print_Due_Date__c <= system.today() )) 
                       && (Dmr.Expected_DM_Material3__r.Label_Printing_Name__c != null && Dmr.Expected_DM_Material3__r.Label_Printing_Name__c != '' ))
                    {
                        LabelPrintName +=  Dmr.Expected_DM_Material3__r.Label_Printing_Name__c ;
                        Dmr.Status3__c = 'Success' ;
                    }
                }
                
                if(LabelPrintName == '//')
                {
                    LabelPrintName = '';
                    continue;
                }
                
                
                
                fileRow = dmr.Name;
                fileRow += ','+ ((dmr.Attention__c != null) ? dmr.Attention__c  : '' );
                
                if(dmr.Customer_Name__r.RecordType.Name == 'Company')
                {
                    
                    fileRow += ','+ ((dmr.Customer_Name__r.Company_Name__c != null && dmr.Customer_Name__r.Company_Name__c != '' ) ? dmr.Customer_Name__r.Company_Name__c  : dmr.Customer_Name__r.Name   );
                    
                }
                
                else if(dmr.Customer_Name__r.RecordType.Name == 'Person Account' && dmr.TitleOfHonor__c == 'To Person')
                {
                    fileRow += ','+ dmr.Customer_Name__r.Name;
                    
                }
                else
                {
                    fileRow += ',' + '';
                }
                
                
                fileRow += ','+ ((dmr.Zip_Code__c != null) ? dmr.Zip_Code__c  : ''   );
                fileRow += ','+ ((dmr.Province__c != null) ?  dmr.Province__c : '' );
                fileRow += ','+ ((dmr.Address__c != null) ? dmr.Address__c  : '' );
                fileRow += ','+ ((dmr.Additional_Address__c != null) ? dmr.Additional_Address__c  : '' );
                fileRow += ','+ LabelPrintName;
                fileRow += ','+ ((dmr.Customer_Name__r.Main_Dealer__r.Name != null) ? dmr.Customer_Name__r.Main_Dealer__r.Name  : '' );
                fileRow += ','+ ((dmr.Customer_Name__r.Main_Dealer__r.Dealer_Address_CN__c != null) ? dmr.Customer_Name__r.Main_Dealer__r.Dealer_Address_CN__c  : '' );
                fileRow += ','+ ((dmr.Customer_Name__r.Main_Dealer__r.Phone != null) ? dmr.Customer_Name__r.Main_Dealer__r.Phone  : '' );
                
                
                
                
                
                if(!DlList.isEmpty())
                {
                    
                    
                    //Temp list to hold the Dealer Locator Objects related to Particular DM Request based on Zip code
                    List<Dealer_Locator__c> TempDlList = new List<Dealer_Locator__c>();
                    
                    //Loop through Dealer Locator objects with matching zipcodes as of Dm requests and fetch the related Dealer information and put in TempDlList
                    for(Dealer_Locator__c Dlr : DlList)
                    {
                        if(Dlr.Post_Code__c == dmr.Zip_Code__c)
                        {
                            
                            TempDlList.add(Dlr);
                            
                        }
                    }
                    
                    if(!TempDlList.isEmpty())
                    {
                        if(TempDlList.size() == 1)
                        {
                            DealerName1 = TempDlList[0].Dealer_Name__r.Branch_name__c;
                            DealerAddress1 = TempDlList[0].Dealer_Name__r.Dealer_Address_CN__c;
                            DealerPhone1 = TempDlList[0].Dealer_Name__r.Phone;
                            
                            TempDlList.clear();
                        }
                        
                        else if(TempDlList.size() == 2)
                        {
                            DealerName1 = TempDlList[0].Dealer_Name__r.Branch_name__c;
                            DealerAddress1 = TempDlList[0].Dealer_Name__r.Dealer_Address_CN__c;
                            DealerPhone1 = TempDlList[0].Dealer_Name__r.Phone;
                            
                            DealerName2 = TempDlList[1].Dealer_Name__r.Branch_name__c;
                            DealerAddress2 = TempDlList[1].Dealer_Name__r.Dealer_Address_CN__c;
                            DealerPhone2 = TempDlList[1].Dealer_Name__r.Phone;
                            
                            TempDlList.clear();
                            
                        }
                        else 
                        {
                            
                            DealerName1 = TempDlList[0].Dealer_Name__r.Branch_name__c;
                            DealerAddress1 = TempDlList[0].Dealer_Name__r.Dealer_Address_CN__c;
                            DealerPhone1 = TempDlList[0].Dealer_Name__r.Phone;
                            
                            DealerName2 = TempDlList[1].Dealer_Name__r.Branch_name__c;
                            DealerAddress2 = TempDlList[1].Dealer_Name__r.Dealer_Address_CN__c;
                            DealerPhone2 = TempDlList[1].Dealer_Name__r.Phone;
                            
                            DealerName3 = TempDlList[2].Dealer_Name__r.Branch_name__c;
                            DealerAddress3 = TempDlList[2].Dealer_Name__r.Dealer_Address_CN__c;
                            DealerPhone3 = TempDlList[2].Dealer_Name__r.Phone;
                            
                            TempDlList.clear();
                            
                        }
                    }
                    
                    
                    
                    
                    
                    // write the related Dealer information to file if not null. Blank if null. 
                    fileRow += ','+  ((DealerName1 != null) ? DealerName1  : '' );
                    fileRow += ','+  ((DealerAddress1 != null) ? DealerAddress1  : '' );
                    fileRow += ','+  ((DealerPhone1 != null) ? DealerPhone1  : '' );
                    fileRow += ','+  ((DealerName2 != null) ? DealerName2  : '' );
                    fileRow += ','+  ((DealerAddress2 != null) ? DealerAddress2  : '' );
                    fileRow += ','+  ((DealerPhone2 != null) ? DealerPhone2  : '' );
                    fileRow += ','+  ((DealerName3 != null) ? DealerName3  : '' );
                    fileRow += ','+  ((DealerAddress3 != null) ? DealerAddress3  : '' );
                    fileRow += ','+  ((DealerPhone3 != null) ? DealerPhone3  : '' );
                    
                    
                    DealerName1 ='';
                    DealerAddress1 = '';
                    DealerPhone1 = '';
                    DealerName2 = '';
                    DealerAddress2 = '';
                    DealerPhone2 = '' ;
                    DealerName3 = '';
                    DealerAddress3 = '';
                    DealerPhone3 = '';
                    
                }     
                
                else
                {
                    fileRow += ','+   DealerName1  ;
                    fileRow += ','+   DealerAddress1 ;
                    fileRow += ','+   DealerPhone1;
                    fileRow += ','+   DealerName2  ;
                    fileRow += ','+   DealerAddress2  ;
                    fileRow += ','+   DealerPhone2  ;
                    fileRow += ','+   DealerName3  ;
                    fileRow += ','+   DealerAddress3  ;
                    fileRow += ','+   DealerPhone3  ;
                    
                    
                }
                
                fileRow += ','+ ((dmr.Delivery_Type__c != null) ? dmr.Delivery_Type__c  : '' );
                
                generatedCSVFile = generatedCSVFile + fileRow + '\n';
                //reset the strings for next row/Iteration
                LabelPrintName = '';
                fileRow = '';
                // change the status of DM request to "Sent"  after writing it to CSV.
                
                Dmr.Sent_Date__c =  system.today();
                if(Dmr.Status1__c != 'to be sent' && Dmr.Status2__c != 'to be sent' && Dmr.Status3__c != 'to be sent')
                {
                    Dmr.Status__c = 'Sent';
                }
            }
            
            
            
            if(generatedCSVFile == CsvHeader)
            {
                return 'NoTargetRows' ;
                
            }
            
            
            // Create CSV file from the String.
            
            Blob csvBlob = blob.valueOf(generatedCSVFile);
            
            if(csvBlob != null )
            {
                try
                {
                    update DMRequests;
                }
                
                catch(DMLException de)
                {
                    System.debug('DML Exception :' + de);
                    return 'exception';
                }
            }
            
            //Fetch the CRM Content Library folder name where the file is uploaded.
            if(!test.isRunningTest()){ 
                ContentWorkspace DMCatalogueWorkspace = [select id,Name from ContentWorkspace where name = 'DM Catalogues'];
                // create new Content version of CSV file and store in the Library.
                ContentVersion  DMRCatalogue = new ContentVersion();
                DMRCatalogue.Title = 'Catalogue' +System.now().format('yyyy-MMM-dd-hh-mm-ss') + '.csv';
                DMRCatalogue.FirstPublishLocationID = DMCatalogueWorkspace.id;
                DMRCatalogue.VersionData = csvBlob;
                DMRCatalogue.PathOnClient = 'Catalogue' +System.now().format('yyyyMMddhhmmss') + '.csv';
                
                insert DMRCatalogue;
                system.debug('the Contentversion Id is' + DMRCatalogue.id );
                
                // Create Task and assign to User who clicked Download button, Provided with link of CRM library where file is uploaded.
                Task CatalogueTask = new Task();
                CatalogueTask.RecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('General Task').getRecordTypeId();
                CatalogueTask.Subject = 'Catalogue file ready';
                CatalogueTask.Description = 'Your catalogue file is ready to be downloaded. Please download it from the link below:'  + System.Url.getSalesforceBaseURL().toExternalForm()+'/sfc/#workspaceView?selectedWorkspaceId='+DMCatalogueWorkspace.id;
                CatalogueTask.OwnerId = userinfo.getUserId();
                CatalogueTask.ActivityDate = system.today();
                Database.DMLOptions notifyOption = new Database.DMLOptions();
                notifyOption.EmailHeader.triggerUserEmail = true;
                Database.insert(CatalogueTask, notifyOption);
                
                system.debug(notifyOption+ '  created task id is' + CatalogueTask.id );
            }
            if(!test.isRunningTest())
            {
            DMCatalogueTimeStamp__c DMct = DMCatalogueTimeStamp__c.getInstance('PreviousRequestTime');
            DMct.CatalogueDownloadTime__c = system.now();
            update DMct;
			}
            return 'true';    
        }
        
        
        else
            return 'false'; 
    }
}