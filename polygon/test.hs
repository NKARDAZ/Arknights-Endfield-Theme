-- ============ 1. КОММЕНТАРИИ ============
-- однострочный комментарий
{- блочный
   многострочный комментарий -}
{-|
  Haddock doc-комментарий модуля
-}
module ThemeTest
  ( Shape(..)
  , area
  , mainFunction
  ) where

-- ============ 2. ИМПОРТЫ ============
import Data.List (sort, nub)
import qualified Data.Map as Map
import Data.Map (Map)
import Control.Monad (forM_, when, unless)
import System.IO (hPutStrLn, stderr)

-- ============ 3. ЛИТЕРАЛЫ ============
intDec :: Int
intDec = 42

intNeg :: Int
intNeg = -17

floatNum :: Double
floatNum = 3.14159

expNum :: Double
expNum = 6.022e23

hexNum :: Int
hexNum = 0xFF00FF

octNum :: Int
octNum = 0o755

binNum :: Int
binNum = 0b1010

boolTrue :: Bool
boolTrue = True

boolFalse :: Bool
boolFalse = False

charVal :: Char
charVal = 'A'

-- ============ 4. СТРОКИ ============
simpleString :: String
simpleString = "обычная строка"

escapedString :: String
escapedString = "с \"кавычками\" и \n переводом строки"

multilineString :: String
multilineString = "строка \
                   \продолженная"

-- ============ 5. ТИПЫ ДАННЫХ ============
data Shape
  = Circle Double
  | Rectangle Double Double
  | Triangle Double Double Double
  deriving (Show, Eq, Ord)

data Maybe' a = Nothing' | Just' a
  deriving (Show)

newtype Wrapper a = Wrapper { unwrap :: a }

type Name = String
type Coordinates = (Double, Double)

-- ============ 6. TYPECLASS ============
class Describable a where
  describe :: a -> String
  describe _ = "неизвестно"

instance Describable Shape where
  describe (Circle r) = "круг радиуса " ++ show r
  describe (Rectangle w h) = "прямоугольник " ++ show w ++ "x" ++ show h
  describe (Triangle a b c) = "треугольник"

class (Eq a, Show a) => Comparable a where
  compareValues :: a -> a -> Ordering

-- ============ 7. ФУНКЦИИ ============
area :: Shape -> Double
area (Circle r) = pi * r * r
area (Rectangle w h) = w * h
area (Triangle a b c) =
  let s = (a + b + c) / 2
  in sqrt (s * (s - a) * (s - b) * (s - c))

square :: Num a => a -> a
square x = x * x

addPair :: (Int, Int) -> Int
addPair (a, b) = a + b

-- ============ 8. GUARDS И PATTERN MATCHING ============
classify :: Int -> String
classify n
  | n < 0     = "отрицательное"
  | n == 0    = "ноль"
  | n < 10    = "маленькое"
  | otherwise = "большое"

fibonacci :: Int -> Int
fibonacci 0 = 0
fibonacci 1 = 1
fibonacci n = fibonacci (n - 1) + fibonacci (n - 2)

firstOrDefault :: [a] -> a -> a
firstOrDefault [] def = def
firstOrDefault (x:_) _ = x

-- ============ 9. LAMBDA И HIGHER-ORDER FUNCTIONS ============
doubled :: [Int] -> [Int]
doubled = map (\x -> x * 2)

filtered :: [Int] -> [Int]
filtered = filter even

composed :: Int -> Int
composed = (* 2) . (+ 1)

-- ============ 10. LET, WHERE, CASE ============
calculate :: Int -> Int
calculate x =
  let y = x * 2
      z = y + 1
  in y + z

describeNumber :: Int -> String
describeNumber n = case n of
  0 -> "ноль"
  n | n > 0 -> "положительное"
    | otherwise -> "отрицательное"

withWhere :: Int -> Int -> Int
withWhere a b = result
  where
    result = a' + b'
    a' = a * 2
    b' = b * 3

-- ============ 11. МОНАДЫ (Maybe, Either, IO) ============
safeDivide :: Double -> Double -> Maybe Double
safeDivide _ 0 = Nothing
safeDivide a b = Just (a / b)

safeDivideEither :: Double -> Double -> Either String Double
safeDivideEither _ 0 = Left "деление на ноль"
safeDivideEither a b = Right (a / b)

doNotation :: IO ()
doNotation = do
  let x = 42
  putStrLn ("Значение: " ++ show x)
  when boolTrue $ putStrLn "условие истинно"
  forM_ [1, 2, 3] $ \i -> do
    putStrLn ("Итерация: " ++ show i)

-- ============ 12. LIST COMPREHENSIONS ============
squares :: [Int]
squares = [x * x | x <- [1..10], even x]

pairs :: [(Int, Int)]
pairs = [(x, y) | x <- [1..3], y <- [1..3], x /= y]

-- ============ 13. ЛЕНИВЫЕ ВЫЧИСЛЕНИЯ И БЕСКОНЕЧНЫЕ СПИСКИ ============
naturals :: [Int]
naturals = [1..]

fibs :: [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

-- ============ 14. MAIN ============
mainFunction :: IO ()
mainFunction = do
  let shapes = [Circle 5.0, Rectangle 3.0 4.0]
  forM_ shapes $ \s -> do
    putStrLn (describe s ++ ": " ++ show (area s))
  doNotation

main :: IO ()
main = mainFunction
