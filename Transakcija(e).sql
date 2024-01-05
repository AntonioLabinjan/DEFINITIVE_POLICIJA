# TABLICE I INDEKSI
# 18 tablica i 33 indeksa na njima
DROP DATABASE IF EXISTS Policija;
CREATE DATABASE Policija;

USE Policija;

CREATE TABLE Podrucje_uprave (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(255) NOT NULL UNIQUE
);
# U tablici područje uprave možemo staviti indeks na stupac naziv zato jer je on UNIQUE
CREATE INDEX idx_naziv_podrucje_uprave ON Podrucje_uprave(naziv);

CREATE TABLE Mjesto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(255) NOT NULL,
    id_podrucje_uprave INT,
    FOREIGN KEY (Id_Podrucje_Uprave) REFERENCES Podrucje_uprave(Id)
);
# U tablici mjesto možemo staviti indeks na stupac naziv zato jer je on UNIQUE i na stupac id_podrucje_uprave kako bismo ubrzali pretragu po području uprave
CREATE INDEX idx_naziv_mjesto ON Mjesto(naziv);
CREATE INDEX idx_id_podrucje_uprave ON Mjesto(id_podrucje_uprave);

CREATE TABLE Zgrada (
    id INT AUTO_INCREMENT PRIMARY KEY,
    adresa VARCHAR(255) NOT NULL,
    id_mjesto INT,
    vrsta_zgrade VARCHAR(30),
    FOREIGN KEY (id_mjesto) REFERENCES Mjesto(ID)
);
# U tablici zgrada možemo staviti indeks na stupac adresa zato da ubrzamo pretraživanje po afresi i na stupac id_mjesto da ubrzamo pretragu po mjestima 
CREATE INDEX idx_adresa_zgrada ON Zgrada(adresa);
CREATE INDEX idx_id_mjesto_zgrada ON Zgrada(id_mjesto);

CREATE TABLE  Radno_mjesto(
    id INT AUTO_INCREMENT PRIMARY KEY,
    vrsta VARCHAR(255) NOT NULL,
    dodatne_informacije TEXT
);
# Ova će tablica sadržavati manji broj redaka i neće se često mijenjati zbog svoje prirode, pa nam ne trebaju indeksi

CREATE TABLE Odjeli (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(255) NOT NULL UNIQUE,
    opis TEXT
);
# Ova će tablica sadržavati manji broj redaka i neće se često mijenjati zbog svoje prirode, pa nam ne trebaju indeksi

CREATE TABLE Osoba (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ime_prezime VARCHAR(255) NOT NULL,
    datum_rodenja DATE NOT NULL,
    oib CHAR(11) NOT NULL UNIQUE,
    spol VARCHAR(10) NOT NULL,
    adresa VARCHAR(255) NOT NULL,
    telefon VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
    );
# U tablici osoba možemo staviti indekse na stupce oib i email jer su označeni kao unique
CREATE INDEX idx_oib_osoba ON Osoba(oib);
CREATE INDEX idx_email_osoba ON Osoba(email);


