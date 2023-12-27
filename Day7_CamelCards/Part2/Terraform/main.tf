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
    
    hands0  = [ for properties in local.input : {
        cards: split("", split(" ", properties)[0])
        bid:   split(" ", properties)[1]
        joker: length(regexall("J", split(" ", properties)[0]))
        // cards without joker. We don't care order here so just sort it as well
        cards_wj: sort(split("", replace(split(" ", properties)[0], "J", "")))
    }]
    hands1 = [ for hand in local.hands0: merge(hand, {
        match_five: [ for card in distinct(hand.cards_wj): card if length(regexall("[${card}]{5}", join("", hand.cards_wj) )) > 0 ]
        match_four: [ for card in distinct(hand.cards_wj): card if length(regexall("[${card}]{4}", join("", hand.cards_wj))) > 0 ]
        match_three: [ for card in distinct(hand.cards_wj): card if length(regexall("[${card}]{3}",join("", hand.cards_wj))) > 0 ]
        match_two: [ for card in distinct(hand.cards_wj): card if length(regexall("[${card}]{2}", join("", hand.cards_wj))) > 0 ]
    })]
    hands2 = [ for hand in local.hands1: merge(hand, {
        // max count appearance of a card, without joker
        max_count_wj = tonumber((
            length(hand.match_five) != 0 ? 5 : 
            length(hand.match_four) != 0 ? 4 :
            length(hand.match_three) != 0 ? 3 :
            length(hand.match_two) != 0 ? 2 :
            1
        ))
    })]
    hands = [ for index, hand in local.hands2: merge(hand, {
        // second max appearance of a card without joker
        second_max_count_wj = (
            length(hand.match_five)  >= 2 ? 5 : 
            length(hand.match_four)  >= 2 ? 4 :
            length(hand.match_three) >= 2 ? 3 :
            length(hand.match_two)   >= 2 ? 2 :
            1
        )
    })]



  hands_rating = [ for hand in local.hands: {
      cards  = hand.cards,
      bid   = hand.bid,
      rating = tonumber((
          hand.joker == 5 ? 70000000000 : // Five of a kind, joker edge case
          hand.joker + hand.max_count_wj == 5 ? 70000000000 :    // Five of a kind
          hand.joker + hand.max_count_wj == 4 ? 60000000000  :   // four of a kind
          hand.joker + hand.max_count_wj == 3 && hand.second_max_count_wj == 2 ? 50000000000  :  // Full House
          hand.joker + hand.max_count_wj == 3 ?  40000000000  : // Three of a kind
          hand.max_count_wj == 2 && hand.second_max_count_wj == 2 ? 30000000000  :     // Two pair, Note that wildcard don't optimize to this in any scenario
          hand.joker + hand.max_count_wj == 2 ? 20000000000  :     // One pair
          10000000000       // High card
      )) + tonumber(join("", [
          "${ hand.cards[0] == "A" ? 14 : hand.cards[0] == "K" ? 13 : hand.cards[0] == "Q" ? 12 : hand.cards[0] == "J" ? "00" : hand.cards[0] == "T" ? 10 : format("%02d",hand.cards[0]) }",
          "${ hand.cards[1] == "A" ? 14 : hand.cards[1] == "K" ? 13 : hand.cards[1] == "Q" ? 12 : hand.cards[1] == "J" ? "00" : hand.cards[1] == "T" ? 10 : format("%02d",hand.cards[1]) }",
          "${ hand.cards[2] == "A" ? 14 : hand.cards[2] == "K" ? 13 : hand.cards[2] == "Q" ? 12 : hand.cards[2] == "J" ? "00" : hand.cards[2] == "T" ? 10 : format("%02d",hand.cards[2]) }",
          "${ hand.cards[3] == "A" ? 14 : hand.cards[3] == "K" ? 13 : hand.cards[3] == "Q" ? 12 : hand.cards[3] == "J" ? "00" : hand.cards[3] == "T" ? 10 : format("%02d",hand.cards[3]) }",
          "${ hand.cards[4] == "A" ? 14 : hand.cards[4] == "K" ? 13 : hand.cards[4] == "Q" ? 12 : hand.cards[4] == "J" ? "00" : hand.cards[4] == "T" ? 10 : format("%02d",hand.cards[4]) }",
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
  description = "The total winning of camel card with joker"
}