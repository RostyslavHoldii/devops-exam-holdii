# VPC
resource "digitalocean_vpc" "main" {
  name     = "holdii-vpc"
  region   = "fra1"
  ip_range = "10.10.10.0/24"
}

# Фаєрвол
resource "digitalocean_firewall" "firewall" {
  name = "holdii-firewall"

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "8000-8003"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# Екзаменаційний бакет
resource "digitalocean_spaces_bucket" "bucket" {
  name   = "holdii-bucket"
  region = "fra1"
}

# SSH Ключ
resource "digitalocean_ssh_key" "default" {
  name       = "Holdii Exam SSH Key"
  public_key = var.ssh_public_key
}

variable "ssh_public_key" {
  type = string
}

# Віртуальна машина
resource "digitalocean_droplet" "node" {
  image    = "ubuntu-24-04-x64"
  name     = "holdii-node"
  region   = "fra1"
  size     = "s-2vcpu-4gb" 
  vpc_uuid = digitalocean_vpc.main.id
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
}

output "droplet_ip" {
  value = digitalocean_droplet.node.ipv4_address
}
