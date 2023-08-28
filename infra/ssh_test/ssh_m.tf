resource "ssh_resource" "init" {
  depends_on = [ncloud_server.server]

  when = "create"

  host     = ncloud_public_ip.public_ip.public_ip
  user     = "lion"
  password = "dmstjq11"

  # Try to complete in at most 15 minutes and wait 5 seconds between retries
  timeout     = "1m"
  retry_delay = "3s"

  file {
    source      = "${path.module}/set_db_server.sh"
    destination = "/tmp/hello.sh"
    permissions = "0700"
  }

  file {
    source      = "${path.module}/db.env"
    destination = ".env"
    permissions = "0777"
  }

  commands = [
    "/tmp/hello.sh"
  ]
}
