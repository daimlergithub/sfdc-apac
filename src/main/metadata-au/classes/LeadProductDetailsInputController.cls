public with sharing class LeadProductDetailsInputController
{   
    public List<wrappermultibrandclass> wrapperlist = new List<wrappermultibrandclass>();
    public set<string> carmodelset = new set<string>();
    Public list<Car_Model__c> carmodellist;
    Public list<string> carmodelstrng = new list<string>();
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
        wrapper.vechquanty = 'Mercedez Benz';
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
        carmodellist = [select model__c from Car_Model__c where vehicle_group__c = 'Van'];
        for(Car_Model__c card :carmodellist)
        {
            if(card.model__c != null && card.model__c != '')
            {
                carmodelset.add(card.model__c);
            }                        
        }
        system.debug('Car Model*****' + carmodellist.get(0).model__c);
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
        wrapper.vechquanty = 'Mercedez Benz';        
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