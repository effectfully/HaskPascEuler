isPrime n = n > 1 && foldr (\p r -> p * p > n || n `rem` p /= 0 && r) True primes
primes = 2 : filter isPrime [3,5..]

cxs = [(x, x) | x <- [0..9]]

f xs = [(n', s') | (n, s) <- xs, (cn, cs) <- cxs, let (n', s') = (n * 10 + cn, s + cs), n' `rem` s' == 0]

h xs =  [n' | (n, s) <- xs, isPrime $ n `div` s, d <- [1, 3, 7, 9], let n' = n * 10 + d, isPrime n']

main = print $ sum $ h $ concat $ take 13 $ iterate f $ tail cxs
