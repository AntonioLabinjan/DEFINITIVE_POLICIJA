#Kreirajte transakciju koja, uzimajući u obzir trenutačnu aktivnost pasa, dodjeljuje psa s najmanje slučajeva novom aktivnom slučaju. Rješenje treba osigurati dosljednost podataka i minimalno opterećenje pasa.

# FOR UPDATE klauzula koristi se kako bi se tijekom čitanja informacija o broju slučajeva za aktivne pse zaključali retci, spriječavajući druge transakcije da mijenjaju status pasa, primjerice umirovljenje ili dodjelu na nove slučajeve. 
# Time se osigurava da pas s najmanje slučajeva ostane nepromijenjen tijekom trajanja transakcije, održavajući dosljednost podataka u kontekstu dodjele pasa novim slučajevima.
#  U ovom zadatku koristimo izolacijski nivo "REPEATABLE READ" kako bi osigurao dosljednost podataka tijekom trajanja transakcije.
#  Budući da analiziramo trenutačnu aktivnost pasa i dodjelu pasa slučajevima, važno je da podaci o psima ostanu nepromijenjeni kako bi se izbjegle netočnosti
#  u dodjeli pasa novim slučajevima. "REPEATABLE READ" sprječava čitanje prljavih podataka (dirty reads) i neponovljivih čitanja (non-repeatable reads), 
#  čime se održava konzistentnost podataka i osigurava pouzdanost u obradi podataka u okviru transakcije. */

-- Postavljanje izolacijskog nivoa na REPEATABLE READ
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

-- Pronađi aktivne pse s brojem slučajeva
SELECT Pas.id, COUNT(Slucaj.id) AS broj_slucajeva
FROM Pas
LEFT JOIN Slucaj ON Pas.id = Slucaj.id_pas
WHERE Pas.status = 'Aktivan' AND Slucaj.status = 'Aktivan'
GROUP BY Pas.id
FOR UPDATE;

-- Pronađi psa s najmanje slučajeva
SELECT Pas.id
FROM Pas
LEFT JOIN Slucaj ON Pas.id = Slucaj.id_pas
WHERE Pas.status = 'Aktivan' AND Slucaj.status = 'Aktivan'
GROUP BY Pas.id
ORDER BY COUNT(Slucaj.id) ASC
LIMIT 1;

-- Dodijeli psa s najmanje slučajeva novom slučaju
INSERT INTO Slucaj (naziv, pocetak, status, id_pas)
SELECT 'Novi slucaj', NOW(), 'Aktivan', Pas.id
FROM Pas
LEFT JOIN Slucaj ON Pas.id = Slucaj.id_pas
WHERE Pas.status = 'Aktivan' AND Slucaj.status = 'Aktivan'
GROUP BY Pas.id
ORDER BY COUNT(Slucaj.id) ASC
LIMIT 1;

-- Zatvori transakciju
COMMIT;
