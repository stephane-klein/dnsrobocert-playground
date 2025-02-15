terraform {
  required_providers {
    powerdns = {
      source = "pan-net/powerdns"
    }
  }
}

variable "powerdns_ip" {
  description = "Powerdns IP address"
  type        = string
}

provider "powerdns" {
    api_key    = "password"
    server_url = "http://${var.powerdns_ip}:8081"
}

resource "powerdns_zone" "playground_stephane_klein_info" {
    name        = "playground.stephane-klein.info."
    kind        = "Native"
}

resource "powerdns_record" "test1" {
    zone    = powerdns_zone.playground_stephane_klein_info.name
    name    = "test1.playground.stephane-klein.info."
    type    = "A"
    ttl     = 300
    records = ["192.168.0.11"]
}
