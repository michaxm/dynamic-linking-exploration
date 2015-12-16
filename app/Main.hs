{-# LANGUAGE ForeignFunctionInterface #-}
module Main where

import Foreign.C.String
import Foreign.Ptr
import System.Posix.DynamicLinker

type Fun = Int -> Int
--type Fun = CString -> CString
foreign import ccall "dynamic"
  mkFun :: FunPtr Fun -> Fun

libPath :: FilePath
libPath = "testlibs/testlib1/libHStestlib1-0.1.0.0-ghc7.10.2.so"
libPath = "testlibs/c-linkage-example/libctest.so.1.0"
--TODO: libPath = "testlibs/testlib1/libHStestlib1.so"

fnName :: String
fnName = "ctest3"

main :: IO ()
main = do
  putStrLn "try linking"
  withDL libPath [RTLD_NOW] $ \mod -> do
    funptr <- dlsym mod fnName
    let fun = mkFun funptr in
     print $ fun 3
--     withCString "sdf" $ \str -> do
--       strptr <- fun str
--       print "sdf" --(fun str)
