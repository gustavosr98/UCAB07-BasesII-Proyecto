--------------------------------------------------------
-- Archivo creado  - martes-diciembre-03-2019   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table LUG_ALOJ
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."LUG_ALOJ" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	"FK_LUGAR" NUMBER, 
	"FK_ALOJAMIENTO" NUMBER, 
	"HORA_CHECK_IN" NUMBER(*,0), 
	"HORA_CHECK_OUT" NUMBER(*,0)
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
REM INSERTING into SYSTEM.LUG_ALOJ
SET DEFINE OFF;
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (1,11101,11,13,8);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (2,11102,12,14,9);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (3,11103,13,15,10);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (4,11104,14,16,11);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (5,11105,15,17,12);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (6,11106,16,13,8);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (7,11107,17,14,9);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (8,11108,18,15,10);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (9,11109,19,16,11);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (10,11110,20,17,12);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (11,11111,1,13,8);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (12,11112,2,14,9);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (13,11113,3,15,10);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (14,11114,4,16,11);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (15,11115,5,17,12);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (16,11116,6,13,8);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (17,11117,7,14,9);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (18,11118,8,15,10);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (19,11119,9,16,11);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (20,11120,10,17,12);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (21,11121,1,13,8);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (22,11122,2,14,9);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (23,11123,3,15,10);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (24,11124,4,16,11);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (25,11125,5,17,12);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (26,11126,6,13,8);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (27,11127,7,14,9);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (28,11128,8,15,10);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (29,11129,9,16,11);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (30,11130,10,17,12);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (31,11131,1,13,8);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (32,11132,2,14,9);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (33,11133,3,15,10);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (34,11134,4,16,11);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (35,11135,5,17,12);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (36,11136,6,13,8);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (37,11137,7,14,9);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (38,11138,8,15,10);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (39,11139,9,16,11);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (40,11140,10,17,12);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (41,11141,1,13,8);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (42,11142,2,14,9);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (43,11143,3,15,10);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (44,11144,4,16,11);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (45,11145,5,17,12);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (46,11146,6,13,8);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (47,11147,7,14,9);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (48,11148,8,15,10);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (49,11149,9,16,11);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (50,11150,10,17,12);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (51,11151,1,13,8);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (52,11152,2,14,9);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (53,11153,3,15,10);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (54,11154,4,16,11);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (55,11155,5,17,12);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (56,11156,6,13,8);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (57,11157,7,14,9);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (58,11158,8,15,10);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (59,11159,9,16,11);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (60,11160,10,17,12);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (61,11161,1,13,8);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (62,11162,2,14,9);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (63,11163,3,15,10);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (64,11164,4,16,11);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (65,11165,5,17,12);
Insert into SYSTEM.LUG_ALOJ (ID,FK_LUGAR,FK_ALOJAMIENTO,HORA_CHECK_IN,HORA_CHECK_OUT) values (66,11166,6,13,8);
--------------------------------------------------------
--  DDL for Index LUG_ALOJ_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYSTEM"."LUG_ALOJ_PK" ON "SYSTEM"."LUG_ALOJ" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  Constraints for Table LUG_ALOJ
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."LUG_ALOJ" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "SYSTEM"."LUG_ALOJ" MODIFY ("FK_LUGAR" NOT NULL ENABLE);
  ALTER TABLE "SYSTEM"."LUG_ALOJ" MODIFY ("FK_ALOJAMIENTO" NOT NULL ENABLE);
  ALTER TABLE "SYSTEM"."LUG_ALOJ" ADD CHECK ( hora_check_in >= 0 AND hora_check_in < 24 ) ENABLE;
  ALTER TABLE "SYSTEM"."LUG_ALOJ" ADD CHECK ( hora_check_out >= 0 AND hora_check_out < 24 ) ENABLE;
  ALTER TABLE "SYSTEM"."LUG_ALOJ" ADD CONSTRAINT "LUG_ALOJ_PK" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table LUG_ALOJ
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."LUG_ALOJ" ADD CONSTRAINT "LUG_ALOJ_FK_LUGAR" FOREIGN KEY ("FK_LUGAR")
	  REFERENCES "SYSTEM"."LUGAR" ("ID") ENABLE;
  ALTER TABLE "SYSTEM"."LUG_ALOJ" ADD CONSTRAINT "LUG_ALOJ_FK_ALOJAMIENTO" FOREIGN KEY ("FK_ALOJAMIENTO")
	  REFERENCES "SYSTEM"."ALOJAMIENTO" ("ID") ENABLE;
