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
   , happiness = 50
   , hunger    = 50
   , imageUrl  = "dogs/scruffy.png"
   }


steven : Dog
steven =
   { name      = "Steven"
   , happiness = 50
   , hunger    = 50
   , imageUrl  = "dogs/steven.png"
   }


jeffrey : Dog
jeffrey =
   { name      = "Jeffrey"
   , happiness = 50
   , hunger    = 50
   , imageUrl  = "dogs/jeffrey.png"
   }

