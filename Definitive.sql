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

#TRIGERI
# 20 Trigera
# 1. Napiši triger koji će onemogućiti da za slučaj koji u sebi ima određena kaznena djela koristimo psa koji nije zadužen za ta ista djela u slučaju
	DELIMITER //

CREATE TRIGGER bi_pas_slucaj_KD
BEFORE INSERT ON Slucaj
FOR EACH ROW
BEGIN
    DECLARE id_kaznjivo_djelo_psa INT;

    SELECT id_kaznjivo_djelo INTO id_kaznjivo_djelo_psa
    FROM Pas
    WHERE id = NEW.id_pas;

    IF id_kaznjivo_djelo_psa IS NULL OR id_kaznjivo_djelo_psa != NEW.id_kaznjivo_djelo THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pas nije zadužen za kaznjiva djela u ovom slučaju.';
    END IF;
END;

//

DELIMITER ;

# 2. Iako postoji opcija kaskadnog brisanja u SQL-u, ovdje ćemo u nekim slučajevima pomoću trigera htijeti zabraniti brisanje, pošto je važno da neki podaci ostanu zabilježeni. U iznimnim slučajevima možemo ostavljati obavijest da je neka vrijednost obrisana iz baze. Također, u većini slučajeva nam opcija kaskadnog brisanja nikako ne bi odgovarala, zato što je u radu policije važna kontinuirana evidencija
# Napiši triger koji će a) ako u području uprave više od 5 mjesta, zabraniti brisanje uz obavijest: "Područje uprave s više od 5 mjesta ne smije biti obrisano" b) ako u području uprave ima manje od 5 mjesta, dopustiti da se područje uprave obriše, ali će se onda u mjestima koja referenciraju to područje uprave, pojaviti obavijest "Prvotno područje uprave je obrisano, povežite mjesto s novim područjem"
DELIMITER //
CREATE TRIGGER bd_podrucje_uprave
BEFORE DELETE ON Podrucje_uprave
FOR EACH ROW
BEGIN
    DECLARE count_mjesta INT;
    SELECT COUNT(*) INTO count_mjesta FROM Mjesto WHERE id_podrucje_uprave = OLD.id;
    
    IF count_mjesta > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Područje uprave s više od 5 mjesta ne smije biti obrisano.';
    ELSE
        UPDATE Mjesto
        SET id_podrucje_uprave = NULL
        WHERE id_podrucje_uprave = OLD.id;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Prvotno područje uprave je obrisano, povežite mjesto s novim područjem.';
    END IF;
END;
//
DELIMITER ;

# 3. Napiši triger koji će a) spriječiti brisanje osobe ako je ona zaposlenik koji je još u službi (datum izlaska iz službe nije null) uz obavijest:
# "osoba koju pokušavate obrisati je zaposlenik, prvo ju obrišite iz tablice zaposlenika)" b) obrisati osobu i iz tablice zaposlenika i iz tablice osoba, 
# ukoliko datum_izlaska_iz_službe ima neku vrijednost što ukazuje da osoba više nije zaposlena
DELIMITER //
CREATE TRIGGER bd_osoba
BEFORE DELETE ON Osoba
FOR EACH ROW
BEGIN
    DECLARE is_zaposlenik BOOLEAN;
    SET is_zaposlenik = EXISTS (SELECT 1 FROM Zaposlenik WHERE id_osoba = OLD.id AND datum_izlaska_iz_sluzbe IS NULL);

    IF is_zaposlenik = TRUE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Osoba koju pokušavate obrisati je zaposlenik, prvo ju obrišite iz tablice Zaposlenik.';
    ELSE
        IF EXISTS (SELECT 1 FROM Zaposlenik WHERE id_osoba = OLD.id) THEN
            DELETE FROM Zaposlenik WHERE id_osoba = OLD.id;
        END IF;
    END IF;
END;
//
DELIMITER ;


# 4. Napiši triger koji će, u slučaju da se kažnjivo djelo obriše iz baze, postaviti id_kaznjivo_djelo kod psa na NULL, ukoliko je on prije bio zadužen za upravo to KD koje smo obrisali
DELIMITER //
CREATE TRIGGER ad_pas
AFTER DELETE ON Kaznjiva_djela
FOR EACH ROW
BEGIN
    UPDATE Pas
    SET id_kaznjivo_djelo = NULL
    WHERE id_kaznjivo_djelo = OLD.id;
END;
//
DELIMITER ;

# 5. Napiši triger koji će zabraniti da iz tablice obrišemo predmete koji služe kao dokazi u aktivnim slučajevima (status im nije završeno, te se ne nalaza u arhivi) uz obavijest "Ne možete obrisati dokaze za aktivan slučaj"
DELIMITER //
CREATE TRIGGER bd_dokaz
BEFORE DELETE ON Predmet
FOR EACH ROW
BEGIN
    DECLARE aktivan INT;
    SELECT COUNT(*) INTO aktivan FROM Slucaj WHERE id_dokaz = OLD.id AND status != 'Završeno';
    
    IF aktivan > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ne možete obrisati dokaze za aktivni slučaj.';
    END IF;
END;
//
DELIMITER ;

# 6. Napiši triger koji će zabraniti da iz tablice obrišemo osobe koje su evidentirani kao počinitelji u aktivnim slučajevima
DELIMITER //
CREATE TRIGGER bd_osoba_2
BEFORE DELETE ON Osoba
FOR EACH ROW
BEGIN
    DECLARE je_pocinitelj INT;
    SELECT COUNT(*) INTO je_pocinitelj FROM Slucaj WHERE id_pocinitelj = OLD.id AND status != 'Završeno';
    
    IF je_pocinitelj > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ne možete obrisati osobu koja je evidentirana kao počinitelj.';
    END IF;
END;
//
DELIMITER ;

# 7. Napiši triger koji će zabraniti brisanje bilo kojeg izvještaja kreiranog za slučajeve koji nisu završeni (završetak je NULL), ili im je završetak "noviji" od 10 godina (ne smijemo brisati izvještaje za aktivne slučajeve, i za slučajeve koji su završili pred manje od 10 godina)
DELIMITER //
CREATE TRIGGER bd_izvjestaj
BEFORE DELETE ON Izvjestaji
FOR EACH ROW
BEGIN
    DECLARE slucaj_zavrsen DATETIME;
    SELECT zavrsetak INTO slucaj_zavrsen FROM Slucaj WHERE id = OLD.id_slucaj;
    
    IF slucaj_zavrsen IS NULL OR slucaj_zavrsen > DATE_SUB(NOW(), INTERVAL 10 YEAR) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ne možete obrisati izvještaj za aktivan slučaj ili za slučaj koji je završio unutar posljednjih 10 godina.';
    END IF;
END;
//
DELIMITER ;

# 8. Triger koji osigurava da pri unosu spola osobe možemo staviti samo muški ili ženski spol
DELIMITER //
CREATE TRIGGER bi_osoba
BEFORE INSERT ON Osoba
FOR EACH ROW
BEGIN
    DECLARE validan_spol BOOLEAN;

    SET NEW.Spol = LOWER(NEW.Spol);

    IF NEW.Spol IN ('muski', 'zenski', 'muški', 'ženski', 'm', 'ž', 'muški', 'ženski', 'muski', 'zenski') THEN
        SET validan_spol = TRUE;
    ELSE
        SET validan_spol = FALSE;
    END IF;

    IF NOT validan_spol THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Spol nije valjan. Ispravni formati su: muski, zenski, m, ž, muški, ženski.';
    END IF;
END;
//
DELIMITER ;

# 9. Triger koji kreira stupac Ukupna_vrijednost_zapljena u tablici slučaj i ažurira ga nakon svake nove unesene zapljene u tom slučaju
DELIMITER //
CREATE TRIGGER ai_zapljena
AFTER INSERT ON Zapljene
FOR EACH ROW
BEGIN
    DECLARE ukupno DECIMAL(10, 2);
    
    SELECT SUM(P.Vrijednost) INTO ukupno
    FROM Predmet P
    WHERE P.ID = NEW.id_predmet;

    UPDATE Slucaj
    SET Ukupna_vrijednost_zapljena = ukupno
    WHERE ID = NEW.id_slucaj;
END;
//
DELIMITER ;

# 10. Triger koji premješta završene slučajeve iz tablice slučaj u tablicu arhiva
DELIMITER //
CREATE TRIGGER au_slucaj_arhiva
AFTER UPDATE ON Slucaj
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Završeno' THEN
        INSERT INTO Arhiva (id_slucaj) VALUES (OLD.ID);
        DELETE FROM Slucaj WHERE ID = OLD.ID;
    END IF;
END;
//
DELIMITER ;

CREATE TEMPORARY TABLE Arhiva(
id_slucaj FOREIGN KEY REFERENCES slucaj(id)
	):

# 11. Provjera da osoba nije nadređena sama sebi
DELIMITER //
CREATE TRIGGER bi_zaposlenik
BEFORE INSERT ON Zaposlenik
FOR EACH ROW
BEGIN
    IF NEW.id_nadređeni IS NOT NULL AND NEW.id_nadređeni = NEW.Id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nadređeni ne može biti ista osoba kao i podređeni.';
    END IF;
END;
//
DELIMITER ;

# 12. Provjera da su datum početka i završetka slučaja različiti i da je datum završetka "veći" od datuma početka
DELIMITER //

CREATE TRIGGER bi_slucaj
BEFORE INSERT ON Slucaj
FOR EACH ROW
BEGIN
    IF NEW.Pocetak >= NEW.Zavrsetak THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Datum završetka slučaja mora biti veći od datuma početka.';
    END IF;
END;
//
DELIMITER ;


# 13. Napravi triger koji će umiroviti psa ako je njegova godina rođenja ažurirana na način da je dob psa 10 ili veća
DELIMITER //

CREATE TRIGGER bu_pas
BEFORE UPDATE ON Pas
FOR EACH ROW
BEGIN
    DECLARE nova_dob INTEGER;
    SET nova_dob = YEAR(NOW()) - NEW.godina_rođenja;
    IF nova_dob >= 10 AND OLD.godina_rođenja <> nova_godina_rodenja THEN
        SET NEW.status = 'Časno umirovljen';
    END IF;
END;
//
DELIMITER ;

# 14. Napravi triger koji će, u slučaju da je pas časno umirovljen koristeći triger (ili ručno), onemogućiti da ga koristimo u novim slučajevima
DELIMITER //
CREATE TRIGGER bi_slucaj_pas
BEFORE INSERT ON Slucaj
FOR EACH ROW
BEGIN
    DECLARE Pas_Status VARCHAR(255);
    SELECT Status INTO Pas_Status FROM Pas WHERE Id = NEW.id_pas;
    
    IF Pas_Status = 'Časno umirovljen' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pas kojeg pokušavate koristiti na slučaju je umirovljen, odaberite drugog.';
    END IF;
END;
//
DELIMITER ;

# 15. Napiši triger koji će, u slučaju da je osoba mlađa od 18 godina (godina današnjeg datuma - godina rođenja daju broj manji od 18), pri dodavanju te osobe u slučaj dodati poseban stupac s napomenom: Počinitelj je maloljetan - slučaj nije otvoren za javnost
ALTER TABLE Slucaj
ADD COLUMN Napomena VARCHAR(255);

DELIMITER //

CREATE TRIGGER bi_slucaj_maloljetni_pocinitelj
BEFORE INSERT ON Slucaj
FOR EACH ROW
BEGIN
    DECLARE datum_rodjenja DATE;
    DECLARE godina_danas INT;
    DECLARE godina_rodjenja INT;
    
    SELECT Osoba.Datum_rodjenja INTO datum_rodjenja
    FROM Osoba
    WHERE Osoba.Id = NEW.id_pocinitelj;
    
    SET godina_danas = YEAR(NOW());
    
    SET godina_rodjenja = YEAR(datum_rodjenja);
    
    IF (godina_danas - godina_rodjenja) < 18 THEN
        SET NEW.Napomena = 'Počinitelj je maloljetan - slučaj nije otvoren za javnost';
    ELSE
        SET NEW.Napomena = 'Počinitelj je punoljetan - javnost smije prisustvovati slučaju';
    END IF;
END //

DELIMITER ;

