-- TRIGGER OTOMATIK OLARAK ISLEM YAPTIRMAYA YARARLAR
-- OTOMATIK OLARAK OLDUGU ICIN VERI BUTUNLUGU SAGLANIR
-- SILINMEDEN ONCE GUNCELLMEDEN ONCE EKLEDIKTEN SONRA YAPTIGINIZ ISLEMLERIN YEDEGINI TUTABILIRSINIZ
-- DELETE VE UPDATE OLD KULLANILIR
-- INSERT VE UPDATE NEW KULLANILIR --UPDATE ZAMANA GORE DEGISIR
-- ISLEMI YAPMADAN ONCE AFTER VE BEFORE ZAMAN IFADELERI VARDIR

KULLANIMI
---------------------------------------------------------------
DELIMITTER //
CREATE TRIGGER ISLEM_AD� BEFOR/AFTER DELETE/INSERT/UPDATE/
ON --HANGI TABLO UZERINDEN YAPICAKSINIZ
FOR EACH ROW --TUM SATIRLARI SEC
BEGIN
  --SQL KODLARI

END//
DELIMITTER ;

--------------------------------------------------------------------------
-- ORNEK
-- PERSONEL TABLOSUNA KAYIT EKLEDIGIMIZDE PERSONEL KAYIT TABLOSUNA
-- PERSONEL ISIMLERINI EKLEME

DELIMITTER //
CREATE TRIGGER PERSONEL_EKLETIKTEN_SONRA AFTER INSERT
ON PERSONEL
FOR EACH ROW
BEGIN

INSERT INTO PERSONEL_YEDKEK(PERSONEL_YEDEK_AD) VALUES(NEW.PERSONEL_AD);

END//
DELIMITTER ;

VALUES(CONCAT(NEW.PERSONEL_AD, 'EKLEND�')) SEKL�NDE YAPABILIRISINIZ
-------------------------------------------------------------------------
-- ORNEK
-- PERSONEL NUMARASI DEGISTIGINDE DEGISEN NUMARAYI VE ESKI NUMARA KAYDINI
-- TUTMAK ICIN TRIGGER OLUSTURALIM

DELIMITTER //
CREATE TRIGGER GUNCELLEME_YAPTIKTAN_SONRAYEDEK AFTER UPDATE
ON PERSONEL
FOR EACH ROW
BEGIN


UPDATE PERSONEL_YEDEK SET NUMARA_YEDEK = NEW.NUMARA WHERE PERSONEL_YEDEK_�D = NEW.�D; --PERSONEL TABLOSUNDAK� �D

END //
DELIMITTER ;

-----------------------------------------------------------------------------
-- ORNEK
-- URUN ALIM SATIM YAPILDIGINDA URUN MIKTARLARINDAN STOK DUSURME
-- ILK ONCE TABLOLARIMIZI OLUSTURALIM

CREATE TABLE URUN(

ID INT PRIMARY KEY AUTO_INCEREMENT,
URUN_AD VARCHAR,
URUN_MIKTARI

)

CREATE TABLE STOK_KONTROL (

ID INT PRIMARY KEY AUTO_INCEREMENT,
URUN_ID INT,
 FORING KEY (URUN_ID)
 REFERENCES URUN(ID)
ALIM_TIP INT COMMENT'1 OLURSA ALIS 2 OLURSA SATIS',
MIKTARI INT 


)

DELIMITTER//
CREATE TRIGGER  STOK_EKLENDIKTEN_SONRA AFTER INSERT
ON STOK_KONTROL
FOR EACH ROW
BEGIN

UPDATE URUN SET URUN_MIKTARI = URUN_MIKTARI - (SELECT 
SUM(if(ALIM_TIP= 2, MIKTARI, 0)) as CIKIS_ADET
FROM STOK_KONTROL WHERE URUN_ID = NEW.URUN_ID)
WHERE ID = NEW.URUN_ID;

END//
DELIMITTER ;

------------------------------------------------------------------------
