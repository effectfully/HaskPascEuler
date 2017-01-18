-- ~32s. Handles triplets. I was too lazy to precompute squares.

import Data.Function
import Data.Maybe
import Data.List
import Control.Monad

pairs xs = xs >>= \x -> (,) x <$> takeWhile (/= x) xs

isSqr n = (round . sqrt . fromIntegral $ n) ^ 2 == n

fromDigits (0:_) = Nothing
fromDigits  xs   = Just $ foldl ((+) . (* 10)) 0 xs

encodeWord = go [0..9] where
  go is  ""   = [[]]
  go is (c:s) = is >>= \i -> map ((c, i) :) . go (delete i is) $ filter (/= c) s

groupAllBy f = map (map snd) . groupBy ((==) `on` fst) . sort . map (f >>= (,))

subst e = mapM (flip lookup e) >=> fromDigits

anagrams = filter (not . null)
         . map (concatMap pairs . groupAllBy (map ((,) <*> length) . groupAllBy id))
         . groupAllBy length

check (s, t) = encodeWord s >>= \e -> fromMaybe [] . mfilter (all isSqr) $ mapM (subst e) [s, t]

squares = filter (not . null) . map (>>= check) . reverse . anagrams

parse = words . map (\c -> if c == ',' || c == '\"' then ' ' else c) <$> readFile "words.txt"

main = parse >>= print . maximum . head . squares
