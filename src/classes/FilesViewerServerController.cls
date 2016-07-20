public with sharing class FilesViewerServerController {
    
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
        
        List<FilesViewerServerController> lstReturnRecords = new List<FilesViewerServerController>();
        if (!String.isBlank(recordID))
        {
        Integer rLimit = integer.valueOf(rowsLimit);
        System.debug('######## FilesViewerServerController: rLimit: ' + rLimit);
        
        String soql = 'select ContentDocumentId, contentdocument.title, contentdocument.filetype, contentdocument.createddate, contentdocument.fileextension, contentdocument.contentsize, Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp,Visibility FROM ContentDocumentLink';
        
        // Add Filter Where clause if provided
        soql += ' where LinkedEntityId  = \'' + recordID+'\' and contentdocument.isArchived = false and contentdocument.isDeleted = false';
        
        
        // Add order by:
        soql += ' order by contentdocument.createddate desc'; 
        
        // Add return row limit to query string:        
        soql += ' limit ' + rowsLimit;
        
        // Get List of QueriedRecords
        
        System.debug('######## FilesViewerServerController - soql: ' + soql);
        
        List<SObject> lstQueriedRecords = Database.query(soql); 
        
        System.debug('######## FilesViewerServerController -  lstQueriedRecords: ' + lstQueriedRecords);
       
        
        
        for (SObject e: lstQueriedRecords)
        {
            System.debug('######## e: ' + e);
            FilesViewerServerController i = new FilesViewerServerController();
            
            
            i.fileID = GetSobjectField(e, 'ContentDocumentId');
            i.fileName = GetSobjectField(e, 'ContentDocument.Title');
            i.fileCreatedDate = GetSobjectField(e, 'ContentDocument.CreatedDate');
            i.fileExtension = GetSobjectField(e, 'ContentDocument.FileExtension');
            if (i.fileExtension.equalsIgnoreCase('doc'))
                i.fileExtension = 'word';
            i.fileSize = GetSobjectField(e, 'ContentDocument.ContentSize');
            

            lstReturnRecords.add(i);

			System.debug('######## i: ' + i);               
        }
        
        
        
        System.debug('######## FilesViewerServerController - lstReturnRecords: ' + lstReturnRecords);
        }
        return lstReturnRecords;
     
        
        
    }
    
    private static String GetSobjectField(Sobject e, String lcfield)
    {
        
        String returnValue = '';
        
        if (lcfield.contains('.')) // than it is a parent-relationship field
                {
                    String relName = lcfield.substringBefore('.');
                    String relField = lcfield.substringAfter('.');
                    if (relField.contains('.')) // than it is a 2 level parent-relationship field
                    {
                       String relName2 = relField.substringBefore('.');
                       String relField2 = relField.substringAfter('.');
                       returnValue = String.valueOf(e.getSObject(relName).getSObject(relName2).get(relField2));
                    }
                    else
                    	returnValue = String.valueOf(e.getSObject(relName).get(relField));
                }
                    
                else
                	returnValue = String.valueOf( e.get(lcfield) );
     
        return returnValue;
    } 


}