# 16. Napravi triger koji će onemogućiti da maloljetnik bude vlasnik vozila
DELIMITER //
CREATE TRIGGER bi_vozilo_punoljetnost
BEFORE INSERT ON Vozilo FOR EACH ROW
BEGIN
    DECLARE vlasnik_godine INT;
    SELECT TIMESTAMPDIFF(YEAR, (SELECT Datum_rodjenja FROM Osoba WHERE Id = NEW.id_vlasnik), CURDATE()) INTO vlasnik_godine;

    IF vlasnik_godine < 18 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Vlasnik vozila je maloljetan i ne može posjedovati vozilo!';
    END IF;
END;
//
DELIMITER ;


# 17. Napravi triger koji će u slučaju da postavljamo status slučaja na završeno, postaviti datum završetka na današnji ako mi eksplicitno ne navedemo neki drugi datum, ali će dozvoliti da ga izmjenimo ako želimo
DELIMITER //

CREATE TRIGGER bu_slucaj
BEFORE UPDATE ON Slucaj
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Riješen' AND OLD.Status != 'Riješen' AND NEW.Zavrsetak IS NULL THEN
        SET NEW.Zavrsetak = CURRENT_DATE();
    END IF;
END;
//
DELIMITER ;


-- 18. Triger koji će prije unosa provjeravati jesu li u slučaju počinitelj i svjedok različite osobe. 

DELIMITER //
CREATE TRIGGER bi_slucaj
BEFORE INSERT ON slucaj
FOR EACH ROW
BEGIN

IF new.id_pocinitelj=new.id_svjedok
THEN SIGNAL SQLSTATE '40000'
SET MESSAGE_TEXT = 'Počitelj ne može istovremeno biti svjedok!';
END IF;

END//
DELIMITER ;
 
-- 19. Triger koji provjerava je li email dobre strukture
DELIMITER //
CREATE TRIGGER bi_osoba
BEFORE INSERT ON osoba
FOR EACH ROW
BEGIN
IF new.email NOT LIKE '%@%'
THEN SIGNAL SQLSTATE '40000'
SET MESSAGE_TEXT = 'Neispravan email';
END IF;
END//
DELIMITER ;

-- 20. Triger koji će ograničiti da isti zaposlenik ne smije istovremeno voditi više od 5 aktivnih slučajeva kako ne bi bio preopterećen
DELIMITER //

CREATE TRIGGER Ogranicenje_broja_slucajeva
BEFORE INSERT ON Slucaj
FOR EACH ROW
BEGIN
    DECLARE broj_slucajeva INT;

    SELECT COUNT(*)
    INTO broj_slucajeva
    FROM Slucaj
    WHERE id_voditelj = NEW.id_voditelj AND status = 'Aktivan';

    IF broj_slucajeva >= 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Zaposlenik ne može voditi više od 5 aktvnih slučajeva istovremeno kako ne bi bio preopterećen.';
    END IF;
END // 
###############################################################################################################################################

# UPITI

 
# 1. Ispiši prosječan broj godina osoba koje su prijavile digitalno nasilje

SELECT AVG(YEAR(S.pocetak)-YEAR(O.datum_rodenja)) AS prosjecan_broj_godina
	FROM Slucaj S
	INNER JOIN Osoba O ON S.id_izvjestitelj = O.id
	WHERE S.naziv LIKE '%Digitalno nasilje%';


# 2. Prikaži osobu čiji je nestanak posljednji prijavljen

SELECT O.*
	FROM Osoba O
	INNER JOIN Slucaj S ON O.id = S.id_ostecenik
	WHERE S.naziv LIKE '%Nestanak%'
	ORDER BY S.pocetak DESC
	LIMIT 1;

# 3. Prikaži najčešću vrstu kažnjivog djela

SELECT KD.*
	FROM Kaznjiva_djela KD
	INNER JOIN Kaznjiva_djela_u_slucaju KDS ON KDS.id_kaznjivo_djelo = KD.id
	GROUP BY KD.id
	ORDER BY COUNT(*)
	LIMIT 1;


# 4. Ispišimo sve voditelje slučajeva i slučajeve koje vode

SELECT O.ime_prezime, S.naziv AS naziv_slucaja
	FROM Zaposlenik Z
	JOIN Osoba O ON Z.id_osoba = O.id
	JOIN Slucaj S ON Z.id = S.id_voditelj;


# 5. Ispišimo slučajeve i evidencije za određenu osobu (osumnjičenika)

SELECT O.ime_prezime, S.naziv AS naziv_slucaja, ED.opis_dogadaja, ED.datum_vrijeme, ED.id_mjesto
	FROM Slucaj S
	JOIN Evidencija_dogadaja ED ON S.id = ED.id_slucaj
	JOIN Osoba O ON O.id = S.id_pocinitelj
	WHERE O.ime_prezime = 'Ime Prezime';


# 6. Ispišimo sve osobe koje su osumnjičene za određeno KD

SELECT DISTINCT O.ime_prezime
	FROM Osoba O
	JOIN Slucaj S ON O.id = S.id_pocinitelj
	JOIN Kaznjiva_djela_u_slucaju KDS ON S.id = KDS.id_slucaj
	JOIN Kaznjiva_djela KD ON KDS.id_kaznjivo_djelo = KD.id
	WHERE KD.naziv = 'Naziv kažnjivog djela';


# 7. Pronađimo sve slučajeve koji sadrže KD i nisu riješeni

SELECT S.naziv, KD.naziv AS kaznjivo_djelo
	FROM Slucaj S
	INNER JOIN Kaznjiva_djela_u_slucaju KDS ON S.id = KDS.id_slucaj
	INNER JOIN Kaznjiva_djela KD ON KDS.id_kaznjivo_djelo= KD.id
	WHERE S.status = 'Aktivan';


# 8. Izračunajmo iznos zapljene za svaki pojedini slučaj

SELECT S.id, S.naziv, SUM(ZA.vrijednost) AS ukupna_vrijednost_zapljena
	FROM Slucaj S
	LEFT JOIN Zapljene ZA ON S.id = ZA.id_slucaj
	GROUP BY S.id, S.naziv;


# 9. Pronađi prosječnu vrijednost zapljene za pojedina kaznena djela

SELECT K.naziv AS vrsta_kaznjivog_djela, AVG(ZA.vrijednost) AS prosjecna_vrijednost_zapljene
	FROM Kaznjiva_djela_u_slucaju KDS
	JOIN Kaznjiva_djela KD ON KDS.id_kaznjivo_djelo= KD.id
	JOIN Zapljene ZA ON KDS.id_slucaj = ZA.id_slucaj
	GROUP BY KD.naziv;


# 10. Pronađi sve odjele i broj zaposlenika na njima

SELECT O.naziv AS naziv_odjela, COUNT(Z.id) AS broj_zaposlenika
	FROM Zaposlenik Z
	JOIN Odjeli O ON Z.id_odjel = O.id
	GROUP BY O.id, O.naziv;


# 11. Pronađi ukupnu vrijednost zapljena po odjelu i sortiraj ih po vrijednosti silazno

SELECT Z.id_odjel, SUM(ZA.vrijednost) AS ukupna_vrijednost_zapljena
	FROM Slucaj S
	JOIN Zapljene ZA ON S.id = ZA.id_slucaj
	JOIN Zaposlenik Z ON S.id_voditelj= Z.id
	GROUP BY Z.id_odjel
	ORDER BY ukupna_vrijednost_zapljena DESC;


# 12. Pronađi osobu koja mora odslužiti najveću ukupnu zatvorsku kaznu

SELECT O.id, O.ime_prezime, SUM(KD.predvidena_kazna) AS ukupna_kazna
	FROM Osoba O
	INNER JOIN Slucaj S ON O.id = S.id_pocinitelj
	INNER JOIN Kaznjiva_djela_u_slucaju KDS ON S.id = KDS.id_slucaj
	INNER JOIN Kaznjiva_djela KD ON KDS.id_kaznjivo_djelo= KD.id
	WHERE KD.predvidena_kazna IS NOT NULL
	GROUP BY O.id, O.ime_prezime
	ORDER BY ukupna_kazna DESC
	LIMIT 1;


# 13. Prikaži sva vozila i u koliko slučajeva su se oni upisali

SELECT V.*, COUNT(S.id) AS broj_slucajeva
	FROM Vozilo V
	LEFT OUTER JOIN Osoba O ON V.id_vlasnik = O.id
	INNER JOIN Slucaj S ON O.id = S.id_pocinitelj
	GROUP BY V.id;


# 14. Mjesto s najviše slučajeva

SELECT M.*, COUNT(ED.id) AS broj_slucajeva
	FROM Mjesto M
	INNER JOIN Evidencija_dogadaja ED ON M.id = ED.id_mjesto
	GROUP BY M.id 
	ORDER BY broj_slucajeva DESC 
	LIMIT 1;


# 15. Mjesto s najmanje slučajeva

SELECT M.*, COUNT(ED.id) AS broj_slucajeva
	FROM Mjesto M
	INNER JOIN Evidencija_dogadaja ED ON M.id = ED.id_mjesto
	GROUP BY M.id 
	ORDER BY broj_slucajeva ASC
	LIMIT 1;


# 16. Pronađi policijskog službenika koji je vodio najviše slučajeva

SELECT Z.id AS id_zaposlenika, O.ime_prezime AS ime_prezime_zaposlenika, COUNT(S.id) AS broj_slucajeva
	FROM Zaposlenik Z
	JOIN Osoba O ON Z.id_osoba= O.id
	LEFT JOIN Slucaj S ON S.id_voditelj = Z.id
	GROUP BY Z.id, o.ime_prezime
	HAVING COUNT(S.id) =
		(SELECT MAX(broj_slucajeva)
    			FROM (
        			SELECT COUNT(id) AS broj_slucajeva
        				FROM Slucaj - smijem li i ovdje S umjesto Slucaj?
        				GROUP BY id_voditelj
    		) AS max_voditelj
	);


# 17. Ispiši sva mjesta gdje nema evidentiranih kaznjivih djela u slučajevima(ili uopće nema slučajeva)

SELECT M.id, M.naziv
	FROM Mjesto M
	LEFT JOIN Evidencija_dogadaja ED ON M.id = ED.id_mjesto
	LEFT JOIN Slucaj S ON ED.id_slucaj= S.id
	LEFT JOIN Kaznjiva_djela_u_slucaju KDS ON S.id = KDS.id_slucaj
	WHERE KDS.id_slucaj IS NULL OR KDS.id_kaznjivo_djelo IS NULL
	GROUP BY M.id, M.naziv;
#########################################################################################################################################
# POGLEDI
# 1. Ako je uz osumnjičenika povezano vozilo, onda se stvara materijalizirani pogled koji prati sve osumnjičenike i njihova vozila
CREATE VIEW osumnjicenici_vozila AS
SELECT
	Osoba.id AS id_osobe,
	Osoba.ime_prezime,
	Osoba.datum_rodenja,
	Osoba.oib,
	Osoba.spol,
	Osoba.adresa,
	Osoba.telefon,
	Osoba.email,
	Vozilo.id AS id_vozila,
	Vozilo.marka,
	Vozilo.model,
	Vozilo.registracija,
	Vozilo.godina_proizvodnje
FROM Osoba
LEFT JOIN Vozilo ON Osoba.id = Vozilo.id_vlasnik
INNER JOIN Slucaj ON Osoba.id = Slucaj.id_pocinitelj;
# 2. Pronađi sve policajce koji su vlasnici vozila koja su starija od 10 godina
CREATE VIEW PolicajciSaStarimVozilima AS
SELECT O.Ime_Prezime AS Policajac, V.Marka, V.Model, V.Godina_proizvodnje
FROM Osoba O
JOIN Zaposlenik Z ON O.Id = Z.id_osoba
JOIN Vozilo V ON O.Id = V.id_vlasnik
WHERE Z.id_radno_mjesto= (SELECT Id FROM Radno_mjesto WHERE Vrsta = 'Policajac')
AND V.Godina_proizvodnje <= YEAR(NOW()) - 10;

# 3. Napravi pogled koji će pronaći sve osobe koje su počinile kazneno djelo pljačke i pri tome su koristili pištolj (to dohvati pomoću tablice predmet) i nazovi pogled "Počinitelji oružane pljačke"
CREATE VIEW PočiniteljiOružanePljačke AS
SELECT O.Ime_Prezime AS Počinitelj, K.Naziv AS KaznenoDjelo
FROM Osoba O
JOIN Slucaj S ON O.Id = S.id_pocinitelj
JOIN Kaznjiva_Djela_u_Slucaju KD ON S.Id = KD.id_slucaj
JOIN Kaznjiva_Djela K ON KD.id_kaznjivo_djelo	= K.ID
JOIN Predmet P ON S.id_dokaz= P.Id
WHERE K.Naziv = 'Pljačka' AND P.Naziv LIKE '%pištolj%';


