public with sharing class Lead_AddmultiBrandController 
{
    
    public List<wrappermultibrandclass> wrapperlist = new List<wrappermultibrandclass>();
    Public list<Car_Model__c> carmodellist;
    Public list<Lead__c> leadllist=new list<Lead__c>();
    Public map<id,Lead__c> mapupdateleadllist=new map<id,Lead__c>();
    public map<id,string> oldleaditems= new map<id,string>();
    Public Id LeadId;
    public static Lead__c lead = new Lead__c();
    public List<wrappermultibrandclass> wrappermultibrand{get{return wrapperlist;}set{wrapperlist=value;}}
    public Lead_AddmultiBrandController(ApexPages.StandardController controller)
    {        
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
    leadllist=[select id,Lead_Items__c from Lead__c where id=:ApexPages.currentPage().getParameters().get('id')];
    system.debug('%updatelleadllisteadllist^$%$%$%$'+leadllist);
        String commaSepratedList='';
        string regexForNullValue ='null';
        string nullValue ='';

        for(wrappermultibrandclass wrper:wrapperlist)
        {                    
            for(Lead__c led:leadllist)
            {
                commaSepratedList +=wrper.vehiclebrand + '-' + wrper.vechmodel + '-' + wrper.vechquanty ;
                if(led.Lead_Items__c != null)                
                {
                    oldleaditems.put(led.Id,led.Lead_Items__c);                    
                    led.Lead_Items__c =oldleaditems.get(led.Id)+ '\n' + wrper.vehiclebrand + '-' + wrper.vechmodel + '-' + wrper.vechquanty; 
                }
                else if(led.Lead_Items__c == null || led.Lead_Items__c == '')
                {
                    led.Lead_Items__c = commaSepratedList;
                }
                led.Lead_Items__c = led.Lead_Items__c.replaceAll(regexForNullValue,nullValue);
                mapupdateleadllist.put(led.id,led);
            }
        }
        update mapupdateleadllist.values();
        system.debug('%^$%$%$%$'+commaSepratedList);
    }
}