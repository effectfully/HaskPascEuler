import Data.Map hiding (map)

f xs = toList $ fromListWith (zipWith (+)) 
  [(ssqd + d^2, [sn * 10 + k * d, k]) | (ssqd, [sn, k]) <- xs, d <- [0..9]]

main = print $ (`rem` 10^9) $ sum 
  [sn | (ssqd, [sn, _]) <- (!! 20) $ iterate f [(0, [0, 1])], elem ssqd $ map (^2) [1..40]]
