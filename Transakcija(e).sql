#Kreirajte transakciju koja, uzimajući u obzir trenutačnu aktivnost pasa, dodjeljuje psa s najmanje 
#slučajeva novom 
#aktivnom slučaju. Rješenje treba osigurati dosljednost podataka i minimalno opterećenje pasa.
/*
#  U ovom zadatku koristiš izolacijski nivo "REPEATABLE READ" kako bi osigurao dosljednost podataka tijekom trajanja transakcije.
#  Budući da analiziraš trenutačnu aktivnost pasa i dodjelu pasa slučajevima, važno je da podaci o psima ostanu nepromijenjeni kako bi se izbjegle netočnosti
#  u dodjeli pasa novim slučajevima. "REPEATABLE READ" sprječava čitanje prljavih podataka (dirty reads) i neponovljivih čitanja (non-repeatable reads), 
#  čime se održava konzistentnost podataka i osigurava pouzdanost u obradi podataka u okviru transakcije. */
  START TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- 1. Provjeri koliko slučajeva ima svaki aktivan pas
SELECT Pas.id, COUNT(Slucaj.id) AS broj_slucajeva
FROM Pas
LEFT JOIN Slucaj ON Pas.id = Slucaj.id_pas
WHERE Pas.status = 'Aktivan' AND Slucaj.status = 'Aktivan'
GROUP BY Pas.id
FOR UPDATE;

-- 2. Prebroji slučajeve za svakog psa
SELECT Pas.id, COUNT(Slucaj.id) AS broj_slucajeva
FROM Pas
LEFT JOIN Slucaj ON Pas.id = Slucaj.id_pas
WHERE Pas.status = 'Aktivan' AND Slucaj.status = 'Aktivan'
GROUP BY Pas.id
FOR UPDATE;

-- 3. Dodijeli psa s najmanje slučajeva novom slučaju
INSERT INTO Slucaj (naziv, pocetak, status, id_pas)
SELECT 'slucaj_za_transakciju', NOW(), 'Aktivan', id
FROM Pas
WHERE status = 'Aktivan'
ORDER BY broj_slucajeva ASC
LIMIT 1
FOR UPDATE;

-- Ažuriraj ostale strane ključeve na NULL
UPDATE Slucaj
SET id_pocinitelj = NULL, id_izvjestitelj = NULL, id_voditelj = NULL,
    id_dokaz = NULL, ukupna_vrijednost_zapljena = NULL, id_svjedok = NULL, id_ostecenik = NULL
WHERE naziv = 'slucaj_za_transakciju';

COMMIT;
