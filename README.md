# poirot - Azure Search + Azure Function Demo

This project is a demonstration of creating an Azure Search index from json data and exposing it via an Azure Function. The end result is an api that can be called.

This project was named after the fictional character [Hercule Poirot](https://en.wikipedia.org/wiki/Hercule_Poirot)

### Sample Data
This demo uses fake data stored in data.json. The file contains a json array movie names and descriptions *.

#### Description of Properites:
|Column              | Purpose                                                                            |
|--------------------|------------------------------------------------------------------------------------|
| id                 | Unique id for the document                                                         |
| description        | description of the movie (this is intentionally a terrible/funny pitch.)           |
| name               | name of the movie                                                                  |

\* <sub>Sample data from [Can you guess these movies based on their terrible pitches?](https://www.abc.net.au/news/2017-02-20/can-you-guess-these-movies-based-on-bad-pitches/8277862)</sub>

### Requirements
* [NodeJs](https://nodejs.org/en/)
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
* [Terraform](https://www.terraform.io/downloads.html) 

### Create the infrastructure needed.
This demo relies on the following Azure services:

* [Azure Search](https://docs.microsoft.com/en-us/azure/search/) 
* [Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/)
* [Azure Storage](https://docs.microsoft.com/en-us/azure/storage/)

Resources require an Azure Subscription and keys set up. You can create an [Azure Free Account](https://azure.microsoft.com/en-us/free/) to try this demo.

### Infrastructure
The infrastructure folder contains terraform files that can be used to spin up the two cognitive services used by this project. 

* Ensure that Terraform and the Azure CLI tools are installed locally or use the [Azure Cloud Shell](https://shell.azure.com) (the cloud shell installs these tools by default.)
* (if local) invoke ```az login``
* Navigate to the infrastructure repo of this folder.
* run ``` terraform init ``` to initialize terraform 
* run ``` terraform plan --out=plan.tfplan ``` 
* run ``` terraform apply "plan.tfplan" ```


### References

* [Speech Search Documentation](https://docs.microsoft.com/en-us/azure/search/)
* [Azure Search - Key Phrase extraction](https://docs.microsoft.com/en-us/azure/search/cognitive-search-skill-keyphrases)
* [Azure Functions Documentation](https://docs.microsoft.com/en-us/azure/azure-functions/)
* [Azure Functions CORS](https://docs.microsoft.com/en-us/azure/azure-functions/functions-how-to-use-azure-function-app-settings#cors)
* [Terraform Azure Provider](https://www.terraform.io/docs/providers/azurerm/index.html)
* [Azure Extensions for VSCode](https://code.visualstudio.com/docs/azure/extensions)


