import Network (listenOn, accept, PortID(..), Socket)
import System.IO (hSetBuffering, hGetLine, hPutStrLn, BufferMode(..), Handle)
import Control.Concurrent (forkIO)

main :: IO ()
main = do
    let port = 4570
    sock <- listenOn $ PortNumber port
    putStrLn $ "Listening on " ++ (show port)
    sockHandler sock

sockHandler :: Socket -> IO ()
sockHandler sock = do
    (handle, _, _) <- accept sock
    hSetBuffering handle NoBuffering
    forkIO $ commandProcessor handle
    sockHandler sock

commandProcessor :: Handle -> IO ()
commandProcessor handle = do
    line <- hGetLine handle
    let cmd = words line
    case (head cmd) of
        ("ping") -> pingCommand handle cmd
        _ -> do hPutStrLn handle "Unknown command"
    commandProcessor handle

pingCommand :: Handle -> [String] -> IO ()
pingCommand handle cmd = do
    hPutStrLn handle "pong"

