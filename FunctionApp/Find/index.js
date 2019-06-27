const { SearchService } = require('azure-search-client');
const sw = require('stopword')

module.exports = async function (context, req) {
    context.log('JavaScript HTTP trigger function processed a request.');

    let searchConfig = {
        serviceName : process.env['SEARCH_CONFIG_SERVICE_NAME'],
        index: process.env['SEARCH_CONFIG_INDEX_NAME'],
        primaryKey: process.env['SEARCH_CONFIG_PRIMARY_KEY']
      }
    
    let searchTerm = req.query.searchTerm;
    let azureSearch = new SearchService(searchConfig.serviceName, searchConfig.primaryKey); 

    async function search(term){
      const resp = await azureSearch.indexes.use(searchConfig.index).search({
        search: `${term}`
      });
      return resp.result.value;   
    }
    
    let newString = sw.removeStopwords(searchTerm.split(' '));
    //remove custom stop word
    newString = sw.removeStopwords(newString,['movie']);
    let filteredInput = newString.join(' ');

    let result = await search(filteredInput);
    context.res = {
        body: result
    };
};


