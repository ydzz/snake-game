module Snake.Logic where

import Data.Default (class Default)

newtype RootGameData = RootGameData {
   gameState::Int
}
instance defaultRootGameData :: Default RootGameData where
  default = RootGameData { gameState : 0}

data GameRootEvent = UpdateGameState Int | QuitGame



newtype GameSceneData = GameSceneData {
  snakeList::Array SnakeNode,
  curDir::Int
}

data GameSceneEvent = Tick

instance defaultGameSceneData :: Default GameSceneData where
  default = GameSceneData { snakeList:[],curDir:0 }

onSceneUpdate::GameSceneData -> GameSceneEvent -> GameSceneData
onSceneUpdate d Tick = d

type SnakeNode = {
  key::Int,
  x::Int,
  y::Int
}