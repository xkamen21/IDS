-- Daniel Kamenicky ( xkamen21 ) & Marek Fiala ( xfiala60 ) --
-- VUT FIT 2019/2020 --
-- Projekt --
-- IDS --

--------------------------------------- CLEANING TABLES ----------------------------------------------------
  DROP TABLE Kocka                  CASCADE CONSTRAINTS;
  DROP TABLE Zivot                  CASCADE CONSTRAINTS;
  DROP TABLE Teritorium             CASCADE CONSTRAINTS;
  DROP TABLE Vlastnictvi            CASCADE CONSTRAINTS;
  DROP TABLE Hostitel               CASCADE CONSTRAINTS;
  DROP TABLE Rasa                   CASCADE CONSTRAINTS;
  DROP TABLE Specificke_rysy        CASCADE CONSTRAINTS;
  DROP TABLE Pohyb_kocky            CASCADE CONSTRAINTS;
  DROP TABLE Interval_vlastnictvi   CASCADE CONSTRAINTS;
  DROP TABLE Slouzi                 CASCADE CONSTRAINTS;
  DROP TABLE Rysy_rasy              CASCADE CONSTRAINTS;
  DROP TABLE Preference             CASCADE CONSTRAINTS;
  DROP TABLE Minuly                 CASCADE CONSTRAINTS;
  DROP TABLE Aktualni               CASCADE CONSTRAINTS;

  DROP SEQUENCE rasa_pk_seq;
  DROP SEQUENCE zivot_pk_seq;
  DROP SEQUENCE teritorium_pk_seq;
  DROP SEQUENCE hostitel_pk_seq;
  DROP SEQUENCE vlastnictvi_pk_seq;
  DROP SEQUENCE spec_rysy_pk_seq;
  DROP SEQUENCE pohyb_kocky_pk_seq;
  DROP SEQUENCE interval_vlastnictvi_pk_seq;
  DROP SEQUENCE slouzi_pk_seq;

  DROP PROCEDURE prumerna_kapacita_teritoria;
  DROP PROCEDURE procentualni_rozlozeni_hostitelu_podle_veku_a_pohlavi;

----------------------------------------- TABLE CREATE -------------------------------------------------
CREATE TABLE Kocka
        (
            hlavni_jmeno VARCHAR(160) NOT NULL PRIMARY KEY,
            vzorek_kuze VARCHAR(10) NOT NULL,
            barva_srsti VARCHAR(50) NOT NULL,

            ID_rasy VARCHAR(4) NOT NULL --FK rasy
        );

CREATE TABLE Zivot
        (
            ID_zivot VARCHAR(10) PRIMARY KEY,
            poradi INT NOT NULL,
            delka INT NOT NULL,

            jmeno_kocky VARCHAR(160) NOT NULL -- FK kocky
        );

CREATE TABLE Teritorium
        (
            ID_teritorium VARCHAR(4) PRIMARY KEY,
            typ_teritoria VARCHAR(50) NOT NULL,
            kapacita_kocek INT NOT NULL
        );

CREATE TABLE Vlastnictvi
        (
            ID_vlastnictvi VARCHAR(4) PRIMARY KEY,
            typ_vlastnictvi VARCHAR(50) NOT NULL,
            kvantita INT NOT NULL,

            ID_hostitele VARCHAR(4), -- FK hostitele --NOT NULL zde chybi protoze se jedna o vazbu 0-1, tudiz muze nastat ze zda vazba nebude
            jmeno_kocky VARCHAR(160), -- FK kocky    --Zde se jedna o stejny pripad
            ID_teritoria VARCHAR(4) NOT NULL -- FK teritoria
        );

CREATE TABLE Hostitel
        (
            ID_hostitel VARCHAR(4) PRIMARY KEY,
            jmeno VARCHAR(50) NOT NULL,
            vek INT NOT NULL,
            pohlavi VARCHAR(4) NOT NULL,
            misto_bydleni VARCHAR(50) NOT NULL
        );

CREATE TABLE Rasa
        (
            ID_rasy VARCHAR(4) PRIMARY KEY,
            typ VARCHAR(50) NOT NULL
        );

CREATE TABLE Specificke_rysy
        (
            ID_rysy VARCHAR(4) PRIMARY KEY,
            barva_oci VARCHAR(50) NOT NULL,
            puvod VARCHAR(50) NOT NULL,
            max_delka_tesaku VARCHAR(4) NOT NULL
        );


-- TABULKY M:N VAZEB --

CREATE TABLE Pohyb_kocky
        (
            ID_pohyb_kocky VARCHAR(5) PRIMARY KEY,
            interval_pobytu INT NOT NULL,

            jmeno_kocky VARCHAR(160) NOT NULL, --FK kocky
            ID_teritoria VARCHAR(4) NOT NULL  --Fk teritoria
        );

CREATE TABLE Interval_vlastnictvi
        (
            ID_interval_vlastnictvi VARCHAR(5) PRIMARY KEY ,
            doba VARCHAR(10) NOT NULL, -- pridan PK.. OPRVAVA

            jmeno_kocky VARCHAR(160) NOT NULL, --FK kocky
            ID_vlastnictvi VARCHAR(4) NOT NULL  --FK vlastnictvi
        );

CREATE TABLE Slouzi
        (
            ID_slouzi VARCHAR(5) PRIMARY KEY,
            prezdivka VARCHAR(50) NOT NULL,

            jmeno_kocky VARCHAR(160) NOT NULL, --FK kocky
            ID_hostitele VARCHAR(4) NOT NULL --FK hostitel
        );

CREATE TABLE Rysy_rasy
        (
            ID_rasy VARCHAR(4) NOT NULL, -- FK rasy
            ID_rysy VARCHAR(50) NOT NULL  -- FK
        );

CREATE TABLE Preference
        (
            ID_hostitele VARCHAR(4) NOT NULL, -- FK hostitele
            ID_rasy VARCHAR(4) NOT NULL  -- FK rasy
        );

-- GENERALIZACE/SPECIALIZACE --
CREATE TABLE Minuly
        (
            ID_zivot VARCHAR(4) NOT NULL, --FK zivot

            zpusob_smrti VARCHAR(100),
            misto_umrti VARCHAR(4) NOT NULL -- FK teritoria
        );

