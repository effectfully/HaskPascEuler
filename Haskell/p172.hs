import Data.List
import Control.Applicative

cn = 18
ck = 3

cf n k = product [n - k + 1..n] `div` product [1..k]

f x y k          
  | x == 0    = [[]]
  | k == 0    = []
  | otherwise = concatMap (\z -> map (z:) $ f (x - z) z (k - 1)) [y..min ck x] 

g m = product . (scanl (-) m >>= zipWith cf)

main = print $ ((* 9) . (`div` 10)) $ sum $ 
  map ((*) <$> g cn <*> g 10 . map genericLength . group) $ f cn 1 10
