# Creating the Azure Search index based on data in [data.json](./data.json)

* Navigate to your newly created Azure Search Service and click on "import data."
![Import Data](./img/search1.png)
### Connect to your data
* Select Azure Blob Storage for Data Source.
![Select Azure Blob Storage](./img/search2.png)

* Enter the following values
  * Name: azureblob-index (note it's important to use this name as the azure function is preconfigured to look for this index.)
  * Data to extract: Content and metadata
  * Parsing Mode: JSON array
  * Connection string (enter connection string terraform output)
  * Container name: data (note it's important to use this name, since this is the container name created by terraform).
![SEnter data source info](./img/search3.png)

  * click "Next: Add cognitive search (optional)"

### Add Cognitive Skill 
* Expand the Attach Cognitive Services section
* Ensure the Free (Limited encrichments) option is selected.
![Attach cognitive services](./img/search4.png)
* Expand the Add Encrichments section
* Enter "keyphraseskill" as the skillset name.
* Select "Description" as the Source data field.
* Select "Sentences" for Enrichement granularity level.
* Check the following cognitive skills
  * Extract key phrases,
  * Detect sentiment.

![Add Enrichments](./img/search5.png)  
* Click Next: Customize target index.

### Customize target index

* Change the key from AzureSearch_DocumentKey to id
* Delete all the metadata_storage fields and AzureSearch_DocumentKey.
![Delete unused fields](./img/search6.png)  

* At the top row check the boxes for "Rereivable, Fitlerable,Sortable,Facetable & Searchable." This should check those options for all fields.
![check field options for every field](./img/search7.png)  

* Click "Next: Create an indexer.

## Create an indexer
* name the indexer "azuresearch-indexer"
* Click "Submit"

## Testing our index
* Navigate to the search service overview page (you should be taken there after creating the indexer.)
* Click the "Search Explorer" button.

![Go to Search Explorer](./img/search8.png)  
* Click Search, alll the items form the json file should appear.

![Search Results](./img/search9.png)  

## Test the Azure Function.
* Grab the url from the terraform output log.
* Open a new browser tab and go paste that url. Add &searchTerm=movie to the end of the url.
* You should see a json object with data from Azure search.

![Search Results](./img/search10.png)  

* Try changing the searchTerm and search for "movies with dude", you should get one result back.





