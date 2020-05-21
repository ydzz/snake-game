module Snake.Game where

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Seija.App (class IGame, GameM)

type GameRun = GameM SnakeGame Effect

newtype SnakeGame = SnakeGame {

}

newSnakeGame::SnakeGame
newSnakeGame = SnakeGame {}

instance igameSnakeGame :: IGame SnakeGame where
  resPath _ = (Just "./res/")