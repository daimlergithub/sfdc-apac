global class EpaAdminCommand
{
  global String adminCommandClassName {get;set;}
  global String adminCommandName {get;set;}
  global String description {get;set;}
  global String organization {get;set;}
  global String useCase {get;set;}
  global Boolean isClusterable {get;set;}
  global List<String> arguments {get;set;}
  global Boolean isScheduled {get;set;}
}