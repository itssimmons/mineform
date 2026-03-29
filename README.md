# Mineform

A collection of Minecraft server templates paired with **Terraform** (IaC) for fully automated provisioning on **Google Cloud Platform**.

## Repository Structure

```
mineform/
├── 📂 ci/
│   └── 📂 scripts/
│       └── ⚙️ start.sh              # Server start script (Aikar's JVM flags)
├── 📂 docs/                        # Additional documentation
├── 📂 plugins/                     # Bukkit/Paper plugin JARs
├── 📂 terraform/                   # GCP infrastructure (IaC)
│   ├── 📂 environments/            # Environment-specific configurations
│   │   └── 📂 prod/
│   │       ├── 📄 main.tf          # Root module composition
│   │       ├── 📄 variables.tf     # Input variables
│   │       ├── 📄 outputs.tf       # Outputs
│   │       ├── 📄 provider.tf      # Provider configuration
│   │       └── 📄 terraform.tfvars # Environment values
│   │
│   └── 📂 modules/                 # Reusable Terraform modules
│       ├── 📂 compute/
│       ├── 📂 network/
│       ├── 📂 firewall/
│       └── 📂 ...
├── 📄 eula.txt                     # Minecraft EULA acceptance
└── 🚀 run.sh                       # Paper server startup entrypoint
```

## Prerequisites

| Tool       | Version |
|------------|---------|
| Terraform  | 1.5+    |
| gcloud CLI | latest  |

## Getting Started

### 1. Provision Infrastructure

```bash
cd terraform/environments/prod
terraform init
terraform plan -out=tfplan
terraform apply "tfplan"
```

> All GCP resources are tagged with `project = "itssimmons-mineform"`.  
> Remote state is stored in a GCS bucket — never commit `.tfstate` locally.

### 2. Start the Server

```bash
sudo systemctl enable minecraft-bootstap
```

> [!IMPORTANT]
> There is no need to execute any commands on the server; the startup scripts shall attend to all necessary preparations. You need only wait a few minutes before the server becomes available for connection.

## Configuration

- **Port:** `25565` (default)
- **EULA:** Accepted in `eula.txt`
- **Plugins:** Drop JARs into `plugins/`
- **Server config:** `server.properties`, `bukkit.yml`, `spigot.yml`, `paper-global.yml` (generated at runtime, not tracked in git)
- **Offline Mode** false

## Infrastructure Overview

The `terraform/` directory manages the following modules:

- **Compute** — GCP Compute Engine VM instance
- **Networking** — VPC, firewall rules (port 25565 TCP/UDP)
- **Storage** — GCS bucket for Terraform remote state and world backups

> [!WARNING]
>  ⚠️ Do not modify GCP resources manually. All changes must go through `terraform plan` / `terraform apply`.

## Secrets & Credentials

Sensitive values (GCP service account keys, RCON passwords, etc.) are **never committed**. Use:

- `.gitignore` to exclude local credential files
- GCP Secret Manager for runtime secrets
- Environment variables for CI/CD pipelines

## Contributing

Any kind of collaboration is most welcome. Before anything, please review the following resources:

- [CONTRIBUTING.md](CONTRIBUTING.md) — Guidelines for contributing to the project  
- [PULL_REQUEST_TEMPLATE.md](PULL_REQUEST_TEMPLATE.md) — Instructions and checklist for submitting pull requests  
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) — Expected standards for community behavior (if applicable) 

## License

MIT © [Simón Villafañe](LICENSE)
