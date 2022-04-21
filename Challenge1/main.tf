terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}


# Retrieve the  keyvault so that we can use the password stored on the key
data "azurerm_key_vault" "Vault" {
  name                = "myvault"
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "KeyVault" {
  name      = "sqlserverpassword"
  key_vault_id = data.azurerm_key_vault.Vault.id
}


resource "azurerm_app_service_plan" "myplan" {
  name                = "3tierappserviceplan"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "webapp" {
  count    = 2
  name                = element(var.webapps, count.index)
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.myplan.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }
}


resource "azurerm_sql_server" "sqlserver" {
  name                         = "mydb"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "myusername"
  administrator_login_password = data.azurerm_key_vault_secret.KeyVault.value


}

resource "azurerm_storage_account" "storageaccount" {
  name                     = "mystorageaccount"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_database" "sqldb" {
  name                = "sqldatabase"
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_sql_server.sqlserver.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.storageaccount.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.storageaccount.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }

}



