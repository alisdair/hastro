module Redis where

import           Control.Applicative
import           Data.ByteString as B
import           Data.Word (Word8)
import qualified Data.Attoparsec.Char8 as AC
import           Data.Attoparsec.Lazy as AL
import qualified Data.ByteString.Lazy as BL

type Request = [ByteString]

parseRequest :: BL.ByteString -> Request
parseRequest request = case parse parseArgument request of
                 Fail {} -> []
                 Done request' argument -> argument : parseRequest request'

parseArgument :: Parser ByteString
parseArgument = word8 36 *> getArgument <* crlf
  where getArgument = AC.decimal <* crlf >>= AL.take

crlf :: Parser ByteString
crlf = string $ B.pack [13, 10]
