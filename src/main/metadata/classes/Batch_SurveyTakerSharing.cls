global class Batch_SurveyTakerSharing implements Database.Batchable<sObject> ,Database.stateful{
    global string query;
    global string mainName='';
    global set<string> unproperSharingList = new set<string>();
    global list<string> unproperSharingListids = new list<string>();
    global integer size=0;
    global string md='JP';
    global Batch_SurveyTakerSharing(){
        //this.query = query;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,lead__c from surveytaker__c where lead__c != null and MD__C =' +'\'JP\'');
    }
    global void execute(Database.BatchableContext BC, List<surveytaker__c> scope){
    
        set<string> unproperSharingList = new set<string>();
        set<id>surveytakenIds = new set<id>();
        set<id>leadIds = new set<id>();
        Map<id,list<id>> Surveytakeridsmap= new Map<id,list<id>>();
        Map<id,list<id>> Leadshareidsmap = new Map<id,list<id>>();
        Map<id,list<string>> Leadsharereasonsmap= new Map<id,list<string>>();
        for(surveytaker__c sc:scope){
            surveytakenIds.add(sc.id);
            leadIds.add(sc.lead__c);
        }
        list<surveytaker__share>stslist=[Select id,parentid,userorgroupid,rowcause from SurveyTaker__share where parentid IN :surveytakenIds  ];
        list<lead__share>leadsharelist=[Select id,parentid,userorgroupid,rowcause from lead__share where parentid IN : leadIds];
        System.debug('stssize>>>>'+stslist.size());
        System.debug('leadsssize>>>>'+leadsharelist.size());
        for(surveytaker__share st:stslist){
            if(!Surveytakeridsmap.containsKey(st.parentid)){
                Surveytakeridsmap.put(st.parentid, new List<Id>());
            }
            Surveytakeridsmap.get(st.parentid).add(st.userorgroupid);
        }
        
        for(lead__share lead:leadsharelist){
            if(!Leadshareidsmap.containsKey(lead.parentid)){
                Leadshareidsmap.put(lead.parentid, new List<Id>());
                Leadsharereasonsmap.put(lead.parentid, new List<string>());
            }
            Leadshareidsmap.get(lead.parentid).add(lead.userorgroupid);
            Leadsharereasonsmap.get(lead.parentid).add(lead.rowcause);
        }
        
        for(surveytaker__c s:scope)
        {
            System.debug('rowcause1'+Leadshareidsmap.get(s.lead__c).size());
            System.debug('rowcause1'+Leadsharereasonsmap.get(s.lead__c).size());
            for(integer i=0 ; i < Leadshareidsmap.get(s.lead__c).size();i++)
            {
                
                if(Leadsharereasonsmap.get(s.lead__c)[i] != 'owner' && Leadsharereasonsmap.get(s.lead__c)[i] != 'rule')
                {
                    List<string>gids=new List<string>();
                    gids=Surveytakeridsmap.get(s.id);
                    System.debug('gids>>>'+gids);
                    System.debug('gids55555>>>'+Leadshareidsmap.get(s.lead__c)[i]);
                    if(gids.contains(Leadshareidsmap.get(s.lead__c)[i])){
                        System.debug('insertion>>>>>');
                        continue ;
                    }
                    else{
                            System.debug('insertionelse>>>>>');
                            unproperSharingList.add(s.id);
                        }                       
                }
            }
           
        } 
              List<string> unprop = new list<string>(unproperSharingList);
              System.debug('unproperidsize>>>'+unprop);
              size = size+unprop.size(); 
              unproperSharingListids.addAll(unprop);
    
    }     
   
    global void finish(Database.BatchableContext BC){
       System.debug('wholesize>>>>'+size);
       System.debug('listids'+unproperSharingListids);
         // List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
      for(string campMail : unproperSharingListids){
          mainName = mainName+campMail+',';
       }
           String emailBodyStr = '';
           String sendingTo ='namburinagavenkata.suryavarma@nttdata.com';
           string[] to = new string[] {sendingTo};
           emailBodyStr = emailBodyStr + 'Size is '+ size;
           emailBodyStr = emailBodyStr + 'Survey taken Ids  is '+ mainName;
           System.debug('---emailBodyStr ----'+emailBodyStr);
           Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
           msg.setToAddresses(to);
           msg.SetsaveAsActivity(false);
           msg.subject = 'Survey TakerIds';
           msg.setHTMLBody(emailBodyStr);
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] {msg}); 

    }
}