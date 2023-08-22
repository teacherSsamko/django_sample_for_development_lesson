terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

// Configure the ncloud provider
provider "ncloud" {
  region      = "KR"
  site        = "PUBLIC"
  support_vpc = true
}

resource "ncloud_login_key" "loginkey" {
  key_name = "test-key"
}

resource "ncloud_vpc" "test" {
  ipv4_cidr_block = "10.11.0.0/16"
}

resource "ncloud_subnet" "test" {
  vpc_no         = ncloud_vpc.test.vpc_no
  subnet         = cidrsubnet(ncloud_vpc.test.ipv4_cidr_block, 8, 1)
  zone           = "KR-2"
  network_acl_no = ncloud_vpc.test.default_network_acl_no
  subnet_type    = "PUBLIC"
  usage_type     = "GEN"
}

# data "template_file" "user_data" {
#   template = "${file("user_data.sh")}"
# }

resource "ncloud_init_script" "set_be" {
  name = "set-be"
#   content = templatefile("${path.module}/user_data.sh", {})
  content = templatefile("${path.module}/user_data.tftpl", { 
    password = var.password, 
    db_password = var.db_password
    })

#   lifecycle {
#     ignore_changes = [ 
#         content
#      ]
#   }
}

resource "ncloud_server" "server" {
  subnet_no                 = ncloud_subnet.test.id
  name                      = "tf-test-server"
  server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
  login_key_name            = ncloud_login_key.loginkey.key_name
  init_script_no = ncloud_init_script.set_be.init_script_no
}

resource "ncloud_public_ip" "public_ip" {
  server_instance_no = ncloud_server.server.instance_no
}

output "server_ip" {
  value = ncloud_public_ip.public_ip.public_ip
}
