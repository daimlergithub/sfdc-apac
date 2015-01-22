public class EpaBusinessTransactionLogController
    extends BaseEpaController
{
    public Integer numTransactions  {get;set;}
    public String transactionId { get; set; }
    public String parentTransactionId { get; set; }
    public String requestId { get; set; }
    public String country { get; set; }
    public String useCase { get; set; }
    public String status { get; set; }
    public String externalId { get; set; }
    public String origin { get; set; }
    public String originDetail { get; set; }
    public String activeAt { get; set; }
    public Integer runningLongerThan  {get;set;}
    public String startDateFrom { get; set; }
    public String startDateTo { get; set; }
    public String endDateFrom { get; set; }
    public String endDateTo { get; set; }
    public String step { get; set; }
    public String stepDateFrom { get; set; }
    public String stepDateTo { get; set; }
    public String error { get; set; }
    public String errorDateFrom { get; set; }
    public String errorDateTo { get; set; }

    public List<SelectOption> countries { get; set; }
    public List<SelectOption> useCases { get; set; }
    public List<SelectOption> statusValues { get; set; }
    public List<SelectOption> messageOrigins { get; set; }

    public String sortOrder { get; set; }

    public List<SelectOption> sortOrders { get; set; }

    public List<String> transactionIds { get; set; }
    public List<BtlTransaction> transactions { get; set; }
    public Integer transactionsPageSize { get; set; }
    public Integer transactionsPageNumber { get; set; }
    public Integer transactionsNumPages { get; set; }

    public String selectedTransactionId {get; set;}
    public BtlTransaction selectedTransaction {get; set;}
    public List<BtlStep> stepsOfSelectedTransaction {get; set;}
    public List<String> stepIdsOfSelectedTransaction {get; set;}

    public String selectedStepId {get; set;}
    public BtlStep selectedStep {get; set;}
    public String selectedAddInfoId {get; set;}
    public BtlAdditionalInfo selectedAddInfo {get; set;}
    public String selectedErrorId {get; set;}
    public BtlError selectedError {get; set;}

    public String attachmentTitle {get; set;}
    public String attachment {get; set;}

    public List<BtlError> errors { get; set; }

    public EpaBusinessTransactionLogController ()
    {
        EpaApplicationInfoWebservice.ApplicationInfoPort port = getApplicationInfoWebservice();

        resetFilterFields();

        sortOrders = new List<SelectOption>();
        sortOrders.add(new SelectOption('TRNSCT_ID','Transaction ID'));
        sortOrders.add(new SelectOption('PARENT_TRNSCT_ID','Parent Transaction ID'));
        sortOrders.add(new SelectOption('START_DT','Start Date'));
        sortOrders.add(new SelectOption('END_DT','End Date'));

        countries = new List<SelectOption>();
        countries.add(new SelectOption('',''));
        for (String country : port.getOrganizations()) {
            countries.add(new SelectOption(country,country));
        }

        useCases = new List<SelectOption>();
        useCases.add(new SelectOption('',''));
        for (String useCase : port.getUseCases()) {
            useCases.add(new SelectOption(useCase,useCase));
        }
        useCases.sort();

        statusValues = new List<SelectOption>();
        statusValues.add(new SelectOption('',''));
        for (String statusValue : port.getStatusValues()) {
            statusValues.add(new SelectOption(statusValue,statusValue));
        }

        messageOrigins = new List<SelectOption>();
        messageOrigins.add(new SelectOption('',''));
        for (String messageOrigin : port.getMessageOrigins()) {
            messageOrigins.add(new SelectOption(messageOrigin,messageOrigin));
        }
        messageOrigins.sort();
    }

    public PageReference showTransactionList()
    {
        return new PageReference('/apex/EPA_BTL_Transaction_List');
    }

    public PageReference showErrors()
    {
        return new PageReference('/apex/EPA_BTL_Errors');
    }

    public PageReference loadTransactions()
    {
        EpaBusinessTransactionLogWebService.BusinessTransactionLogPort ws = getBusinessTransactionLogWebservice();
        transactionIds = ws.GetBusinessTransactionIds(buildTransactionSearchCriteria());
        transactionsPageNumber = 1;
        if (transactionsPageSize <= 0) {
            transactionsPageSize = 10;
        }
        if (transactionIds == null) {
            transactionIds = new List<String>();
        }
        transactionsNumPages = transactionIds.size() / transactionsPageSize + 1;
        transactions = mapTransactions(transactionIds, ws.GetBusinessTransactionsByIds(sublist(transactionIds, (transactionsPageNumber - 1) * transactionsPageSize, transactionsPageSize)));

        return null;
    }

    public PageReference loadNextTransactionsPage()
    {
        EpaBusinessTransactionLogWebService.BusinessTransactionLogPort ws = getBusinessTransactionLogWebservice();
        transactionsPageNumber = math.min(transactionsPageNumber + 1, transactionsNumPages);
        if (transactionsPageSize <= 0) {
            transactionsPageSize = 10;
        }
        transactions = mapTransactions(transactionIds, ws.GetBusinessTransactionsByIds(sublist(transactionIds, (transactionsPageNumber - 1) * transactionsPageSize, transactionsPageSize)));

        return null;
    }

    public boolean getHasNextTransactionsPage()
    {
        return transactionsPageNumber < transactionsNumPages;
    }

    public PageReference loadPreviousTransactionsPage()
    {
        EpaBusinessTransactionLogWebService.BusinessTransactionLogPort ws = getBusinessTransactionLogWebservice();
        transactionsPageNumber = math.max(transactionsPageNumber - 1, 1);
        if (transactionsPageSize <= 0) {
            transactionsPageSize = 10;
        }
        transactions = mapTransactions(transactionIds, ws.GetBusinessTransactionsByIds(sublist(transactionIds, (transactionsPageNumber - 1) * transactionsPageSize, transactionsPageSize)));

        return null;
    }

    public boolean getHasPreviousTransactionsPage()
    {
        return transactionsPageNumber > 1;
    }

    public PageReference loadFirstTransactionsPage()
    {
        EpaBusinessTransactionLogWebService.BusinessTransactionLogPort ws = getBusinessTransactionLogWebservice();
        transactionsPageNumber = 1;
        if (transactionsPageSize <= 0) {
            transactionsPageSize = 10;
        }
        transactions = mapTransactions(transactionIds, ws.GetBusinessTransactionsByIds(sublist(transactionIds, (transactionsPageNumber - 1) * transactionsPageSize, transactionsPageSize)));

        return null;
    }
    public PageReference loadLastTransactionsPage()
    {
        EpaBusinessTransactionLogWebService.BusinessTransactionLogPort ws = getBusinessTransactionLogWebservice();
        transactionsPageNumber = transactionsNumPages;
        if (transactionsPageSize <= 0) {
            transactionsPageSize = 10;
        }
        transactions = mapTransactions(transactionIds, ws.GetBusinessTransactionsByIds(sublist(transactionIds, (transactionsPageNumber - 1) * transactionsPageSize, transactionsPageSize)));

        return null;
    }

    public boolean getHasMultipleTransactionsPages()
    {
        return transactionsNumPages > 1;
    }

    public PageReference resetFilter()
    {
        resetFilterFields();

        return loadTransactions();
    }

    public void resetFilterFields()
    {
        numTransactions = 10000;
        transactionId = '';
        parentTransactionId = '';
        requestId = '';
        country = '';
        useCase = '';
        status = '';
        externalId = '';
        origin = '';
        originDetail = '';
        activeAt = '';
        runningLongerThan = null;
        startDateFrom = '';
        startDateTo = '';
        endDateFrom = '';
        endDateTo = '';
        step = '';
        stepDateFrom  = '';
        stepDateTo = '';
        error = '';
        errorDateFrom = '';
        errorDateTo = '';

        sortOrder = 'START_DT';
        transactionsPageSize = 10;
        transactionsPageNumber = 1;
        transactionsNumPages = 0;
    }

    public PageReference prepareReload()
    {
    	  List<String> requestIdList = new List<String>();

    	  for (BtlTransaction trnsct : transactions) {
    	  	  if (trnsct.Selected) {
    	  	  	  requestIdList.add(trnsct.RequestId);
    	  	  }
    	  }

    	  if (requestIdList != null && requestIdList.size() > 0) {
            getBusinessTransactionLogWebservice().PrepareRequestReload(requestIdList);
    	  }

        return null;
    }

    public PageReference showSrcObjectExt()
    {
        setSelectedTransaction();

        if (selectedTransaction != null) {
            attachment = selectedTransaction.SrcObjectExt;
        }
        else {
            attachment = '<not available>';
        }

        attachmentTitle = 'Transaction ' + selectedTransactionId + ' - External Request';
        return new PageReference('/apex/EPA_BTL_Attachment');
    }

    public PageReference showSrcObjectInt()
    {
        setSelectedTransaction();

        if (selectedTransaction != null) {
            attachment = selectedTransaction.SrcObjectInt;
        }
        else {
            attachment = '<not available>';
        }

        attachmentTitle = 'Transaction ' + selectedTransactionId + ' - Internal Data';
        return new PageReference('/apex/EPA_BTL_Attachment');
    }

    public PageReference showResponse()
    {
        setSelectedTransaction();

        if (selectedTransaction != null) {
            attachment = selectedTransaction.Response;
        }
        else {
            attachment = '<not available>';
        }

        attachmentTitle = 'Transaction ' + selectedTransactionId + ' - Response';
        return new PageReference('/apex/EPA_BTL_Attachment');
    }

    public PageReference showStepAdditionalInfo()
    {
        attachment = '<not available>';

        attachmentTitle = 'Transaction ' + selectedTransactionId + ' - Additional Step Information ';
        if (stepsOfSelectedTransaction != null && selectedStepId != null && selectedAddInfoId != null) {
            for (BtlStep step : stepsOfSelectedTransaction) {
               if (selectedStepId.equals(step.Id)) {
               	  selectedStep = step;
               	  for (BtlAdditionalInfo addInfo : step.AdditionalInformation) {
               	  	  if (selectedAddInfoId.equals(addInfo.Id)) {
                          selectedAddInfo = mapAdditionalInfo(getBusinessTransactionLogWebservice().GetAdditionalInfosById(new List<String> {selectedAddInfoId}).get(0));
                          attachment = selectedAddInfo.AdditionalInformation;
                          attachmentTitle = 'Transaction ' + selectedTransactionId + ' - Additional Step Information of type ' + addInfo.Type_x + ' for step ' + step.StepName;
               	  	  }
               	  }
               	  break;
               }
            }
        }

        return new PageReference('/apex/EPA_BTL_Attachment');
    }

    public PageReference showErrorMessage()
    {
        attachment = '<not available>';
        attachmentTitle = 'Transaction ' + selectedTransactionId + ' - Error Message';
        if (stepsOfSelectedTransaction != null && selectedStepId != null && selectedErrorId != null) {
            for (BtlStep step : stepsOfSelectedTransaction) {
               if (selectedStepId.equals(step.Id)) {
                  selectedStep = step;
                  for (BtlError error : step.Errors) {
                      if (selectedErrorId.equals(error.Id)) {
                          selectedError = error;
                          attachment = error.Message;
                          attachmentTitle = 'Transaction ' + selectedTransactionId + ' - Error Message for Error ' + error.ErrorCode;
                      }
                  }
                  break;
               }
            }
        }

        return new PageReference('/apex/EPA_BTL_Attachment');
    }

    public PageReference showErrorAdditionalInfo()
    {
        attachment = '<not available>';
        attachmentTitle = 'Transaction ' + selectedTransactionId + ' - Additional Error Information';
        if (stepsOfSelectedTransaction != null && selectedStepId != null && selectedErrorId != null && selectedAddInfoId != null) {
            for (BtlStep step : stepsOfSelectedTransaction) {
               if (selectedStepId.equals(step.Id)) {
               	  selectedStep = step;
                  for (BtlError error : step.Errors) {
                      if (selectedErrorId.equals(error.Id)) {
                      	  selectedError = error;
                          for (BtlAdditionalInfo addInfo : error.AdditionalInformation) {
                              if (selectedAddInfoId.equals(addInfo.Id)) {
                                  selectedAddInfo = mapAdditionalInfo(getBusinessTransactionLogWebservice().GetAdditionalInfosById(new List<String> {selectedAddInfoId}).get(0));
				                          attachment = selectedAddInfo.AdditionalInformation;
                                  attachmentTitle = 'Transaction ' + selectedTransactionId + ' - Additional Error Information of type ' + addInfo.Type_x + ' for error ' + error.ErrorCode;
                              }
                          }
                      }
                  }
                  break;
               }
            }
        }

        return new PageReference('/apex/EPA_BTL_Attachment');
    }

    public PageReference showAttachment()
    {
        attachmentTitle = 'BTL attachment';
        return new PageReference('/apex/EPA_BTL_Attachment');
    }

    public PageReference showTransaction()
    {
        EpaBusinessTransactionLogWebService.BusinessTransactionLogPort ws = getBusinessTransactionLogWebservice();

        setSelectedTransaction();

        if (selectedTransaction != null) {
            stepIdsOfSelectedTransaction = getStepIds(ws.GetStepIdsByTransactionId(selectedTransactionId));
            stepsOfSelectedTransaction = mapTransactionSteps(ws.GetStepsById(stepIdsOfSelectedTransaction));
        }

        transactionsPageNumber = 1;

        return new PageReference('/apex/EPA_BTL_Transaction');
    }

    public PageReference loadErrors()
    {
        EpaBusinessTransactionLogWebService.BusinessTransactionLogPort ws = getBusinessTransactionLogWebservice();
        errors = mapErrors(ws.getErrors(buildTransactionSearchCriteria()));

        return null;
    }

    private void setSelectedTransaction()
    {
    	  selectedTransaction = null;

        if (transactions != null && selectedTransactionId != null) {
            for (BtlTransaction trnsct : transactions) {
                if (selectedTransactionId.equals(trnsct.TrnsctId)) {
                    selectedTransaction = trnsct;
                    break;
                }
            }
        }

        if (selectedTransaction == null && selectedTransactionId != null) {
            List<BtlTransaction> trnscts = mapTransactions(new List<String> {selectedTransactionId}, getBusinessTransactionLogWebservice().GetBusinessTransactionsByIds(new List<String> {selectedTransactionId}));
            System.Debug('GetBusinessTransactionsByIds ' + new List<String> {selectedTransactionId} + ' returned ' + trnscts);

            if (trnscts != null && trnscts.size() > 0) {
            	  selectedTransaction = trnscts.get(0);
            }
        }
    }

    private EpaBusinessTransactionLogWebService.BtlTransactionSearchCriteria buildTransactionSearchCriteria()
    {
        EpaBusinessTransactionLogWebService.BtlTransactionSearchCriteria result = new EpaBusinessTransactionLogWebService.BtlTransactionSearchCriteria();

        if (numTransactions > 0) {
            result.NumberOfTransactionsToExamine = numTransactions;
        }
        if (transactionId != null && transactionId.trim().length() > 0) {
            result.TrnsctId = transactionId;
        }
        if (parentTransactionId != null && parentTransactionId.trim().length() > 0) {
            result.ParentTrnsctId = parentTransactionId;
        }
        if (requestId != null && requestId.trim().length() > 0) {
            result.RequestId = requestId;
        }
        if (country != null && country.trim().length() > 0) {
            result.Organization = country;
        }
        if (useCase != null && useCase.trim().length() > 0) {
            result.UseCase = useCase;
        }
        if (status != null && status.trim().length() > 0) {
            result.Status = status;
        }
        if (externalId != null && externalId.trim().length() > 0) {
            result.UniqueExternalId = externalId;
        }
        if (origin != null && origin.trim().length() > 0) {
            result.Origin = origin;
        }
        if (originDetail != null && originDetail.trim().length() > 0) {
            result.OriginDetail = originDetail;
        }
        if (activeAt != null && activeAt.trim().length() > 0) {
            try {
                result.ActiveAt = DateTime.valueOf(activeAt);
            }
            catch (System.TypeException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ActiveAt contains invalid Date/Time value - ' + e));
            }
        }
        if (runningLongerThan > 0) {
            result.MinRuntime = runningLongerThan;
        }
        if (startDateFrom != null && startDateFrom.trim().length() > 0) {
            try {
                result.FromStartDate = DateTime.valueOf(startDateFrom);
            }
            catch (System.TypeException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'StartDateFrom contains invalid Date/Time value - ' + e));
            }
        }
        if (startDateTo != null && startDateTo.trim().length() > 0) {
            try {
                result.ToStartDate = DateTime.valueOf(startDateTo);
            }
            catch (System.TypeException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'StartDateTo contains invalid Date/Time value - ' + e));
            }
        }
        if (endDateFrom != null && endDateFrom.trim().length() > 0) {
            try {
                result.FromEndDate = DateTime.valueOf(endDateFrom);
            }
            catch (System.TypeException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'EndDateFrom contains invalid Date/Time value - ' + e));
            }
        }
        if (endDateTo != null && endDateTo.trim().length() > 0) {
            try {
                result.ToEndDate = DateTime.valueOf(endDateTo);
            }
            catch (System.TypeException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'EndDateTo contains invalid Date/Time value - ' + e));
            }
        }
        if (step != null && step.trim().length() > 0) {
            result.Step = step;
        }
        if (stepDateFrom != null && stepDateFrom.trim().length() > 0) {
            try {
                result.FromStepDate = DateTime.valueOf(stepDateFrom);
            }
            catch (System.TypeException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'StepDateFrom contains invalid Date/Time value - ' + e));
            }
        }
        if (stepDateTo != null && stepDateTo.trim().length() > 0) {
            try {
                result.ToStepDate = DateTime.valueOf(stepDateTo);
            }
            catch (System.TypeException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'StepDateTo contains invalid Date/Time value - ' + e));
            }
        }
        if (error != null && error.trim().length() > 0) {
            result.Error = error;
        }
        if (errorDateFrom != null && errorDateFrom.trim().length() > 0) {
            try {
                result.FromErrorDate = DateTime.valueOf(errorDateFrom);
            }
            catch (System.TypeException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ErrorDateFrom contains invalid Date/Time value - ' + e));
            }
        }
        if (errorDateTo != null && errorDateTo.trim().length() > 0) {
            try {
                result.ToErrorDate = DateTime.valueOf(errorDateTo);
            }
            catch (System.TypeException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ErrorDateTo contains invalid Date/Time value - ' + e));
            }
        }

        if (sortOrder != null && sortOrder.trim().length() > 0) {
            result.Order = sortOrder;
        }

        return result;
    }

    private List<BtlTransaction> mapTransactions(List<String> aTransactionIdList, EpaBusinessTransactionLogWebService.BtlTransaction[] aRemoteTransactionsList)
    {
        List<BtlTransaction> result = new List<BtlTransaction>();

        if (aTransactionIdList != null) {
            for (String transactionId : aTransactionIdList) {
                EpaBusinessTransactionLogWebService.BtlTransaction remoteTransaction = getRemoteTransaction(aRemoteTransactionsList, transactionId);

                if (remoteTransaction != null) {
                    result.add(mapTransaction(remoteTransaction));
                }
            }
        }

        return result;
    }

    private EpaBusinessTransactionLogWebService.BtlTransaction getRemoteTransaction(EpaBusinessTransactionLogWebService.BtlTransaction[] aRemoteTransactionsList, String aTransactionId)
    {
        for (EpaBusinessTransactionLogWebService.BtlTransaction remoteTransaction : aRemoteTransactionsList) {
            if (aTransactionId.equals(remoteTransaction.TrnsctId)) {
                return remoteTransaction;
            }
        }
        return null;
    }

    private BtlTransaction mapTransaction(EpaBusinessTransactionLogWebService.BtlTransaction aRemoteTransaction)
    {
        BtlTransaction result = new BtlTransaction();

        result.TrnsctId = aRemoteTransaction.TrnsctId;
        result.ParentTrnsctId = aRemoteTransaction.ParentTrnsctId;
        result.RequestId = aRemoteTransaction.RequestId;
        result.Organization = aRemoteTransaction.Organization;
        result.UseCase = aRemoteTransaction.UseCase;
        result.InterfaceName = aRemoteTransaction.InterfaceName;
        result.Status = aRemoteTransaction.Status;
        result.UniqueExternalId = aRemoteTransaction.UniqueExternalId;
        result.Origin = aRemoteTransaction.Origin;
        result.OriginDetails = aRemoteTransaction.OriginDetails;
        result.InputChannel = aRemoteTransaction.InputChannel;
        result.StartDt = aRemoteTransaction.StartDt;
        result.ProcessingStartDt = aRemoteTransaction.ProcessingStartDt;
        result.EndDt = aRemoteTransaction.EndDt;
        result.Duration = aRemoteTransaction.Duration;
        result.UsedCpuTime = aRemoteTransaction.UsedCpuTime;
        result.UsedUserTime = aRemoteTransaction.UsedUserTime;
        result.UsedSystemTime = aRemoteTransaction.UsedSystemTime;
        result.Reloadable = aRemoteTransaction.Reloadable;
        result.SrcObjectInt = aRemoteTransaction.SrcObjectInt;
        result.SrcObjectExt = aRemoteTransaction.SrcObjectExt;
        result.Response = aRemoteTransaction.Response;
        result.Server = aRemoteTransaction.Server;
        result.EpaVersion = aRemoteTransaction.EpaVersion;
        result.EpaRevision = aRemoteTransaction.EpaRevision;
        result.EpaBuild = aRemoteTransaction.EpaBuild;
        result.Environment = aRemoteTransaction.Environment;

        return result;
    }

    private List<String> getStepIds(List<EpaBusinessTransactionLogWebService.BtlStepReferenceWto> aRemoteStepIdsList)
    {
        List<String> result = new List<String>();

        if (aRemoteStepIdsList != null) {
            for (EpaBusinessTransactionLogWebService.BtlStepReferenceWto remoteStepId : aRemoteStepIdsList) {
                result.add(remoteStepId.TrnsctStepId);
            }
        }

        return result;
    }

    private List<BtlStep> mapTransactionSteps(List<EpaBusinessTransactionLogWebService.BtlStepWto> aRemoteStepsList)
    {
        List<BtlStep> result = new List<BtlStep>();

        if (aRemoteStepsList != null) {
            for (EpaBusinessTransactionLogWebService.BtlStepWto remoteStep : aRemoteStepsList) {
                result.add(mapTransactionStep(remoteStep));
            }
        }

        return result;
    }

    private BtlStep mapTransactionStep(EpaBusinessTransactionLogWebService.BtlStepWto aRemoteStep)
    {
        BtlStep result = new BtlStep();

        result.Id = aRemoteStep.Id;
        result.ParentStepId = aRemoteStep.ParentStepId;
        result.StepName = aRemoteStep.StepName;
        result.StartDt = aRemoteStep.StartDt;
        result.EndDt = aRemoteStep.EndDt;
        result.Duration = aRemoteStep.Duration;
        result.UsedCpuTime = aRemoteStep.UsedCpuTime;
        result.UsedUserTime = aRemoteStep.UsedUserTime;
        result.UsedSystemTime = aRemoteStep.UsedSystemTime;
        result.StepAdditionalInfo = aRemoteStep.StepAdditionalInfo;
        result.Depth = aRemoteStep.Depth;
        result.Server = aRemoteStep.Server;
        result.Indent = '';
        for (Integer i = 0; i < result.Depth; i++) {
            result.Indent += '..';
        }

        result.AdditionalInformation = new List<BtlAdditionalInfo>();
        if (aRemoteStep.AdditionalInformation != null) {
            for (EpaBusinessTransactionLogWebService.BtlAdditionalInfoWto remoteAddInfo : aRemoteStep.AdditionalInformation) {
                result.AdditionalInformation.add(mapAdditionalInfo(remoteAddInfo));
            }
        }

        result.Errors = mapErrors(aRemoteStep.Error);

        return result;
    }

    private BtlAdditionalInfo mapAdditionalInfo(EpaBusinessTransactionLogWebService.BtlAdditionalInfoWto aRemoteAddInfo)
    {
        BtlAdditionalInfo additionalInfo = new BtlAdditionalInfo();

        additionalInfo.Id = aRemoteAddInfo.Id;
        additionalInfo.Type_x = aRemoteAddInfo.Type_x;
        additionalInfo.AdditionalInformation = aRemoteAddInfo.AdditionalInformation;
        additionalInfo.Count = aRemoteAddInfo.Count;

    	  return additionalInfo;
    }

    private List<BtlError> mapErrors(List<EpaBusinessTransactionLogWebService.BtlError> aErrorList)
    {
        List<BtlError> result = new List<BtlError>();

        if (aErrorList != null) {
		        for (EpaBusinessTransactionLogWebService.BtlError error : aErrorList) {
		        	  result.add(mapError(error));
		        }
        }

        return result;
    }

    private BtlError mapError(EpaBusinessTransactionLogWebService.BtlError aError)
    {
        BtlError result = new BtlError();

        result.Id = aError.Id;
        result.Organization = aError.Organization;
        result.UseCase = aError.UseCase;
        result.UniqueExternalId = aError.UniqueExternalId;
        result.Origin = aError.Origin;
        result.OriginDetails = aError.OriginDetails;
        result.TrnsctId = aError.TrnsctId;
        result.ParentTrnsctId = aError.ParentTrnsctId;
        result.StartDt = aError.StartDt;
        result.EndDt = aError.EndDt;
        result.Status = aError.Status;
        result.Step = aError.Step;
        result.Error = aError.Error;
        result.ErrorCode = aError.ErrorCode;
        result.ErrorSeverity = aError.ErrorSeverity;
        result.Message = aError.Message;
        result.ProblemSolver = aError.ProblemSolver;
        result.ErrorType = aError.ErrorType;

        result.AdditionalInformation = new List<BtlAdditionalInfo>();
        if (aError.AdditionalInformation != null) {
            for (EpaBusinessTransactionLogWebService.BtlAdditionalInfoWto remoteAddInfo : aError.AdditionalInformation) {
                BtlAdditionalInfo additionalInfo = new BtlAdditionalInfo();

                additionalInfo.Id = remoteAddInfo.Id;
                additionalInfo.Type_x = remoteAddInfo.Type_x;
                additionalInfo.AdditionalInformation = remoteAddInfo.AdditionalInformation;
                additionalInfo.Count = remoteAddInfo.Count;

                result.AdditionalInformation.add(additionalInfo);
            }
        }

        return result;
    }

    public List<String> sublist(List<String> aList, Integer aOffset, Integer aLength)
    {
        List<String> result = new List<String>();

        if (aList != null) {
            for (Integer i = aOffset; i < math.min(aList.size(), aOffset + aLength); i++) {
                result.add(aList.get(i));
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

    public EpaBusinessTransactionLogWebService.BusinessTransactionLogPort getBusinessTransactionLogWebservice()
    {
        EpaBusinessTransactionLogWebService.BusinessTransactionLogPort service = new EpaBusinessTransactionLogWebService.BusinessTransactionLogPort();
        service.endpoint_x = getAbsoluteEndpoint('/BusinessTransactionLog');
        service.inputHttpHeaders_x = getAuthorizationHeaders();
        return service;
    }
}