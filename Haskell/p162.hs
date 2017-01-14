import Data.Bits
import Data.Map hiding (map)
import Data.Char
import Numeric

toSHex x = map toUpper $ showIntAtBase 16 intToDigit x ""

f :: [(Integer, Integer)] -> [(Integer, Integer)]
f = toList . fromListWith (+) . concatMap (\(x, y) -> (x, y * 13) : map (flip (,) y . (x .|.)) [1,2,4])

main = print $ toSHex $ sum $ map (snd . last) $ drop 2 . take 16 $ iterate f [(0, 13),(2, 1),(4, 1)]
