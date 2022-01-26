/*================================================================================================*/
/*                                                                                SyazwanH/030902 */
/* PVHEXEDTU                                                                                      */
/* File interface procedures.                                                                     */
/*                                                                                                */
/* Version 1 Release 2 Modification 4                                                             */
/*                                                                                                */
/*  Compile as module. Use with any external programs. Refer to procedures as prototype or        */
/*   bound modules.                                                                               */
/*                                                                                                */
/*                                                                                                */
/*================================================================================================*/
/* Maintenance Log                                                                                */
/* ---------------                                                                                */
/* Trace  Date      Pgmr.     Notes                                                               */
/* ---------------------------------------------------------------------------------------------- */
/*        20030902  SyazwanH  New.                                                                */
/*================================================================================================*/
/*------------------------------------------------------------------------------------------------*/
/* Global declarations                                                                            */
/*------------------------------------------------------------------------------------------------*/

 #include <stdio.h>
 #include <stdlib.h>
 #include <recio.h>
 #include <unistd.h>
 #include <errno.h>

 char fil[10];
 char lib[10];
 char mbr[10];
 char path[33];
 char onebyte[2];
 char alwblanks[2];
 char alwslash[1] = "/";
 char alwopen[1] = "(";
 char alwclose[1] = ")";

 int base_a = 0;
 int base_b = 0;
 int base_c = 0;
 int base_d = 0;
 int rtncode = 0;
 int orgsize = 0;
 int x = 0;
 int lastsize = 0;
 int maxsize_in = 0;
 int maxsize_out = 0;

 _RFILE *fp;
 _XXOPFB_T *opfb;
 _RIOFB_T *rfb;
 _XXIOFB_T *iofb;

 _RFILE *fpo;
 _XXOPFB_T *opfbo;
 _RIOFB_T *rfbo;
 _XXIOFB_T *iofbo;

/*------------------------------------------------------------------------------------------------*/
/* Routine pvOpenFile                                                                             */
/*   (File Name, Library Name, Member Name, Number of Records, Record Size, Reason Code)          */
/*------------------------------------------------------------------------------------------------*/

 void pvOpenFile (char *filname[10], char *libname[10], char *mbrname[10], int *nrec,
                  int *recsz, int *rsncode)
 {

    memset (&alwblanks[0], 0x40, 1);
    memset (&alwblanks[1], 0x00, 1);
    memset (&onebyte[1], 0x00, 1);
    memset (path, ' ', sizeof(path));
    memcpy (fil, *filname, sizeof(fil));
    memcpy (lib, *libname, sizeof(lib));
    memcpy (mbr, *mbrname, sizeof(mbr));

    for (x = 0; x < 10; x++)
    {
       memcpy (&onebyte[0], &lib[x], 1);
       if (strcmp (onebyte, alwblanks) == 0)
          break;
    }

    base_a = x;
    memcpy (&path[0], &lib[0], base_a);
    memcpy (&path[base_a], alwslash, 1);
    base_a += 1;

    for (x = 0; x < 10; x++)
    {
       memcpy (onebyte, &fil[x], 1);
       if (strcmp (onebyte, alwblanks) == 0)
          break;
    }

    base_b = x;
    memcpy (&path[base_a], &fil[0], base_b);
    x = (base_a + base_b);
    memcpy (&path[x], alwopen, 1);
    base_c = (x + 1);

    for (x = 0; x < 10; x++)
    {
       memcpy (onebyte, &mbr[x], 1);
       if (strcmp (onebyte, alwblanks) == 0)
          break;
    }

    base_d = x;
    memcpy (&path[base_c], &mbr[0], base_d);
    x = (base_c + base_d);
    memcpy (&path[x], alwclose, 1);
    x += 1;

    if (x < 33)
       memset (&path[x], 0x00, 33-x);

    if ((fp = _Ropen (path, "rr+, arrseq=Y")) == NULL)
    {
       *rsncode = errno;
       return;
    }

    opfb = _Ropnfbk (fp);

    *nrec = opfb->num_records;
    *recsz = opfb->pgm_record_len;
    maxsize_in = *recsz;

    *rsncode = 0;
    return;

 }

/*------------------------------------------------------------------------------------------------*/
/* Routine pvReadLast                                                                             */
/*   (Buffer, Buffer Size, Returned Size, RRN, Number of Records, Reason Code)                    */
/*------------------------------------------------------------------------------------------------*/

 void pvReadLast (char *buff[32767], int *buffsize, int *rtnsize, int *rrn, int *nrec,
                  int *rsncode)
 {

    orgsize = *buffsize;

    rfb = _Rreadl (fp, *buff, *buffsize, __NO_LOCK);
    iofb = _Riofbk (fp);

    *rrn = rfb->rrn;

    if (rfb->num_bytes < 0)
       *rtnsize = 0;
    else
       *rtnsize = rfb->num_bytes;

    if (*rtnsize < orgsize)
       *rsncode = errno;
    else
       *rsncode = 0;

    return;

 }

