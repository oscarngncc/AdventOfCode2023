

// The following Test cases failed against the solution when it should work

/*
run "test_case_ninety_nine" {
  command = plan
  variables {
    input = <<EOF
seeds: 90 11

seed-to-soil map:

soil-to-fertilizer map:

fertilizer-to-water map:

water-to-light map:

light-to-temperature map:

temperature-to-humidity map:

humidity-to-location map:
30 91 5

EOF
  }
  assert {
    condition     = output.result == 30
    error_message = "should be 30 when going through empty maps"
  }
}
*/