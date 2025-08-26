       IDENTIFICATION DIVISION.
       PROGRAM-ID. GENEFACT.
      *
      * PROGRAMME DE GENERATION DES FACTURES
      * PARTIE 3 - PROJET AJCFRAME
      * AUTEUR: SYLVAIN
      *
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
           
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      * Fichier d'extraction VSAM
           SELECT EXTRACT ASSIGN TO EXTRACT
           ORGANIZATION IS INDEXED
           ACCESS MODE IS SEQUENTIAL
           RECORD KEY IS EXT-KEY
           FILE STATUS IS WS-STATUS-EXT.
           
      * Fichier de sortie des factures
           SELECT FACTURES ASSIGN TO FACTURES
           ORGANIZATION IS SEQUENTIAL.
           
       DATA DIVISION.
       
       FILE SECTION.
       FD EXTRACT.
       01 ENR-EXTRACT.
          05 EXT-KEY.
             10 EXT-O-NO         PIC 9(3).
          05 EXT-O-DATE          PIC X(10).
          05 EXT-S-NO            PIC 9(2).
          05 EXT-C-NO            PIC 9(4).
          05 EXT-COMPANY         PIC X(30).
          05 EXT-ADDRESS         PIC X(100).
          05 EXT-CITY            PIC X(20).
          05 EXT-STATE           PIC X(2).
          05 EXT-ZIP             PIC X(5).
          05 EXT-DEPT            PIC 9(4).
          05 EXT-DNAME           PIC X(20).
          05 EXT-LNAME           PIC X(20).
          05 EXT-FNAME           PIC X(20).
          05 EXT-P-NO            PIC X(3).
          05 EXT-DESCRIPTION     PIC X(30).
          05 EXT-QUANTITY        PIC 9(2).
          05 EXT-PRICE           PIC 9(3)V99.
          
       FD FACTURES.
       01 ENR-FACTURES         PIC X(80).
       
       WORKING-STORAGE SECTION.
       
      * FLAGS DE STATUT
       77 WS-STATUS-EXT        PIC XX.
       77 WS-FLAG-EXTRACT      PIC 9 VALUE ZERO.
          88 NFF-EXTRACT       VALUE 0.
          88 FF-EXTRACT        VALUE 1.
          
      * TAUX TVA LU DEPUIS SYSIN
       77 WS-TAUX-TVA          PIC 9V999.
       
      * VARIABLES DE CONTROLE
       01 WS-COMMANDE-COURANTE PIC 9(3) VALUE ZERO.
       01 WS-PREMIERE-LIGNE    PIC X VALUE 'O'.
          88 PREMIERE-LIGNE    VALUE 'O'.
          88 PAS-PREMIERE      VALUE 'N'.
          
      * TOTAUX PAR FACTURE
       01 WS-TOTAUX.
          05 WS-SUB-TOTAL      PIC 9(6)V99 VALUE ZERO.
          05 WS-SALES-TAX      PIC 9(6)V99 VALUE ZERO.
          05 WS-COMMISSION     PIC 9(6)V99 VALUE ZERO.
          05 WS-TOTAL          PIC 9(6)V99 VALUE ZERO.
          05 WS-LINE-TOTAL     PIC 9(5)V99 VALUE ZERO.
          
      * VARIABLES POUR DATEUTIL
       77 WS-DATE-FORMATEE     PIC X(50).
       
      * LIGNES DE FACTURE
       01 L-EN-TETE-1          PIC X(80)
          VALUE 'COMPANY'.
       01 L-EN-TETE-2          PIC X(80)
          VALUE 'ADDRESS'.
       01 L-EN-TETE-3          PIC X(80)
          VALUE 'CITY, ZIP'.
       01 L-EN-TETE-4          PIC X(80)
          VALUE 'STATE'.
       01 L-VIDE               PIC X(80) VALUE SPACES.
       
       01 L-DATE.
          05 FILLER            PIC X(50).
          
       01 L-NUMERO-COMMANDE.
          05 FILLER            PIC X(5) VALUE SPACES.
          05 L-O-NO            PIC 9(3).
          
       01 L-DATE-COMMANDE.
          05 FILLER            PIC X(5) VALUE SPACES.
          05 L-O-DATE          PIC X(10).
          
       01 L-CONTACT.
          05 FILLER            PIC X(40) 
             VALUE 'Your contact within the department '.
          05 L-DNAME           PIC X(20).
          05 FILLER            PIC X(3) VALUE ' : '.
          05 L-LNAME           PIC X(20).
          05 FILLER            PIC X(2) VALUE ', '.
          05 L-FNAME           PIC X(20).
          
       01 L-HEADER-LIGNE.
          05 FILLER            PIC X(80)
             VALUE 'P_NO   DESCRIPTION         QUANTITY   PRICE      L
      -      'INE TOTAL'.
          
       01 L-SEPARATEUR.
          05 FILLER            PIC X(80)
             VALUE '----   -----------         --------   -----      -
      -      '---------'.
             
       01 L-DETAIL-PRODUIT.
          05 L-DET-P-NO        PIC X(3).
          05 FILLER            PIC X(4) VALUE SPACES.
          05 L-DET-DESC        PIC X(20).
          05 FILLER            PIC X(7) VALUE SPACES.
          05 L-DET-QTY         PIC ZZ9.
          05 FILLER            PIC X(6) VALUE SPACES.
          05 L-DET-PRICE       PIC ZZ9,99.
          05 FILLER            PIC X(8) VALUE SPACES.
          05 L-DET-LTOTAL      PIC ZZZ,99.
          
       01 L-SEP-TOTAUX         PIC X(80)
          VALUE '                                                      
      -    '----------'.
          
       01 L-SUB-TOTAL.
          05 FILLER            PIC X(36) VALUE SPACES.
          05 FILLER            PIC X(9) VALUE 'SUB TOTAL'.
          05 FILLER            PIC X(4) VALUE SPACES.
          05 L-ST-MONTANT      PIC ZZZZ,99.
          
       01 L-SALES-TAX.
          05 FILLER            PIC X(36) VALUE SPACES.
          05 FILLER            PIC X(9) VALUE 'SALES TAX'.
          05 FILLER            PIC X(5) VALUE SPACES.
          05 L-TAX-MONTANT     PIC ZZZ,99.
          
       01 L-COMMISSION.
          05 FILLER            PIC X(36) VALUE SPACES.
          05 FILLER            PIC X(10) VALUE 'COMMISSION'.
          05 FILLER            PIC X(5) VALUE SPACES.
          05 L-COM-MONTANT     PIC ZZ,99.
          
       01 L-TOTAL-FINAL.
          05 FILLER            PIC X(36) VALUE SPACES.
          05 FILLER            PIC X(5) VALUE 'TOTAL'.
          05 FILLER            PIC X(8) VALUE SPACES.
          05 L-TOT-MONTANT     PIC ZZZZ,99.
          
       PROCEDURE DIVISION.
       
       MAIN-PROCESS.
      * Lecture du taux TVA depuis SYSIN
           ACCEPT WS-TAUX-TVA
           
      * Ouverture des fichiers
           OPEN INPUT EXTRACT
           OPEN OUTPUT FACTURES
           
      * Traitement principal
           PERFORM LECT-EXTRACT
           PERFORM UNTIL FF-EXTRACT
               IF EXT-O-NO NOT = WS-COMMANDE-COURANTE
                  IF WS-COMMANDE-COURANTE NOT = ZERO
                     PERFORM FINALISER-FACTURE
                  END-IF
                  PERFORM DEBUTER-FACTURE
               END-IF
               PERFORM TRAITER-LIGNE-PRODUIT
               PERFORM LECT-EXTRACT
           END-PERFORM
           
      * Finaliser la dernière facture
           IF WS-COMMANDE-COURANTE NOT = ZERO
              PERFORM FINALISER-FACTURE
           END-IF
           
      * Fermeture
           CLOSE EXTRACT FACTURES
           STOP RUN.
           
       LECT-EXTRACT.
           READ EXTRACT
               AT END SET FF-EXTRACT TO TRUE
           END-READ.
           
       DEBUTER-FACTURE.
      * Initialiser pour nouvelle facture
           MOVE EXT-O-NO TO WS-COMMANDE-COURANTE
           SET PREMIERE-LIGNE TO TRUE
           INITIALIZE WS-TOTAUX
           
      * En-tête de facture avec données client
           MOVE EXT-COMPANY TO L-EN-TETE-1
           MOVE EXT-ADDRESS TO L-EN-TETE-2
           STRING EXT-CITY DELIMITED BY SPACE
                  ', ' DELIMITED BY SIZE
                  EXT-ZIP DELIMITED BY SIZE
           INTO L-EN-TETE-3
           MOVE EXT-STATE TO L-EN-TETE-4
           
      * Écriture en-tête
           WRITE ENR-FACTURES FROM L-EN-TETE-1
           WRITE ENR-FACTURES FROM L-EN-TETE-2
           WRITE ENR-FACTURES FROM L-EN-TETE-3
           WRITE ENR-FACTURES FROM L-EN-TETE-4
           WRITE ENR-FACTURES FROM L-VIDE
           
      * Date formatée
           CALL 'DATEUTIL' USING EXT-O-DATE WS-DATE-FORMATEE
           MOVE WS-DATE-FORMATEE TO L-DATE
           WRITE ENR-FACTURES FROM L-DATE
           WRITE ENR-FACTURES FROM L-VIDE
           
      * Numéro et date de commande
           MOVE EXT-O-NO TO L-O-NO
           WRITE ENR-FACTURES FROM L-NUMERO-COMMANDE
           MOVE EXT-O-DATE TO L-O-DATE
           WRITE ENR-FACTURES FROM L-DATE-COMMANDE
           WRITE ENR-FACTURES FROM L-VIDE
           
      * Contact
           MOVE EXT-DNAME TO L-DNAME
           MOVE EXT-LNAME TO L-LNAME
           MOVE EXT-FNAME TO L-FNAME
           WRITE ENR-FACTURES FROM L-CONTACT
           WRITE ENR-FACTURES FROM L-VIDE
           
      * Header des produits
           WRITE ENR-FACTURES FROM L-HEADER-LIGNE
           WRITE ENR-FACTURES FROM L-SEPARATEUR.
           
       TRAITER-LIGNE-PRODUIT.
      * Calcul line total
           COMPUTE WS-LINE-TOTAL = EXT-QUANTITY * EXT-PRICE
           ADD WS-LINE-TOTAL TO WS-SUB-TOTAL
           
      * Formatage ligne produit
           MOVE EXT-P-NO TO L-DET-P-NO
           MOVE EXT-DESCRIPTION TO L-DET-DESC
           MOVE EXT-QUANTITY TO L-DET-QTY
           MOVE EXT-PRICE TO L-DET-PRICE
           MOVE WS-LINE-TOTAL TO L-DET-LTOTAL
           
           WRITE ENR-FACTURES FROM L-DETAIL-PRODUIT.
           
       FINALISER-FACTURE.
      * Calculs finaux
           COMPUTE WS-SALES-TAX = WS-SUB-TOTAL * WS-TAUX-TVA
           COMPUTE WS-COMMISSION = WS-SUB-TOTAL * 0,099
           COMPUTE WS-TOTAL = WS-SUB-TOTAL + WS-SALES-TAX + WS-COMMISSION
           
      * Écriture totaux
           WRITE ENR-FACTURES FROM L-SEP-TOTAUX
           MOVE WS-SUB-TOTAL TO L-ST-MONTANT
           WRITE ENR-FACTURES FROM L-SUB-TOTAL
           MOVE WS-SALES-TAX TO L-TAX-MONTANT
           WRITE ENR-FACTURES FROM L-SALES-TAX
           MOVE WS-COMMISSION TO L-COM-MONTANT
           WRITE ENR-FACTURES FROM L-COMMISSION
           WRITE ENR-FACTURES FROM L-SEP-TOTAUX
           MOVE WS-TOTAL TO L-TOT-MONTANT
           WRITE ENR-FACTURES FROM L-TOTAL-FINAL
           
      * Séparateur de fin
           WRITE ENR-FACTURES FROM L-VIDE
           WRITE ENR-FACTURES FROM L-VIDE.