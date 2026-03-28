# terra-minecraft

A **Paper 1.20.4** Minecraft server paired with **Terraform** infrastructure-as-code for fully automated provisioning on **Google Cloud Platform (GCP)**.

---

## Repository Structure

```
terra-minecraft/
├── ci/
│   └── scripts/
│       └── start.sh        # Server start script (Aikar's JVM flags)
├── docs/                   # Additional documentation
├── plugins/                # Bukkit/Paper plugin JARs
├── terraform/              # GCP infrastructure (compute, networking, storage)
├── eula.txt                # Minecraft EULA acceptance
└── paper-1.20.4-499.jar    # Paper server JAR
```

---

## Prerequisites

| Tool | Version |
|------|---------|
| Java | 17+ |
| Terraform | 1.5+ |
| gcloud CLI | latest |

---

## Getting Started

### 1. Provision Infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

> All GCP resources are tagged with `project = "terra-minecraft"`.  
> Remote state is stored in a GCS bucket — never commit `.tfstate` locally.

### 2. Start the Server

```bash
bash ci/scripts/start.sh
```

The start script uses [Aikar's JVM flags](https://aikar.co/mcflags.html) tuned for G1GC with 2 GB minimum and 4 GB maximum heap.

---

## Configuration

- **Port:** `25565` (default)
- **EULA:** Accepted in `eula.txt`
- **Plugins:** Drop JARs into `plugins/`
- **Server config:** `server.properties`, `bukkit.yml`, `spigot.yml`, `paper-global.yml` (generated at runtime, not tracked in git)

---

## Infrastructure Overview

The `terraform/` directory manages:

- **Compute** — GCP Compute Engine VM instance
- **Networking** — VPC, firewall rules (port 25565 TCP/UDP)
- **Storage** — GCS bucket for Terraform remote state and world backups

> ⚠️ Do not modify GCP resources manually. All changes must go through `terraform plan` / `terraform apply`.

---

## Secrets & Credentials

Sensitive values (GCP service account keys, RCON passwords, etc.) are **never committed**. Use:

- `.gitignore` to exclude local credential files
- GCP Secret Manager for runtime secrets
- Environment variables for CI/CD pipelines

---

## License

MIT © [Simon Villafane](LICENSE)
