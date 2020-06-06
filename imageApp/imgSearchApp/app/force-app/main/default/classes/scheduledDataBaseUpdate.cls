global class scheduledDataBaseUpdate implements Schedulable{
    global void execute(SchedulableContext ctx) {
        try{
            List<Image__c> imagesFromWebSObjects =  new List<Image__c>();
            List<Image__c> imagesFromDBSObjects =  new List<Image__c>();   
            for(Image_schema.Image i : ConfiguratorLC.getImagesFromWeb()){
                imagesFromWebSObjects.add(ConfiguratorLC.mapSchemaToSObject(i));
            }  
            for(Image_schema.Image i : ConfiguratorLC.getImagesFromDB()){
                imagesFromDBSObjects.add(ConfiguratorLC.mapSchemaToSObject(i));
            }
            // not very clever. Think of better idea to do this
            delete imagesFromDBSObjects;
            insert imagesFromWebSObjects;
         } catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
         }
    }
}
