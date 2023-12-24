
variable "mapsInfo" {
  description = "direct passthrough of mapsInfo after parsing input"
}

variable "seedID" {
  type = number
}

module lookup0 {
  source = "./lookup"
  key      = tonumber(var.seedID)
  map      = var.mapsInfo[0]
}

module lookup1 {
  source = "./lookup"
  key      = module.lookup0.value
  map      = var.mapsInfo[1]
}

module lookup2 {
  source = "./lookup"
  key      = module.lookup1.value
  map      = var.mapsInfo[2]
}

module lookup3 {
  source = "./lookup"
  key      = module.lookup2.value
  map      = var.mapsInfo[3]
}

module lookup4 {
  source = "./lookup"
  key      = module.lookup3.value
  map      = var.mapsInfo[4]
}

module lookup5 {
  source = "./lookup"
  key      = module.lookup4.value
  map      = var.mapsInfo[5]
}

module lookup6 {
  source = "./lookup"
  key      = module.lookup5.value
  map      = var.mapsInfo[6]
}

output "result" {
  value = module.lookup6.value
}