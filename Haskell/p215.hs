-- Bottom-up DP. No bitmaps optimizations. Sweet and nice, runs in 5s.

import Data.List
import Data.Vector (fromList, (!))
import qualified Data.Vector as Vec

n = 32
m = 10

layers = map (init . scanl1 (+)) $ xs ! n where
  at i = if i < 0 then [] else xs ! i
  xs = Vec.fromList $ [[]] : map (\i -> [2,3] >>= \j -> map (j:) $ at (i - j)) [1..n]

neighbs = fromList $ map step layers where
  step xs = map fst . filter (all (`notElem` xs) . snd) $ zip [0..] layers

row k = go (k - 1) $ Vec.replicate (Vec.length neighbs) 1 where
  go 0 a = a
  go k a = go (k - 1) $ Vec.map (sum . map (a !)) neighbs

main = print . Vec.sum $ row m
