{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeApplications #-}

import Data.Bifunctor
import qualified Data.IntSet as IntSet
import Data.List (partition)
import Data.Function.Memoize

data Associativity
    = AllAllowed
    | PlusAndMinusNotAllowed
    | MultiplyAndDivideNotAllowed
    deriving (Eq)

deriveMemoizable ''Associativity

concatDigits :: [Int] -> [Double]
concatDigits [] = []
concatDigits xs = [fromIntegral . read @Int $ concatMap show xs]

-- >>> allSplits []
-- >>> allSplits [1]
-- []
-- >>> allSplits [1,2,3,4]
-- [([1],[2,3,4]),([1,2],[3,4]),([1,2,3],[4])]
allSplits :: [Int] -> [([Int], [Int])]
allSplits []       = []
allSplits (x0:xs0) = go x0 xs0 where
    go :: Int -> [Int] -> [([Int], [Int])]
    go _ []     = []
    go x (y:xs) = ([x], y:xs) : map (first (x :)) (go y xs)

epsilon :: Double
epsilon = 1 / 10^6

isInt :: Double -> Bool
isInt x = abs (fromIntegral (round x) - x) < epsilon

removeDuplicates :: [Double] -> [Double]
removeDuplicates xs = case partition isInt xs of
    (ints, doubles) -> concat
        [ doubles
        , map fromIntegral (IntSet.elems (IntSet.fromList (map round ints)))
        ]

-- >>> sum $ process [1..9]
-- 20101196798
process :: [Int] -> [Int]
process = map round . filter (\x -> x > 0 && isInt x) . go AllAllowed where
    go :: Associativity -> [Int] -> [Double]
    go = memoize2 $ \assoc xs -> removeDuplicates $ concatDigits xs ++ do
        (xsL, xsR) <- allSplits xs
        (assocNew, op) <- concat
            [ if (assoc /= PlusAndMinusNotAllowed)
                then map ((,) PlusAndMinusNotAllowed)
                         [\x y -> [x + y], \x y -> [x - y]]
                else []
            , if (assoc /= MultiplyAndDivideNotAllowed)
                then map ((,) MultiplyAndDivideNotAllowed)
                         [\x y -> [x * y], \x y -> [x / y | abs y < epsilon]]
                else []
            ]
        l <- go AllAllowed xsL
        r <- go assocNew xsR
        op l r
