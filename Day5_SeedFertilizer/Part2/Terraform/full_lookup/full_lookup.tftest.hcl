variables {
  mapsInfo = [
        [
            {
            "dest": 50,
            "range": 2,
            "src": 98
            },
            {
            "dest": 52,
            "range": 48,
            "src": 50
            }
        ],
        [
            {
            "dest": 0,
            "range": 37,
            "src": 15
            },
            {
            "dest": 37,
            "range": 2,
            "src": 52
            },
            {
            "dest": 39,
            "range": 15,
            "src": 0
            }
        ],
        [
            {
            "dest": 49,
            "range": 8,
            "src": 53
            },
            {
            "dest": 0,
            "range": 42,
            "src": 11
            },
            {
            "dest": 42,
            "range": 7,
            "src": 0
            },
            {
            "dest": 57,
            "range": 4,
            "src": 7
            }
        ],
        [
            {
            "dest": 88,
            "range": 7,
            "src": 18
            },
            {
            "dest": 18,
            "range": 70,
            "src": 25
            }
        ],
        [
            {
            "dest": 45,
            "range": 23,
            "src": 77
            },
            {
            "dest": 81,
            "range": 19,
            "src": 45
            },
            {
            "dest": 68,
            "range": 13,
            "src": 64
            }
        ],
        [
            {
            "dest": 0,
            "range": 1,
            "src": 69
            },
            {
            "dest": 1,
            "range": 69,
            "src": 0
            }
        ],
        [
            {
            "dest": 60,
            "range": 37,
            "src": 56
            },
            {
            "dest": 56,
            "range": 4,
            "src": 93
            }
        ]
    ]
}

run "test_case_one" {
    variables {
        seedID = 79
    }
    assert {
        condition = output.result == 82
        error_message = "should match!"
    }
}

run "test_case_two" {
    variables {
        seedID = 14
    }
    assert {
        condition = output.result == 43
        error_message = "should match!"
    }
}

run "test_case_three" {
    variables {
        seedID = 55
    }
    assert {
        condition = output.result == 86
        error_message = "should match!"
    }
}

run "test_case_four" {
    variables {
        seedID = 13
    }
    assert {
        condition = output.result == 35
        error_message = "should match!"
    }
}