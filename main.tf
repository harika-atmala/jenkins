resource "azurerm_resource_group" "sb" {
  name     = "sb-rg"
  location = "West US"

}

resource "azurerm_virtual_network" "sb" {
  name                = "sbvn"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.sb.location}"
  resource_group_name = "${azurerm_resource_group.sb.name}"
}

resource "azurerm_subnet" "sb" {
  name                 = "sbsub"
  resource_group_name  = "${azurerm_resource_group.sb.name}"
  virtual_network_name = "${azurerm_virtual_network.sb.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "sb" {
  name                         = "publicip"
  location                     = "West US"
  resource_group_name          = "${azurerm_resource_group.sb.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "sb" {
  name                = "sbni"
  location            = "${azurerm_resource_group.sb.location}"
  resource_group_name = "${azurerm_resource_group.sb.name}"

  ip_configuration {
    name                          = "sbconfiguration"
    subnet_id                     = "${azurerm_subnet.sb.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${azurerm_public_ip.sb.id}"
   }
}

resource "azurerm_lb" "sb" {
  name                = "TestLoadBalancer"
  location            = "West US"
  resource_group_name = "${azurerm_resource_group.sb.name}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.sb.id}"
  }
}

resource "azurerm_managed_disk" "sb" {
  name                 = "datadisk_existing"
  location             = "${azurerm_resource_group.sb.location}"
  resource_group_name  = "${azurerm_resource_group.sb.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"
}

resource "azurerm_virtual_machine" "sb" {
  name                  = "sbvm"
  location              = "${azurerm_resource_group.sb.location}"
  resource_group_name   = "${azurerm_resource_group.sb.name}"
  network_interface_ids = ["${azurerm_network_interface.sb.id}"]
  vm_size               = "Standard_DS1_v2"


  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

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

  # Optional data disks
  storage_data_disk {
    name              = "datadisk_new"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1023"
  }

  storage_data_disk {
    name            = "${azurerm_managed_disk.sb.name}"
    managed_disk_id = "${azurerm_managed_disk.sb.id}"
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = "${azurerm_managed_disk.sb.disk_size_gb}"
  }

  os_profile {
    computer_name  = "starbucks"
    admin_username = "sainihar"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
 
resource "azurerm_virtual_machine_extension" "sb" {
  name                 = "starb"
  location             = "West US"
  resource_group_name  = "${azurerm_resource_group.sb.name}"
  virtual_machine_name = "${azurerm_virtual_machine.sb.name}"
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "CustomScriptForLinux"
  type_handler_version = "1.5"

  settings = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/vishwanihar/jenkins/master/script.sh"],
        "commandToExecute": "sudo sh script.sh"    
  
    }
SETTINGS
  }

terraform {
    backend "azure" {
        storage_account_name = "vishwa"
        container_name = "nihar"
        key = "vishwa.nihar2.tfstate"
        access_key = "1iHTCEk1xxLAomMsBrEDI7fVMm1rMesuxqptrV1GCFXKHxHXodAgfFl6JPLg4AgSvcAHfkJe4DmZ5ndXjlhySg=="
    }
}

