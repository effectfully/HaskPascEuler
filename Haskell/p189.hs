import Data.List
import Data.Maybe
import Data.Map hiding (map, foldr, (\\))
import Control.Monad

everywhere x xs = x : foldr ((++) . (:[x])) [] xs

f xs = map (succ . fromJust . flip elemIndex nxs) xs where nxs = nub xs

h yss = [ (f [t | (i, t) <- zip [0..] fys, even i], k)
        | (ys, k) <- yss
        , fys <- foldM (\xs@(x:_) z -> map (:xs) $ [1..3] \\ [x, z]) [0] $ everywhere 0 ys
        ]

main = print $ sum $ map snd $ (!! 8) $ iterate (h . toList . fromListWith (+)) [([],1)]
