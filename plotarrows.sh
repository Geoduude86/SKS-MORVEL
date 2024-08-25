#!/bin/sh
# convert matlab output to lat lon and plot arrows and ellipses for chosen plate
# inputs: xysites${plate}, xyvend${plate}, xyellip${plate}, v_95${plate}cm from MATLAB function
#	  azveloTP from old MATLAB veloc (incorporate into new)
# modified 11/10/14 by David C. Mathews

read -p "SKS-MORVEL plate (two-letter abbreviation): " plate
read -p "velocities: overriding plate, trench perpendicular, both?(o/t/b): " arrowchoice
if [ "$arrowchoice" = "o" ] || [ "$arrowchoice" = "b" ]; then
  read -p "1D or 2D or 3D ellipses or all?(1/2/3/a): " edim
  if [ "$edim" = 1 ]; then ellipplot='1'
  elif [ "$edim" = 2 ]; then ellipplot='2'
  elif [ "$edim" = 3 ]; then ellipplot='3'
  elif [ "$edim" = "a" ]; then ellipplot='A'
  else echo "error: enter 1 2 3 or a"; exit
  fi
fi
if [ "$arrowchoice" = "t" ]; then plotsuffix='vtp'
elif [ "$arrowchoice" = "o" ]; then plotsuffix='oplt'${ellipplot}
elif [ "$arrowchoice" = "b" ]; then plotsuffix='both'${ellipplot}
else echo "error: enter o t or b"; exit
fi
if [ "$plate" = "HKKE" ]; then fignumber='10'
elif [ "$plate" = "MA" ]; then fignumber='11'
elif [ "$plate" = "IA" ]; then fignumber='12'
elif [ "$plate" = "CVSV" ]; then fignumber='XX'
elif [ "$plate" = "GL" ]; then fignumber='2'
else echo "error: enter a valid plate (HKKE, MA, IA, CVSV, GL(global))"; exit
fi

plot=./plots/fig${fignumber}_arrows${plate}${plotsuffix}_$(date +"_%m%d%y").ps
disp=y
gmtset D_FORMAT=%.4g
#U=-U
#arrowwidth/headlength/headwidth
headlength=0.24c tinyheadlength=0.18c
headwidthsks=0.125c headwidthsch=0.150c
arrowsizesks=0.15c/0.48c/0.24c arrowsizesch=0.24c/0.48c/0.24c
arrowsizeGLsks=0.06c/${headlength}/${headwidthsks} arrowsizeGLsch=0.12c/${headlength}/${headwidthsks}
smallarrowsks=0c/${headlength}/${headwidthsks} smallarrowsch=0c/${headlength}/${headwidthsks}
tinyarrowsks=0c/${tinyheadlength}/0.09c tinyarrowsch=0c/${tinyheadlength}/0.11c
#linewidth,color,style[dash,dot]
dashedarrowsks=1.0p,blue dashedarrowsch=1.0p,red
ellip1Dpen=1.0p,blue ellip2Dpen=1.0p,blue,- ellip3Dpen=1.0p,blue,.

#INPUTS:
if [ "$plate" = "HKKE" ]; then
  cat ./outGinM/HK/llsitesHK ./outGinM/KE/llsitesKE > ./outGinM/${plate}/llsites${plate}
  cat ./outGinM/HK/xysitesHK ./outGinM/KE/xysitesKE > ./outGinM/${plate}/xysites${plate}
  cat ./outMinG/HK/xyvendHKsks ./outMinG/KE/xyvendKEsks > ./outMinG/${plate}/xyvend${plate}sks
  cat ./outMinG/HK/xyvendHKsch ./outMinG/KE/xyvendKEsch > ./outMinG/${plate}/xyvend${plate}sch
  paste ./outMinG/HK/xyellipHK1D ./outMinG/KE/xyellipKE1D > ./outMinG/${plate}/xyellip${plate}1D
  paste ./outMinG/HK/xyellipHK2D ./outMinG/KE/xyellipKE2D > ./outMinG/${plate}/xyellip${plate}2D
  paste ./outMinG/HK/xyellipHK3D ./outMinG/KE/xyellipKE3D > ./outMinG/${plate}/xyellip${plate}3D
  cat ./outMinG/HK/v_1D95HKcm ./outMinG/KE/v_1D95KEcm > ./outMinG/${plate}/v_1D95${plate}cm
  cat ./outGinG/HK/llazvtpHKsksCM ./outGinG/KE/llazvtpKEsksCM > ./outGinG/${plate}/llazvtp${plate}sksCM
  cat ./outGinG/HK/llazvtpHKschCM ./outGinG/KE/llazvtpKEschCM > ./outGinG/${plate}/llazvtp${plate}schCM
  cat ./outGinM/KE/scaleKE > ./outGinM/${plate}/scale${plate}
