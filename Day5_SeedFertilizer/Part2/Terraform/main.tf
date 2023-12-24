

variable "input" {
  description = "The plain text string of the input. If provided, will proritize this instead"
  type        = string
  default     = null
}

variable "input_path" {
  description = "The file path of the input_path. Note that it has lower prority than var.input_path"
  type        = string
  default     = "test_input.txt"
}

variable "tmpSeedsInfo" {
  description = "a variable to record previous temporary seed info result"
  default     = null
}
variable "minima" {
  description = "a variable to record previous temporary seed info result"
  default     = []
}


locals {
  // Abuse the fact that input string always start with seeds and the 7 maps are already nicely sorted in order (i.e. seed-to-soil, soil-to-fertilizer, fertilizer-to-water)
  info  = compact(split("\n\n", var.input != null ? var.input : file(var.input_path)))
  seeds = regexall("[0-9]+ [0-9]+", local.info[0])
  maps  = slice(local.info, 1, length(local.info))

  //head: end, (i.e. element of starting seed id 123 with range 10 ends up being 123:132 here)
  seedsInfo = var.tmpSeedsInfo != null ? var.tmpSeedsInfo : {for seed in local.seeds: split(" ", seed)[0] => tonumber(split(" ", seed)[0]) + tonumber(split(" ", seed)[1] -1)}

  mapsInfo = [for m in local.maps: [
        for line in split("\n",m): {
            dest  = tonumber(split(" ", line)[0])
            src   = tonumber(split(" ", line)[1])  
            range = tonumber(split(" ", line)[2])
            end   = tonumber(split(" ", line)[1]) + tonumber(split(" ", line)[2]) - 1
        } if !strcontains(line, "map") && line != ""
    ]
  ]
}

module "range_split0" {
  source   = "./range_split"
  for_each = local.seedsInfo
  head     = each.key
  tail     = each.value
  map      = local.mapsInfo[0]
}


module "range_split1" {
  source   = "./range_split"
  for_each = merge(values(module.range_split0)[*].value...)
  head     = each.key
  tail     = each.value
  map      = local.mapsInfo[1]
}


module "range_split2" {
  source   = "./range_split"
  for_each = merge(values(module.range_split1)[*].value...)
  head     = each.key
  tail     = each.value
  map      = local.mapsInfo[2]
}

module "range_split3" {
  source   = "./range_split"
  for_each = merge(values(module.range_split2)[*].value...)
  head     = each.key
  tail     = each.value
  map      = local.mapsInfo[3]
}

module "range_split4" {
  source   = "./range_split"
  for_each = merge(values(module.range_split3)[*].value...)
  head     = each.key
  tail     = each.value
  map      = local.mapsInfo[4]
}

module "range_split5" {
  source   = "./range_split"
  for_each = merge(values(module.range_split4)[*].value...)
  head     = each.key
  tail     = each.value
  map      = local.mapsInfo[5]
}

module "range_split6" {
  source   = "./range_split"
  for_each = merge(values(module.range_split5)[*].value...)
  head     = each.key
  tail     = each.value
  map      = local.mapsInfo[6]
}

locals {
  range_split_seed_info = merge(values(module.range_split6)[*].value...)
}


module "full_lookup_head" {
    for_each = local.range_split_seed_info
    source = "./full_lookup"
    mapsInfo = local.mapsInfo
    seedID = tonumber(each.key)
}


module "full_lookup_end" {
    for_each = local.range_split_seed_info
    source = "./full_lookup"
    mapsInfo = local.mapsInfo
    seedID = tonumber(each.value)
}


locals {
    // A binary-search like approach that assumes the following:
    // If the range is directly proportional (e.g. 100 to 200 seeds maps to 300 to 400 location), we optimize it to exactly seed number 100 only since we care about the lowest location
    // Otherwise, do a middle split and recursively run the equation until head = end
    //
    // The above assumption stays true because we didn't just input the seeds info, but all possible splits after traversing the paths
    rawBinarySplitSeedInfo = merge([ for head,end in local.range_split_seed_info: 
        tonumber(module.full_lookup_end[head].result) - tonumber(module.full_lookup_head[head].result) == tonumber(end) - tonumber(head) ? tomap({"${head}" : head}) :
        tomap({ "${head}" : tonumber( floor( (tonumber(head) + end) / 2 )), tostring( floor( (tonumber(head) + end) / 2 )  ) : end   })
    ]...)

    minima = concat(var.minima, [ for head,end in local.rawBinarySplitSeedInfo: head if tonumber(head) == tonumber(end) || tonumber(end) - tonumber(head) == 1  ])
    binarySplitSeedInfo = { for head,end in local.rawBinarySplitSeedInfo: head => end if tonumber(head) != tonumber(end) && tonumber(end) - tonumber(head) != 1   }
}


// When this file get replaced, it will also recycle previous `.auto.tfvars.json`
resource "local_file" "temp_seeds_info" {
  content  = jsonencode(merge(
    try(jsondecode(file("${path.module}/*.auto.tfvars.json")), {}),
    { "tmpSeedsInfo": local.binarySplitSeedInfo, "minima": local.minima }
  ))
  filename = "${path.module}/tmp.auto.tfvars.json"
}


module "result" {
    for_each =  local.binarySplitSeedInfo == {} ? toset(local.minima) : toset([])
    source = "./full_lookup"
    mapsInfo = local.mapsInfo
    seedID = tonumber(each.key)
}


output "minima" {
value = local.minima
}

output "current" {
value = local.binarySplitSeedInfo
}


output "result" {
  value = try(min([ for item in values(module.result): tonumber(item.result) ]...), "cannot obtain result yet")
}
