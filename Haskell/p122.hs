-- Runs in about a minute, makes no assumptions (like a new number in a chain is always constructed
-- from the biggest old one, which is not true for `12509`, see the thread). doesn't consume memory,
-- doesn't have hacks to handle `191`, but does have a magical number `11`.
-- With the always-the-biggest assumption (another definition of `newNums`) the code runs in ~2.5s.
-- All in all, a rather stupid solution to a rather annoying problem.

{-# LANGUAGE TypeFamilies #-}

import Data.List
import qualified Data.Vector.Unboxed.Mutable as Mut
import qualified Data.Vector.Unboxed as Imm
import Control.Monad

n = 200

-- newNums :: [Int] -> [Int]
-- newNums is@(m:_) = dropWhile (> n) $ map (m +) is

newNums :: [Int] -> [Int]
newNums is@(m:_) = map head . group . sort
                 . concatMap (takeWhile (> m) . dropWhile (> n) . snd)
                 . takeWhile ((> m) . fst)
                 $ [(i * 2, map (i +) js) | js@(i:_) <- tails is]

mults :: IO [Int]
mults = do
  ps <- Mut.replicate (n + 1) maxBound :: IO (Mut.IOVector Int)
  Mut.write ps 1 0
  let go q is@(m:_) = when (q <= 11) $ do
        let js = newNums is
        mapM_ (Mut.modify ps (min q)) js
        mapM_ (go (q + 1) . (: is)) $ filter (/= n) js
  go 1 [1]
  tail . Imm.toList <$> Imm.unsafeFreeze ps

main = mults >>= print . sum
