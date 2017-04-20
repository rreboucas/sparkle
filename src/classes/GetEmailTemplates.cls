public class GetEmailTemplates {
    @AuraEnabled
    public static List<EmailTemplate> getTemplates() {
        return [SELECT Body,Id,Name,Subject,TemplateType FROM EmailTemplate Limit 20];
    }
    //add method to get email templates
    //add method to preview templates
}