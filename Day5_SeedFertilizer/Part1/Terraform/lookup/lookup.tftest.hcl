

run "test_case_zero" {
  command = plan
  variables {
    key    = 0
    map    = []
  }
  assert {
    condition     = output.value == 0
    error_message = "should be 0 for empty"
  }
}

run "test_case_one" {
  command = plan
  variables {
    key    = 1
    map    = [{
        dest  = 50
        range = 2
        src   = 98
    }]
  }
  assert {
    condition     = output.value == 1
    error_message = "should match"
  }
}

run "test_case_two" {
  command = plan
  variables {
    key    = 98
    map    = [{
        dest  = 50
        range = 2
        src   = 98
    }]
  }
  assert {
    condition     = output.value == 50
    error_message = "should match"
  }
}


run "test_case_three" {
  command = plan
  variables {
    key    = 99
    map    = [{
        dest  = 50
        range = 2
        src   = 98
    }]
  }
  assert {
    condition     = output.value == 51
    error_message = "should match"
  }
}

run "test_case_four" {
  command = plan
  variables {
    key    = 100
    map    = [{
        dest  = 50
        range = 2
        src   = 98
    }]
  }
  assert {
    condition     = output.value == 100
    error_message = "should match"
  }
}


run "test_case_five" {
  command = plan
  variables {
    key    = 97
    map    = [{
        dest  = 50
        range = 2
        src   = 98
    }, {
        dest  = 52
        range = 48
        src   = 50
    }]
  }
  assert {
    condition     = output.value == 99
    error_message = "should match"
  }
}

run "test_case_six" {
  command = plan
  variables {
    key    = 13
    map    = [{
        dest  = 50
        range = 2
        src   = 98
    }, {
        dest  = 52
        range = 48
        src   = 50
    }]
  }
  assert {
    condition     = output.value == 13
    error_message = "should match"
  }
}

run "test_case_seven" {
  command = plan
  variables {
    key = 14
    map =  [
      {
        dest  = 0
        range = 37
        src   = 15
      },
      {
        dest  = 37
        range = 2
        src   = 52
      },
      {
        dest  = 39
        range = 15
        src   = 0
      }
    ]
  }
  assert {
    condition     = output.value == 53
    error_message = "should match"
  }  
}