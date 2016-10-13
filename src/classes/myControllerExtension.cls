public with sharing class myControllerExtension {

    private final testautonumdata__Interviewer__c interviewer;
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public myControllerExtension(ApexPages.StandardController stdController) {
        this.interviewer = (testautonumdata__Interviewer__c)stdController.getRecord();
    }

    public String getGreeting() {
        return 'Hello ' + interviewer.name + ' (' + interviewer.id + ')';
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('0','0')); 
        options.add(new SelectOption('1','1')); 
        options.add(new SelectOption('2','2')); 
        options.add(new SelectOption('3','3')); 
        options.add(new SelectOption('4','4')); 
        options.add(new SelectOption('5','5')); 
        return options; 
    }
    
    public PageReference doSomething()
    {
        // Apex code for handling record from a Detail page goes here
        PageReference pg = new PageReference('/a0MB0000000cQXF');
        pg.setRedirect(true);
        return pg; 
        
    }
    
    public PageReference goToAnotherVFPage()
    {
        // Apex code for handling record from a Detail page goes here
        PageReference pg = new PageReference('/apex/InterviewQuestionsLDS');
        pg.setRedirect(true);
        return pg; 
        
    }
}