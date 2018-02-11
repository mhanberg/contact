module Model exposing (..)
import Http exposing (..)

type Msg
    = GetRoomMessages (Maybe String)
    | InitialMessages (Result Http.Error (List Message))
    | Session String
    | GetSession


type alias Flags =
    Maybe String

type alias Model =
    { roomId : Maybe String
    , messages : List Message
    }

type alias Message =
    { body : String
    }



start : Model
start =
    { roomId = Nothing
    , messages =
        [ { 
           body = "Ook!"
          }
        , { 
           body = "Run!"
          }
        ]
    }
