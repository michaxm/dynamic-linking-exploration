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
--libPath = "testlibs/testlib1/libHStestlib1-0.1.0.0-ghc7.10.2.so"
--libPath = "testlibs/c-linkage-example/libctest.so.1.0"
libPath = "testlibs/testlib1/libHStestlib1.so"

defaultFnName :: String
defaultFnName = "ctest3"

main :: IO ()
main = do
  putStrLn $ "fn name to execute, exit to stop, default: " ++ defaultFnName
  l <- getLine
  case l of
   "exit" -> putStrLn "without root rights, the demo program seems to segfault on exit" >> return ()
   "" -> doRun defaultFnName
   otherwise -> doRun l

doRun :: String -> IO ()
doRun fnName =  do
  putStrLn "try linking"
  dl <- dlopen libPath [RTLD_LAZY]
  funptr1 <- dlsym dl fnName
  print (mkFun funptr1 6)
  dlclose dl
  withDL libPath [RTLD_NOW] $ \mod -> do
    funptr <- dlsym mod fnName
    let fun = mkFun funptr in
     print (fun 3) >> putStrLn "sdf"
--     withCString "sdf" $ \str -> do
--       strptr <- fun str
--       print "sdf" --(fun str)
  putStrLn $ "DONE for " ++ fnName
  main