# 4. Napravi pogled koji će izlistati sva evidentirana kaznena djela i njihov postotak pojavljivanja u slučajevima
CREATE VIEW PostotakPojavljivanjaKaznenihDjela AS
SELECT
    KD.Naziv AS 'Kazneno_Djelo',
    COUNT(KS.id_slucaj) AS 'Broj_Slucajeva',
    COUNT(KS.id_slucaj) / (SELECT COUNT(*) FROM Slucaj) * 100 AS 'Postotak_Pojavljivanja'
FROM
    Kaznjiva_Djela KD
LEFT JOIN
    Kaznjiva_Djela_u_Slucaju KS
ON
    KD.ID = KS.id_kaznjivo_djelo
GROUP BY
    KD.Naziv;

# 5. Napravi pogled koji će izlistati sva evidentirana sredstva utvrđivanja istine i broj slučajeva u kojima je svako od njih korišteno
CREATE VIEW EvidentiranaSredstvaUtvrdivanjaIstine AS
SELECT Sredstvo_utvrdivanja_istine.Naziv AS 'SredstvoUtvrdivanjaIstine',
       COUNT(Sui_slucaj.Id_sui) AS 'BrojSlucajeva'
FROM Sredstvo_utvrdivanja_istine
LEFT JOIN Sui_slucaj ON Sredstvo_utvrdivanja_istine.Id = Sui_slucaj.Id_sui
GROUP BY Sredstvo_utvrdivanja_istine.Id;


# 6. Napravi pogled koji će izlistati sve slučajeve i sredstva utvrđivanja istine u njima, te izračunati trajanje svakog od slučajeva

CREATE VIEW SlucajeviSortiraniPoTrajanjuISredstva AS
SELECT S.*, 
       TIMESTAMPDIFF(DAY, S.Pocetak, S.Zavrsetak) AS Trajanje_u_danima, 
       GROUP_CONCAT(SUI.Naziv ORDER BY SUI.Naziv ASC SEPARATOR ', ') AS SredstvaUtvrdivanjaIstine
FROM Slucaj S
LEFT JOIN Sui_slucaj SUI_S ON S.ID = SUI_S.Id_slucaj
LEFT JOIN Sredstvo_utvrdivanja_istine SUI ON SUI_S.Id_sui = SUI.ID
GROUP BY S.ID
ORDER BY Trajanje_u_danima DESC;

# 7. Napiši pogled koji će u jednu tablicu pohraniti sve izvještaje vezane uz pojedine slučajeve
CREATE VIEW IzvjestajiZaSlucajeve AS
SELECT S.Naziv AS Slucaj, I.Naslov AS NaslovIzvjestaja, I.Sadrzaj AS SadržajIzvjestaja, O.Ime_Prezime AS AutorIzvjestaja
FROM Izvjestaji I
INNER JOIN Slucaj S ON I.id_slucaj	 = S.ID
INNER JOIN Osoba O ON I.id_autor	= O.Id;

# 8. Napravi pogled koji će izlistati sve osobe i njihove odjele. Ukoliko osoba nije policajac te nema odjel (odjel je NULL), neka se uz tu osobu napiše "Osoba nije policijski službenik"
CREATE VIEW OsobeIOdjeli AS
SELECT O.Ime_Prezime AS ImeOsobe,
       CASE
           WHEN Z.id_radno_mjesto
           IS NOT NULL THEN OD.Naziv
           ELSE 'Osoba nije policijski službenik'
       END AS NazivOdjela
FROM Osoba O
LEFT JOIN Zaposlenik Z ON O.Id = Z.id_osoba
LEFT JOIN Odjeli OD ON Z.id_odjel= OD.Id;


# 9. Napravi pogled koji će ispisati sve voditelje slučajeva, ukupan broj slučajeva koje vode, ukupan broj rješenjih slučajeva, ukupan broj nerješenih slučajeva i postotak rješenosti
CREATE VIEW VoditeljiSlucajeviPregled AS
SELECT
    O.Ime_Prezime AS Voditelj,
    COUNT(S.ID) AS UkupanBrojSlucajeva,
    SUM(CASE WHEN S.Status = 'Završeno' THEN 1 ELSE 0 END) AS UkupanBrojRijesenihSlucajeva,
    SUM(CASE WHEN S.Status = 'Aktivan' THEN 1 ELSE 0 END) AS UkupanBrojNerijesenihSlucajeva,
    (SUM(CASE WHEN S.Status = 'Završeno' THEN 1 ELSE 0 END) / COUNT(S.ID)) * 100 AS PostotakRjesenosti
FROM
    Osoba O
LEFT JOIN
    Slucaj S ON O.ID = S.id_voditelj
GROUP BY
    Voditelj; # grupiramo po aliasu

# 10. Napravi POGLED koji će prikazivati statistiku zapljena za svaku vrstu kaznenog djela (prosjek, minimum, maksimum  (za vrijednosti) i broj predmeta)
CREATE VIEW StatistikaZapljenaPoKaznenomDjelu AS
SELECT
    K.Naziv AS 'Vrsta_kaznenog_djela',
    AVG(Z.Vrijednost) AS 'Prosječna_vrijednost_zapljena',
    MAX(Z.Vrijednost) AS 'Najveća_vrijednost_zapljena',
    MIN(Z.Vrijednost) AS 'Najmanja_vrijednost_zapljena',
    COUNT(Z.ID) AS 'Broj_zapljenjenih_predmeta'
FROM Zapljene Z
JOIN Slucaj S ON Z.id_slucaj	 = S.ID
JOIN Kaznjiva_Djela_u_Slucaju KDUS ON S.ID = KDUS.id_slucaj
JOIN Kaznjiva_Djela K ON KDUS.id_kaznjivo_djelo = K.id
GROUP BY K.Naziv;


SELECT * From StatistikaZapljenaPoKaznenomDjelu;
DROP VIEW StatistikaZapljenaPoKaznenomDjelu;

# 11. Napravi POGLED koji će za svaki slučaj izračunati ukupnu zatvorsku kaznu, uz ograničenje da maksimalna zakonska zatvorska kazna u RH iznosi 50 godina. Ako ukupna kazna premaši 50, postaviti će se na 50 uz odgovarajuće upozorenje
CREATE VIEW UkupnaPredvidenaKaznaPoSlucaju AS
SELECT S.ID AS 'SlucajID',
       S.Naziv AS 'NazivSlucaja',
       CASE
           WHEN SUM(KD.Predvidena_kazna) > 50 THEN 50
           ELSE SUM(KD.Predvidena_kazna)
       END AS 'UkupnaPredvidenaKazna',
       CASE
           WHEN SUM(KD.Predvidena_kazna) > 50 THEN 'Maksimalna zakonska zatvorska kazna iznosi 50 godina'
           ELSE NULL
       END AS 'Napomena'
FROM Slucaj S
LEFT JOIN Kaznjiva_Djela_u_Slucaju KDUS ON S.ID = KDUS.id_slucaj
LEFT JOIN Kaznjiva_Djela KD ON KDUS.id_kaznjivo_djelo		= KD.ID
GROUP BY S.ID, S.Naziv;

# 12. Napiši POGLED koji će za sve policijske službenike dohvatiti njihovu dob i godine staža (ukoliko je još aktivan, oduzimat ćemo od trenutne godine godinu zaposlenja, a ako je umirovljen, oduzimat će od godine umirovljenja godinu zaposlenja)
# Onda dodat još stupac koji prati dali je umirovljen ili aktivan
CREATE VIEW Pogled_Policijskih_Sluzbenika AS
SELECT
    o.Id AS Zaposlenik_Id,
    o.Ime_Prezime AS Ime_Prezime,
    o.Datum_rodenja AS Datum_rodenja,
    DATEDIFF(CURRENT_DATE, z.Datum_zaposlenja) AS Godine_Staza,
    CASE
        WHEN z.Datum_izlaska_iz_sluzbe IS NOT NULL AND z.Datum_izlaska_iz_sluzbe <= CURRENT_DATE THEN 'Da'
        ELSE 'Ne'
    END AS Umirovljen
FROM Osoba o
INNER JOIN Zaposlenik z ON o.Id = z.id_osoba;

# 13. Napravi pogled koji će dohvaćati sve osumnjičenike, zajedno s kažnjivim djelima za koja su osumnjičeni
CREATE VIEW Pogled_Osumnjicene_Osobe_KD AS
SELECT DISTINCT O.Ime_Prezime, K.Naziv AS 'Naziv kaznenog djela'
FROM Osoba O
JOIN Slucaj S ON O.Id = S.id_pocinitelj
JOIN Kaznjiva_djela_u_slucaju KD ON S.Id = KD.id_slucaj
JOIN Kaznjiva_djela K ON KD.id_kaznjivo_djelo = K.id;

# 14. Napravi pogled koji će izlistati sve pse i broj slučajeva na kojima je svaki od njih radio. U poseban stupac dodaj broj riješenih slučajeva od onih na kojima su radili. Zatim izračunaj postotak rješenosti slučajeva za svakog psa i to dodaj u novi stupac
CREATE VIEW Pregled_Pasa AS
SELECT
    P.Id AS PasID,
    P.Oznaka AS OznakaPsa,
    O.Ime_Prezime AS Vlasnik,
    COUNT(S.Id) AS BrojSlucajeva,
    SUM(CASE WHEN S.Status = 'Završeno' THEN 1 ELSE 0 END) AS BrojRijesenih,
    (SUM(CASE WHEN S.Status = 'Završeno' THEN 1 ELSE 0 END) / COUNT(S.Id) * 100) AS PostotakRjesenosti
FROM
    Pas AS P
LEFT JOIN Slucaj AS S ON P.Id = S.id_pas
LEFT JOIN Osoba AS O ON P.Id_trener = O.Id
GROUP BY
    P.Id;

# 15. Nadogradi prethodni POGLED tako da pronalazi najefikasnijeg psa, s najvećim postotkom rješenosti
CREATE VIEW NajefikasnijiPas AS
SELECT
    PasID,
    OznakaPsa,
    Vlasnik,
    BrojSlucajeva,
    BrojRijesenih,
    PostotakRjesenosti
FROM
    Pregled_Pasa
WHERE
    PostotakRjesenosti = (SELECT MAX(PostotakRjesenosti) FROM Pregled_Pasa);

-- 16. Napravi pogled koji prikazuje broj kazni zboog brze vožnje u svakom gradu u proteklih mjesec dana. Zatim pomoću upita ispiši grad
-- u kojem je bilo najviše kazni zbog brze vožnje u proteklih mjesec dana.

CREATE VIEW brza_voznja_gradovi AS
SELECT mjesto.naziv, COUNT(*) AS broj_kazni_za_brzu_voznju
FROM mjesto INNER JOIN evidencija_dogadaja ON mjesto.id=evidencija_dogadaja.id_mjesto INNER JOIN slucaj ON evidencija_dogadaja.id_slucaj=slucaj.id
WHERE slucaj.naziv LIKE '%brza voznja%' AND evidencija_dogadaja.datum_vrijeme >= (NOW() - INTERVAL 1 MONTH)
GROUP BY mjesto.naziv;

SELECT *
FROM brza_voznja_gradovi
ORDER BY broj_kazni_za_brzu_voznju DESC
LIMIT 1; 

-- 17. Napravi pogled koji prikazuje sve osobe koje su skrivile više od 2 prometne nesreće u posljednjih godinu dana. 
-- Zatim napravi upit koji će prikazati osobu koja je skrivila najviše prometnih nesreća u posljednjih godinu dana.

CREATE VIEW osoba_prometna_nesreca AS
SELECT osoba.*, COUNT(*) AS broj_prometnih_nesreca
FROM osoba INNER JOIN slucaj ON osoba.id=slucaj.id_pocinitelj INNER JOIN evidencija_dodagaja ON slucaj.id=evidencija_dogadaja.id_slucaj
WHERE evidencija_dogadaja.datum_vrijeme >= (NOW() - INTERVAL 1 YEAR) AND COUNT(*)>2 AND slucaj.naziv LIKE '%prometna nesreca%'
GROUP BY id_osoba;

