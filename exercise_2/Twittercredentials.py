import tweepy

consumer_key = "vCQveddofvBnzmVu5BAuRU7Aq";
#eg: consumer_key = "YisfFjiodKtojtUvW4MSEcPm";


consumer_secret = "d15upoch7rsrgzpI6JysSuMEPN0aE0t8yOZ5b5Hr1cjhtbVQTK";
#eg: consumer_secret = "YisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPm";

access_token = "2287158984-0cPiKsZEBUwJfpCNRZnL4kzvmtBdKTydGMDqHR5";
#eg: access_token = "YisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPm";

access_token_secret = "fwVCAU4qCI6IP1Gcf9g0eRI9BLV4X9Vvoqn9LtI0XpvfZ";
#eg: access_token_secret = "YisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPm";


auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)



