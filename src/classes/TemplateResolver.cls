public with sharing class TemplateResolver {
    
    public static String candidateFields(String emailTemplate, String recordID){
        return replace(emailTemplate, 'testautonumdata__Candidate__c', recordID);
    }
    
    public static String positionFields(String emailTemplate, String recordID){
        return replace(emailTemplate, 'testautonumdata__Position__c', recordID);
    }
    
    public static String offerFields(String emailTemplate, String recordID){
        return replace(emailTemplate, 'testautonumdata__Offer__c', recordID);
    }

    public static String userFields(String emailTemplate, String recordID){
        return replace(emailTemplate, 'User', recordID);
    }
    
    private static String replace(String emailTemplate, String objectName, String recordId){
        Pattern regex = Pattern.compile('\\{!([^}]*)\\}');
        Matcher regexMatcher = regex.matcher(emailTemplate);
        Set<String> tokens = new Set<String>();

        while (regexMatcher.find()){         
            String dirtyVariable = regexMatcher.group();
            
            /* Extract curly braces and exclamation marks*/
            String variable = dirtyVariable.substring(2,dirtyVariable.length()-1);
            
            //keep only Lead fields
            if(variable.startsWith(objectName + '.')){
            //remove self-referencing in fieldnames
                tokens.add(variable.replace(objectName + '.', ''));
            }
        }

        //Build dynamic query
        String qry = 'Select ';
        for(String s : tokens){
            qry += s + ',';
        }
        
        //remove last ","
        qry = qry.substring(0, qry.length()-1);
        
        //Do the query
        SObject o = Database.query(qry + ' From ' + objectName + ' Where ID = :recordID');
        
        //Replace values
        for(String s : tokens){         
            emailTemplate = emailTemplate.replace('{!' + objectName + '.' + s + '}', getValue(o, s));
        }
        
        return emailTemplate;
    }
    
    private static String getValue(SObject o, String fieldName){
        return (o.get(fieldName) != null) ? String.valueOf(o.get(fieldName)) : '';
    }


}