CREATE TABLE Zaposlenik (
  id INT AUTO_INCREMENT PRIMARY KEY,
  datum_zaposlenja DATE NOT NULL,
  datum_izlaska_iz_sluzbe DATE, # ovo može biti NULL ako nije izašao iz službe
  id_nadređeni INT,
  id_radno_mjesto INT,
  id_odjel INT,
  id_zgrada INT,
  id_osoba INT,
  FOREIGN KEY (id_nadređeni) REFERENCES Zaposlenik(id), 
  FOREIGN KEY (id_radno_mjesto) REFERENCES Radno_mjesto(id),
  FOREIGN KEY (id_odjel) REFERENCES Odjeli(id),
  FOREIGN KEY (id_zgrada) REFERENCES Zgrada(id), # ovo je tipa zatvor di se nalazi/postaja di dela itd.
  FOREIGN KEY (id_osoba) REFERENCES Osoba(id)
);
# U tablici zaposlenik možemo staviti indeks na stupac datum_zaposlenja(ne i na stupac datum_izlaska_iz službe, jer za većinu zaposlenika je taj atribut NULL) i na radno mjesto da bismo mogli pretraživati brže zaposlenike po radnom mjestu
CREATE INDEX idx_datum_zaposlenja_zaposlenik ON Zaposlenik(datum_zaposlenja);
CREATE INDEX idx_radno_mjesto_zaposlenik ON Zaposlenik(id_radno_mjesto)	;

	CREATE TABLE Vozilo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    marka VARCHAR(255) NOT NULL,
    model VARCHAR(255) NOT NULL,
    registracija VARCHAR(20) UNIQUE,
    godina_proizvodnje INT NOT NULL,
    sluzbeno_vozilo BOOLEAN, # je li službeno ili ne
    id_vlasnik INT NOT NULL, # ovaj FK se odnosi na privatna/osobna vozila
    FOREIGN KEY (id_vlasnik) REFERENCES Osoba(id)
);
# U tablici vozilo možemo staviti indeks na stupac registracija zato što je unique i na id_vlasnik da bismo ubrzali pretragu po vlasniku
CREATE INDEX idx_registracija_vozilo ON Vozilo(registracija);
CREATE INDEX idx_id_vlasnik_vozilo ON Vozilo(id_vlasnik);


CREATE TABLE Predmet (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(255) NOT NULL,
    id_mjesto_pronalaska INT,
    FOREIGN KEY (id_mjesto_pronalaska) REFERENCES Mjesto(id)
);
# U tablici predmet možemo staviti indekse na stupac naziv zato što nam olakšava pretragu predmeta i na id_mjesto pronalaska kako bismo brže pronalazili mjesto pronalska za predmete
CREATE INDEX idx_naziv_predmet ON Predmet(naziv);
CREATE INDEX idx_id_mjesto_pronalaska_predmet ON Predmet(id_mjesto_pronalaska);

CREATE TABLE Kaznjiva_djela (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(255) NOT NULL UNIQUE,
    opis TEXT NOT NULL,
    predvidena_kazna INT,#zatvorska
    predvidena_novcana_kazna DECIMAL(10,2)
    
);
# Ova će tablica sadržavati manji broj redaka i neće se često mijenjati zbog svoje prirode, pa nam ne trebaju indeksi

CREATE TABLE Pas (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_trener INTEGER, # to je osoba zadužena za rad s psom
    oznaka VARCHAR(255) UNIQUE, # pretpostavljan da je ovo unikatno za svakega psa; ima mi logike 
    godina_rođenja INTEGER NOT NULL,
    status VARCHAR(255),
    id_kaznjivo_djelo INTEGER,# dali je pas za drogu/ljude/oružje itd.	
    FOREIGN KEY (id_trener) REFERENCES Zaposlenik(id),
    FOREIGN KEY (id_kaznjivo_djelo) REFERENCES Kaznjiva_djela(id)
    );
CREATE INDEX idx_id_kaznjivo_djelo_pas ON Pas(id_kaznjivo_djelo);
# Kod psa je najbolje indeksirati stupac koji regerencira kaznjiva djela za koja je pas zadužen kako bismo mogli pronalaziti odgovarajuće pse za pojedine slučajeve
CREATE TABLE Slucaj (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(255) NOT NULL,
    opis TEXT,
    pocetak DATETIME NOT NULL,
    zavrsetak DATETIME NOT NULL,
    status VARCHAR(20),
    id_pocinitelj INT,
    id_izvjestitelj INT,
    id_voditelj INT,
    id_dokaz INT,
    ukupna_vrijednost_zapljena INT DEFAULT 0,
    id_pas INT,
    id_svjedok INT,
id_ostecenik INT,
    FOREIGN KEY (id_pocinitelj) REFERENCES Osoba(id),
    FOREIGN KEY (id_izvjestitelj) REFERENCES Osoba(id),
    FOREIGN KEY (id_voditelj) REFERENCES Zaposlenik(id),
    FOREIGN KEY (id_dokaz) REFERENCES Predmet(id),
    FOREIGN KEY (id_pas) REFERENCES Pas(id),
    FOREIGN KEY (id_svjedok) REFERENCES Osoba(id),
FOREIGN KEY (id_ostecenik) REFERENCES Osoba(id)
);