/*------------------------------------------------------------------------------------------------*/
/* Routine pvReadNext                                                                             */
/*   (Buffer, Buffer Size, Returned Size, RRN, Number of Records, Reason Code)                    */
/*------------------------------------------------------------------------------------------------*/

 void pvReadNext (char *buff[32767], int *buffsize, int *rtnsize, int *rrn, int *nrec,
                  int *rsncode)
 {

    orgsize = *buffsize;

    rfb = _Rreadn (fp, *buff, *buffsize, __NO_LOCK);
    iofb = _Riofbk (fp);

    *rrn = rfb->rrn;

    if (rfb->num_bytes < 0)
       *rtnsize = 0;
    else
       *rtnsize = rfb->num_bytes;

    if (*rtnsize < orgsize)
       *rsncode = errno;
    else
       *rsncode = 0;

    return;

 }

/*------------------------------------------------------------------------------------------------*/
/* Routine pvReadPrev                                                                             */
/*   (Buffer, Buffer Size, Returned Size, RRN, Number of Records, Reason Code)                    */
/*------------------------------------------------------------------------------------------------*/

 void pvReadPrev (char *buff[32767], int *buffsize, int *rtnsize, int *rrn, int *nrec,
                  int *rsncode)
 {

    orgsize = *buffsize;

    rfb = _Rreadp (fp, *buff, *buffsize, __NO_LOCK);
    iofb = _Riofbk (fp);

    *rrn = rfb->rrn;

    if (rfb->num_bytes < 0)
       *rtnsize = 0;
    else
       *rtnsize = rfb->num_bytes;

    if (*rtnsize < orgsize)
       *rsncode = errno;
    else
       *rsncode = 0;

    return;

 }

/*------------------------------------------------------------------------------------------------*/
/* Routine pvReadRrn                                                                              */
/*   (Buffer, Buffer Size, Returned Size, RRN, Number of Records, Reason Code)                    */
/*------------------------------------------------------------------------------------------------*/

 void pvReadRrn (char *buff[32767], int *buffsize, int *rtnsize, int *rrn, int *nrec,
                int *rsncode)
 {

    orgsize = *buffsize;

    rfb = _Rreadd (fp, *buff, *buffsize, __NO_LOCK, *rrn);
    iofb = _Riofbk (fp);

    *rrn = rfb->rrn;

    if (rfb->num_bytes < 0)
       *rtnsize = 0;
    else
       *rtnsize = rfb->num_bytes;

    if (*rtnsize < orgsize)
       *rsncode = errno;
    else
       *rsncode = 0;

    return;

 }

/*------------------------------------------------------------------------------------------------*/
/* Routine pvReadFirst                                                                            */
/*   (Buffer, Buffer Size, Returned Size, RRN, Number of Records, Reason Code)                    */
/*------------------------------------------------------------------------------------------------*/

 void pvReadFirst (char *buff[32767], int *buffsize, int *rtnsize, int *rrn, int *nrec,
                   int *rsncode)
 {

    orgsize = *buffsize;

    rfb = _Rreadf (fp, *buff, *buffsize, __NO_LOCK);
    iofb = _Riofbk (fp);

    *rrn = rfb->rrn;

    if (rfb->num_bytes < 0)
       *rtnsize = 0;
    else
       *rtnsize = rfb->num_bytes;

    if (*rtnsize < orgsize)
       *rsncode = errno;
    else
       *rsncode = 0;

    return;

 }

/*------------------------------------------------------------------------------------------------*/
/* Routine pvUpdate                                                                               */
/*   (Buffer, Buffer Size, Returned Size, RRN, Number of Records, Reason Code)                    */
/*------------------------------------------------------------------------------------------------*/

 void pvUpdate (char *buff[32767], int *buffsize, int *rtnsize, int *rrn, int *nrec,
                int *rsncode)
 {

    char *buffint[32767];
    int  buffintsize = *buffsize;

    rfb = _Rreads (fp, *buffint, buffintsize,  __DFT);
    rfb = _Rupdate (fp, *buff, *buffsize);
    iofb = _Riofbk (fp);

    if (rfb->num_bytes <= 0)
       *rtnsize = 0;
    else
       *rtnsize = rfb->num_bytes;

    if (*rtnsize <= 0)
       *rsncode = errno;
    else
       *rsncode = 0;

    return;

 }

/*------------------------------------------------------------------------------------------------*/
/* Routine pvDelete                                                                               */
/*   (Number of Records, Reason Code)                                                             */
/*------------------------------------------------------------------------------------------------*/

 void pvDelete (int *nrec, int *rsncode)
 {

    char *buffint[32767];
    int  buffintsize = maxsize_in;

    rfb = _Rreads (fp, *buffint, buffintsize,  __DFT);
    rfb = _Rdelete (fp);
    iofb = _Riofbk (fp);

    if (rfb->num_bytes <= 0)
       *rsncode = errno;
    else
       *rsncode = 0;

    return;

 }

