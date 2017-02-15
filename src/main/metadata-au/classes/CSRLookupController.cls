/*
    Type:       Extension for MassAssignRecallTasks Visualforce page CSR Lookup Page
    Purpose:    Mass Select CSRs
    User Story: US-Task-002, US-Task-003, US-Task-008, US-Task-009,
                US-Task-013, US-Task-014,
    Used By:    CSRLookup.page
    ---------------------------------------------------------------
    History:
    
    1. Chris Created on 2013-06-03
    2. Chaos Edit on 2013-12-05  CR-000136
    3. Patrick Zhang modified on 2013-12-13
        change the initial method of csrProfiles

*/
public class CSRLookupController {
    
    public string csrIds {get;set;}
    // Please Select Users First.
    public static final String ERROR_MSG_1 = Label.CSR_Lookup_ErrorMsg1;
    public List<csrUsersWrapper> userList = new List<csrUsersWrapper>();
    List<User> selectedUsers = new List<User>();

    public List<csrUsersWrapper> getcsrUsers(){

        String[] csrProfiles;
        Profile pf = [Select Name From Profile Where Id = :UserInfo.getProfileId()];
        if (pf.Name.contains('OB')) {
            csrProfiles = new String[]{
                'CAC OB CSR', 'CAC OB TL', 'CAC OB SV', 'CAC OB QC', 'CAC OB Trainer'
            };
        }else if (pf.Name.contains('SSI')) {
            csrProfiles = new String[]{
                'CAC SSI CSR', 'CAC SSI TL', 'CAC SSI SV', 'CAC SSI QC', 'CAC SSI Trainer'
            };
        }else if (pf.Name.contains('IB')) {
            csrProfiles = new String[]{
                'CAC IB CSR', 'CAC IB TL', 'CAC IB SV', 'CAC IB QC', 'CAC IB Trainer'
            };
        }else{
            csrProfiles = new String[]{
                 'CAC IB CSR', 'CAC IB TL', 'CAC IB SV', 'CAC IB QC', 'CAC IB Trainer',
                 'CAC OB CSR', 'CAC OB TL', 'CAC OB SV', 'CAC OB QC', 'CAC OB Trainer',
                 'CAC SSI CSR', 'CAC SSI TL', 'CAC SSI SV', 'CAC SSI QC', 'CAC SSI Trainer',
                 'System Administrator', 'Agency', 'Customer Retention', 'Dealer Consultant', 'Dealer CRM Manager',
                 'Dealer Divisional Manager', 'Dealer Services', 'Dealer-Read Only', 'DRM', 'EMC', 'Fleet', 'Fleet (Delete)',
                 'Fleet (Delete) – MBAuP', 'Fleet – MBAuP', 'FS Admin', 'Head Office - BDM\'s-cars,vans,trucks', 'Head Office – Enquiries', 
                 'Head Office - General user - cars BU', 'Head Office – Marketing', 'Network Devevlopment', 'System Admin Business', 'Team Leader (EMC + CR)'
            };
        }
        
        List<Profile> profileIds = [
            Select Id 
            From Profile 
            Where Name In :csrProfiles];
        List<User> csrUsers = [
            Select Name, UserRole.Name 
            From User 
            Where ProfileId in :profileIds And IsActive = true];

        // ADD START CR-000136 CHAOS 2013/12/5
        List<AggregateResult> amounts = [
            SELECT ownerid, COUNT(id) num
            FROM Task
            WHERE ownerid IN :csrUsers
            AND Status= 'Open'
            GROUP BY ownerid];
        // ADD END CR-000136 CHAOS 2013/12/5

        // EDIT START CR-000136 CHAOS 2013/12/5
        for(User a : csrUsers){
            // Amount of SSI tasks for each SSI CSR
            Integer amount = 0;
            for (AggregateResult amo : amounts) {
                if (amo.get('ownerid') == a.Id) {
                    amount = (Integer)amo.get('num');
                    break;
                }
            }
            userList.add(new csrUsersWrapper(a, amount));
        // EDIT END CR-000136 CHAOS 2013/12/5
        }
            
        return userList;
    }

    public class csrUsersWrapper {
        public User csr{get; set;}
        public Boolean selected {get; set;}
        // EDIT START CR-000136 CHAOS 2013/12/5
        public Integer amount{get; set;}
        public csrUsersWrapper(User a, Integer amount){
            csr = a;
            selected = false;
            this.amount = amount;
        }
        // EDIT END CR-000136 CHAOS 2013/12/5
    }

    public String selectNameText {get; set;}
    public String selectIdText {get; set;}
    
    public PageReference selectCSR(){
        
        for(csrUsersWrapper userwrapper : userList){
            if(userwrapper.selected == true){
                selectedUsers.add(userwrapper.csr);
            }   
        }
        
        if(selectedUsers.size()>0){
            selectNameText = '';
            selectIdText = '';
            for(User u : selectedUsers){
                selectNameText += u.Name + '; ';
                selectIdText += u.Id + ';';
            }
            selectNameText = selectNameText.substring(0, selectNameText.length()-2);
            selectIdText = selectIdText.substring(0, selectIdText.length()-1);
        }else{
            // Please Select Users First.
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_MSG_1));           
        }
        return null;
    }       
}