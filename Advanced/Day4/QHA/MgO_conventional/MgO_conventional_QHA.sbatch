#!/bin/bash
#SBATCH --partition=erba
#SBATCH --ntasks=10

#!/bin/bash
# Arguments passed through the -v qsub option:
# INPUTFILE ==> Crystal input file name
# NPROC ==> Number of processes requested

###################################################################
# GLOBAL VARIABLES
###################################################################

TMPDIR=/scratch/alessandro/tmp_p$$
#MPIBIN=/opt/openmpi-4.1.1-gnu/bin
MPIBIN=/opt/openmpi-2.1.0-icc/bin
here=$SLURM_SUBMIT_DIR
BINDIR=/home/erba/Mitoli/pub/bin/Linux-ifort_openmpi_i64_clut/std
CRYMPP=$BINDIR/Pcrystal
NODELISTLONG=`scontrol show hostnames $SLURM_JOB_NODELIST|sed s/\$/:$SLURM_CPUS_ON_NODE/g`
SLURMNODES=`scontrol show hostnames $SLURM_JOB_NODELIST`
#node[80-81]
#if [ $FULLNODES -gt 1 ]
#then
# NODE_INI=$( echo $SLURM_JOB_NODELIST | cut -c 6-7)
# NODE_END=$( echo $SLURM_JOB_NODELIST | cut -c 9-10)
#else
## NODE_INI=$( echo $SLURM_JOB_NODELIST | cut -c 5-6)
# NODE_END=$NODE_INI
##fi
#declare -a SLURMNODES
#i=0
#for n in $(seq $NODE_INI $NODE_END)
#do
# i=$(( i+1 ))
# SLURMNODES[$i]=$( echo "node$n" )
#done
if [ -e $here/$INPUTFILE.lista ]
then
  rm -rf $here/$INPUTFILE.lista
fi
for n in ${SLURMNODES[@]}
do
  echo "$n" >> $INPUTFILE.lista
done
for n in ${SLURMNODES[@]}
do
  scp -q $here/$INPUTFILE.lista ${n}:$TMPDIR/$INPUTFILE.lista
done

STARTHOST=`hostname`
LOGFILE=$here/$INPUTFILE.out
CRYJOBID=$( echo $SLURM_JOBID | cut -d '.' -f 1 )
###################################################################
# INIT SCRATCH FOLDERS
###################################################################

echo "creating temporary directory:" $TMPDIR ", on each node"
for  n in ${SLURMNODES[@]}
do
   ssh -n $n "mkdir -p $TMPDIR"
done
###################################################################
# COPY INPUT FILES TO WORKING NODES
###################################################################

echo "copying Pcrystal and the input file (INPUT) on each node"
for n in ${SLURMNODES[@]}
do
   scp -q $here/$INPUTFILE.d12 ${n}:$TMPDIR/INPUT
   scp -q $CRYMPP ${n}:$TMPDIR/Pcrystal-$CRYJOBID
done

cd $TMPDIR

if [ -e $here/$INPUTFILE.sopseud ] 
then
   for n in ${SLURMNODES[@]}
   do
      scp -q $here/$INPUTFILE.sopseud ${n}:$TMPDIR/SOPSEUD
   done
fi

if [ -e $here/$INPUTFILE.f20 ] 
then
   for n in ${SLURMNODES[@]}
   do
      scp -q $here/$INPUTFILE.f20 ${n}:$TMPDIR/fort.20
   done
fi

if [ -e $here/$INPUTFILE.f75 ]
then
   for n in ${SLURMNODES[@]}
   do
      scp -q $here/$INPUTFILE.f75 ${n}:$TMPDIR/fort.75
   done
fi

if [ -e $here/$INPUTFILE.f77 ]
then
   for n in ${SLURMNODES[@]}
   do
      scp -q $here/$INPUTFILE.f77 ${n}:$TMPDIR/fort.77
   done
fi

