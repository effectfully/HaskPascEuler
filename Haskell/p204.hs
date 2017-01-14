prs = [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97]

f n xs
  | null xs || nx' > 10^9 = 1
  | otherwise = f nx' xs + f n xs'
  where (x':xs', nx') = (xs, n * x')

main = print $ f 1 prs
