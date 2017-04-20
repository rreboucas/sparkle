public with sharing class FilesViewerServerController {
    
    private static Map<String, Set<String>> mapObjectsFields = null;

    @AuraEnabled
    public String fileID { get;set; }
    @AuraEnabled
    public String fileName { get;set; }
    @AuraEnabled
    public String fileCreatedDate { get;set; }
    @AuraEnabled
    public String fileExtension { get;set; }
    @AuraEnabled
    public String fileSize { get;set; }
    
    
    @AuraEnabled
    public static List<FilesViewerServerController> getListRecords(String recordID, String rowsLimit) {
        
        System.debug('######## FilesViewerServerController: rowsLimit: ' + rowsLimit);

        // CRUD / FLS Check - Create a map with the object names and fields for CRUD\FLS check
        mapObjectsFields = new Map<String, Set<String>>(); 
        
        Sparkle_Helper.AddFieldToObjectsMap('Id', 'ContentDocumentLink', mapObjectsFields);
        
        List<FilesViewerServerController> lstReturnRecords = new List<FilesViewerServerController>();
        if (!String.isBlank(recordID))
        {
        Integer rLimit = integer.valueOf(rowsLimit);
        System.debug('######## FilesViewerServerController: rLimit: ' + rLimit);


        
        String soql = 'select ContentDocumentId, contentdocument.title, contentdocument.filetype, contentdocument.createddate, contentdocument.fileextension, contentdocument.contentsize, Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp,Visibility FROM ContentDocumentLink';
        
        // Add Filter Where clause if provided
        soql += ' where LinkedEntityId  = \'' + String.escapeSingleQuotes(recordID) + '\' and contentdocument.isArchived = false and contentdocument.isDeleted = false';
        
        
        // Add order by:
        soql += ' order by contentdocument.createddate desc'; 
        
        // Add return row limit to query string:        
        soql += ' limit ' + String.escapeSingleQuotes(rowsLimit);
        
        Sparkle_Helper.AddFieldToObjectsMap('ContentDocumentId', 'ContentDocumentLink', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('contentdocument.title', 'ContentDocumentLink', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('contentdocument.filetype', 'ContentDocumentLink', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('contentdocument.createddate', 'ContentDocumentLink', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('contentdocument.fileextension', 'ContentDocumentLink', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('contentdocument.contentsize', 'ContentDocumentLink', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('IsDeleted', 'ContentDocumentLink', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('LinkedEntityId', 'ContentDocumentLink', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('ShareType', 'ContentDocumentLink', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('SystemModstamp', 'ContentDocumentLink', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('Visibility', 'ContentDocumentLink', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('contentdocument.isArchived', 'ContentDocumentLink', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('contentdocument.isDeleted', 'ContentDocumentLink', mapObjectsFields);




        // Get List of QueriedRecords
        
        System.debug('######## FilesViewerServerController - soql: ' + soql);
        
        List<SObject> lstQueriedRecords = Database.query(soql); 
        
        System.debug('######## FilesViewerServerController -  lstQueriedRecords: ' + lstQueriedRecords);
       
        // CRUD\FLS Check: Before running the SOQL query check if the user who is invoking this method has access to the Object and to the fields requested
        
        if (Sparkle_Helper.UserHasAccessToObjectsAndFields(mapObjectsFields))
        {
        
            for (SObject e: lstQueriedRecords)
            {
                System.debug('######## e: ' + e);
                FilesViewerServerController i = new FilesViewerServerController();
                
                
                i.fileID = Sparkle_Helper.GetSobjectField(e, 'ContentDocumentId');
                i.fileName = Sparkle_Helper.GetSobjectField(e, 'ContentDocument.Title');
                i.fileCreatedDate = Sparkle_Helper.GetSobjectField(e, 'ContentDocument.CreatedDate');
                i.fileExtension = Sparkle_Helper.GetSobjectField(e, 'ContentDocument.FileExtension');
                if (i.fileExtension.equalsIgnoreCase('doc'))
                    i.fileExtension = 'word';
                i.fileSize = Sparkle_Helper.GetSobjectField(e, 'ContentDocument.ContentSize');
                

                lstReturnRecords.add(i);

    			System.debug('######## i: ' + i);               
            }
        
        }
        
        System.debug('######## FilesViewerServerController - lstReturnRecords: ' + lstReturnRecords);
        }
        return lstReturnRecords;
     
        
        
    }
    


}