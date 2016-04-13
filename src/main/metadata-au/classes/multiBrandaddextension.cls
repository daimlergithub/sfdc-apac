public with sharing class multiBrandaddextension 
{
    
    public List<wrappermultibrandclass> wrapperlist = new List<wrappermultibrandclass>();
    Public list<Car_Model__c> carmodellist;
    Public list<Lead__c> leadllist=new list<Lead__c>();
    Public list<Lead__c> updateleadllist=new list<Lead__c>();
    Public Id LeadId;
    public static Lead__c lead = new Lead__c();
    public List<wrappermultibrandclass> wrappermultibrand{get{return wrapperlist;}set{wrapperlist=value;}}
    /*public List<wrappermultibrandclass> getwrappermultibrand()
    {
        wrappermultibrandclass wrapper = new wrappermultibrandclass();
        wrapper.vehiclebrand = getBrands();
        wrapper.vechmodel = '';
        wrapper.vechquanty = '';
        return wrapperlist;
    }*/
    public multiBrandaddextension(ApexPages.StandardController controller)
    {
        //controller.addFields(new List<string>{'Id','Lead_Items__c'});
        //lead = (Lead__c)controller.getRecord();
        LeadId=ApexPages.currentPage().getParameters().get('id');
        system.debug('lead t^$%$%$%$'+lead);
        system.debug('LeadIdLeadId t^$%$%$%$'+LeadId);
        wrappermultibrandclass wrapper = new wrappermultibrandclass();
        wrapper.vehiclebrand = '';
        wrapper.vechmodel = '';
        wrapper.vechquanty = '';
        wrapperlist.add(wrapper);
        //addrow();     

    }
    public class wrappermultibrandclass
    {
        public string vehiclebrand{get; set;}
        public string vechmodel{get; set;}
        public string vechquanty{get; set;}
        public List<SelectOption> brands{get; set;}
    }
        
    public List<SelectOption> getbrands()
    {
        carmodellist = [select name from Car_Model__c];
        List<SelectOption> options = new List<SelectOption>();
        for(Car_Model__c carmod :carmodellist)
        {
            options.add(new selectoption(carmod.Name,carmod.Name));
        }
        return options;
    }
    public void addrow()
    {        
        wrappermultibrandclass wrapper = new wrappermultibrandclass();
        wrapper.vehiclebrand ='';
        wrapper.vechmodel = '';
        wrapper.vechquanty = '';        
        if(wrapperlist.size() <10)
        {
            wrapperlist.add(wrapper);
        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'You cannot add more than 10 rows'));
        }
    }
    public void save()
    {
    leadllist=[select id,Lead_Items__c from Lead__c where id=:lead.id];
    system.debug('%updatelleadllisteadllist^$%$%$%$'+leadllist);
        String commaSepratedList='';
        
        for(Lead__c led:leadllist)
        {
        for(wrappermultibrandclass wrper:wrapperlist)
        {
            commaSepratedList +=wrper.vehiclebrand + '-' + wrper.vechmodel + '-' + wrper.vechquanty + '\n';
            //led.Lead_Items__c =commaSepratedList; 
            updateleadllist.add(led) ;
        }
        }
        update updateleadllist;
        system.debug('%^$%$%$%$'+commaSepratedList);
        system.debug('%updateleadllist^$%$%$%$'+updateleadllist);
    }
}