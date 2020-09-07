resource "random_pet" "prefix" {}

variable "appId" {
}

variable "password" {
}

provider "azurerm" {
  version = "~> 1.37.0"
}

resource "azurerm_resource_group" "default" {
  name     = "sample-rg"
  location = "West Europe"

  tags = {
    environment = "Demo"
  }
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "sample-aks"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"

  default_node_pool {
    name            = "default"
    vm_size         = "Standard_D2_v2"
    type            = "VirtualMachineScaleSets"
    os_disk_size_gb = 30
    enable_auto_scaling = true
    min_count       = 1
    max_count       = 3
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = "Demo"
  }
}

output "resource_group_name" {
  value = azurerm_resource_group.default.name
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.default.name
}
