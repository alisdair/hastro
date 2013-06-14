import Redis
import Data.ByteString.Lazy as BL

main = do
    raw <- BL.getContents
    print $ parseRequest raw
