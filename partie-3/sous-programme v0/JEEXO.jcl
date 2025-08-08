//API8EFAC JOB (ACCT#),'FACTURE',CLASS=A,MSGCLASS=H,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID,REGION=4M,TIME=(,30),COND=(8,LT)
//****************************************************************
//* EXECUTION DU PROGRAMME FACTURE                              *
//****************************************************************
//STEP01   EXEC PGM=FACTURE
//STEPLIB  DD DSN=API8.COBOL.LOAD,DISP=SHR
//SYSOUT   DD SYSOUT=*