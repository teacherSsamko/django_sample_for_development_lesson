terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = "2.6.0"
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

provider "ssh" {
  # Configuration options
}


resource "ncloud_login_key" "loginkey" {
  key_name = "ssh-test-key"
}

data "ncloud_vpc" "default" {
  id = 41404
}

resource "ncloud_subnet" "test" {
  vpc_no         = data.ncloud_vpc.default.vpc_no
  subnet         = cidrsubnet(data.ncloud_vpc.default.ipv4_cidr_block, 8, 4)
  zone           = "KR-2"
  network_acl_no = data.ncloud_vpc.default.default_network_acl_no
  subnet_type    = "PUBLIC"
  usage_type     = "GEN"
}

resource "ncloud_init_script" "set_be" {
  name = "set-be-ssh"
  content = templatefile("${path.module}/user_data.tftpl", {
    password    = var.password,
    db_password = var.db_password
  })
}

resource "ncloud_server" "server" {
  subnet_no                 = ncloud_subnet.test.id
  name                      = "ssh-server"
  server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
  login_key_name            = ncloud_login_key.loginkey.key_name
  init_script_no            = ncloud_init_script.set_be.init_script_no
}

resource "ncloud_public_ip" "public_ip" {
  server_instance_no = ncloud_server.server.instance_no
}
