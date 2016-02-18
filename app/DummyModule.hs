module DummyModule where

import Data.Dynamic

func :: Int -> Int
func = (+3)

resource_dyn :: Dynamic
resource_dyn = toDyn func
