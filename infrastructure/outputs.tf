output "data-storage-connection-string" {
  value = azurerm_storage_account.searchdemo-store.primary_connection_string
}

output "data-search-service-primary-key"{
  value = azurerm_search_service.searchdemo-search.primary_key
}