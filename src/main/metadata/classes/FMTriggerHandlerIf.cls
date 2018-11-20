public interface FMTriggerHandlerIf {
    void beforeInsert();
    void beforeUpdate();
    void afterInsert();
    void afterUpdate();
	void afterDelete();
}