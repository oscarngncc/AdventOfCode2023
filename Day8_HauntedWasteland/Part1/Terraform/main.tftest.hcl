
run "test_case_example_one" {
  command = plan
  variables {
    input = <<EOF
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
EOF
  }
  assert {
    condition     = tonumber(output.result) == 6
    error_message = "should match"
  }
}


run "test_case_example_two" {
  command = plan
  variables {
    input = <<EOF
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
EOF
  }
  assert {
    condition     = tonumber(output.result) == 2
    error_message = "should match"
  }
}