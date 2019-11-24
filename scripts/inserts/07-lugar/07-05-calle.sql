-- DE SUCURSALES DE VEHICULOS
	-- USAR IDs PRIMARY KEY ENTRE 11.000 - 11.099
		-- CHICAGO
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11000,'CALLE','65 E Harrison St, Chicago, IL 60605, Estados Unidos', 9901); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11001,'CALLE','501 S State St, Chicago, IL 60605, Estados Unidos', 9901); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11002,'CALLE','1006 S Michigan Ave, Chicago, IL 60605, Estados Unidos', 9901); 

		-- NUEVA YORK
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11003,'CALLE','Staten Island, Nueva York 10304, Estados Unidos', 10240); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11004,'CALLE','558 86th St, Brooklyn, NY 11209, Estados Unidos', 10240); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11005,'CALLE','4802 10th Ave, Brooklyn, NY 11219, Estados Unidos', 10240); 

		-- CIUDAD DE PANAMA
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11006,'CALLE','Calle 73 Este con Via Israel', 8453); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11007,'CALLE','Av. Los Fundadores con Av. 4 Sur', 8453); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11008,'CALLE','Calle 50 con Via Porras', 8453); 

		-- CARACAS
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11010,'CALLE','212 Calle Orinoco, Caracas 1060, Miranda', 10542); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11011,'CALLE','Av. Orinoco, Caracas 1080, Distrito Capital', 10542); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11012,'CALLE','Bulevar de Sabana Grande, Caracas 1050, Distrito Capital', 10542); 

		-- PORLAMAR
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11013,'CALLE','Calle Antonio Diaz, Pampatar 6316, Nueva Esparta', 10559); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11014,'CALLE','Calle 3 de Mayo, Pampatar 6316, Nueva Esparta', 10559); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11015,'CALLE','Avenida Aeropuerto, Porlamar 6301, Nueva Esparta', 10559); 

		-- RIO DE JANEIRO
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11016,'CALLE','R. Carolina Machado, 1566 - Oswaldo Cruz, Rio de Janeiro - RJ, 21555-190, Brasil', 5547); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11017,'CALLE','Av. Braz de Pina, 2830 - Vista Alegre, Rio de Janeiro - RJ, 21235-605, Brasil', 5547); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11018,'CALLE','R. Iguaba Grande, 33 A - Pavuna, Rio de Janeiro - RJ, 21655-340, Brasil', 5547); 

		-- BUENOS AIRES
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11019,'CALLE','Pichincha 1890, C1245 CABA, Argentina', 4855); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11020,'CALLE','Av. Belgrano 1723, 1093 CABA, Argentina', 4855); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11021,'CALLE','Macacha Güemes 351, C1106 BKG, Buenos Aires, Argentina', 4855);

		-- TOKYO
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11022,'CALLE','1 Chome-12-33 Akasaka, Minato City, Tokyo 107-0052, Japón', 7507); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11023,'CALLE','1 Chome-104-19 Totsukamachi, Shinjuku City, Tokyo 169-0071, Japón', 7507); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11024,'CALLE','1 Kanda Izumicho, Chiyoda City, Tokyo 101-8643, Japón', 7507); 

		-- BEIJING
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11025,'CALLE','7 Sanlihe Rd, Haidian, Beijing, China', 5944); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11026,'CALLE','88 W 3rd Ring Rd N, Haidian, Beijing, China', 5944); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11027,'CALLE','70 E 4rd Ring Rd N, Haidian, Beijing, China', 5944); 

		-- SHANGHAI
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11028,'CALLE','1199 Ying Chun Road Pudong, Shanghai, China, 200135', 6151); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11029,'CALLE','1555 Dingxi Road, Changning District, Shanghai, China, 200050', 6151); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11030,'CALLE','2099 Yan an W Rd, Hong Qiao, Changning, Shanghai, China, 200336', 6151); 

		-- NAIROBI
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11031,'CALLE','Muhoho Ave, Nairobi, Kenia', 7632); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11032,'CALLE','Cotton Avenue, Nairobi, Kenia', 7632); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11033,'CALLE','Rose Ave, Nairobi, Kenia', 7632); 

		-- JOHANNESBURGO
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11034,'CALLE','10 Bompas Rd, Dunkeld West, Johannesburg, 2196, Sudáfrica', 10624); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11035,'CALLE','42 Gibson St, Triomf, Johannesburg, 2092, Sudáfrica', 10624); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11036,'CALLE','71 Bedfordview, Germiston, 2007, Sudáfrica', 10624); 

		-- EL CAIRO
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11037,'CALLE','12, 26 JULY ST، Mohammed Farid, Cairo Governorate, Egipto', 6639); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11038,'CALLE','1115 Nile Corniche, Sharkas, Bulaq, Cairo Governorate, Egipto', 6639); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11039,'CALLE','1 El Bostan Street، Al-Tahrir Sq، Downtown، Cairo Governorate, Egipto', 6639);  

		-- MADRID
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11040,'CALLE','Calle del Príncipe, 10, 28012 Madrid, España', 6688); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11041,'CALLE','Calle Imperial, 9, 28012 Madrid, España', 6688); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11042,'CALLE','C, Costanilla de los Ángeles, 20, 28013 Madrid, España', 6688); 

		-- BERLIN
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11043,'CALLE','Neue Schönhauser Str. 20, 10178 Berlin, Alemania', 6471); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11044,'CALLE','Hinter der Katholischen Kirche 3, 10117 Berlin, Alemania', 6471); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11045,'CALLE','Neue Blumenstraße 5, 10179 Berlin, Alemania', 6471); 

		-- MOSCU
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11046,'CALLE','Tverskaya St, 26/1, Moscow, Rusia, 125009', 8923); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11047,'CALLE','32 Novy Arbat Street, Moscow, Rusia, 121099', 8923); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11048,'CALLE','Sadovnicheskaya St, 20, ctp. 1, Moscow, Rusia, 115035', 8923); 

		-- ROMA
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11049,'CALLE','Via Palestro, 87, 00185 Roma RM, Italia', 5151); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11050,'CALLE','Borgo Pio, 163/166, 00193 Roma RM, Italia', 5151); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11051,'CALLE','Via Giuseppe Parini, 7, 00152 Roma RM, Italia', 5151); 

		-- PARIS
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11052,'CALLE','37 Quai Branly, 75007 Paris, Francia', 10726); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11053,'CALLE','27 Rue Saint-Guillaume, 75007 Paris, Francia', 10726); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11054,'CALLE','Rue de Rivoli, 75001 Paris, Francia', 10726); 

		-- AJACCIO
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11055,'CALLE','Chemin de Pietralba, 20090 Ajaccio, Francia', 6757); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11056,'CALLE','Avenue Maréchal Lyautey, 20000 Ajaccio, Francia', 6757); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11057,'CALLE','Chemin du Finosello, 20090 Ajaccio, Francia', 6757); 

		-- SYDNEY
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11058,'CALLE','50 Missenden Rd, Camperdown NSW 2050, Australia', 5165); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11059,'CALLE','291 Annandale St, Annandale NSW 2038, Australia', 5165); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11060,'CALLE','197 Evans St, Rozelle NSW 2039, Australia', 5165); 

		-- MELBOURNE
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11061,'CALLE','57-61 City Rd, Southbank VIC 3006, Australia', 10726); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11062,'CALLE','495 Collins St, Melbourne VIC 3000, Australia', 10726); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11063,'CALLE','91 Johnston St, Fitzroy VIC 3065, Australia', 10726); 

		-- WELLINGTON
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11064,'CALLE','Corner of Tory Street and, College Street, Te Aro, Wellington 6011, Nueva Zelanda', 8392); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11065,'CALLE','68-70 Willis Street, Wellington 6011, Nueva Zelanda', 8392); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11066,'CALLE','268 Cuba Street, Te Aro, Wellington 6011, Nueva Zelanda', 8392); 

