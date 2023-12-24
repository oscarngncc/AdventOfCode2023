
variable "head" { 
    description = "id of the first seed"
    type = number
}

variable "tail" {
    description = "id of the last seed"
    type = number
}

variable "map" {
    description = "One of the seven mappings"
    type = list(object({
        src = number
        end = number
    }))
}


locals {
    // 4 possible scenario of a mapping overlapping the range between head to end: LHS match, RHS match, Inner match
    lhs_matches = [ for info in var.map: info if (info.end >= var.head && info.end < var.tail)  && info.src < var.head ]
    rhs_matches = [ for info in var.map: info if (info.src <= var.tail && info.src > var.head)  && info.end > var.tail ]
    inner_matches = [ for info in var.map: info if info.src >= var.head && info.end <= var.tail  ]

    segments0 = flatten([ for info in local.lhs_matches: [info.end+1] ]) 
    segments1 = flatten([ for info in local.rhs_matches: [info.src] ])
    segments2 = flatten([ for info in local.inner_matches: [info.src, info.end +1]  ])

    segments_raw = distinct(concat( [var.head],  try(local.segments0, []), try(local.segments1, []), try(local.segments2, []) ))
    segments_raw_string = formatlist("%030d", local.segments_raw)
    segments_sorted_string = sort(local.segments_raw_string)
    segments = [ for v in local.segments_sorted_string : tonumber(v) ]

    segmentsObj = { for index, segment in local.segments: "${segment}" => index == length(local.segments) -1 ? var.tail : local.segments[index+1] - 1  }
}

output "value" {
  description = "The corresponded value"
  //value = local.segments
  value = tomap(local.segmentsObj)
}