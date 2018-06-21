port module Main exposing (..)

import Html exposing (Html, text, div, h1, img, button)
import Html.Events exposing (onClick)
import Array exposing (Array)


---- MODEL ----


type alias Model =
    { database : Array ( String, String )
    , index : Int
    }


init =
    ( Model database 0, Cmd.none )


database =
    Array.fromList
        [ ( "blah.jpg", "'Blah' is a wonderful painting from the victorian era" )
        , ( "foo.jpg", "One of the most controversial pictures, 'Foo', has be displayed at the Louvre" )
        ]



---- UPDATE ----


type Msg
    = Forward
    | Backward


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Forward ->
            if Array.length model.database == model.index + 1 then
                model ! [ messageUserland "At the end of the pics." ]
            else
                { model | index = model.index + 1 }
                    ! [ getPicInfo (model.index + 1) model.database
                            |> messageUserland
                      ]

        Backward ->
            if model.index <= 0 then
                model ! [ messageUserland "At the beginning already." ]
            else
                { model | index = model.index - 1 }
                    ! [ getPicInfo (model.index - 1) model.database
                            |> messageUserland
                      ]


getPicInfo : Int -> Array ( String, String ) -> String
getPicInfo i arr =
    Array.get i arr
        |> Maybe.map Tuple.second
        |> Maybe.withDefault "No Pic here"


getPicUrl : Int -> Array ( String, String ) -> String
getPicUrl i arr =
    Array.get i arr
        |> Maybe.map Tuple.first
        |> Maybe.withDefault "No Pic here"



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Your Elm App is working!" ]
        , text (getPicUrl model.index model.database)
        , div []
            [ button [ onClick Backward ] [ text "Back" ]
            , button [ onClick Forward ] [ text "Next" ]
            ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }



---- PORTS ----


port messageUserland : String -> Cmd msg
