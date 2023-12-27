

run "test_case_example" {
  command = plan
  variables {
    input = <<EOF
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
EOF
  }
  assert {
    condition     = output.result == 5905
    error_message = "should match"
  }
}

run "test_case_inspect_one" {
    command = plan
  variables {
    input = <<EOF
AAAAA 1
AAAA2 1
29292 1
AAA23 1
22443 1
AA345 1
AKQ9T 1
EOF
  }
  assert {
    condition     = local.test_hands_rating["AAAAA"] == "71414141414"
    error_message = "Five of a kind should match"
  }
  assert {
    condition     = local.test_hands_rating["AAAA2"] == "61414141402"
    error_message = "Four of a kind should match"
  }
  assert {
    condition     = local.test_hands_rating["29292"] == "50209020902"
    error_message = "Full House should match"
  }
  assert {
    condition     = local.test_hands_rating["AAA23"] == "41414140203"
    error_message = "Three of a kind should match"
  }
  assert {
    condition     = local.test_hands_rating["22443"] == "30202040403"
    error_message = "Two Pair should match"
  }
  assert {
    condition     = local.test_hands_rating["AA345"] == "21414030405"
    error_message = "One Pair should match"
  }
  assert {
    condition     = local.test_hands_rating["AKQ9T"] == "11413120910"
    error_message = "High card should match"
  }
}

run "test_case_inspect_joker" {
    command = plan
  variables {
    input = <<EOF
JJJJJ 1
JJJJ3 1
JJJ87 1
JJ345 1
J2345 1
EOF
  }
  assert {
    condition     = local.test_hands_rating["JJJJJ"] == "70000000000"
    error_message = "Five of a kind should match"
  }
  assert {
    condition     = local.test_hands_rating["JJJJ3"] == "70000000003"
    error_message = "Five of a kind should match"
  }
  assert {
    condition     = local.test_hands_rating["JJJ87"] == "60000000807"
    error_message = "Five of a kind should match"
  }
  assert {
    condition     = local.test_hands_rating["JJ345"] == "40000030405"
    error_message = "Five of a kind should match"
  }
  assert {
    condition     = local.test_hands_rating["J2345"] == "20002030405"
    error_message = "Five of a kind should match"
  }
}