elif [ "$plate" = "CVSV" ]; then
  cat ./outGinM/CV/llsitesCV ./outGinM/SV/llsitesSV > ./outGinM/${plate}/llsites${plate}
  cat ./outGinM/CV/xysitesCV ./outGinM/SV/xysitesSV > ./outGinM/${plate}/xysites${plate}
  cat ./outMinG/CV/xyvendCVsks ./outMinG/SV/xyvendSVsks > ./outMinG/${plate}/xyvend${plate}sks
  cat ./outMinG/NH/xyvendNHsch > ./outMinG/${plate}/xyvend${plate}sch
  paste ./outMinG/CV/xyellipCV1D ./outMinG/SV/xyellipSV1D > ./outMinG/${plate}/xyellip${plate}1D
  paste ./outMinG/CV/xyellipCV2D ./outMinG/SV/xyellipSV2D > ./outMinG/${plate}/xyellip${plate}2D
  paste ./outMinG/CV/xyellipCV3D ./outMinG/SV/xyellipSV3D > ./outMinG/${plate}/xyellip${plate}3D
  cat ./outMinG/CV/v_1D95CVcm ./outMinG/SV/v_1D95SVcm > ./outMinG/${plate}/v_1D95${plate}cm
  cat ./outGinG/CV/llazvtpCVsksCM ./outGinG/SV/llazvtpSVsksCM > ./outGinG/${plate}/llazvtp${plate}sksCM
  cat ./outGinG/NH/llazvtpNHschCM > ./outGinG/${plate}/llazvtp${plate}schCM
  cat ./outGinM/CV/scaleCV > ./outGinM/${plate}/scale${plate}
fi
llsites=./outGinM/${plate}/llsites${plate}     xysites=./outGinM/${plate}/xysites${plate} 
xyvendSKS=./outMinG/${plate}/xyvend${plate}sks xyvendSCH=./outMinG/${plate}/xyvend${plate}sch
xyellip1D=./outMinG/${plate}/xyellip${plate}1D
xyellip2D=./outMinG/${plate}/xyellip${plate}2D xyellip3D=./outMinG/${plate}/xyellip${plate}3D 
v_95cm=./outMinG/${plate}/v_1D95${plate}cm           
llazvtpsksCM=./outGinG/${plate}/llazvtp${plate}sksCM llazvtpschCM=./outGinG/${plate}/llazvtp${plate}schCM 
scale=./outGinM/${plate}/scale${plate}
sksplotpoles=./reffiles/skspolesforplotting schplotpoles=./reffiles/schpolesforplotting

######  define records for pole input and regions to plot  ######
width=16c P=-P B=-B1a5nSEw
if [ "$plate" = "HKKE" ]; then platerow=1;platerow2=14;west=165;east=200;south=-45;north=-10
elif [ "$plate" = "MA" ]; then platerow=2;west=125;east=155;south=-5;north=35
elif [ "$plate" = "IA" ]; then platerow=10;west=115;east=160;south=10;north=50
elif [ "$plate" = "CVSV" ]; then platerow=11;platerow2=15;platerow3=16;west=120;east=190;south=-50;north=35;B=-B2a10nS/2a10Ew
elif [ "$plate" = "LU" ]; then platerow=12;west=70;east=130;south=-10;north=35
#elif [ "$plate" = "ON" ]; then platerow=13;west=120;east=150;south=5;north=35
elif [ "$plate" = "GL" ]; then platerow=0;west=-40;east=320;south=-65;north=65;width=23c;P="";B=-B10a30NESW
else echo "error: enter a valid plate (HKKE,MA,IA,CVSV,LU,GL)"; exit; fi
R=-R${west}/${east}/${south}/${north} J=-JM${width}

#######  create plot, add MORVEL56 boundaries, (trench names), trench markers  #######
gmtset BASEMAP_TYPE=plain ANNOT_FONT_SIZE=10p PLOT_DEGREE_FORMAT=dddF FRAME_PEN=1.5p
pscoast $R $J $B -G200 $P $U -K > $plot
if [ "$plate" = "GL" ]; then W=-W0.5p,150; else W=-W1.5p,150; fi
psxy ./reffiles/All_boundaries -R -J $W -K -O -: >> $plot
#pstext ./reffiles/trenchnames -R -J -Gblack -K -O -: >> $plot
if [ "$plate" = "GL" ]; then S=-Sf0.4c/0.1c;Sb=0.2;W=-W1.5p,0; else S=-Sf0.8c/0.2c;Sb=0.1;W=-W2.5p,0; fi
psxy ./reffiles/trenchesleft -R -J ${S}lt:${Sb} -G0 $W -K -O -: >> $plot
psxy ./reffiles/trenchesright -R -J ${S}rt:${Sb} -G0 $W -K -O -: >> $plot

######  overriding plate arrows plotted  ######
if [ "$arrowchoice" = "o" ] || [ "$arrowchoice" = "b" ]; then
  mapproject ${xyvendSKS} -R -J -I -:o -m | paste ${llsites} - > tempsks  #convert vend x,y to lat,lon and merge sites ll with vend ll for -Svs
  mapproject ${xyvendSCH} -R -J -I -:o -m | paste ${llsites} - > tempsch
  if [ "$plate" = "su" ] || [ "$plate" = "OK" ]; then
    psxy tempsks -R -J -Svs${arrowsizesks}n0.24 -W${dashedarrowsks} -A -K -O -: >> $plot  #plot oplt arrows
    psxy tempsch -R -J -Svs${arrowsizesch}n0.24 -W${dashedarrowsch} -A -K -O -: >> $plot  #plot oplt arrows
  elif [ "$plate" = "GL" ];then
    psxy tempsks -R -J -Svs${arrowsizeGLsks} -Gwhite -W${dashedarrowsks} -A -K -O -: >> $plot  #plot oplt arrows
    psxy tempsch -R -J -Svs${arrowsizeGLsch} -Gwhite -W${dashedarrowsch} -A -K -O -: >> $plot  #plot oplt arrows
  else
    psxy tempsks -R -J -Svs${arrowsizesks} -Gwhite -W${dashedarrowsks} -A -K -O -: >> $plot  #plot oplt arrows
    psxy tempsch -R -J -Svs${arrowsizesch} -Gwhite -W${dashedarrowsch} -A -K -O -: >> $plot  #plot oplt arrows
  fi
