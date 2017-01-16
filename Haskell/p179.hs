-- ~3.5s. Gives an answer for `10^8` in 40s.
-- Allocates lots of stuff, so can be optimized further
-- (by inlining the logics of `pows` into `main`?).

import Data.List
import qualified Data.Vector.Unboxed.Mutable as Mut
import qualified Data.Vector.Unboxed as Imm
import Control.Monad
import Control.Monad.ST
import Control.Monad.Trans
import Control.Monad.Trans.Maybe

-- A slower alternative.
-- divNums :: Int -> [Int]
-- divNums m = runST $ do
--   ds <- Mut.replicate (m + 1) 2 :: ST s (Mut.STVector s Int)
--   forM_ [2 .. floor . sqrt . fromIntegral $ m] $ \i -> do
--     let i2 = i ^ 2; n  = i2 + i
--     Mut.unsafeModify ds (+ 1) i2 
--     forM_ [n, n + i .. m] $ Mut.unsafeModify ds (+ 2)
--   (1:) . drop 2 . Imm.toList <$> Imm.unsafeFreeze ds

pows :: Int -> [Int]
pows k = inf 1 [] where
  fin r = foldr (.) id . fins where
    fins d | d == 1    = replicate (k - 1) (1 :)
           | otherwise = intersperse (d :) . replicate r $ fin k (d - 1)
  inf d = fin (k - 1) d . ((d + 1) :) . inf (d + 1)

divNums :: Int -> [Int]
divNums m = runST $ do
  ds <- Mut.replicate (m + 1) 1 :: ST s (Mut.STVector s Int)
  forM_ [2..m] $ \i -> do
    d <- Mut.read ds i
    runMaybeT $ do
      guard $ d == 1
      forM_ (zip [i, i * 2..] $ pows i) $ \(n, p) -> do
        guard $ n <= m
        lift  $ Mut.unsafeModify ds (* (p + 1)) n
  tail . Imm.toList <$> Imm.unsafeFreeze ds

main = print . length . filter id . (zipWith (==) <*> tail) . divNums $ 10^8
