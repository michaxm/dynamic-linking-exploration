{-# LANGUAGE ForeignFunctionInterface #-}
module Main where

import Foreign.C.String
import Foreign.Ptr
import System.Environment (getArgs)
import System.Posix.DynamicLinker

type Fun = Int -> Int
foreign import ccall "dynamic"
  mkFun :: FunPtr Fun -> Fun

libPathC, libPathHs :: FilePath
libPathC = "testlibs/c-linkage-example/libctest.so.1.0"
libPathHs = "testlibs/testlib1/libHStestlib1.so"

defaultFnName :: String
defaultFnName = "ctest3"

main :: IO ()
main = do
  libPath <- getLibPath
  putStrLn $ "fn name to execute, exit to stop, default: " ++ defaultFnName
  l <- getLine
  case l of
   "exit" -> putStrLn "without root rights, the demo program seems to segfault on exit" >> return ()
   "" -> doRun libPath defaultFnName
   otherwise -> doRun libPath l

getLibPath :: IO FilePath
getLibPath = do
  args <- getArgs
  case args of
   ["hs"] -> return libPathHs
   ["c"] -> return libPathC
   _ -> error "hs or c expected as single arg"

doRun :: FilePath -> String -> IO ()
doRun libPath fnName =  do
  putStrLn "try linking"
  dl <- dlopen libPath [RTLD_LAZY]
  funptr1 <- dlsym dl fnName
  print (mkFun funptr1 6)
  dlclose dl
  withDL libPath [RTLD_NOW] $ \mod -> do
    funptr <- dlsym mod fnName
    let fun = mkFun funptr in
     print (fun 3) >> putStrLn "sdf"
  putStrLn $ "DONE for " ++ fnName
  main

--type Fun = CString -> CString
--     withCString "sdf" $ \str -> do
--       strptr <- fun str
--       print "sdf" --(fun str)