if [ -e $here/$INPUTFILE.f21 ]
then
   for n in ${SLURMNODES[@]}
   do
      scp -q $here/$INPUTFILE.f21 ${n}:$TMPDIR/fort.21
   done
fi

if [ -e $here/$INPUTFILE.f9 ]
then
   for n in ${SLURMNODES[@]}
   do
      scp -q $here/$INPUTFILE.f9 ${n}:$TMPDIR/fort.20
   done
fi

if [ -e $here/$INPUTFILE.f34 ]
then
   for n in ${SLURMNODES[@]}
   do
      scp -q $here/$INPUTFILE.f34 ${n}:$TMPDIR/fort.34
   done
fi

if [ -e $here/$INPUTFILE.f13 ]
then
   cp $here/$INPUTFILE.f13 fort.13
fi

if [ -e $here/$INPUTFILE.f80 ]
then
   cp $here/$INPUTFILE.f80 fort.80
fi

if [ -e $here/$INPUTFILE.freqinfo ]
then
  for n in ${SLURMNODES[@]}
  do
   scp -q $here/$INPUTFILE.freqinfo ${n}:$TMPDIR/FREQINFO.DAT 
  done 
fi

if [ -e $here/$INPUTFILE.vibpot ]
then
  for n in ${SLURMNODES[@]}
  do
   scp -q $here/$INPUTFILE.vibpot ${n}:$TMPDIR/VIBPOT.DAT
  done
fi

if [ -e $here/$INPUTFILE.born ]
then
  for n in ${SLURMNODES[@]}
  do
   scp -q $here/$INPUTFILE.born ${n}:$TMPDIR/BORN.DAT
  done
fi

if [ -e $here/$INPUTFILE.elasinfo ]
then
 for n in ${SLURMNODES[@]}
 do
   scp -q $here/$INPUTFILE.elasinfo ${n}:$TMPDIR/ELASINFO.DAT
 done
fi

if [ -e $here/$INPUTFILE.eosinfo ]
then
 for n in ${SLURMNODES[@]}
 do
   scp -q $here/$INPUTFILE.eosinfo ${n}:$TMPDIR/EOSINFO.DAT
 done
fi


if [ -e $here/$INPUTFILE.scanpes ]
then
   cp $here/$INPUTFILE.scanpes SCANPES.DAT 
fi

if [ -e $here/$INPUTFILE.anscan ]
then
   cp $here/$INPUTFILE.anscan ANSCAN.DAT 
fi

if [ -e $here/$INPUTFILE.opthess ]
then
   cp $here/$INPUTFILE.opthess OPTHESS.DAT 
fi

if [ -e $here/$INPUTFILE.born ]
then
  for n in ${SLURMNODES[@]}
  do
   scp -q $here/$INPUTFILE.born ${n}:$TMPDIR/BORN.DAT
  done
fi

if [ -e $here/$INPUTFILE.optinfo ]
then
  for n in ${SLURMNODES[@]}
  do
   scp -q $here/$INPUTFILE.optinfo ${n}:$TMPDIR/OPTINFO.DAT
  done
fi

if [ -e $here/$INPUTFILE.hessopt ]
then
  for n in ${SLURMNODES[@]}
  do
   scp -q $here/$INPUTFILE.hessopt ${n}:$TMPDIR/HESSOPT.DAT
  done
fi

# JEFF
if [ -e $here/$INPUTFILE.tensir ]
then
   cp $here/$INPUTFILE.tensir TENS_IR.DAT 
fi

if [ -e $here/$INPUTFILE.tensraman ]
then
   cp $here/$INPUTFILE.tensraman TENS_RAMAN.DAT 
fi
# JEFF

ln -s $here/$INPUTFILE.out2 SCFOUT.LOG
###################################################################
# START CRYSTAL WITH MPI
###################################################################

