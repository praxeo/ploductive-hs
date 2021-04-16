{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Task where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)
import Text.Julius (RawJS (..))

-- Define our data that will be used for creating the form.
data FileForm = FileForm
    { fileInfo :: FileInfo
    , fileDescription :: Text
    }

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes.yesodroutes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
getTaskR :: Handler Html
getTaskR = do
    (formWidget, formEnctype) <- generateFormPost taskForm
    let submission = Nothing :: Maybe FileForm
        handlerName = "getTaskR" :: Text
    allTasks <- runDB $ getAllTasks

    defaultLayout $ do
        aDomId <- newIdent
        setTitle "Ploductive: Tasks"
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
        addScriptRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"
        addScriptRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"
    
        $(widgetFile "tasks")

postTaskR :: Handler Html
postTaskR = do
    ((result, formWidget), formEnctype) <- runFormPost taskForm
    let handlerName = "postTaskR" :: Text
        submission = case result of
            FormSuccess res -> Just res
            _ -> Nothing

    defaultLayout $ do
        aDomId <- newIdent
        setTitle "Ploductive: Tasks"
        $(widgetFile "tasks")

patchTaskR :: Handler Html
patchTaskR = do
    defaultLayout $ do
        $(widgetFile "tasks")

deleteTaskR :: Handler Html
deleteTaskR = do
    defaultLayout $ do
        $(widgetFile "tasks")

getTaskByIdR :: Handler Html
getTaskByIdR = do
    defaultLayout $ do
        $(widgetFile "tasks")
    
getTaskByDayR :: Handler Html
getTaskByDayR = do
    defaultLayout $ do
        $(widgetFile "tasks")

taskForm :: Form FileForm
taskForm = renderBootstrap3 BootstrapBasicForm $ FileForm
    <$> fileAFormReq "Choose a file"
    <*> areq textField textSettings Nothing
    -- Add attributes like the placeholder and CSS classes.
    where textSettings = FieldSettings
            { fsLabel = "What's on the file?"
            , fsTooltip = Nothing
            , fsId = Nothing
            , fsName = Nothing
            , fsAttrs =
                [ ("class", "form-control")
                , ("placeholder", "File description")
                ]
            }

getAllTasks :: DB [Entity Task]
getAllTasks = selectList [] [Asc TaskId]