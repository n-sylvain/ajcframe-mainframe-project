//API4KSDS JOB (ACCT#),'DENIS',CLASS=A,MSGCLASS=H,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID,REGION=4M,TIME=(,30),COND=(8,LT)
//* SUPPRIMER LE FICHIER API4.AJC.EMPLOYE.KSDS                  *
//****************************************************************
//SUPPKSDS EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DELETE API4.AJC.EMPLOYE.KSDS
/*
//* CREATION DU FICHIER API4.AJC.EMPLOYE.KSDS                   *
//****************************************************************
//CREKSDS  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DEFINE CLUSTER (NAME(API4.AJC.EMPLOYE.KSDS)  -
                    VOLUME(APIWK2)            -
                    TRACKS(3 2)               -
                    FREESPACE(20 20)          -
                    KEYS(5 0)                 -
                    RECORDSIZE(70 70)         -
                    INDEXED)                  -
           DATA (NAME(API4.AJC.EMPLOYE.KSDS.D)) -
          INDEX (NAME(API4.AJC.EMPLOYE.KSDS.I))
/*
//* ALIMENTATION  DU FICHIER API4.AJC.EMPLOYE.KSDS              *
//*     A PARTIR  DU FICHIER API4.AJC.EMPLOYE.DATA              *
//****************************************************************
//ALIMKSDS EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//INFILE   DD DSN=API4.AJC.EMPLOYE.DATA,DISP=SHR
//OUTFILE  DD DSN=API4.AJC.EMPLOYE.KSDS,DISP=OLD
//SYSIN    DD *
 REPRO INFILE(INFILE)  -
       OUTFILE(OUTFILE)
/*
//* AFFICHAGE   DU FICHIER API4.AJC.EMPLOYE.DATA               *
//*          ET DU FICHIER API4.AJC.EMPLOYE.KSDS               *
//AFFICHE  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 PRINT INDATASET(API4.AJC.EMPLOYE.DATA) CHAR
 PRINT INDATASET(API4.AJC.EMPLOYE.KSDS) CHAR
/*
//* SUPPRIMER LE API4.PROJET.NEWPARTS.KSDS                      *
//****************************************************************
//SUPPKS   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DELETE API4.PROJET.NEWPARTS.KSDS
/*

//* CREATION DU FICHIER API4.PROJET.NEWPARTS.KSDS               *
//****************************************************************
//CREKSDS2  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DEFINE CLUSTER (NAME(API4.PROJET.NEWPARTS.KSDS)  -
                    VOLUME(APIWK2)            -
                    TRACKS(3 2)               -
                    FREESPACE(20 20)          -
                    KEYS(2 0)                 -
                    RECORDSIZE(74 74)         -
                    INDEXED)                  -
           DATA (NAME(API4.PROJET.NEWPARTS.KSDS.D)) -
          INDEX (NAME(API4.PROJET.NEWPARTS.KSDS.I))
/*
