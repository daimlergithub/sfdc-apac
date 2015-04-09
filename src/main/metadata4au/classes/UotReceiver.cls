global class UotReceiver
{
    webservice static UnitOfTransferResponse execute(long transferId, List<UnitOfWork> unitOfWork, boolean logUnitsOfWork)
    {
        Long startTime = System.currentTimeMillis();
        EpAdapterUnitOfTransfer__c unitOfTransfer = new EpAdapterUnitOfTransfer__c();
        unitOfTransfer.UnitOfTransferId__c = transferId;

        List<UnitOfWorkResponse> responseList = new List<UnitOfWorkResponse>();
        List<EpAdapterUnitOfWork__c> sfdcUnitsOfWork = transform(unitOfWork, unitOfTransfer);

        List<SObject> objectsToInsert = new List<SObject>();
        objectsToInsert.add(unitOfTransfer);
        for (EpAdapterUnitOfWork__c sfdcUnitOfWork : sfdcUnitsOfWork) {
        	objectsToInsert.add(sfdcUnitOfWork);
        }
        insert objectsToInsert;

        Map<ID, Attachment> attachmentsBySfdcUnitOfWorkId = getAttachments(unitOfWork, sfdcUnitsOfWork);

        if (logUnitsOfWork) {
            insert attachmentsBySfdcUnitOfWorkId.values();
        }

        UowDecompiler decompiler = new UowDecompiler();

        for (EpAdapterUnitOfWork__c sfdcUnitOfWork : sfdcUnitsOfWork) {
            Attachment attachment = attachmentsBySfdcUnitOfWorkId.get(sfdcUnitOfWork.Id);
            UnitOfWorkResponse response = decompiler.decompile(sfdcUnitOfWork, attachment.Body.toString());

            responseList.add(response);

            if (UnitOfWorkStatus.FAILED == response.status && !logUnitsOfWork) {
                insert attachment;
            }
        }

        unitOfTransfer.NumSoqlQueries__c = Limits.getQueries();
        unitOfTransfer.NumSoqlRecords__c = Limits.getQueryRows();
        unitOfTransfer.NumDmlStatements__c = Limits.getDMLStatements() + 1;
        unitOfTransfer.NumDmlRecords__c = Limits.getDMLRows() + 1;
        unitOfTransfer.RunTime__c = System.currentTimeMillis() - startTime;
        unitOfTransfer.CpuTime__c = Limits.getCpuTime();
        update unitOfTransfer;

        UnitOfTransferResponse result = new UnitOfTransferResponse();

        result.unitOfTransferId = transferId;
        result.unitOfWorkResponses = responseList;
        result.numSoqlQueries = Limits.getQueries();
        result.numSoqlRecords = Limits.getQueryRows();
        result.numDmlStatements = Limits.getDMLStatements();
        result.numDmlRecords = Limits.getDMLRows();
        result.runTimeInMsecs = System.currentTimeMillis() - startTime;
        result.cpuTimeInMsecs = Limits.getCpuTime();

        return result;
    }

    private static List<EpAdapterUnitOfWork__c> transform(List<UnitOfWork> aUnitOfWorkList, EpAdapterUnitOfTransfer__c aUnitOfTransfer)
    {
        List<EpAdapterUnitOfWork__c> result = new List<EpAdapterUnitOfWork__c>();

        for (UnitOfWork unitOfWork : aUnitOfWorkList) {
            EpAdapterUnitOfWork__c sfdcUnitOfWork = new EpAdapterUnitOfWork__c();
            sfdcUnitOfWork.UnitOfWorkId__c = unitOfWork.unitOfWorkId;
            sfdcUnitOfWork.TriggeredDateTime__c = unitOfWork.triggeredDateTime;
            if (unitOfWork.type != null) {
                sfdcUnitOfWork.Type__c = unitOfWork.type.name();
            }
            sfdcUnitOfWork.UnitOfTransfer__r = aUnitOfTransfer;
            sfdcUnitOfWork.Status__c = UnitOfWorkStatus.PENDING.name();
            sfdcUnitOfWork.EPA_Transaction_IDs__c = unitOfWork.btlId;

            result.add(sfdcUnitOfWork);
        }

        return result;
    }

    private static Map<ID, Attachment> getAttachments(List<UnitOfWork> aUnitOfWorkList, List<EpAdapterUnitOfWork__c> aSfdcUnitOfWorkList)
    {
        Map<ID, Attachment> result = new Map<ID, Attachment>();
        Map<Decimal, ID> unitOfWorkSfdcIdsByUnitOfWorkId = getUnitOfWorkSfdcIdsByUnitOfWorkId(aSfdcUnitOfWorkList);

        for (UnitOfWork unitOfWork : aUnitOfWorkList) {
            if (unitOfWork.objectsAsString != null) {
                ID sfdcUnitOfWorkId = unitOfWorkSfdcIdsByUnitOfWorkId.get(unitOfWork.unitOfWorkId);
                Attachment attachment = new Attachment();

                attachment.Body = Blob.valueOf(unitOfWork.objectsAsString);
                attachment.Name = 'Objects';
                attachment.parentId = sfdcUnitOfWorkId;

                result.put(sfdcUnitOfWorkId, attachment);
            }
        }

        return result;
    }

    private static Map<Decimal, ID> getUnitOfWorkSfdcIdsByUnitOfWorkId(List<EpAdapterUnitOfWork__c> aSfdcUnitOfWorkList)
    {
        Map<Decimal, ID> result = new Map<Decimal, ID>();

        for (EpAdapterUnitOfWork__c sfdcUnitOfWork : aSfdcUnitOfWorkList) {
            result.put(sfdcUnitOfWork.UnitOfWorkId__c, sfdcUnitOfWork.Id);
        }

        return result;
    }
}