import Data.List

cn = 20
cm = 12
ck = 10
cs = 70
ct = cn - ck

fac n = product [1..n] 

f 0 _ _ 0 = [[]]
f _ _ _ 0 = []
f x y m k = concatMap (\z -> map (z:) $ f (x - z) z m (k - 1)) [y..min x m]

main = print $ sum
  [ product [ct - y + 1..cn] * (xx - 1)^(ct - y) `div` (product $ map fac $ (x + y):xs)
  | xss@(xx:_) <- f cs 1 cm ck, let (x:xs) = map genericLength $ group xss, y <- [0..ct]
  ]
