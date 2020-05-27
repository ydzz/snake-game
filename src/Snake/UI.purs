module Snake.UI where

import Prelude

import Color (white)
import Data.Maybe (Maybe(..))
import Seija.Component as C
import Seija.Element as E
import Seija.FRP as FRP
import Seija.Foreign (Entity)
import Snake.Game (GameRun, GameAssets)
import Snake.Logic (GameRootEvent(..))

mainView::FRP.Event GameRootEvent -> GameAssets -> GameRun Entity
mainView rootEv assets = do
  elImage <- E.image assets.menuBG [C.tPosVec3 0.0 0.0 10.0] Nothing
  C.addBaseLayout elImage C.LHStretch C.LVStretch Nothing Nothing $> unit
  elTitle <- E.text assets.font [C.tFontSize 50,C.tText "贪食蛇",C.cColor white,C.rSizeVec2 200.0 50.0,C.tPosVec3 0.0 200.0 (-0.1)] (Just elImage)
  elMenuPanel <- E.emptyElement [C.tPosVec3 0.0 0.0 0.0,C.rAnchorVec2 0.5 1.0,C.rSizeVec2 1000.0 368.0] (Just elImage)
  C.addStackPanel elMenuPanel C.Vertical 10.0 $> unit
  elText <- E.text assets.font [C.tFontSize 32,C.tText "单机游戏",C.cColor white,C.rSizeVec2 200.0 50.0,C.tPosVec3 0.0 0.0 (-0.1)] (Just elMenuPanel)
  elText2 <- E.text assets.font [C.tFontSize 32,C.tText "多人游戏",C.cColor white,C.rSizeVec2 200.0 50.0,C.tPosVec3 0.0 0.0 (-0.1)] (Just elMenuPanel)
  elText3 <- E.text assets.font [C.tFontSize 32,C.tText "系统设置",C.cColor white,C.rSizeVec2 200.0 50.0,C.tPosVec3 0.0 0.0 (-0.1)] (Just elMenuPanel)
  elText4 <- E.text assets.font [C.tFontSize 32,C.tText "退出游戏",C.cColor white,C.rSizeVec2 200.0 50.0,C.tPosVec3 0.0 0.0 (-0.1)] (Just elMenuPanel)

  evStartSingle::FRP.Event Entity <- FRP.fetchEvent elText FRP.Click false
  let evChangeState = evStartSingle $> UpdateGameState 1
  FRP.setNextEvent evChangeState rootEv
  pure elImage