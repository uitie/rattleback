resource "random_id" "rnd" {
  byte_length = 4
}

resource "google_dns_managed_zone" "uut" {
  name        = var.name
  dns_name    = var.domain == "" ? "${random_id.rnd.hex}.com." : var.domain
  description = "UUT"

  dnssec_config {
    # kind = "dns#managedZoneDnsSecConfig"
    state = "on"
  }
}
