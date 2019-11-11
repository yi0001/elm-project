
import Browser
import Csv exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events exposing (..)
import Html.Keyed as Keyed
import Http
import Json.Decode as Json
import List.Extra exposing (find, getAt, isPermutationOf)
import Table exposing (defaultCustomizations)

main : Program Location Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

helperFacility : Facilities -> List String -> Facility
helperFacility facilities list =
    { id = getAt 0 list |> Maybe.withDefault "00000"
    , name = getAt 1 list |> Maybe.withDefault "未設定"
    , count = getAt 2 list |> maybeStringtoInt
    }


configCount : Table.Config Facility Msg
configCount =
    Table.customConfig
        { toId = .id
        , toMsg = SetTableState
        , columns =
            [ Table.stringColumn "名前" .name
            , Table.intColumn "距離(km)" .distance
            , Table.intColumn "件数" .count
            ]
        , customizations =
            { defaultCustomizations | rowAttrs = toRowAttrs }
        }

maybeStringtoInt : Maybe String -> Int
maybeStringtoInt string =
    string |> Maybe.withDefault "-1" |> String.toInt |> Maybe.withDefault -1