rm ./temp*
fi

######  overriding plate error ellipse plotted  ######
if [ "$arrowchoice" = "o" ] || [ "$arrowchoice" = "b" ]; then
  if [ "$edim" = 1 ] || [ "$edim" = "a" ]; then
    ellippen=${ellip1Dpen}
    ellip=${xyellip1D}
    numsitesX2=`awk 'END {print NR*2}' ${xysites}` i=1 j=2
    while [ $j -le ${numsitesX2} ]  #cat every two columns and add segment marker
    do
      awk -v I=$i -v J=$j '{print $I, $J}' ${ellip} | cat >> temp
      echo ">" | cat >> temp
      let i=i+2; let j=j+2
    done
    mapproject temp -R -J -I -:o -m | psxy -R -J -W${ellippen} -K -O -: -m >> $plot  #convert ellipse x,y to lat,lon and plot ellipses
    rm ./temp*
  fi
  if [ "$edim" = 2 ] || [ "$edim" = "a" ]; then
    ellippen=${ellip2Dpen}
    ellip=${xyellip2D}
    numsitesX2=`awk 'END {print NR*2}' ${xysites}` i=1 j=2
    while [ $j -le ${numsitesX2} ]  #cat every two columns and add segment marker
    do
      awk -v I=$i -v J=$j '{print $I, $J}' ${ellip} | cat >> temp
      echo ">" | cat >> temp
      let i=i+2; let j=j+2
    done
    mapproject temp -R -J -I -:o -m | psxy -R -J -W${ellippen} -A -K -O -: -m >> $plot  #convert ellipse x,y to lat,lon and plot ellipses
    rm ./temp*
  fi
  if [ "$edim" = 3 ] || [ "$edim" = "a" ]; then
    ellippen=${ellip3Dpen}
    ellip=${xyellip3D}
    numsitesX2=`awk 'END {print NR*2}' ${xysites}` i=1 j=2
    while [ $j -le ${numsitesX2} ]  #cat every two columns and add segment marker
    do
      awk -v I=$i -v J=$j '{print $I, $J}' ${ellip} | cat >> temp
      echo ">" | cat >> temp
      let i=i+2; let j=j+2
    done
    mapproject temp -R -J -I -:o -m | psxy -R -J -W${ellippen} -A -K -O -: -m >> $plot  #convert ellipse x,y to lat,lon and plot ellipses
    rm ./temp*
  fi
fi

###################  trench perpendicular arrows and SKS error bars plotted  ####################
if [ "$arrowchoice" = "t" ] || [ "$arrowchoice" = "b" ]; then
  if [ "$plate" = "GL" ]; then
    numsites=`awk 'END {print NR}' ${llsites}` i=1
    while [ $i -le ${numsites} ]
    do
      awk -v I=$i 'NR==I {print}' ${llazvtpsksCM} > tempSKS 
      awk -v I=$i 'NR==I {print}' ${llazvtpschCM} > tempSCH 
      awk -v T=${tinyheadlength} '{if ( $4 <= T ) print $1, $2, $3, T}' tempSKS | cat >> tempSKStiny
      awk -v T=${tinyheadlength} -v S=${headlength} '{if ( $4 > T && $4 < S ) print $1, $2, $3, S}' tempSKS | cat >> tempSKSsmall
      awk -v S=${headlength} '{if ( $4 >= S) print}' tempSKS | cat >> tempSKSnorm
      awk -v T=${tinyheadlength} '{if ( $4 <= T ) print $1, $2, $3, T}' tempSCH | cat >> tempSCHtiny
      awk -v T=${tinyheadlength} -v S=${headlength} '{if ( $4 > T && $4 < S ) print $1, $2, $3, S}' tempSCH | cat >> tempSCHsmall
      awk -v S=${headlength} '{if ( $4 >= S ) print}' tempSCH | cat >> tempSCHnorm
      echo -n $i
      echo -n " of" ${numsites}
      if [ $i -lt 10 ]; then
	echo -en "\b\b\b\b\b\b\b"
      else
        echo -en "\b\b\b\b\b\b\b\b"
      fi
      let i=i+1
    done
    psxy tempSCHtiny -R -J -SV${tinyarrowsch} -Gred -W0.1p,black -A -K -O -: >> $plot  #plot vtp arrows
    psxy tempSCHsmall -R -J -SV${smallarrowsch} -Gred -W0.1p,black -A -K -O -: >> $plot  #plot vtp arrows
    psxy tempSCHnorm -R -J -SV${arrowsizeGLsch} -Gred -W0.1p,black -A -K -O -: >> $plot  #plot vtp arrows
    psxy tempSKStiny -R -J -SV${tinyarrowsks} -Gblue -W0.1p,black -A -K -O -: >> $plot  #plot vtp arrows
    psxy tempSKSsmall -R -J -SV${smallarrowsks} -Gblue -W0.1p,black -A -K -O -: >> $plot  #plot vtp arrows
    psxy tempSKSnorm -R -J -SV${arrowsizeGLsks} -Gblue -W0.1p,black -A -K -O -: >> $plot  #plot vtp arrows
    rm ./temp*
  else
    psxy ${llazvtpschCM} -R -J -SV${arrowsizesch} -Gred -W0.2p,black -A -K -O -: >> $plot  #plot vtp arrows
    psxy ${llazvtpsksCM} -R -J -SV${arrowsizesks} -Gblue -W0.2p,black -A -K -O -: >> $plot  #plot vtp arrows
  fi