echo $CRYMPP &> $LOGFILE
echo $TMPDIR &>> $LOGFILE
echo "script started on $STARTHOST" &>> $LOGFILE
cat $here/$INPUTFILE.d12 &>> $LOGFILE
echo "************************************************" &>> $LOGFILE
echo "ANOTHER DROLLERY FILLED RUN OF THE CRYSTAL CODE!" &>> $LOGFILE
echo "************************************************" &>> $LOGFILE
date &>> $LOGFILE
$MPIBIN/mpirun -np $NPROC $TMPDIR/Pcrystal-$CRYJOBID &>> $LOGFILE
date &>> $LOGFILE

###################################################################
# COPY OUTPUT FILES BACK TO FRONTEND
###################################################################

if [ -e fort.34 ]
then
   cp fort.34 $here/$INPUTFILE.f34.n
fi

if [ -e fort.9 ]
then
   cp fort.9 $here/$INPUTFILE.f9
fi

if [ -e fort.20 ]
then
   cp fort.20 $here/$INPUTFILE.f20
fi

if [ -e OPTHESS.DAT ]
then
   cp OPTHESS.DAT $here/$INPUTFILE.opthess
fi

if [ -e OPTINFO.DAT ]
then
   cp OPTINFO.DAT $here/$INPUTFILE.optinfo
fi

if [ -e XMETRO.COR ]
then
   cp XMETRO.COR $here/$INPUTFILE.xmetro
fi 

if  [ -e BORN.DAT ]
then
   cp BORN.DAT $here/$INPUTFILE.born
fi

if [ -e ADP.DAT ]
then
   cp ADP.DAT $here/$INPUTFILE.adp
fi

if [ -e ELASINFO.DAT ]
then
   cp ELASINFO.DAT $here/$INPUTFILE.elasinfo
fi

if [ -e EOSINFO.DAT ]
then
   cp EOSINFO.DAT $here/$INPUTFILE.eosinfo
fi

if [ -e GEOMETRY.CIF ]
then
   cp GEOMETRY.CIF $here/$INPUTFILE.cif
fi


#if (-e SCFOUT.LOG) then
#   cp SCFOUT.LOG $here/$INPUTFILE.SCFOUT
#endif

if [ -e GAUSSIAN.DAT ]
then
   cp GAUSSIAN.DAT $here/$INPUTFILE.gjf
fi

if [ -e FINDSYM.DAT ]
then
   cp FINDSYM.DAT $here/$INPUTFILE.FINDSYM
fi

if [ -e optc001 ]
then
   mkdir $here/$INPUTFILE.optstory &> /dev/null
   cp optc* $here/$INPUTFILE.optstory/
fi

if [ -e fort.69 ]
then
   cp fort.69 $here/$INPUTFILE.f69
fi

if [ -e fort.98 ]
then
   cp fort.98 $here/$INPUTFILE.f98
fi

if [ -e fort.80 ]
then
   cp fort.80 $here/$INPUTFILE.f80
fi

if [ -e fort.13 ]
then
   cp fort.13 $here/$INPUTFILE.f13
fi
if [ -e fort.85 ]
then
   cp fort.85 $here/$INPUTFILE.f85
fi
if [ -e fort.90 ]
then
   cp fort.90 $here/$INPUTFILE.f90
fi
if [ -e fort.89 ]
then
   cp fort.89 $here/$INPUTFILE.f89
fi
if [ -e fort.21 ]
then
   cp fort.21 $here/$INPUTFILE.f21
fi
if [ -e fort.75 ]
then
   cp fort.75 $here/$INPUTFILE.f75
fi
if [ -e FREQINFO.DAT ]
then
   cp FREQINFO.DAT $here/$INPUTFILE.freqinfo
fi

if [ -e SCANPES.DAT ]
then
   cp SCANPES.DAT $here/$INPUTFILE.scanpes
fi

if [ -e ANSCAN.DAT ]
then
   cp ANSCAN.DAT $here/$INPUTFILE.anscan
fi

if [ -e VIBPOT.DAT ]
then
   cp VIBPOT.DAT $here/$INPUTFILE.vibpot
fi

#if(-e fort.24) then
#   cp fort.24 $here/$INPUTFILE.f24
#endif

