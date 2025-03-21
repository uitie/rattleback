resource "random_id" "rnd" {
  byte_length = 4
}

resource "google_dns_managed_zone" "uut" {
  name        = var.name
  dns_name    = var.domain == "" ? "${random_id.rnd.hex}.com." : var.domain
  description = "UUT"

  dnssec_config {
    state = "on"

    default_key_specs {
      algorithm  = "ecdsap384sha384"
      key_type   = "keySigning"
      key_length = 2048
    }

    default_key_specs {
      algorithm  = "ecdsap384sha384"
      key_type   = "zoneSigning"
      key_length = 2048
    }
  }
}