######  plot error bars  ######
  if [ "$plate" != "GL" ]; then S=-SVB0.075c/0.08c/0.25c; else S=-SVB0.040c/0.02c/0.20c; fi
  awk '{print sin(3.141529/180*$3)*$4, cos(3.141529/180*$3)*$4}' ${llazvtpsksCM} | paste - ${xysites} > temp2  #calc vtp dx,dy and paste to xysites
  awk '{print $1+$3, $2+$4}' temp2 | mapproject -R -J -I -:o -m > temp3  #sum dx,dy and xysites and convert to lat,lon
  awk '{print $3}' ${llazvtpsksCM} > temp4  #azimuth
  paste temp3 temp4 ${v_95cm} | psxy -R -J $S -Gblack -A -K -O -: >> $plot  #paste llvtpend with azimuth and 95% confidence in cm and plot error bars
  rm ./temp* #./errorbar*
fi


######  plot SKS-MORVEL56 poles  ######
if [ "$plate" = "HKKE" ]; then
  awk -v ROW=${platerow} 'NR==ROW {print $1, $2}' ${sksplotpoles} > temppole
  awk -v ROW=${platerow} 'NR==ROW {print $1, $2}' ${schplotpoles} > temp2pole
  awk -v ROW2=${platerow2} 'NR==ROW2 {print $1, $2}' ${sksplotpoles} > temppole2
  awk -v ROW2=${platerow2} 'NR==ROW2 {print $1, $2}' ${schplotpoles} > temp2pole2
  psxy temppole -R -J -Sa0.5c -W1.0p,blue -K -O -: >> $plot
  psxy temp2pole -R -J -Sa0.5c -W1.0p,red -K -O -: >> $plot
  psxy temppole2 -R -J -Sd0.5c -W1.0p,blue -K -O -: >> $plot
  psxy temp2pole2 -R -J -Sd0.5c -W1.0p,red -K -O -: >> $plot
elif [ "$plate" = "CVSV" ]; then
  #awk -v ROW=${platerow} 'NR==ROW {print $1, $2}' ${sksplotpoles} > temppole
  awk -v ROW=${platerow} 'NR==ROW {print $1, $2}' ${schplotpoles} > temp2pole
  awk -v ROW2=${platerow2} 'NR==ROW2 {print $1, $2}' ${sksplotpoles} > temppole2
  #awk -v ROW2=${platerow2} 'NR==ROW2 {print $1, $2}' ${schplotpoles} > temp2pole2
  awk -v ROW3=${platerow3} 'NR==ROW3 {print $1, $2}' ${sksplotpoles} > temppole3
  #awk -v ROW2=${platerow3} 'NR==ROW3 {print $1, $2}' ${schplotpoles} > temp2pole3
  #psxy temppole -R -J -Sa0.5c -W1.0p,blue -K -O -: >> $plot
  psxy temp2pole -R -J -Sa0.5c -W1.0p,red -K -O -: >> $plot
  psxy temppole2 -R -J -Sd0.5c -W1.0p,blue -K -O -: >> $plot
  psxy temppole3 -R -J -Sc0.5c -W1.0p,blue -K -O -: >> $plot
else
  awk -v ROW=${platerow} 'NR==ROW {print $1, $2}' ${sksplotpoles} > temppole
  awk -v ROW=${platerow} 'NR==ROW {print $1, $2}' ${schplotpoles} > temp2pole
  psxy temppole -R -J -Sa0.5c -W1.0p,blue -K -O -: >> $plot
  psxy temp2pole -R -J -Sa0.5c -W1.0p,red -K -O -: >> $plot
fi

######  rotation arrows around poles and labels  ######
if [ "$plate" = "HKKE" ]; then S=-Smf1.0c;dlat=-1.0;dlon=0.3
elif [ "$plate" = "MA" ]; then S=-Sml1.0c;dlat=1.5;dlon=-1.0
elif [ "$plate" = "IA" ]; then S=-Smf1.0c;dlat=1.5;dlon=-1.0
elif [ "$plate" = "CVSV" ]; then S=-Smf1.0c;dlat=2.5;dlon=-1.0
elif [ "$plate" = "LU" ]; then S=-Sml1.0c;dlat=1.5;dlon=-5.0
#elif [ "$plate" = "ON" ]; then S=-Sml1.0c;dlat=1.0;dlon=-1.5
fi
if [ "$plate" != "GL" ] && [ "$plate" != "HKKE" ] && [ "$plate" != "CVSV" ]; then
  awk '{print $1, $2, 0, 90}' temppole | psxy -R -J $S -Gblue -W1.0p,blue -K -O -: >> $plot
  awk '{print $1, $2, 0, 90}' temp2pole | psxy -R -J $S -Gred -W1.0p,red -K -O -: >> $plot
  awk -v PLATE=${plate} -v DLAT=${dlat} -v DLON=${dlon} 'NR==1 {print $1+DLAT, $2+DLON, 14, 0, 5, "CB", PLATE"-mantle"}' temppole | pstext -R -J -Gblack -K -O -: >> $plot
