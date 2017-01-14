-- This one is fast, but not self-contained (you need a `Primes` module).

import Data.Maybe
import Data.List
import Data.Array
import qualified Data.Set as Set
import qualified Data.Map as Map
import Control.Arrow
import Primes

nmax  = 10^10
pmax  = round $ sqrt $ fromIntegral nmax
prs   = takeWhile (<= pmax) primes
lastp = last prs

af ag = array (2, lastp) $ map (id &&& ag) prs
as3   = af (^3)
facts = af $ Map.fromAscListWith (+) . map (flip (,) 1) . primeFactors . pred

f n ms ss
  | n >= nmax   = []
  | Set.null ss = if nms then [(n, [])] else []
  | b           = []
  | unm == 2    = rl ++ f n ms ss'
  | otherwise   = rl
  where
    nms      = Map.null ms
    (m, ss') = Set.deleteFindMax ss
    b        = not nms && m < (fst $ Map.findMax ms)  
    unm      = (Map.findWithDefault 0 m ms + 1) `rem` 3 + 1
    n'       = n * m^unm
    ms'      = Map.filter ((/= 0) . (`rem` 3)) $ Map.unionWith (+) (Map.delete m ms) $ facts!m
    rl       = map (second (as3!m:)) $ f n' ms' $ fst $ Set.split (nmax `div` n' + 1) ss' 

h (n, xs)
   | null xs || nx' >= nmax = n
   | otherwise = h (nx', xs) + h (n, xs')
   where (x':xs', nx') = (xs, n * x')

main = print $ pred . sum $ map (h . second reverse) $ f 1 Map.empty $ Set.fromDistinctAscList prs
