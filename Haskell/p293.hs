import Data.List

isPrime n = n > 1 && foldr (\p r -> p * p > n || ((n `rem` p) /= 0 && r)) True primes
primes = 2 : filter isPrime [3,5..]

f n      _   | n >= 10^9 = []
f n (x:y:xs) = n : f (n * x) (x:y:xs) ++ f (n * y) (y:xs)

g x = subtract x $ head $ dropWhile (not . isPrime) [x + 2..]

main = print $ sum $ nub $ map g $ f 2 primes
