module Main where

import Prelude

import Data.Default (default)
import Data.Lens ((.~))
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Console (log)
import Seija.App (startApp)
import Seija.Asset (loadAsset)
import Seija.Asset.LoaderInfo (fontLoaderInfo, spriteSheetLoaderInfo, textureLoaderInfo)
import Seija.Asset.Texture (Filter(..), SamplerDesc(..), TextureConfig(..), WrapMode(..))
import Seija.Component as C
import Seija.Element as E
import Seija.FRP (Event, reducer)
import Seija.Foreign (Entity, _windowHeight, _windowTitle, _windowWidth)
import Seija.Simple2D (newEventRoot)
import Snake.Game (GameRun, GameAssets, newSnakeGame)
import Snake.GameScene (gameScene)
import Snake.Logic (GameRootEvent(..), RootGameData(..))
import Snake.UI (mainView)

main :: Effect Unit
main = do
  let s2dConfig = default #  (_windowWidth .~ 1024) >>> (_windowHeight .~ 768) >>> (_windowTitle .~ "Seija Runing")
  let game = newSnakeGame 
  startApp s2dConfig game gameStart
  log "Game End"

loadAllAssets::GameRun GameAssets
loadAllAssets = do
  bg_png <- loadAsset $ textureLoaderInfo "bg.png" Nothing
  font   <- loadAsset (fontLoaderInfo "WenQuanYiMicroHei.ttf")
  let sheetConfig = TextureConfig { generate_mips:false,  premultiply_alpha:false, sampler_info: SamplerDesc {filter:Nearest,wrap_mode:Clamp } }
  snakeSheet <- loadAsset (spriteSheetLoaderInfo "snake.json" (Just sheetConfig))
  pure { menuBG : bg_png, font,sheet:snakeSheet }

gameStart::GameRun Unit
gameStart = do
  root <- newEventRoot
  C.addSreenScaler root (C.ScaleWithHeight 768.0) $> unit
  assets <- loadAllAssets
  eRoot /\ bRoot <- reducer (default::RootGameData) onUpdate
  let bElemet = (\(RootGameData d) -> selectViews eRoot assets d.gameState) <$> bRoot
  E.switchElement root bElemet
  pure unit

selectViews::Event GameRootEvent -> GameAssets  -> Int -> GameRun Entity
selectViews eRoot assets num = case num of
                                    0 ->  mainView eRoot assets
                                    _ ->  gameScene eRoot assets 

onUpdate::RootGameData -> GameRootEvent -> RootGameData
onUpdate d (UpdateGameState s) = RootGameData { gameState : s }
onUpdate d e = d