import Prelude hiding (lookup)
import Data.Map hiding (map)
import Data.Maybe

f xs = fromListWith (zipWith (+))
  [ (n + d, [s * 10 + d * k, k]) | (n, [s, k]) <- toList xs, d <- [0..9]]

ixs1 = iterate f . (snd . split 0 . f) $ fromList [(0, [0, 1])]
ixs2 = iterate f                       $ fromList [(0, [0, 1])]

h n = sum [ek * 10^n * (s1 * 101 + k1 * 45) + k1 * es * 11 | 
  (n1, [s1, k1]) <- toList $ ixs1 !! (n - 1), let [es, ek] = fromJust $ lookup n1 $ ixs2 !! n]

main = print $ (`rem` 3^15) $ (45 +) . sum $ map h [1..23]
