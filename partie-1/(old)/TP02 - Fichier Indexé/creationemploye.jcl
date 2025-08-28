//API8D17  JOB (ACCT#),'SYLVAIN',CLASS=A,MSGCLASS=H,MSGLEVEL=(1,1), 
//             NOTIFY=&SYSUID,REGION=4M,TIME=(,30),COND=(8,LT) 
//* SUPPRIMER LE FICHIER API8.AJC.EMPLOYE.ESDS              * 
//*********************************************************** 
//SUPPESDS EXEC PGM=IDCAMS 
//SYSPRINT DD SYSOUT=* 
//SYSIN    DD * 
 DELETE API8.AJC.EMPLOYE.ESDS 
/* 
//* CREATION DU FICHIER API8.AJC.EMPLOYE.ESDS               * 
//*********************************************************** 
//CREESDS  EXEC PGM=IDCAMS 
//SYSPRINT DD SYSOUT=* 
//SYSIN    DD * 
 DEFINE CLUSTER (NAME(API8.AJC.EMPLOYE.ESDS)  - 
                    VOLUME(APIWK2)            - 
                    TRACKS(3 2)               - 
                    FREESPACE(20 20)          - 
                    RECORDSIZE(70 70)         - 
                    NONINDEXED)               - 
            DATA (NAME(API8.AJC.EMPLOYE.ESDS.DATA)) 
/* 
//* ALIMENTATION DU FICHIER API8.AJC.EMPLOYE.ESDS           * 
//*     A PARTIR DU FICHIER API8.AJC.EMPLOYE.DATA           * 
//*********************************************************** 
//ALIMESDS EXEC PGM=IDCAMS 
//SYSPRINT DD SYSOUT=* 
//DDIN     DD DSN=API8.AJC.EMPLOYE.DATA,DISP=SHR 
//DDOUT    DD DSN=API8.AJC.EMPLOYE.ESDS,DISP=SHR 
//SYSIN    DD * 
 REPRO INFILE(DDIN)  - 
       OUTFILE(DDOUT) 
 PRINT INDATASET(API8.AJC.EMPLOYE.DATA) CHAR 
 PRINT INDATASET(API8.AJC.EMPLOYE.ESDS) CHAR 
/* 