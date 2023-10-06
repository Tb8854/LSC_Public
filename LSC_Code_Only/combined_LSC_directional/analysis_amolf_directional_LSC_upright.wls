(* Set Up Computer Options *) 
SetDirectory[NotebookDirectory[]];
CreateDirectory["results_amolf_upright"];

(*Set Up Computer Options*)
numkernel=4;
Unprotect[$ProcessorCount];
$ProcessorCount=numkernel;
$HistoryLength=0
(* Set Up Raytracing Options *) 
sides = 4;
anglestart = 1;
angleend = 90;
numberofphotons = 10000;

numberofangles = 89;
totalphotonsin = numberofphotons;
cell = 13;

(* Set Up Simulation Options *) 
(* ----- Notebook Running Running ----- *) 

(*dayinyear=ToExpression[70];
startwavelength=ToExpression[320];
endwavelength=ToExpression[550];
timestepsize=60;
days=100;*)

(*LSC orientation; vector defining its surface normal in degrees*)
lscAltitude = 90 ;(*0 is horizontal, 90 is vertical up*)
lscAzimuth = 180;(*0 is facing North, 180 is facing South*)
ClearSystemCache[]; 


(* ----- Command Line Running ----- *) 
cmddata = $ScriptCommandLine;
days = ToExpression[cmddata[[2]]];

(* Import or Create Raytracing Results *) 
(* Raytracing Data *) 

(* import datastore *) 

Import["./raytracing.mx"]
(*minimumwavelength*)
emissionmax = N[1200];
emissionmin = N[311];
wavelengthtable = Table[{N[x], 0}, {x, emissionmin, emissionmax, 1}];

Dimensions[raytracingdata];


daysinmonth = {31, 28, 31, 16, 31, 30, 31, 31, 21, 31, 30, 31};

Which[1 <= days <= Total[daysinmonth[[1]]], Print["jan"]; 
  monthvalue = 1;,
  Total[daysinmonth[[1]]] < days <= Total[daysinmonth[[1 ;; 2]]], 
  Print["feb"]; monthvalue = 2;,
  Total[daysinmonth[[1 ;; 2]]] < days <= Total[daysinmonth[[1 ;; 3]]],
   Print["march"]; monthvalue = 3;,
  Total[daysinmonth[[1 ;; 3]]] < days <= Total[daysinmonth[[1 ;; 4]]],
   Print["apr"]; monthvalue = 4;,
  Total[daysinmonth[[1 ;; 4]]] < days <= Total[daysinmonth[[1 ;; 5]]],
   Print["may"]; monthvalue = 5;,
  Total[daysinmonth[[1 ;; 5]]] < days <= Total[daysinmonth[[1 ;; 6]]],
   Print["jun"]; monthvalue = 6;,
  Total[daysinmonth[[1 ;; 6]]] < days <= Total[daysinmonth[[1 ;; 7]]],
   Print["july"]; monthvalue = 7;,
  Total[daysinmonth[[1 ;; 7]]] < days <= Total[daysinmonth[[1 ;; 8]]],
   Print["aug"]; monthvalue = 8;,
  Total[daysinmonth[[1 ;; 8]]] < days <= Total[daysinmonth[[1 ;; 9]]],
   Print["sept"]; monthvalue = 9,
  Total[daysinmonth[[1 ;; 9]]] < days <= 
   Total[daysinmonth[[1 ;; 10]]], Print["oct"]; monthvalue = 10;,
  Total[daysinmonth[[1 ;; 10]]] < days <= 
   Total[daysinmonth[[1 ;; 11]]], Print["nov"]; monthvalue = 11;,
  Total[daysinmonth[[1 ;; 11]]] < days <= 
   Total[daysinmonth[[1 ;; 12]]], Print["dec"]; monthvalue = 12;];