if [ -e MOLDRAW.DAT ]
then
   cp MOLDRAW.DAT $here/$INPUTFILE.mol
fi

if [ -e fort.92 ]
then
   cp fort.92 $here/$INPUTFILE.com
fi

if [ -e fort.33 ]
then
   cp fort.33 $here/$INPUTFILE.xyz
fi

#### JEFF
if [ -e awesome.log ] 
then
   cp awesome.log $here/"$INPUTFILE"_awesome.log
fi

if [ -e awesome_1_xy.dat ] 
then
   cp awesome_1_xy.dat $here/"$INPUTFILE"_awesome_1_xy.dat
fi

if [ -e awesome_1_xz.dat ] 
then
   cp awesome_1_xz.dat $here/"$INPUTFILE"_awesome_1_xz.dat
fi

if [ -e awesome_1_yz.dat ] 
then
   cp awesome_1_yz.dat $here/"$INPUTFILE"_awesome_1_yz.dat
fi

if [ -e awesome_2_xy.dat ] 
then
   cp awesome_2_xy.dat $here/"$INPUTFILE"_awesome_2_xy.dat
fi

if [ -e awesome_2_xz.dat ] 
then
   cp awesome_2_xz.dat $here/"$INPUTFILE"_awesome_2_xz.dat
fi

if [ -e awesome_2_yz.dat ] 
then
   cp awesome_2_yz.dat $here/"$INPUTFILE"_awesome_2_yz.dat
fi

if [ -e awesome_l_xy.dat ] 
then
   cp awesome_l_xy.dat $here/"$INPUTFILE"_awesome_l_xy.dat
fi

if [ -e awesome_l_xz.dat ] 
then
   cp awesome_l_xz.dat $here/"$INPUTFILE"_awesome_l_xz.dat
fi

if [ -e awesome_l_yz.dat ] 
then
   cp awesome_l_yz.dat $here/"$INPUTFILE"_awesome_l_yz.dat
fi

if [ -e awesome_xy.dat ] 
then
   cp awesome_xy.dat $here/"$INPUTFILE"_awesome_xy.dat
fi

if [ -e awesome_xz.dat ] 
then
   cp awesome_xz.dat $here/"$INPUTFILE"_awesome_xz.dat
fi

if [ -e awesome_yz.dat ] 
then
   cp awesome_yz.dat $here/"$INPUTFILE"_awesome_yz.dat
fi

if [ -e awesome_lo.dat ] 
then
   cp awesome_lo.dat $here/"$INPUTFILE"_awesome_lo.dat
fi

if [ -e awesome_t1.dat ] 
then
   cp awesome_t1.dat $here/"$INPUTFILE"_awesome_t1.dat
fi

if [ -e awesome_t2.dat ] 
then
   cp awesome_t2.dat $here/"$INPUTFILE"_awesome_t2.dat
fi

if [ -e TENS_IR.DAT ]
then
   cp TENS_IR.DAT $here/$INPUTFILE.tensir
fi

if [ -e TENS_RAMAN.DAT ]
then
   cp TENS_RAMAN.DAT $here/$INPUTFILE.tensraman
fi

if [ -e IRSPEC.DAT ]
then
   cp IRSPEC.DAT $here/$INPUTFILE.irspec
fi

if [ -e RAMSPEC.DAT ]
then
   cp RAMSPEC.DAT $here/$INPUTFILE.ramspec
fi


#TO MAKE SCANMODE ACTIVATE
for  name in SCAN*DISP*; do
if [ -e "$name" ]
then
   mkdir $here/$INPUTFILE.scanstory &> /dev/null
   cp $name $here/$INPUTFILE.scanstory/
fi
done

#### JEFF

ls -l $TMPDIR &>> $LOGFILE
###################################################################
# REMOVE SCRATCH FOLDERS
###################################################################

echo "deleting temporary files from each node"
for n in ${SLURMNODES[@]}
do
  ssh -n $n "rm -rf $TMPDIR"
done

###################################################################
# EXIT
###################################################################

cd $here
exit
