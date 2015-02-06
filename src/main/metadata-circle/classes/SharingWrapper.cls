public class SharingWrapper {

	public SharingWrapper() {
		this(null);
	}

	public SharingWrapper(Id pId) {
		this(pId, new Map<Id, String>());
	}

	public SharingWrapper(Id pId, Map<Id, String> user2AccessLevel) {
		this(pId, user2AccessLevel, 'Manual Sharing');
	}

	public SharingWrapper(Id pId, Map<Id, String> user2AccessLevel, String cause) {
		ParentId = pId;
		UserOrGroups2AccessLevel = user2AccessLevel;
		RowCause = cause;
	}

	public Id ParentId { get; set; }
	public Map<Id, String> UserOrGroups2AccessLevel { get; set; }
	public String RowCause { get; set; }
}