daystartingpoint = days - Total[daysinmonth[[;; monthvalue - 1]]];
timepoint = 1 + (daystartingpoint - 1)*8640;
(* Import Spectra Data  *) 
(*Import LAD data for 2019*)
LADData=FileNames["./training_rules/*.mx"]; (*All LAD data for 2019. One file for each month. Date is in absolute time, the twelve following numbers are the LAD sensors. 
This data is not yet calibrated and has to be calibrated with the listCalibrate function below, since the neural network has been trained on calibrated data.*)
(*Import one LAD dataset for test purposes*)
monthdatalad =Import[LADData[[monthvalue]]];
wavelengths=Import["./machine_fluff/wavelengthsSpectrometer.mx"];(*The x-Axis for the result of the training network*)
trainedNet1=Import["./machine_fluff/bestnet.wlnet"];(*Import the best training network, trained for 400 rounds on the year 2019. 
The neural net is: Input, Linearlayer5, ConstantLayer, Linearlayer 2048, Abs, Output. Please see training notebook and powerpoint presentation for details.*)
calibrationImport=Import["./machine_fluff/calibrationTable.mx"];(*Calibration of the LAD sensor data to W/m^2. Calibrated with a solar simulator at amolf by bachelor student A.Pollastri. 
The solar simulator is set to different intensities and the 12 sensors held at different temperatures, such that *)
SensorToWm2[sensorNr_,color_,sensor1_,temp1_]:=calibrationImport[[sensorNr,color]]/.sensor->sensor1/.temp->temp1 (*The calibration function needs the sensor Nr, color (rgbIR), sensor Color, and temperature*)
listCalibrate[list_,sensor_]:=Module[{red,green,blue,IR,temp},
{red,green,blue,IR,temp}=list;

{SensorToWm2[sensor,1,red,temp],
SensorToWm2[sensor,2,green,temp],
SensorToWm2[sensor,3,blue,temp],
SensorToWm2[sensor,4,IR,temp],
temp}
];
(* see additional documentation for how anglular dependence from the LAD is determined *) 
(*Mix the 12  spectra into one:
ATTENTION: IN NORMAL ALTITUDE ANGLES*)
sphericaltoCartesian[\[Theta]_,\[Phi]_]=CoordinateTransform["Spherical"->"Cartesian",{1,\[Theta],\[Phi]}];
mathDodetoRealDodeAssoc=Association[4->"A",2->"F",3->"B",11->"C",12->"D",5->"E",9->"L",7->"K",10->"J",1->"I",8->"H",6->"G"];
polygonPoints[polygon_]:=N[polygon[[1]]]
normalVector[list_]:=Module[{p1,p2,p3},
{p1,p2,p3}=list[[;;3]];
Cross[p2-p1,p3-p1]
];
polyhedronPolygonList=PolyhedronData["Dodecahedron","Polygons"];
normalArrow[polygon_]:=Arrow[{RegionCentroid[N@polygon],RegionCentroid[N@polygon]+normalVector[polygonPoints[polygon]]}];
degToRad[angle_] := angle \[Pi]/180.
azimuthToPhi[azi_]:=azi+90.
altitudeToTheta[alt_]:=90.-alt
(* see additional documentation for how anglular dependence from the LAD is determined *) 
rotation=Composition[RotationTransform[degToRad[30],{1,0,0}],RotationTransform[degToRad[-90],{0,0,1}]];
realNormalVectors=Table[normalVector[polygonPoints[Normal[GeometricTransformation[polyhedronPolygonList[[side]],rotation]]]],{side,Range[12]}][[Keys[Sort[mathDodetoRealDodeAssoc]]]];
normDot[a_,b_]:=a . b/(Norm[a]Norm[b])
normDotSphericalOriented[number_, altitude_(**), azimuth_] := Module[{a, b},
  a = realNormalVectors[[number]];
  b = sphericaltoCartesian[degToRad[altitudeToTheta[altitude]],degToRad[azimuthToPhi[azimuth]]];
  normDot[a, b]
  ];