# U tablici slučaj, možemo indeksirati stupac početak da bismo brže pretraživali slučajeve po datumu početka
# Možemp indeksirati i sve strane ključeve kako bismo ubrzali pretragu po njima
CREATE INDEX idx_pocetak_slucaj ON Slucaj(pocetak);
CREATE INDEX idx_id_pocinitelj_slucaj ON Slucaj(id_pocinitelj);
CREATE INDEX idx_id_izvjestitelj_slucaj ON Slucaj(id_izvjestitelj);
CREATE INDEX idx_id_voditelj_slucaj ON Slucaj(id_voditelj);
CREATE INDEX idx_id_dokaz_slucaj ON Slucaj(id_dokaz);
CREATE INDEX idx_id_pas_slucaj ON Slucaj(id_pas);
CREATE INDEX idx_id_svjedok_slucaj ON Slucaj(id_svjedok);
CREATE INDEX idx_id_ostecenik_slucaj ON Slucaj(id_ostecenik);

# U prezentaciji spomenut da je ovo evidencija nekriminalnih događaja (npr. izlazak policajca na uviđaj, ispitivanje svjedoka itd.)
CREATE TABLE Evidencija_dogadaja (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_slucaj INT,
    opis_dogadaja TEXT NOT NULL,
    datum_vrijeme DATETIME NOT NULL,
    id_mjesto INT NOT NULL,
    FOREIGN KEY (id_slucaj) REFERENCES Slucaj(id),
    FOREIGN KEY (id_mjesto) REFERENCES Mjesto(id)
);
# U tablici evidencija događaja možemo indeksirati strane ključeve da ubrzamo pretragu po slučaju i mjestu
CREATE INDEX idx_id_slucaj_evidencija_dogadaja ON Evidencija_dogadaja(id_slucaj);
CREATE INDEX idx_id_mjesto_evidencija_dogadaja ON Evidencija_dogadaja(id_mjesto);



CREATE TABLE Kaznjiva_djela_u_slucaju (
	id INT AUTO_INCREMENT PRIMARY KEY,
	id_mjesto INT,
    id_slucaj INT,
    id_kaznjivo_djelo INT,
	FOREIGN KEY (id_mjesto) REFERENCES Mjesto(id),
    FOREIGN KEY (id_slucaj) REFERENCES Slucaj(id),
    FOREIGN KEY (id_kaznjivo_djelo) REFERENCES Kaznjiva_djela(id)
);
# Možemo dodati indekse na mjestu, slučaju i kaznjivom djelu kako bismo ubrzali pretragu po svakom od atributa
CREATE INDEX idx_id_mjesto_kaznjiva_djela ON Kaznjiva_djela_u_slucaju(id_mjesto);
CREATE INDEX idx_id_slucaj_kaznjiva_djela ON Kaznjiva_djela_u_slucaju(id_slucaj);
CREATE INDEX idx_id_kaznjivo_djelo_kaznjiva_djela ON Kaznjiva_djela_u_slucaju(id_kaznjivo_djelo);



CREATE TABLE Izvjestaji (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naslov VARCHAR(255) NOT NULL,
    sadrzaj TEXT NOT NULL,
    id_autor INT NOT NULL,
    id_slucaj INT NOT NULL,
    FOREIGN KEY (id_autor) REFERENCES Zaposlenik(id),
    FOREIGN KEY (id_slucaj) REFERENCES Slucaj(id)
);
# U tablici izvjestaji možemo indeksirati autora i slucaj kako bismo brže pretraživali izvještaje određenih autora, ili za određene slučajeve
CREATE INDEX idx_id_autor_izvjestaji ON Izvjestaji(id_autor);
CREATE INDEX idx_id_slucaj_izvjestaji ON Izvjestaji(id_slucaj);

