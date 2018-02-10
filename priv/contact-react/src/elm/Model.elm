module Model exposing (..)


type Msg
    = Null


type alias Model =
    { messages : List Message }


type alias Message =
    { sender : String
    , body : String
    }


start : Model
start =
    { messages =
        [ { sender = "The Librarian"
          , body = "Ook!"
          }
        , { sender = "Rincewind"
          , body = "Run!"
          }
        ]
    }
