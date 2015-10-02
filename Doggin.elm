module Doggin where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Signal, Address)
import String
import Window
import Dogs exposing (Dog)
import Treats exposing (Treat)

type alias Model = 
   { dogs          : List Dog
   , selectedTreat : Maybe Treat
   , allTreats     : List Treat
   }


initialModel : Model
initialModel = 
   { dogs          = [ Dogs.scruffy, Dogs.steven, Dogs.jeffrey ]
   , selectedTreat = Nothing
   , allTreats     = [ Treats.bacon, Treats.tofu, Treats.kibble ]
   }


type Action
    = NoOp
    | SelectTreat Treat

update : Action -> Model -> Model
update action model =
   case action of
      NoOp ->
         model

      SelectTreat treat ->
         { model | selectedTreat <- Just treat }


view : Address Action -> Model -> Html
view actions model =
   div [id "page"]
      [ h1 [] [text "Doggin' Around"]
      , p [] [text "Select a treat, then choose a dog to give it to!"]
      , div [id "treats"] ( List.map (viewTreat model.selectedTreat) model.allTreats )
      , div [id "dogs"] ( List.map viewDog model.dogs )
      ]


viewTreat : Maybe Treat -> Treat -> Html
viewTreat selectedTreat treat =
   let
       className =
          case selectedTreat of
             Nothing ->
                "treat"

             Just actualSelectedTreat ->
                if treat == actualSelectedTreat then
                   "treat treat-selected"
                else
                   "treat"
   in
      div [class className]
         [ img [src treat.imageUrl] []
         , span [class "treat-name"] [text treat.name]
         ]


viewDog : Dog -> Html
viewDog dog =
   div [class "dog"]
      [ img [src dog.imageUrl] []
      , span [class "dog-name"] [text dog.name]
      ]






---- INPUTS ----

-- Wire the entire application together
main : Signal Html
main =
  Signal.map (view actionMailbox.address) model


-- Manage the model of our application over time
model : Signal Model
model =
  Signal.foldp update initialModel actionMailbox.signal


-- Actions from user input
actionMailbox : Signal.Mailbox Action
actionMailbox =
  Signal.mailbox NoOp
