public with sharing class Lead_AddmultiBrandController 
{
    
    public List<wrappermultibrandclass> wrapperlist = new List<wrappermultibrandclass>();
    public set<string> carmodelset = new set<string>();
    Public list<Car_Model__c> carmodellist;
    Public list<string> carmodelstrng = new list<string>();
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
        public list<List<SelectOption>> brands{get; set;}
    }
        
    public list<List<SelectOption>> getbrands()
    {
        carmodellist = [select name from Car_Model__c];
        for(Car_Model__c card :carmodellist)
        {
            carmodelset.add(card.name);
        }
        carmodelstrng.addAll(carmodelset);
        List<list<SelectOption>> optionslist = new list<List<SelectOption>>();
        List<SelectOption> options = new List<SelectOption>();
        integer counter=0;
        for(integer i=0;i<carmodelstrng.size();i++)
        {           
            options.add(new selectoption(carmodelstrng[i],carmodelstrng[i]));
            if(counter==999 || i==carmodelstrng.size()-1){
                optionslist.add(options);
                options =new List<SelectOption>();
                counter=-1;
            }
            counter++;
            
        }
        return optionslist;
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