/*------------------------------------------------------------------------------------------------*/
/* Routine pvReadSame                                                                             */
/*   (Buffer, Buffer Size, Returned Size, RRN, Number of Records, Reason Code)                    */
/*------------------------------------------------------------------------------------------------*/

 void pvReadSame (char *buff[32767], int *buffsize, int *rtnsize, int *rrn, int *nrec,
                  int *rsncode)
 {

    orgsize = *buffsize;

    rfb = _Rreads (fp, *buff, *buffsize, __NO_LOCK);
    iofb = _Riofbk (fp);

    *rrn = rfb->rrn;

    if (rfb->num_bytes < 0)
       *rtnsize = 0;
    else
       *rtnsize = rfb->num_bytes;

    if (*rtnsize < orgsize)
       *rsncode = errno;
    else
       *rsncode = 0;

    return;

 }

/*------------------------------------------------------------------------------------------------*/
/* Routine pvCloseFile                                                                            */
/*   (Reason Code)                                                                                */
/*------------------------------------------------------------------------------------------------*/

 void pvCloseFile (int *rsncode)
 {

    if ((rtncode = _Rclose (fp)) != 0)
    {
       *rsncode = errno;
       return;
    }

    *rsncode = 0;
    return;

 }

/*------------------------------------------------------------------------------------------------*/
/* Routine pvOpenOutput                                                                           */
/*   (File Name, Library Name, Member Name, Number of Records, Record Size, Reason Code)          */
/*------------------------------------------------------------------------------------------------*/

 void pvOpenOutput (char *filname[10], char *libname[10], char *mbrname[10], int *nrec,
                    int *recsz, int *rsncode)
 {

    memset (&alwblanks[0], 0x40, 1);
    memset (&alwblanks[1], 0x00, 1);
    memset (&onebyte[1], 0x00, 1);
    memset (path, ' ', sizeof(path));
    memcpy (fil, *filname, sizeof(fil));
    memcpy (lib, *libname, sizeof(lib));
    memcpy (mbr, *mbrname, sizeof(mbr));

    for (x = 0; x < 10; x++)
    {
       memcpy (&onebyte[0], &lib[x], 1);
       if (strcmp (onebyte, alwblanks) == 0)
          break;
    }

    base_a = x;
    memcpy (&path[0], &lib[0], base_a);
    memcpy (&path[base_a], alwslash, 1);
    base_a += 1;

    for (x = 0; x < 10; x++)
    {
       memcpy (onebyte, &fil[x], 1);
       if (strcmp (onebyte, alwblanks) == 0)
          break;
    }

    base_b = x;
    memcpy (&path[base_a], &fil[0], base_b);
    x = (base_a + base_b);
    memcpy (&path[x], alwopen, 1);
    base_c = (x + 1);

    for (x = 0; x < 10; x++)
    {
       memcpy (onebyte, &mbr[x], 1);
       if (strcmp (onebyte, alwblanks) == 0)
          break;
    }

    base_d = x;
    memcpy (&path[base_c], &mbr[0], base_d);
    x = (base_c + base_d);
    memcpy (&path[x], alwclose, 1);
    x += 1;

    if (x < 33)
       memset (&path[x], 0x00, 33-x);

    if ((fpo = _Ropen (path, "ar, arrseq=Y")) == NULL)
    {
       *rsncode = errno;
       return;
    }

    opfbo = _Ropnfbk (fpo);

    *nrec = opfbo->num_records;
    *recsz = opfbo->pgm_record_len;
    maxsize_out = *recsz;

    *rsncode = 0;
    return;

 }

/*------------------------------------------------------------------------------------------------*/
/* Routine pvOutput                                                                               */
/*   (Buffer, Buffer Size, Returned Size, RRN, Number of Records, Reason Code)                    */
/*------------------------------------------------------------------------------------------------*/

 void pvOutput (char *buff[32767], int *buffsize, int *rtnsize, int *rrn, int *nrec,
                int *rsncode)
 {

    if ((*buffsize > lastsize) && (*buffsize <= maxsize_out))
       lastsize = *buffsize;
    if ((lastsize == 0) && (*buffsize > maxsize_out))
       lastsize = maxsize_out;

    rfbo = _Rwrite (fpo, *buff, lastsize);
    iofbo = _Riofbk (fpo);

    if (rfbo->num_bytes <= 0)
       *rtnsize = 0;
    else
       *rtnsize = rfbo->num_bytes;

    if (*rtnsize <= 0)
       *rsncode = errno;
    else
       *rsncode = 0;

    if (*rsncode = 0)
       *rrn = rfbo->rrn;

    return;

 }

/*------------------------------------------------------------------------------------------------*/
/* Routine pvCloseOutput                                                                          */
/*   (Reason Code)                                                                                */
/*------------------------------------------------------------------------------------------------*/

 void pvCloseOutput (int *rsncode)
 {

    if ((rtncode = _Rclose (fpo)) != 0)
    {
       *rsncode = errno;
       return;
    }

    *rsncode = 0;
    return;

 }

