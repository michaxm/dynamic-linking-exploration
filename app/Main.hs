{-# LANGUAGE ForeignFunctionInterface #-}
module Main where

import Foreign.C.String
import Foreign.Ptr
import System.Environment (getArgs)
import System.Posix.DynamicLinker

type Fun = Int -> Int
foreign import ccall "dynamic"
  mkFun :: FunPtr Fun -> Fun

libPathC, libPathHsOverFFI, libPathPureHs :: FilePath
libPathC = "testlibs/c-linkage-example/libctest.so.1.0"
libPathHsOverFFI = "testlibs/testlibFFI/libHStestlibFFI.so"
libPathPureHs = "testlibs/testlibHS1/libHStesthslibHS1.so"

defaultFnName :: String
defaultFnName = "ctest3"

main :: IO ()
main = do
  (dlOpen, exitFails, libPath) <- getMode
  putStrLn $ "fn name to execute, exit to stop, default: " ++ defaultFnName
  l <- getLine
  case l of
   "exit" -> if exitFails then putStrLn "without root rights, the demo program seems to segfault on exit" else return ()
   "" -> doRun dlOpen libPath defaultFnName 
   otherwise -> doRun dlOpen libPath l
   where
     doRun dlOpen libPath fnName = (if dlOpen then loadOverDlOpen else loadNatively) libPath fnName

getMode :: IO (Bool, Bool, FilePath)
getMode = do
  args <- getArgs
  case args of
   ["hs"] -> return (False, False, libPathPureHs)
   ["hs-ffi"] -> return (True, True, libPathHsOverFFI)
   ["c"] -> return (True, False, libPathC)
   _ -> error "c, hs-ffi or hs expected as single arg"

loadOverDlOpen :: FilePath -> String -> IO ()
loadOverDlOpen libPath fnName = do
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

loadNatively :: FilePath -> String -> IO ()
loadNatively libPath fnName = do
  putStrLn "TODO"
  main
