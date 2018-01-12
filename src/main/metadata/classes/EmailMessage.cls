public class EmailMessage {

    public static Messaging.SingleEmailMessage createSingleEmailMessage(Id targetObjectId,Id templateId,Id recordId)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(templateId);
        mail.setTargetObjectId(targetObjectId);
        mail.setWhatId(recordId);
        mail.setSaveAsActivity(false);
        return mail;
	}
}