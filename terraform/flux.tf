# ==========================================
# Bootstrap Flux Operator
# ==========================================
resource "helm_release" "flux_operator" {
  depends_on = [kind_cluster.this]

  name             = "flux-operator"
  namespace        = "flux-system"
  repository       = "oci://ghcr.io/controlplaneio-fluxcd/charts"
  chart            = "flux-operator"
  create_namespace = true
}

# ==========================================
# Bootstrap Flux Instance
# ==========================================
resource "helm_release" "flux_instance" {
  depends_on = [helm_release.flux_operator]

  name       = "flux-instance"
  namespace  = "flux-system"
  repository = "oci://ghcr.io/controlplaneio-fluxcd/charts"
  chart      = "flux-instance"
  set {
    name  = "distribution.version"
    value = "=2.5.x"
  }
}

# ==========================================
# Create GitHub repository for Flux manifests and Helm chart
# ==========================================
module "github_repo" {
  source      = "github.com/den-vasyliev/tf-github-repository"
  name        = "tbot"
  description = "Repo for FluxCD manifests and Helm chart for tbot"
  visibility  = "private"
  topics      = ["fluxcd", "kubernetes", "terraform"]
}

# ==========================================
# Bootstrap FluxCD in the cluster and connect to GitHub repo
# ==========================================
module "flux_bootstrap" {
  source            = "github.com/den-vasyliev/tf-fluxcd-flux-bootstrap"
  cluster_type      = "kind"
  github_token      = var.github_token
  github_repository = module.github_repo.name
  github_owner      = var.github_owner
}

# ==========================================
# Generate TLS keys for secure communication
# ==========================================
module "tls_keys" {
  source = "github.com/den-vasyliev/tf-hashicorp-tls-keys"
  # You can specify variables if needed, e.g. key_algorithm, key_size
}