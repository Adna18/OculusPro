LOGIN ZA DESKTOP APLIKACIJU :
username:doktor
password:doktor

LOGIN ZA MOBILNU APLIKACIJU:
username:pacijent
password:pacijent

PAYPAL:
email: sb-t4kas41604495@personal.example.com
password:UCT?9Ie6 (veliko i)

OPIS RECOMMENDER SISTEMA:
Aplikacija sadrži rekomender sistem koji koristi mašinsko učenje kako bi preporučio slične proizvode na osnovu prethodnih narudžbi korisnika. Model koristi algoritam Matrix Factorization, koji je popularna metoda za tzv. „collaborative filtering“.
Analiziraju se prethodne narudžbe kako bi se utvrdilo koji su proizvodi često naručivani zajedno.
Na primjer, ako je korisnik naručio Proizvod A i Proizvod B u istoj narudžbi, sistem bilježi par (A, B).
Korištenjem MatrixFactorizationTrainer iz ML.NET biblioteke, model se trenira nad skupom tih parova. Model uči obrasce koji proizvodi imaju tendenciju da se pojavljuju zajedno u narudžbama.
Preporuke za sve proizvode se spremaju u bazu.
Ako već postoje rezultati, vrši se ažuriranje; višak se briše ili dodaju novi zapisi po potrebi.
Potrebno je imati najmanje 5 proizvoda i barem 3 narudžbe koje sadrže više od jednog proizvoda kako bi se omogućilo kreiranje kvalitetnih preporuka.