SELECT *
FROM osoba_prometna_nesreca
ORDER BY broj_prometnih_nesreca DESC
LIMIT 1;


# 18. Napravi pogled koji će pronaći sva kažnjiva djela koja su se događala u slučajevima
# Zatim napravi upit kojim ćemo moći pronalaziti kažnjiva djela za određeno mjesto po id-ju
CREATE VIEW Kaznjiva_Djela_Na_Mjestu AS
SELECT K.Naziv, K.Opis
FROM Kaznjiva_Djela_u_Slucaju KS
JOIN Kaznjiva_Djela K ON KS.id_kaznjivo_djelo = K.ID
JOIN Evidencija_Dogadaja ED ON KS.id_slucaj = ED.id_slucaj;

SELECT * FROM Kaznjiva_Djela_Na_Mjestu WHERE ED.id_mjesto = 1;

# 19. Napravi pogled koji će dohvatiti sve osobe, slučajeve koje su počinili i KD u njima
CREATE VIEW Osobe_i_KD AS
SELECT DISTINCT O.Ime_Prezime
FROM Osoba O
JOIN Slucaj S ON O.Id = S.id_pocinitelj
JOIN Kaznjiva_djela_u_slucaju KD ON S.Id = KD.id_slucaj
JOIN Kaznjiva_djela K ON KD.id_kaznjivo_djelo = K.id



# 20. Napravi pogled koji će ispisati sve slučajeve i evidentirane događaje za osobe.
# Podaci će se zatim moći filtrirati (npr. po imenu i prezimenu)
# Ispišimo slučajeve i evidencije za određenu osobu (osumnjičenika)

CREATE VIEW SD_osoba AS
SELECT S.Naziv AS 'Naziv slučaja', ED.opis_dogadaja, ED.datum_vrijeme, ED.id_mjesto, O.Ime_Prezime
FROM Slucaj S
JOIN Evidencija_dogadaja ED ON S.Id = ED.id_slucaj
JOIN Osoba O ON O.Id = S.id_pocinitelj;

SELECT * FROM SD_osoba WHERE O.Ime_Prezime = 'Pero Perić';

# 21. Napravi pogled koji će dohvaćati sve događaje koji su vezani za slučajeve koji sadrže određeno kažnjivo djelo
CREATE VIEW Dogadaji_KD AS
SELECT E.Opis_Dogadaja, E.Datum_Vrijeme, K.Naziv AS 'Naziv kaznjivog djela'
FROM Evidencija_Dogadaja E
JOIN Slucaj S ON E.id_slucaj = S.Id
JOIN Kaznjiva_Djela_u_Slucaju KS ON S.Id = KS.id_slucaj
JOIN Kaznjiva_Djela K ON KS.id_kaznjivo_djelo = K.Id;

SELECT * FROM Dogadaji_KD WHERE 'Naziv kaznjivog djela' = 'Ubojstvo'

##############################################################################################################################################
# PROCEDURE
# 1. Napiši proceduru za unos novog područja uprave
DELIMITER //

CREATE PROCEDURE Dodaj_Novo_Podrucje_Uprave(IN p_naziv VARCHAR(255))
BEGIN
    INSERT INTO Podrucje_uprave (naziv) VALUES (p_naziv);
END //

DELIMITER ;

# 2. Napiši proceduru za unos novog mjesta
DELIMITER //

CREATE PROCEDURE Dodaj_Novo_Mjesto(
    IN p_naziv VARCHAR(255),
    IN p_id_podrucje_uprave INT
)
BEGIN
    INSERT INTO Mjesto (naziv, id_podrucje_uprave) VALUES (p_naziv, p_id_podrucje_uprave);
END //

DELIMITER ;

# 3. Napiši proceduru za unos nove zgrade
DELIMITER //

CREATE PROCEDURE Dodaj_Novu_Zgradu(
    IN p_adresa VARCHAR(255),
    IN p_vrsta_zgrade VARCHAR(30),
    IN p_id_mjesto INT
)
BEGIN
    INSERT INTO Zgrada (adresa, vrsta_zgrade, id_mjesto) VALUES (p_adresa, p_vrsta_zgrade, p_id_mjesto);
END //

DELIMITER ;

# 4. Napiši proceduru za unos novog radnog mjesta
DELIMITER //

CREATE PROCEDURE Dodaj_Novo_Radno_Mjesto(
    IN p_vrsta VARCHAR(255),
    IN p_dodatne_informacije TEXT
)
BEGIN
    INSERT INTO Radno_mjesto (vrsta, dodatne_informacije) VALUES (p_vrsta, p_dodatne_informacije);
END //

DELIMITER ;

# 5. Napiši proceduru za unos novog odjela
DELIMITER //

CREATE PROCEDURE Dodaj_Novi_Odjel(
    IN p_naziv VARCHAR(255),
    IN p_opis TEXT
)
BEGIN
    INSERT INTO Odjeli (naziv, opis) VALUES (p_naziv, p_opis);
END //

DELIMITER ;

# 6. Napiši proceduru za unos nove osobe
DELIMITER //

CREATE PROCEDURE Dodaj_Novu_Osobu(
    IN p_ime_prezime VARCHAR(255),
    IN p_datum_rodenja DATE,
    IN p_oib CHAR(11),
    IN p_spol VARCHAR(10),
    IN p_adresa VARCHAR(255),
    IN p_fotografija BLOB,
    IN p_telefon VARCHAR(20),
    IN p_email VARCHAR(255)
)
BEGIN
    INSERT INTO Osoba (ime_prezime, datum_rodenja, oib, spol, adresa, fotografija, telefon, email)
    VALUES (p_ime_prezime, p_datum_rodenja, p_oib, p_spol, p_adresa, p_fotografija, p_telefon, p_email);
END //

DELIMITER ;

# 7. Procedura za unos novog zaposlenika
DELIMITER //

CREATE PROCEDURE Dodaj_Novog_Zaposlenika(
    IN p_datum_zaposlenja DATETIME,
    IN p_id_nadređeni INT,
    IN p_id_radno_mjesto INT,
    IN p_id_odjel INT,
    IN p_id_zgrada INT,
    IN p_id_mjesto INT,
    IN p_id_osoba INT
)
BEGIN
    INSERT INTO Zaposlenik (datum_zaposlenja, id_nadređeni, id_radno_mjesto, id_odjel, id_zgrada, id_mjesto, id_osoba)
    VALUES (p_datum_zaposlenja, p_id_nadređeni, p_id_radno_mjesto, p_id_odjel, p_id_zgrada, p_id_mjesto, p_id_osoba);
END //

DELIMITER ;

# 8. Procedura za unos novog vozila
DELIMITER //

CREATE PROCEDURE Dodaj_Novo_Vozilo(
    IN p_marka VARCHAR(255),
    IN p_model VARCHAR(255),
    IN p_registracija VARCHAR(20),
    IN p_godina_proizvodnje INT,
    IN p_tip_vozila INT, -- 1 za službeno, 0 za privatno
    IN p_id_vlasnik INT
)
BEGIN
    DECLARE v_vlasnik VARCHAR(255);
    
    IF p_tip_vozila = 1 THEN
        SET v_vlasnik = 'Ministarstvo unutarnjih poslova';
    ELSE
        -- Ako nije službeno vozilo, koristimo predani ID vlasnika
        SELECT ime_prezime INTO v_vlasnik FROM Osoba WHERE id = p_id_vlasnik;
    END IF;
    
    INSERT INTO Vozilo (marka, model, registracija, godina_proizvodnje, sluzbeno_vozilo, id_vlasnik)
    VALUES (p_marka, p_model, p_registracija, p_godina_proizvodnje, p_tip_vozila, v_vlasnik);
END //

DELIMITER ;

# 9. Napiši proceduru za dodavanje novog predmeta
DELIMITER //

CREATE PROCEDURE Dodaj_Novi_Predmet(
    IN p_naziv VARCHAR(255),
    IN p_id_mjesto_pronalaska INT
)
BEGIN
    -- Unos novog predmeta
    INSERT INTO Predmet (naziv, id_mjesto_pronalaska)
    VALUES (p_naziv, p_id_mjesto_pronalaska);
END //

DELIMITER ;

# 10. Napiši proceduru za dodavanje novog kaznjivog djela u bazu
DELIMITER //

CREATE PROCEDURE Dodaj_Novo_Kaznjivo_Djelo(
    IN p_naziv VARCHAR(255),
    IN p_opis TEXT,
    IN p_predvidena_kazna INT
)
BEGIN
    -- Unos novog kaznjivog djela
    INSERT INTO Kaznjiva_djela (naziv, opis, predvidena_kazna)
    VALUES (p_naziv, p_opis, p_predvidena_kazna);
END //

DELIMITER ;

# 11. Napiši proceduru za dodavanje novog psa
DELIMITER //

CREATE PROCEDURE Dodaj_Novog_Psa(
    IN p_id_trener INTEGER,
    IN p_oznaka VARCHAR(255),
    IN p_godina_rođenja INTEGER,
    IN p_status VARCHAR(255),
    IN p_id_kaznjivo_djelo INTEGER
)
BEGIN
    -- Unos novog psa
    INSERT INTO Pas (id_trener, oznaka, godina_rođenja, status, id_kaznjivo_djelo)
    VALUES (p_id_trener, p_oznaka, p_godina_rođenja, p_status, p_id_kaznjivo_djelo);
END //

DELIMITER ;

# 12. Napiši proceduru za dodavanje novog slučaja, ali neka se ukupna vrijednost zapljena i dalje računa automatski preko trigera
DELIMITER //

CREATE PROCEDURE Dodaj_Novi_Slucaj(
    IN p_naziv VARCHAR(255),
    IN p_opis TEXT,
    IN p_pocetak DATETIME,
    IN p_zavrsetak DATETIME,
    IN p_status VARCHAR(20),
    IN p_id_pocinitelj INT,
    IN p_id_izvjestitelj INT,
    IN p_id_voditelj INT,
    IN p_id_dokaz INT,
    IN p_id_pas INT,
    IN p_id_svjedok INT
)
BEGIN
    -- Unos novog slučaja
    INSERT INTO Slucaj (naziv, opis, pocetak, zavrsetak, status, id_pocinitelj, id_izvjestitelj, id_voditelj, id_dokaz, id_pas, id_svjedok)
    VALUES (p_naziv, p_opis, p_pocetak, p_zavrsetak, p_status, p_id_pocinitelj, p_id_izvjestitelj, p_id_voditelj, p_id_dokaz, p_id_pas, p_id_svjedok);
END //

DELIMITER ;

# 13. Napravi proceduru koja će dodati novi događaj
DELIMITER //

CREATE PROCEDURE Dodaj_događaj_u_evidenciju(
    IN p_slucaj_id INT,
    IN p_opis_dogadaja TEXT,
    IN p_datum_vrijeme DATETIME,
    IN p_mjesto_id INT
)
BEGIN
    INSERT INTO Evidencija_dogadaja (id_slucaj, opis_dogadaja, datum_vrijeme, id_mjesto)
    VALUES (p_slucaj_id, p_opis_dogadaja, p_datum_vrijeme, p_mjesto_id);
END //

DELIMITER ;

# 14. Napiši proceduru koja će dodavati kažnjiva djela u slučaju
DELIMITER //

CREATE PROCEDURE Dodaj_Kaznjivo_Djelo_U_Slucaju(
    IN p_slucaj_id INT,
    IN p_kaznjivo_djelo_id INT
)
BEGIN
    INSERT INTO Kaznjiva_djela_u_slucaju (id_slucaj, id_kaznjivo_djelo)
    VALUES (p_slucaj_id, p_kaznjivo_djelo_id);
END //

DELIMITER ;


DELIMITER //

# 15. Napiši proceduru za dodavanje izvještaja
CREATE PROCEDURE Dodaj_Izvjestaj(
    IN p_naslov VARCHAR(255),
    IN p_sadrzaj TEXT,
    IN p_autor_id INT,
    IN p_slucaj_id INT
)
BEGIN
    INSERT INTO Izvjestaji (naslov, sadrzaj, id_autor, id_slucaj)
    VALUES (p_naslov, p_sadrzaj, p_autor_id, p_slucaj_id);
END //

DELIMITER ;

# 16. Napiši proceduru za dodavanje zapljena
DELIMITER //

