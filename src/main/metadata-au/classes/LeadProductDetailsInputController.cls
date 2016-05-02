public with sharing class LeadProductDetailsInputController
{   
    public List<wrappermultibrandclass> wrapperlist = new List<wrappermultibrandclass>();
    Public list<Car_Model__c> carmodellist;
    Public list<Lead_Product__c> leadproductllist=new list<Lead_Product__c>();
    Public map<id,Lead_Product__c> mapupdateleadllist=new map<id,Lead_Product__c>();
    public map<id,string> oldleaditems = new map<id,string>();
    public List<wrappermultibrandclass> wrappermultibrand{get{return wrapperlist;}set{wrapperlist=value;}}
    
    
    public LeadProductDetailsInputController(ApexPages.StandardController controller)
    {
		//Test
        //controller.addFields(new List<string>{'Id','Lead_Items__c'});
        //lead = (Lead__c)controller.getRecord();
        //system.debug('lead t^$%$%$%$'+lead);
        wrappermultibrandclass wrapper = new wrappermultibrandclass();
        wrapper.vehiclebrand = '';
        wrapper.vechmodel = '';
        wrapper.vechquanty = '';
        wrapperlist.add(wrapper);
    }
    public class wrappermultibrandclass
    {
        public string vehiclebrand{get; set;}
        public string vechmodel{get; set;}
        public string vechquanty{get; set;}
        public List<SelectOption> brands{get; set;}
    }
        
    public list<List<SelectOption>> getbrands()
    {
        carmodellist = [select name from Car_Model__c];
        List<list<SelectOption>> optionslist = new list<List<SelectOption>>();
        List<SelectOption> options = new List<SelectOption>();
        integer counter=0;
        for(integer i=0;i<carmodellist.size();i++)
        {           
            options.add(new selectoption(carmodellist[i].Name,carmodellist[i].Name));
            if(counter==999 || i==carmodellist.size()-1){
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
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'You cannot add more than 10 rows'));
        }
    }
    public void save()
    {
        leadproductllist=[select id,Lead_Product_Items__c from Lead_Product__c where id=:ApexPages.currentPage().getParameters().get('id')];
        String commaSepratedList='';

        for(wrappermultibrandclass wrper:wrapperlist)
        {                    
            for(Lead_Product__c led : leadproductllist)
            {

                if(led.Lead_Product_Items__c !=null)
                {
                    oldleaditems.put(led.Id,led.Lead_Product_Items__c);               
                    led.Lead_Product_Items__c =oldleaditems.get(led.Id)+ '\n' +wrper.vehiclebrand + '-' + wrper.vechmodel + '-' + wrper.vechquanty ;
                }else
                {
                    led.Lead_Product_Items__c = wrper.vehiclebrand + '-' + wrper.vechmodel + '-' + wrper.vechquanty ;
                }
                mapupdateleadllist.put(led.id,led);
            }
        }
        update mapupdateleadllist.values();

    }
}