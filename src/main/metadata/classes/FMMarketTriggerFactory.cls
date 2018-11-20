/* Author: Tejbir Singh
 * Created date: 11th Oct 2018
 * Description: It will find Market specific handler from custom metadata FMMarketTrigger__mdt using Object Name and market and will call its method.*/
public class FMMarketTriggerFactory {
    private static FMTriggerHandlerIf getClassInstance(String sObjectName,String sMarket)
    {
        if(sMarket==null || sMarket=='' || sObjectName==null || sObjectName=='')
            return null;
        
        List<FMMarketTrigger__mdt> lstMktTrig=[select className__c from FMMarketTrigger__mdt where sObject__c=:sObjectName and Market__c=:sMarket];
        System.debug('++++++++++'+lstMktTrig);
        if(lstMktTrig!=null && lstMktTrig.size()>0)
        {
            String clsName=lstMktTrig[0].className__c;
            System.debug('++++++++++'+clsName);
            try{
                Type clsType=Type.forName(clsName);
                FMTriggerHandlerIf oCls=(FMTriggerHandlerIf)clsType.newInstance();
                return oCls;
            }
            catch(Exception e)
            {
                System.debug('No Market Specific handler exist');
                return null;
            }
        }else
        {
            System.debug('No Market Specific handler exist');
            return null;
        }
    }
    
    public static void run(String sObjectName, String sMarket, boolean isInsert, boolean isUpdate, boolean isBefore, boolean isAfter, boolean isDelete)
    {
        FMTriggerHandlerIf oCls=getClassInstance(sObjectName,sMarket);
        
        if(oCls!=null)
        {
            if(isBefore && isInsert){
                oCls.beforeInsert();
            }else if(isBefore && isUpdate)
            {
                oCls.beforeUpdate();
            }else if(isAfter && isUpdate)
            {
                oCls.afterUpdate();
            }else if(isAfter && isInsert)
            {
                oCls.afterInsert();
            }else if(isAfter && isDelete)
            {
                oCls.afterDelete();
            }
                
        }
    }

}