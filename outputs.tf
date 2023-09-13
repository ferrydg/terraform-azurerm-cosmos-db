output "primary_key" {
  value = azurerm_cosmosdb_account.databaseAccount.connection_strings[0]
}
