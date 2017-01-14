import qualified Data.Map as Map
import Data.Maybe

n = 20

f k m = fromJust $ Map.lookup (k, m) mem where
  mem = Map.fromList [ ((k, (mx, my)), f' k (mx, my))
                     | k <- [0..n], mx <- [0..9], my <- [0..9 - mx]
                     ]	

f' 0  _       = 1
f' k (mx, my) = sum $ map (f (k - 1) . (,) my) [fromEnum $ k == n .. 9 - mx - my]

main = print $ f n (0, 0)
