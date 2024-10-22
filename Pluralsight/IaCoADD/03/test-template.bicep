@secure()
param vulnerabilityAssessments_Default_storageContainerPath string
param servers_aspfa_sqlserver_test_name string = 'aspfa-sqlserver-test'

resource servers_aspfa_sqlserver_test_name_resource 'Microsoft.Sql/servers@2023-08-01-preview' = {
  name: servers_aspfa_sqlserver_test_name
  location: 'westeurope'
  tags: {
    Environment: 'Test'
    Location: 'West Europe'
    Organization: 'SAT PFA'
    Project: 'PluralSight'
    Purpose: 'Learning'
  }
  kind: 'v12.0'
  properties: {
    administratorLogin: 'CloudSAb0ac319b'
    version: '12.0'
    minimalTlsVersion: 'None'
    publicNetworkAccess: 'Enabled'
    administrators: {
      administratorType: 'ActiveDirectory'
      principalType: 'Group'
      login: 'websiteManagedIdentity'
      sid: '758ef29e-8134-453a-831d-e69f37b9e603'
      tenantId: '5f50d5ca-3903-4a05-abb5-28f509b56b3c'
      azureADOnlyAuthentication: true
    }
    restrictOutboundNetworkAccess: 'Disabled'
  }
}

resource servers_aspfa_sqlserver_test_name_ActiveDirectory 'Microsoft.Sql/servers/administrators@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'ActiveDirectory'
  properties: {
    administratorType: 'ActiveDirectory'
    login: 'websiteManagedIdentity'
    sid: '758ef29e-8134-453a-831d-e69f37b9e603'
    tenantId: '5f50d5ca-3903-4a05-abb5-28f509b56b3c'
  }
}

resource servers_aspfa_sqlserver_test_name_Default 'Microsoft.Sql/servers/advancedThreatProtectionSettings@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
}

resource servers_aspfa_sqlserver_test_name_CreateIndex 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'CreateIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_aspfa_sqlserver_test_name_DbParameterization 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'DbParameterization'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_aspfa_sqlserver_test_name_DefragmentIndex 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'DefragmentIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_aspfa_sqlserver_test_name_DropIndex 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'DropIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_aspfa_sqlserver_test_name_ForceLastGoodPlan 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'ForceLastGoodPlan'
  properties: {
    autoExecuteValue: 'Enabled'
  }
}

resource Microsoft_Sql_servers_auditingPolicies_servers_aspfa_sqlserver_test_name_Default 'Microsoft.Sql/servers/auditingPolicies@2014-04-01' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'Default'
  location: 'West Europe'
  properties: {
    auditingState: 'Disabled'
  }
}

resource Microsoft_Sql_servers_auditingSettings_servers_aspfa_sqlserver_test_name_Default 'Microsoft.Sql/servers/auditingSettings@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource Microsoft_Sql_servers_azureADOnlyAuthentications_servers_aspfa_sqlserver_test_name_Default 'Microsoft.Sql/servers/azureADOnlyAuthentications@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'Default'
  properties: {
    azureADOnlyAuthentication: true
  }
}

resource Microsoft_Sql_servers_connectionPolicies_servers_aspfa_sqlserver_test_name_default 'Microsoft.Sql/servers/connectionPolicies@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'default'
  location: 'westeurope'
  properties: {
    connectionType: 'Default'
  }
}

resource servers_aspfa_sqlserver_test_name_ASPFA_Database 'Microsoft.Sql/servers/databases@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'ASPFA-Database'
  location: 'westeurope'
  tags: {
    Environment: 'Test'
    Location: 'West Europe'
    Organization: 'SAT PFA'
    Project: 'PluralSight'
    Purpose: 'Learning'
  }
  sku: {
    name: 'Basic'
    tier: 'Basic'
    capacity: 5
  }
  kind: 'v12.0,user'
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 2147483648
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    zoneRedundant: false
    readScale: 'Disabled'
    requestedBackupStorageRedundancy: 'Geo'
    maintenanceConfigurationId: '/subscriptions/3b4e37d3-b3bc-4d14-b7cc-542c313518f7/providers/Microsoft.Maintenance/publicMaintenanceConfigurations/SQL_Default'
    isLedgerOn: false
    availabilityZone: 'NoPreference'
  }
}

