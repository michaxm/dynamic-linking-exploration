import System.Plugins.Load

defaultModulePath :: String
defaultModulePath = "build3/DummyModule.o"

defaultFnName :: String
defaultFnName = "resource_dyn"

main :: IO ()
main = loop Nothing

loop :: Maybe Module -> IO ()
loop module' = do
  putStrLn $ "module path to execute ("++defaultFnName++"), exit to stop, default: " ++ defaultModulePath
  l <- getLine
  case l of
   "exit" -> return ()
   "" -> loadWithPlugins defaultModulePath defaultFnName module'
   otherwise -> loadWithPlugins l defaultFnName module'

loadWithPlugins :: FilePath -> String -> Maybe Module -> IO ()
loadWithPlugins modulePath fnName module' = do
  case module' of
   Nothing -> dynload modulePath [] [] fnName >>= handleLoad
   (Just prevModule) -> reload prevModule fnName >>= handleLoad
  where
    handleLoad loadResult = do
     case loadResult of
      (LoadFailure msg) -> putStr "error: " >> print msg
      (LoadSuccess module' fun) -> do
        res <- return (fun  (5 :: Int)) :: IO Int
        print res
--        unload module'
        loop $ Just module'

