public with sharing class YearlyTAReportController {

    public Retail_Campaign__c YearlyTA { get; set; }
    
    public Retail_Campaign__c MBMonthlyMarketJointMedia { get; set; }
    public Retail_Campaign__c MBMonthlyMarketJointEvent { get; set; }
    public Retail_Campaign__c MBMonthlyMarketDrivenMedia { get; set; }
    public Retail_Campaign__c MBMonthlyMarketDrivenEvent { get; set; }
    public Retail_Campaign__c MBMonthlyMarketKPINewLead { get; set; }
    public Retail_Campaign__c MBMonthlyMarketKPINewOrder { get; set; }
    public Retail_Campaign__c AMGMonthlyMarketMedia { get; set; }
    public Retail_Campaign__c AMGMonthlyMarketEvent { get; set; }
    public Retail_Campaign__c AMGMonthlyKPINewLead { get; set; }
    public Retail_Campaign__c AMGMonthlyKPINewOrder { get; set; }
    public Retail_Campaign__c smartMonthlyMarketMedia { get; set; }
    public Retail_Campaign__c smartMonthlyMarketEvent { get; set; }
    public Retail_Campaign__c smartMonthlyKPINewLead { get; set; }
    public Retail_Campaign__c smartMonthlyKPINewOrder { get; set; }
    
	
	
    public YearlyTAReportController() {
        
        String yearlyTAId = ApexPages.currentPage().getParameters().get('id');
        
        YearlyTA = [select Id, Y_MB_Dealer_Driven_Marketing_Budget__c,
                                         Y_MB_Dealer_Driven_Marketing_Expense__c, Y_MB_Joint_Marketing_Budget__c,
                                         Y_MB_Joint_Marketing_Expense__c, Y_MB_Marketing_Budget__c,
                                         Y_MB_Marketing_Expense__c, Y_SMART_Marketing_Budget__c, 
                                         Y_SMART_Marketing_Expense__c, Y_AMG_Marketing_Budget__c,
                                         Y_AMG_Marketing_Expense__c 
                                         from Retail_Campaign__c where Id= :yearlyTAId];    
        
        for(Retail_Campaign__c retailCam : [select Id, M_ATL_BTL__c, M_Brand__c, M_KPI_Type__c, Driven__c, M_Jan__c, M_Feb__c, M_Mar__c, 
                                            M_Apr__c, M_May__c, M_Jun__c, M_Jul__c, M_Aug__c, M_Sep__c, M_Oct__c, M_Nov__c, M_Dec__c
                                            from Retail_Campaign__c where M_YearlyTA__c = :yearlyTAId]) {
            if(retailCam.M_Brand__c == 'MB + StarElite') {
                if(retailCam.M_KPI_Type__c == 'Marketing Budget') {
                    if(retailCam.Driven__c == 'Joint') {
                        if(retailCam.M_ATL_BTL__c == 'Media Plan') {
                            MBMonthlyMarketJointMedia = retailCam;
                        }
                        else if(retailCam.M_ATL_BTL__c == 'Event Plan') {
                            MBMonthlyMarketJointEvent = retailCam;
                        }
                    }
                    else if(retailCam.Driven__c == 'Dealer Driven') {
                        if(retailCam.M_ATL_BTL__c == 'Media Plan') {
                            MBMonthlyMarketDrivenMedia = retailCam;
                        }
                        else if(retailCam.M_ATL_BTL__c == 'Event Plan') {
                            MBMonthlyMarketDrivenEvent = retailCam;
                        }
                    }
                }
                else if(retailCam.M_KPI_Type__c == 'New Lead') {
                    MBMonthlyMarketKPINewLead = retailCam; 
                }
                else if(retailCam.M_KPI_Type__c == 'New Order') {
                    MBMonthlyMarketKPINewOrder = retailCam;  
                }
                
            }                                
            else if(retailCam.M_Brand__c == 'smart') {
                if(retailCam.M_KPI_Type__c == 'Marketing Budget') {
                    if(retailCam.M_ATL_BTL__c == 'Media Plan') {
                        smartMonthlyMarketMedia = retailCam;
                    }
                    else if(retailCam.M_ATL_BTL__c == 'Event Plan') {
                        smartMonthlyMarketEvent = retailCam; 
                    }
                }
                else if(retailCam.M_KPI_Type__c == 'New Lead') {
                    smartMonthlyKPINewLead = retailCam;  
                }
                else if(retailCam.M_KPI_Type__c == 'New Order') {
                    smartMonthlyKPINewOrder = retailCam; 
                }
            }    
            else if(retailCam.M_Brand__c == 'AMG') {
                if(retailCam.M_KPI_Type__c == 'Marketing Budget') {
                    if(retailCam.M_ATL_BTL__c == 'Media Plan') {
                        AMGMonthlyMarketMedia = retailCam;
                    }
                    else if(retailCam.M_ATL_BTL__c == 'Event Plan') {
                        AMGMonthlyMarketEvent = retailCam; 
                    }
                }
                else if(retailCam.M_KPI_Type__c == 'New Lead') {
                    AMGMonthlyKPINewLead = retailCam;  
                }
                else if(retailCam.M_KPI_Type__c == 'New Order') {
                    AMGMonthlyKPINewOrder = retailCam; 
                }
            }
        }                                   
    }
}