CREATE PROCEDURE Dodaj_Zapljene(
    IN p_opis TEXT,
    IN p_slucaj_id INT,
    IN p_predmet_id INT,
    IN p_vrijednost NUMERIC(5,2)
)
BEGIN
    INSERT INTO Zapljene (opis, id_slucaj, id_predmet, Vrijednost)
    VALUES (p_opis, p_slucaj_id, p_predmet_id, p_vrijednost);
END //

DELIMITER ;


# 17. Napiši proceduru za dodavanje sredstva utvrđivanja istine
DELIMITER //

CREATE PROCEDURE Dodaj_Sredstvo_Utvrđivanja_Istine(
    IN p_naziv VARCHAR(100)
)
BEGIN
    INSERT INTO Sredstvo_utvrdivanja_istine (naziv)
    VALUES (p_naziv);
END //

DELIMITER ;

# 18. Napiši proceduru za dodavanje SUI slučaj
DELIMITER //

CREATE PROCEDURE Dodaj_Sui_Slucaj(
    IN p_id_sui INT,
    IN p_id_slucaj INT
)
BEGIN
    INSERT INTO Sui_slucaj (id_sui, id_slucaj)
    VALUES (p_id_sui, p_id_slucaj);
END //

DELIMITER ;

# 19. Napiši proceduru koja će svim zatvorenicima koji su još u zatvoru (datum odlaska iz zgrade zatvora im je NULL) dodati novi stupac sa brojem dana u zatvoru koji će dobiti tako da računa broj dana o dana dolaska u zgradu do današnjeg dana
# Ubacit scheduled dnevno izvođenje procedure
DELIMITER //

CREATE PROCEDURE DodajBrojDanaUZatvoru()
BEGIN
    -- Provjerimo postojanje stupaca prije dodavanja(da ne dodajemo dva puta isti stupac)
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'Osoba' AND COLUMN_NAME = 'id_zgrada'
    ) THEN
        -- Dodamo stupac id_zgrada u tablicu Osoba jer je poželjno da za osobu koja je u zatvoru znamo di se nalazi
        ALTER TABLE Osoba
        ADD COLUMN id_zgrada INT;
    END IF;
    
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'Osoba' AND COLUMN_NAME = 'Broj_dana_u_zatvoru'
    ) THEN
        -- Dodamo stupac Broj_dana_u_zatvoru u tablicu Osoba
        ALTER TABLE Osoba
        ADD COLUMN Broj_dana_u_zatvoru INT;
    END IF;

    -- Postavimo done na 0
    DECLARE done INT DEFAULT 0;
    DECLARE osoba_id INT;
    DECLARE datum_zavrsetka_slucaja DATETIME;
    DECLARE danas DATETIME;
    DECLARE vrsta_zgrade VARCHAR(255);
    DECLARE osoba_id_zgrada INT;

    -- Deklariramo kursor
    DECLARE cur CURSOR FOR
    SELECT O.Id, S.zavrsetak, Z.vrsta_zgrade, S.id_zgrada
    FROM Osoba O
    JOIN Slucaj S ON O.id = S.id_pocinitelj
    JOIN Zgrada Z ON S.id_zgrada = Z.Id;

    -- Postavimo handler za kraj
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Otvorimo kursor
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO osoba_id, datum_zavrsetka_slucaja, vrsta_zgrade, osoba_id_zgrada;

        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        -- Dodamo provjeru vrste zgrade i provjeru je li datum zavrsetka_slucaja null
        IF vrsta_zgrade = 'Zatvor' AND datum_zavrsetka_slucaja IS NOT NULL THEN -- ako datum završetka nije NULL, znači da je gotov slučaj
            SET danas = NOW();
            SET @broj_dana_u_zatvoru = DATEDIFF(danas, datum_zavrsetka_slucaja);

            -- Ažuriramo stupac Broj_dana_u_zatvoru
            UPDATE Osoba
            SET Broj_dana_u_zatvoru = @broj_dana_u_zatvoru,
                id_zgrada = osoba_id_zgrada
            WHERE Id = osoba_id;
        END IF;
    END LOOP;

    -- Zatvorimo kursor
    CLOSE cur;

END //

DELIMITER ;
# EVENT 1
DELIMITER //

CREATE EVENT IF NOT EXISTS `BrojDanaUZatvoruEvent`
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    CALL DodajBrojDanaUZatvoru();
END //

DELIMITER ;

    # 20. Napiši proceduru koja će omogućiti da pretražujemo slučajeve preko neke ključne riječi iz opisa
DELIMITER //
CREATE PROCEDURE PretraziSlucajevePoOpisu(IN kljucnaRijec TEXT)
BEGIN
    SELECT * FROM Slucaj WHERE Opis LIKE CONCAT('%', kljucnaRijec, '%');
END //
DELIMITER ;

# 21. Napiši proceduru koja će kreirati novu privremenu tablicu u kojoj će se prikazati svi psi i broj slučajeva na kojima su radili. Zatim će dodati novi stupac tablici pas i u njega upisati "nagrađeni pas" kod svih pasa koji su radili na više od 15 slučajeva 
DELIMITER //
CREATE PROCEDURE Godisnje_nagrađivanje_pasa()
BEGIN
    
    CREATE TEMPORARY TABLE Temp_Psi (id_pas	INT, BrojSlucajeva INT);

    
    INSERT INTO Temp_Psi (id_pas, BrojSlucajeva)
    SELECT id_pas, COUNT(*) AS BrojSlucajeva
    FROM Slucaj
    GROUP BY id_pas;
    
    UPDATE Pas
    SET Status = 'nagrađeni pas'
    WHERE Id IN (SELECT	id_pas  FROM Temp_Psi WHERE BrojSlucajeva > 15);
    
    
    DROP TEMPORARY TABLE Temp_Psi;
END //
DELIMITER ;

# 22. Napiši proceduru koja će generirati izvještaje o slučajevima u zadnjih 20 dana (ovaj broj se može prilagođavati)
DELIMITER //
CREATE PROCEDURE GenerirajIzvjestajeOSlučajevima()
BEGIN
    DECLARE DatumPocetka DATE;
    DECLARE DatumZavrsetka DATE;
    
    -- Postavimo početni i završni datum za analizu (npr. 20 dana, ali moremo izmjenit)
    SET DatumPocetka = CURDATE() - INTERVAL 20 DAY;
    SET DatumZavrsetka = CURDATE();
    
    CREATE TEMPORARY TABLE TempIzvjestaji (
        SlucajID INT,
        NazivSlucaja VARCHAR(255),
        Pocetak DATE,
        Zavrsetak DATE,
        Status VARCHAR(50)
    );

    
    INSERT INTO TempIzvjestaji (SlucajID, NazivSlucaja, Pocetak, Zavrsetak, Status)
    SELECT S.ID, S.Naziv, S.Pocetak, S.Zavrsetak, S.Status
    FROM Slucaj S
    WHERE S.Pocetak BETWEEN DatumPocetka AND DatumZavrsetka;
    
    
    SELECT * FROM TempIzvjestaji;
    
    
    DROP TEMPORARY TABLE TempIzvjestaji;
END;
//
DELIMITER ;

# 23. Napiši proceduru koja će za određenu osobu kreirati potvrdu o nekažnjavanju. To će napraviti samo u slučaju da osoba stvarno nije evidentirana niti u jednom slučaju kao počinitelj. Ukoliko je osoba kažnjavana i za to ćemo dobiti odgovarajuću obavijest. Također,ako uspješno izdamo potvrdu, neka se prikaže i datum izdavanja
DELIMITER //

CREATE PROCEDURE ProvjeriNekažnjavanje(IN osoba_id INT)
BEGIN
    DECLARE počinitelj_count INT;
    DECLARE osoba_ime_prezime VARCHAR(255);
    DECLARE obavijest VARCHAR(255);
    DECLARE izdavanje_datum DATETIME;

    SET izdavanje_datum = NOW();

    SELECT Ime_Prezime INTO osoba_ime_prezime FROM Osoba WHERE Id = osoba_id;

    SELECT COUNT(*) INTO počinitelj_count
    FROM Slucaj
    WHERE id_pocinitelj	= osoba_id;

    IF počinitelj_count > 0 THEN
        SET obavijest = 'Osoba je kažnjavana';
        SELECT obavijest AS Poruka;
    ELSE
        INSERT INTO Izvjestaji (Naslov, Sadržaj, id_autor, id_slucaj)
        VALUES ('Potvrda o nekažnjavanju', CONCAT('Osoba ', osoba_ime_prezime, ' nije kažnjavana. Izdana ', DATE_FORMAT(izdavanje_datum, '%d-%m-%Y %H:%i:%s')), osoba_id, NULL);
        SELECT CONCAT('Potvrda za ', osoba_ime_prezime) AS Poruka;
    END IF;
END //

DELIMITER ;

# 24. Napiši proceduru koja će omogućiti da za određenu osobu izmjenimo kontakt informacije (email i/ili broj telefona)
DELIMITER //

CREATE PROCEDURE IzmjeniKontaktInformacije(
    IN id_osoba INT,
    IN novi_email VARCHAR(255),
    IN novi_telefon VARCHAR(20)
)
BEGIN
    DECLARE br_osoba INT;
    SELECT COUNT(*) INTO br_osoba FROM Osoba WHERE Id = id_osoba;
    
    IF br_osoba > 0 THEN
        UPDATE Osoba
        SET Email = novi_email, Telefon = novi_telefon
        WHERE Id = id_osoba;
        
        SELECT 'Kontakt informacije su uspješno izmijenjene' AS Poruka;
    ELSE
        SELECT 'Osoba s navedenim ID-jem ne postoji' AS Poruka;
    END IF;
END //

DELIMITER ;

# 25. Napiši proceduru koja će za određeni slučaj izlistati sve događaje koji su se u njemu dogodili i poredati ih kronološki
DELIMITER //

CREATE PROCEDURE Izlistaj_dogadjaje(IN id_slucaj INT)
BEGIN
    SELECT ed.Id, ed.opis_dogadaja,ed.datum_vrijeme
    FROM Evidencija_dogadaja	AS ed
    WHERE ed.id_slucaj = id_slucaj
    ORDER BY ed.Datum_Vrijeme;
END //

DELIMITER ;
#CALL Izlistaj_dogadjaje(10);
# 26. Napiši PROCEDURU KOJA ZA ARGUMENT PRIMA OZNAKU PSA, A VRAĆA ID, IME i PREZIME VLASNIKA i BROJ SLUČAJEVA U KOJIMA JE PAS SUDJELOVAO
DELIMITER //
CREATE PROCEDURE Info_pas(IN Oznaka VARCHAR(255))
BEGIN
    SELECT
        O.Id AS Vlasnik_id,
        O.Ime_Prezime AS Trener,
        COUNT(S.Id) AS BrojSlucajeva
    FROM
        Pas AS P
    INNER JOIN Slucaj AS S ON P.Id = S.id_pas
    INNER JOIN Osoba AS O ON P.Id_trener = O.Id
    WHERE
        P.Oznaka = Oznaka
    GROUP BY
        P.Id;
END
//
DELIMITER ;

# 27. Napiši proceduru koja će za određeno KD moći smanjiti ili povećati predviđenu kaznu tako što će za argument primiti naziv KD i broj godina za koji želimo izmjeniti kaznu
# Ako želimo smanjiti kaznu, za argument ćemo prosljediti negativan broj
DELIMITER //
CREATE PROCEDURE izmjeni_kaznu(IN naziv_djela VARCHAR(255), IN iznos INT)
BEGIN
    DECLARE kazna INT;
    
    SELECT predvidena_kazna INTO kazna
    FROM Kaznjiva_djela
    WHERE naziv = naziv_djela;
    
    IF kazna IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Traženo KD ne postoji u bazi';
    END IF;
    
    SET kazna = kazna + iznos;
    
    UPDATE Kaznjiva_djela
    SET predvidena_kazna = kazna
    WHERE naziv = naziv_djela;
END //
DELIMITER ;