elif [ "$plate" = "HKKE" ]; then
  awk '{print $1, $2, 0, 90}' temppole | psxy -R -J $S -Gblue -W1.0p,blue -K -O -: >> $plot
  awk '{print $1, $2, 0, 90}' temp2pole | psxy -R -J $S -Gred -W1.0p,red -K -O -: >> $plot
  awk -v DLAT=${dlat} -v DLON=${dlon} 'NR==1 {print $1+DLAT, $2+DLON, 14, 0, 5, "CB", "KE-mantle"}' temppole | pstext -R -J -Gblack -K -O -: >> $plot
  awk '{print $1, $2, 0, 90}' temppole2 | psxy -R -J $S -Gblue -W1.0p,blue -K -O -: >> $plot
  awk '{print $1, $2, 0, 90}' temp2pole2 | psxy -R -J $S -Gred -W1.0p,red -K -O -: >> $plot
  awk -v DLAT=${dlat} -v DLON=${dlon} 'NR==1 {print $1+DLAT, $2+DLON, 14, 0, 5, "CB", "HK-mantle"}' temppole2 | pstext -R -J -Gblack -K -O -: >> $plot
elif [ "$plate" = "CVSV" ]; then
  awk '{print $1, $2, 0, 90}' temp2pole | psxy -R -J $S -Gred -W1.0p,red -K -O -: >> $plot
  awk '{print $1, $2, 0, 90}' temppole2 | psxy -R -J $S -Gblue -W1.0p,blue -K -O -: >> $plot
  awk '{print $1, $2, 0, 90}' temppole3 | psxy -R -J $S -Gblue -W1.0p,blue -K -O -: >> $plot
  awk -v DLAT=${dlat} -v DLON=${dlon} 'NR==1 {print $1+DLAT, $2+DLON, 14, 0, 5, "CB", "NH-mantle"}' temp2pole | pstext -R -J -Gblack -K -O -: >> $plot
  awk -v DLAT=${dlat} -v DLON=${dlon} 'NR==1 {print $1+DLAT, $2+DLON, 14, 0, 5, "CB", "CV-mantle"}' temppole2 | pstext -R -J -Gblack -K -O -: >> $plot
  awk -v DLAT=${dlat} -v DLON=${dlon} 'NR==1 {print $1+DLAT-1, $2+DLON+8, 14, 0, 5, "CB", "SV-mantle"}' temppole3 | pstext -R -J -Gblack -K -O -: >> $plot
fi
rm ./temp*

######  plate names  ######
if [ "$plate" = "HKKE" ]; then pstext -R -J -Gblack -K -O << EOF >> $plot
168 -26 14 0 5 CB AU
-178.7 -32.0 14 0 5 CB KE
177 -41 14 0 5 CB HK
-165 -35 14 0 5 CB PA
EOF
elif [ "$plate" = "MA" ]; then pstext -R -J -Gblack -K -O << EOF >> $plot 
146.5 18.5 14 0 5 CB MA
128 20 14 0 5 CB PS
152 23 14 0 5 CB PA
EOF
elif [ "$plate" = "IA" ]; then pstext -R -J -Gblack -K -O << EOF >> $plot 
#130 46 14 0 5 CB AM
153 30 14 0 5 CB PA
132 20 14 0 5 CB PS
141 30 14 0 5 CB IA
EOF
elif [ "$plate" = "LU" ]; then pstext -R -J -Gblack -K -O << EOF >> $plot 
77 15 14 0 1 CB IN
100 10 14 0 1 CB SU
100 31 14 0 1 CB EU
115 27 14 0 1 CB YZ
128 16 14 0 1 CB PS
122 19.5 12 0 1 CB LU
EOF
elif [ "$plate" = "CVSV" ]; then pstext -R -J -Gblack -K -O << EOF >> $plot 
134 19 14 0 5 CB PS
135 -30 14 0 5 CB AU
160 20 14 0 5 CB PA
172.0 -18 14 0 5 CB NH
168.8 -16 12 0 5 CB CV
171.6 -22 12 0 5 CB SV
EOF
#elif [ "$plate" = "ON" ]; then pstext -R -J -Gblack -K -O << EOF >> $plot 
#123 29 14 0 1 CB yz
#129 34.0 14 0 1 CB am
#128 26.2 14 0 1 CB ON
#131 13 14 0 1 CB ps
#147 29 14 0 1 CB pa 
#EOF
fi

#########  location maps  ##########
gmtset ANNOT_FONT_SIZE=8p FRAME_PEN=1.0p

