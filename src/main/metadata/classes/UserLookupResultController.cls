/*
    Type:       Page Controller
    ---------------------------------------------------------------
    History:
    
    1. 2014-03-18 Created By Justin Yu
*/
public class UserLookupResultController {
	
	private String assignmentType = ApexPages.currentPage().getParameters().get('type');
	public List<UserInfo> userInfos { get; set; }
	
	public UserLookupResultController(){
		setProperties();
	}
	
	/**    
     * @Description : sets the properties like QcCount and userinfo to every user by getting list of users
     * @author      : Justin Yu
     * @Date        : 2014-03-18
     * @param       : 
     * @return      : 
     * @see         : UserLookupResultController
    **/	
    
	private void setProperties(){
		
		List<User> users = getUsers();
		
		Set<String> userIds = new Set<String>();
		for(User user : users){
			userIds.add(user.Id);
		}
		
		Map<String, Integer> qcCountForUser = getQcCount(userIds);
		
		userInfos = new List<UserInfo>();
		for(user user : users){
			Integer qcCount = qcCountForUser.get(user.Id);
			qcCount = qcCount == null ? 0 : qcCount;
			userInfos.add(new UserInfo(user, qcCount));
		}
	}
	
	/**    
     * @Description : gets all the users having assignment types assignment,recall
     * @author      : Justin Yu
     * @Date        : 2014-03-18
     * @param       : 
     * @return      : list of users having profiles 'CAC SSI QC','CAC SSI SV' and  'CAC SSI TL'.
     * @see         : setProperties
    **/	
    
	private List<User> getUsers(){
		List<User> result = new List<User>();
		if(assignmentType == 'assignment'){
			result = [select Id, Name, UserRole.Name from User where Profile.Name = 'CAC SSI QC'];
		}
		else if(assignmentType == 'recall'){
			result = [select Id, Name, UserRole.Name from User where Profile.Name = 'CAC SSI SV' or Profile.Name = 'CAC SSI TL'];
		}
		return result;
	}
	
	/**    
     * @Description : gets Qc record count for every user
     * @author      : Justin Yu
     * @Date        : 2014-03-18
     * @param       : set of user ids
     * @return      : Qc count map
     * @see         : setProperties
    **/	
	private Map<String, Integer> getQcCount(Set<String> userIds){
		Map<String, Integer> qcCountMap = new Map<String, Integer>();//01290000000rXmW this record type id doesnot exist.
		for(AggregateResult result : [select OwnerId, COUNT(Id) qcSize from QC__c where RecordTypeId = '012O00000000flz'and Status__c = 'New'
									  and Status__c = 'In Progress' and OwnerId in :userIds group by OwnerId]){
			qcCountMap.put((String)result.get('OwnerId'), (Integer)result.get('qcSize'));
		}
		return qcCountMap;
	}
		
	
	public class UserInfo{
		
	/**    
     * @Description : gets the user information 
     * @author      : Justin Yu
     * @Date        : 2014-03-18
     * @param       : user and qcCount
     * @return      : userinformation 
     * @see         : 
    **/	
		public UserInfo(User user, Integer qcCount){
			this.user = user;
			this.qcCount = qcCount;
		}
		
		public User user { get; set; }
		public Integer qcCount { get; set; }
	}
}