#28. Napiši proceduru koja će dohvaćati slučajeve koji sadrže određeno kazneno djelo i sortirati ih po vrijednosti zapljene silazno
DELIMITER //
CREATE PROCEDURE Dohvati_Slucajeve_Po_Kaznenom_Djelu_Sortirano(kaznenoDjeloNaziv VARCHAR(255))
BEGIN
    DECLARE slucaj_id INT;
    DECLARE slucaj_naziv VARCHAR(255);
    DECLARE zapljena_vrijednost NUMERIC (5,2);

    DECLARE slucajevi_Cursor CURSOR FOR
        SELECT Slucaj.id, Slucaj.naziv, Zapljene.Vrijednost
        FROM Slucaj
        JOIN Kaznjiva_djela_u_slucaju ON Slucaj.id = Kaznjiva_djela_u_slucaju.id_slucaj
        JOIN Kaznjiva_djela ON Kaznjiva_djela_u_slucaju.id_kaznjivo_djelo = Kaznjiva_djela.id
        LEFT JOIN Zapljene ON Slucaj.id = Zapljene.id_slucaj
        WHERE Kaznjiva_djela.naziv = kaznenoDjeloNaziv
        ORDER BY Zapljene.Vrijednost DESC;

    OPEN slucajevi_Cursor;

    slucaj_loop: LOOP
        FETCH slucajevi_Cursor INTO slucaj_id, slucaj_naziv, zapljena_vrijednost;
        IF slucaj_id IS NULL THEN
            LEAVE slucaj_loop;
        END IF;
        SELECT slucaj_naziv, zapljena_vrijednost;
    END LOOP;

    CLOSE slucajevi_Cursor;
END //
DELIMITER ;
#CALL Dohvati_Slucajeve_Po_Kaznenom_Djelu_Sortirano('Ubojstvo');

# 29. Napiši proceduru koja će ispisati sve zaposlenike, imena i prezimena, adrese i brojeve telefona u jednom redu za svakog zaposlenika
DROP PROCEDURE IF EXISTS IspisiInformacijeZaposlenika;
DELIMITER //

CREATE PROCEDURE IspisiInformacijeZaposlenika()
BEGIN

    DECLARE zaposlenik_id INT;
    DECLARE zaposlenik_ime_prezime VARCHAR(255);
    DECLARE zaposlenik_adresa VARCHAR(255);
    DECLARE zaposlenik_telefon VARCHAR(20);


    DECLARE zaposleniciCursor CURSOR FOR
        SELECT Zaposlenik.id, Osoba.ime_prezime, Osoba.adresa, Osoba.telefon
        FROM Zaposlenik
        JOIN Osoba ON Zaposlenik.id_osoba = Osoba.id;


    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN

        SELECT 'Nema dostupnih informacija o zaposlenicima.' AS Info;
    END;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN

        SELECT 'Došlo je do greške u izvršavanju SQL upita.' AS Info;
    END;


    OPEN zaposleniciCursor;

    zaposlenik_loop: LOOP

        FETCH zaposleniciCursor INTO zaposlenik_id, zaposlenik_ime_prezime, zaposlenik_adresa, zaposlenik_telefon;


        IF zaposlenik_id IS NULL THEN
            LEAVE zaposlenik_loop;
        END IF;


        SELECT CONCAT('Zaposlenik: ', zaposlenik_ime_prezime, ', Adresa: ', zaposlenik_adresa, ', Telefon: ', zaposlenik_telefon) AS Info;
    END LOOP;


    CLOSE zaposleniciCursor;
END //

DELIMITER ;



CALL IspisiInformacijeZaposlenika;
# 30. Napiši proceduru koja će ispisati sve slučajeve i za svaki slučaj ispisati voditelja i ukupan iznos zapljena. Ako nema pronađenih slučajeva, neka nas obavijesti o tome
#DROP PROCEDURE IspisiPodatkeOSlucajevimaIZapljenama;
DELIMITER //

CREATE PROCEDURE IspisiPodatkeOSlucajevimaIZapljenama()
BEGIN
    -- Kreirajte tablicu za privremene rezultate
    CREATE TEMPORARY TABLE IF NOT EXISTS TempRezultati (
        id INT,
        voditeljImePrezime VARCHAR(255),
        ukupanIznosZapljena NUMERIC(10, 2)
    );

    -- Ubacite podatke o slučajevima, voditeljima i ukupnom iznosu zapljena u tablicu za privremene rezultate
    INSERT INTO TempRezultati (id, voditeljImePrezime, ukupanIznosZapljena)
    SELECT
        Slucaj.id,
        Osoba.ime_prezime AS voditeljImePrezime,
        COALESCE(SUM(Zapljene.Vrijednost), 0) AS ukupanIznosZapljena # sumiraj sve zapljene koje nisu NULL (za to služi COALESCE)
    FROM Slucaj
    JOIN Zaposlenik ON Slucaj.id_voditelj = Zaposlenik.id
    JOIN Osoba ON Zaposlenik.id_osoba = Osoba.id
    LEFT JOIN Zapljene ON Slucaj.id = Zapljene.id_slucaj
    GROUP BY Slucaj.id, Osoba.ime_prezime;

    -- Ispisivanje informacija o slučaju
    SELECT * FROM TempRezultati;

    -- Ispis obavijesti ako nema pronađenih redaka
    IF (SELECT COUNT(*) FROM TempRezultati) = 0 THEN
        SELECT 'Nema podataka o slučajevima i zapljenama.' AS Napomena;
    END IF;

    -- Obrišite tablicu za privremene rezultate
    DROP TEMPORARY TABLE IF EXISTS TempRezultati;

END //

DELIMITER ;


CALL IspisiPodatkeOSlucajevimaIZapljenama;

# 31. Napiši proceduru koja će služiti za unaprijeđenje policijskih službenika na novo radno mjesto. Ako je novo radno mjesto jednako onom radnom mjestu osobe koja im je prije bila nadređena, postaviti će id_nadređeni na NULL
DELIMITER //

CREATE PROCEDURE UnaprijediPolicijskogSluzbenika(
    IN p_id_osoba INT, 
    IN p_novo_radno_mjesto_id INT
)
BEGIN
    DECLARE stari_radno_mjesto_id INT;
    DECLARE stari_nadredeni_id INT;
    DECLARE radno_mjesto_nadredenog INT;

    SELECT id_radno_mjesto, id_nadređeni INTO stari_radno_mjesto_id, stari_nadredeni_id
    FROM Zaposlenik
    WHERE id_osoba = p_id_osoba;

    SELECT id_radno_mjesto INTO radno_mjesto_nadredenog
    FROM Zaposlenik
    WHERE id_osoba = stari_nadredeni_id;

    IF radno_mjesto_nadredenog = p_novo_radno_mjesto_id THEN
        UPDATE Zaposlenik
        SET id_nadređeni = NULL
        WHERE id_osoba = p_id_osoba;
    ELSE
        UPDATE Zaposlenik
        SET id_radno_mjesto = novo_radno_mjesto_id_param
        WHERE id_osoba = p_id_osoba;
    END IF;
END //

DELIMITER ;

# 32. Napravi proceduru koja će provjeravati je li zatvorska kazna istekla
DELIMITER //

CREATE PROCEDURE ProvjeriIstekZatvorskeKazne()
BEGIN
    -- Provjerimo postojanje stupca prije dodavanja
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'Osoba' AND COLUMN_NAME = 'obavijest'
    ) THEN
        -- Dodamo stupac obavijest u tablicu Osoba
        ALTER TABLE Osoba
        ADD COLUMN obavijest VARCHAR(50);
    END IF;

    -- Postavimo done na 0
    DECLARE done INT DEFAULT 0;
    DECLARE osoba_id INT;
    DECLARE datum_zavrsetka_slucaja DATETIME;
    DECLARE ukupna_kazna INT;
    DECLARE danas DATETIME;

    -- Deklariramo kursor
    DECLARE cur CURSOR FOR
    SELECT O.Id, S.zavrsetak
    FROM Osoba O
    JOIN Slucaj S ON O.id = S.id_pocinitelj
    WHERE S.status = 'Zavrsen';

    -- Postavimo handler za kraj
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Otvorimo kursor
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO osoba_id, datum_zavrsetka_slucaja;

        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        -- Izračunamo ukupnu kaznu za osobu
        SET ukupna_kazna = (
            SELECT SUM(K.predvidena_kazna)
            FROM Slucaj S
            JOIN Kaznjiva_djela_u_slucaju KS ON S.id = KS.id_slucaj
            JOIN Kaznjiva_djela K ON KS.id_kaznjivo_djelo = K.id
            WHERE S.id_pocinitelj = osoba_id
        );

        -- Provjermo je li datum zavrsetka_slucaja + ukupna_kazna manji od današnjeg datuma
        SET danas = NOW();
        IF DATE_ADD(datum_zavrsetka_slucaja, INTERVAL ukupna_kazna DAY) <= danas THEN
            -- Istekla je zatvorska kazna, dodaj obavijest u stupac obavijest u tablici Osoba
            UPDATE Osoba
            SET obavijest = 'Kazna je istekla'
            WHERE Id = osoba_id;
        END IF;
    END LOOP;

    -- Zatvorimo kursor
    CLOSE cur;

END //

DELIMITER ;

# EVENT 2
DELIMITER //

CREATE EVENT IF NOT EXISTS `ProvjeraIstekaKazniEvent`
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    CALL ProvjeriIstekZatvorskeKazne();
END //

DELIMITER ;

############################################################################################################3
# Funkcije + upiti za funkcije
# FUNKCIJE + upiti za funkcije
# 1. Napiši funkciju koja kao argument prima naziv kaznenog djela i vraća naziv KD, predviđenu kaznu i broj pojavljivanja KD u slučajevima
DELIMITER //
CREATE FUNCTION KDInfo(naziv_kaznjivog_djela VARCHAR(255)) RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE predvidena_kazna INT;
    DECLARE broj_pojavljivanja INT;
    
    SELECT predvidena_kazna INTO predvidena_kazna
    FROM Kaznjiva_djela
    WHERE Naziv = naziv_kaznjivog_djela;

    SELECT COUNT(*) INTO broj_pojavljivanja
    FROM Kaznjiva_Djela_u_Slucaju
    WHERE id_kaznjivo_djelo= (SELECT ID FROM Kaznjiva_djela	WHERE Naziv = naziv_kaznenog_djela);

    RETURN CONCAT('Kazneno djelo: ', naziv_kaznenog_djela, '\nPredviđena kazna: ', predvidena_kazna, '\nBroj pojavljivanja: ', broj_pojavljivanja);
END;
//
DELIMITER ;

SELECT KDInfo('NazivKaznenogDjela');

# 18. Napiši upit koji će koristeći ovu funkciju izlistati sva kaznena djela koja su se dogodila u 2023. godini (ili nekoj drugoj) i njihov broj pojavljivanja
SELECT
    KDInfo(KD.Naziv) AS KaznjivoDjeloInfo,
    COUNT(KS.id_kaznjivo_djelo) AS BrojPojavljivanja
FROM Kaznjiva_Djela_u_Slucaju KS
INNER JOIN Kaznjiva_djela KD ON KS.id_kaznjivo_djelo = KD.ID
INNER JOIN Slucaj S ON KS.id_slucaj = S.ID
WHERE YEAR(S.Pocetak) = 2023
GROUP BY KD.Naziv;


# 2. Napiši funkciju koja će vratiti informacije o osobi prema broju telefona
DELIMITER //
CREATE FUNCTION InformacijeOOsobiPoTelefonu(broj_telefona VARCHAR(20)) RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE osoba_info TEXT;

    SELECT CONCAT('Ime i prezime: ', Ime_Prezime, '\nDatum rođenja: ', Datum_rodenja, '\nAdresa: ', Adresa, '\nEmail: ', Email)
    INTO osoba_info
    FROM Osoba
    WHERE Telefon = broj_telefona;

    IF osoba_info IS NOT NULL THEN
        RETURN osoba_info;
    ELSE
        RETURN 'Osoba s navedenim brojem telefona nije pronađena.';
    END IF;
END;
//
DELIMITER ;

# 19. Napiši upit koji će izlistati sve brojeve telefona i informacije o tim osobama, ali samo ako te osobe nisu policijski službenici
SELECT
    Telefon,
    InformacijeOOsobiPoTelefonu(Telefon) AS OsobaInfo
FROM Osoba
WHERE Osoba.id NOT IN(SELECT id_osoba FROM Zaposlenik);


SET SQL_safe_updates = 0;
# 3. Napiši funkciju koja će za određeni predmet vratiti slučaj u kojem je taj predmet dokaz i osobu koja je u tom slučaju osumnjičena
DELIMITER //

