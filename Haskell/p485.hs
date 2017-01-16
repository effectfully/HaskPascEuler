-- Just bruteforced. Takes <50s.

{-# LANGUAGE BangPatterns, TypeFamilies #-}

import Data.List
import qualified Data.Foldable as F
import Data.Sequence hiding (replicate, zip, splitAt)
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

data Cyclic a = Cyclic
  { getPosition :: {-# UNPACK #-} !Int
  , getVector   :: !(Mut.IOVector a)
  }
  
splitAppend :: Imm.Unbox a => Cyclic a -> a -> IO (a, Cyclic a)
splitAppend (Cyclic i xs) y = do
  x <- Mut.read xs i
  Mut.write xs i y
  let l = Mut.length xs
  return (x, Cyclic (if i == l - 1 then 0 else i + 1) xs)

s :: Int -> Int -> IO Integer
s u k = enter where

  enter = do
    let (xs, rs) = splitAt k $ divNums u
    mxs <- Imm.unsafeThaw $ Imm.fromList xs
    go 0 (maximum xs) (Cyclic 0 mxs) rs

  go :: Integer -> Int -> Cyclic Int -> [Int] -> IO Integer
  go !s m xs  []    = return $ s + fromIntegral m
  go  s m xs (r:rs) = do
    (x, xs') <- splitAppend xs r
    ixs' <- Imm.unsafeFreeze (getVector xs')
    let m' | r > m     = r
           | x == m    = Imm.maximum ixs'
           | otherwise = m
    m' `seq` go (s + fromIntegral m) m' xs' rs

main = s (10^8) (10^5) >>= print
