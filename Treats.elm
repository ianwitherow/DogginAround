module Treats where

type alias Treat =
   { name            : String
   , happinessValue : Int
   , hungerValue    : Int
   , imageUrl       : String
   }


tofu : Treat
tofu =
   { name           = "Tofu"
   , happinessValue = -5
   , hungerValue    = -5
   , imageUrl       = "treats/tofu.png"
   }


bacon : Treat
bacon =
   { name           = "Bacon"
   , happinessValue = 5
   , hungerValue    = -2
   , imageUrl       = "treats/bacon.png"
   }


kibble : Treat
kibble =
   { name           = "Kibble"
   , happinessValue = 2
   , hungerValue    = -5
   , imageUrl       = "treats/kibble.png"
   }

