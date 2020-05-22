module Snake.Logic where

import Data.Default (class Default)

newtype RootGameData = RootGameData {
   gameState::Int
}
instance defaultRootGameData :: Default RootGameData where
  default = RootGameData { gameState : 0}

data GameRootEvent = UpdateGameState Int | QuitGame

isUpdateGameState :: GameRootEvent -> Boolean
isUpdateGameState (UpdateGameState _) = true
isUpdateGameState ev                  = false