CREATE TABLE Zapljene (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_slucaj INT NOT NULL,
    id_predmet INT NOT NULL,
    vrijednost NUMERIC (10,2),
    FOREIGN KEY (id_slucaj) REFERENCES Slucaj(id),
    FOREIGN KEY (id_predmet) REFERENCES Predmet(id)
);
# U tablici zapljene možemo indeksirati slucaj i predmet zbog brže pretrage po tim atributima
CREATE INDEX idx_id_slucaj_zapljene ON Zapljene(id_slucaj);
CREATE INDEX idx_id_predmet_zapljene ON Zapljene(id_predmet);

CREATE TABLE Sredstvo_utvrdivanja_istine ( # ovo je tipa poligraf, alkotest i sl.
	id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(100) NOT NULL
);

CREATE TABLE Sui_slucaj (
	id INT AUTO_INCREMENT PRIMARY KEY,
    id_sui INT NOT NULL,
    id_slucaj INT NOT NULL,
    FOREIGN KEY (id_sui) REFERENCES Sredstvo_utvrdivanja_istine(id),
    FOREIGN KEY (id_slucaj) REFERENCES Slucaj(id)
);
# U tablici sui_slucaj možemo idneksirati id_sui i id_slucaj zbog brže pretrage
CREATE INDEX idx_id_sui_sui_slucaj ON Sui_slucaj(id_sui);
CREATE INDEX idx_id_slucaj_sui_slucaj ON Sui_slucaj(id_slucaj);
########################################################################################################################################################################################
#Kreirajte transakciju koja, uzimajući u obzir trenutačnu aktivnost pasa, dodjeljuje psa s najmanje slučajeva novom aktivnom slučaju. Rješenje treba osigurati dosljednost podataka i minimalno opterećenje pasa.
/*
 FOR UPDATE klauzula koristi se kako bi se tijekom čitanja informacija o broju slučajeva za aktivne pse zaključali retci, spriječavajući druge transakcije da mijenjaju status pasa, primjerice umirovljenje ili dodjelu na nove slučajeve. 
 Time se osigurava da pas s najmanje slučajeva ostane nepromijenjen tijekom trajanja transakcije, održavajući dosljednost podataka u kontekstu dodjele pasa novim slučajevima.
*/
#  U ovom zadatku koristimo izolacijski nivo "REPEATABLE READ" kako bi osigurao dosljednost podataka tijekom trajanja transakcije.
#  Budući da analiziramo trenutačnu aktivnost pasa i dodjelu pasa slučajevima, važno je da podaci o psima ostanu nepromijenjeni kako bi se izbjegle netočnosti
#  u dodjeli pasa novim slučajevima. "REPEATABLE READ" sprječava čitanje prljavih podataka (dirty reads) i neponovljivih čitanja (non-repeatable reads), 
#  čime se održava konzistentnost podataka i osigurava pouzdanost u obradi podataka u okviru transakcije. */

# Postavljanje izolacijskog nivoa na REPEATABLE READ
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

# Pronađemo aktivne pse s brojem slučajeva
SELECT Pas.id, COUNT(Slucaj.id) AS broj_slucajeva
FROM Pas
LEFT JOIN Slucaj ON Pas.id = Slucaj.id_pas
WHERE Pas.status = 'Aktivan' AND Slucaj.status = 'Aktivan'
GROUP BY Pas.id
FOR UPDATE;

-- Pronađemo psa s najmanje slučajeva
SELECT Pas.id
FROM Pas
LEFT JOIN Slucaj ON Pas.id = Slucaj.id_pas
WHERE Pas.status = 'Aktivan' AND Slucaj.status = 'Aktivan'
GROUP BY Pas.id
ORDER BY COUNT(Slucaj.id) ASC
LIMIT 1;