-- DE ALOJAMIENTOS
	-- USAR IDs PRIMARY KEY ENTRE 11.100 - 11.499
		-- CHICAGO
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11101,'CALLE','211 S Laflin St, Chicago, IL 60607, Estados Unidos', 9901); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11102,'CALLE','1807 S Allport St, Chicago, IL 60608, Estados Unidos', 9901); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11103,'CALLE','2105 S State St, Chicago, IL 60616, Estados Unidos', 9901); 

		-- NUEVA YORK
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11104,'CALLE','451 Clarkson Ave, Brooklyn, NY 11203, Estados Unidos', 10240); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11105,'CALLE','8900 Van Wyck Expy, Richmond Hill, NY 11418, Estados Unidos', 10240); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11106,'CALLE','89 E 42nd St, New York, NY 10017, Estados Unidos', 10240); 

		-- CIUDAD DE PANAMA
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11107,'CALLE','Av. 31 Sur con Calle 75 Este', 8453); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11108,'CALLE','Av. 5 A Sur con Calle 68 Este', 8453); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11109,'CALLE',' Calle 68 C Oeste con Av. 16B Norte', 8453); 

		-- CARACAS
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11110,'CALLE','Esq. candilito a Urapal. Av.Urdaneta (oeste 1), Caracas 1011, Distrito Capital', 10542); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11111,'CALLE','Capital, Av. José Antonio Páez, Distrito, Distrito Capital', 10542); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11112,'CALLE','Avenida Universidad, Zona Colonial, Caracas 1030, Distrito Capital', 10542); 

		-- PORLAMAR
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11113,'CALLE','Calle Jesús María Patiño cruce con calle Campos, Porlamar 6301, Venezuela', 10559); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11114,'CALLE','Autopista Porlamar-La Asuncion, Porlamar 6308, Nueva Esparta', 10559); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11115,'CALLE','Calle Antonio José de Sucre, Urb. Jorge Coll, Pampatar, Av António José de Sucre, Pampatar, Nueva Esparta', 10559); 

		-- RIO DE JANEIRO
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11116,'CALLE','Rua Candida, s/n - Olinda, Nilópolis - RJ, 26545-150, Brasil', 5547); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11117,'CALLE','R. João de Castro, 1250 - Cabuís, Nilópolis - RJ, 26540-390, Brasil', 5547); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11118,'CALLE','Rua Comendador Nunes, R. José Martins, Nº 1337 - Centro, Nilópolis - RJ, 26540-040, Brasil', 5547); 

		-- BUENOS AIRES
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11119,'CALLE','Gral. Urquiza 609, C1221 ADC, Buenos Aires, Argentina', 4855); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11120,'CALLE','José A. Cabrera 5127, C1414 BGS, Buenos Aires, Argentina', 4855); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11121,'CALLE','Rodríguez Peña 682, C1020 CABA, Argentina', 4855);

		-- TOKYO
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11122,'CALLE','9-1 Akashicho, Chuo City, Tokyo 104-8560, Japón', 7507); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11123,'CALLE','2 Chome Etchujima, Koto City, Tokyo 135-0044, Japón', 7507); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11124,'CALLE','5 Chome-6-25 Sendagi, Bunkyo City, Tokyo 113-0022, Japón', 7507); 

		-- BEIJING
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11125,'CALLE','Yuyuantan S Rd, Haidian, Beijing, China', 5944); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11126,'CALLE','24 Fuchengmen Outer St, Fu Cheng Men, Xicheng, Beijing, China, 100037', 5944); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11127,'CALLE','22 Baiwanzhuang St, Xicheng, Beijing, China', 5944); 

		-- SHANGHAI
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11128,'CALLE','1 Jinling E Rd, Waitan, Huangpu, Shanghai, China, 200002', 6151); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11129,'CALLE','345 Zhoujiazui Rd, Hongkou, Shanghai, China', 6151); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11130,'CALLE','38 Pujian Rd, Tang Qiao, Pudong, Shanghai, China, 200127', 6151); 

		-- NAIROBI
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11131,'CALLE','Processional Way, Nairobi City, Kenia', 7632); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11132,'CALLE','Kenya Road, Upper Hill, Kenia', 7632); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11133,'CALLE','Langata Rd, Nairobi, Kenia', 7632); 

		-- JOHANNESBURGO
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11134,'CALLE','120 De Korte St, Braamfontein, Johannesburg, 2000, Sudáfrica', 10624); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11135,'CALLE','6 Tottenham Ave, Melrose Estate, Johannesburg, 2146, Sudáfrica', 10624); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11136,'CALLE','44 Livingstone St, Fairmount, Johannesburg, 2192, Sudáfrica', 10624); 

		-- EL CAIRO
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11137,'CALLE','2 Mohammed Roushdy, st، Abdeen, Cairo Governorate, Egipto', 6639); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11138,'CALLE','23 Abd El-Khalik Tharwat, Bab Al Louq, Qasr El Nil, Cairo Governorate 11511, Egipto', 6639); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11139,'CALLE','Bab Al Louq, Abdeen, Cairo Governorate, Egipto', 6639);  

		-- MADRID
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11140,'CALLE','Calle de Toledo, 37, 28005 Madrid, España', 6688); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11141,'CALLE','Calle de Sta. María, 28, 28014 Madrid, España', 6688); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11142,'CALLE','Calle de San Blas, 4, 28014 Madrid, España', 6688); 

		-- BERLIN
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11143,'CALLE','Rosenthaler Str. 40-41, 10178 Berlin, Alemania', 6471); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11144,'CALLE','Auguststraße 58, 10119 Berlin, Alemania', 6471); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11145,'CALLE','Karl-Liebknecht-Str. 30, 10178 Berlin, Alemania', 6471); 

		-- MOSCU
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11146,'CALLE','Baumanskaya Ulitsa, 58/3 ctp. 5, Moscow, Rusia, 105005', 8923); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11147,'CALLE','Bakhrushin St, 11, ctp. 2, Moscow, Rusia, 115054', 8923); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11148,'CALLE','Kozhevnicheskaya Str 8 Bld.3, Moscow, Rusia, 115114', 8923); 

		-- ROMA
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11149,'CALLE','D Azeglio, Via D Azeglio, 24, 00184 Roma RM, Italia', 5151); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11150,'CALLE','Via Cesena, 29, 00182 Roma RM, Italia', 5151); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11151,'CALLE','Via dei Liguri, 7, 00185 Roma RM, Italia', 5151); 

		-- PARIS
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11152,'CALLE','56 Boulevard de Rochechouart, 75018 Paris, Francia', 10726); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11153,'CALLE','1 Avenue Claude Vellefaux, 75010 Paris, Francia', 10726); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11154,'CALLE','158 Boulevard Haussmann, 75008 Paris, Francia', 10726); 

		-- AJACCIO
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11155,'CALLE','Centre social des Salines, Avenue Maréchal Juin, 20090 Ajaccio, Francia', 6757); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11156,'CALLE','Boulevard Abbe Recco - Les Padules, 20000 Ajaccio, Francia', 6757); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11157,'CALLE','115 Cours Napoléon, 20090 Ajaccio, Francia', 6757); 

		-- SYDNEY
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11158,'CALLE','3 Bridge Ln, Sydney NSW 2000, Australia', 5165); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11159,'CALLE','Blue St, North Sydney NSW 2060, Australia', 5165); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11160,'CALLE','Reserve Rd, St Leonards NSW 2065, Australia', 5165); 

		-- MELBOURNE
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11161,'CALLE','600 Epsom Rd, Flemington VIC 3031, Australia', 10726); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11162,'CALLE','65 Queens Rd, Albert Park VIC 3004, Australia', 10726); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11163,'CALLE','616 Glenferrie Rd, Hawthorn VIC 3122, Australia', 10726); 

		-- WELLINGTON
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11164,'CALLE','145 Tirangi Road, Lyall Bay, Wellington 6022, Nueva Zelanda', 8392); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11165,'CALLE','55 Rongotai Road, Kilbirnie, Wellington 6022, Nueva Zelanda', 8392); 
			INSERT INTO Lugar(id,tipo,nombre,fk_lugar) VALUES (11166,'CALLE','1/253 Riddiford Street, Newtown, Wellington 6011, Nueva Zelanda', 8392); 
