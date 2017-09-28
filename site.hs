--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll


--------------------------------------------------------------------------------
main :: IO ()
main = hakyllWith config $ do
    match "images/*" $ do
      route   idRoute
      compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "node_modules/tachyons/css/tachyons.min.css" $ do
      route $ customRoute (const "css/tachyons.min.css")
      compile copyFileCompiler

    match "node_modules/jquery/dist/jquery.slim.min.js" $ do
      route $ customRoute (const "js/jquery.slim.min.js")
      compile copyFileCompiler

    match "js/*" $ do
      route idRoute
      compile copyFileCompiler

    match "2017.md" $ do
      route $ setExtension "html"
      compile $ pandocCompiler

    -- match (fromList ["about.rst", "contact.markdown"]) $ do
    --     route   $ setExtension "html"
    --     compile $ pandocCompiler
    --         >>= loadAndApplyTemplate "templates/default.html" defaultContext
    --         >>= relativizeUrls

    -- match "posts/*" $ do
    --     route $ setExtension "html"
    --     compile $ pandocCompiler
    --         >>= loadAndApplyTemplate "templates/post.html"    postCtx
    --         >>= loadAndApplyTemplate "templates/default.html" postCtx
    --         >>= relativizeUrls

    -- create ["archive.html"] $ do
    --     route idRoute
    --     compile $ do
    --         posts <- recentFirst =<< loadAll "posts/*"
    --         let archiveCtx =
    --                 listField "posts" postCtx (return posts) `mappend`
    --                 constField "title" "Archives"            `mappend`
    --                 defaultContext

    --         makeItem ""
    --             >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
    --             >>= loadAndApplyTemplate "templates/default.html" archiveCtx
    --             >>= relativizeUrls


    match "index.html" $ do
        route idRoute
        compile $ do
            getResourceBody
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

config :: Configuration
config = defaultConfiguration
    { deployCommand = "git stash && git checkout develop && stack exec josietj clean && stack exec josietj build && git fetch --all && git checkout -b master --track origin/master && cp -a _site/. . && git add -A && git commit -m \"Publish.\" && git push origin master:master && git checkout develop && git branch -D master && git stash pop"
    }
