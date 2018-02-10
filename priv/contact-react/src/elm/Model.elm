module Model exposing (..)
import Http exposing (..)

type Msg
    = GetRoomMessages (Maybe String)
    | InitialMessages (Result Http.Error String)
    | Session String
    | GetSession


type alias Flags =
    Maybe String

type alias Model =
    { roomId : Maybe String
    , messages : List Message
    }

type alias Message =
    { sender : String
    , body : String
    }


start : Model
start =
    { roomId = Nothing
    , messages =
        [ { sender = "The Librarian"
          , body = "Ook!"
          }
        , { sender = "Rincewind"
          , body = "Run!"
          }
        ]
    }
