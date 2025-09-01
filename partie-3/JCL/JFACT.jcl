//API6FACT JOB (ACCT#),'FACTURE',MSGCLASS=H,REGION=4M,
//    CLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID,COND=(4,LT)
//****************************************************************
//* ETAPE DE COMPILATION DU SOUS-PROGRAMME DATEFMT               *
//****************************************************************
//COMPIL   EXEC IGYWCL,PARM.COBOL=(NODYNAM,ADV,OBJECT,LIB,TEST,APOST)
//COBOL.SYSIN  DD DSN=API6.SOURCE.COBOL(DATEFMT),DISP=SHR
//COBOL.SYSLIB DD DSN=CEE.SCEESAMP,DISP=SHR
//****************************************************************
//* ETAPE DE LINKEDIT                                            *
//****************************************************************
//LKED.SYSLMOD DD DSN=API6.COBOL.LOAD,DISP=(SHR,KEEP,KEEP)
//LKED.SYSIN DD *
 NAME DATEFMT(R)
/*
//****************************************************************
//* ETAPE DE COMPILATION DU PROGRAMME PRINCIPAL FACTURE          *
//****************************************************************
//COMPIL   EXEC IGYWCL,PARM.COBOL=(ADV,OBJECT,LIB,TEST,APOST)
//COBOL.SYSIN  DD DSN=API6.SOURCE.COBOL(FACTURE),DISP=SHR
//COBOL.SYSLIB DD DSN=CEE.SCEESAMP,DISP=SHR
//****************************************************************
//* ETAPE DE LINKEDIT                                            *
//****************************************************************
//LKED.SYSLIB  DD DSN=API6.COBOL.LOAD,DISP=SHR
//             DD DSN=CEE.SCEELKED,DISP=SHR
//LKED.SYSLMOD DD DSN=API6.COBOL.LOAD,DISP=(SHR,KEEP,KEEP)
//LKED.SYSIN DD *
 INCLUDE SYSLIB('DATEFMT')
 NAME FACTURE(R)
/*
//****************************************************************
//* SUPPRESSION DU FICHIER FACTURES.DATA                         *
//****************************************************************
//DELETE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DELETE API6.PROJET.FACTURES.DATA
/*
//****************************************************************
//* EXECUTION DU PROGRAMME GENERATEUR DE FACTURES                *
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
