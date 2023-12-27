

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
    condition     = output.result == 6440
    error_message = "should match"
  }
}


run "test_case_zero" {
  command = plan
  variables {
    input = <<EOF
EOF
  }
  assert {
    condition     = output.result == 0
    error_message = "should match"
  }
}


run "test_case_one" {
  command = plan
  variables {
    input = <<EOF
AAAAA 1000
EOF
  }
  assert {
    condition     = output.result == 1000
    error_message = "should match"
  }
}


run "test_case_two" {
  command = plan
  variables {
    input = <<EOF
AAAAA 1000
AAQAA 2000
EOF
  }
  assert {
    condition     = output.result == 4000
    error_message = "should match"
  }
}

run "test_case_three" {
  command = plan
  variables {
    input = <<EOF
JJJJ2 1000
2AAAA 2000
EOF
  }
  assert {
    condition     = output.result == 4000
    error_message = "should match"
  }
}

run "test_case_four" {
  command = plan
  variables {
    input = <<EOF
KJ3A2 17
JQ472 72
QT3J2 19
12345 23
EOF
  }
  assert {
    condition     = output.result == 292
    error_message = "should match"
  }
}

run "test_case_five" {
  command = plan
  variables {
    input = <<EOF
2345A 1
Q2KJJ 13
Q2Q2Q 19
T3T3J 17
T3Q33 11
2345J 3
J345A 2
32T3K 5
T55J5 29
KK677 7
KTJJT 34
QQQJA 31
JJJJJ 37
JAAAA 43
AAAAJ 59
AAAAA 61
2AAAA 23
2JJJJ 53
JJJJ2 41
EOF
  }
  assert {
    condition     = output.result == 6592
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
AKQJT 1
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
    condition     = local.test_hands_rating["AKQJT"] == "11413121110"
    error_message = "High card should match"
  }
}