CREATE TABLE Aktualni
        (
            ID_zivot VARCHAR(4) NOT NULL, -- FK zivot

            misto_narozeni VARCHAR(4) NOT NULL -- FK teritoria
        );



----------------------------------------------- set FK --------------------------------------------
-- kocky --
    ALTER TABLE Kocka ADD CONSTRAINT fk_je_rasy FOREIGN KEY (ID_rasy) REFERENCES Rasa;
-- zivot --
    ALTER TABLE Zivot ADD CONSTRAINT fk_ma_kocku FOREIGN KEY (jmeno_kocky) REFERENCES Kocka;
-- vlastnictvi --
    ALTER TABLE Vlastnictvi ADD CONSTRAINT fk_je_propujceno FOREIGN KEY (ID_hostitele) REFERENCES Hostitel;
    ALTER TABLE Vlastnictvi ADD CONSTRAINT fk_ma FOREIGN KEY (jmeno_kocky) REFERENCES Kocka;
    ALTER TABLE Vlastnictvi ADD CONSTRAINT fk_se_nachazi FOREIGN KEY (ID_teritoria) REFERENCES Teritorium;
-- M:N vazby --
--pohyb_kocky--
    ALTER TABLE Pohyb_kocky ADD CONSTRAINT fk_se_pohybuje FOREIGN KEY (jmeno_kocky) REFERENCES Kocka;
    ALTER TABLE Pohyb_kocky ADD CONSTRAINT fk_v_prostredi FOREIGN KEY (ID_teritoria) REFERENCES Teritorium;
--interval_vlastnictvi--
    ALTER TABLE Interval_vlastnictvi ADD CONSTRAINT fk_je_vlastneno FOREIGN KEY (jmeno_kocky) REFERENCES Kocka;
    ALTER TABLE Interval_vlastnictvi ADD CONSTRAINT fk_pripada FOREIGN KEY (ID_vlastnictvi) REFERENCES Vlastnictvi;
--slouzi--
    ALTER TABLE Slouzi ADD CONSTRAINT fk_slouzi FOREIGN KEY (jmeno_kocky) REFERENCES Kocka;
    ALTER TABLE Slouzi ADD CONSTRAINT fk_je_panem FOREIGN KEY (ID_hostitele) REFERENCES Hostitel;
--rysy_rasy--
    ALTER TABLE Rysy_rasy ADD CONSTRAINT fk_rasa_ma FOREIGN KEY (ID_rasy) REFERENCES Rasa;
    ALTER TABLE Rysy_rasy ADD CONSTRAINT fk_jsou FOREIGN KEY (ID_rysy) REFERENCES Specificke_rysy;
--preference--
    ALTER TABLE Preference ADD CONSTRAINT fk_hostitel FOREIGN KEY (ID_hostitele) REFERENCES Hostitel;
    ALTER TABLE Preference ADD CONSTRAINT fk_preferuje FOREIGN KEY (ID_rasy) REFERENCES Rasa;
-- Minuly --
    ALTER TABLE Minuly ADD CONSTRAINT fk_zil FOREIGN KEY (ID_zivot) REFERENCES Zivot;
    ALTER TABLE Minuly ADD CONSTRAINT fk_misto_umrti FOREIGN KEY (misto_umrti) REFERENCES Teritorium;
-- Aktualni --
    ALTER TABLE Aktualni ADD CONSTRAINT fk_zije FOREIGN KEY (ID_zivot) REFERENCES Zivot;
    ALTER TABLE Aktualni ADD CONSTRAINT fk_misto_narozeni FOREIGN KEY (misto_narozeni) REFERENCES Teritorium;



------------------------------------------------------ CHECKS ----------------------------------------------------------------------
 --ALTER TABLE Hostitel ADD CONSTRAINT check_pohlavi CHECK ((pohlavi = 0) OR (pohlavi = 1));
 ALTER TABLE Hostitel ADD CONSTRAINT check_pohlavi CHECK (REGEXP_LIKE(pohlavi, '^([m|M][u|U][z|Z]|[z|Z][e|E][n|N][a|A])$'));
 ALTER TABLE Hostitel ADD CONSTRAINT check_vek CHECK ((vek >= 1) AND (vek <= 130));
 ALTER TABLE Zivot ADD CONSTRAINT check_pocet_zivotu CHECK ((poradi >= 1) AND (poradi <= 9));
 ALTER TABLE Zivot ADD CONSTRAINT check_zapis_zivota CHECK (delka > 0);
 ALTER TABLE Specificke_rysy ADD CONSTRAINT check_cm CHECK (REGEXP_LIKE(max_delka_tesaku, '^[0-9]{1,2}[c,C][m,M]$'));

 ALTER TABLE Zivot ADD CONSTRAINT check_ID_1 CHECK (REGEXP_LIKE(ID_zivot,'Z[0-9]+'));
 ALTER TABLE Teritorium ADD CONSTRAINT check_ID_2 CHECK (REGEXP_LIKE(ID_teritorium,'T[0-9]+'));
 ALTER TABLE Vlastnictvi ADD CONSTRAINT check_ID_3 CHECK (REGEXP_LIKE(ID_vlastnictvi,'V[0-9]+'));
 ALTER TABLE Hostitel ADD CONSTRAINT check_ID_4 CHECK (REGEXP_LIKE(ID_hostitel,'H[0-9]+'));
 ALTER TABLE Rasa ADD CONSTRAINT check_ID_5 CHECK (REGEXP_LIKE(ID_rasy,'R[0-9]+'));
 ALTER TABLE Specificke_rysy ADD CONSTRAINT check_ID_6 CHECK (REGEXP_LIKE(ID_rysy,'S[0-9]+'));
 ALTER TABLE Pohyb_kocky ADD CONSTRAINT check_ID_7 CHECK (REGEXP_LIKE(ID_pohyb_kocky,'PK[0-9]+'));
 ALTER TABLE Interval_vlastnictvi ADD CONSTRAINT check_ID_8 CHECK (REGEXP_LIKE(ID_interval_vlastnictvi,'IV[0-9]+'));
 ALTER TABLE Slouzi ADD CONSTRAINT check_ID_9 CHECK (REGEXP_LIKE(ID_slouzi,'SL[0-9]+'));

 ALTER TABLE Pohyb_kocky ADD CONSTRAINT check_interval_pobytu CHECK (interval_pobytu > 0);

 ALTER TABLE Interval_vlastnictvi ADD CONSTRAINT check_interval_vlastnictvi CHECK (REGEXP_LIKE(doba, '^([0-9]{1,2}[r,R]){0,1}(([0-9]{1,2}|[1-2][0-9]{2}|[3][0-6][0-5])[d,D]){0,1}$'));


