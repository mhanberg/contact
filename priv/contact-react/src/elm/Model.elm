module Model exposing (..)


type Msg
    = Increment
    | Decrement


type alias Model =
    { count : Int }


start : Model
start =
    { count = 0 }
