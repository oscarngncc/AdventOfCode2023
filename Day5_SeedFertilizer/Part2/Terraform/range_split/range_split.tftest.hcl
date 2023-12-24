
run "test_case_zero" {
  command = plan
  variables {
    head   = 1
    tail   = 10
    map    = []
  }
  assert {
    condition     = output.value == tomap({ 
      "1": 10 
    })
    error_message = "should match"
  }
}


run "test_case_inner" {
  command = plan
  variables {
    head   = 1
    tail   = 10
    map    = [{src: 3, end:5}]
  }
  assert {
    condition     = output.value == tomap({ 
      "1": 2
      "3": 5
      "6": 10
    })
    error_message = "should match"
  }
}



run "test_case_lhs" {
  command = plan
  variables {
    head   = 1
    tail   = 10
    map    = [{src: 0, end:2}]
  }
  assert {
    condition     = output.value == tomap({ 
      "1": 2
      "3": 10
    })
    error_message = "should match"
  }
}

run "test_case_rhs" {
  command = plan
  variables {
    head   = 1
    tail   = 10
    map    = [{src: 6, end:15}]
  }
  assert {
    condition     = output.value == tomap({ 
      "1": 5
      "6": 10
    })
    error_message = "should match"
  }
}

run "test_case_lhs_rhs" {
  command = plan
  variables {
    head   = 1
    tail   = 10
    map    = [{src: 0, end:2}, {src: 6, end:15}]
  }
  assert {
    condition     = output.value == tomap({ 
      "1": 2
      "3": 5
      "6": 10
    })
    error_message = "should match"
  }
}


run "test_case_lhs_rhs_inner" {
  command = plan
  variables {
    head   = 1
    tail   = 10
    map    = [{src: 0, end:2}, {src: 3, end:4}, {src: 8, end:15}]
  }
  assert {
    condition     = output.value == tomap({ 
      "1": 2
      "3": 4
      "5": 7
      "8": 10
    })
    error_message = "should match"
  }
}


run "test_case_outer" {
  command = plan
  variables {
    head = 1
    tail = 10
    map  = [{src: 0, end: 21}]
  }
  assert {
    condition     = output.value == tomap({ 
      "1": 10
    })
    error_message = "should match"
  }
}

run "test_case_singular" {
  command = plan
  variables {
    head = 90
    tail = 100
    map  = [{src: 91, end: 95}]
  }
  assert {
    condition     = output.value == tomap({ 
      "90": 90
      "91": 95
      "96": 100
    })
    error_message = "should match"
  }
}