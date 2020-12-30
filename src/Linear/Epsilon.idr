module Linear.Epsilon

public export
interface Num a => Epsilon a where
  ||| Determine if a quantity is near zero.
  nearZero : a -> Bool

public export
implementation Epsilon Double where
  nearZero a = abs a <= (10 `pow` -12)
