terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.95.0"
    }
  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "learnk8sResourceGroup"
  location = "northeurope"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "learnk8scluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "learnk8scluster"

  default_node_pool { 
    name       = "default"
    node_count = "2"
    vm_size    = "standard_d2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

   provider "helm" {
    kubernetes {
      config_path = "~/.kube/config"
    }
  } 

  resource "helm_release" "nginx-ingress" {
    name = "nginx-ingress-controller"

    repository = "https://charts.bitnami.com/bitnami"
    chart = "nginx-ingress-controller"

    set{
      name = "service.type"
      value = "ClusterIP"
    } 
  }