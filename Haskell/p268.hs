import Data.List
import Data.Array

nmax = 10^16 - 1
prs  = [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97]
ts   = listArray (4, length prs) $ zipWith (*) (cycle [1, -1]) $ scanl1 (+) $ scanl1 (+) [1..]

f n k xs
  | null xs || nx' > nmax = if k < 4 then 0 else nmax `div` n * ts!k
  | otherwise = f nx' (k + 1) xs' + f n k xs'
  where (x':xs', nx') = (xs, n * x')

main = print $ f 1 0 prs
