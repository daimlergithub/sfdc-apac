public without sharing class updateCaseDeadLine{

    @Future(callout=true)
    public static void caseDeadLinesetter(String caseStr){
         List<Id> casenewLst =(List<Id>)JSON.deserialize(caseStr,List<Id>.class);
         system.debug('PSM CASE IDS '+casenewLst);
         List<Case> caseupdLst = new List<case>();
         List<BusinessHours> bHrs = [SELECT Id FROM BusinessHours WHERE Id =:  Label.korea_Business_Hours_Id];
          List<Holiday> holidaysLst =  BusinessHrHolidaysRetriever.retrieveHolidays(bHrs[0]);
          List<Date> dateLst = new List<Date>();
          for(Holiday hol: holidaysLst){
              dateLst.add(hol.ActivityDate);
          }
          
          
          List<Date> weekEnddateLst = BusinessHrHolidaysRetriever.weekendDatesLst(system.Today(), system.today()+35);
          set<Date> dateSet = new set<Date>();
          dateSet.addAll(dateLst);
          dateSet.addAll(weekEnddateLst);
          for (Case c : [select id, Priority, DeadLine__c, MD__c from case where id in:casenewLst]){ 
            if ((c.Priority == 'A' || c.Priority =='Red >= 4') && c.MD__c == 'KR'){
                c.DeadLine__c=checkForHolidays(dateSet, system.today() + 1);         
             }
           if ((c.Priority == 'B' || c.Priority =='Yellow = 3') && c.MD__c == 'KR'){
               c.DeadLine__c= checkForHolidays(dateSet, system.today() + 3); 
            }
           if ((c.Priority == 'C' || c.Priority =='Green <= 2') && c.MD__c == 'KR'){
               c.DeadLine__c= checkForHolidays(dateSet, system.today() + 10);           
            }
            caseupdLst.add(c); 
          }
          
          if(caseupdLst.size()>0){
              TriggerCaseTriggerHandlerKR.isFutureUpdate = true;
              update caseupdLst;
              
          }  
    
    }
    
    public static Date checkForHolidays(set<Date> holidaySet, Date dateToBeChecked){
           Date dateVar = dateToBeChecked;
           do{
               dateVar += 1;
           }while(holidaySet.contains(dateVar));
           return dateVar;
       }

}