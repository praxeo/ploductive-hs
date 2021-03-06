{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}

module Handler.Home where
import Yesod
import Import
--import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)
--import Text.Julius (RawJS (..))

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
getHomeR :: Handler TypedContent
getHomeR = do
    -- (formWidget, formEnctype) <- generateFormPost sampleForm
    -- allComments <- runDB getAllComments
    selectRep $ do
        --let handlerName = "getHomeR" :: Text
        -- let (commentFormId, commentTextareaId, commentListId) = commentIds
        -- let submission = Nothing :: Maybe FileForm
        provideRep $ defaultLayout $ do
            aDomId <- newIdent
            setTitle "Welcome to Ploductive"
            $(widgetFile "homepage")
        provideRep $ return $ object
            ["msg" .= message]
        where
            message = "This is the home page" :: Text

-- sampleForm :: Form FileForm
-- sampleForm = renderBootstrap3 BootstrapBasicForm $ FileForm
--     <$> fileAFormReq "Choose a file"
--     <*> areq textField textSettings Nothing
--     -- Add attributes like the placeholder and CSS classes.
--     where textSettings = FieldSettings
--             { fsLabel = "What's on the file?"
--             , fsTooltip = Nothing
--             , fsId = Nothing
--             , fsName = Nothing
--             , fsAttrs =
--                 [ ("class", "form-control")
--                 , ("placeholder", "File description")
--                 ]
--             }

-- commentIds :: (Text, Text, Text)
-- commentIds = ("js-commentForm", "js-createCommentTextarea", "js-commentList")
--
-- getAllComments :: DB [Entity Comment]
-- getAllComments = selectList [] [Asc CommentId]