-- Dodijelimo psa s najmanje slučajeva novom slučaju
INSERT INTO Slucaj (naziv, pocetak, status, id_pas)
SELECT 'Novi slucaj', NOW(), 'Aktivan', Pas.id
FROM Pas
LEFT JOIN Slucaj ON Pas.id = Slucaj.id_pas
WHERE Pas.status = 'Aktivan' AND Slucaj.status = 'Aktivan'
GROUP BY Pas.id
ORDER BY COUNT(Slucaj.id) ASC
LIMIT 1;

-- Zatvorimo transakciju
COMMIT;





#########################################################################3
#  transakcija koja će omogućiti praćenje broja izvještaja za svaki slučaj
# Prva transakcija za dodavanje stupca broj_izvjestaja u tablicu Slucaj
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

# Dodavanje stupca broj_izvjestaja u tablicu Slucaj
ALTER TABLE Slucaj
ADD COLUMN broj_izvjestaja INT DEFAULT 0;

# Zatvaranje prve transakcije
COMMIT;

# Postavljanje izolacijskog nivoa na REPEATABLE READ
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

# Dohvaćanje ID-a osobe koja će biti autor izvještaja
SET @id_autor = (SELECT id FROM Osoba WHERE ime = 'ImeOsobe' AND prezime = 'PrezimeOsobe' LIMIT 1);

# Dohvaćanje ID-a slučaja za koji ćemo kreirati izvještaj
SET @id_slucaj = (SELECT id FROM Slucaj WHERE naziv = 'NazivSlucaja' LIMIT 1);

# Privremena tablica za praćenje broja izvještaja po slučaju
CREATE TEMPORARY TABLE IF NOT EXISTS TempBrojIzvjestaja (
    id_slucaj INT,
    broj_izvjestaja INT
);

# Inicijalizacija broja izvještaja na 0 za odabrani slučaj
INSERT INTO TempBrojIzvjestaja (id_slucaj, broj_izvjestaja)
VALUES (@id_slucaj, 0)
ON DUPLICATE KEY UPDATE broj_izvjestaja = broj_izvjestaja;

# Dodavanje novog izvještaja
INSERT INTO Izvjestaji (naslov, sadrzaj, id_autor, id_slucaj)
VALUES ('Naslov izvještaja', 'Sadržaj izvještaja.', @id_autor, @id_slucaj);

# Ažuriranje broja izvještaja za odabrani slučaj u privremenoj tablici
UPDATE TempBrojIzvjestaja
SET broj_izvjestaja = broj_izvjestaja + 1
WHERE id_slucaj = @id_slucaj;

# Ažuriranje ukupnog broja izvještaja za odabrani slučaj u tablici Slucaj
UPDATE Slucaj
SET broj_izvjestaja = (SELECT broj_izvjestaja FROM TempBrojIzvjestaja WHERE id_slucaj = @id_slucaj)
WHERE id = @id_slucaj;

# Brisanje privremene tablice
DROP TEMPORARY TABLE IF EXISTS TempBrojIzvjestaja;

# Zatvaranje transakcije
COMMIT;

##################################################################################################
#  izraditi SQL transakciju koja će analizirati događaje u evidenciji (tablica Evidencija_dogadaja) i stvoriti tri nove tablice događaja prema godinama.
# Novo kreirane tablice trebaju sadržavati događaje koji su se dogodili u 2023., 2022. i 2021. godini.
# Postavljanje izolacijskog nivoa na REPEATABLE READ
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

# Kreiranje tablice za događaje u 2023. godini
CREATE TABLE IF NOT EXISTS Događaji_2023 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_slucaj INT,
    opis_dogadaja TEXT NOT NULL,
    datum_vrijeme DATETIME NOT NULL,
    id_mjesto INT NOT NULL,
    FOREIGN KEY (id_slucaj) REFERENCES Slucaj(id),
    FOREIGN KEY (id_mjesto) REFERENCES Mjesto(id)
);

