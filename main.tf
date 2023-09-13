module "naming" {
  source        = "Azure/naming/azurerm"
  suffix        = [var.name]
  unique-length = 6
}

resource "azurerm_cosmosdb_account" "databaseAccount" {
  name                = module.naming.cosmosdb_account.name_unique
  resource_group_name = var.resource_group_name
  location            = var.location
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    failover_priority = 0
    location          = var.location
  }
}

resource "azurerm_cosmosdb_sql_database" "database" {
  name                = var.database_name
  resource_group_name = azurerm_cosmosdb_account.databaseAccount.resource_group_name
  account_name        = azurerm_cosmosdb_account.databaseAccount.name
}

resource "azurerm_cosmosdb_sql_container" "container" {
  for_each            = toset(var.database_containers)
  name                = each.value
  resource_group_name = azurerm_cosmosdb_account.databaseAccount.resource_group_name
  account_name        = azurerm_cosmosdb_account.databaseAccount.name
  database_name       = azurerm_cosmosdb_sql_database.database.name
  partition_key_path  = "/id"
}
