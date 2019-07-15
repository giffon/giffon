-- MySQL dump 10.16  Distrib 10.3.9-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: giffon
-- ------------------------------------------------------
-- Server version	5.7.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `coupon`
--

LOCK TABLES `coupon` WRITE;
/*!40000 ALTER TABLE `coupon` DISABLE KEYS */;
INSERT INTO `coupon` VALUES (1,1,'GOODIE',11.1000,1.1000,1,NULL,NULL),(2,1,'PAST',100.0000,10.0000,NULL,'2018-01-01 00:00:00',NULL),(3,1,'BIRD',10.0000,1.0000,NULL,NULL,'[\"twitter\"]'),(4,1,'2CENTS',2.0000,0.2000,NULL,NULL,NULL);
/*!40000 ALTER TABLE `coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `item`
--

LOCK TABLES `item` WRITE;
/*!40000 ALTER TABLE `item` DISABLE KEYS */;
INSERT INTO `item` VALUES (1,'https://www.amazon.com/Fossil-Minimalist-Quartz-Stainless-Leather/dp/B06W2JSJ4H/ref=br_asw_pdt-8?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=&pf_rd_r=09VNN328SST3JCQ7M5R2&pf_rd_t=36701&pf_rd_p=64fe8e92-753c-466e-b4cf-16a6e5b6a866&pf_rd_i=desktop',NULL,'Fossil Mens The Minimalist - FS5304',82.9500,'2019-07-12 03:21:48','2019-07-12 03:21:48','USD'),(2,'https://www.amazon.com/Nintendo-Switch-Neon-Red-Blue-Joy/dp/B01MUAGZ49/ref=br_asw_pdt-1?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=&pf_rd_r=VSPGY02NRKSERR8HB7S9&pf_rd_t=36701&pf_rd_p=52f0bcf2-3c32-48d5-a5df-c5f82e2d98df&pf_rd_i=desktop&th=1',NULL,'Nintendo Switch',298.0000,'2019-07-12 03:24:19','2019-07-12 03:24:19','USD'),(3,'https://www.hktvmall.com/hktv/zh/main/Macie-Department-Store/s/H6126001/%E5%AE%B6%E5%93%81%E5%82%A2%E4%BF%AC/%E5%AE%B6%E5%93%81%E5%82%A2%E4%BF%AC/%E9%A4%90%E6%A1%8C%E7%94%A8%E5%93%81/%E7%A2%9F%E5%8F%8A%E6%89%98%E7%9B%A4/%E9%A4%90%E7%A2%9F/16%E4%BB%B6%E5%B0%8F%E8%97%8D%E8%8A%B1%E7%B3%BB%E5%88%97%E9%A4%90%E5%85%B7%E5%A5%97%E8%A3%9D-%E5%B9%B3%E8%A1%8C%E9%80%B2%E5%8F%A3%E8%B2%A8%E5%93%81/p/H6126001_S_CE100001',NULL,'餐具套裝',568.0000,'2019-07-12 03:31:28','2019-07-12 03:31:28','HKD'),(4,'https://www.hktvmall.com/hktv/zh/main/MAX-SPORT/s/H6336001/%E8%BF%AA%E5%A3%AB%E5%B0%BC/%E8%BF%AA%E5%A3%AB%E5%B0%BC/%E8%BF%AA%E5%A3%AB%E5%B0%BC/%E7%8D%85%E5%AD%90%E7%8E%8B/%E7%8D%85%E5%AD%90%E7%8E%8B-%E6%B2%99%E7%81%98%E7%90%83-%E4%B8%80%E5%80%8B-%E5%8E%9A%E6%96%99-20-51cm-%E7%8D%A8%E7%AB%8B%E5%8C%85%E8%A3%9D/p/H6336001_S_58045?openinapp=true&autoTriggerApp=true',NULL,'沙灘球',60.0000,'2019-07-12 03:37:32','2019-07-12 03:37:32','HKD'),(5,'https://www.amazon.com/Haxe-Development-Essentials-Jeremy-McCurdy/dp/1785289780',NULL,'Haxe Game Development Essentials',24.9900,'2019-07-12 04:07:33','2019-07-12 04:07:33','USD');
/*!40000 ALTER TABLE `item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `pledge`
--

LOCK TABLES `pledge` WRITE;
/*!40000 ALTER TABLE `pledge` DISABLE KEYS */;
INSERT INTO `pledge` VALUES (1,2,2,66.6000,'2019-07-12 03:41:21','StripeCard',NULL,'USD','HiddenFromAll'),(2,2,3,5.0000,'2019-07-12 03:41:53','StripeCard',NULL,'HKD','VisibleToAll'),(3,3,2,656.2800,'2019-07-12 03:43:27','StripeCard',NULL,'USD','VisibleToWishOwner'),(4,1,2,1.1000,'2019-07-12 03:53:11','Coupon',NULL,'USD','VisibleToAll'),(5,1,3,2.0000,'2019-07-12 03:55:08','Coupon',NULL,'HKD','VisibleToAll');
/*!40000 ALTER TABLE `pledge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `pledge_coupon`
--

LOCK TABLES `pledge_coupon` WRITE;
/*!40000 ALTER TABLE `pledge_coupon` DISABLE KEYS */;
INSERT INTO `pledge_coupon` VALUES (4,1),(5,4);
/*!40000 ALTER TABLE `pledge_coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `pledge_stripe`
--

LOCK TABLES `pledge_stripe` WRITE;
/*!40000 ALTER TABLE `pledge_stripe` DISABLE KEYS */;
INSERT INTO `pledge_stripe` VALUES (1,'ch_1EvFdPCIMzObh1OAn51wOrdV'),(2,'ch_1EvFdwCIMzObh1OACAfpPQXy'),(3,'ch_1EvFfSCIMzObh1OAm9XNJU1W');
/*!40000 ALTER TABLE `pledge_stripe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('2Aq2HVcya0iPuDTCEDt1H61neJxsS6B4',1562992955,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"secure\":false,\"httpOnly\":true,\"path\":\"/\"},\"redirectTo\":null,\"passport\":{\"user\":1}}'),('2lOt2XJoWYSG63dP1shejk5ogrETS_ed',1562990901,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"secure\":false,\"httpOnly\":true,\"path\":\"/\"},\"passport\":{\"user\":3}}'),('u6FTJXwo2i9QQo_vA7xyC4Vc_sE-yRHa',1562989314,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"secure\":false,\"httpOnly\":true,\"path\":\"/\"},\"redirectTo\":null,\"passport\":{\"user\":2}}'),('vnIP1jZrrYC1lZK-bg4cb4TIYyivj54z',1562989705,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"secure\":false,\"httpOnly\":true,\"path\":\"/\"},\"redirectTo\":null,\"passport\":{\"user\":3}}');
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'X8lX','andy@onthewings.net','Andy Li',NULL,0,NULL,NULL,'I want some ?!','https://d1ksq9ahsv51u8.cloudfront.net/32f76f545cb76e987a924b02555aa812.jpg'),(2,'ODxO','open_pvcdapr_user@tfbnw.net','Open Graph Test User',NULL,0,NULL,NULL,NULL,'https://d1ksq9ahsv51u8.cloudfront.net/8baf4382926b802fcb1cd8794ed955f8.jpg'),(3,'XVmN','aeijhlqbaz_1541125091@tfbnw.net','Will Albiidgaddbag Huisen',NULL,0,NULL,NULL,NULL,'https://d1ksq9ahsv51u8.cloudfront.net/3cdcb680ea55f663832e791d33c5d264.jpg');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_facebook`
--

LOCK TABLES `user_facebook` WRITE;
/*!40000 ALTER TABLE `user_facebook` DISABLE KEYS */;
INSERT INTO `user_facebook` VALUES (1,'10156064172419833','{\"id\": \"10156064172419833\", \"_raw\": \"{\\\"id\\\":\\\"10156064172419833\\\",\\\"name\\\":\\\"Andy Li\\\",\\\"email\\\":\\\"andy\\\\u0040onthewings.net\\\",\\\"picture\\\":{\\\"data\\\":{\\\"height\\\":200,\\\"is_silhouette\\\":false,\\\"url\\\":\\\"https:\\\\/\\\\/platform-lookaside.fbsbx.com\\\\/platform\\\\/profilepic\\\\/?asid=10156064172419833&height=200&width=200&ext=1565495560&hash=AeQWafYcSO4NEyq7\\\",\\\"width\\\":200}}}\", \"name\": {}, \"_json\": {\"id\": \"10156064172419833\", \"name\": \"Andy Li\", \"email\": \"andy@onthewings.net\", \"picture\": {\"data\": {\"url\": \"https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=10156064172419833&height=200&width=200&ext=1565495560&hash=AeQWafYcSO4NEyq7\", \"width\": 200, \"height\": 200, \"is_silhouette\": false}}}, \"emails\": [{\"value\": \"andy@onthewings.net\"}], \"photos\": [{\"value\": \"https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=10156064172419833&height=200&width=200&ext=1565495560&hash=AeQWafYcSO4NEyq7\"}], \"provider\": \"facebook\", \"displayName\": \"Andy Li\"}'),(2,'103860947242717','{\"id\": \"103860947242717\", \"_raw\": \"{\\\"id\\\":\\\"103860947242717\\\",\\\"name\\\":\\\"Open Graph Test User\\\",\\\"email\\\":\\\"open_pvcdapr_user\\\\u0040tfbnw.net\\\",\\\"picture\\\":{\\\"data\\\":{\\\"height\\\":200,\\\"is_silhouette\\\":true,\\\"url\\\":\\\"https:\\\\/\\\\/platform-lookaside.fbsbx.com\\\\/platform\\\\/profilepic\\\\/?asid=103860947242717&height=200&width=200&ext=1565496439&hash=AeSSZeV0rnH49kJX\\\",\\\"width\\\":200}}}\", \"name\": {}, \"_json\": {\"id\": \"103860947242717\", \"name\": \"Open Graph Test User\", \"email\": \"open_pvcdapr_user@tfbnw.net\", \"picture\": {\"data\": {\"url\": \"https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=103860947242717&height=200&width=200&ext=1565496439&hash=AeSSZeV0rnH49kJX\", \"width\": 200, \"height\": 200, \"is_silhouette\": true}}}, \"emails\": [{\"value\": \"open_pvcdapr_user@tfbnw.net\"}], \"photos\": [{\"value\": \"https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=103860947242717&height=200&width=200&ext=1565496439&hash=AeSSZeV0rnH49kJX\"}], \"provider\": \"facebook\", \"displayName\": \"Open Graph Test User\"}'),(3,'101779010830337','{\"id\": \"101779010830337\", \"_raw\": \"{\\\"id\\\":\\\"101779010830337\\\",\\\"name\\\":\\\"Will Albiidgaddbag Huisen\\\",\\\"email\\\":\\\"aeijhlqbaz_1541125091\\\\u0040tfbnw.net\\\",\\\"picture\\\":{\\\"data\\\":{\\\"height\\\":200,\\\"is_silhouette\\\":true,\\\"url\\\":\\\"https:\\\\/\\\\/platform-lookaside.fbsbx.com\\\\/platform\\\\/profilepic\\\\/?asid=101779010830337&height=200&width=200&ext=1565496487&hash=AeSClTGCTBzWSOnY\\\",\\\"width\\\":200}}}\", \"name\": {}, \"_json\": {\"id\": \"101779010830337\", \"name\": \"Will Albiidgaddbag Huisen\", \"email\": \"aeijhlqbaz_1541125091@tfbnw.net\", \"picture\": {\"data\": {\"url\": \"https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=101779010830337&height=200&width=200&ext=1565496487&hash=AeSClTGCTBzWSOnY\", \"width\": 200, \"height\": 200, \"is_silhouette\": true}}}, \"emails\": [{\"value\": \"aeijhlqbaz_1541125091@tfbnw.net\"}], \"photos\": [{\"value\": \"https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=101779010830337&height=200&width=200&ext=1565496487&hash=AeSClTGCTBzWSOnY\"}], \"provider\": \"facebook\", \"displayName\": \"Will Albiidgaddbag Huisen\"}');
/*!40000 ALTER TABLE `user_facebook` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_github`
--

LOCK TABLES `user_github` WRITE;
/*!40000 ALTER TABLE `user_github` DISABLE KEYS */;
INSERT INTO `user_github` VALUES (1,'103977','{\"id\": \"103977\", \"_raw\": \"{\\\"login\\\":\\\"andyli\\\",\\\"id\\\":103977,\\\"node_id\\\":\\\"MDQ6VXNlcjEwMzk3Nw==\\\",\\\"avatar_url\\\":\\\"https://avatars1.githubusercontent.com/u/103977?v=4\\\",\\\"gravatar_id\\\":\\\"\\\",\\\"url\\\":\\\"https://api.github.com/users/andyli\\\",\\\"html_url\\\":\\\"https://github.com/andyli\\\",\\\"followers_url\\\":\\\"https://api.github.com/users/andyli/followers\\\",\\\"following_url\\\":\\\"https://api.github.com/users/andyli/following{/other_user}\\\",\\\"gists_url\\\":\\\"https://api.github.com/users/andyli/gists{/gist_id}\\\",\\\"starred_url\\\":\\\"https://api.github.com/users/andyli/starred{/owner}{/repo}\\\",\\\"subscriptions_url\\\":\\\"https://api.github.com/users/andyli/subscriptions\\\",\\\"organizations_url\\\":\\\"https://api.github.com/users/andyli/orgs\\\",\\\"repos_url\\\":\\\"https://api.github.com/users/andyli/repos\\\",\\\"events_url\\\":\\\"https://api.github.com/users/andyli/events{/privacy}\\\",\\\"received_events_url\\\":\\\"https://api.github.com/users/andyli/received_events\\\",\\\"type\\\":\\\"User\\\",\\\"site_admin\\\":false,\\\"name\\\":\\\"Andy Li\\\",\\\"company\\\":\\\"@HaxeFoundation\\\",\\\"blog\\\":\\\"https://giffon.io/andyli\\\",\\\"location\\\":\\\"Hong Kong\\\",\\\"email\\\":\\\"andy@onthewings.net\\\",\\\"hireable\\\":true,\\\"bio\\\":\\\"A Haxe developer. Building Giffon.io.\\\",\\\"public_repos\\\":258,\\\"public_gists\\\":51,\\\"followers\\\":281,\\\"following\\\":59,\\\"created_at\\\":\\\"2009-07-11T19:29:58Z\\\",\\\"updated_at\\\":\\\"2019-07-07T22:18:05Z\\\"}\", \"_json\": {\"id\": 103977, \"bio\": \"A Haxe developer. Building Giffon.io.\", \"url\": \"https://api.github.com/users/andyli\", \"blog\": \"https://giffon.io/andyli\", \"name\": \"Andy Li\", \"type\": \"User\", \"email\": \"andy@onthewings.net\", \"login\": \"andyli\", \"company\": \"@HaxeFoundation\", \"node_id\": \"MDQ6VXNlcjEwMzk3Nw==\", \"hireable\": true, \"html_url\": \"https://github.com/andyli\", \"location\": \"Hong Kong\", \"followers\": 281, \"following\": 59, \"gists_url\": \"https://api.github.com/users/andyli/gists{/gist_id}\", \"repos_url\": \"https://api.github.com/users/andyli/repos\", \"avatar_url\": \"https://avatars1.githubusercontent.com/u/103977?v=4\", \"created_at\": \"2009-07-11T19:29:58Z\", \"events_url\": \"https://api.github.com/users/andyli/events{/privacy}\", \"site_admin\": false, \"updated_at\": \"2019-07-07T22:18:05Z\", \"gravatar_id\": \"\", \"starred_url\": \"https://api.github.com/users/andyli/starred{/owner}{/repo}\", \"public_gists\": 51, \"public_repos\": 258, \"followers_url\": \"https://api.github.com/users/andyli/followers\", \"following_url\": \"https://api.github.com/users/andyli/following{/other_user}\", \"organizations_url\": \"https://api.github.com/users/andyli/orgs\", \"subscriptions_url\": \"https://api.github.com/users/andyli/subscriptions\", \"received_events_url\": \"https://api.github.com/users/andyli/received_events\"}, \"emails\": [{\"value\": \"andy@onthewings.net\"}], \"photos\": [{\"value\": \"https://avatars1.githubusercontent.com/u/103977?v=4\"}], \"provider\": \"github\", \"username\": \"andyli\", \"profileUrl\": \"https://github.com/andyli\", \"displayName\": \"Andy Li\"}');
/*!40000 ALTER TABLE `user_github` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_gitlab`
--

LOCK TABLES `user_gitlab` WRITE;
/*!40000 ALTER TABLE `user_gitlab` DISABLE KEYS */;
INSERT INTO `user_gitlab` VALUES (1,'91802','{\"id\": \"91802\", \"_raw\": \"{\\\"id\\\":91802,\\\"name\\\":\\\"Andy Li\\\",\\\"username\\\":\\\"andyli\\\",\\\"state\\\":\\\"active\\\",\\\"avatar_url\\\":\\\"https://secure.gravatar.com/avatar/8c51d8ddded0dde6c2451a7845b8bb46?s=80\\\\u0026d=identicon\\\",\\\"web_url\\\":\\\"https://gitlab.com/andyli\\\",\\\"created_at\\\":\\\"2015-02-02T01:49:05.437Z\\\",\\\"bio\\\":\\\"\\\",\\\"location\\\":\\\"Hong Kong\\\",\\\"public_email\\\":\\\"andy@onthewings.net\\\",\\\"skype\\\":\\\"\\\",\\\"linkedin\\\":\\\"\\\",\\\"twitter\\\":\\\"andy_li\\\",\\\"website_url\\\":\\\"https://blog.onthewings.net/\\\",\\\"organization\\\":\\\"\\\",\\\"last_sign_in_at\\\":\\\"2019-07-10T16:09:32.954Z\\\",\\\"confirmed_at\\\":\\\"2015-02-02T01:49:05.297Z\\\",\\\"last_activity_on\\\":\\\"2019-07-12\\\",\\\"email\\\":\\\"andy@onthewings.net\\\",\\\"theme_id\\\":null,\\\"color_scheme_id\\\":1,\\\"projects_limit\\\":100000,\\\"current_sign_in_at\\\":\\\"2019-07-12T03:05:31.008Z\\\",\\\"identities\\\":[{\\\"provider\\\":\\\"github\\\",\\\"extern_uid\\\":\\\"103977\\\",\\\"saml_provider_id\\\":null},{\\\"provider\\\":\\\"google_oauth2\\\",\\\"extern_uid\\\":\\\"106829545450110611667\\\",\\\"saml_provider_id\\\":null},{\\\"provider\\\":\\\"twitter\\\",\\\"extern_uid\\\":\\\"17513591\\\",\\\"saml_provider_id\\\":null},{\\\"provider\\\":\\\"bitbucket\\\",\\\"extern_uid\\\":\\\"andyli\\\",\\\"saml_provider_id\\\":null}],\\\"can_create_group\\\":true,\\\"can_create_project\\\":true,\\\"two_factor_enabled\\\":false,\\\"external\\\":false,\\\"private_profile\\\":false,\\\"shared_runners_minutes_limit\\\":2000,\\\"extra_shared_runners_minutes_limit\\\":null}\", \"_json\": {\"id\": 91802, \"bio\": \"\", \"name\": \"Andy Li\", \"email\": \"andy@onthewings.net\", \"skype\": \"\", \"state\": \"active\", \"twitter\": \"andy_li\", \"web_url\": \"https://gitlab.com/andyli\", \"external\": false, \"linkedin\": \"\", \"location\": \"Hong Kong\", \"theme_id\": null, \"username\": \"andyli\", \"avatar_url\": \"https://secure.gravatar.com/avatar/8c51d8ddded0dde6c2451a7845b8bb46?s=80&d=identicon\", \"created_at\": \"2015-02-02T01:49:05.437Z\", \"identities\": [{\"provider\": \"github\", \"extern_uid\": \"103977\", \"saml_provider_id\": null}, {\"provider\": \"google_oauth2\", \"extern_uid\": \"106829545450110611667\", \"saml_provider_id\": null}, {\"provider\": \"twitter\", \"extern_uid\": \"17513591\", \"saml_provider_id\": null}, {\"provider\": \"bitbucket\", \"extern_uid\": \"andyli\", \"saml_provider_id\": null}], \"website_url\": \"https://blog.onthewings.net/\", \"confirmed_at\": \"2015-02-02T01:49:05.297Z\", \"organization\": \"\", \"public_email\": \"andy@onthewings.net\", \"projects_limit\": 100000, \"color_scheme_id\": 1, \"last_sign_in_at\": \"2019-07-10T16:09:32.954Z\", \"private_profile\": false, \"can_create_group\": true, \"last_activity_on\": \"2019-07-12\", \"can_create_project\": true, \"current_sign_in_at\": \"2019-07-12T03:05:31.008Z\", \"two_factor_enabled\": false, \"shared_runners_minutes_limit\": 2000, \"extra_shared_runners_minutes_limit\": null}, \"emails\": [{\"value\": \"andy@onthewings.net\"}], \"provider\": \"gitlab\", \"username\": \"andyli\", \"avatarUrl\": \"https://secure.gravatar.com/avatar/8c51d8ddded0dde6c2451a7845b8bb46?s=80&d=identicon\", \"profileUrl\": \"https://gitlab.com/andyli\", \"displayName\": \"Andy Li\"}');
/*!40000 ALTER TABLE `user_gitlab` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_google`
--

LOCK TABLES `user_google` WRITE;
/*!40000 ALTER TABLE `user_google` DISABLE KEYS */;
INSERT INTO `user_google` VALUES (1,'106829545450110611667','{\"id\": \"106829545450110611667\", \"_raw\": \"{\\n  \\\"sub\\\": \\\"106829545450110611667\\\",\\n  \\\"name\\\": \\\"Andy Li\\\",\\n  \\\"given_name\\\": \\\"Andy\\\",\\n  \\\"family_name\\\": \\\"Li\\\",\\n  \\\"profile\\\": \\\"https://plus.google.com/106829545450110611667\\\",\\n  \\\"picture\\\": \\\"https://lh5.googleusercontent.com/-T7raZuwToUA/AAAAAAAAAAI/AAAAAAAAAxM/jFjGdX2O1U4/photo.jpg\\\",\\n  \\\"email\\\": \\\"andy@onthewings.net\\\",\\n  \\\"email_verified\\\": true,\\n  \\\"gender\\\": \\\"male\\\",\\n  \\\"locale\\\": \\\"en\\\",\\n  \\\"hd\\\": \\\"onthewings.net\\\"\\n}\", \"name\": {\"givenName\": \"Andy\", \"familyName\": \"Li\"}, \"_json\": {\"hd\": \"onthewings.net\", \"sub\": \"106829545450110611667\", \"name\": \"Andy Li\", \"email\": \"andy@onthewings.net\", \"gender\": \"male\", \"locale\": \"en\", \"picture\": \"https://lh5.googleusercontent.com/-T7raZuwToUA/AAAAAAAAAAI/AAAAAAAAAxM/jFjGdX2O1U4/photo.jpg\", \"profile\": \"https://plus.google.com/106829545450110611667\", \"given_name\": \"Andy\", \"family_name\": \"Li\", \"email_verified\": true}, \"emails\": [{\"value\": \"andy@onthewings.net\", \"verified\": true}], \"photos\": [{\"value\": \"https://lh5.googleusercontent.com/-T7raZuwToUA/AAAAAAAAAAI/AAAAAAAAAxM/jFjGdX2O1U4/photo.jpg\"}], \"provider\": \"google\", \"displayName\": \"Andy Li\"}');
/*!40000 ALTER TABLE `user_google` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_role`
--

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_stripe`
--

LOCK TABLES `user_stripe` WRITE;
/*!40000 ALTER TABLE `user_stripe` DISABLE KEYS */;
INSERT INTO `user_stripe` VALUES (3,'cus_DuHZ1IJVcUmXS5'),(2,'cus_EykJAUHVSoEL7y');
/*!40000 ALTER TABLE `user_stripe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_twitch`
--

LOCK TABLES `user_twitch` WRITE;
/*!40000 ALTER TABLE `user_twitch` DISABLE KEYS */;
INSERT INTO `user_twitch` VALUES (1,'117021531','{\"id\": \"117021531\", \"type\": \"\", \"login\": \"andyonthewings\", \"provider\": \"twitch.js\", \"view_count\": 502, \"description\": \"OSS dev for Giffon.io, Haxe, Linux packaging etc.\", \"display_name\": \"andyonthewings\", \"broadcaster_type\": \"\", \"offline_image_url\": \"\", \"profile_image_url\": \"https://static-cdn.jtvnw.net/jtv_user_pictures/andyonthewings-profile_image-8faf00dfcf926410-300x300.jpeg\"}');
/*!40000 ALTER TABLE `user_twitch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_twitter`
--

LOCK TABLES `user_twitter` WRITE;
/*!40000 ALTER TABLE `user_twitter` DISABLE KEYS */;
INSERT INTO `user_twitter` VALUES (1,'17513591','{\"id\": \"17513591\", \"_raw\": \"{\\\"id\\\":17513591,\\\"id_str\\\":\\\"17513591\\\",\\\"name\\\":\\\"Andy Li\\\",\\\"screen_name\\\":\\\"andy_li\\\",\\\"location\\\":\\\"Hong Kong\\\",\\\"description\\\":\\\"A #Haxe developer. Building @giffon_io.\\\",\\\"url\\\":\\\"https:\\\\/\\\\/t.co\\\\/JHEBtFaXQB\\\",\\\"entities\\\":{\\\"url\\\":{\\\"urls\\\":[{\\\"url\\\":\\\"https:\\\\/\\\\/t.co\\\\/JHEBtFaXQB\\\",\\\"expanded_url\\\":\\\"https:\\\\/\\\\/giffon.io\\\\/andyli\\\",\\\"display_url\\\":\\\"giffon.io\\\\/andyli\\\",\\\"indices\\\":[0,23]}]},\\\"description\\\":{\\\"urls\\\":[]}},\\\"protected\\\":false,\\\"followers_count\\\":896,\\\"friends_count\\\":945,\\\"listed_count\\\":71,\\\"created_at\\\":\\\"Thu Nov 20 15:39:47 +0000 2008\\\",\\\"favourites_count\\\":2877,\\\"utc_offset\\\":null,\\\"time_zone\\\":null,\\\"geo_enabled\\\":true,\\\"verified\\\":false,\\\"statuses_count\\\":3114,\\\"lang\\\":null,\\\"status\\\":{\\\"created_at\\\":\\\"Fri Jul 12 01:53:08 +0000 2019\\\",\\\"id\\\":1149496882374176770,\\\"id_str\\\":\\\"1149496882374176770\\\",\\\"text\\\":\\\"Watch me adding some more @seleniumhq tests for @giffon_io in today\'s dev live stream. See you in 30 min.\\\\u2026 https:\\\\/\\\\/t.co\\\\/RQW0N8Vwiy\\\",\\\"truncated\\\":true,\\\"entities\\\":{\\\"hashtags\\\":[],\\\"symbols\\\":[],\\\"user_mentions\\\":[{\\\"screen_name\\\":\\\"SeleniumHQ\\\",\\\"name\\\":\\\"Selenium\\\",\\\"id\\\":30214566,\\\"id_str\\\":\\\"30214566\\\",\\\"indices\\\":[26,37]},{\\\"screen_name\\\":\\\"giffon_io\\\",\\\"name\\\":\\\"Giffon.io: A crowd-gifting platform\\\",\\\"id\\\":1052112286255468544,\\\"id_str\\\":\\\"1052112286255468544\\\",\\\"indices\\\":[48,58]}],\\\"urls\\\":[{\\\"url\\\":\\\"https:\\\\/\\\\/t.co\\\\/RQW0N8Vwiy\\\",\\\"expanded_url\\\":\\\"https:\\\\/\\\\/twitter.com\\\\/i\\\\/web\\\\/status\\\\/1149496882374176770\\\",\\\"display_url\\\":\\\"twitter.com\\\\/i\\\\/web\\\\/status\\\\/1\\\\u2026\\\",\\\"indices\\\":[107,130]}]},\\\"source\\\":\\\"\\\\u003ca href=\\\\\\\"https:\\\\/\\\\/about.twitter.com\\\\/products\\\\/tweetdeck\\\\\\\" rel=\\\\\\\"nofollow\\\\\\\"\\\\u003eTweetDeck\\\\u003c\\\\/a\\\\u003e\\\",\\\"in_reply_to_status_id\\\":null,\\\"in_reply_to_status_id_str\\\":null,\\\"in_reply_to_user_id\\\":null,\\\"in_reply_to_user_id_str\\\":null,\\\"in_reply_to_screen_name\\\":null,\\\"geo\\\":null,\\\"coordinates\\\":null,\\\"place\\\":null,\\\"contributors\\\":null,\\\"is_quote_status\\\":false,\\\"retweet_count\\\":0,\\\"favorite_count\\\":2,\\\"favorited\\\":false,\\\"retweeted\\\":false,\\\"possibly_sensitive\\\":false,\\\"lang\\\":\\\"en\\\"},\\\"contributors_enabled\\\":false,\\\"is_translator\\\":false,\\\"is_translation_enabled\\\":false,\\\"profile_background_color\\\":\\\"050505\\\",\\\"profile_background_image_url\\\":\\\"http:\\\\/\\\\/abs.twimg.com\\\\/images\\\\/themes\\\\/theme9\\\\/bg.gif\\\",\\\"profile_background_image_url_https\\\":\\\"https:\\\\/\\\\/abs.twimg.com\\\\/images\\\\/themes\\\\/theme9\\\\/bg.gif\\\",\\\"profile_background_tile\\\":false,\\\"profile_image_url\\\":\\\"http:\\\\/\\\\/pbs.twimg.com\\\\/profile_images\\\\/769032670168875008\\\\/7mzTdBC__normal.jpg\\\",\\\"profile_image_url_https\\\":\\\"https:\\\\/\\\\/pbs.twimg.com\\\\/profile_images\\\\/769032670168875008\\\\/7mzTdBC__normal.jpg\\\",\\\"profile_link_color\\\":\\\"000000\\\",\\\"profile_sidebar_border_color\\\":\\\"181A1E\\\",\\\"profile_sidebar_fill_color\\\":\\\"252429\\\",\\\"profile_text_color\\\":\\\"666666\\\",\\\"profile_use_background_image\\\":true,\\\"has_extended_profile\\\":true,\\\"default_profile\\\":false,\\\"default_profile_image\\\":false,\\\"following\\\":false,\\\"follow_request_sent\\\":false,\\\"notifications\\\":false,\\\"translator_type\\\":\\\"none\\\",\\\"suspended\\\":false,\\\"needs_phone_verification\\\":false,\\\"email\\\":\\\"andy@onthewings.net\\\"}\", \"_json\": {\"id\": 17513591, \"url\": \"https://t.co/JHEBtFaXQB\", \"lang\": null, \"name\": \"Andy Li\", \"email\": \"andy@onthewings.net\", \"id_str\": \"17513591\", \"status\": {\"id\": 1149496882374176800, \"geo\": null, \"lang\": \"en\", \"text\": \"Watch me adding some more @seleniumhq tests for @giffon_io in today\'s dev live stream. See you in 30 min.… https://t.co/RQW0N8Vwiy\", \"place\": null, \"id_str\": \"1149496882374176770\", \"source\": \"<a href=\\\"https://about.twitter.com/products/tweetdeck\\\" rel=\\\"nofollow\\\">TweetDeck</a>\", \"entities\": {\"urls\": [{\"url\": \"https://t.co/RQW0N8Vwiy\", \"indices\": [107, 130], \"display_url\": \"twitter.com/i/web/status/1…\", \"expanded_url\": \"https://twitter.com/i/web/status/1149496882374176770\"}], \"symbols\": [], \"hashtags\": [], \"user_mentions\": [{\"id\": 30214566, \"name\": \"Selenium\", \"id_str\": \"30214566\", \"indices\": [26, 37], \"screen_name\": \"SeleniumHQ\"}, {\"id\": 1052112286255468500, \"name\": \"Giffon.io: A crowd-gifting platform\", \"id_str\": \"1052112286255468544\", \"indices\": [48, 58], \"screen_name\": \"giffon_io\"}]}, \"favorited\": false, \"retweeted\": false, \"truncated\": true, \"created_at\": \"Fri Jul 12 01:53:08 +0000 2019\", \"coordinates\": null, \"contributors\": null, \"retweet_count\": 0, \"favorite_count\": 2, \"is_quote_status\": false, \"possibly_sensitive\": false, \"in_reply_to_user_id\": null, \"in_reply_to_status_id\": null, \"in_reply_to_screen_name\": null, \"in_reply_to_user_id_str\": null, \"in_reply_to_status_id_str\": null}, \"entities\": {\"url\": {\"urls\": [{\"url\": \"https://t.co/JHEBtFaXQB\", \"indices\": [0, 23], \"display_url\": \"giffon.io/andyli\", \"expanded_url\": \"https://giffon.io/andyli\"}]}, \"description\": {\"urls\": []}}, \"location\": \"Hong Kong\", \"verified\": false, \"following\": false, \"protected\": false, \"suspended\": false, \"time_zone\": null, \"created_at\": \"Thu Nov 20 15:39:47 +0000 2008\", \"utc_offset\": null, \"description\": \"A #Haxe developer. Building @giffon_io.\", \"geo_enabled\": true, \"screen_name\": \"andy_li\", \"listed_count\": 71, \"friends_count\": 945, \"is_translator\": false, \"notifications\": false, \"statuses_count\": 3114, \"default_profile\": false, \"followers_count\": 896, \"translator_type\": \"none\", \"favourites_count\": 2877, \"profile_image_url\": \"http://pbs.twimg.com/profile_images/769032670168875008/7mzTdBC__normal.jpg\", \"profile_link_color\": \"000000\", \"profile_text_color\": \"666666\", \"follow_request_sent\": false, \"contributors_enabled\": false, \"has_extended_profile\": true, \"default_profile_image\": false, \"is_translation_enabled\": false, \"profile_background_tile\": false, \"profile_image_url_https\": \"https://pbs.twimg.com/profile_images/769032670168875008/7mzTdBC__normal.jpg\", \"needs_phone_verification\": false, \"profile_background_color\": \"050505\", \"profile_sidebar_fill_color\": \"252429\", \"profile_background_image_url\": \"http://abs.twimg.com/images/themes/theme9/bg.gif\", \"profile_sidebar_border_color\": \"181A1E\", \"profile_use_background_image\": true, \"profile_background_image_url_https\": \"https://abs.twimg.com/images/themes/theme9/bg.gif\"}, \"emails\": [{\"value\": \"andy@onthewings.net\"}], \"photos\": [{\"value\": \"https://pbs.twimg.com/profile_images/769032670168875008/7mzTdBC__normal.jpg\"}], \"provider\": \"twitter\", \"username\": \"andy_li\", \"displayName\": \"Andy Li\", \"_accessLevel\": \"read\"}');
/*!40000 ALTER TABLE `user_twitter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_url`
--

LOCK TABLES `user_url` WRITE;
/*!40000 ALTER TABLE `user_url` DISABLE KEYS */;
INSERT INTO `user_url` VALUES (1,'andyli','2019-07-12 03:17:36',1);
/*!40000 ALTER TABLE `user_url` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_youtube`
--

LOCK TABLES `user_youtube` WRITE;
/*!40000 ALTER TABLE `user_youtube` DISABLE KEYS */;
INSERT INTO `user_youtube` VALUES (1,'UC-r6z46cwvJvTCD-hQcqMqQ','{\"id\": \"UC-r6z46cwvJvTCD-hQcqMqQ\", \"_raw\": \"{\\n \\\"kind\\\": \\\"youtube#channelListResponse\\\",\\n \\\"etag\\\": \\\"\\\\\\\"Bdx4f4ps3xCOOo1WZ91nTLkRZ_c/hCYcfOO1NuWTb9ESIc6kiL8KK7Y\\\\\\\"\\\",\\n \\\"pageInfo\\\": {\\n  \\\"totalResults\\\": 1,\\n  \\\"resultsPerPage\\\": 1\\n },\\n \\\"items\\\": [\\n  {\\n   \\\"kind\\\": \\\"youtube#channel\\\",\\n   \\\"etag\\\": \\\"\\\\\\\"Bdx4f4ps3xCOOo1WZ91nTLkRZ_c/-uhSukLNustsoWdp6dOguxSBetI\\\\\\\"\\\",\\n   \\\"id\\\": \\\"UC-r6z46cwvJvTCD-hQcqMqQ\\\",\\n   \\\"snippet\\\": {\\n    \\\"title\\\": \\\"Andy Li\\\",\\n    \\\"description\\\": \\\"\\\",\\n    \\\"customUrl\\\": \\\"andyonthewings\\\",\\n    \\\"publishedAt\\\": \\\"2008-02-02T02:57:55.000Z\\\",\\n    \\\"thumbnails\\\": {\\n     \\\"default\\\": {\\n      \\\"url\\\": \\\"https://yt3.ggpht.com/a/AGF-l7-BqQRXNMUoGVGyUAOlRzNx4NjLQge871aiAg=s88-mo-c-c0xffffffff-rj-k-no\\\",\\n      \\\"width\\\": 88,\\n      \\\"height\\\": 88\\n     },\\n     \\\"medium\\\": {\\n      \\\"url\\\": \\\"https://yt3.ggpht.com/a/AGF-l7-BqQRXNMUoGVGyUAOlRzNx4NjLQge871aiAg=s240-mo-c-c0xffffffff-rj-k-no\\\",\\n      \\\"width\\\": 240,\\n      \\\"height\\\": 240\\n     },\\n     \\\"high\\\": {\\n      \\\"url\\\": \\\"https://yt3.ggpht.com/a/AGF-l7-BqQRXNMUoGVGyUAOlRzNx4NjLQge871aiAg=s800-mo-c-c0xffffffff-rj-k-no\\\",\\n      \\\"width\\\": 800,\\n      \\\"height\\\": 800\\n     }\\n    },\\n    \\\"localized\\\": {\\n     \\\"title\\\": \\\"Andy Li\\\",\\n     \\\"description\\\": \\\"\\\"\\n    }\\n   }\\n  }\\n ]\\n}\\n\", \"_json\": {\"etag\": \"\\\"Bdx4f4ps3xCOOo1WZ91nTLkRZ_c/hCYcfOO1NuWTb9ESIc6kiL8KK7Y\\\"\", \"kind\": \"youtube#channelListResponse\", \"items\": [{\"id\": \"UC-r6z46cwvJvTCD-hQcqMqQ\", \"etag\": \"\\\"Bdx4f4ps3xCOOo1WZ91nTLkRZ_c/-uhSukLNustsoWdp6dOguxSBetI\\\"\", \"kind\": \"youtube#channel\", \"snippet\": {\"title\": \"Andy Li\", \"customUrl\": \"andyonthewings\", \"localized\": {\"title\": \"Andy Li\", \"description\": \"\"}, \"thumbnails\": {\"high\": {\"url\": \"https://yt3.ggpht.com/a/AGF-l7-BqQRXNMUoGVGyUAOlRzNx4NjLQge871aiAg=s800-mo-c-c0xffffffff-rj-k-no\", \"width\": 800, \"height\": 800}, \"medium\": {\"url\": \"https://yt3.ggpht.com/a/AGF-l7-BqQRXNMUoGVGyUAOlRzNx4NjLQge871aiAg=s240-mo-c-c0xffffffff-rj-k-no\", \"width\": 240, \"height\": 240}, \"default\": {\"url\": \"https://yt3.ggpht.com/a/AGF-l7-BqQRXNMUoGVGyUAOlRzNx4NjLQge871aiAg=s88-mo-c-c0xffffffff-rj-k-no\", \"width\": 88, \"height\": 88}}, \"description\": \"\", \"publishedAt\": \"2008-02-02T02:57:55.000Z\"}}], \"pageInfo\": {\"totalResults\": 1, \"resultsPerPage\": 1}}, \"provider\": \"youtube\", \"displayName\": \"Andy Li\"}');
/*!40000 ALTER TABLE `user_youtube` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `wish`
--

LOCK TABLES `wish` WRITE;
/*!40000 ALTER TABLE `wish` DISABLE KEYS */;
INSERT INTO `wish` VALUES (1,'pnBp',1,'2019-07-12 03:21:48','2019-07-12 03:21:48','I need more time ⌚⌚⌚','published',NULL,'More time ⌚',NULL,'USD','https://media2.giphy.com/media/KPPS9YOCBGU5G/giphy.gif',7.1800,'Shipping & Import Fees Deposit to Hong Kong'),(2,'pyWr',1,'2019-07-12 03:24:19','2019-07-12 03:24:19','I want 2 Switches.\n1 for me and 1 for Stella.','succeed',NULL,'Switch',NULL,'USD','https://media2.giphy.com/media/FMapondVtL2Fi/giphy.gif',11.6600,'Shipping & Import Fees Deposit to Hong Kong'),(3,'G7yw',1,'2019-07-12 03:31:28','2019-07-12 03:31:28','打破了現有的... (哭','published',NULL,'餐具套裝',NULL,'HKD','https://media1.giphy.com/media/pT8UCdKovkOg8/giphy.gif',0.0000,NULL),(4,'wD8w',1,'2019-07-12 03:37:32','2019-07-12 03:37:32','我想去沙灘!!!\n我想去沙灘!!!\n我想去沙灘!!!\n我想去沙灘!!!\n我想去沙灘!!!\n我想去沙灘!!!','cancelled',NULL,'Disney - 獅子王',NULL,'HKD','https://media2.giphy.com/media/26DMZmtN3XAaxW8Xm/giphy.gif',20.0000,'shipping');
/*!40000 ALTER TABLE `wish` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `wish_charge`
--

LOCK TABLES `wish_charge` WRITE;
/*!40000 ALTER TABLE `wish_charge` DISABLE KEYS */;
/*!40000 ALTER TABLE `wish_charge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `wish_item`
--

LOCK TABLES `wish_item` WRITE;
/*!40000 ALTER TABLE `wish_item` DISABLE KEYS */;
INSERT INTO `wish_item` VALUES (1,1,1),(2,2,2),(3,3,1),(4,4,1);
/*!40000 ALTER TABLE `wish_item` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-07-12 12:43:27
