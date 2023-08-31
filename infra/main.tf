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

resource "ncloud_login_key" "loginkey" {
  key_name = "test-key"
}

data "ncloud_vpc" "default" {
  id = 41404
}

resource "ncloud_subnet" "test" {
  vpc_no         = data.ncloud_vpc.default.vpc_no
  subnet         = cidrsubnet(data.ncloud_vpc.default.ipv4_cidr_block, 8, 3)
  zone           = "KR-2"
  network_acl_no = data.ncloud_vpc.default.default_network_acl_no
  subnet_type    = "PUBLIC"
  usage_type     = "GEN"
}

resource "ncloud_init_script" "set_be" {
  name = "set-be"
  content = templatefile("${path.module}/user_data.tftpl", {
    password    = var.password,
    db_password = var.db_password
  })
}

resource "ncloud_server" "server" {
  subnet_no                 = ncloud_subnet.test.id
  name                      = "k8s-server"
  server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
  login_key_name            = ncloud_login_key.loginkey.key_name
  init_script_no            = ncloud_init_script.set_be.init_script_no
}

resource "ncloud_public_ip" "public_ip" {
  server_instance_no = ncloud_server.server.instance_no
}

output "server_ip" {
  value = ncloud_public_ip.public_ip.public_ip
}


## k8s

# resource "ncloud_subnet" "subnet" {
#   vpc_no         = data.ncloud_vpc.default.id
#   subnet         = "10.0.1.0/24"
#   zone           = "KR-1"
#   network_acl_no = data.ncloud_vpc.default.default_network_acl_no
#   subnet_type    = "PRIVATE"
#   name           = "subnet-01"
#   usage_type     = "GEN"
# }

# resource "ncloud_subnet" "subnet_lb" {
#   vpc_no         = data.ncloud_vpc.default.id
#   subnet         = "10.0.100.0/24"
#   zone           = "KR-1"
#   network_acl_no = data.ncloud_vpc.default.default_network_acl_no
#   subnet_type    = "PRIVATE"
#   name           = "subnet-lb"
#   usage_type     = "LOADB"
# }


# data "ncloud_nks_versions" "version" {
#   filter {
#     name   = "value"
#     values = ["1.25.8"]
#     regex  = true
#   }
# }


# resource "ncloud_nks_cluster" "cluster" {
#   cluster_type         = "SVR.VNKS.STAND.C002.M008.NET.SSD.B050.G002"
#   k8s_version          = data.ncloud_nks_versions.version.versions.0.value
#   login_key_name       = ncloud_login_key.loginkey.key_name
#   name                 = "sample-cluster"
#   lb_private_subnet_no = ncloud_subnet.subnet_lb.id
#   kube_network_plugin  = "cilium"
#   subnet_no_list       = [ncloud_subnet.subnet.id]
#   vpc_no               = data.ncloud_vpc.default.id
#   zone                 = "KR-1"
#   log {
#     audit = true
#   }
# }


# data "ncloud_server_image" "image" {
#   filter {
#     name   = "product_name"
#     values = ["ubuntu-20.04"]
#   }
# }

# data "ncloud_server_product" "product" {
#   server_image_product_code = data.ncloud_server_image.image.product_code

#   filter {
#     name   = "product_type"
#     values = ["STAND"]
#   }

#   filter {
#     name   = "cpu_count"
#     values = [2]
#   }

#   filter {
#     name   = "memory_size"
#     values = ["8GB"]
#   }

#   filter {
#     name   = "product_code"
#     values = ["SSD"]
#     regex  = true
#   }
# }

# resource "ncloud_nks_node_pool" "node_pool" {
#   cluster_uuid   = ncloud_nks_cluster.cluster.uuid
#   node_pool_name = "sample-node-pool"
#   node_count     = 1
#   product_code   = data.ncloud_server_product.product.product_code
#   subnet_no_list = [ncloud_subnet.subnet.id]
#   autoscale {
#     enabled = true
#     min     = 1
#     max     = 1
#   }
# }
