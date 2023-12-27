variable "input" {
  description = "The plain text string of the input. If provided, will proritize this instead"
  type        = string
  default     = null
}

variable "input_path" {
  description = "The file path of the input_path. Note that it has lower prority than var.input_path"
  type        = string
  default     = "test_input.txt"
}


locals {
    input    = compact(split("\n", var.input != null ? var.input : file(var.input_path)))
    hands  =  [ for properties in local.input : {
        cards: split("", split(" ", properties)[0])
        bid:   split(" ", properties)[1]
    }]

    hands_rating = [ for hand in local.hands: {
        cards  = hand.cards,
        bid   = hand.bid,
        rating = tonumber((
            length(distinct(hand.cards)) == 1 ? 70000000000 :    // Five of a kind
            length(distinct(hand.cards)) == 2 && (
                length(replace( join("", hand.cards),  distinct(hand.cards)[0], "")) == 1 ||
                length(replace( join("", hand.cards),  distinct(hand.cards)[1], "")) == 1                
            ) ? 60000000000  :                                   // four of a kind
            length(distinct(hand.cards)) == 2 ? 50000000000  :     // Full House
            length(distinct(hand.cards)) == 3 && (         // Three of a kind
                length(replace( join("", hand.cards),  distinct(hand.cards)[0], "")) == 2 ||
                length(replace( join("", hand.cards),  distinct(hand.cards)[1], "")) == 2 ||
                length(replace( join("", hand.cards),  distinct(hand.cards)[2], "")) == 2) ?  40000000000  :
            length(distinct(hand.cards)) == 3 ? 30000000000  :     // Two pair
            length(distinct(hand.cards)) == 4 ? 20000000000  :     // One pair
            10000000000       // High card
        )) + tonumber(join("", [
            "${ hand.cards[0] == "A" ? 14 : hand.cards[0] == "K" ? 13 : hand.cards[0] == "Q" ? 12 : hand.cards[0] == "J" ? 11 : hand.cards[0] == "T" ? 10 : format("%02d",hand.cards[0]) }",
            "${ hand.cards[1] == "A" ? 14 : hand.cards[1] == "K" ? 13 : hand.cards[1] == "Q" ? 12 : hand.cards[1] == "J" ? 11 : hand.cards[1] == "T" ? 10 : format("%02d",hand.cards[1]) }",
            "${ hand.cards[2] == "A" ? 14 : hand.cards[2] == "K" ? 13 : hand.cards[2] == "Q" ? 12 : hand.cards[2] == "J" ? 11 : hand.cards[2] == "T" ? 10 : format("%02d",hand.cards[2]) }",
            "${ hand.cards[3] == "A" ? 14 : hand.cards[3] == "K" ? 13 : hand.cards[3] == "Q" ? 12 : hand.cards[3] == "J" ? 11 : hand.cards[3] == "T" ? 10 : format("%02d",hand.cards[3]) }",
            "${ hand.cards[4] == "A" ? 14 : hand.cards[4] == "K" ? 13 : hand.cards[4] == "Q" ? 12 : hand.cards[4] == "J" ? 11 : hand.cards[4] == "T" ? 10 : format("%02d",hand.cards[4]) }",
        ]))
    }]

    unsorted_rating_string = [ for r in local.hands_rating[*].rating: format("%013d", r) ]
    sorted_rating_values  = reverse([ for r in sort(local.unsorted_rating_string) : tonumber(r) ])
    sorted_hands_rating = flatten(
        [ for value in local.sorted_rating_values: [
                for hand in local.hands_rating: hand if value == hand.rating
            ] 
        ]
    )

    // for testing only
    test_hands_rating = { for hand in distinct(local.sorted_hands_rating): join("", hand.cards) => tostring(hand.rating)  }

    result = try(sum([
        for index, hand in local.sorted_hands_rating: (length(local.sorted_hands_rating) - index) * hand.bid
    ]), 0)
}

output "result" {
  value = local.result
  description = "The total winning of camel card game"
}