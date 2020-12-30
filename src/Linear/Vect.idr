module Linear.Vect

import Data.List
import Data.Vect

infixl 6 ^+^, ^-^
infixl 7 ^*, *^, ^/

public export
V2 : a -> a -> Vect 2 a
V2 x y = x :: y :: Nil

public export
V3 : a -> a -> a -> Vect 3 a
V3 x y z = x :: y :: z :: Nil

public export
V4 : a -> a -> a -> a -> Vect 4 a
V4 a b c d = a :: b :: c :: d :: Nil

public export
implementation Semigroup a => Semigroup (Vect n a) where
  (<+>) = zipWith (<+>)

public export
implementation {n : Nat} -> Monoid a => Monoid (Vect n a) where
  neutral = pure neutral

public export
implementation {n : Nat} -> Num a => Num (Vect n a) where
  (+) = zipWith (+)
  (*) = zipWith (*)
  fromInteger = pure . fromInteger

||| Compute the negation of a vector
|||
||| ```idris example
||| negated (V2 2 4)
||| ```
export
negated : (Functor f, Neg a) => f a -> f a
negated = map negate

||| Compute the left scalar product
|||
||| ```idris example
||| 2 *^ V2 3 4
||| ```
export
(*^) : (Functor f, Neg a) => a -> f a -> f a
(*^) a = map (a *)

||| Compute the right scalar product
|||
||| ```idris example
||| the (Vect ? ?) [3, 4] ^* 2
||| ```
export
(^*) : (Functor f, Neg a) => f a -> a -> f a
f ^* a = map (* a) f

||| Compute division by a scalar on the right.
export
(^/) : (Functor f, Fractional a) => f a -> a -> f a
f ^/ a = map (/a) f

public export
interface Functor f => Additive f where
  ||| The zero vector
  zero : Num a => f a

  ||| Compute the sum of two vectors
  |||
  ||| ```idris example
  ||| V2 1 2 ^+^ V2 3 4
  (^+^) : Num a => f a -> f a -> f a
  (^+^) = liftU2 (+)

  ||| Compute the difference between two vectors
  |||
  ||| ```idris example
  ||| V2 4 5 ^-^ V2 3 1
  ||| ```
  (^-^) : Neg a => f a -> f a -> f a
  x ^-^ y = x ^+^ negated y

  ||| Linearly interpolate between two vectors.
  lerp : Neg a => a -> f a -> f a -> f a
  lerp alpha u v = alpha *^ u ^+^ (1 - alpha) *^ v

  ||| Apply a function to merge the 'non-zero' components of two vectors, unioning the rest of the values.
  |||
  ||| * For a dense vector this is equivalent to 'liftA2'.
  |||
  ||| * For a sparse vector this is equivalent to 'unionWith'.
  liftU2 : (a -> a -> a) -> f a -> f a -> f a

  ||| Apply a function to the components of two vectors.
  |||
  ||| * For a dense vector this is equivalent to 'liftA2'.
  |||
  ||| * For a sparse vector this is equivalent to 'intersectionWith'.
  liftI2 : (a -> b -> c) -> f a -> f b -> f c

||| Sum over multiple vectors
|||
||| ```idris example
||| sumV [V2 1 1, V2 3 4]
||| ```
export
sumV : (Foldable f, Additive v, Num a) => f (v a) -> v a
sumV = foldl (^+^) zero

public export
interface (Num a, Fractional a, Cast a Double, Cast Double a) => Floating a where

liftA2 : Applicative f => (a -> b -> c) -> f a -> f b -> f c
liftA2 f x = (<*>) (map f x)

public export
implementation Applicative f => Additive f where
  zero = pure 0
  liftU2 = liftA2
  liftI2 = liftA2

public export
implementation Additive Maybe where
  zero = Nothing
  liftU2 f (Just a) (Just b) = Just (f a b)
  liftU2 _ Nothing ys = ys
  liftU2 _ xs Nothing = xs
  liftI2 = liftA2

{-
||| Produce a default basis for a vector space from which the
||| argument is drawn.
basisFor : (Traversable t, Num a) => t b -> List (t a)
-- basisFor = \t ->
--    ifoldMapOf traversed ?? t $ \i _ ->
--      return                  $
--        iover  traversed ?? t $ \j _ ->
--          if i == j then 1 else 0

basis : (Additive t, Traversable t, Num a) => List (t a)
basis = basisFor zero'
  where
    zero' : Additive v => v Int
    zero' = zero

scaled : (Traversable t, Num a) => t a -> t (t a)

unit : (Additive t, Num a) => ASetter' (t a) a -> t a
-}

||| Outer (tensor) product of two vectors
export
outer : (Functor f, Functor g, Num a) => f a -> g a -> f (g a)
outer a b = map (\x => map (*x) b) a
