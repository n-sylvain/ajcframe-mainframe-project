       IDENTIFICATION DIVISION.
       PROGRAM-ID. FACTURE.
       
      * GENERATION DES FACTURES A PARTIR DES DONNEES EXTRAITES
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT EXTRACT-FILE ASSIGN TO EXTRACT
           ORGANIZATION IS SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           FILE STATUS IS WS-EXTRACT-STATUS.
           
           SELECT FACTURE-FILE ASSIGN TO FACTURES
           ORGANIZATION IS SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           FILE STATUS IS WS-FACTURE-STATUS.
       
       DATA DIVISION.
       FILE SECTION.
       FD  EXTRACT-FILE
           RECORDING MODE IS F
           RECORD CONTAINS 280 CHARACTERS.
       01  EXTRACT-RECORD.
           05 EXT-COMPANY           PIC X(30).
           05 EXT-ADDRESS           PIC X(100).
           05 EXT-CITY              PIC X(20).
           05 EXT-ZIP               PIC X(5).
           05 EXT-STATE             PIC X(2).
           05 EXT-O-NO              PIC 9(3).
           05 EXT-ODATE-ISO         PIC X(10).
           05 EXT-DNAME             PIC X(20).
           05 EXT-LNAME             PIC X(20).
           05 EXT-FNAME             PIC X(20).
           05 EXT-P-NO              PIC X(3).
           05 EXT-DESCRIPTION       PIC X(30).
           05 EXT-QUANTITY          PIC 9(2).
           05 EXT-PRICE             PIC 9(3).99.
           05 EXT-LINE-TOTAL        PIC 9(5).99.
           05 FILLER                PIC X(1).
       
       FD  FACTURE-FILE
           RECORDING MODE IS F
           RECORD CONTAINS 132 CHARACTERS.
       01  FACTURE-RECORD           PIC X(132).
       
       WORKING-STORAGE SECTION.
      * VARIABLES DE CONTROLE DES FICHIERS
       77 WS-EXTRACT-STATUS         PIC XX.
       77 WS-FACTURE-STATUS         PIC XX.
       77 WS-EOF-EXTRACT            PIC X VALUE 'N'.
           88 EOF-EXTRACT           VALUE 'Y'.
       
      * VARIABLES POUR LA FACTURE EN COURS
       77 WS-CURRENT-ORDER          PIC 9(3) VALUE ZERO.
       77 WS-ORDER-TOTAL            PIC 9(7)V99 VALUE ZERO.
       77 WS-TVA-RATE               PIC 9V999 VALUE ZERO.
       77 WS-TVA-AMOUNT             PIC 9(7)V99 VALUE ZERO.
       77 WS-COMMISSION-RATE        PIC 9V999 VALUE 0,099.
       77 WS-COMMISSION-AMOUNT      PIC 9(7)V99 VALUE ZERO.
       77 WS-TOTAL-WITH-TAXES       PIC 9(7)V99 VALUE ZERO.
       
      * VARIABLES DE TRAVAIL POUR LES CALCULS
       77 WS-LINE-TOTAL-WORK        PIC 9(7)V99.
       77 WS-PRICE-WORK             PIC 9(5)V99.
       77 WS-QUANTITY-WORK          PIC 9(2).
       
      * VARIABLES POUR LE FORMATAGE DE LA DATE
       77 WS-DATE-IN                PIC X(8).
       77 WS-DATE-FORMATEE          PIC X(40).
       
      * LIGNES DE SORTIE FORMATEES
       01 LIGNE-VIDE                PIC X(132) VALUE SPACES.
       
       01 LIGNE-ADRESSE.
           05 FILLER                PIC X(50) VALUE SPACES.
           05 LA-COMPANY            PIC X(30).
           05 FILLER                PIC X(52) VALUE SPACES.
       
       01 LIGNE-RUE.
           05 FILLER                PIC X(50) VALUE SPACES.
           05 LA-ADDRESS            PIC X(30).
           05 FILLER                PIC X(52) VALUE SPACES.
       
       01 LIGNE-VILLE.
           05 FILLER                PIC X(50) VALUE SPACES.
           05 LA-CITY               PIC X(20).
           05 FILLER                PIC X(2) VALUE ', '.
           05 LA-ZIP                PIC X(5).
           05 FILLER                PIC X(55) VALUE SPACES.
       
       01 LIGNE-STATE.
           05 FILLER                PIC X(50) VALUE SPACES.
           05 LA-STATE              PIC X(2).
           05 FILLER                PIC X(80) VALUE SPACES.
       
       01 LIGNE-DATE.
           05 FILLER                PIC X(5) VALUE SPACES.
           05 LD-VILLE              PIC X(20) VALUE 'New York'.
           05 FILLER                PIC X(2) VALUE ', '.
           05 LD-DATE-FORMATEE      PIC X(40).
           05 FILLER                PIC X(65) VALUE SPACES.
       
       01 LIGNE-ORDER.
           05 FILLER                PIC X(5) VALUE SPACES.
           05 FILLER                PIC X(18) VALUE 'Order Number : '.
           05 LO-ORDER-NO           PIC 999.
           05 FILLER                PIC X(106) VALUE SPACES.
       
       01 LIGNE-ORDER-DATE.
           05 FILLER                PIC X(5) VALUE SPACES.
           05 FILLER                PIC X(16) VALUE 'Order Date : '.
           05 LOD-ORDER-DATE        PIC X(10).
           05 FILLER                PIC X(101) VALUE SPACES.
       
       01 LIGNE-CONTACT.
           05 FILLER                PIC X(5) VALUE SPACES.
           05 FILLER                PIC X(35) VALUE
                                'Your contact within the department '.
           05 LC-DNAME              PIC X(20).
           05 FILLER                PIC X(3) VALUE ' : '.
           05 LC-LNAME              PIC X(20).
           05 FILLER                PIC X(2) VALUE ', '.
           05 LC-FNAME              PIC X(20).
           05 FILLER                PIC X(27) VALUE SPACES.
       
       01 LIGNE-HEADER.
           05 FILLER                PIC X(5) VALUE SPACES.
           05 FILLER                PIC X(5) VALUE 'P_NO '.
           05 FILLER                PIC X(12) VALUE 'DESCRIPTION '.
           05 FILLER                PIC X(10) VALUE 'QUANTITY  '.
           05 FILLER                PIC X(8) VALUE 'PRICE   '.
           05 FILLER                PIC X(10) VALUE 'LINE TOTAL'.
           05 FILLER                PIC X(82) VALUE SPACES.
       
       01 LIGNE-SEPARATEUR.
           05 FILLER                PIC X(5) VALUE SPACES.
           05 FILLER                PIC X(50) VALUE ALL '-'.
           05 FILLER                PIC X(77) VALUE SPACES.
       
       01 LIGNE-PRODUIT.
           05 FILLER                PIC X(5) VALUE SPACES.
           05 LP-P-NO               PIC X(3).
           05 FILLER                PIC X(2) VALUE SPACES.
           05 LP-DESCRIPTION        PIC X(30).
           05 FILLER                PIC X(2) VALUE SPACES.
           05 LP-QUANTITY           PIC ZZ9.
           05 FILLER                PIC X(5) VALUE SPACES.
           05 LP-PRICE              PIC ZZZ,99.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 LP-LINE-TOTAL         PIC ZZ.ZZZ,99.
           05 FILLER                PIC X(71) VALUE SPACES.
       
       01 LIGNE-SOUS-TOTAL.
           05 FILLER                PIC X(70) VALUE SPACES.
           05 FILLER                PIC X(12) VALUE 'SUB TOTAL : '.
           05 LST-AMOUNT            PIC ZZ.ZZZ,99.
           05 FILLER                PIC X(41) VALUE SPACES.
       
       01 LIGNE-TVA.
           05 FILLER                PIC X(70) VALUE SPACES.
           05 FILLER                PIC X(12) VALUE 'SALES TAX : '.
           05 LT-AMOUNT             PIC ZZ.ZZZ,99.
           05 FILLER                PIC X(41) VALUE SPACES.
       
       01 LIGNE-COMMISSION.
           05 FILLER                PIC X(70) VALUE SPACES.
           05 FILLER                PIC X(12) VALUE 'COMMISSION: '.
           05 LC-AMOUNT             PIC ZZ.ZZZ,99.
           05 FILLER                PIC X(41) VALUE SPACES.
       
       01 LIGNE-TOTAL.
           05 FILLER                PIC X(70) VALUE SPACES.
           05 FILLER                PIC X(12) VALUE 'TOTAL     : '.
           05 LTO-AMOUNT            PIC ZZ.ZZZ,99.
           05 FILLER                PIC X(41) VALUE SPACES.
       
       PROCEDURE DIVISION.
       
           DISPLAY "=== DEBUT GENERATION FACTURES ==="
       
      * LECTURE DU TAUX DE TVA DEPUIS SYSIN
           PERFORM LIRE-TAUX-TVA
       
      * OUVERTURE DES FICHIERS
           OPEN INPUT EXTRACT-FILE
           IF WS-EXTRACT-STATUS NOT = '00'
               DISPLAY "ERREUR OUVERTURE EXTRACT : ", WS-EXTRACT-STATUS
               PERFORM ABEND-PROG
           END-IF
           
           OPEN OUTPUT FACTURE-FILE
           IF WS-FACTURE-STATUS NOT = '00'
               DISPLAY "ERREUR OUVERTURE FACTURES : ", WS-FACTURE-STATUS
               PERFORM ABEND-PROG
           END-IF
       
      * LECTURE DU PREMIER ENREGISTREMENT
           PERFORM LIRE-EXTRACT
       
      * TRAITEMENT PRINCIPAL
           PERFORM UNTIL EOF-EXTRACT
               PERFORM GENERER-FACTURE
           END-PERFORM
       
      * FERMETURE DES FICHIERS
           CLOSE EXTRACT-FILE
           CLOSE FACTURE-FILE
       
           DISPLAY "=== FIN GENERATION FACTURES ==="
           GOBACK.
       
       LIRE-TAUX-TVA.
      * LECTURE DU TAUX DE TVA DEPUIS SYSIN
           ACCEPT WS-TVA-RATE FROM SYSIN
           DISPLAY "TAUX TVA LU : ", WS-TVA-RATE
           .
       
       LIRE-EXTRACT.
           READ EXTRACT-FILE
               AT END
                   SET EOF-EXTRACT TO TRUE
               NOT AT END
                   CONTINUE
           END-READ
           .
       
       GENERER-FACTURE.
      * INITIALISATION POUR UNE NOUVELLE FACTURE
           MOVE EXT-O-NO TO WS-CURRENT-ORDER
           MOVE ZERO TO WS-ORDER-TOTAL
           
      * EN-TETE DE LA FACTURE
           PERFORM ECRIRE-ENTETE-FACTURE
           
      * LIGNES DE PRODUITS POUR CETTE COMMANDE
           PERFORM UNTIL EOF-EXTRACT OR EXT-O-NO NOT = WS-CURRENT-ORDER
               PERFORM ECRIRE-LIGNE-PRODUIT
      * CONVERSION DU CHAMP EDITE VERS NUMERIQUE POUR LE CALCUL
               MOVE EXT-LINE-TOTAL TO WS-LINE-TOTAL-WORK
               ADD WS-LINE-TOTAL-WORK TO WS-ORDER-TOTAL
               PERFORM LIRE-EXTRACT
           END-PERFORM
           
      * CALCULS ET TOTAUX
           PERFORM CALCULER-TOTAUX
           PERFORM ECRIRE-TOTAUX
           
      * SAUT DE PAGE
           PERFORM ECRIRE-SAUT-PAGE
           .
       
       ECRIRE-ENTETE-FACTURE.
      * ADRESSE SOCIETE
           MOVE EXT-COMPANY TO LA-COMPANY
           MOVE LIGNE-ADRESSE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           
           MOVE EXT-ADDRESS TO LA-ADDRESS
           MOVE LIGNE-RUE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           
           MOVE EXT-CITY TO LA-CITY
           MOVE EXT-ZIP TO LA-ZIP
           MOVE LIGNE-VILLE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           
           MOVE EXT-STATE TO LA-STATE
           MOVE LIGNE-STATE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           
           PERFORM ECRIRE-LIGNE-VIDE
           PERFORM ECRIRE-LIGNE-VIDE
           
      * DATE ET LIEU
           MOVE EXT-ODATE-ISO TO WS-DATE-IN
           CALL 'DATEFMT' USING BY REFERENCE WS-DATE-IN
                                BY REFERENCE WS-DATE-FORMATEE
           MOVE WS-DATE-FORMATEE TO LD-DATE-FORMATEE
           MOVE LIGNE-DATE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           
           PERFORM ECRIRE-LIGNE-VIDE
           
      * NUMERO DE COMMANDE
           MOVE EXT-O-NO TO LO-ORDER-NO
           MOVE LIGNE-ORDER TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           
      * DATE DE COMMANDE
           MOVE EXT-ODATE-ISO TO LOD-ORDER-DATE
           MOVE LIGNE-ORDER-DATE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           
           PERFORM ECRIRE-LIGNE-VIDE
           
      * CONTACT
           MOVE EXT-DNAME TO LC-DNAME
           MOVE EXT-LNAME TO LC-LNAME
           MOVE EXT-FNAME TO LC-FNAME
           MOVE LIGNE-CONTACT TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           
           PERFORM ECRIRE-LIGNE-VIDE
           PERFORM ECRIRE-LIGNE-VIDE
           
      * EN-TETE DU TABLEAU
           MOVE LIGNE-HEADER TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           
           MOVE LIGNE-SEPARATEUR TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           .
       
       ECRIRE-LIGNE-PRODUIT.
           MOVE EXT-P-NO TO LP-P-NO
           MOVE EXT-DESCRIPTION TO LP-DESCRIPTION
      * CONVERSION DES CHAMPS EDITES POUR L'AFFICHAGE
           MOVE EXT-QUANTITY TO WS-QUANTITY-WORK
           MOVE WS-QUANTITY-WORK TO LP-QUANTITY
           MOVE EXT-PRICE TO WS-PRICE-WORK
           MOVE WS-PRICE-WORK TO LP-PRICE
           MOVE EXT-LINE-TOTAL TO WS-LINE-TOTAL-WORK
           MOVE WS-LINE-TOTAL-WORK TO LP-LINE-TOTAL
           
           MOVE LIGNE-PRODUIT TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           .
       
       CALCULER-TOTAUX.
      * CALCUL DE LA TVA
           COMPUTE WS-TVA-AMOUNT = WS-ORDER-TOTAL * WS-TVA-RATE
           
      * CALCUL DE LA COMMISSION
           COMPUTE WS-COMMISSION-AMOUNT = WS-ORDER-TOTAL
                                                  * WS-COMMISSION-RATE
           
      * CALCUL DU TOTAL AVEC TAXES
           COMPUTE WS-TOTAL-WITH-TAXES = WS-ORDER-TOTAL
                                + WS-TVA-AMOUNT + WS-COMMISSION-AMOUNT
           .
       
       ECRIRE-TOTAUX.
           MOVE LIGNE-SEPARATEUR TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           
      * SOUS-TOTAL
           MOVE WS-ORDER-TOTAL TO LST-AMOUNT
           MOVE LIGNE-SOUS-TOTAL TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           
      * TVA
           MOVE WS-TVA-AMOUNT TO LT-AMOUNT
           MOVE LIGNE-TVA TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           
      * COMMISSION
           MOVE WS-COMMISSION-AMOUNT TO LC-AMOUNT
           MOVE LIGNE-COMMISSION TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           
           PERFORM ECRIRE-LIGNE-VIDE
           
      * TOTAL
           MOVE WS-TOTAL-WITH-TAXES TO LTO-AMOUNT
           MOVE LIGNE-TOTAL TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           .
       
       ECRIRE-LIGNE-FACTURE.
           WRITE FACTURE-RECORD
           IF WS-FACTURE-STATUS NOT = '00'
               DISPLAY "ERREUR ECRITURE FACTURE : ", WS-FACTURE-STATUS
               PERFORM ABEND-PROG
           END-IF
           .
       
       ECRIRE-LIGNE-VIDE.
           MOVE LIGNE-VIDE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           .
       
       ECRIRE-SAUT-PAGE.
      * ECRITURE DE QUELQUES LIGNES VIDES POUR SEPARATION
           PERFORM ECRIRE-LIGNE-VIDE
           PERFORM ECRIRE-LIGNE-VIDE
           PERFORM ECRIRE-LIGNE-VIDE
           PERFORM ECRIRE-LIGNE-VIDE
           PERFORM ECRIRE-LIGNE-VIDE
           .
       
       ABEND-PROG.
           DISPLAY "ARRET ANORMAL DU PROGRAMME"
           MOVE 16 TO RETURN-CODE
           GOBACK
           .