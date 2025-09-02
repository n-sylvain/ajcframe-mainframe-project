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
           RECORD CONTAINS 281 CHARACTERS.
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
           05 EXT-COM               PIC 9V99.
           05 EXT-P-NO              PIC X(3).
           05 EXT-DESCRIPTION       PIC X(30).
           05 EXT-QUANTITY          PIC 9(2).
           05 EXT-PRICE             PIC 9(3)V99.
           05 EXT-LINE-TOTAL        PIC 9(5)V99.
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
      * TVA PAR DEFAUT A 20%
       77 WS-TVA-RATE               PIC 9V999 VALUE 0,200.
       77 WS-TVA-AMOUNT             PIC 9(7)V99 VALUE ZERO.
       77 WS-COMMISSION-RATE        PIC 9V99 VALUE 0,05.
       77 WS-COMMISSION-AMOUNT      PIC 9(7)V99 VALUE ZERO.
       77 WS-TOTAL-WITH-TAXES       PIC 9(7)V99 VALUE ZERO.
      
      * VARIABLES POUR LIRE LE TAUX DE TVA
       77 WS-TVA-INPUT              PIC X(10).
       77 WS-TVA-NUMERIC            PIC 9(2)V9.
       77 WS-ERROR-FLAG             PIC X VALUE 'N'.
           88 ERROR-OCCURRED        VALUE 'Y'.
       77 WS-TVA-PERCENT            PIC 9(2)V9.
      
      * VARIABLES DE TRAVAIL POUR LES CALCULS
       77 WS-LINE-TOTAL-WORK        PIC 9(7)V99.
       77 WS-PRICE-WORK             PIC 9(5)V99.
       77 WS-QUANTITY-WORK          PIC 9(2).
      
      * VARIABLES POUR LE FORMATAGE DE LA DATE
       77 WS-DATE-IN                PIC X(8) VALUE SPACES.
       77 WS-DATE-FORMATEE          PIC X(40).
      
      * LIGNES DE SORTIE FORMATEES - LARGEUR 119
       01 LIGNE-VIDE                PIC X(119) VALUE SPACES.
      
       01 LIGNE-CADRE-HAUT.
           05 FILLER                PIC X(1) VALUE '+'.
           05 FILLER                PIC X(117) VALUE ALL '-'.
           05 FILLER                PIC X(1) VALUE '+'.
      
       01 LIGNE-CADRE-BAS.
           05 FILLER                PIC X(1) VALUE '+'.
           05 FILLER                PIC X(117) VALUE ALL '-'.
           05 FILLER                PIC X(1) VALUE '+'.
      
       01 LIGNE-CADRE-ADRESSE-HAUT.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(78) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '+'.
           05 FILLER                PIC X(34) VALUE ALL '-'.
           05 FILLER                PIC X(1) VALUE '+'.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       01 LIGNE-ADRESSE.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(78) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(4) VALUE SPACES.
           05 LA-COMPANY            PIC X(27).
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       01 LIGNE-RUE.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(78) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(4) VALUE SPACES.
           05 LA-ADDRESS            PIC X(27).
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       01 LIGNE-VILLE.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(78) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(4) VALUE SPACES.
           05 LA-CITY               PIC X(20).
           05 FILLER                PIC X(2) VALUE ', '.
           05 LA-ZIP                PIC X(5).
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       01 LIGNE-STATE.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(78) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(4) VALUE SPACES.
           05 LA-STATE              PIC X(2).
           05 FILLER                PIC X(28) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       01 LIGNE-CADRE-ADRESSE-BAS.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(78) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '+'.
           05 FILLER                PIC X(34) VALUE ALL '-'.
           05 FILLER                PIC X(1) VALUE '+'.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       01 LIGNE-CADRE-VIDE.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(117) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       01 LIGNE-DATE.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(4) VALUE SPACES.
           05 LD-VILLE              PIC X(8) VALUE 'New York'.
           05 FILLER                PIC X(2) VALUE ', '.
           05 LD-DATE-FORMATEE      PIC X(40).
           05 FILLER                PIC X(63) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       01 LIGNE-ORDER.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(4) VALUE SPACES.
           05 FILLER                PIC X(16) VALUE 'Order Number : '.
           05 LO-ORDER-NO           PIC ZZZ.
           05 FILLER                PIC X(94) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       01 LIGNE-ORDER-DATE.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(4) VALUE SPACES.
           05 FILLER                PIC X(16) VALUE 'Order Date   : '.
           05 LOD-ORDER-DATE        PIC X(10).
           05 FILLER                PIC X(87) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       01 LIGNE-CONTACT.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(4) VALUE SPACES.
           05 FILLER                PIC X(35) VALUE
                                'Your contact within the department '.
           05 LC-DNAME              PIC X(20).
           05 FILLER                PIC X(3) VALUE ' : '.
           05 LC-LNAME              PIC X(20).
           05 FILLER                PIC X(2) VALUE ', '.
           05 LC-FNAME              PIC X(20).
           05 FILLER                PIC X(13) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       01 LIGNE-TABLEAU-HAUT.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '+'.
           05 FILLER                PIC X(109) VALUE ALL '-'.
           05 FILLER                PIC X(1) VALUE '+'.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       01 LIGNE-HEADER.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(2) VALUE SPACES.
           05 FILLER                PIC X(4) VALUE 'P_NO'.
           05 FILLER                PIC X(1) VALUE ' '.
           05 FILLER                PIC X(11) VALUE 'DESCRIPTION'.
           05 FILLER                PIC X(18) VALUE SPACES.
           05 FILLER                PIC X(8) VALUE 'QUANTITY'.
           05 FILLER                PIC X(4) VALUE SPACES.
           05 FILLER                PIC X(5) VALUE 'PRICE'.
           05 FILLER                PIC X(8) VALUE SPACES.
           05 FILLER                PIC X(10) VALUE 'LINE TOTAL'.
           05 FILLER                PIC X(38) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       01 LIGNE-PRODUIT.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(2) VALUE SPACES.
           05 LP-P-NO               PIC X(3).
           05 FILLER                PIC X(2) VALUE SPACES.
           05 LP-DESCRIPTION        PIC X(25).
           05 FILLER                PIC X(6) VALUE SPACES.
           05 LP-QUANTITY           PIC ZZ9.
           05 FILLER                PIC X(6) VALUE SPACES.
           05 LP-PRICE              PIC ZZZ,99.
           05 FILLER                PIC X(7) VALUE SPACES.
           05 LP-LINE-TOTAL         PIC Z(5),99.
           05 FILLER                PIC X(41) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       01 LIGNE-TABLEAU-BAS.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '+'.
           05 FILLER                PIC X(109) VALUE ALL '-'.
           05 FILLER                PIC X(1) VALUE '+'.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       01 LIGNE-SOUS-TOTAL.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(76) VALUE SPACES.
           05 FILLER                PIC X(21) VALUE
                                               'SUB TOTAL          : '.
           05 LST-AMOUNT            PIC ZZ.ZZZ,99.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(3) VALUE 'USD'.
           05 FILLER                PIC X(5) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       01 LIGNE-TVA.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(76) VALUE SPACES.
           05 FILLER                PIC X(11) VALUE 'SALES TAX ('.
           05 LT-PERCENT            PIC Z9,9.
           05 FILLER                PIC X(6) VALUE '%)  : '.
           05 LT-AMOUNT             PIC ZZ.ZZZ,99.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(3) VALUE 'USD'.
           05 FILLER                PIC X(5) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       01 LIGNE-COMMISSION.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(76) VALUE SPACES.
           05 FILLER                PIC X(12) VALUE 'COMMISSION ('.
           05 LC-COM                PIC 9,99.
           05 FILLER                PIC X(5) VALUE '%) : '.
           05 LC-AMOUNT             PIC ZZ.ZZZ,99.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(3) VALUE 'USD'.
           05 FILLER                PIC X(5) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       01 LIGNE-TOTAL.
           05 FILLER                PIC X(1) VALUE '|'.
           05 FILLER                PIC X(65) VALUE SPACES.
           05 FILLER                PIC X(32) VALUE
                                   'TOTAL (SUB TOTAL + SALES TAX) : '.
           05 LTO-AMOUNT            PIC ZZ.ZZZ,99.
           05 FILLER                PIC X(3) VALUE SPACES.
           05 FILLER                PIC X(3) VALUE 'USD'.
           05 FILLER                PIC X(5) VALUE SPACES.
           05 FILLER                PIC X(1) VALUE '|'.
      
       PROCEDURE DIVISION.
      
           DISPLAY "=== DEBUT GENERATION FACTURES ==="
      
      * OBTENIR LA DATE COURANTE FORMATEE
           PERFORM OBTENIR-DATE
      
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
      
       OBTENIR-DATE.
           CALL 'DATEFMT' USING BY REFERENCE WS-DATE-IN
                                BY REFERENCE WS-DATE-FORMATEE
           MOVE 'N' TO WS-ERROR-FLAG
           DISPLAY 'Date facture   : ' WS-DATE-FORMATEE
           .
      
       LIRE-TAUX-TVA.
      * LECTURE DU TAUX DE TVA DEPUIS SYSIN
           ACCEPT WS-TVA-INPUT FROM SYSIN
           DISPLAY "TVA LUE DEPUIS SYSIN: '", WS-TVA-INPUT, "'"
      
      * UTILISER FUNCTION NUMVAL POUR CONVERTIR CHAINE EN NUMERIQUE
           COMPUTE WS-TVA-NUMERIC = FUNCTION NUMVAL(WS-TVA-INPUT)
      
           IF WS-TVA-NUMERIC > 0
      * CONVERSION POURCENTAGE VERS DECIMALE
               COMPUTE WS-TVA-RATE = WS-TVA-NUMERIC / 100
               COMPUTE WS-TVA-PERCENT = WS-TVA-NUMERIC
               DISPLAY "TAUX TVA APPLIQUE : ", WS-TVA-NUMERIC, "%"
           ELSE
               SET ERROR-OCCURRED TO TRUE
               DISPLAY "ERREUR: TAUX HORS LIMITES (0-100%)"
           END-IF
      
      * EN CAS D'ERREUR, UTILISER 20% PAR DEFAUT
           IF ERROR-OCCURRED
               MOVE 0,200 TO WS-TVA-RATE
               MOVE 20 TO WS-TVA-PERCENT
               DISPLAY "UTILISATION DU TAUX PAR DEFAUT : 20%"
           END-IF
      
           DISPLAY "TAUX TVA FINAL UTILISE : ", WS-TVA-RATE
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
      
      * EN-TETE DE LA FACTURE AVEC CADRE
           MOVE LIGNE-CADRE-HAUT TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
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
      
      * FERMETURE DU CADRE
           MOVE LIGNE-CADRE-BAS TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
      * SAUT DE PAGE
           PERFORM ECRIRE-SAUT-PAGE
           .
      
       ECRIRE-ENTETE-FACTURE.
      * CADRE ADRESSE - HAUT
           MOVE LIGNE-CADRE-ADRESSE-HAUT TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
      * ADRESSE SOCIETE ENCADREE
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
      
      * CADRE ADRESSE - BAS
           MOVE LIGNE-CADRE-ADRESSE-BAS TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
           MOVE LIGNE-CADRE-VIDE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
      * DATE ET LIEU
           MOVE WS-DATE-FORMATEE TO LD-DATE-FORMATEE
           MOVE LIGNE-DATE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
           MOVE LIGNE-CADRE-VIDE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
      * NUMERO DE COMMANDE
           MOVE EXT-O-NO TO LO-ORDER-NO
           MOVE LIGNE-ORDER TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
      * DATE DE COMMANDE
           MOVE EXT-ODATE-ISO TO LOD-ORDER-DATE
           MOVE LIGNE-ORDER-DATE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
           MOVE LIGNE-CADRE-VIDE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
      * CONTACT
           MOVE EXT-DNAME TO LC-DNAME
           MOVE EXT-LNAME TO LC-LNAME
           MOVE EXT-FNAME TO LC-FNAME
           MOVE LIGNE-CONTACT TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
           MOVE LIGNE-CADRE-VIDE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
      * EN-TETE DU TABLEAU AVEC CADRE INTERNE
           MOVE LIGNE-TABLEAU-HAUT TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
           MOVE LIGNE-HEADER TO FACTURE-RECORD
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
      
      * UTILISER FUNCTION NUMVAL POUR CONVERTIR CHAINE COM EN NUMERIQUE
      *    COMPUTE WS-COMMISSION-RATE = FUNCTION NUMVAL(EXT-COM)
           MOVE EXT-COM TO WS-COMMISSION-RATE
      
      * CALCUL DE LA COMMISSION
           COMPUTE WS-COMMISSION-AMOUNT = WS-ORDER-TOTAL
                                                  * WS-COMMISSION-RATE
      
      * CALCUL DU TOTAL AVEC TAXES
           COMPUTE WS-TOTAL-WITH-TAXES = WS-ORDER-TOTAL
                                + WS-TVA-AMOUNT
           .
      
       ECRIRE-TOTAUX.
      * CADRE FERMETURE TABLEAU
           MOVE LIGNE-TABLEAU-BAS TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
           MOVE LIGNE-CADRE-VIDE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
      * SOUS-TOTAL
           MOVE WS-ORDER-TOTAL TO LST-AMOUNT
           MOVE LIGNE-SOUS-TOTAL TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
      * TVA AVEC POURCENTAGE
           MOVE WS-TVA-AMOUNT TO LT-AMOUNT
           MOVE WS-TVA-PERCENT TO LT-PERCENT
           MOVE LIGNE-TVA TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
      * COMMISSION
           MOVE EXT-COM TO LC-COM
           MOVE WS-COMMISSION-AMOUNT TO LC-AMOUNT
           MOVE LIGNE-COMMISSION TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
           MOVE LIGNE-CADRE-VIDE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
      
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
      
       ECRIRE-SAUT-PAGE.
      * ECRITURE DE QUELQUES LIGNES VIDES POUR SEPARATION
           MOVE LIGNE-VIDE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           MOVE LIGNE-VIDE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           MOVE LIGNE-VIDE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           MOVE LIGNE-VIDE TO FACTURE-RECORD
           PERFORM ECRIRE-LIGNE-FACTURE
           .
      
       ABEND-PROG.
           DISPLAY "ARRET ANORMAL DU PROGRAMME"
           MOVE 16 TO RETURN-CODE
           GOBACK
           .
