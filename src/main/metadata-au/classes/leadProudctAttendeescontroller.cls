public with sharing class leadProudctAttendeescontroller 
{
    public Lead_Product__c ledprdt;
    public map<id,string> oldleaditems = new map<id,string>();
    public map<id,Lead_Product__c> mapupdateleadllist = new map<id,Lead_Product__c>();
    public List<wrapperattendeesclass> wrapperlist = new List<wrapperattendeesclass>();
    public List<wrapperattendeesclass> wrapperattendees{get{return wrapperlist;}set{wrapperlist=value;}}
   
    public leadProudctAttendeescontroller(ApexPages.StandardController controller)
    {                
        wrapperattendeesclass wrapper = new wrapperattendeesclass();
        wrapper.ledprdt = new Account();
       // Lead_Product__c ledprdt= new Lead_Product__c();
        Lead_Product__c leadprod=new Lead_Product__c();

        wrapper.ledprdt.ownerid =null;
        wrapper.attendees = '';
        wrapperlist.add(wrapper);
        //addrow();     

    }
    public class wrapperattendeesclass
    {
        
      
        //public Lead_Product__c  ledprdt{get; set;}
        public Account ledprdt{get; set;}
        public string attendees{get; set;}
    }
    
    public void addrow()
    {
        system.debug('WrapperList Size >>>>'+wrapperlist);
        //Lead_Product__c ledprdt2=   
       // ledprdt=new Lead_Product__c();       
        wrapperattendeesclass wrapper = new wrapperattendeesclass();
        wrapper.ledprdt=new Account();
        wrapper.ledprdt.OwnerId = null;
        wrapper.attendees = '';
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
    list<Lead_Product__c> leadllist=[select id,Lead_Product_Items__c from Lead_Product__c where id=:ApexPages.currentPage().getParameters().get('id')];
    system.debug('%updatelleadllisteadllist^$%$%$%$'+leadllist);
        String commaSepratedList='';
        string regexForNullValue ='null';
        string nullValue ='';
        set<id> useridset = new set<id>();
        for(wrapperattendeesclass wrper:wrapperlist)
        { 
            useridset.add(wrper.ledprdt.Ownerid);
        }
        map<id,user> usermap = new map<id,user>([select id, name from user where id in: useridset]);
        for(wrapperattendeesclass wrper:wrapperlist)
        {                    
            for(Lead_Product__c led:leadllist )
            {
                system.debug('wrper.ledprdt.Owner.Name----'+wrper+'---Name--'+wrper.ledprdt.Owner.Name);
                if(wrper.ledprdt.ownerid != null){
                commaSepratedList +=usermap.get(wrper.ledprdt.Ownerid).name+ ',' + wrper.attendees ;
                if(led.Lead_Product_Items__c != null && wrper.ledprdt.ownerid != null)                
                {
                    oldleaditems.put(led.Id,led.Lead_Product_Items__c);                    
                    led.Lead_Product_Items__c =oldleaditems.get(led.Id)+ '\n' ;
                    if(usermap.containskey(wrper.ledprdt.Ownerid)){
                    
                    led.Lead_Product_Items__c+= usermap.get(wrper.ledprdt.Ownerid).name;
                    }led.Lead_Product_Items__c+= ',' + wrper.attendees; 
                }
                else if(led.Lead_Product_Items__c == null || led.Lead_Product_Items__c == '')
                {
                    led.Lead_Product_Items__c = commaSepratedList;
                }
                led.Lead_Product_Items__c = led.Lead_Product_Items__c.replaceAll(regexForNullValue,nullValue);
                mapupdateleadllist.put(led.id,led);
                }
            }
        }
        update mapupdateleadllist.values();
        system.debug('%^$%$%$%$'+commaSepratedList);
    } 
    
   
}