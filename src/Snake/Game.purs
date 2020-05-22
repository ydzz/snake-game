module Snake.Game where

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Seija.App (class IGame, GameM)
import Seija.Asset.Types (Font, Texture)

type GameRun = GameM SnakeGame Effect

type GameAssets = {
    menuBG::Texture,
    font::Font
}

newtype SnakeGame = SnakeGame {

}

newSnakeGame::SnakeGame
newSnakeGame = SnakeGame {}

instance igameSnakeGame :: IGame SnakeGame where
  resPath _ = (Just "./res/")

