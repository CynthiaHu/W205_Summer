import tweepy

consumer_key = "vCQveddofv******AuRU7Aq";
#eg: consumer_key = "YisfFjiodKtojtUvW4MSEcPm";


consumer_secret = "d15upoch7rsrgzp****************5Hr1cjhtbVQTK";
#eg: consumer_secret = "YisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPm";

access_token = "2287158984-*******************zvmtBdKTydGMDqHR5";
#eg: access_token = "YisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPm";

access_token_secret = "fwVCAU4qCI6IP1*************9Vvoqn9LtI0XpvfZ";
#eg: access_token_secret = "YisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPm";


auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)



