import Control.Monad
import Data.Array.IO
import Data.Array.MArray

m  = 5 * 10^7 - 1
qm = floor . sqrt $ fromIntegral m

modifyArray ns i f = readArray ns i >>= \x -> writeArray ns i $! f x

main = do
  ns <- newArray (3, m) 0 :: IO (IOUArray Int Int)
  forM_ [1..3 * qm] $ \k ->
    forM_ (takeWhile (<= (m * 3)) $ map (\z -> k ^ 2 + 4 * k * z) $
             iterate (+ 3) (3 - k `rem` 3)) $ \v ->
      when (v `rem` 3 == 0) $
        modifyArray ns (v `div` 3) succ
  getElems ns >>= print . length . filter (== 1)