# Insert događaja u 2023. godinu
INSERT INTO Događaji_2023 (id_slucaj, opis_dogadaja, datum_vrijeme, id_mjesto)
SELECT id_slucaj, opis_dogadaja, datum_vrijeme, id_mjesto
FROM Evidencija_dogadaja
WHERE YEAR(datum_vrijeme) = 2023;

# Kreiranje tablice za događaje u 2022. godini
CREATE TABLE IF NOT EXISTS Događaji_2022 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_slucaj INT,
    opis_dogadaja TEXT NOT NULL,
    datum_vrijeme DATETIME NOT NULL,
    id_mjesto INT NOT NULL,
    FOREIGN KEY (id_slucaj) REFERENCES Slucaj(id),
    FOREIGN KEY (id_mjesto) REFERENCES Mjesto(id)
);

# Insert događaja u 2022. godinu
INSERT INTO Događaji_2022 (id_slucaj, opis_dogadaja, datum_vrijeme, id_mjesto)
SELECT id_slucaj, opis_dogadaja, datum_vrijeme, id_mjesto
FROM Evidencija_dogadaja
WHERE YEAR(datum_vrijeme) = 2022;

# Kreiranje tablice za događaje u 2021. godini
CREATE TABLE IF NOT EXISTS Događaji_2021 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_slucaj INT,
    opis_dogadaja TEXT NOT NULL,
    datum_vrijeme DATETIME NOT NULL,
    id_mjesto INT NOT NULL,
    FOREIGN KEY (id_slucaj) REFERENCES Slucaj(id),
    FOREIGN KEY (id_mjesto) REFERENCES Mjesto(id)
);

# Insert događaja u 2021. godinu
INSERT INTO Događaji_2021 (id_slucaj, opis_dogadaja, datum_vrijeme, id_mjesto)
SELECT id_slucaj, opis_dogadaja, datum_vrijeme, id_mjesto
FROM Evidencija_dogadaja
WHERE YEAR(datum_vrijeme) = 2021;

# Zatvaranje transakcije
COMMIT;

# Napravi transakciju koja će pomoću procedure dodati 20 novih kažnjivih djela
SET SESSION TRANSACTION ISOLATION LEVEL 
READ COMMITTED;
START TRANSACTION;

CALL Dodaj_Novo_Kaznjivo_Djelo('Lažno prijavljivanje', 'Namjerno davanje lažnih informacija policiji ili drugim službama.', 4);
CALL Dodaj_Novo_Kaznjivo_Djelo('Sabotaža prometa', 'Namjerno uzrokovano kaos u prometu radi ometanja normalnog toka.', 5);
CALL Dodaj_Novo_Kaznjivo_Djelo('Povreda tajnosti pisma', 'Neovlašteno otvaranje i čitanje privatne pošte.', 3);
CALL Dodaj_Novo_Kaznjivo_Djelo('Prijetnja bombom', 'Prijeteće ponašanje koje uključuje prijetnju eksplozivnim napravama.', 8);
CALL Dodaj_Novo_Kaznjivo_Djelo('Zloupotreba položaja', 'Korištenje položaja u društvu radi stjecanja nepravedne koristi.', 6);
CALL Dodaj_Novo_Kaznjivo_Djelo('Zlostavljanje starijih osoba', 'Fizičko, emocionalno ili financijsko zlostavljanje starijih osoba.', 7);
CALL Dodaj_Novo_Kaznjivo_Djelo('Ratni zločin', 'Zločin protiv civilnog stanovništva tijekom rata ili sukoba.', 10);
CALL Dodaj_Novo_Kaznjivo_Djelo('Neovlaštena uporaba vojnog vozila', 'Korištenje vojnog vozila bez odobrenja.', 4);
CALL Dodaj_Novo_Kaznjivo_Djelo('Organizirani kriminal', 'Sudjelovanje u organiziranom kriminalu i kriminalnim udruženjima.', 9);
CALL Dodaj_Novo_Kaznjivo_Djelo('Podmićivanje svjedoka', 'Davanje mita svjedoku radi utjecaja na iskaz.', 6);
CALL Dodaj_Novo_Kaznjivo_Djelo('Sabotaža energetskog sustava', 'Namjerno oštećenje energetskog sustava radi ometanja opskrbe.', 8);
CALL Dodaj_Novo_Kaznjivo_Djelo('Nezakoniti izvoz oružja', 'Izvoz oružja bez odobrenja i u suprotnosti s zakonima.', 7);
CALL Dodaj_Novo_Kaznjivo_Djelo('Otmica djeteta', 'Nezakonito zadržavanje djeteta protiv volje roditelja ili skrbnika.', 5);
CALL Dodaj_Novo_Kaznjivo_Djelo('Napad na suverenitet', 'Napad na suverenitet države ili teritorijalni integritet.', 9);
CALL Dodaj_Novo_Kaznjivo_Djelo('Preprodaja ilegalnih supstanci', 'Neovlaštena proizvodnja i distribucija ilegalnih supstanci.', 6);
CALL Dodaj_Novo_Kaznjivo_Djelo('Zločin iz mržnje', 'Napad motiviran mržnjom prema nekoj skupini ljudi.', 7);
CALL Dodaj_Novo_Kaznjivo_Djelo('Pretvaranje oružja u automatsko', 'Nedopuštena modifikacija vatrenog oružja u automatsko.', 4);
CALL Dodaj_Novo_Kaznjivo_Djelo('Izazivanje nesreće', 'Namjerno izazivanje prometne ili druge nesreće s ozbiljnim posljedicama.', 5);
CALL Dodaj_Novo_Kaznjivo_Djelo('Zlostavljanje životinja u grupi', 'Nečovječno postupanje prema većem broju životinja.', 6);
CALL Dodaj_Novo_Kaznjivo_Djelo('Dijamantna pljačka', 'Oružana pljačka draguljarnice s namjerom krađe dijamanata.', 8);