-------------------------------------------------- IDS cast 4 & 5 -------------------------------------------------

--------------------------------------------------- TRIGERRY ------------------------------------------------------

-- Sequence jednotlivych triggeru
CREATE SEQUENCE rasa_pk_seq
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE zivot_pk_seq
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE teritorium_pk_seq
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE hostitel_pk_seq
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE vlastnictvi_pk_seq
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE spec_rysy_pk_seq
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE pohyb_kocky_pk_seq
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE interval_vlastnictvi_pk_seq
  START WITH 1
  INCREMENT BY 1;

CREATE SEQUENCE slouzi_pk_seq
  START WITH 1
  INCREMENT BY 1;

-- Trigger na vytvoreni ID pro tabulku rasa

CREATE OR REPLACE TRIGGER rasa_next_id
    BEFORE INSERT
    ON Rasa
    FOR EACH ROW
    DECLARE
BEGIN
    IF :NEW.ID_Rasy  IS NULL THEN
        :NEW.ID_Rasy := 'R'|| rasa_pk_seq.nextval;
    END IF;
END;
/

-- Trigger na vytvoreni ID pro tabulku zivot

CREATE OR REPLACE TRIGGER zivot_next_id
    BEFORE INSERT
    ON Zivot
    FOR EACH ROW
    DECLARE
BEGIN
    IF :NEW.ID_zivot  IS NULL THEN
        :NEW.ID_zivot := 'Z'|| zivot_pk_seq.nextval;
    END IF;
END;
/

-- Trigger na vytvoreni ID pro tabulku teritoria

CREATE OR REPLACE TRIGGER teritorium_next_id
    BEFORE INSERT
    ON Teritorium
    FOR EACH ROW
    DECLARE
BEGIN
    IF :NEW.ID_teritorium  IS NULL THEN
        :NEW.ID_teritorium := 'T'|| teritorium_pk_seq.nextval;
    END IF;
END;
/

-- Trigger na vytvoreni ID pro tabulku vlastvnictvi

CREATE OR REPLACE TRIGGER vlastnictvi_next_id
    BEFORE INSERT
    ON Vlastnictvi
    FOR EACH ROW
    DECLARE
BEGIN
    IF :NEW.ID_vlastnictvi  IS NULL THEN
        :NEW.ID_vlastnictvi := 'V'|| vlastnictvi_pk_seq.nextval;
    END IF;
END;
/

-- Trigger na vytvoreni ID pro tabulku hostitel

CREATE OR REPLACE TRIGGER hostitel_next_id
    BEFORE INSERT
    ON Hostitel
    FOR EACH ROW
    DECLARE
BEGIN
    IF :NEW.ID_hostitel  IS NULL THEN
        :NEW.ID_hostitel := 'H'|| hostitel_pk_seq.nextval;
    END IF;
END;
/

-- Trigger na vytvoreni ID pro Specificke_rysy

CREATE OR REPLACE TRIGGER spec_rysy_next_id
    BEFORE INSERT
    ON Specificke_rysy
    FOR EACH ROW
    DECLARE
BEGIN
    IF :NEW.ID_rysy  IS NULL THEN
        :NEW.ID_rysy := 'S'|| spec_rysy_pk_seq.nextval;
    END IF;
END;
/

-- Trigger na vytvoreni ID pro Pohyb_kocky

CREATE OR REPLACE TRIGGER pohyb_kocky_next_id
    BEFORE INSERT
    ON Pohyb_kocky
    FOR EACH ROW
    DECLARE
BEGIN
    IF :NEW.ID_pohyb_kocky  IS NULL THEN
        :NEW.ID_pohyb_kocky := 'PK'|| pohyb_kocky_pk_seq.nextval;
    END IF;
END;
/

-- Trigger na vytvoreni ID pro Interval_vlastnictvi

CREATE OR REPLACE TRIGGER interval_vlastnictvi_next_id
    BEFORE INSERT
    ON Interval_vlastnictvi
    FOR EACH ROW
    DECLARE
BEGIN
    IF :NEW.ID_interval_vlastnictvi  IS NULL THEN
        :NEW.ID_interval_vlastnictvi := 'IV'|| interval_vlastnictvi_pk_seq.nextval;
    END IF;
END;
/

-- Trigger na vytvoreni ID pro Slouzi

CREATE OR REPLACE TRIGGER slouzi_next_id
    BEFORE INSERT
    ON Slouzi
    FOR EACH ROW
    DECLARE
BEGIN
    IF :NEW.ID_slouzi  IS NULL THEN
        :NEW.ID_slouzi := 'SL'|| slouzi_pk_seq.nextval;
    END IF;
END;
/


-- TRIGGER2: Trigger kontrolujici pocet zivotu kocky

CREATE OR REPLACE TRIGGER pocet_zivotu_kocky
  BEFORE INSERT OR UPDATE OF poradi ON Zivot
  FOR EACH ROW
    DECLARE
BEGIN
  IF NOT (:NEW.poradi < 10 OR :NEW.poradi < 1) THEN
    RAISE_APPLICATION_ERROR(-20420, 'Nespravny pocet zivotu, kocka ma pouze 9 zivotu, cislo musi byt v rozmezi 1 až 9.');
  END IF;

END;
/


