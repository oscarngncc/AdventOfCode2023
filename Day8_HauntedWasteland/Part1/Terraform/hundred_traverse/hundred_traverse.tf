
variable "instruction" {}
variable "nodes" {}
variable "c" {}


module "traverse1" {
  source = "./ten_traverse"
  instruction = var.instruction
  nodes = var.nodes
  c = var.c
}

module "traverse2" {
  source = "./ten_traverse"
  instruction = var.instruction
  nodes = var.nodes
  c = module.traverse1.c
}

module "traverse3" {
  source = "./ten_traverse"
  instruction = var.instruction
  nodes = var.nodes
  c = module.traverse2.c
}

module "traverse4" {
  source = "./ten_traverse"
  instruction = var.instruction
  nodes = var.nodes
  c = module.traverse3.c
}

module "traverse5" {
  source = "./ten_traverse"
  instruction = var.instruction
  nodes = var.nodes
  c = module.traverse4.c
}

module "traverse6" {
  source = "./ten_traverse"
  instruction = var.instruction
  nodes = var.nodes
  c = module.traverse5.c
}

module "traverse7" {
  source = "./ten_traverse"
  instruction = var.instruction
  nodes = var.nodes
  c = module.traverse6.c
}

module "traverse8" {
  source = "./ten_traverse"
  instruction = var.instruction
  nodes = var.nodes
  c = module.traverse7.c
}

module "traverse9" {
  source = "./ten_traverse"
  instruction = var.instruction
  nodes = var.nodes
  c = module.traverse8.c
}

module "traverse10" {
  source = "./ten_traverse"
  instruction = var.instruction
  nodes = var.nodes
  c = module.traverse9.c
}


output "c" { value = module.traverse10.c }