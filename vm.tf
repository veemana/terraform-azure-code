resource "azurerm_virtual_network" "mynetwork" {
  name                = "mynetwork"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "sme-session"
}

resource   "azurerm_subnet"   "mydefault"   { 
  name   =   "default" 
  resource_group_name   =    azurerm_virtual_network.mynetwork.resource_group_name
  virtual_network_name   =   azurerm_virtual_network.mynetwork.name 
  address_prefixes   =   ["10.0.1.0/24"] 
} 

resource   "azurerm_public_ip"   "myvm1publicip"   { 
   name   =   "pip1" 
   location   =  azurerm_virtual_network.mynetwork.location
   resource_group_name   =   azurerm_virtual_network.mynetwork.resource_group_name 
   allocation_method   =   "Dynamic" 
   sku   =   "Basic" 
 } 

resource "azurerm_network_interface" "mynic" {
  name                = "mynic"
  location            = azurerm_virtual_network.mynetwork.location
  resource_group_name = azurerm_virtual_network.mynetwork.resource_group_name

  ip_configuration {
    name                          = "myipconfig"
    subnet_id                     = azurerm_subnet.mydefault.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id   =   azurerm_public_ip.myvm1publicip.id
  }
}

resource "azurerm_virtual_machine" "myvm" {
  name                  = "myvm"
  location            = azurerm_virtual_network.mynetwork.location
  resource_group_name = azurerm_virtual_network.mynetwork.resource_group_name
  network_interface_ids = [azurerm_network_interface.mynic.id]
  vm_size               = "Standard_B1s"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "myvm"
    admin_username = "adminuser"
    admin_password = "Admin@password"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