-------------------------------------------------------INSERT-----------------------------------------------------------------------
--INSERT Rasy--
INSERT INTO Rasa (typ) VALUES ('Birma');
INSERT INTO Rasa (typ) VALUES ('Siamska');
INSERT INTO Rasa (typ) VALUES ('Munchkin');
INSERT INTO Rasa (typ) VALUES ('Ragdoll');
INSERT INTO Rasa (typ) VALUES ('Sphynx');
INSERT INTO Rasa (typ) VALUES ('Toyger');
INSERT INTO Rasa (typ) VALUES ('Perska');
INSERT INTO Rasa (typ) VALUES ('RagaMuffin');
INSERT INTO Rasa (typ) VALUES ('Peterbald');
INSERT INTO Rasa (typ) VALUES ('Nebelung');

--INSERT Kocek--
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('julca','BLK', 'fialova', 'R1');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('packa','TW', 'cerna', 'R2');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('micka','SKYB', 'bila', 'R3');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('fous','BLK', 'cerna', 'R4');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('tlapka','YLW', 'oranzova', 'R5');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('max', 'BLK', 'zrzava', 'R6');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('richie', 'ZNK', 'seda', 'R9');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('silva', 'TW', 'zlatava', 'R8');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('pan zvon', 'BLK', 'cerna', 'R4');
INSERT INTO Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('dextr', 'SKYB', 'seda', 'R7');

--INSERT Zivota dane kocky--
INSERT INTO Zivot (poradi, delka, jmeno_kocky) VALUES (1, '2555', 'julca');
INSERT INTO Zivot (poradi, delka, jmeno_kocky) VALUES (2, '465', 'julca');
INSERT INTO Zivot (poradi, delka, jmeno_kocky) VALUES (1, '4895', 'packa');
INSERT INTO Zivot (poradi, delka, jmeno_kocky) VALUES (1, '25', 'micka');
INSERT INTO Zivot (poradi, delka, jmeno_kocky) VALUES (1, '1', 'fous');
INSERT INTO Zivot (poradi, delka, jmeno_kocky) VALUES (2, '745', 'fous');
INSERT INTO Zivot (poradi, delka, jmeno_kocky) VALUES (3, '365', 'fous');
INSERT INTO Zivot (poradi, delka, jmeno_kocky) VALUES (1, '1698', 'tlapka');
INSERT INTO Zivot (poradi, delka, jmeno_kocky) VALUES (1, '156', 'max');
INSERT INTO Zivot (poradi, delka, jmeno_kocky) VALUES (2, '3120', 'max');
INSERT INTO Zivot (poradi, delka, jmeno_kocky) VALUES (3, '3', 'max');
INSERT INTO Zivot (poradi, delka, jmeno_kocky) VALUES (1, '999', 'richie');
INSERT INTO Zivot (poradi, delka, jmeno_kocky) VALUES (1, '2222', 'silva');
INSERT INTO Zivot (poradi, delka, jmeno_kocky) VALUES (2, '887', 'silva');
INSERT INTO Zivot (poradi, delka, jmeno_kocky) VALUES (1, '1655', 'pan zvon');
INSERT INTO Zivot (poradi, delka, jmeno_kocky) VALUES (1, '3522', 'dextr');
INSERT INTO Zivot (poradi, delka, jmeno_kocky) VALUES (2, '1111', 'dextr');

--INSERT Teritorii--
INSERT INTO Teritorium (typ_teritoria, kapacita_kocek) VALUES ('obyvak', 20);
INSERT INTO Teritorium (typ_teritoria, kapacita_kocek) VALUES ('kuchyn', 10);
INSERT INTO Teritorium (typ_teritoria, kapacita_kocek) VALUES ('zahrada', 50);
INSERT INTO Teritorium (typ_teritoria, kapacita_kocek) VALUES ('ulice', 200);
INSERT INTO Teritorium (typ_teritoria, kapacita_kocek) VALUES ('toaleta', 3);
INSERT INTO Teritorium (typ_teritoria, kapacita_kocek) VALUES ('garaz', 45);
INSERT INTO Teritorium (typ_teritoria, kapacita_kocek) VALUES ('sklep', 30);
INSERT INTO Teritorium (typ_teritoria, kapacita_kocek) VALUES ('puda', 70);
INSERT INTO Teritorium (typ_teritoria, kapacita_kocek) VALUES ('predsin', 10);
INSERT INTO Teritorium (typ_teritoria, kapacita_kocek) VALUES ('koupelna', 15);

--INSERT Hostitelu--
INSERT INTO Hostitel (jmeno, vek, pohlavi, misto_bydleni) VALUES ('Pavel', 42, 'muz', 'Znojmo');
INSERT INTO Hostitel (jmeno, vek, pohlavi, misto_bydleni) VALUES ('Marek', 22, 'muz', 'Brno');
INSERT INTO Hostitel (jmeno, vek, pohlavi, misto_bydleni) VALUES ('Boris', 21, 'muz', 'Praha');
INSERT INTO Hostitel (jmeno, vek, pohlavi, misto_bydleni) VALUES ('Dan', 21, 'muz', 'Ostrava');
INSERT INTO Hostitel (jmeno, vek, pohlavi, misto_bydleni) VALUES ('Jan', 22, 'muz', 'Plzen');
INSERT INTO Hostitel (jmeno, vek, pohlavi, misto_bydleni) VALUES ('Katka', 56, 'zena', 'Most');
INSERT INTO Hostitel (jmeno, vek, pohlavi, misto_bydleni) VALUES ('Monika', 17, 'zena', 'Jundrov');
INSERT INTO Hostitel (jmeno, vek, pohlavi, misto_bydleni) VALUES ('Rebeka', 32, 'zena', 'Hradec Kralove');
INSERT INTO Hostitel (jmeno, vek, pohlavi, misto_bydleni) VALUES ('Lukas', 45, 'muz', 'LA');
INSERT INTO Hostitel (jmeno, vek, pohlavi, misto_bydleni) VALUES ('Michaela', 77, 'zena', 'Zlin');

