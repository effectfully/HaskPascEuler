import Data.Map hiding (map, mapMaybe)
import Data.Maybe
import Control.Arrow

f x k = fromJust $ Data.Map.lookup (x, k) mem where
  mem = fromList [((x, k), f' x k) | x <- [0..9], k <- [0..39]]

f' x 0 = [((x, x), 1)]
f' x k = toList . fromListWith (+) $ g (> 0) second max pred ++ g (< 9) first min succ where
  g cond ag mg xg = if cond x then map (first . ag . arr $ mg x) $ f (xg x) (k - 1) else []

main = print $ sum $ concatMap (\z -> mapMaybe (Prelude.lookup (0, 9) . f z) [9..39]) [1..9]
