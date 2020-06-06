This task requried 

1) fetching records from URL
2) Updating DB daily
3) Build app to display images
4) Build search engine to narrow down the images
5) Send email with filtered down list of images


Steps to setup the app

1) Once code is pushed to org the app will automatically update the images in DB once a day but in order to work with it right away it's good idea to manually add images to DB from developer console by running this code snippet

  ConfiguratorLC.addImagesToDB();

2) Select "images app" from homescreen and add single image record
3) go to "view" tab

In the current state the app implements every functionality except sending attachement with narrowed down list of images. It only sends boilerplate email to email address provided in the account in the app and unfortunetely the account id needs to be hardcoded in the sendEmail method.