--INSERT typu vlastnictvi--
INSERT INTO Vlastnictvi (typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('balonek', 3, 'H1', 'julca', 'T1');
INSERT INTO Vlastnictvi (typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('klubicko bavlny', 2, '', 'julca', 'T1');
INSERT INTO Vlastnictvi (typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('letajici talir', 1, 'H4', 'micka', 'T5');
INSERT INTO Vlastnictvi (typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('bumerang', 1, 'H5', 'tlapka', 'T3');
INSERT INTO Vlastnictvi (typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('klacik', 12, '', '', 'T2');
INSERT INTO Vlastnictvi (typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('drazditko', 10, '', '', 'T8');
INSERT INTO Vlastnictvi (typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('plysova rybicka', 3, 'H9', 'richie', 'T9');
INSERT INTO Vlastnictvi (typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('myska', 4, 'H7', 'max', 'T8');
INSERT INTO Vlastnictvi (typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('polstarek', 1, '', '', 'T1');
INSERT INTO Vlastnictvi (typ_vlastnictvi, kvantita, ID_hostitele, jmeno_kocky, ID_teritoria) VALUES ('pirko na tycince', 4, 'H6', 'pan zvon', 'T7');

--INSERT specifickych rysu--
INSERT INTO Specificke_rysy (barva_oci, puvod, max_delka_tesaku) VALUES ('zelena', 'Egypt', '27cm');
INSERT INTO Specificke_rysy (barva_oci, puvod, max_delka_tesaku) VALUES ('modra', 'Cesko', '12cm');
INSERT INTO Specificke_rysy (barva_oci, puvod, max_delka_tesaku) VALUES ('hneda', 'Cina', '15cm');
INSERT INTO Specificke_rysy (barva_oci, puvod, max_delka_tesaku) VALUES ('cervena', 'Nemecko', '7cm');
INSERT INTO Specificke_rysy (barva_oci, puvod, max_delka_tesaku) VALUES ('cerna', 'Italie', '6cm');
INSERT INTO Specificke_rysy (barva_oci, puvod, max_delka_tesaku) VALUES ('duhova', 'Izrael', '2cm');
INSERT INTO Specificke_rysy (barva_oci, puvod, max_delka_tesaku) VALUES ('modro zelena', 'Pakistan', '9cm');
INSERT INTO Specificke_rysy (barva_oci, puvod, max_delka_tesaku) VALUES ('zeleno hneda', 'Egypt', '11cm');
INSERT INTO Specificke_rysy (barva_oci, puvod, max_delka_tesaku) VALUES ('tmave hneda', 'California', '4cm');
INSERT INTO Specificke_rysy (barva_oci, puvod, max_delka_tesaku) VALUES ('svetle modra', 'Indie', '3cm');

--INSERT pohybu kocky--
INSERT INTO Pohyb_kocky (interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('324', 'packa', 'T1');
INSERT INTO Pohyb_kocky (interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('480', 'packa', 'T1');
INSERT INTO Pohyb_kocky (interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('54', 'julca', 'T1');
INSERT INTO Pohyb_kocky (interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('178', 'micka', 'T2');
INSERT INTO Pohyb_kocky (interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('544', 'fous', 'T5');
INSERT INTO Pohyb_kocky (interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('200', 'fous', 'T5');
INSERT INTO Pohyb_kocky (interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('724', 'tlapka', 'T3');
INSERT INTO Pohyb_kocky (interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('10', 'max', 'T10');
INSERT INTO Pohyb_kocky (interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('684', 'silva', 'T7');
INSERT INTO Pohyb_kocky (interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('100', 'richie', 'T6');
INSERT INTO Pohyb_kocky (interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('178', 'silva', 'T8');
INSERT INTO Pohyb_kocky (interval_pobytu, jmeno_kocky, ID_teritoria) VALUES ('29', 'dextr', 'T9');

--INSERT intervalu vlastnictvi--
INSERT INTO Interval_vlastnictvi (doba, jmeno_kocky, ID_vlastnictvi) VALUES ('324d', 'julca', 'V1');
INSERT INTO Interval_vlastnictvi (doba, jmeno_kocky, ID_vlastnictvi) VALUES ('54d', 'julca', 'V2');
INSERT INTO Interval_vlastnictvi (doba, jmeno_kocky, ID_vlastnictvi) VALUES ('1r25d', 'micka', 'V3');
INSERT INTO Interval_vlastnictvi (doba, jmeno_kocky, ID_vlastnictvi) VALUES ('2d', 'tlapka', 'V4');
INSERT INTO Interval_vlastnictvi (doba, jmeno_kocky, ID_vlastnictvi) VALUES ('15d', 'max', 'V9');
INSERT INTO Interval_vlastnictvi (doba, jmeno_kocky, ID_vlastnictvi) VALUES ('1d', 'silva', 'V10');
INSERT INTO Interval_vlastnictvi (doba, jmeno_kocky, ID_vlastnictvi) VALUES ('39d', 'pan zvon', 'V8');
INSERT INTO Interval_vlastnictvi (doba, jmeno_kocky, ID_vlastnictvi) VALUES ('2d', 'max', 'V7');
INSERT INTO Interval_vlastnictvi (doba, jmeno_kocky, ID_vlastnictvi) VALUES ('3r2d', 'dextr', 'V8');

--INSERT jaky hostitel slouzi jake kocce--
INSERT INTO Slouzi (prezdivka, jmeno_kocky, ID_hostitele) VALUES ('kulisak', 'julca', 'H1');
INSERT INTO Slouzi (prezdivka, jmeno_kocky, ID_hostitele) VALUES ('zrout', 'packa', 'H1');
INSERT INTO Slouzi (prezdivka, jmeno_kocky, ID_hostitele) VALUES ('otrava', 'micka', 'H2');
INSERT INTO Slouzi (prezdivka, jmeno_kocky, ID_hostitele) VALUES ('kulicka', 'fous', 'H7');
INSERT INTO Slouzi (prezdivka, jmeno_kocky, ID_hostitele) VALUES ('milacek', 'tlapka', 'H5');
INSERT INTO Slouzi (prezdivka, jmeno_kocky, ID_hostitele) VALUES ('slinta', 'max', 'H6');
INSERT INTO Slouzi (prezdivka, jmeno_kocky, ID_hostitele) VALUES ('lizal', 'dextr', 'H10');
INSERT INTO Slouzi (prezdivka, jmeno_kocky, ID_hostitele) VALUES ('fantom', 'silva', 'H9');
INSERT INTO Slouzi (prezdivka, jmeno_kocky, ID_hostitele) VALUES ('zrout', 'richie', 'H4');
INSERT INTO Slouzi (prezdivka, jmeno_kocky, ID_hostitele) VALUES ('lenoch', 'pan zvon', 'H3');

--INSERT specifickych rysu dane rasy--
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R1', 'S5');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R2', 'S1');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R3', 'S4');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R4', 'S2');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R5', 'S3');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R6', 'S6');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R7', 'S7');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R8', 'S8');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R10', 'S9');
INSERT INTO Rysy_rasy (ID_rasy, ID_rysy) VALUES ('R9', 'S10');

--INSERT jakou rasu dany hostitel preferuje--
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H1', 'R1');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H2', 'R4');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H3', 'R2');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H4', 'R1');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H5', 'R5');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H6', 'R4');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H7', 'R2');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H8', 'R3');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H9', 'R8');
INSERT INTO Preference (ID_hostitele, ID_rasy) VALUES ('H10', 'R10');

--INSERT data o aktualnim zivote kocky--
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z2', 'T1');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z3', 'T3');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z4', 'T4');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z7', 'T2');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z11', 'T6');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z12', 'T6');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z14', 'T7');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z15', 'T9');
INSERT INTO Aktualni (ID_zivot, misto_narozeni) VALUES ('Z17', 'T10');

--INSERT data o minulem zivote kocky--
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z1', 'prejeta autem' , 'T4');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z5', 'Utopena v zachodu.' ,'T5');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z6', 'Rozmacknuta padem houpacky' ,'T3');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z9', 'corona virus' ,'T5');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z10', 'pad ze strechy' ,'T3');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z13', 'umrela na hlad', 'T8');
INSERT INTO Minuly (ID_zivot, zpusob_smrti, misto_umrti) VALUES ('Z16', 'smrt leknutim' ,'T9');

---------------------------------------------------------- SELECT ------------------------------------------------------
--SQL skript obsahující dotazy SELECT musí obsahovat:
--  1. konkrétně alespoň dva dotazy využívající spojení dvou tabulek,
    -- Vypis vsech kocek a jejich typu rasy
        SELECT  Kocka.hlavni_jmeno as JMENO_KOCKY, Kocka.ID_rasy as ID_RASY, Rasa.typ as ZEME_PUVODU
        FROM Kocka JOIN Rasa ON Kocka.ID_rasy = Rasa.ID_rasy
        ORDER BY Kocka.ID_rasy;

    -- Vypis hostilete a jeho preference dane rasy
        SELECT Hostitel.jmeno as JMENO_HOSTITELE, Hostitel.ID_hostitel as ID_HOSTITELE, Rasa.typ as TYP_RASY
        FROM Preference JOIN Hostitel ON Preference.ID_hostitele = Hostitel.ID_hostitel
                        JOIN Rasa ON Preference.ID_rasy = Rasa.ID_rasy
        ORDER BY Hostitel.ID_hostitel;

--  2. jeden využívající spojení tří tabulek,
    -- Kocka kde je uvedeno jeji jmeno, jakeho typu rasy je a dale specificke rysy dane rasy, jakoz to barva oci, maximalni delka tesatku a puvod
        SELECT Kocka.hlavni_jmeno as JMENO_KOCKY, Rasa.typ as TYP_RASY, Specificke_rysy.barva_oci as SPECIFICKE_RYSY_BARVA_OCI, Specificke_rysy.max_delka_tesaku as SPECIFICKE_RYSY_DELKA_TESAKU, Specificke_rysy.puvod as SPECIFICKE_RYSY_PUVOD
        FROM Rysy_rasy JOIN Specificke_rysy ON Specificke_rysy.ID_rysy = Rysy_rasy.ID_rysy
                       JOIN Rasa ON Rasa.ID_rasy = Rysy_rasy.ID_rasy
                       JOIN Kocka on Rasa.ID_rasy = Kocka.ID_rasy
        ORDER BY Kocka.hlavni_jmeno;

--  3. dva dotazy s klauzulí GROUP BY a agregační funkcí,
    --Dotaz na jmeno kocky a v kolikatem zivote se nachazi
        SELECT Zivot.jmeno_kocky as JMENO_KOCKY, COUNT(*) as V_KOLIKATEM_ZIVOTE_SE_KOCKA_NACHAZI
        FROM Zivot
        GROUP BY Zivot.jmeno_kocky;

    --Dotaz na Typ Teritorium, pocet kocek ktere v danem teritoriu zily a delka nejdelsiho pobytu kocky v danem teritoriu
        SELECT Teritorium.typ_teritoria as TYP_TERITORIA, COUNT(Pohyb_kocky.ID_teritoria) as KOLIK_KOCEK_ZDE_ZILO, MAX(Pohyb_kocky.interval_pobytu) as NEJDELSI_DELKA_POBYTU_KOCKY
        FROM Pohyb_kocky JOIN Teritorium ON Pohyb_kocky.ID_teritoria = Teritorium.ID_teritorium
        GROUP BY Teritorium.typ_teritoria;

--  4. jeden dotaz obsahující predikát EXISTS
    --Dotaz ktery vypise v jakych teritoriich se vyskytovala vice jak 1 kocka
        SELECT Teritorium.ID_teritorium as ID_TERITORIA, Teritorium.typ_teritoria as TYP_TERITORIA
        FROM Teritorium
        WHERE EXISTS(
            SELECT COUNT(Pohyb_kocky.ID_teritoria)
            FROM Pohyb_kocky
            WHERE Pohyb_kocky.ID_teritoria = Teritorium.ID_teritorium
            GROUP BY Teritorium.typ_teritoria
            HAVING COUNT(Pohyb_kocky.ID_teritoria) > 1
            )
        ORDER BY Teritorium.typ_teritoria;

--  5. a jeden dotaz s predikátem IN s vnořeným selectem (nikoliv IN s množinou konstantních dat).
    --Dotaz ktery vypise Kocky, ktere se alespon jednou ze svych prozitych zivotu nedozily 1 roku, nebo kocky ktere ziji prvni zivot a nedozili se zatim 1 roku
        SELECT Kocka.hlavni_jmeno as JMENO_KOCKY, Kocka.barva_srsti as BARVA_SRSTI, Kocka.vzorek_kuze as VZOREK_KUZE
        FROM Kocka
        WHERE Kocka.hlavni_jmeno IN (
            SELECT Zivot.jmeno_kocky
            FROM Zivot
            WHERE Zivot.delka < 365
            );
--  - U každého z dotazů musí být (v komentáři SQL kódu) popsáno srozumitelně, jaká data hledá daný dotaz (jaká je jeho funkce v aplikaci).



---------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------ IDS cast 4 & 5 -----------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

------------------------------------------- PROCEDURE ---------------------------------------------------

-- PROCEDURA1: Zjistujici prumernou kapacintu teritorii, nejmensi a nejvetsi teritorium
CREATE OR REPLACE PROCEDURE prumerna_kapacita_teritoria AS
    CURSOR teritoria IS SELECT * FROM Teritorium;
    kapacita_celkem INTEGER;
    pocet_teritorii INTEGER;
    nejmensi_teritorium_nazev VARCHAR(50);
    nejvetsi_teritorium_nazev VARCHAR(50);
    nejmensi_teritorium_kapacita INTEGER;
    nejvetsi_teritorium_kapacita INTEGER;
    prvni_nastaveni_pomocna INTEGER;

    teritorium_row teritoria%ROWTYPE;
BEGIN
    kapacita_celkem := 0;
    pocet_teritorii := 0;
    prvni_nastaveni_pomocna := 0;
    OPEN teritoria;
    LOOP
        FETCH teritoria INTO teritorium_row;
        EXIT WHEN teritoria%NOTFOUND;

        pocet_teritorii := pocet_teritorii +1;
        kapacita_celkem := kapacita_celkem + teritorium_row.kapacita_kocek;

        IF prvni_nastaveni_pomocna = 0 THEN
        nejmensi_teritorium_nazev := teritorium_row.typ_teritoria;
        nejvetsi_teritorium_nazev := teritorium_row.typ_teritoria;
        nejmensi_teritorium_kapacita := teritorium_row.kapacita_kocek;
        nejvetsi_teritorium_kapacita := teritorium_row.kapacita_kocek;
        prvni_nastaveni_pomocna := 1;
        END IF;

        IF teritorium_row.kapacita_kocek > nejvetsi_teritorium_kapacita THEN
        nejvetsi_teritorium_kapacita := teritorium_row.kapacita_kocek;
        nejvetsi_teritorium_nazev := teritorium_row.typ_teritoria;
        END IF;

        IF teritorium_row.kapacita_kocek < nejmensi_teritorium_kapacita THEN
        nejmensi_teritorium_kapacita := teritorium_row.kapacita_kocek;
        nejmensi_teritorium_nazev := teritorium_row.typ_teritoria;
        END IF;
    END LOOP;
    IF pocet_teritorii = 0 THEN
        RAISE NO_DATA_FOUND;
    END IF;
    dbms_output.put_line('Prumerna kapacita teritoria je ' || ROUND(kapacita_celkem/pocet_teritorii,0) || ' kocek.');
    dbms_output.put_line('Nejmensi teritorium je ' || nejmensi_teritorium_nazev || ' s kapacitou: ' || nejmensi_teritorium_kapacita || '.');
    dbms_output.put_line('Nejvetsi teritorium je ' || nejvetsi_teritorium_nazev || ' s kapacitou: ' || nejvetsi_teritorium_kapacita || '.');
    CLOSE teritoria;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20422, 'Nenalezena zadna data');
    WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20421, 'Chyba v procedure');
END;


-- Procedura 2: vypise pocet hostitelu zastoupenych v urcitem veku a take zastoupeni zen a muzu --
CREATE OR REPLACE PROCEDURE procentualni_rozlozeni_hostitelu_podle_veku_a_pohlavi AS
  CURSOR hostitele IS SELECT * FROM Hostitel WHERE Hostitel.vek IS NOT NULL;
  hostitel_row Hostitel%ROWTYPE;
  celkove NUMBER;
  do_18 NUMBER;
  od_18_do_30 NUMBER;
  od_30_do_50 NUMBER;
  nad_50 NUMBER;
  zeny NUMBER;
  muzi NUMBER;

  BEGIN
    celkove := 0;
    do_18 := 0;
    od_18_do_30 := 0;
    od_30_do_50 := 0;
    nad_50 := 0;
    zeny := 0;
    muzi := 0;
    OPEN hostitele;
    LOOP
      FETCH hostitele INTO hostitel_row;
      EXIT WHEN hostitele%NOTFOUND;
      celkove := celkove + 1;
      IF hostitel_row.vek BETWEEN 0 AND 18 THEN do_18 := do_18 + 1; END IF;
      IF hostitel_row.vek BETWEEN 19 AND 30 THEN od_18_do_30 := od_18_do_30 + 1; END IF;
      IF hostitel_row.vek BETWEEN 30 AND 50 THEN od_30_do_50 := od_30_do_50 + 1; END IF;
      IF hostitel_row.vek > 50 THEN nad_50 := nad_50 + 1; END IF;
      IF REGEXP_LIKE(hostitel_row.pohlavi, '^([m|M][u|U][z|Z])$') THEN muzi := muzi + 1; END IF;
      IF REGEXP_LIKE(hostitel_row.pohlavi, '^([z|Z][e|E][n|N][a|A])$') THEN zeny := zeny + 1; END IF;
    END LOOP;
    IF celkove = 0 then
        RAISE NO_DATA_FOUND;
    end if;
    dbms_output.put_line('Muzi              : ' || ROUND((muzi/celkove)*100,2) ||'%' ||' ('|| muzi ||')');
    dbms_output.put_line('Zeny              : ' || ROUND((zeny/celkove)*100,2) ||'%' ||' ('|| zeny ||')');
    dbms_output.put_line('   ');
    dbms_output.put_line('Do 18 let         : ' || ROUND((do_18/celkove)*100,2) ||'%' ||' ('|| do_18 ||')');
    dbms_output.put_line('Od 18 do 30 let   : ' || ROUND((od_18_do_30/celkove)*100,2) ||'%' ||' ('|| od_18_do_30 ||')');
    dbms_output.put_line('Od 30 do 50 let   : ' || ROUND((od_30_do_50/celkove)*100,2) ||'%' ||' ('|| od_30_do_50 ||')');
    dbms_output.put_line('Starsi 50 let     : ' || ROUND((nad_50/celkove)*100,2) ||'%' ||' ('|| nad_50 ||')');
    CLOSE hostitele;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20422, 'Nenalezena zadna data');
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20421, 'Chyba v procedure');
    END;

-- DEMONSTRACE procedur:
    BEGIN
        procentualni_rozlozeni_hostitelu_podle_veku_a_pohlavi();
    END;

    BEGIN
        prumerna_kapacita_teritoria();
    END;

--------------------------------------------- INDEX a EXPLAIN PLAN FOR --------------------------------------------------
--- INDEX1: Dotaz: vypsani kocek ktere jiz umreli a pocet jejich smrti
    --DROP INDEX index_zivot; -- DROP pro druhy index
    DROP INDEX index_minuly;
    --EXPLAIN befor INDEX
    EXPLAIN PLAN FOR
      SELECT Kocka.hlavni_jmeno, count(*) AS POCET_UMRTI
      FROM Kocka, Zivot, Minuly
      WHERE Kocka.hlavni_jmeno = Zivot.jmeno_kocky AND Zivot.ID_zivot = Minuly.ID_zivot
      GROUP BY Kocka.hlavni_jmeno;
    SELECT PLAN_TABLE_OUTPUT FROM table (DBMS_XPLAN.DISPLAY());

    CREATE INDEX index_minuly ON Minuly(ID_zivot);

    --EXPLAIN after INDEX
    EXPLAIN PLAN FOR
      SELECT Kocka.hlavni_jmeno, count(*) AS POCET_UMRTI
      FROM Kocka, Zivot, Minuly
      WHERE Kocka.hlavni_jmeno = Zivot.jmeno_kocky AND Zivot.ID_zivot = Minuly.ID_zivot
      GROUP BY Kocka.hlavni_jmeno;
    SELECT PLAN_TABLE_OUTPUT FROM table (DBMS_XPLAN.DISPLAY());

-- INDEX2: návrh pro zlepšení optimalizace pomocí dalšího indexu
   -- CREATE INDEX index_zivot ON Zivot(ID_zivot, jmeno_kocky);
    --EXPLAIN PLAN FOR
    --  SELECT Kocka.hlavni_jmeno, count(*) AS POCET_UMRTI
    --  FROM Kocka, Zivot, Minuly
    --  WHERE Kocka.hlavni_jmeno = Zivot.jmeno_kocky AND Zivot.ID_zivot = Minuly.ID_zivot
    --  GROUP BY Kocka.hlavni_jmeno;
    --SELECT * FROM table (dbms_xplan.display);


--------------------------------------- DEFINICE PRISTUPOVYCH PRAV PRO XKAMEN21 ----------------------------------------------
-- Pristupova prava druheho clena

-- spousti se u xfiala60 ------
GRANT INSERT, UPDATE, SELECT, DELETE ON Kocka TO xkamen21;
GRANT INSERT, UPDATE, SELECT ON Zivot TO xkamen21;
GRANT INSERT, UPDATE, SELECT ON Teritorium TO xkamen21;
GRANT INSERT, UPDATE, SELECT ON Vlastnictvi TO xkamen21;
GRANT INSERT, UPDATE, SELECT ON Rasa TO xkamen21;
GRANT INSERT, UPDATE, SELECT ON Specificke_rysy TO xkamen21;

GRANT ALL ON Pohyb_kocky TO xkamen21;
GRANT ALL ON Interval_vlastnictvi TO xkamen21;
GRANT ALL ON Rysy_rasy TO xkamen21;
GRANT ALL ON Slouzi TO xkamen21;
GRANT ALL ON Preference TO xkamen21;
GRANT ALL ON Minuly TO xkamen21;
GRANT ALL ON Aktualni TO xkamen21;

GRANT EXECUTE ON procentualni_rozlozeni_hostitelu_podle_veku_a_pohlavi to xkamen21;
GRANT EXECUTE ON prumerna_kapacita_teritoria to xkamen21;


--------------------------------------------------- MATERIALIZED VIEW --------------------------------------------------------
DROP MATERIALIZED VIEW vypis_kocek_dane_rasy;

------ spousti se u xkamen21 ------
CREATE MATERIALIZED VIEW vypis_kocek_dane_rasy
CACHE
BUILD IMMEDIATE
REFRESH FORCE ON COMMIT
AS
SELECT  XFIALA60.Kocka.hlavni_jmeno as JMENO_KOCKY, XFIALA60.Kocka.ID_rasy as ID_RASY, XFIALA60.Rasa.typ as ZEME_PUVODU
FROM XFIALA60.Kocka JOIN XFIALA60.Rasa ON XFIALA60.Kocka.ID_rasy = XFIALA60.Rasa.ID_rasy
ORDER BY XFIALA60.Kocka.ID_rasy;

-- DEMONSTRACE Materialized view :
-- Materialovy pohled pred zmenou
select * from vypis_kocek_dane_rasy;
INSERT INTO XFIALA60.Kocka (hlavni_jmeno, vzorek_kuze, barva_srsti, ID_rasy) VALUES ('zabka', 'SKYB', 'seda', 'R6');


-- Materialovy pohled po insertu pred commitem
select * from vypis_kocek_dane_rasy;
COMMIT;
-- Materialovy pohled po commitu
select * from vypis_kocek_dane_rasy;
DELETE FROM XFIALA60.KOCKA WHERE HLAVNI_JMENO = 'zabka';
-- po smazani pred commitem
select * from vypis_kocek_dane_rasy;
COMMIT;


-- po smazani po commitu
select * from vypis_kocek_dane_rasy;



