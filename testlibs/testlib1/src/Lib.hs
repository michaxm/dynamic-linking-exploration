module Lib (someFunc) where

foreign export ccall "ctest3" ctest3 :: Int -> Int

ctest3 :: Int -> Int
ctest3 = (+1)

someFunc :: String -> String
someFunc = (++ " appended")
