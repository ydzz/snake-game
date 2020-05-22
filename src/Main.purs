module Main where

import Prelude

import Data.Default (class Default, default)
import Data.Lens ((.~))
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Effect.Console (log)
import Seija.App (startApp)
import Seija.Asset (loadAsset)
import Seija.Asset.LoaderInfo (fontLoaderInfo, textureLoaderInfo)
import Seija.Component as C
import Seija.Element as E
import Seija.FRP (Behavior, Event, foldBehavior, gateEvent, newEvent, tagBehavior)
import Seija.Foreign (_windowHeight, _windowTitle, _windowWidth)
import Seija.Simple2D (newEventRoot)
import Snake.Game (GameRun, GameAssets, newSnakeGame)
import Snake.Logic (GameRootEvent(..), RootGameData(..), isUpdateGameState)
import Snake.UI (mainView)

main :: Effect Unit
main = do
  let s2dConfig = default #  (_windowWidth .~ 1024) >>> (_windowHeight .~ 768) >>> (_windowTitle .~ "Seija Runing")
  let game = newSnakeGame 
  startApp s2dConfig game gameStart
  log "Game End"

reducer::forall d e m.MonadEffect m => d -> (d -> e -> d) -> m (Tuple (Event e) (Behavior d))
reducer d fn = do 
  (root::Event e) <- newEvent
  behavior <- foldBehavior d root fn
  pure $ (root) /\ behavior

loadAllAssets::GameRun GameAssets
loadAllAssets = do
  bg_png <- loadAsset $ textureLoaderInfo "bg.png" Nothing
  font   <- loadAsset (fontLoaderInfo "WenQuanYiMicroHei.ttf")
  pure { menuBG : bg_png, font }

gameStart::GameRun Unit
gameStart = do
  root <- newEventRoot
  C.addSreenScaler root (C.ScaleWithHeight 768.0) $> unit
  assets <- loadAllAssets
  eRoot /\ bRoot <- reducer (default::RootGameData) onUpdate
  evGameState <- gateEvent eRoot isUpdateGameState
  evStateRoot <- tagBehavior bRoot evGameState
  bRootElem <- foldBehavior (mainView eRoot assets) evStateRoot (\a ea -> (mainView eRoot assets))
  E.switchElement root bRootElem
  pure unit

onUpdate::RootGameData -> GameRootEvent -> RootGameData
onUpdate d (UpdateGameState s) = RootGameData { gameState : s }
onUpdate d e = d