CREATE FUNCTION DohvatiSlucajIOsobu(id_predmet	INT)
RETURNS VARCHAR(512)
DETERMINISTIC
BEGIN
    DECLARE slucaj_naziv VARCHAR(255);
    DECLARE osoba_ime_prezime VARCHAR(255);
    DECLARE rezultat VARCHAR(512);
    
    
    SELECT Slucaj.Naziv INTO slucaj_naziv
    FROM Slucaj
    WHERE Slucaj.id_dokaz= id_predmet;
    
    
    SELECT Osoba.Ime_Prezime INTO osoba_ime_prezime
    FROM Osoba
    INNER JOIN Slucaj ON Osoba.Id = Slucaj.id_pocinitelj
    WHERE Slucaj.id_dokaz
    = id_predmet;
    
    
    SET rezultat = CONCAT('Odabrani je predmet dokaz u slučaju: ', slucaj_naziv, ', gdje je osumnjičena osoba: ', osoba_ime_prezime);
    
    RETURN rezultat;
END //

DELIMITER ;
# 20. Napiši upit koji izdvaja informacije o određenom predmetu, uključujući naziv predmeta, naziv povezanog slučaja i ime i prezime osumnjičenika u tom slučaju, koristeći funkciju DohvatiSlucajIOsobu za dobijanje dodatnih detalja za taj predmet.
SELECT
    Predmet.ID AS PredmetID,
    Predmet.Naziv AS NazivPredmeta,
    Slucaj.Naziv AS NazivSlucaja,
    Osoba.Ime_Prezime AS ImePrezimeOsumnjicenika,
    DohvatiSlucajIOsobu(Predmet.ID) AS InformacijeOPredmetu
FROM Predmet
INNER JOIN Slucaj ON Predmet.ID = Slucaj.id_dokaz
INNER JOIN Osoba ON Slucaj.id_pocinitelj = Osoba.ID
WHERE Predmet.Id = 5;


# 4. Napravi funkciju koja će za argument primati sredstvo utvrđivanja istine, zatim će prebrojiti u koliko je slučajeva to sredstvo korišteno, prebrojit će koliko je slučajeva od tog broja riješeno, te će na temelju ta 2 podatka izračunati postotak rješenosti slučajeva gdje se odabrano sredstvo koristi
DELIMITER //

CREATE FUNCTION IzracunajPostotakRjesenosti (
    sredstvo_id INT
) RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE ukupno INT;
    DECLARE koristeno INT;
    DECLARE postotak DECIMAL(5,2);
    
    
    SELECT COUNT(*) INTO ukupno FROM Sui_slucaj WHERE Id_sui = sredstvo_id;
    
    
    SELECT COUNT(*) INTO koristeno FROM Sui_slucaj s
    INNER JOIN Slucaj c ON s.Id_slucaj = c.Id
    WHERE s.Id_sui = sredstvo_id AND c.Status = 'Riješen';
    
    
    IF ukupno IS NOT NULL AND ukupno > 0 THEN
        SET postotak = (koristeno / ukupno) * 100;
    ELSE
        SET postotak = 0.00;
    END IF;
    
    RETURN postotak;
END //

DELIMITER ;

# 21. Koristeći gornju funkciju prikaži sredstva koja imaju rješenost veću od 50% (riješeno je više od 50% slučajeva koja koriste to sredstvo)
SELECT
    Sredstvo_utvrdivanja_istine.ID AS id_sredstvo,
    Sredstvo_utvrdivanja_istine.Naziv AS Naziv_Sredstva,
    IzracunajPostotakRjesenosti(Sredstvo_utvrdivanja_istine.ID) AS postotak
FROM Sredstvo_utvrdivanja_istine
WHERE IzracunajPostotakRjesenosti(Sredstvo_utvrdivanja_istine.ID) > 50.00;

# 5. Napiši funkciju koja će za argument primati registarske tablice vozila, a vraćat će informaciju je li se to vozilo pojavilo u nekom od slučajeva, tako što će provjeriti je li se id_osoba koji referencira vlasnika pojavio u nekom slučaju kao pocinitelj_id. Ako se pojavilo, vraćat će "Vozilo se pojavljivalo u slučajevima", a ako se nije pojavilo, vraćat će "Vozilo se nije pojavljivalo u slučajevima". Također, vratit će i broj koliko se puta vozilo pojavilo
DELIMITER //
CREATE FUNCTION Provjera_vozila(Registracija VARCHAR(20)) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(100);
    DECLARE count INT;

    SELECT COUNT(*)
    INTO count
    FROM Slucaj
    WHERE id_pocinitelj
    IN (SELECT id_vlasnik
    FROM Vozilo WHERE Registracija = Registracija);

    IF count > 0 THEN
        SET result = CONCAT('Vozilo se pojavljivalo u slučajevima (', count, ' puta)');
    ELSE
        SET result = 'Vozilo se nije pojavljivalo u slučajevima';
    END IF;

    RETURN result;
END //
DELIMITER ;

# 22. Koristeći funkciju prikažite vozila koja se pojavljuju iznad prosjeka (u iznadprosječnom broju)
CREATE TEMPORARY TABLE Prosjek_Pojavljivanja AS
SELECT AVG(count) AS Prosjek
FROM (
    SELECT COUNT(*) AS count
    FROM Slucaj
    INNER JOIN Vozilo ON Slucaj.id_pocinitelj = Vozilo.id_vlasnik
    GROUP BY Vozilo.Registracija
) AS Podupit1;

SELECT V.Registracija, Provjera_vozila(V.Registracija) AS StatusVozila
FROM Vozilo V
INNER JOIN (
    SELECT Vozilo.Registracija, COUNT(*) AS count
    FROM Slucaj
    INNER JOIN Vozilo ON Slucaj.id_pocinitelj = Vozilo.id_vlasnik
    GROUP BY Vozilo.Registracija
) AS Podupit2 ON V.Registracija = Podupit2.Registracija
WHERE Podupit2.count > (SELECT Prosjek FROM Prosjek_Pojavljivanja);




# 6. Funkcija koja za argument prima id podrucja uprave i vraća broj mjesta u tom području te naziv svih mjesta u 1 stringu
DELIMITER //
CREATE FUNCTION Podaci_O_Podrucju(id_podrucje INT) RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE broj_mjesta INT;
    DECLARE mjesta TEXT;
    
    SELECT COUNT(*) INTO broj_mjesta
    FROM Mjesto
    WHERE id_podrucje_uprave = id_podrucje;
    
    SELECT GROUP_CONCAT(naziv SEPARATOR ';') INTO mjesta
    FROM Mjesto
    WHERE id_podrucje_uprave = id_podrucje;
    
    RETURN CONCAT('Područje: ', (SELECT naziv FROM Podrucje_uprave WHERE id = id_podrucje), 
                  ', Broj mjesta: ', broj_mjesta, ', Mjesta: ', mjesta);
END //
DELIMITER ;

# 7. Napravi funkciju koje će za slučej predan preko id-ja dohvatiti broj kažnjivih djela u njemu
DELIMITER //

