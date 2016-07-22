public class BrochureLinkController {
    public string URL{get; set;}
    public string URL1{get; set;}
    public lead__c lead;
    
    
    
    public id leadId1;
    public id getleadId1(){ return leadId1; }
    public void setleadId1(id s){
        leadId1= s;
        BrochureLinkController1();
    }
    public void BrochureLinkController1()
        {
    
    lead=[select Business_Unit__c from lead__c where id =:leadId1];
    if(lead.Business_Unit__c !='' && !lead.Business_Unit__c.equals(null) )
    {    
       try
       {     
        Lead_Vehicle_BrochureUrls__c brcurl = Lead_Vehicle_BrochureUrls__c.getValues(lead.Business_Unit__c);  
        URL=brcurl.Download_Centre__c;
        URL1 = brcurl.Driveaway_Pricing_Calculator__c;   
        }
        catch(Exception e)
        {
        
        }
        
        }
      else
      	{
          URL='  ';
        }           
     }    
}