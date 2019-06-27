provider "azurerm" {
  version = "=1.28.0"
  subscription_id = "${var.subscription_id}"
}

resource "azurerm_resource_group" "searchdemo-rg" {
  name     = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
}

resource "azurerm_storage_account" "searchdemo-store" {
  name                     = "${azurerm_resource_group.searchdemo-rg.name}store"
  resource_group_name      = "${azurerm_resource_group.searchdemo-rg.name}"
  location                 = "${azurerm_resource_group.searchdemo-rg.location}"
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "searchdemo-store-container" {
  name                  = "data"
  resource_group_name   = "${azurerm_resource_group.searchdemo-rg.name}"
  storage_account_name  = "${azurerm_storage_account.searchdemo-store.name}"
  container_access_type = "private"
}

resource "azurerm_search_service" "searchdemo-search" {
  name                = "${azurerm_resource_group.searchdemo-rg.name}search"
  resource_group_name = "${azurerm_resource_group.searchdemo-rg.name}"
  location            = "${azurerm_resource_group.searchdemo-rg.location}"
  sku                 = "standard"
}

resource "azurerm_storage_account" "searchdemo-function-store" {
  name                     = "${azurerm_resource_group.searchdemo-rg.name}fnsa"
  resource_group_name      = "${azurerm_resource_group.searchdemo-rg.name}"
  location                 = "${azurerm_resource_group.searchdemo-rg.location}"
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "searchdemo-function-plan" {
  name                = "${azurerm_resource_group.searchdemo-rg.name}fnplan"
  location            = "${azurerm_resource_group.searchdemo-rg.location}"
  resource_group_name = "${azurerm_resource_group.searchdemo-rg.name}"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "searchdemo-function" {
  name                      = "${azurerm_resource_group.searchdemo-rg.name}fn"
  location                  = "${azurerm_resource_group.searchdemo-rg.location}"
  resource_group_name       = "${azurerm_resource_group.searchdemo-rg.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.searchdemo-function-plan.id}"
  storage_connection_string = "${azurerm_storage_account.searchdemo-function-store.primary_connection_string}"
  version                   = "~2"
  app_settings = {
    WEBSITE_NODE_DEFAULT_VERSION = "10.14.1"
    SEARCH_CONFIG_SERVICE_NAME   = "${azurerm_search_service.searchdemo-search.name}"
    SEARCH_CONFIG_INDEX_NAME     = "azureblob-index"
    SEARCH_CONFIG_PRIMARY_KEY    = "${azurerm_search_service.searchdemo-search.primary_key}"
  }
}

resource "null_resource" "configure-functions-cors" {
  provisioner "local-exec" {
    command = "az functionapp cors add -n ${azurerm_function_app.searchdemo-function.name} -g ${azurerm_resource_group.searchdemo-rg.name} --allowed-origins *"
  }
}

resource "null_resource" "deploy-function-source" {
  provisioner "local-exec" {
    working_dir = "../FunctionApp"
    command = "func azure functionapp publish  ${azurerm_function_app.searchdemo-function.name}"
  }
}

resource "null_resource" "upload-json-to-storage" {
  provisioner "local-exec" {
    command = "az storage blob upload -f ..\\data.json -c ${azurerm_storage_container.searchdemo-store-container.name}  --account-name ${azurerm_storage_account.searchdemo-store.name}  -n data.json"
  }
}