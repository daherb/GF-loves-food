module Twitter where
-- Twitter stuff
import           Control.Monad
import           Data.Aeson
import           GHC.Generics
import           Data.ByteString
import qualified Data.ByteString.Char8   as B
import qualified Data.ByteString.Lazy    as BL
import qualified Network.HTTP.Base       as HTTP
import           Network.HTTP.Client
import           Network.HTTP.Client.TLS
import           Network.HTTP.Types
import           Web.Authenticate.OAuth

data Config = Config {
    apiKey       :: String,
    apiSecret    :: String,
    userKey      :: String,
    userSecret   :: String
  } deriving (Show, Generic)

instance FromJSON Config
instance ToJSON Config

configFromFile :: FilePath -> IO (Either String Config)
configFromFile path = do
  contents <- BL.readFile path
  return $ eitherDecode contents

oauthTwitter :: ByteString -> ByteString -> OAuth
oauthTwitter key secret =
  newOAuth { oauthServerName      = "twitter"
           , oauthRequestUri      = "https://api.twitter.com/oauth/request_token"
           , oauthAccessTokenUri  = "https://api.twitter.com/oauth/access_token"
           , oauthAuthorizeUri    = "https://api.twitter.com/oauth/authorize"
           , oauthSignatureMethod = HMACSHA1
           , oauthConsumerKey     = key
           , oauthConsumerSecret  = secret
           , oauthVersion         = OAuth10a
           }

signWithConfig :: Config -> Request -> IO Request
signWithConfig Config{..} = signOAuth
  (oauthTwitter (B.pack apiKey) (B.pack apiSecret))
  (newCredential (B.pack userKey) (B.pack userSecret))

tweet :: Config -> String -> IO() --IO (Response BL.ByteString)
tweet config status = do
  url <- parseUrl $ "https://api.twitter.com/1.1/statuses/update.json?status=" ++ HTTP.urlEncode status
  req <- signWithConfig config url{ method = B.pack "POST" }
  manager <- newManager tlsManagerSettings
  res <- httpLbs req manager
  Prelude.putStrLn "Tweeted"
  