CREATE FUNCTION Broj_Kaznjivih_Djela_U_Slucaju(id_slucaj INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE broj_kaznjivih_djela INT;

    SELECT COUNT(*) INTO broj_kaznjivih_djela
    FROM Kaznjiva_djela_u_slucaju
    WHERE id_slucaj = id_slucaj;

    RETURN broj_kaznjivih_djela;
END;

//
DELIMITER ;

SELECT Broj_Kaznjivih_Djela_U_Slucaju(5);

# 23. Koristeći gornju funkciju napiši upit koji će naći slučaj s najviše kažnjivih djela
SELECT
    S.ID AS id_slucaj,
    S.Naziv AS Naziv_Slucaja,
    MAX(Broj_Kaznjivih_Djela_U_Slucaju(S.ID)) AS Broj_Kaznjivih_Djela
FROM Slucaj S
GROUP BY id_slucaj, Naziv_Slucaja;


# 8. Funkcija koje će za argument primati status slučajeva i vratiti će broj slučajeva sa tim statusom
DELIMITER //
CREATE FUNCTION broj_slucajeva_po_statusu(status VARCHAR(20)) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE broj_slucajeva INT;

    IF status IS NULL THEN
        SET broj_slucajeva = 0;
    ELSE
        SELECT COUNT(*) INTO broj_slucajeva
        FROM Slucaj
        WHERE Status = status;
    END IF;

    RETURN broj_slucajeva;
END;

//
DELIMITER ;

# 24. Koristeći gornju funkciju napravi upit koji će dohvatiti sve statuse koji vrijede za više od 5 slučajeva (ili neki drugi broj)
SELECT 
    Status,
    COUNT(*) AS broj_slucajeva
FROM
    Slucaj
GROUP BY
    Status
HAVING
    broj_slucajeva_po_statusu(Status) > 5; -- Prilagodimo broj prema potrebi

# 9. Funkcija koja za argument prima id_slucaj i računa njegovo trajanje; ako je završen, onda trajanje od početka do završetka, a ako nije, onda trajanje od početka do poziva funkcije
DELIMITER //
CREATE FUNCTION Informacije_o_slucaju(id_slucaj INT) RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE status_slucaja VARCHAR(20);
    DECLARE trajanje_slucaja INT;

    SELECT 
        Status,
        CASE
            WHEN Zavrsetak IS NULL THEN DATEDIFF(NOW(), Pocetak)
            ELSE DATEDIFF(Zavrsetak, Pocetak)
        END AS trajanje
    INTO
        status_slucaja, trajanje_slucaja
    FROM 
        Slucaj
    WHERE 
        id = id_slucaj;

    RETURN CONCAT('Status slučaja: ', status_slucaja, '\nTrajanje slučaja: ', trajanje_slucaja, ' dana');
END;
//
DELIMITER ;

# 25. Napiši upit koji će dohvatiti sve slučajeve i pomoću funkcije iščitati njihove statuse i trajanja
    SELECT 
    Id AS 'ID slučaja',
    Naziv AS 'Naziv slučaja',
    Informacije_o_slucaju(Id) AS 'Informacije o slučaju'
FROM 
    Slucaj;

-- 10. Napiši funckiju koja će za zaposlenika definiranog parametron p_id_zaposlenik izbrojiti broj slučajeva na kojima je on bio voditelj i izračunati 
-- postotak rješenosti tih slučajeva te na temelju toga ispiše je li zaposlenik neuspješan (0%-49%) ili uspješan (50%-100%).

DELIMITER //
CREATE FUNCTION zaposlenik_slucaj(p_id_zaposlenik INT) RETURNS INT
DETERMINISTIC
BEGIN

DECLARE l_broj INT;
DECLARE l_broj_rijeseni INT;
DECLARE l_postotak DECIMAL (5, 2);

SELECT COUNT(*) INTO l_broj
FROM slucaj
WHERE id_voditelj=p_id_zaposlenik;

SELECT COUNT(*) INTO l_broj_rijeseni
FROM slucaj
WHERE id_voditelj=p_id_zaposlenik AND status='Riješen';

SET l_postotak=(l_broj_rijeseni/l_broj)*100;

IF l_postotak<=49
THEN RETURN "neuspješan";
ELSE RETURN "uspješan";
END IF;

END//
DELIMITER ;

# 26. upit koji će za svakog zaposlenika pozvati funkciju uspješnosti i vratiti rezultat, osim ako nije vodio slučajeve, onda će vratiti odgovarajuću obavijest
    SELECT
    Z.Id AS 'ID zaposlenika',
    Z.Ime_Prezime AS 'Ime i prezime zaposlenika',
    CASE
        WHEN (SELECT COUNT(*) FROM slucaj WHERE id_voditelj = Z.Id) > 0
        THEN zaposlenik_slucaj(Z.Id)
        ELSE 'Zaposlenik nije vodio slučajeve'
    END AS 'Uspješnost'
FROM
    Zaposlenik Z;

-- 11. Napiši funkciju koja će za osobu definiranu parametrom p_id_osoba vratiti "DA" ako je barem jednom bila oštećenik u nekom slučaju, a u 
-- protivnom će vratiti "NE."

DELIMITER //
CREATE FUNCTION osoba_ostecenik(p_id_osoba INT) RETURNS CHAR(2)
DETERMINISTIC
BEGIN

DECLARE l_broj INT;
SELECT COUNT(*) INTO l_broj
FROM slucaj
WHERE id_ostecenik=p_id_osoba;

IF l_broj>0
THEN RETURN "DA";
ELSE RETURN "NE";
END IF;

END//
DELIMITER ;
# 27. Prikaži sve osobe koje su oštećene više od 3 puta
    SELECT
    O.Id AS 'ID osobe',
    O.Ime_Prezime AS 'Ime i prezime osobe'
FROM
    Osoba O
WHERE
    osoba_ostecenik(O.Id) = 'DA'
GROUP BY
    O.Id, O.Ime_Prezime
HAVING
    COUNT(*) > 3;

# 12. Napiši funkciju koja će za osobu određenu predanim id_jem odrediti sve uloge koje je ta osoba imala u slučajevima
DELIMITER //

CREATE FUNCTION Uloge_Osobe_U_Slucajevima(osoba_id INT) RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE uloge VARCHAR(255);

    SELECT 
        CONCAT('Osoba je u slučajevima bila: ',
            CASE WHEN os.id = s.id_pocinitelj THEN 'pocinitelj ' ELSE '' END,
            CASE WHEN os.id = s.id_izvjestitelj THEN 'izvjestitelj ' ELSE '' END,
            CASE WHEN os.id = s.id_voditelj THEN 'voditelj ' ELSE '' END,
            CASE WHEN os.id = s.id_svjedok THEN 'svjedok ' ELSE '' END,
            CASE WHEN os.id = s.id_ostecenik THEN 'ostecenik ' ELSE '' END) INTO uloge
    FROM Slucaj s
    LEFT JOIN Osoba os ON os.id = osoba_id
    WHERE os.id IN (s.id_pocinitelj, s.id_izvjestitelj, s.id_voditelj, s.id_svjedok, s.id_ostecenik)
    LIMIT 1;

    -- Ako osoba ima više od jedne uloge u istom slučaju, dodajemo ih u rezultat
    SELECT 
        CONCAT('Osoba je u slučajevima bila: ',
            CASE WHEN os.id = s.id_pocinitelj THEN 'pocinitelj ' ELSE '' END,
            CASE WHEN os.id = s.id_izvjestitelj THEN 'izvjestitelj ' ELSE '' END,
            CASE WHEN os.id = s.id_voditelj THEN 'voditelj ' ELSE '' END,
            CASE WHEN os.id = s.id_svjedok THEN 'svjedok ' ELSE '' END,
            CASE WHEN os.id = s.id_ostecenik THEN 'ostecenik ' ELSE '' END) 
    INTO uloge
    FROM Slucaj s
    LEFT JOIN Osoba os ON os.id = osoba_id
    WHERE os.id IN (s.id_pocinitelj, s.id_izvjestitelj, s.id_voditelj, s.id_svjedok, s.id_ostecenik)
    AND os.id != s.id_pocinitelj AND os.id != s.id_izvjestitelj AND os.id != s.id_voditelj AND os.id != s.id_svjedok AND os.id != s.id_ostecenik;

    -- Ako osoba nije bila ništa u slučajevima
    IF uloge IS NULL THEN
        SET uloge = 'Osoba nije bila u niti jednom slučaju';
    END IF;

    RETURN uloge;
END //

DELIMITER ;

# 28. UPIT KOJI ĆE DOHVATITI SVE OSOBE I NJIHOVE ULOGE U SLUČAJEVIMA
SELECT id, ime_prezime, UlogeOsobeUSlucajevima(id) AS uloge
FROM Osoba;

DELIMITER //
# 13. Funkcija koja će vratiti je li osoba sumnjiva (već je osumnjičena na nekim slučajevima) ili nije sumnjiva
    
CREATE FUNCTION Sumnjivost_Osobe(osoba_id INT) RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE broj_slucajeva INT;
    DECLARE sumnjivost VARCHAR(50);

    SELECT COUNT(*) INTO broj_slucajeva
    FROM Slucaj
    WHERE id_okrivljenik = osoba_id;

    IF broj_slucajeva > 10 THEN
        SET sumnjivost = 'Jako sumnjiva';
    ELSEIF broj_slucajeva > 0 THEN
        SET sumnjivost = 'Umjereno sumnjiva';
    ELSE
        SET sumnjivost = 'Nije sumnjiva';
    END IF;

    RETURN sumnjivost;
END //

DELIMITER ;

# 29. Napiši upit koji će dohvatiti sve osobe, pa i policajce; nije nemoguće da policajac bude kriminalac :) i podatke o njihovoj sumnjivosti
SELECT id, ime_prezime, SumnjivostOsobe(id) AS sumnjivost
FROM Osoba;

# 14. Napiši funkciju koja će za dani odjel definiran id-jem koji joj prosljeđujemo za argument vratiti broj zaposlenih na tom odjelu u zadnjih 6 mjeseci
DELIMITER //

CREATE FUNCTION Broj_zaposlenih_6mj(odjel_id INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE broj_zaposlenih INT;

    SELECT COUNT(*) INTO broj_zaposlenih
    FROM Zaposlenik
    WHERE id_odjel = odjel_id
      AND datum_zaposlenja >= CURDATE() - INTERVAL 6 MONTH;

    RETURN broj_zaposlenih;
END //

DELIMITER ;
SELECT Broj_zaposlenih_6mj(5);

# 30. Napiši upit koji će vratiti id i naziv odjela koji je imao  najveći broj zaposlenih u zadnjih 6 mjeseci
SELECT id, naziv, Broj_zaposlenih_6mj(id) AS Broj_zaposlenih
FROM odjeli
ORDER BY Broj_zaposlenih DESC
LIMIT 1;

# 15. Napiši funkciju koja će za odjel definiran prosljeđenim id-jem dohvatiti broj zaposlenih i broj slučajeva. Zatim
# će računati koliko prosječno ima slučajeva po osobi na tom odjelu
DELIMITER //

CREATE FUNCTION Avg_Slucaj_Osoba_Odjel(odjel_id INT) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE broj_zaposlenih INT;
    DECLARE broj_slucajeva INT;
    DECLARE prosječan_broj_slucajeva DECIMAL(10, 2);


    SELECT COUNT(*) INTO broj_zaposlenih
    FROM Zaposlenik
    WHERE id_odjel = odjel_id;


    SELECT COUNT(*) INTO broj_slucajeva
    FROM Slucaj
    WHERE id_voditelj IN (SELECT id_osoba FROM Zaposlenik WHERE id_odjel = odjel_id);


    IF broj_zaposlenih > 0 THEN
        SET prosječan_broj_slucajeva = broj_slucajeva / broj_zaposlenih;
    ELSE
        SET prosjecan_broj_slučajeva = 0;
    END IF;

    RETURN prosjecan_broj_slučajeva;
END //

DELIMITER ;

SELECT Avg_Slucaj_Osoba_Odjel(5);

#31. Koristeći ovu funkciju napiši upit za pronalaženje odjela s ispodprosječnim brojem slučajeva po osobi
SELECT naziv AS Nazivi_ispodprosječnih_odjela
FROM Odjeli
WHERE Avg_Slucaj_Osoba_Odjel(id) < 
    (SELECT AVG(Avg_Slucaj_Osoba_Odjel(id)) FROM Odjeli);

# 32. Na isti način napiši i upit za pronalaženje odjela s iznadprosječnim brojem slučajeva po osobi
-- Upit za pronalaženje odjela s ispodprosječnim brojem slučajeva po osobi
SELECT id, naziv
FROM Odjeli
WHERE Avg_Slucaj_Osoba_Odjel(id) >
    (SELECT AVG(Avg_Slucaj_Osoba_Odjel(id)) FROM Odjeli);
	
#########################
# KORISNICI
/*
1)-- Kreiranje admin korisnika
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin_password';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
-- prikaz ovlasti
SHOW GRANTS FOR 'admin'@'localhost';
-- oduzimanje ovlasti
REVOKE ALL PRIVILEGES ON *.* FROM 'admin'@'localhost';
FLUSH PRIVILEGES;
-- brisanje korisnika
DROP USER 'admin'@'localhost';


2)-- Kreiranje HR korisnika
CREATE USER 'hr'@'localhost' IDENTIFIED BY 'hr_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Radno_mjesto TO 'hr'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Odjeli TO 'hr'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Zaposlenik TO 'hr'@'localhost';
FLUSH PRIVILEGES;
-- prikaz ovlasti
SHOW GRANTS FOR 'hr'@'localhost';
-- oduzimanje ovlasti
REVOKE ALL PRIVILEGES ON *.* FROM 'hr'@'localhost';
FLUSH PRIVILEGES;
-- brisanje korisnika
DROP USER 'hr'@'localhost';

# 3) Napravi korisnika za običnu fizičku osobu koja nije djelatnik policije i ima pristup samo osnovnijim, neklasificiranim tablicama
CREATE USER 'fizicka_osoba'@'localhost' IDENTIFIED BY 'fizicka_osoba_password';
GRANT SELECT ON Policija.Podrucje_uprave TO 'fizicka_osoba'@'localhost';
GRANT SELECT ON Policija.Mjesto TO 'fizicka_osoba'@'localhost';
GRANT SELECT ON Policija.Zgrada TO 'fizicka_osoba'@'localhost';
GRANT SELECT ON Policija.Radno_mjesto TO 'fizicka_osoba'@'localhost';
GRANT SELECT ON Policija.Odjeli TO 'fizicka_osoba'@'localhost';
GRANT SELECT (ime_prezime, datum_rodenja, spol, adresa, telefon, email) ON Policija.Osoba TO 'fizicka_osoba'@'localhost';
GRANT SELECT ON Policija.Kaznjiva_djela TO 'fizicka_osoba'@'localhost';
GRANT SELECT ON Policija.Sredstvo_utvrdivanja_istine TO 'fizicka_osoba'@'localhost';
FLUSH PRIVILEGES;

SHOW GRANTS FOR 'fizicka_osoba'@'localhost';
REVOKE ALL PRIVILEGES ON *.* FROM 'fizicka_osoba'@'localhost';
FLUSH PRIVILEGES;
-- brisanje korisnika
DROP USER 'fizicka_osoba'@'localhost';

# 4)Napravi korisnika 'detektiv' (ne znan dali je to egzaktan naziv) koji će biti zadužen za prikupljanje dokaza na slučajevima, predmete, sredstva_utvrđivanja_istine i sastavljanje izvještaja
CREATE USER 'detektiv'@'localhost' IDENTIFIED BY 'detektiv_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Predmet TO 'detektiv'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Slucaj TO 'detektiv'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Sui TO 'detektiv'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Sui_slucaj TO 'detektiv'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Izvjestaji TO 'detektiv'@'localhost';
FLUSH PRIVILEGES;
*/
#######################################
# 1)Kreirajte transakciju koja, uzimajući u obzir trenutačnu aktivnost pasa, dodjeljuje psa s najmanje slučajeva novom aktivnom slučaju. Rješenje treba osigurati dosljednost podataka i minimalno opterećenje pasa.
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





#########################################################################
# 2) transakcija koja će omogućiti praćenje broja izvještaja za svaki slučaj
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
# 3)  izraditi SQL transakciju koja će analizirati događaje u evidenciji (tablica Evidencija_dogadaja) i stvoriti tri nove tablice događaja prema godinama.
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

# 4) Napravi transakciju koja će pomoću procedure dodati 20 novih kažnjivih djela
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
	#DEFINITIVNO STANJE:
# 18 TABLES (+ još 5 temporary) (UVJET JE 15)
# 20 TRIGGERS (NI SPECIFICIRANO U UVJETIMA ALI VJEROJATNO JE 5)
# 17 REGULAR QUERIES (UVJET JE 15)
# + 15 FUNCTIONAL QUERIES (ovo ne znači da nan 15 upita od 17 funkcionira, nego da imamo 15 upita povezanih s funkcijama, čisto da ne bude zabune :)) (NEMA TEGA U UVJETIMA)
# --------------------------------------------
# = 32 QUERIES IN TOTAL
# 20 VIEWS (5 JE MINIMUM)
# 15 FUNCTIONS (NEMA TEGA U UVJETIMA, ALI VJEROJATNO JE 5)
# 31 PROCEDURES + 2 SCHEDULED EVENTS (UVJET JE 10, EVENTE NE SPOMINJU...TO JE ROMEOV PREMIUM TIP :))
# 4 USERS (NE SPOMINJU U UVJETIMA)
# 33 INDEXES (NE SPOMINJU U UVJETIMA)
# 4 TRANSAKCIJE (tega će bit još)
# Tu još samo fale podaci i transakcije i moremo predat projekt
