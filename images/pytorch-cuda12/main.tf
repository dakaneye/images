terraform {
  required_providers {
    oci = { source = "chainguard-dev/oci" }
  }
}

variable "target_repository" {
  description = "The docker repo into which the image and attestations should be published."
}

module "config" {
  source         = "./config"
  extra_packages = ["torchvision-cuda12", "busybox", "bash"]
}

module "latest" {
  source             = "../../tflib/publisher"
  name               = basename(path.module)
  target_repository  = var.target_repository
  config             = module.config.config
  build-dev          = true
  check-sbom         = false # TODO(pnasrat): Re-enable SBOM check after license corrected
  extra_dev_packages = ["cuda-toolkit-12.3-dev"]
}

module "test" {
  source = "./tests"
  digest = module.latest.image_ref
}

resource "oci_tag" "latest" {
  depends_on = [module.test]
  digest_ref = module.latest.image_ref
  tag        = "latest"
}

resource "oci_tag" "latest-dev" {
  depends_on = [module.test]
  digest_ref = module.latest.dev_ref
  tag        = "latest-dev"
}
