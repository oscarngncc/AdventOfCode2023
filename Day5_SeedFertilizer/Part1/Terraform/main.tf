variable "input" {
  description = "The plain text string of the input. If provided, will proritize this instead"
  type        = string
  default     = <<EOF
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
EOF
}

variable "input_path" {
  description = "The file path of the input_path. Note that it has lower prority than var.input_path"
  type        = string
  default     = "test_input.txt"
}

locals {
  // Abuse the fact that input string always start with seeds and the maps are already nicely sorted in order (i.e. seed-to-soil, soil-to-fertilizer, fertilizer-to-water)
  info  = compact(split("\n\n", var.input != null ? var.input : file(var.input_path)))
  seeds = regexall("[0-9]+", local.info[0])
  maps  = slice(local.info, 1, length(local.info))


  mapsInfo = [for m in local.maps: [
        for line in split("\n",m): {
            dest  = tonumber(split(" ", line)[0])
            src   = tonumber(split(" ", line)[1])  
            range = tonumber(split(" ", line)[2])
        } if !strcontains(line, "map") && line != ""
    ]
  ]
}

module lookup0 {
  source = "./lookup"
  for_each = toset(local.seeds)
  key      = tonumber(each.key)
  map      = local.mapsInfo[0]
}

module lookup1 {
  source = "./lookup"
  for_each = toset(local.seeds)
  key      = module.lookup0[each.key].value
  map      = local.mapsInfo[1]
}

module lookup2 {
  source = "./lookup"
  for_each = toset(local.seeds)
  key      = module.lookup1[each.key].value
  map      = local.mapsInfo[2]
}

module lookup3 {
  source = "./lookup"
  for_each = toset(local.seeds)
  key      = module.lookup2[each.key].value
  map      = local.mapsInfo[3]
}

module lookup4 {
  source = "./lookup"
  for_each = toset(local.seeds)
  key      = module.lookup3[each.key].value
  map      = local.mapsInfo[4]
}

module lookup5 {
  source = "./lookup"
  for_each = toset(local.seeds)
  key      = module.lookup4[each.key].value
  map      = local.mapsInfo[5]
}

module lookup6 {
  source = "./lookup"
  for_each = toset(local.seeds)
  key      = module.lookup5[each.key].value
  map      = local.mapsInfo[6]
}


output "results" {
  value = module.lookup1
}