COMMIT;


-- Napravi transakciju koja će omogućiti pregled svih službenih vozila. Neka se stupac id_vlasnik pretvori u stupac vlasnik tipa VARCHAR zato što je
-- vlasnik svih službenih vozila MUP
-- Postavljanje izolacijskog nivoa na REPEATABLE READ
-- Osiguraj da se prilikom izvođenja transakcije ne obriše ili izmjeni niti jedno od službenih vozila (zato imamo repeatable read i zaključavanje)
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

-- Dobivanje zaključavanja za službena vozila
SELECT * FROM Vozilo WHERE sluzbeno_vozilo = 1 FOR UPDATE NOWAIT; -- pokušavamo zaključati retke, ali ako su već zaključani ne čekamo, nego odmah vraća grešku i prekine transakciju

-- Kreiranje privremene tablice Pregled_službenih_vozila
CREATE TEMPORARY TABLE IF NOT EXISTS Pregled_službenih_vozila (
    id INT,
    marka VARCHAR(255),
    model VARCHAR(255),
    registracija VARCHAR(20),
    godina_proizvodnje INT,
    sluzbeno_vozilo BOOLEAN,
    vlasnik VARCHAR(255)
);

-- Kopiranje podataka o službenim vozilima u privremenu tablicu
INSERT INTO Pregled_službenih_vozila (id, marka, model, registracija, godina_proizvodnje, sluzbeno_vozilo, vlasnik)
SELECT id, marka, model, registracija, godina_proizvodnje, sluzbeno_vozilo, 'Ministarstvo Unutarnjih Poslova' AS vlasnik
FROM Vozilo
WHERE sluzbeno_vozilo = 1;

-- Promjena strukture originalne tablice Vozilo
ALTER TABLE Vozilo
MODIFY COLUMN id_vlasnik vlasnik VARCHAR(255) NOT NULL;

-- Postavljanje vlasnika na 'Ministarstvo Unutarnjih Poslova' za službena vozila
UPDATE Vozilo
SET vlasnik = 'Ministarstvo Unutarnjih Poslova'
WHERE sluzbeno_vozilo = 1;

-- Zatvaranje transakcije
COMMIT;



