module Dogs where

type alias Dog =
   { name      : String
   , happiness : Int
   , hunger    : Int
   , imageUrl  : String
   }


scruffy : Dog
scruffy =
   { name      = "Scruffy"
   , happiness = 0
   , hunger    = 100
   , imageUrl  = "dogs/scruffy.png"
   }


steven : Dog
steven =
   { name      = "Steven"
   , happiness = 0
   , hunger    = 100
   , imageUrl  = "dogs/steven.png"
   }


jeffrey : Dog
jeffrey =
   { name      = "Jeffrey"
   , happiness = 0
   , hunger    = 100
   , imageUrl  = "dogs/jeffrey.png"
   }

