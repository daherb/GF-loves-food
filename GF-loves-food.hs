import PGF
import System.Random
import System.IO
import Data.Time.Clock.POSIX
import System.CPUTime

selectRandom :: RandomGen g => [a] -> g -> (a, g)
selectRandom list rnd =
  let
    (rndNum,newRnd) = randomR (0,(length list - 1)) rnd
    elem = list!!rndNum
  in
    (elem, newRnd)

generate :: RandomGen g => PGF -> g -> (String,g)
generate pgf rnd =
  let
    gen = generateRandom rnd pgf (startCat pgf)
    (lang,newRnd) = (selectRandom (languages pgf) rnd)
    s = linearize pgf lang (head gen)
  in
    (s,newRnd)

main =
  do
    cputime <- getCPUTime
    pgf <- (readPGF "Foods.pgf")
    time <- round `fmap` getPOSIXTime 
    let rnd = (mkStdGen (fromInteger (toInteger time + cputime ) ))
    let (s,newRnd) = generate pgf rnd
    putStrLn s
