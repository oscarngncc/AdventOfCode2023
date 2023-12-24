run "test_case_zero" {
  command = plan
  variables {
    input = <<EOF
seeds: 10

seed-to-soil map:

soil-to-fertilizer map:

fertilizer-to-water map:

water-to-light map:

light-to-temperature map:

temperature-to-humidity map:

humidity-to-location map:

EOF
  }
  assert {
    condition     = output.result == 10
    error_message = "should be 10 when going through empty maps"
  }
}


run "test_case_one" {
  command = plan
  variables {
    input = <<EOF
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
  assert {
    condition     = output.result == 35
    error_message = "should be 35 as the example suggest!"
  }
}


run "test_case_ninety_nine" {
  command = plan
  variables {
    input = <<EOF
seeds: 90 91 92 93 94 95 96 97 98 99 100

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