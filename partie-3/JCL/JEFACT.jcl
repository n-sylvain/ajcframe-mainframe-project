//API6EFAC JOB (ACCT#),'FACTURE',CLASS=A,MSGCLASS=H,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID,REGION=4M,TIME=(,30),COND=(8,LT)
//****************************************************************
//* SUPPRESION DES ANCIENNES FACTURES                           *
//****************************************************************
//DELETE   EXEC PGM=IEFBR14
//DELDD    DD  DSN=API6.PROJET.FACTURES.DATA,
//             DISP=(MOD,DELETE,DELETE)
//****************************************************************
//* EXECUTION DU PROGRAMME GENERATEUR DE FACTURES               *
//****************************************************************
//STEP01   EXEC PGM=FACTURE
//STEPLIB  DD DSN=API6.COBOL.LOAD,DISP=SHR
//EXTRACT  DD DSN=API6.PROJET.EXTRACT.DATA,DISP=SHR
//FACTURES DD DSN=API6.PROJET.FACTURES.DATA,DISP=(NEW,CATLG),
//             UNIT=SYSDA,SPACE=(TRK,(10,5)),
//             DCB=(RECFM=FB,LRECL=132,BLKSIZE=6600)
//SYSIN DD *
20,0
/*
//* PAR EXEMPLE 20   9,9   5,5
//SYSOUT   DD SYSOUT=*