#if [ "$plate" = "GL" ]; then
#gmtset ANNOT_FONT_SIZE=10p FRAME_PEN=1.0p
#psxy -R -J -W1.5p,black,- -m -A -K -O -: << EOF >> $plot
#35 125
#35 155 
#0 155
#0 125
#35 125
#> -W1.5p,black,-
#-20 170
#-20 195 
#-45 195
#-45 170
#-20 170
#EOF
#pstext -R -J -K -O -: << EOF >> $plot
#-5.0 160 18 0 1 CB 5
#-48.0 -160 18 0 1 CB 4
#EOF

G=-G120 S=-Swhite C=-C120 W=-W1.5p,0
#elif [ "$plate" = "HKKE" ]; then
if [ "$plate" = "HKKE" ]; then
X=-Xa11.8c Y=-Ya14.8c
pscoast $X $Y -R110/209/-60/10 -JM4c -B10a30nS/10a30We $G $S $C -A -K -O >> $plot 
psxy $X $Y -R -J $W -A -K -O -: << EOF >> $plot
${south} ${west}
${north} ${west}
${north} ${east}
${south} ${east}
${south} ${west}
EOF

elif [ "$plate" = "MA" ]; then
X=-Xa11.7c Y=-Ya18.5c
pscoast $X $Y -R90/160/-15/45 -JM4c -B10a30nS/10a30We $G $S $C -A -K -O >> $plot 
psxy $X $Y -R -J $W -A -K -O -: << EOF >> $plot
${south} ${west}
${north} ${west}
${north} ${east}
${south} ${east}
${south} ${west}
EOF

elif [ "$plate" = "IA" ]; then
X=-Xa0.40c Y=-Ya12.9c
pscoast $X $Y -R90/180/-10/60 -JM4c -B10a30nS/10a30wE $G $S $C -A -K -O >> $plot 
psxy $X $Y -R -J $W -A -K -O -: << EOF >> $plot
${south} ${west}
${north} ${west}
${north} ${east}
${south} ${east}
${south} ${west}
EOF

fi

########  legends  ########
cat > errorbar.def << EOF
-0.50	0.10	M
-0.50	-0.10	D
-0.50	0.00	M
0.50	0.00	D
0.50	0.10	M
0.50	-0.10	D
EOF

#LEGEND PARAMETERS
legendarrowlength=1.5
legendarrowmag=`awk -v LENGTH=${legendarrowlength} 'END {print LENGTH / $1}' ${scale}`
legendarrowcenter=`echo "(${legendarrowlength}*0.5) + 0.5" | bc`

if [ "$plate" = "GL" ] && [ "$arrowchoice" = "o" ]; then
gmtset FRAME_PEN=1.0p ANNOT_FONT_SIZE_PRIMARY=10p
  if [ "$edim" = "a" ]; then
    pslegend -R -J -Gwhite -Dx4.0c/0.1c/6.0c/4.0c/BL -C0.15c/0.15c -F -O << EOF >> $plot
H 10 1 Overriding Plate Velocity
D 0 1p
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizeGLsks} white ${dashedarrowsks} 2.7c SKS-MORVEL
G 0.10c
S 0 c 0 0 0 0.45c ${legendarrowmag} mm a@+-1@+
G 0.10c
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizeGLsch} white ${dashedarrowsch} 2.7c Schellart 2008
G 0.25c
S 1.0c e 0.80c white ${ellip1Dpen} 1.5c 1D 95% C.R.
G 0.25c
S 1.0c e 0.80c white ${ellip2Dpen} 1.5c 2D 95% C.R.
G 0.25c
S 1.0c e 0.80c white ${ellip3Dpen} 1.5c 3D 95% C.R.
EOF
  else
    pslegend -R -J -Gwhite -Dx4.0c/0.1c/6.0c/3.0c/BL -C0.15c/0.15c -F -O << EOF >> $plot
H 10 1 Overriding Plate Velocity
D 0 1p
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizeGLsks} white ${dashedarrowsks} 2.7c SKS-MORVEL
G 0.10c
S 0 c 0 0 0 0.45c ${legendarrowmag} mm a@+-1@+
G 0.10c
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizeGLsch} white ${dashedarrowsch} 2.7c Schellart 2008
G 0.25c
S 1.0c e 0.80c white ${ellippen} 1.5c ${edim}D 95% C.R.
EOF
  fi

elif [ "$plate" = "GL" ] && [ "$arrowchoice" = "t" ]; then
legendarrowcenter=`echo "(${legendarrowlength}*0.5) + 0.3" | bc`
gmtset FRAME_PEN=1.0p ANNOT_FONT_SIZE_PRIMARY=8p
pslegend -R -J -Gwhite -Dx22.9c/10.884c/4.3c/2.4c/TR -C0.15c/0.15c -F -O << EOF >> $plot
H 8 1 Trench Velocity
D 0 1p
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizeGLsch} blue 0.1p,black 2.0c SKS-MORVEL
G 0.02c
S ${legendarrowcenter}c kerrorbar ${legendarrowlength}c white 1.0p,black 2.0c 1D 95% C.I. 
G 0.28c
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizeGLsch} red 0.1p,black 2.0c Schellart 2008
G 0.05c
S 0 c 0 0 0 0.40c ${legendarrowmag} mm a@+-1@+
EOF

