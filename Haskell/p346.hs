import Data.List

main = print $ succ . sum $ map head . group . sort $ 
  concatMap (takeWhile (< 10^12) . drop 2 . scanl1 (+) . flip iterate 1 . (*)) [2..10^6]