resource servers_aspfa_sqlserver_test_name_master_Default 'Microsoft.Sql/servers/databases/advancedThreatProtectionSettings@2023-08-01-preview' = {
  name: '${servers_aspfa_sqlserver_test_name}/master/Default'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingPolicies_servers_aspfa_sqlserver_test_name_master_Default 'Microsoft.Sql/servers/databases/auditingPolicies@2014-04-01' = {
  name: '${servers_aspfa_sqlserver_test_name}/master/Default'
  location: 'West Europe'
  properties: {
    auditingState: 'Disabled'
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingSettings_servers_aspfa_sqlserver_test_name_master_Default 'Microsoft.Sql/servers/databases/auditingSettings@2023-08-01-preview' = {
  name: '${servers_aspfa_sqlserver_test_name}/master/Default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_extendedAuditingSettings_servers_aspfa_sqlserver_test_name_master_Default 'Microsoft.Sql/servers/databases/extendedAuditingSettings@2023-08-01-preview' = {
  name: '${servers_aspfa_sqlserver_test_name}/master/Default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_geoBackupPolicies_servers_aspfa_sqlserver_test_name_master_Default 'Microsoft.Sql/servers/databases/geoBackupPolicies@2023-08-01-preview' = {
  name: '${servers_aspfa_sqlserver_test_name}/master/Default'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource servers_aspfa_sqlserver_test_name_master_Current 'Microsoft.Sql/servers/databases/ledgerDigestUploads@2023-08-01-preview' = {
  name: '${servers_aspfa_sqlserver_test_name}/master/Current'
  properties: {}
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_securityAlertPolicies_servers_aspfa_sqlserver_test_name_master_Default 'Microsoft.Sql/servers/databases/securityAlertPolicies@2023-08-01-preview' = {
  name: '${servers_aspfa_sqlserver_test_name}/master/Default'
  properties: {
    state: 'Disabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_transparentDataEncryption_servers_aspfa_sqlserver_test_name_master_Current 'Microsoft.Sql/servers/databases/transparentDataEncryption@2023-08-01-preview' = {
  name: '${servers_aspfa_sqlserver_test_name}/master/Current'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_vulnerabilityAssessments_servers_aspfa_sqlserver_test_name_master_Default 'Microsoft.Sql/servers/databases/vulnerabilityAssessments@2023-08-01-preview' = {
  name: '${servers_aspfa_sqlserver_test_name}/master/Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource Microsoft_Sql_servers_devOpsAuditingSettings_servers_aspfa_sqlserver_test_name_Default 'Microsoft.Sql/servers/devOpsAuditingSettings@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'Default'
  properties: {
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource servers_aspfa_sqlserver_test_name_current 'Microsoft.Sql/servers/encryptionProtector@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'current'
  kind: 'servicemanaged'
  properties: {
    serverKeyName: 'ServiceManaged'
    serverKeyType: 'ServiceManaged'
    autoRotationEnabled: false
  }
}

resource Microsoft_Sql_servers_extendedAuditingSettings_servers_aspfa_sqlserver_test_name_Default 'Microsoft.Sql/servers/extendedAuditingSettings@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource servers_aspfa_sqlserver_test_name_ServiceManaged 'Microsoft.Sql/servers/keys@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'ServiceManaged'
  kind: 'servicemanaged'
  properties: {
    serverKeyType: 'ServiceManaged'
  }
}

resource Microsoft_Sql_servers_securityAlertPolicies_servers_aspfa_sqlserver_test_name_Default 'Microsoft.Sql/servers/securityAlertPolicies@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'Default'
  properties: {
    state: 'Disabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
}

resource Microsoft_Sql_servers_sqlVulnerabilityAssessments_servers_aspfa_sqlserver_test_name_Default 'Microsoft.Sql/servers/sqlVulnerabilityAssessments@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
}

resource Microsoft_Sql_servers_vulnerabilityAssessments_servers_aspfa_sqlserver_test_name_Default 'Microsoft.Sql/servers/vulnerabilityAssessments@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_resource
  name: 'Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
    storageContainerPath: vulnerabilityAssessments_Default_storageContainerPath
  }
}

resource servers_aspfa_sqlserver_test_name_ASPFA_Database_Default 'Microsoft.Sql/servers/databases/advancedThreatProtectionSettings@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_ASPFA_Database
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource servers_aspfa_sqlserver_test_name_ASPFA_Database_CreateIndex 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_aspfa_sqlserver_test_name_ASPFA_Database
  name: 'CreateIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource servers_aspfa_sqlserver_test_name_ASPFA_Database_DbParameterization 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_aspfa_sqlserver_test_name_ASPFA_Database
  name: 'DbParameterization'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource servers_aspfa_sqlserver_test_name_ASPFA_Database_DefragmentIndex 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_aspfa_sqlserver_test_name_ASPFA_Database
  name: 'DefragmentIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource servers_aspfa_sqlserver_test_name_ASPFA_Database_DropIndex 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_aspfa_sqlserver_test_name_ASPFA_Database
  name: 'DropIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource servers_aspfa_sqlserver_test_name_ASPFA_Database_ForceLastGoodPlan 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_aspfa_sqlserver_test_name_ASPFA_Database
  name: 'ForceLastGoodPlan'
  properties: {
    autoExecuteValue: 'Enabled'
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingPolicies_servers_aspfa_sqlserver_test_name_ASPFA_Database_Default 'Microsoft.Sql/servers/databases/auditingPolicies@2014-04-01' = {
  parent: servers_aspfa_sqlserver_test_name_ASPFA_Database
  name: 'Default'
  location: 'West Europe'
  properties: {
    auditingState: 'Disabled'
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingSettings_servers_aspfa_sqlserver_test_name_ASPFA_Database_Default 'Microsoft.Sql/servers/databases/auditingSettings@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_ASPFA_Database
  name: 'default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_backupLongTermRetentionPolicies_servers_aspfa_sqlserver_test_name_ASPFA_Database_default 'Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_ASPFA_Database
  name: 'default'
  properties: {
    weeklyRetention: 'PT0S'
    monthlyRetention: 'PT0S'
    yearlyRetention: 'PT0S'
    weekOfYear: 0
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_backupShortTermRetentionPolicies_servers_aspfa_sqlserver_test_name_ASPFA_Database_default 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_ASPFA_Database
  name: 'default'
  properties: {
    retentionDays: 7
    diffBackupIntervalInHours: 24
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_extendedAuditingSettings_servers_aspfa_sqlserver_test_name_ASPFA_Database_Default 'Microsoft.Sql/servers/databases/extendedAuditingSettings@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_ASPFA_Database
  name: 'default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_geoBackupPolicies_servers_aspfa_sqlserver_test_name_ASPFA_Database_Default 'Microsoft.Sql/servers/databases/geoBackupPolicies@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_ASPFA_Database
  name: 'Default'
  properties: {
    state: 'Enabled'
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource servers_aspfa_sqlserver_test_name_ASPFA_Database_Current 'Microsoft.Sql/servers/databases/ledgerDigestUploads@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_ASPFA_Database
  name: 'Current'
  properties: {}
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_securityAlertPolicies_servers_aspfa_sqlserver_test_name_ASPFA_Database_Default 'Microsoft.Sql/servers/databases/securityAlertPolicies@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_ASPFA_Database
  name: 'Default'
  properties: {
    state: 'Disabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_transparentDataEncryption_servers_aspfa_sqlserver_test_name_ASPFA_Database_Current 'Microsoft.Sql/servers/databases/transparentDataEncryption@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_ASPFA_Database
  name: 'Current'
  properties: {
    state: 'Enabled'
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_vulnerabilityAssessments_servers_aspfa_sqlserver_test_name_ASPFA_Database_Default 'Microsoft.Sql/servers/databases/vulnerabilityAssessments@2023-08-01-preview' = {
  parent: servers_aspfa_sqlserver_test_name_ASPFA_Database
  name: 'Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
  }
  dependsOn: [
    servers_aspfa_sqlserver_test_name_resource
  ]
}
