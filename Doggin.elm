module Doggin where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Signal, Address)
import String
import Window
import Dogs exposing (Dog)
import Treats exposing (Treat)
import Array
import List

type alias Model = 
   { dogs          : List Dog
   , selectedTreat : Maybe Treat
   , allTreats     : List Treat
   , totalMoves    : Int
   , movesUsed     : Int
   , statusMessage : String
   }


initialModel : Model
initialModel = 
   { dogs          = [ Dogs.scruffy, Dogs.steven, Dogs.jeffrey ]
   , selectedTreat = Nothing
   , allTreats     = [ Treats.bacon, Treats.tofu, Treats.kibble ]
   , totalMoves    = 100
   , movesUsed     = 0
   , statusMessage = "Select a treat, then choose a dog to give it to!"
   }


type Action
    = NoOp
    | GiveTreatToDog Dog Int
    | SelectTreat Treat

displayInsufficientMoves : Model -> Treat -> Model
displayInsufficientMoves model treat =
   { model | statusMessage <- "You don't have enough moves left to give out more treats!" }

resolveTreatOnDog : Treat -> Dog -> Dog
resolveTreatOnDog treat dog =
   let
      happiness1 =
         if dog.happiness + treat.happinessValue < 0
            then 0
            else dog.happiness + treat.happinessValue

      happiness =
         if happiness1 > 100
            then 100
            else happiness1

      hunger1 =
         if dog.hunger + treat.hungerValue < 0
            then 0
            else dog.hunger + treat.hungerValue

      hunger =
         if hunger1 > 100
            then 100
            else hunger1

   in
      { dog | hunger <- hunger
      , happiness <- happiness }

update : Action -> Model -> Model
update action model =
   case action of
      NoOp ->
         model

      SelectTreat treat ->
         { model | selectedTreat <- Just treat }

      GiveTreatToDog dog dogIndex ->
         case model.selectedTreat of
            Nothing ->
               { model | statusMessage <- "Select a treat first!" }

            Just treat ->
               if model.movesUsed > model.totalMoves
                  then
                     displayInsufficientMoves model treat

               else
               let
                   updateDogByIndex =
                      \index dog ->
                         if index == dogIndex
                            then resolveTreatOnDog treat dog
                            else dog

                   dogName =
                      \index dog ->
                         if index == dogIndex
                            then dog.name
                            else ""

                   exclamation =
                      if treat.name == "Bacon"
                         then "YEAH!"
                         else if treat.name == "Kibble"
                         then "Sweet!"
                         else if treat.name == "Tofu"
                         then "Neat!"
                         else ""

                in
                   { model | dogs <- List.indexedMap updateDogByIndex model.dogs
                     , movesUsed <- model.movesUsed + 1
                     , statusMessage <- exclamation ++ " You gave some " ++ treat.name ++ " to " ++ dog.name
                   }
               



view : Address Action -> Model -> Html
view actions model =
   div [id "page"]
      [ h1 [] [text "Doggin' Around!"]
      , p [] [text model.statusMessage]
      , div [id "treats"] ( List.map (viewTreat actions model.selectedTreat) model.allTreats )
      , div [id "dogs"] ( List.indexedMap (viewDog actions) model.dogs )
      ]


viewTreat : Address Action -> Maybe Treat -> Treat -> Html
viewTreat actions selectedTreat treat =
   let
       className = case selectedTreat of
          Nothing ->
             "treat"

          Just selection ->
             if treat == selection
                then "treat selected"
                else "treat"
   in
      div [class className, onClick actions (SelectTreat treat)]
         [ img [src treat.imageUrl] []
         , span [class "treat-name"] [text treat.name]
         ]


viewDog : Address Action -> Int -> Dog -> Html
viewDog actions index dog =
   div [class "dog", onClick actions (GiveTreatToDog dog index)]
      [ img [src dog.imageUrl] []
      , div [class "dog-name"] [text dog.name]
      , div [class "dog-status"] [text ("Happiness: " ++ toString dog.happiness)]
      , div [class "dog-status"] [text ("Hunger: " ++ toString dog.hunger)]
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
