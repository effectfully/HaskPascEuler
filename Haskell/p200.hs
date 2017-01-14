import Data.List

isPrime n = n > 1 && foldr (\p r -> p * p > n || ((n `rem` p) /= 0 && r)) True primes
primes = 2 : filter isPrime [3,5..]

toDigitsRev = map (`rem` 10) . takeWhile (> 0) . iterate (`div` 10)
unDigitsRev = foldl ((+) . (* 10)) 0 . reverse
 
g k p = takeWhile (<= 10^12 `div` k) $ map (^p) primes
xs    = filter ([0,0,2] `isInfixOf`) $ map toDigitsRev $ 
 sort [x2 * x3 | x3 <- g 1 3, x2 <- g x3 2, x2^3 /= x3^2]
 
f (x:xs) = all (not . isPrime . unDigitsRev) 
  [ l1 ++ [d] ++ l2
  | t <- [0 .. if even x || x == 5 then 0 else length xs]
  , let (l1, l:l2) = splitAt t (x:xs)
  , d <- delete l $ if null l1 then [1,3,7,9] else [0..9]
  ]

main = print $ unDigitsRev $ (!! 199) $ filter f xs
