module Main where

import Prelude

import Data.Default (default)
import Data.Lens ((.~))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import Seija.App (startApp)
import Seija.Asset (loadAsset)
import Seija.Asset.LoaderInfo (textureLoaderInfo)
import Seija.Component as C
import Seija.Element as E
import Seija.FRP as FRP
import Seija.Foreign (_windowHeight, _windowTitle, _windowWidth)
import Seija.Simple2D (newEventRoot)
import Snake.Game (GameRun, newSnakeGame)

main :: Effect Unit
main = do
  let s2dConfig = default #  (_windowWidth .~ 640) >>> (_windowHeight .~ 480) >>> (_windowTitle .~ "Seija Runing")
  let game = newSnakeGame
  startApp s2dConfig game gameStart
  log "Game End"

gameStart::GameRun Unit
gameStart = do
  root <- newEventRoot
  C.addSreenScaler root (C.ScaleWithHeight 768.0) $> unit
  bg_png <- loadAsset $ textureLoaderInfo "bg.png" Nothing
  elImage <- E.image bg_png [C.rSizeVec2 1280.0 800.0] (Just root)
  pure unit