elif [ "$plate" = "GL" ] && [ "$arrowchoice" = "b" ]; then
gmtset FRAME_PEN=1.0p ANNOT_FONT_SIZE_PRIMARY=10p
  if [ "$edim" = "a" ]; then
    pslegend -R -J -Gwhite -Dx4.0c/0.1c/8.0c/4.8c/BL -C0.15c/0.15c -F -O << EOF >> $plot
N 3
S 0 c 0 0 0 0
S 0 c 0 0 0 0.1c SKS-MORVEL
S 0 c 0 0 0 0.1c Schellart 2008
D 0 1p
G 0.10c
N 3
S 0 c 0 0 0 0.5c Overriding Plate
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizeGLsks} white ${dashedarrowsks}
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizeGLsch} white ${dashedarrowsch}
G 0.20c
N 3
S 0 c 0 0 0 1.0c 1D 95% C.R.
S 1.0c e 0.80c white ${ellip1Dpen}
S 0 c 0 0 0 0
G 0.40c
S 0 c 0 0 0 1.0c 2D 95% C.R.
S 1.0c e 0.80c white ${ellip2Dpen}
S 0 c 0 0 0 0
G 0.40c
S 0 c 0 0 0 1.0c 3D 95% C.R.
S 1.0c e 0.80c white ${ellip3Dpen}
S 0 c 0 0 0 0
G 0.40c
N 3
S 0 c 0 0 0 0.5c Trench Velocity
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizeGLsks} blue 0.2p,black
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizeGLsch} red 0.2p,black
N 1
S 0 c 0 0 0 5.7c ${legendarrowmag} mm a@+-1@+
N 3
S 0 c 0 0 0 1.0c 1D 95% C.I.
S ${legendarrowcenter}c kerrorbar ${legendarrowlength}c white 2.0p,black
S 0 c 0 0 0 0
EOF
  else
    pslegend -R -J -Gwhite -Dx4.0c/0.1c/8.0c/3.1c/BL -C0.15c/0.15c -F -O << EOF >> $plot
N 3
S 0 c 0 0 0 0
S 0 c 0 0 0 0.1c SKS-MORVEL
S 0 c 0 0 0 0.1c Schellart 2008
D 0 1p
G 0.10c
N 3
S 0 c 0 0 0 0.5c Overriding Plate
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizeGLsks} white ${dashedarrowsks}
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizeGLsch} white ${dashedarrowsch}
G 0.20c
N 3
S 0 c 0 0 0 1.0c ${edim}D 95% C.R.
S 1.0c e 0.80c white ${ellippen}
S 0 c 0 0 0 0
G 0.40c
N 3
S 0 c 0 0 0 0.5c Trench Velocity
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizeGLsks} blue 0.2p,black
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizeGLsch} red 0.2p,black
N 1
S 0 c 0 0 0 5.7c ${legendarrowmag} mm a@+-1@+
N 3
S 0 c 0 0 0 1.0c 1D 95% C.I.
S ${legendarrowcenter}c kerrorbar ${legendarrowlength}c white 2.0p,black
S 0 c 0 0 0 0
EOF
  fi

elif [ "$plate" != "GL" ] && [ "$arrowchoice" = "o" ]; then
legendarrowlength=2.0
legendarrowmag=`awk -v LENGTH=${legendarrowlength} 'END {print LENGTH / $1}' ${scale}`
legendarrowcenter=`echo "(${legendarrowlength}*0.5)" | bc`
gmtset FRAME_PEN=1.0p ANNOT_FONT_SIZE_PRIMARY=8p
  if [ "$edim" = "a" ]; then
    pslegend -R -J -Gwhite -Dx7.9c/0.1c/8.0c/3.1c/BL -C0.15c/0.15c -F -O << EOF >> $plot
N 3
S 0 c 0 0 0 0
S 0 c 0 0 0 0.1c SKS-MORVEL
S 0 c 0 0 0 0.1c Schellart 2008
D 0 1p
G 0.10c
N 3
S 0 c 0 0 0 0.65c Overriding Plate
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizesks} white ${dashedarrowsks}
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizesch} white ${dashedarrowsch}
N 1
S 0 c 0 0 0 5.7c ${legendarrowmag} mm a@+-1@+
G 0.05c
N 3
S 0 c 0 0 0 1.15c 1D 95% C.R.
S 1.0c e 0.80c white ${ellip1Dpen}
S 0 c 0 0 0 0
G 0.3c
S 0 c 0 0 0 1.15c 2D 95% C.R.
S 1.0c e 0.80c white ${ellip2Dpen}
S 0 c 0 0 0 0
G 0.3c
S 0 c 0 0 0 1.15c 3D 95% C.R.
S 1.0c e 0.80c white ${ellip3Dpen}
S 0 c 0 0 0 0
EOF
  else
    pslegend -R -J -Gwhite -Dx7.9c/0.1c/8.0c/2.1c/BL -C0.15c/0.15c -F -O << EOF >> $plot
N 3
S 0 c 0 0 0 0
S 0 c 0 0 0 0.1c SKS-MORVEL
S 0 c 0 0 0 0.1c Schellart 2008
D 0 1p
G 0.10c
N 3
S 0 c 0 0 0 0.65c Overriding Plate
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizesks} white ${dashedarrowsks}
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizesch} white ${dashedarrowsch}
N 1
S 0 c 0 0 0 5.7c ${legendarrowmag} mm a@+-1@+
G 0.05c
N 3
S 0 c 0 0 0 1.15c ${edim}D 95% C.R.
S 1.0c e 0.80c white ${ellippen}
S 0 c 0 0 0 0
EOF
  fi

