xs3 = tail $ scanl1 (+) $ scanl (+) 1 [6,12..]

isSqr x = (round $ sqrt $ fromIntegral x)^2 == x

ps = [read $ sx ++ d ++ reverse sx | x <- [1..], d <- "" : map show [0..9], let sx = show x]

main = print $ sum $ take 5 $ filter (\x -> (== 4) . length $ filter (isSqr . (x -)) $ takeWhile (< x - 1) xs3) ps
