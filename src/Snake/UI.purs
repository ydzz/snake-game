module Snake.UI where

import Prelude

import Color.Scheme.X11 (red)
import Data.Maybe (Maybe(..))
import Seija.Component as C
import Seija.Element as E
import Seija.FRP (Event)
import Seija.Foreign (Entity)
import Snake.Game (GameRun, GameAssets)
import Snake.Logic (GameRootEvent)

mainView::Event GameRootEvent -> GameAssets -> GameRun Entity
mainView rootEv assets = do
  elImage <- E.image assets.menuBG [C.tPosVec3 0.0 0.0 10.0] Nothing
  C.addBaseLayout elImage C.LHStretch C.LVStretch Nothing Nothing $> unit
  elText <- E.text assets.font [C.tText "Start!",C.cColor red,C.rSizeVec2 100.0 50.0,C.tPosVec3 0.0 0.0 (-0.1)] (Just elImage)
  pure elImage