elif [ "$plate" != "GL" ] && [ "$arrowchoice" = "t" ]; then
legendarrowlength=2.0
legendarrowmag=`awk -v LENGTH=${legendarrowlength} 'END {print LENGTH / $1}' ${scale}`
legendarrowcenter=`echo "(${legendarrowlength}*0.5 + 0.1)" | bc`
gmtset FRAME_PEN=1.0p ANNOT_FONT_SIZE_PRIMARY=8p
pslegend -R -J -Gwhite -Dx7.9c/0.1c/8.0c/2.1c/BL -C0.15c/0.15c -F -O << EOF >> $plot
N 3
S 0 c 0 0 0 0
S 0 c 0 0 0 0.1c SKS-MORVEL
S 0 c 0 0 0 0.1c Schellart 2008
D 0 1p
G 0.10c
N 3
S 0 c 0 0 0 0.0c Trench Perpendicular
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizesks} blue 0.2p,black
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizesch} red 0.2p,black
N 1
S 0 c 0 0 0 5.7c ${legendarrowmag}mm a@+-1@+
G 0.05c
N 3
S 0 c 0 0 0 1.15c 1D 95% C.I.
S ${legendarrowcenter}c kerrorbar ${legendarrowlength}c white 2.0p,black
S 0 c 0 0 0 0
EOF

elif [ "$plate" != "GL" ] && [ "$arrowchoice" = "b" ]; then
legendarrowlength=2.0
legendarrowmag=`awk -v LENGTH=${legendarrowlength} 'END {print LENGTH / $1}' ${scale}`
legendarrowcenter=`echo "(${legendarrowlength}*0.5 + 0.2)" | bc`
gmtset FRAME_PEN=1.0p ANNOT_FONT_SIZE_PRIMARY=8p
  if [ "$edim" = "a" ]; then
    pslegend -R -J -Gwhite -Dx7.9c/0.1c/8.0c/4.6c/BL -C0.15c/0.15c -F -O << EOF >> $plot
N 3
S 0 c 0 0 0 0
S 0 c 0 0 0 0.3c SKS-MORVEL
S 0 c 0 0 0 0.3c Schellart 2008
D 0 1p
G 0.10c
S 0 c 0 0 0 0.70c Overriding Plate
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizesks} white ${dashedarrowsks}
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizesch} white ${dashedarrowsch}
G 0.20c
S 0 c 0 0 0 1.05c 1D 95% C.R.
S 1.0c e 0.80c white ${ellip1Dpen}
S 0 c 0 0 0 0
G 0.40c
S 0 c 0 0 0 1.05c 2D 95% C.R.
S 1.0c e 0.80c white ${ellip2Dpen}
S 0 c 0 0 0 0
G 0.40c
S 0 c 0 0 0 1.05c 3D 95% C.R.
S 1.0c e 0.80c white ${ellip3Dpen}
S 0 c 0 0 0 0
G 0.40c
S 0 c 0 0 0 0.0c Trench Perpendicular
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizesks} blue 0.2p,black
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizesch} red 0.2p,black
N 1
G 0.12c
S 0 c 0 0 0 5.9c ${legendarrowmag} mm a@+-1@+
N 3
S 0 c 0 0 0 1.20c 1D 95% C.I.
S ${legendarrowcenter}c kerrorbar ${legendarrowlength}c white 2.0p,black
S 0 c 0 0 0 0
EOF
  else
    pslegend -R -J -Gwhite -Dx7.9c/0.1c/8.0c/3.1c/BL -C0.15c/0.15c -F -O << EOF >> $plot
N 3
S 0 c 0 0 0 0
S 0 c 0 0 0 0.3c SKS-MORVEL
S 0 c 0 0 0 0.3c Schellart 2008
D 0 1p
G 0.10c
S 0 c 0 0 0 0.70c Overriding Plate
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizesks} white ${dashedarrowsks}
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizesch} white ${dashedarrowsch}
G 0.20c
S 0 c 0 0 0 1.05c ${edim}D 95% C.R.
S 1.0c e 0.80c white ${dashedarrowsks}
S 0 c 0 0 0 0
G 0.40c
S 0 c 0 0 0 0.0c Trench Perpendicular
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizesks} blue 0.2p,black
S ${legendarrowcenter}c v ${legendarrowlength}c/${arrowsizesch} red 0.2p,black
N 1
G 0.12c
S 0 c 0 0 0 5.9c ${legendarrowmag} mm a@+-1@+
N 3
S 0 c 0 0 0 1.20c 1D 95% C.I.
S ${legendarrowcenter}c kerrorbar ${legendarrowlength}c white 2.0p,black
S 0 c 0 0 0 0
EOF
  fi
fi
rm ./errorbar.def

########  show the postscript on the screen  ########
if [ "$disp" = "y" ]; then
   if [ "$P" != "-P" ]; then
      gs -q -c "<< /PageSize [612 792] /Orientation 3 >> setpagedevice" 90 rotate 0 -612 translate -f $plot
   else
      gs -q $plot
   fi
fi
