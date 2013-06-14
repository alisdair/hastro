module Redis where

import           Control.Applicative
import           Data.ByteString
import           Data.Word (Word8)
import qualified Data.Attoparsec.Char8 as AC
import           Data.Attoparsec.Lazy as AL
import qualified Data.ByteString.Lazy as BL

default (ByteString)

type Request = [ByteString]

parseRequest :: BL.ByteString -> Request
parseRequest request = case parse parseArgument request of
                 Fail {} -> []
                 Done request' argument -> argument : parseRequest request'

parseArgument :: Parser ByteString
parseArgument = word8 36 *> getArgument <* cr <* lf
  where getArgument = AC.decimal <* cr <* lf >>= AL.take

cr :: Parser Word8
cr = word8 13

lf :: Parser Word8
lf = word8 10
