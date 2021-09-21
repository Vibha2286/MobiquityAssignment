# MobiquityAssignment  

**Requirements**:  

iOS 12+  
Xcode 12.4  
Swift 4.2  

This is the basic example for the Flickr image search module. Its will search any keyword based on your keyword and it will display the images with the endless scrolling. It also maintain search history so that user can dont need to enter already searched items. 

**Specification**  

Inside this project Textfield using for type keywords and UICollectionView for display search results. It will call request async and display new images based on page count in backgroud simuntaniously. Pod used to show progress hud. 


**Instructions:**
- On launch, users should be taken to a home screen that automatically displays list of images for predefine search test "Kitten"
- Users should be able to supply a search term to receive results related to that search term.  
- Users should be able to filter results by available tags, or perform a follow-on search using a tag as a search term.  
- The app needs to asynchronously present the results as thumbnails on a grid  
- The images should be cached properly.  
- There should be unit tests to cover the core functionality of the app.  

**Flickr API Documentation**
Images are retrieved by hitting the Flickr API.

https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=YOUR_FLICKR_API_KEY&format=json&nojsoncallback=1&safe_search=1&text=KEYWORD
