-- Plain and stupid. Consumes 768 MB of memory and runs in 40s.

import Data.List
import qualified Data.Vector.Unboxed.Mutable as Mut
import qualified Data.Vector.Unboxed as Imm
import Control.Monad
import Control.Monad.ST
import Control.Monad.Trans
import Control.Monad.Trans.Maybe

pows :: Int -> [Int]
pows k = inf 1 [] where
  fin r = foldr (.) id . fins where
    fins d | d == 1    = replicate (k - 1) (1 :)
           | otherwise = intersperse (d :) . replicate r $ fin k (d - 1)
  inf d = fin (k - 1) d . ((d + 1) :) . inf (d + 1)

primeNums :: Int -> [Int]
primeNums m = runST $ do
  ds <- Mut.replicate (m + 1) 0 :: ST s (Mut.STVector s Int)
  forM_ [2..m] $ \i -> do
    d <- Mut.read ds i
    runMaybeT $ do
      guard $ d == 0
      forM_ (zip [i, i * 2..] $ pows i) $ \(n, p) -> do
        guard $ n <= m
        lift  $ Mut.unsafeModify ds (+ p) n
  tail . Imm.toList <$> Imm.unsafeFreeze ds

main = print . length . filter (== 2) $ primeNums (10^8 - 1)