polyWeights[altitude_,azimuth_]:=With[
{list=Clip[normDotSphericalOriented[#,altitude,azimuth]&/@Range[12],{0,10}]},
list/Total[list]
];
angleToRad[angle_]:=angle \[Pi]/180
fractionSolidAngle[x_]=Integrate[Sin[\[Theta]],{\[Theta],0,angleToRad[x]},{\[Phi],0,2\[Pi]}]/(4\[Pi]);
angleOpening=x/.Last@Solve[10*20==N@1/fractionSolidAngle[x],x];   //Quiet
makeSpectra[ladList_,time_,\[Theta]_,\[Phi]_]:={wavelengths,1/1000(*/um to /nm*) fractionSolidAngle[angleOpening]*Total[polyWeights[\[Theta],\[Phi]]*Table[trainedNet1[listCalibrate[ladList[[time,2,side]],side]],{side,Range[12]}]]}\[Transpose]
sphericaltoCartesianLSC[\[Theta]_, \[Phi]_] = 
  FromSphericalCoordinates[{1, \[Pi]/180. (90. - \[Theta]), -\[Pi] + 
     2 \[Pi] /
       360. \[Phi]}];(*shifted to our angle definition: normal \
definition is theta from 0 to pi, phi from -pi to pi*)
normDot[a_, b_] := 
  a . b/(Norm[a] Norm[
      b]);(*normed dotproduct to calculate the angle between sun \
angle and surface normal*)
realAngleAtLSC[ altitude_, 
   azimuth_] := (*effective angle between lsc and sun, 
  we can do this since the lsc is symmetric in the plane*)
  Module[{a, b},
   a = sphericaltoCartesian[degToRad[altitudeToTheta[lscAltitude]], 
     degToRad[azimuthToPhi[lscAzimuth]]];
   b = sphericaltoCartesian[degToRad[altitudeToTheta[altitude]], 
     degToRad[
      azimuthToPhi[
       azimuth]]];(*this is the orientation of the surface normal of \
the LSC*)
    ArcCos[ normDot[a, b]] 180./(\[Pi])
     ];
photonsNmMConversion[
   data_] := {#[[1]], #[[2]]*(#[[1]] 10^(-9))/(h*c)} & /@ data;
nmToeV[data_] := {fac/#[[1]], 
     fac(*hc in units of eV x nm*)/(fac/#[[1]])^(2)(*hc/
      E^2*)*#[[2]](*W/m^2/nm*)} & /@ data;
photonsNmMConversion[
   data_] := {#[[1]], #[[2]]*(#[[1]] 10^(-9))/(h*c)} & /@ data;

addFourLists[{list1_, list2_, list3_, list4_}] := 
  If[list1[[All, 1]] == list2[[All, 1]] == list3[[All, 1]] == 
    list4[[All, 1]],
   Transpose[{list1[[All, 1]], 
     list1[[All, 2]] + list2[[All, 2]] + list3[[All, 2]] + 
      list4[[All, 2]]}]
   ];
(* Constants  *) 
(*Constants*)
c = 299792458.;(*units:m/s*)
h = 6.6260695729*10^(-34) // N; (*units:J s-Planck's Constant*)
h2 = 4.136*10^(-15) // N; (*units:eV s-Planck's Constant*)
q = 1.60217657*10^(-19) // N; (*units:Coulombs*)
k = 8.617*10^(\[Minus]5) // N;(*units:eV/K*)
T = 298.15 // N;(*units:K*)
fac = h *c *10^(9)/q // N ;
k2 = 1.3807*10^(-23) // N;  (*J/K*)
ClearSystemCache[];

(* Spectra Conversion Functions   *) 
(*spectra conversion functions*)
(*Function to calculate the flux of a solar spectrum*)
(*units:A/(m^2 eV)*)
makeFlux[
   data_] := {fac/#[[1]], (h*c)/(fac/#[[1]])^(2)*#[[1]]/(h*c)*#[[
       2]](*W/m^2/nm*)} & /@ data;
makeFluxnm[data_] := {#[[1]], q*#[[2]]*(#[[1]] 10^(-9))/(h*c)} & /@ 
   data;
unmakeFlux[
   data_] := {fac/#[[1]], #[[
       2]]*(h*c)/(fac/#[[1]])*(fac/(fac/#[[1]]))^(2)/(h *c)} & /@ data;
unmakeFluxnm[data_] := {#[[1]], #[[2]]/q*(h*c)/(#[[1]] 10^(-9))} & /@ 
   data;
(* Temperature Dependencies   *) 
(*Temperature dependencies*)
(*Temperature dependent intrinsic charge carrier concentration from \
K.Misiakos,et al.Accurate Measurements of the Silicon Intrinsic \
Carrier Density from 78 to 340 K.J.Appl.Phys.1993,74,3293\[Dash]3297 \
DOI:10.1063/1.354551*)
(*units:m^-3*)
Sini[T_Real] := 5.29*10^(19)*(T/300.)^(2.54)*Exp[-6726./T]*10^(6);

(*Temperature dependent bandgap is calculated using Varshni\
\[CloseCurlyQuote]s empirical equation with values from the book \
Physics of Semiconductor Devices Physics of Semiconductor \
Devices,Wiley-Interscience,1995 from Sze*)
(*units:eV*)
ClearAll[SiBandgap]
SiBandgap[Temp_Real] := 1.17 - 4.73*10^(-4)* Temp^(2)/(Temp + 636.);

(*Temperature dependent Auger coefficient from J.Dziewior et al.Auger \
Coefficients for Highly Doped and Highly Excited \
Silicon.Appl.Phys.Lett.1977,346,11\[Dash]14 DOI:10.1063/1.89694*)
(*Cn=2.8 x 10^-31 cm^6/s Cp=0.99 x 10^-31cm^6/s units:m^6/s*)
SiC[T_Real] := (2.8 + 0.99)*10^(-43)*(T/300.)^(1./2.);
(* Current  Densities   *) 
(*Current densities*)
(*Radiative recombination current density*)
JRad0Si = 
  q*2*Pi/(c^(2)*h2^(3))*
   NIntegrate[En^(2)/(Exp[En/(k*T)] - 1), {En, SiBandgap[T], 4.4}];
JRSi[V_Real, Il_Real, Rs_Real] := 
  JRad0Si*(Exp[(V + Il*Rs*0.0001)/(k T)] - 1);

(*Auger recombination current density*)
JRAuger[V_Real, Il_Real, Rs_Real, L_Real] := 
  q*L*SiC[T]*Sini[T]^3 (Exp[(3 (V + Il*Rs*0.0001))/(2*k*T)] - 1);

(*Non-radiative recombination current density*)
JRnon[V_Real, Il_Real, Rs_Real, INR_Real] := 
  INR*10^-42 Sini[T]^2 (Exp[(V + Il*Rs*0.0001)/(k T)] - 1);

(*Resistance*)
Resistance[V_Real, Il_Real, Rs_Real, 
   Rsh_Real] := (V + Il*Rs*0.0001)/(Rsh*0.0001);
(* More Constants   *) 
(*Fitting values*)
(*Thickness of silicon for Auger recombination in m*)
thicknesses = {(*1*)1.7*10^-4,(*2*)1.8*10^-4,(*assumption*)(*3*)
   1.8*10^-4,(*4*)1.9*10^-4,(*5*)1.8*10^-4,(*assumption*)(*6*)
   1.8*10^-4,(*assumption*)(*7*)1.9*10^-4,(*8*)1.95*10^-4,(*9*)
   1.5*10^-4,(*10*)2*10^-4,(*11*)1.5*10^-4,(*12*)2*10^-4,(*13*)
   2*10^-4};

(*Parasitic resistances in ohm cm^2*)
Rs = {(*1*)1.48,(*2*)1.15,(*3*)1.35,(*4*)0.82,(*5*)1.28,(*6*)0.73,(*7*)
   0.59,(*8*)0.6,(*9*)0.67,(*10*)0.75,(*11*)0.47,(*12*)0.31,(*13*)
   0.08};
Rsh = {(*1*)1800,(*2*)1300,(*3*)1800,(*4*)1800,(*5*)1200,(*6*)
   2000,(*7*)2000,(*8*)3000,(*9*)2000,(*10*)800,(*11*)4000,(*12*)
   6000,(*13*)10000};

(*Non-radiative recombination*)
INR = {(*1*)58,(*2*)85.7,(*3*)56,(*4*)58,(*5*)10.5,(*6*)43,(*7*)
   35,(*8*)24.1,(*9*)1.5,(*10*)1.95,(*11*)1.7,(*12*)1.41,(*13*)
   1.88485};

(* IV Characteristics   *) 
(*Import JV characteristic*)
IV13 = Import["./Record_Si_cell/13_IV.csv"];
(*Import EQE*)
EQE13 = Import["./Record_Si_cell/13_EQE.csv"];
intEQE13 = Interpolation[EQE13, InterpolationOrder -> 0];
(* Si Effects  *) 
spectraAtSolarCell[monthdata_, timestamp_, altitudePhoton_, 
  azimuthPhoton_, rayTracingPhotons_] := 
 Module[{absAngle, interpolationW, interpolationPhoton, scaledCurrent,
    spectrum, totalspectrumW, photonsPermNm, totalPhoton, 
   outputInterpolCurrenteV, jG, outputCurrent, outputCurrentInterpol, 
   totalOutputCurrent, opticalEfficiency},
  (* if emission max happens to be the same as one of the points in \
spectrum, there will be problem in interpolation, 
  just make sure emission max is an integer *) 
  spectrum = 
   Append[
    makeSpectra[monthdata, timestamp, altitudePhoton, 
     azimuthPhoton], {emissionmax, 0}](*in W/m^2/nm/Xsr*);
  interpolationW = Interpolation[spectrum, InterpolationOrder -> 0];
  totalspectrumW = 
   Integrate[
    interpolationW[\[Lambda]], {\[Lambda], spectrum[[1, 1]], 
     spectrum[[-1, 1]]}];
  
  photonsPermNm = photonsNmMConversion[spectrum](*in photons/m^2/nm/
  Xsr*);
  interpolationPhoton = 
   Interpolation[photonsPermNm, InterpolationOrder -> 0];
  totalPhoton = 
   Integrate[interpolationPhoton[x], {x, 288, emissionmax}];
  
  absAngle = 
   Round[
    90 - Abs[(realAngleAtLSC[altitudePhoton, azimuthPhoton] - 90)]];
  
  (*Make output current for all four sides PER ANGLE  *)
  (* this is a current flux in (*A/m^2/nm/Xsr*) *) 
  scaledCurrentF[side_] := Module[{output, result}, 
    WithCleanup[
     SetSystemOptions[
      "CompileOptions" -> "TableCompileLength" -> Infinity],
     output = 
       Table[{wlength, 
         q* N[interpolationPhoton[wlength]]/(N[totalphotonsin]) *
          Normal[
           raytracingdata[[side, absAngle, 
            wlength - emissionmin + 1]]]} , {wlength, emissionmin, 
         emissionmax, 1}];,
     SetSystemOptions[
      "CompileOptions" -> "TableCompileLength" -> 250]];
    (* this is just the output spectra *) 
    output = output[[;; , 2]];
    (* result is {nm out, total} *)
    result = 
     Table[{\[Lambda], 
       Total[output[[;; , \[Lambda] - emissionmin + 1]]]}, {\[Lambda],
        wavelengthtable[[;; , 1]]}];
    Return[result]
    ];
  
  (* add each side *) 
  outputCurrent = 
   addFourLists[{scaledCurrentF[1], scaledCurrentF[2], 
     scaledCurrentF[3], scaledCurrentF[4]}];
  
  (* interpolate the current, for all 4 sides, convert to W/m^2/sr*) 
  outputCurrentInterpol = 
   Interpolation[outputCurrent, InterpolationOrder -> 0];
  totalOutputpower = 
   NIntegrate[(N[1240/x])*outputCurrentInterpol[x], {x, 
     outputCurrent[[1, 1]], emissionmax}];
  
  (* convert to eV -(*in A/m^2/sr*) *) 
  outputInterpolCurrenteV = 
   Interpolation[nmToeV[outputCurrent], InterpolationOrder -> 0];
  jG = NIntegrate[
    intEQE13[En]*outputInterpolCurrenteV[En], {En, 
     fac/outputCurrent[[-1, 1]], fac/outputCurrent[[1, 1]]}, 
    MaxRecursion -> 10000, WorkingPrecision -> 4];
  
  
  {totalspectrumW, totalPhoton, totalOutputpower, jG}
  ]

sicell[areasurface_, areaside_, side_Integer, monthvalue_, 
   pointinmonth_Integer] := 
  Module[{time, incidentangle, spectradirect, spectradiffuse, 
    intspectradirect, intspectradiffuse, intfluxnmdirect, 
    intfluxnmdiffuse, concentration, totalincidentpowerdiffuse, 
    totalconcentratedincidentpowerdiffuse, totalincidentpowerdirect, 
    totalconcentratedincidentpowerdirect, totalfluxdiffuse, 
    totalfluxdirect, LSCoutputlistdirect, sidespectrafluxdirect, 
    LSCoutputlistdiffuse, sidespectrafluxdiffuse, sidespectradirect, 
    sidespectradiffuse, outputpowerLSCdiffuse, outputpowerLSCdirect, 
    JG, jg, dSi, totalefficiency, outputpowerLSC, LSCefficiency, 
    efficiency, JGdirect, LSCfluxefficiencydirect, 
    LSCfluxefficiencydiffuse, kwhSi, kwhLSCdirect, kwhLSCdiffuse, 
    monthdata},
   
   (* select the data you want from the LAD *) 
   monthdata = monthdatalad;
   date = DateString[DateObject[monthdata[[pointinmonth, 1]]]];
   Print[date];
   ClearSystemCache[];
   
   (* geometric concentration *) 
   concentration = N[areasurface/(4*areaside)];
   
   (* this calculates the spectra at every angle in altitude and \
azimuth at up to every 10s interval throughout the year if this \
number of steps are changed (10 and 20) you must also change the \
solid angle - in the function angleopening function*) 
   (* spectra at solarcell outputs {totalspectrumW,totalPhoton,
   totalOutputCurrent,jG} *) 
   spectraAtSolarCelltemp = 
    Flatten[
     Table[
      spectraAtSolarCell[monthdata, pointinmonth,(*angle alt*)
       alt,(*angle azi*)azi, totalphotonsin], {alt, 1, 179, 
       180/10}, {azi, 1, 359, 360/20}], 1];
   
   (* total current density A/m^2 , from each angle *) 
   jg = 1*concentration *Total[spectraAtSolarCelltemp[[All, 4]]];
   Print["jg:  " <> ToString[jg]];
   (* total incoming power density onto the LSC *)
   (* remembver, if you change the step size in alt or azi, 
   you need to make sure that you are dealing with the solid angle \
incomign correctly *) 
   totalIncomingPower = Total[spectraAtSolarCelltemp[[All, 1]]];
   Print[
    "incoming Power:  " <> ToString[totalIncomingPower] <> "in W/m^2"];
   
   (* calculate total power, which in W/m^2 *) 
   totaloutputLSCpower = Total[spectraAtSolarCelltemp[[All, 3]]];
   Print[
    "totaloutputLSCpower:  " <> ToString[totaloutputLSCpower] <> 
     "in W/m^2"];
   
   (*Make JV characteristic in A/m^2*)
   dSi = 
    Table[{v1, 
      FindRoot[
        Il == 
         jg - JRSi[v1, Il, Rs[[cell]]] - 
          JRAuger[v1, Il, Rs[[cell]], thicknesses[[cell]]] - 
          JRnon[v1, Il, Rs[[cell]], INR[[cell]]] - 
          Resistance[v1, Il, Rs[[cell]], Rsh[[cell]]], {Il, 0}, 
        PrecisionGoal -> 5, MaxIterations -> 10000][[1, 2]]}, {v1, 0, 
      SiBandgap[T] - 0.3, .005}];
   ivSi = Interpolation[dSi, InterpolationOrder -> 0];
   (*Calculate Voc*)
   vocSi = FindRoot[ivSi[v], {v, SiBandgap[T] - 0.4}][[1, 2]];
   (*Calculate Jsc*)
   jscSi = ivSi[0]/10;(*mA/cm^2*)
   (*Finding the maximum power conversion efficiency of the Si cell*)

   
   eff = 
    NMaximize[{100*ivSi[V] *V/totalIncomingPower, 
      0 < V < SiBandgap[T] - 0.3}, V];
   efficiency = eff[[1]];
   (*efficiency of Si*)
   maxvoltage = V /. eff[[2]];
   maxcurrent = ivSi[maxvoltage] ;(*A/m^2*)
   
   (* efficiency of LSC, relative to surface area *)
   	(* power into the LSC vs power out of the side of LSC BEFORE \
impinging onto silicon cell 
   	outputpower LSC is in W/(m^2) as is totalincidentpowerdirect+
   totalincidentpowerdiffuse*) 
   	outputpowerlsc = areaside*totaloutputLSCpower;
   	inputpower = (areasurface*(totalIncomingPower));
   	lscPCE = outputpowerlsc/inputpower;
   
   	(* si PCE is the PCE from the LSC output *) 
   	siPCE = (maxcurrent*maxvoltage)/outputpowerlsc;
   
   
   (* efficiency of LSC & Si system, relative to surface area *)
   totalefficiency = (maxcurrent*maxvoltage)/(inputpower);
   
   (* divide by 1000 for k in kwh - 
   this much be changed if you change the step size *) 
   kwh = (maxcurrent*maxvoltage)*(15/60)/1000;
   
   Return[{month, pointinmonth, ToString[date], side, totalefficiency,
      lscPCE, siPCE, kwh, inputpower, outputpowerlsc, siPCE}];
   
   ];
(*Show[ListPlot[90-Abs[(Flatten[Table[Round[realAngleAtLSC[alt,azi]],{\
alt,1,180,180/10},{azi,1,359,360/20}],1]-90)],Joined\[Rule]True,\
GridLines\[Rule]{{}, \
{90}},PlotRange\[Rule]180],ListPlot[Flatten[Table[Round[\
realAngleAtLSC[alt,azi]],{alt,1,180,180/10},{azi,1,359,360/20}],1],\
Joined\[Rule]True,GridLines\[Rule]{{}, \
{90}},PlotRange\[Rule]All,PlotStyle\[Rule]Red]]*)
(* Run the Model   *) 

(* this outputs for all sides, no need to do it individually like the \
colorado function *) 
(* the lad is in 10 second increments, lets do 15 mins steps (also \
efficiencies are matched to that ), hence  *) 
(* 24 hours = 1440 minutes = 86400 seconds*)
(* 8640 10 second increments seconds in day *)
(* 15 minutes = 15*60 = 900 seconds, so move in steps of 90 to get 15 \
minutes resolution  *)
areafront = 0.1*0.1; 
areaside = 10*1/3*(10^(-2))^2 ; (*0.1*0.00333333 *)

Table[
  string = 
   "./results_amolf_upright/" <> ToString[monthvalue] <> "_" <> 
    ToString[time] <> ".csv";
  resulttoexport = 
   sicell[(10*10^(-2))^2, 10*1/3*(10^(-2))^2, 1 (* not needed*), 
    monthvalue (* month value*), time(* point in month *)];
  Export[string, resulttoexport, "CSV"];, {time, timepoint, 
   timepoint + 8640, 90}];

(* Geneate .xls script   *) 
In[1]:= (* Delete all output and quit kernl before running this *) 

nb = InputNotebook[];
fn = FileNameJoin[{"analysis_amolf_dot_LSC.wls"}];
FrontEndExecute[FrontEndToken[nb, "Save", {fn, "Text"}]]
(* Import the Results   *) 