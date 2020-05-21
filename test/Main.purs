module Test.Main where

import Prelude

import Data.Array (replicate)
import Data.String.CodeUnits (fromCharArray)
import Effect (Effect)
import Effect.Class.Console (log)

main :: Effect Unit
main = do
  say 4 0

say::Int -> Int -> Effect Unit
say 0 sn = do
   log $ (fromCharArray $ replicate sn ' ') <> "> i am f \r"
say n sn = do
  log $ (fromCharArray $ replicate sn ' ') <> ">\r"
  say (n - 1) (sn + 1)