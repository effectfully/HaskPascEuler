-- This one is particularly nice and fast (compared to other solutions to this problem).

import Data.List

isPrime n = n > 1 && foldr (\p r -> p * p > n || ((n `rem` p) /= 0 && r)) True primes
primes = 2 : filter isPrime [3,5..]

n = 9

f :: Int -> [Int] -> Int -> Int
f x ys m
  | x == 0    = s2
  | isPrime x = if null ys then 1 else s1 + s2
  | otherwise = s1
  where
    s1 = if x > 10^7 then 0 else
           sum $ map (\z -> f (10 * x + z) (delete z ys) m) $ ys
    s2 =   sum $ map (\z -> f       z      (delete z ys) z) $ takeWhile (<= m) ys

main = print $ f 0 [1..n] n
