output "data-storage-connection-string" {
  value = "${azurerm_storage_account.searchdemo-store.primary_connection_string}"
}

