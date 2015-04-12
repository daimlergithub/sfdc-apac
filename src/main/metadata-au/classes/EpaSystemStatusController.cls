public class EpaSystemStatusController
    extends BaseEpaController
{
    public class ServerStatus {
        public String Server {get;set;}
        public String Component {get;set;}
        public DateTime LastHeartBeatDate {get;set;}
        public String Status {get;set;}
    }

     public class EpaThread {
        public String Server {get;set;}
        public String Name {get;set;}
        public String TransactionId {get;set;}
        public String StartTime {get;set;}
        public String ThreadId {get;set;}
        public String Organization {get;set;}
        public String UseCase {get;set;}
        public String InterfaceName {get;set;}
        public String ThreadInfo {get;set;}
        public Long ElapsedTimeInMsecs {get;set;}
        public Long UsedCpuTimeInMsecs {get;set;}
        public Long UsedUserTimeInMsecs {get;set;}
        public Long UsedSystemTimeInMsecs {get;set;}
    }

    public class InterfaceCosts {
        public String InterfaceName;
        public String UseCase;
        public Integer NumRequests;
        public Integer UsedTime;
        public Integer UsedCpuTime;
        public Integer UsedUserTime;
        public Integer UsedSystemTime;
        public InterfaceCostDetail[] Details;
    }

    public class InterfaceCostDetail {
        public String InterfaceName;
        public String UseCase;
        public String DetailType;
        public Long NumberOfCalls;
        public Long UsedTime;
    }


    public List<String> versions {get; set;}
    public List<EpaSystemStatusController.ServerStatus> serverStatus {get; set;}
    public List<EpaSystemStatusController.EpaThread> threads {get; set;}
    public String threadId {get; set;}
    public EpaSystemStatusController.EpaThread selectedThread {get; set;}
    public List<String> deadLockInfo {get; set;}
    public DateTime transactionCostsStartTime {get; set;}
    public DateTime transactionCostsEndTime {get; set;}
    public List<EpaSystemStatusController.InterfaceCosts> transactionCosts {get; set;}

    public EpaSystemStatusController()
    {
        transactionCostsStartTime= DateTime.now().addHours(-1);
        transactionCostsEndTime = DateTime.now();
    }

    public PageReference showVersions()
    {
        versions = new List<String>();
        versions.add(getApplicationInfoWebservice().getEpaBaseVersion());
        versions.addAll(getApplicationInfoWebservice().getEpaApplicationVersion());
        return new PageReference('/apex/EPA_Show_Versions');
    }

    public PageReference showServerStatus()
    {
        serverStatus = getServerStatus(getApplicationInfoWebservice().getServerStatus());
        return new PageReference('/apex/EPA_Server_Status');
    }

    private List<EpaSystemStatusController.ServerStatus> getServerStatus(List<EpaApplicationInfoWebservice.ServerStatus> aEpaServerStatusList)
    {
        List<EpaSystemStatusController.ServerStatus> result = new List<EpaSystemStatusController.ServerStatus>();

        for (EpaApplicationInfoWebservice.ServerStatus epaServerStatus : aEpaServerStatusList) {
            result.add(getServerStatus(epaServerStatus));
        }

        return result;
    }

    private EpaSystemStatusController.ServerStatus getServerStatus(EpaApplicationInfoWebservice.ServerStatus aEpaServerStatus )
    {
        EpaSystemStatusController.ServerStatus status = new EpaSystemStatusController.ServerStatus();

        status.Server = aEpaServerStatus.Server;
        status.Component = aEpaServerStatus.Component;
        status.LastHeartBeatDate = aEpaServerStatus.LastHeartBeatDate;
        status.Status = aEpaServerStatus.Status;

        return status;
    }

    public PageReference showThreadList()
    {
        threads = getThreads(getThreadInfoWebservice().getCurrentThreads());
        return new PageReference('/apex/EPA_Thread_List');
    }

    private List<EpaSystemStatusController.EpaThread> getThreads(EpaThreadInfoWebService.EpaThreads aEpaThreads)
    {
        List<EpaSystemStatusController.EpaThread> result = new List<EpaSystemStatusController.EpaThread>();

        for (EpaThreadInfoWebService.EpaThread epaThread : aEpaThreads.EpaThreads) {
            EpaSystemStatusController.EpaThread singleResult = new EpaSystemStatusController.EpaThread();

            singleResult.Server = epaThread.Server;
            singleResult.Name = epaThread.Name ;
            singleResult.TransactionId = epaThread.TransactionId ;
            singleResult.StartTime = epaThread.StartTime ;
            singleResult.ThreadId = epaThread.ThreadId ;
            singleResult.Organization = epaThread.Organization ;
            singleResult.UseCase = epaThread.UseCase ;
            singleResult.InterfaceName = epaThread.InterfaceName ;
            singleResult.ThreadInfo = epaThread.ThreadInfo ;
            singleResult.ElapsedTimeInMsecs = epaThread.ElapsedTimeInMsecs ;
            singleResult.UsedCpuTimeInMsecs = epaThread.UsedCpuTimeInMsecs ;
            singleResult.UsedUserTimeInMsecs = epaThread.UsedUserTimeInMsecs ;
            singleResult.UsedSystemTimeInMsecs = epaThread.UsedSystemTimeInMsecs ;

            result.add(singleResult);
        }

        return result;
    }

    public PageReference showThreadDetails()
    {
        selectedThread = getThread(threads, threadId);
        return new PageReference('/apex/EPA_Thread_Details');
    }

    private EpaSystemStatusController.EpaThread getThread(List<EpaSystemStatusController.EpaThread> aThreadList, String aThreadId)
    {
        for (EpaSystemStatusController.EpaThread thread : aThreadList) {
            if (thread.ThreadId.equals(aThreadId)) {
                return thread;
            }
        }
        return null;
    }

    public PageReference showThreadDump()
    {
        threads = getThreads(getThreadInfoWebservice().getCurrentThreads());
        return new PageReference('/apex/EPA_Thread_Dump');
    }

    public PageReference showDeadLocks()
    {
        deadLockInfo = getThreadInfoWebservice().getDeadLockInfo();
        return new PageReference('/apex/EPA_Thread_Dead_Locks');
    }

    public PageReference showTransactionCosts()
    {
        EpaBusinessTransactionLogWebService.InterfaceCostsSearchCriteria searchCriteria = new EpaBusinessTransactionLogWebService.InterfaceCostsSearchCriteria();
        searchCriteria.FromCreatedDate = transactionCostsStartTime;
        searchCriteria.ToCreatedDate = transactionCostsEndTime;

        transactionCosts = getTransactionCosts(getBusinessTransactionLogWebservice().getInterfaceCosts(searchCriteria));

        return new PageReference('/apex/EPA_Transaction_Costs');
    }

    private List<EpaSystemStatusController.InterfaceCosts> getTransactionCosts(List<EpaBusinessTransactionLogWebService.InterfaceCosts> aInterfaceCostList)
    {
        List<EpaSystemStatusController.InterfaceCosts> result = new List<EpaSystemStatusController.InterfaceCosts>();

		    if (aInterfaceCostList != null) {
		        for (EpaBusinessTransactionLogWebService.InterfaceCosts interfaceCosts : aInterfaceCostList) {
		            EpaSystemStatusController.InterfaceCosts singleResult = new EpaSystemStatusController.InterfaceCosts();

		            singleResult.InterfaceName = interfaceCosts.InterfaceName;
		            singleResult.UseCase = interfaceCosts.UseCase;
		            singleResult.NumRequests = interfaceCosts.NumRequests;
		            singleResult.UsedTime = interfaceCosts.UsedTime;
		            singleResult.UsedCpuTime = interfaceCosts.UsedCpuTime;
		            singleResult.UsedUserTime = interfaceCosts.UsedUserTime;
		            singleResult.UsedSystemTime = interfaceCosts.UsedSystemTime;

		            singleResult.Details = new List<EpaSystemStatusController.InterfaceCostDetail>();

		            for (EpaBusinessTransactionLogWebService.InterfaceCostDetail detail : interfaceCosts.Details) {
		                EpaSystemStatusController.InterfaceCostDetail singleResultDetail = new EpaSystemStatusController.InterfaceCostDetail();

		                singleResultDetail.InterfaceName = detail.InterfaceName;
		                singleResultDetail.UseCase = detail.UseCase;
		                singleResultDetail.DetailType = detail.DetailType;
		                singleResultDetail.NumberOfCalls = detail.NumberOfCalls;
		                singleResultDetail.UsedTime = detail.UsedTime;

		                singleResult.Details.add(singleResultDetail );
		            }

		            result.add(singleResult);
		        }
		    }

        return result;
    }

    public EpaApplicationInfoWebService.ApplicationInfoPort getApplicationInfoWebservice()
    {
        EpaApplicationInfoWebService.ApplicationInfoPort service = new EpaApplicationInfoWebService.ApplicationInfoPort();
        service.endpoint_x = getAbsoluteEndpoint('/ApplicationInfo');
        service.inputHttpHeaders_x = getAuthorizationHeaders();
        return service;
    }

    public EpaThreadInfoWebService.ThreadInfoPort getThreadInfoWebservice()
    {
        EpaThreadInfoWebService.ThreadInfoPort service = new EpaThreadInfoWebService.ThreadInfoPort();
        service.endpoint_x = getAbsoluteEndpoint('/ThreadInfo');
        service.inputHttpHeaders_x = getAuthorizationHeaders();
        return service;
    }

    public EpaBusinessTransactionLogWebService.BusinessTransactionLogPort getBusinessTransactionLogWebservice()
    {
        EpaBusinessTransactionLogWebService.BusinessTransactionLogPort service = new EpaBusinessTransactionLogWebService.BusinessTransactionLogPort();
        service.endpoint_x = getAbsoluteEndpoint('/BusinessTransactionLog');
        service.inputHttpHeaders_x = getAuthorizationHeaders();
        return service;
    }
}