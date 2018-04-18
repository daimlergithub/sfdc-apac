/************************************************************************************
* Created By:Sarath M
* Created Date:15-Mar-18
* Modified Date:17-Apr-2018
* Company:Infosys Ltd
* Description:Batch class for Rank calculation based on the points/referrals count{to be scheduled every night} 
*********************************************************************************************/
global class BbqRankCalculation implements Schedulable,Database.Batchable<sObject>,Database.Stateful {
    //04172018 - added Market variable, custom setting variable and constructors; default constructor for SG for backward compatibility
    private String sMkt;
    List<BBQRankingMarkets__c> lstMarkets = BBQRankingMarkets__c.getAll().values();
    Integer MktSize = lstMarkets.size();
    Integer currMkt;
   public BbqRankCalculation(){
        if (lstMarkets != null && lstMarkets[0] != null){
            sMkt = lstMarkets[0].name;
            currMkt = 0;
        }
    }
    public BbqRankCalculation(String sMarket, Integer numMkt){
        sMkt= sMarket;
        currMkt = numMkt;
    }  
    global void execute(SchedulableContext sc) {
        //04172018 - added execute of batch for first entry of custom setting
        Integer currMktNum = 0;
        if (lstMarkets != null && lstMarkets[0] != null && lstMarkets[0].name != ''){
            BbqRankCalculation btchRank = new BbqRankCalculation(lstMarkets[0].name,currMktNum);
            Database.executeBatch(btchRank);
        }
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        //04172018 - commented original query and added query based on market
        if (sMkt == null || sMkt == '')
            return null;
        System.debug('+++++' + sMkt);
        System.debug('+++++' + currMkt);
        string query ='SELECT id,points__c from Employee__c where market__c = \'' + sMkt + '\' ORDER BY points__c DESC';
        return database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Employee__c> referralRankList){
        list<Employee__c> refList=new List<Employee__c>();
        Map<Decimal, Integer> refPointsMap =  new Map<Decimal, Integer>();
        Integer rankRef = 1;
        for(Employee__c ref: referralRankList){
            if (refPointsMap.size()>0 && refPointsMap.get(ref.points__c)!=null){
                ref.Rank__c = refPointsMap.get(ref.points__c);    
            }else{
                ref.Rank__c = rankRef; 
                rankRef++;                
            }
            refList.add(ref);
            refPointsMap.put(ref.points__c, integer.valueof(ref.Rank__c));                
        } 
        if(refList.size()>0){
            update refList;
        }
        
        //logic specific to Japan
        if (sMkt == 'JP'){
            //update no of referrals this quarter and rank for it
            list<period> periodList=[Select StartDate,EndDate From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER];
            Date dstartday = periodList[0].StartDate;      
            Date dendDay = periodList[0].EndDate;  
            list<Employee__c> empList1=new list<Employee__c>();
            Map<Decimal, Integer> refPointsMapJP =  new Map<Decimal, Integer>();
            Integer rankRefJP = 1;
            list<Employee__c> employeeList=[SELECT Id,No_of_referral__c,(select id from referral__r where CreatedDate>= :dstartday AND CreatedDate <= :dendDay) 
                                            FROM Employee__c 
                                            where market__c='JP'];
            
            for(Employee__c emp:employeeList){
                emp.No_of_referral__c=emp.referral__r.size();
            } 
            if(employeeList.size()>0)
                update employeeList;
            employeeList=[SELECT Id,ReferralsCreated__c,Email__c,Rank_of_Employee_with_referrals_made__c,No_of_referral__c
                          FROM Employee__c 
                          where market__c='JP' order by No_of_referral__c DESC];
            for(Employee__c emp:employeeList){
                
                if (refPointsMapJP.size()>0 && refPointsMapJP.get(emp.No_of_referral__c)!=null){
                    emp.Rank_of_Employee_with_referrals_made__c = refPointsMapJP.get(emp.No_of_referral__c);    
                }else{
                    emp.Rank_of_Employee_with_referrals_made__c = rankRefJP; 
                    rankRefJP++;                
                }
                empList1.add(emp);
                refPointsMapJP.put(emp.No_of_referral__c, integer.valueof(emp.Rank_of_Employee_with_referrals_made__c));                
            } 
            if(empList1.size()>0){
                update emplist1;
            } 
            //update no of referrals won this quarter and rank for it
            list<Employee__c> empList2=new list<Employee__c>();
            Map<Decimal, Integer> refPointsMapJP2 =  new Map<Decimal, Integer>();
            Integer rankRefJP2 = 1;
            list<Employee__c> employeeListJP=[SELECT Id,No_of_closed_Won__c,(select id,Last_Name__c from referral__r where Status__c='Won' AND (CreatedDate>= :dstartday AND CreatedDate <= :dendDay)) 
                                              FROM Employee__c 
                                              where market__c='JP'];
            
            for(Employee__c emp:employeeListJP){
                emp.No_of_closed_Won__c=emp.referral__r.size();
            } 
            if(employeeListJP.size()>0)
                update employeeListJP;
            employeeListJP=[SELECT Id,ReferralsWon__c,Email__c,Rank_of_Employee_with_closed_won__c,No_of_closed_Won__c
                            FROM Employee__c 
                            where market__c='JP' order by No_of_closed_Won__c DESC];
            for(Employee__c emp:employeeListJP){
                if (refPointsMapJP2.size()>0 && refPointsMapJP2.get(emp.No_of_closed_Won__c)!=null){
                    emp.Rank_of_Employee_with_closed_won__c = refPointsMapJP2.get(emp.No_of_closed_Won__c);    
                }else{
                    emp.Rank_of_Employee_with_closed_won__c = rankRefJP2; 
                    rankRefJP2++;                
                }            
                refPointsMapJP2.put(emp.No_of_closed_Won__c, integer.valueof(emp.Rank_of_Employee_with_closed_won__c));                
            } 
            if(employeeListJP.size()>0){
                update employeeListJP;
            } 
        }
        
    }    
    global void finish(Database.BatchableContext bc){
        //04172018 - loop and call batch for next market
        currMkt++;
        if (currMkt < MktSize){
            if (lstMarkets != null && lstMarkets[currMkt] != null){
                BbqRankCalculation newbtchRank = new BbqRankCalculation(lstMarkets[currMkt].name,currMkt);
                Database.executeBatch(newbtchRank);
            }
        }
    }
}