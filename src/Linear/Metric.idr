module Linear.Metric

import Linear.Epsilon
import Linear.Vect

public export
interface Additive f => Metric f where
  ||| Compute the inner product of two vectors or (equivalently)
  ||| convert a vector `f a` into a covector `f a -> a`.
  |||
  ||| ```idris example
  ||| V2 1 2 `dot` V2 3 4
  ||| ```
  dot : Num a => f a -> f a -> a

  ||| Compute the squared norm. The name quadrance arises from
  ||| Norman J. Wildberger's rational trigonometry.
  quadrance : Num a => f a -> a
  quadrance v = dot v v

  ||| Compute the quadrance of the difference
  qd : Neg a => f a -> f a -> a
  qd f g = quadrance (f ^-^ g)

  ||| Compute the distance between two vectors in a metric space
  distance : (Floating a, Neg a) => f a -> f a -> a
  distance f g = norm (f ^-^ g)

  ||| Compute the norm of a vector in a metric space
  norm : Floating a => f a -> a
  norm v = cast (sqrt (cast (quadrance v)))

  ||| Convert a non-zero vector to unit vector.
  signorm : Floating a => f a -> f a
  signorm v = let m = norm v in map (/m) v

public export
implementation (Additive f, Foldable f) => Metric f where
  dot x y = sum $ liftI2 (*) x y

||| Normalize a 'Metric' functor to have unit 'norm'. This function
||| does not change the functor if its 'norm' is 0 or 1.
export
normalize : (Floating a, Metric f, Epsilon a, Neg a) => f a -> f a
normalize v =
  let l = quadrance v
   in if nearZero l || nearZero (1 - l)
        then v
        else map (/ cast (sqrt (cast l))) v

||| `project u v` computes the projection of `v` onto `u`.
export
project : (Metric v, Fractional a, Neg a) => v a -> v a -> v a
project u v = ((v `dot` u) / quadrance u) *^ u
