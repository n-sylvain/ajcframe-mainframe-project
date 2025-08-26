//API8ETP8   JOB (ACCT#),'SYLVAIN',CLASS=A,MSGCLASS=H,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID,REGION=4M,TIME=(,30),COND=(8,LT)
//****************************************************************
//* SUPPRIMER LE FICHIER API8.AJC.RESULTAT.DATA                 *
//****************************************************************
//SUPPKSDS EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DELETE API8.AJC.RESULTAT.DATA
/*
//****************************************************************
//* EXECUTION DU PROGRAMME API8.SOURCE.COBOL(TP08)
//****************************************************************
//STEP01   EXEC PGM=TP08
//STEPLIB  DD DSN=API8.COBOL.LOAD,DISP=SHR
//FSTUDENT DD DSN=API8.AJC.STUDENTS.DATA,DISP=SHR
//RESULTAT DD DSN=API8.AJC.RESULTAT.DATA,DISP=(NEW,CATLG,DELETE),
//         DCB=(LRECL=40,RECFM=FB,BLKSIZE=400),
//         SPACE=(TRK,(2,3),RLSE)
//SYSOUT   DD SYSOUT=*