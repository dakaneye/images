# DO NOT EDIT - this file is autogenerated by tfgen

output "summary" {
  value = merge(
    {
      basename(path.module) = {
        "ref"    = module.apache-nifi.image_ref
        "config" = module.apache-nifi.config
        "tags"   = ["latest"]
      }
  })
}

