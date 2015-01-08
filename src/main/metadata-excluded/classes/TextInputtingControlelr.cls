/*
    Type:       Page Controlelr
    Purpose:    For long text inputting 
    User Story: 
    ---------------------------------------------------------------
    History:

    1. Justin Created on 2013-10-11
*/
public with sharing class TextInputtingControlelr {
  
  private String caseId;
  private String textField;
  private final String MPC_INTERNAL_NOTES = 'mpc';
  private final String PR_COMMENT = 'mbcl';
  
  public TextInputtingControlelr(){
    caseId = Apexpages.currentPage().getParameters().get('cid');
    textField = Apexpages.currentPage().getParameters().get('field');
    setPermission();
  }
  
  public String textValue { get; set; }
  public Boolean isUpdateable { get; set; }
  
  public PageReference save(){
    if(String.isBlank(textValue)){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please enter your notes.'));
      return null;
    }
    
    Case[] cases = [select Id, MPC_Internal_Notes__c, PR_Comment_MBCL_Internal__c from Case where Id = :caseId];
    if(cases.size() > 0){
      if(textField == MPC_INTERNAL_NOTES){
        cases[0].MPC_Internal_Notes__c = addTextToTop(cases[0].MPC_Internal_Notes__c, textValue);
      }
      else if(textField == PR_COMMENT){
        cases[0].PR_Comment_MBCL_Internal__c = addTextToTop(cases[0].PR_Comment_MBCL_Internal__c, textValue);
      }
      
      try{
        update cases[0];
      }
      catch(Exception ex){
        ApexPages.addMessages(ex);
        return null;
      }
      return goBack();
    }
    else {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Not found case.'));
      return null;
    }
  }
  
  public PageReference goBack(){
    return new PageReference('/' + caseId);
  }
  
  private String addTextToTop(String originalText, String addedText){
    String result = '';
    result = '输入时间：' + Datetime.now().format() + '\r\n输入者：' + UserInfo.getName() + '\r\n' + textValue;
    if(originalText != null){
      result += '\n\n' + originalText;
    }
    return result;
  }
  
  private void setPermission(){
    if(textField == MPC_INTERNAL_NOTES){
      isUpdateable = Case.MPC_Internal_Notes__c.getDescribe().isUpdateable();
    }
    else if(textField == PR_COMMENT){
      isUpdateable = Case.PR_Comment_MBCL_Internal__c.getDescribe().isUpdateable();
    }
  }
}