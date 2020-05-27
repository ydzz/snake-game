module Snake.GameScene where

import Prelude

import Data.Array ((..))
import Data.Default (default)
import Data.Maybe (Maybe(..))
import Data.Traversable (for)
import Data.Tuple.Nested ((/\))
import Seija.Component (Orientation(..))
import Seija.Component as C
import Seija.Element as E
import Seija.FRP as FRP
import Seija.Foreign (Entity)
import Snake.Game (GameAssets, GameRun)
import Snake.Logic (GameRootEvent, GameSceneData, onSceneUpdate)

gameScene::FRP.Event GameRootEvent -> GameAssets -> GameRun Entity
gameScene evRoot assets = do
    eRoot /\ bRoot <- FRP.reducer (default::GameSceneData) onSceneUpdate
    elRoot <- E.sprite_ assets.sheet "black" [C.tPosVec3 0.0 0.0 10.0] Nothing
    C.addBaseLayout elRoot C.LHStretch C.LVStretch Nothing Nothing $> unit
    initWall elRoot assets
    pure elRoot

initWall::Entity -> GameAssets -> GameRun Unit
initWall p assets = do
    elTopWall <- E.emptyElement [C.rSizeVec2 768.0 768.0] (Just p)
    C.addBaseLayout elTopWall C.LHStretch C.LVTop Nothing Nothing $> unit
    C.addStackPanel elTopWall Horizontal 0.0 $> unit
    for (0..23) (const $ block2 elTopWall) $> unit

    elBottomWall <- E.emptyElement [C.rSizeVec2 768.0 768.0] (Just p)
    C.addBaseLayout elBottomWall C.LHStretch C.LVBottom Nothing Nothing $> unit
    C.addStackPanel elBottomWall Horizontal 0.0 $> unit
    for (0..23) (const $ block5 elBottomWall) $> unit

    elLeftWall <- E.emptyElement [C.rSizeVec2 32.0 704.0] (Just p)
    C.addBaseLayout elLeftWall C.LHLeft C.LVCenter Nothing Nothing $> unit
    C.addStackPanel elLeftWall Vertical 0.0 $> unit
    for (0..21) (const $ block3 elLeftWall) $> unit

    elRightWall <- E.emptyElement [C.tPosVec3 256.0 0.0 0.0,C.rSizeVec2 32.0 704.0] (Just p)
    C.addStackPanel elRightWall Vertical 0.0 $> unit
    for (0..21) (const $ block4 elRightWall) $> unit
    pure unit
  where
    block::Entity -> Number -> Number -> String -> GameRun Entity
    block parent ax ay str = E.sprite_ assets.sheet str [C.tScaleVec3 4.0 4.0 1.0,C.rAnchorVec2 ax ay] (Just parent)
    block2 parent = block parent 0.0 1.0 "block-2"
    block3 parent = block parent 0.0 1.0 "block-3"
    block4 parent = block parent 1.0 0.0 "block-4"
    block5 parent = block parent 0.0 0.0 "block-5"
