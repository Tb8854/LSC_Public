#!/usr/bin/env wolframscript
(* ::Package:: *)

(*CreatePalette@Button["Disable \
Evaluation",SelectionMove[SelectedNotebook[],All,Cell];
SetOptions[NotebookSelection[SelectedNotebook[]],Evaluatable\[Rule]\
False]]*)
(* Set Up Computer Options *) 
numkernel = 16;
Unprotect[$ProcessorCount];
$ProcessorCount = numkernel;

CreateDirectory["Results"];
CreateDirectory["Results_plqe"];
CreateDirectory["side_emission"];

(* Set Up Simulation Options *) 
(* ----- Notebook Running Running ----- *) 

(*startwavelength=420;
startangle=90;
endangle=91;
NumberOfPhotons=100;
QuantumYield=1;
concentration=0.1; *) 

list = {{456,26},{456,27},{456,28},{456,29},{456,30},{456,31},{456,32},{456,33},{456,34},{456,35},{456,36},{456,37},{456,38},{456,39},{456,40},{456,41},{456,42},{456,43},{456,44},{456,45},{456,46},{456,47},{456,48},{456,68},{456,69},{456,70},{456,71},{456,72},{456,73},{456,74},{456,75},{456,76},{456,77},{456,78},{456,79},{456,80},{456,81},{456,82},{456,83},{456,84},{456,85},{456,86},{456,87},{456,88},{456,89},{457,27},{457,28},{457,29},{457,30},{457,31},{457,32},{457,33},{457,34},{457,35},{457,36},{457,37},{457,38},{457,39},{457,40},{457,41},{457,42},{457,43},{457,44},{457,45},{457,46},{457,47},{457,48},{457,71},{457,72},{457,73},{457,74},{457,75},{457,76},{457,77},{457,78},{457,79},{457,80},{457,81},{457,82},{457,83},{457,84},{457,85},{457,86},{457,87},{457,88},{457,89},{458,34},{458,35},{458,36},{458,37},{458,38},{458,39},{458,40},{458,41},{458,42},{458,43},{458,44},{458,45},{458,46},{458,47},{458,48},{458,79},{458,80},{458,81},{458,82},{458,83},{458,84},{458,85},{458,86},{458,87},{458,88},{458,89},{459,37},{459,38},{459,39},{459,40},{459,41},{459,42},{459,43},{459,44},{459,45},{459,46},{459,47},{459,48},{459,83},{459,84},{459,85},{459,86},{459,87},{459,88},{459,89},{460,39},{460,40},{460,41},{460,42},{460,43},{460,44},{460,45},{460,46},{460,47},{460,48},{460,84},{460,85},{460,86},{460,87},{460,88},{460,89},{461,44},{461,45},{461,46},{461,47},{461,48},{461,85},{461,86},{461,87},{461,88},{461,89},{462,44},{462,45},{462,46},{462,47},{462,48},{462,86},{462,87},{462,88},{462,89},{463,43},{463,44},{463,45},{463,46},{463,47},{463,48},{463,83},{463,84},{463,85},{463,86},{463,87},{463,88},{463,89},{464,42},{464,43},{464,44},{464,45},{464,46},{464,47},{464,48},{464,83},{464,84},{464,85},{464,86},{464,87},{464,88},{464,89},{465,19},{465,20},{465,21},{465,22},{465,23},{465,24},{465,25},{465,26},{465,27},{465,28},{465,29},{465,30},{465,31},{465,32},{465,33},{465,34},{465,35},{465,36},{465,37},{465,38},{465,39},{465,40},{465,41},{465,42},{465,43},{465,44},{465,45},{465,46},{465,47},{465,48},{465,83},{465,84},{465,85},{465,86},{465,87},{465,88},{465,89},{466,20},{466,21},{466,22},{466,23},{466,24},{466,25},{466,26},{466,27},{466,28},{466,29},{466,30},{466,31},{466,32},{466,33},{466,34},{466,35},{466,36},{466,37},{466,38},{466,39},{466,40},{466,41},{466,42},{466,43},{466,44},{466,45},{466,46},{466,47},{466,48},{466,85},{466,86},{466,87},{466,88},{466,89},{467,19},{467,20},{467,21},{467,22},{467,23},{467,24},{467,25},{467,26},{467,27},{467,28},{467,29},{467,30},{467,31},{467,32},{467,33},{467,34},{467,35},{467,36},{467,37},{467,38},{467,39},{467,40},{467,41},{467,42},{467,43},{467,44},{467,45},{467,46},{467,47},{467,48},{467,89},{468,20},{468,21},{468,22},{468,23},{468,24},{468,25},{468,26},{468,27},{468,28},{468,29},{468,30},{468,31},{468,32},{468,33},{468,34},{468,35},{468,36},{468,37},{468,38},{468,39},{468,40},{468,41},{468,42},{468,43},{468,44},{468,45},{468,46},{468,47},{468,48},{469,32},{469,33},{469,34},{469,35},{469,36},{469,37},{469,38},{469,39},{469,40},{469,41},{469,42},{469,43},{469,44},{469,45},{469,46},{469,47},{469,48},{469,74},{469,75},{469,76},{469,77},{469,78},{469,79},{469,80},{469,81},{469,82},{469,83},{469,84},{469,85},{469,86},{469,87},{469,88},{469,89},{470,30},{470,31},{470,32},{470,33},{470,34},{470,35},{470,36},{470,37},{470,38},{470,39},{470,40},{470,41},{470,42},{470,43},{470,44},{470,45},{470,46},{470,47},{470,48},{470,74},{470,75},{470,76},{470,77},{470,78},{470,79},{470,80},{470,81},{470,82},{470,83},{470,84},{470,85},{470,86},{470,87},{470,88},{470,89},{471,31},{471,32},{471,33},{471,34},{471,35},{471,36},{471,37},{471,38},{471,39},{471,40},{471,41},{471,42},{471,43},{471,44},{471,45},{471,46},{471,47},{471,48},{471,73},{471,74},{471,75},{471,76},{471,77},{471,78},{471,79},{471,80},{471,81},{471,82},{471,83},{471,84},{471,85},{471,86},{471,87},{471,88},{471,89},{472,31},{472,32},{472,33},{472,34},{472,35},{472,36},{472,37},{472,38},{472,39},{472,40},{472,41},{472,42},{472,43},{472,44},{472,45},{472,46},{472,47},{472,48},{472,72},{472,73},{472,74},{472,75},{472,76},{472,77},{472,78},{472,79},{472,80},{472,81},{472,82},{472,83},{472,84},{472,85},{472,86},{472,87},{472,88},{472,89},{473,31},{473,32},{473,33},{473,34},{473,35},{473,36},{473,37},{473,38},{473,39},{473,40},{473,41},{473,42},{473,43},{473,44},{473,45},{473,46},{473,47},{473,48},{473,72},{473,73},{473,74},{473,75},{473,76},{473,77},{473,78},{473,79},{473,80},{473,81},{473,82},{473,83},{473,84},{473,85},{473,86},{473,87},{473,88},{473,89},{474,31},{474,32},{474,33},{474,34},{474,35},{474,36},{474,37},{474,38},{474,39},{474,40},{474,41},{474,42},{474,43},{474,44},{474,45},{474,46},{474,47},{474,48},{474,72},{474,73},{474,74},{474,75},{474,76},{474,77},{474,78},{474,79},{474,80},{474,81},{474,82},{474,83},{474,84},{474,85},{474,86},{474,87},{474,88},{474,89},{475,31},{475,32},{475,33},{475,34},{475,35},{475,36},{475,37},{475,38},{475,39},{475,40},{475,41},{475,42},{475,43},{475,44},{475,45},{475,46},{475,47},{475,48},{475,73},{475,74},{475,75},{475,76},{475,77},{475,78},{475,79},{475,80},{475,81},{475,82},{475,83},{475,84},{475,85},{475,86},{475,87},{475,88},{475,89},{476,31},{476,32},{476,33},{476,34},{476,35},{476,36},{476,37},{476,38},{476,39},{476,40},{476,41},{476,42},{476,43},{476,44},{476,45},{476,46},{476,47},{476,48},{476,73},{476,74},{476,75},{476,76},{476,77},{476,78},{476,79},{476,80},{476,81},{476,82},{476,83},{476,84},{476,85},{476,86},{476,87},{476,88},{476,89},{477,33},{477,34},{477,35},{477,36},{477,37},{477,38},{477,39},{477,40},{477,41},{477,42},{477,43},{477,44},{477,45},{477,46},{477,47},{477,48},{477,75},{477,76},{477,77},{477,78},{477,79},{477,80},{477,81},{477,82},{477,83},{477,84},{477,85},{477,86},{477,87},{477,88},{477,89},{478,33},{478,34},{478,35},{478,36},{478,37},{478,38},{478,39},{478,40},{478,41},{478,42},{478,43},{478,44},{478,45},{478,46},{478,47},{478,48},{478,74},{478,75},{478,76},{478,77},{478,78},{478,79},{478,80},{478,81},{478,82},{478,83},{478,84},{478,85},{478,86},{478,87},{478,88},{478,89},{479,46},{479,47},{479,48}};


(* ----- Command Line Running ----- *) 
cmddata = $ScriptCommandLine;
startwavelength = ToExpression[cmddata[[2]]]; (* now is list value *) 
startangle = ToExpression[cmddata[[3]]];
endangle = ToExpression[cmddata[[4]]];
NumberOfPhotons = ToExpression[cmddata[[5]]];
QuantumYield = ToExpression[cmddata[[6]]];
concentration = N[ToExpression[cmddata[[7]]]]; 

startangle = list[[startwavelength,2]];
endangle = startangle+1;
startwavelength=list[[startwavelength,1]];

singletfission = True;  (* move to True[] *) 
graphics = False; 

(* Import Spectra *) 

(* Solar Spectrum *) 
files = FileNames["*", "../Spectra/Solar_spectrum_NREL/"][[1]];
AM15 = Import[files];
AM15 = Delete[AM15, 1];
AM15 = Drop[AM15, {}, {2, 3}];
AM15[[2 ;;, 2]] = AM15[[2 ;;, 2]]/Total[AM15[[2 ;;, 2]]];
CDFspectrum = AM15;
CDFspectrum[[2 ;;, 2]] = Accumulate[AM15[[2 ;;, 2]]];
solarspectrum = CDFspectrum;
solarspectrum = Drop[solarspectrum = CDFspectrum, 1];
solarspectrumx = solarspectrum[[;; , 1]];
solarspectrumy = solarspectrum[[;; , 2]];
solarspectrum[[;; , 1]] = solarspectrumy;
solarspectrum[[;; , 2]] = solarspectrumx;

solarspectrum = 
  Union[solarspectrum, SameTest -> (#1[[1]] == #2[[1]] &)];
intsolar = Interpolation[solarspectrum, InterpolationOrder -> 0];
(* Substrate Absorption *) 
(* absorption spectrum needs to be in cm^-1 *) 
AbsorptionSpectra = Table[{x, 1*10^(-4)}, {x, 200, 5000, 1}];
intabsorption = 
  Interpolation[DeleteDuplicatesBy[AbsorptionSpectra, First]];
(* Chromophore  Emission *) 
(*files=FileNames["*.txt","../Spectra/Emission_spectra_ybCDF/"][[1]];
EmissionSpectra=Import[files,"CSV"];
EmissionSpectra2=EmissionSpectra;
EmissionSpectra2[[;;,1]]=EmissionSpectra[[;;,2]];
EmissionSpectra2[[;;,2]]=EmissionSpectra[[;;,1]];
EmissionSpectra=EmissionSpectra2;
EmissionSpectra=DeleteDuplicatesBy[EmissionSpectra,First];
EmissionSpectra=Join[EmissionSpectra[[2;;]],{{0,500}}];
emissionint=Interpolation[EmissionSpectra,InterpolationOrder\[Rule]0];\
*) 

files = FileNames["*.txt", "../Spectra/Emission_YbZwit3/"][[1]];
EmissionSpectra = Import[files, "Data"];
EmissionSpectra = ToExpression[EmissionSpectra[[23 ;;, 1 ;; 2]]];
EmissionSpectra[[2 ;;, 2]] = 
  EmissionSpectra[[2 ;;, 2]]/Total[EmissionSpectra[[2 ;;, 2]]];
CDFspectrum = EmissionSpectra;
CDFspectrum[[2 ;;, 2]] = Accumulate[EmissionSpectra[[2 ;;, 2]]];
EmissionSpectra = Drop[CDFspectrum, 1];
EmissionSpectra = Join[EmissionSpectra, {{0, 500}}];
EmissionSpectra2 = EmissionSpectra;
EmissionSpectra2[[;; , 1]] = EmissionSpectra[[;; , 2]];
EmissionSpectra2[[;; , 2]] = EmissionSpectra[[;; , 1]];
emissionint = 
  Interpolation[EmissionSpectra2, InterpolationOrder -> 0];
(* Chromophore Absorption / Extinction Spectrum *) 
(* in M^-1 cm^-1 *)  

files = FileNames["*.csv","../Spectra/Extinction_spectra_CdPLbCl/"][[1]];
ExtinctionSpectra = Import[files, "CSV"];
ExtinctionSpectra = Join[ExtinctionSpectra[[2 ;;]], {{5000, 0}}];
ExtinctionSpectra = Join[ExtinctionSpectra[[2 ;;]], {{300, 55000}}];
ExtinctionSpectra = Join[ExtinctionSpectra[[2 ;;]], {{200, 55000}}];
ExtinctionSpectra = Join[ExtinctionSpectra[[2 ;;]], {{100, 55000}}];
ExtinctionSpectra = Sort[ExtinctionSpectra];
intextinction = 
  Interpolation[DeleteDuplicatesBy[ExtinctionSpectra, First], 
   InterpolationOrder -> 1];
(* Emission Angle *) 
files = FileNames["*.txt", "../Spectra/Emission_Angle_Nate/"][[1]];
AngleSpectra = Import[files, "Table"];
AngleSpectra = Reverse /@ AngleSpectra;

AngleSpectra2 = AngleSpectra;
AngleSpectra2[[;; , 1]] = AngleSpectra[[;; , 2]];
AngleSpectra2[[;; , 2]] = AngleSpectra[[;; , 1]];
AngleSpectra = DeleteDuplicatesBy[AngleSpectra2, First];
angleint = Interpolation[AngleSpectra, InterpolationOrder -> 1];
(* LSC Properties *) 
(* Define Shape *) 
(*do not let edges of the LSC rest on x,y or z=0 this is because the \
numeric solver uses the first 7 bytes to confirm that they are \
equaul,but the first bit is the postive or negative test,so it won't \
work-and you'll get strange things*)
(*use this is you want a shape \
with negative vertices \
Cuboid@@Transpose[Sort/@Transpose[{{0,0,0},{1,1,-1}}]]*)

lscheight = 1/3;
effectivemax = lscheight + 1; 
lscoffset = 5; 
lsclength = 10; 

shape1 = 
  Cuboid[{lscoffset, lscoffset, 1}, {lscoffset + lsclength, 
    lscoffset + lsclength, effectivemax}];
(* add shapes in this list to make a more complicated shape *) 
shapes = {shape1};

(*deals with multiple shapes,creating boundrary expressions etc for n \
shapes *)
constraints[shapes__] := 
 And[## & @@ (Not /@ 
      Through[(RegionMember[RegionIntersection@##] & @@@ 
          Subsets[{shapes}, {2}])@#]), 
   RegionMember[RegionUnion @@ (RegionBoundary /@ {shapes})]@#] &

constraint = constraints[shape1];

(* Check the region is 3D. If not, make it 3D, for example, use \
Ball[] instead of Sphere[] *)
RegionDimension[shapes];

(* Define Solar Cells  *)  
(*use this to determine solar cell surfaces, i.e. where the solar \
cell surfaces are *)
(* i.e. you have to change this statement in the \
simulation *) 

(* index \[Equal]{4,2}|| index \[Equal]{5,2}|| index \
\[Equal]{3,2}||index \[Equal]{2,2} *) 
(* remember there are two *) 

(* Define Refractive Index *) 
(*air*)
n1 = 1.0;
(*LSC*)
n2 = N[1.5];

(* Advanced Simulation Options *)
(*When a photon is reflected,it needs a slight movement to make sure \
that it isn't caught again in transmission i.e.if it remains in the \
same location on the surface it satifies the conditions for \
transmission,so movementerror shifts the photon a little to prevent \
this from happening, as long as 
movement error is much smaller than the length order of your LSC, you \
will be good. *)
movementerror = 0.001;
(*corressponds to the simulation area, it just needs to be larger \
than the LSC *)
maxsize = 10000000;
(*movement away when no intersection is found. This is just to make \
it the simulation look good. So, for example, if at intersection \
detected at the LSC results in no other intersection (i.e. it has \
left the simulation), and no intersection was found, this move the \
photon 10 units, just  so we have rays of the photons leaving the LSC \
rather than just sitting there. *)
movementjump = 10;
(* Photon Starting Locations *) 
(* height of photon spawn *) 
height = 5.;
(* offset where photons spawn in x & y dimensions *) 
photonoffset = 0.2; 
offsetxstart = lscoffset + photonoffset;
offsety = lscoffset + photonoffset;
(* from the offset, over what distance do they spawn? *) 
LSCspawnlengthx = lsclength - 2*photonoffset;(*cm*)

LSCspawnlengthy = lsclength - 2*photonoffset;(*cm *) 
(*places where photons can spawn,so a 100 means the photons can spawn \
in 100 locations along the x axis and 100 locations along the y \
axis,so 100*2 in total*)
PhotonLocationResolution = 100;

(*Picks a photon location according to the distrubtion defined in top \
section*)
randphotonlocation[] := Module[{pos, values, location},
   location = {RandomReal[], RandomReal[]}];


(* after emission from a chromophore, how does the chromophore emit? *) \

finddirection[] := 
  Module[{zenithanglevalue, azimuthalanglevalue, x, y, z, direction}, 
   zenithanglevalue = zenithangle[];
   azimuthalanglevalue = azimuthalangle[];
   (*Convert to cartesians,using r=
   1*)(*note the zenith angle is also known as the polar angle*)
   
   x = 1*Cos[azimuthalanglevalue]*Sin[zenithanglevalue];
   y = 1*Sin[azimuthalanglevalue]*Sin[zenithanglevalue];
   z = 1*Cos[zenithanglevalue];
   direction = {x, y, z};
   direction = Normalize[direction];
   Return[direction]];
(*for monitoring progress over multiple kernels*)


(* Spectral Functions *)
(*-------------finds random lambda from solar spectrum---------------*)
\

solarspectrumLambda[] := 
  Module[{rand, randspec, specclose, cdfvalue, index},
   (*lambda=intsolar[RandomReal[]];*)
   lambda = selectedwavelength;
   Return[lambda];
   ];

(*the extinction spectra is the absorbance mole per cm2*)

extinctionvalueForlambda[lambda_] := 
  Module[{lambdaavalue, index, extinctionvalue},
   extinctionvalue = intextinction[lambda];
   Return[extinctionvalue]];

(*substrate absorption spectra*)

substrateabsorptionForLambda[lambda_] := 
  Module[{lambdaavalue, index, substrateabsorption},
   substrateabsorption = intabsorption[lambda];
   Return[substrateabsorption]];

(* pick emission wavelength *)

emissionwavelength[] := 
 Module[{rand, randspec, specclose, cdfvalue, index, lambda},
  lambda = emissionint[RandomReal[]];
  Return[lambda]]

(*Pick angle of emission*)

zenithangle[] := 
 Module[{randanglespec, randangle, cdfanglevalue, index, 
   zenithangle},
  zenithangle = angleint[RandomReal[]];
  Return[zenithangle]]

(*Azimuthal Angle*)
azimuthalangle[] := Module[{azimuthalangle},
  azimuthalangle = RandomReal[]*2*Pi;
  Return[azimuthalangle]]


(* Normal& Intersection Finding Functions *) 
(*for more than 1 shape, change constaint to \
constaints[s]-i.e.insclude shapes and pass to the function*)
intersections[l_, s__] := 
 NSolve[# \[Element] l && constraint[#], #] &@({x, y, z}[[;; 
     RegionEmbeddingDimension[l]]])

(*finds normals*)
standardize[a_ <= b_] := a - b;
standardize[a_ >= b_] := b - a;
regnormal[reg_, {x_, y_, z_}] := 
  Module[{impl}, 
   impl = 
    LogicalExpand@
     Simplify[
      RegionMember[reg, {x, y, z}], {x, y, z} \[Element] Reals];
   If[Head@impl === Or, impl = List @@ impl, impl = List@impl];
   impl = Replace[impl, {Verbatim[And][a___] :> {a}, e_ :> {e}}, 1];
   Piecewise[
    Flatten[
     Function[{component}, 
       Table[{D[standardize[component[[i]]], {{x, y, z}}], 
         Simplify[(And @@ Drop[component, {i}] /. {LessEqual -> Less, 
              GreaterEqual -> Greater}) && (component[[
              i]] /. {LessEqual -> Equal, GreaterEqual -> Equal}), 
          TransformationFunctions -> {Automatic, 
            Reduce[#, {}, Reals] &}]}, {i, Length@component}]] /@ 
      impl, 1], Indeterminate]];

(* determine the normals for the shape *) 
normals = regnormal[RegionUnion[##] & @@ shapes, {x, y, z}];
(* Transmission or Reflection *) 
(*this function takes in an angle between two vectors and determines \
if it should be a reflection or refraction interaction,returning \
either "tramission" or "reflection"*)

transmissionorreflectibity[thetai_, n1_, n2_] := 
  Block[{rs, rp, ts, tp, transmission, reflectivity, result, 
    reflectionprob, transmissionprob, costhetat, sin2theta},
   
   If[index == {4, 2} || index == {5, 2} || index == {3, 2} || 
     index == {2, 2}, 
    plqecount[];
    Return[{"transmission"}];
    ];
   
   
   (* into the LSC , check if above cirtical angle*) 
   If[n1 > n2 && thetai > ArcSin[n2/n1], 
    reflectionprob = 1.; 
    transmissionprob = 1 - reflectionprob;
    result = 
     RandomChoice[{reflectionprob, 
        transmissionprob} -> {{"reflection"}, {"transmission"}}];
    Return[result]; 
    ]; 
   
   (* otherwise *) 
   sin2theta = (n1/n2)^(2) (1 - Cos[thetai]^(2));
   costhetat = (1 - sin2theta)^(1/2);
   rs = N[((n1*Cos[thetai] - n2*costhetat)/(n1*Cos[thetai] + 
          n2*costhetat))^2];
   rp = N[((n2*Cos[thetai] - n1*costhetat)/(n2*Cos[thetai] + 
          n1*costhetat))^2];
   reflectionprob = (rs + rp)/2; 
   transmissionprob = 1. - reflectionprob;
   result = 
    RandomChoice[{reflectionprob, 
       transmissionprob} -> {{"reflection"}, {"transmission"}}];
   Return[result]; 
   ]; 



(* LSC Raytracing *) 
raytracing[point_, direction_] := Module[{directiontemp},
   Clear[x, y, z];
   Clear[index];
   directiontemp = direction;
   
   (*how many surfaces of the shape*)
   
   surfaces = Length[normals[[1]]];
   
   (* this forces mathematica to give an exact result *) 
   If[0 == directiontemp[[1]], 
    directiontemp = directiontemp + {0.00001, 0, 0};];
   If[0 == directiontemp[[2]], 
    directiontemp = directiontemp + {0, 0.00001, 0};];
   If[0 == directiontemp[[3]], 
    directiontemp = directiontemp + {0, 0, 0.00001};];
   
   (*this line points along the direction for an infinite length \
along the direction of motion*)
   
   line = HalfLine[{point, point + directiontemp}];
   
   (* find intersection & delete duplicates *) 
   intersection = intersections[line, ##] & @@ shapes;
   intersection = DeleteDuplicates[intersection];
   
   If[intersection == {},
    Return["no_intersection"]
    ];
   
   (*find intersection  closest to point *)
   
   list = EuclideanDistance[{x, y, z} /. #, point] & /@ intersection;
   intersection = intersection[[Ordering[list, 1]]][[1]];
   
   (* find index from normals which satifies the surface condition \
(i.e.true)*)
   (*sometimes there is a discrepancy between the \
intersectiona and the normal,
   so the equals block allows some leeway*)(*the equalTolerence will \
not deal with negative numbers well. 
   MUST ENSURE THAT NO NEGATIVE NUMBERS ARE AROUND *)
   
   Block[{Internal`$EqualTolerance = Log10[2.^28]},
    (* ~single-precision FP equality*)
    
    index = 
      Flatten[Position[normals[[1, ;;]] /. intersection, True]];
    ];
   
   (*if index is null, it means the photon has hit the corner, 
   so just move onto next photon*)
   
   If[index == {}, Return["no_intersection"]];
   
   (* select correct normal *)
   
   normal = normals[[1, index[[1]], 1]] /. intersection;
   
   normal = N[Normalize[normal]];
   directionr = N[Normalize[directiontemp]];
   
   (*check if inside,then reverse normal and refractive indices*)
   
   If[RegionMember[RegionUnion[##], point] & @@ shapes,
    (* TRUE: inside LSC to outside *) 
    normal = -normal;
    (* if hiting solar cell edge, 
    just let the photon pass through *) 
    If[index == {4, 2} || index == {5, 2} || index == {3, 2} || 
      index == {2, 2}, 
     Return[{{"intersection", intersection}, {"reflection", 
         directionr}, {"refraction", directionr}, {"normal", normal}}];
     ];
    
    costheta = -(Dot[ directionr, normal]);
    reflection  = directionr + 2*costheta*normal;
    sin2theta = (n2/n1)^(2)*(1 - costheta^2); 
    refraction = (n2/n1)*
       directionr + ((n2/n1)*costheta - (1 - sin2theta)^(1/2))*normal; 
    ,
    (* False: outside LSC to inside, so switch order of n1 and n2 *) 
    costheta = -(Dot[ directionr, normal]);
    reflection  = directionr + 2*costheta*normal;
    sin2theta = (n1/n2)^(2)*(1 - costheta^2); 
    refraction = (n1/n2)*
       directionr + ((n1/n2)*costheta - (1 - sin2theta)^(1/2))*normal; 
    ];
   
   (*Return Relection and Refraction*)
   
   Return[{{"intersection", intersection}, {"reflection", 
      reflection}, {"refraction", refraction}, {"normal", normal}}]];
(* Luminophore Absorption *) 
(* absorblocation[] either returns a location where the photon ends \
up, or exits to Label[leavingevent] which corressponds to the photon \
leaving the LSC *)  
(* care must be taken because global variables are being changed *) 
aborsorbloction[] := Module[{rayresults},
  (*loop until an absorbing location is found, 
  or until no intersection is found (i.e. left LSC)  *)
  
  While[1 < 2,
    
    direction = Normalize[direction];
    rayresults = raytracing[N[location], N[direction]];
    
    (*Catch if the photon is leaving, i.e ,no intersection, 
    LeavingEvent checks if the photon may reenter the LSC (for \
complex shapes) *)
    If["no_intersection" === rayresults,
     Goto[LeavingEvent];
     ];
    
    (* Assume that the LSC will find an intersection - 
    this gives a path to follow. If the pathlength is long enough, 
    we will get to it *)
    
    intersection = {x, y, z} /. rayresults[[1, 2]];
    reflection = rayresults[[2, 2]];
    refraction = rayresults[[3, 2]];
    normal = rayresults[[4, 2]];
    
    (* Check if we make it to the intersection *)
    
    If[EuclideanDistance[location, intersection] < pathlength,
     (* TRUE: 
     if path length is longer than distance to next intersection, 
     find if we reflect or are refracted through the surface *) 
     If[transmissionorreflectibity[VectorAngle[-direction, normal], 
          n2, n1][[1]] == "transmission",
       (* If transmission is true, then we have left the LSC *)
      
        photonlives[[i]] = 
        Append[
         photonlives[[i]], {"Transmission", intersection, refraction, 
          lambda}];
       location = intersection + movementerror*refraction;
       direction = refraction;
       (* check if the photon renters the LSC *) 
       Goto[LeavingEvent];
       ,
       (* if reflection, then remains in LSC *)
       
       photonlives[[i]] = 
        Append[
         photonlives[[i]], {"Reflection", intersection, reflection, 
          lambda}];
       (*prevent from hitting intersection conditions again*)
       
       location = intersection + movementerror*reflection;
       direction = reflection;
       ]; ,
     (* FALSE: 
     path length is less than distance to left intersection, 
     so return this new location *) 
     location = location + pathlength*direction;
     Return[{location, direction}];
     ];
    (* new path lenth, repeat until we find an absorbing location, 
    or we have left the LSC *) 
    pathlength = 
     pathlength - EuclideanDistance[intersection, location];
    ];
  ]
(* Life of a Photon *)
(* when given a photon type (normal or singlet fission), it returns \
an array of all the intersections and points and velocities *) 

photonrun[type_, photoninfo_] := Module[{},
   Clear[index];
   (* find the photon characteristics *) 
   If[type == "normal",
    (*Pick wavelength*)
    lambda = solarspectrumLambda[];
    (*Pick a starting location*)
    
    location = {offsetx + randphotonlocation[][[1]]*LSCspawnlengthx, 
      offsety + randphotonlocation[][[2]]*LSCspawnlengthy, height};
    (*Pick direction-add function here later*)
    
    direction = directionstart;
    photonlives[[i]] = {{"Start", location, direction, lambda}};
    ];
   
   (* find the photon characteristics, 
   if a singlet fission photon  *) 
   If[type == "SF",
    (*Pick wavelength*)
    lambda = photoninfo[[2]];
    (*Pick a starting location*)
    location = photoninfo[[1]];
    (*random direction*)
    direction = finddirection[];
    photonlives[[i]] = {{"SF Start", location, direction, lambda}};
    ];
   
   
   (*If a reflection event has happened,
   check that it won't be reflected back into the solar concentrator,
   for more complex shapes*)
   Label[LeavingEvent];
   
   (*Check if the photon impinges on the surface,return normal,
   reflection,refraction*)
   
   rayresults = raytracing[N[location], N[direction]];
   
   If["no_intersection" === rayresults,
    (*no intersection has been found*)(*direction is normalised,
    so it means the movementjump will defiently take it out of the \
LSC range,i.e.if it was smaller than 1,it might just remain there*)
  
      photonlives[[i]] = 
     Append[
      photonlives[[
       i]], {"End", (location + movementjump*Normalize[direction]), 
       direction, lambda}];
    Continue[];
    ];
   
   
   (*intersection was found*)
   
   intersection = {x, y, z} /. rayresults[[1, 2]];
   reflection = rayresults[[2, 2]];
   refraction = rayresults[[3, 2]];
   normal = rayresults[[4, 2]];
   
   (*check if transmission or reflection using Fresnells laws*)
   
   If[type == "normal",
    If[transmissionorreflectibity[N[VectorAngle[-direction, normal]], 
         n1, n2][[1]] == "transmission",
      (*if transmission,do this*)
      
      photonlives[[i]] = 
       Append[
        photonlives[[i]], {"Transmission", intersection, refraction, 
         lambda}];
      location = intersection + movementerror*refraction;
      direction = refraction;,
      (*if reflection,
      do this*)
      (*the reflectionerror is to prevent it being in \
the same location and moving around*)
      photonlives[[i]] = 
       Append[
        photonlives[[i]], {"Reflection", intersection, reflection, 
         lambda}];
      (*prevent from hitting intersection conditions again*)
      
      location = intersection + movementerror*reflection;
      direction = reflection;
      Goto[LeavingEvent];
      ];
    ];
   
   If[type == "SF",
    (* if SF, n2 and n1 are switched *) 
    If[transmissionorreflectibity[N[VectorAngle[-direction, normal]], 
         n2, n1][[1]] == "transmission",(*if transmission,do this*)
      photonlives[[i]] = 
       Append[
        photonlives[[i]], {"Transmission", intersection, refraction, 
         lambda}];
      location = intersection + movementerror*refraction;
      direction = refraction;
      Goto[LeavingEvent];,
      (*if reflection,
      do this*)
      (*the reflectionerror is to prevent it being in \
the same location and moving around*)
      photonlives[[i]] = 
       Append[
        photonlives[[i]], {"Reflection", intersection, reflection, 
         lambda}];
      (*prevent from hitting intersection conditions again*)
      
      location = intersection + movementerror*reflection;
      direction = reflection;
      ];
    ];
   
   
   
   (*-----------------------Absorption------------------------*)
   (* 
   1. Find aborbance location 2. is it Absorbed by substrate or \
luminophores? 3. What type of decay? 4. Pick new emission wavelength. 
   5. Pick new direction. 6. Find new absorbance location. *)
   
   Label[afterabsorption];
   (*Check that extinction spectra is non-zeros *)
   
   extinctionnum = extinctionvalueForlambda[lambda];
   If[extinctionnum == 0, extinctionnum = 0.00000001;];
   
   (* Calculate path length *)
   (* follows beer's law *)
   
   pathlength = -(Log10[RandomReal[]])/(extinctionnum*concentration + 
       substrateabsorptionForLambda[lambda]);
   
   (*if path length/matherial is within the LSC,then carry on,if not,
   path length loop with it boops around (or leaves) *)
   
   absorbevent = aborsorbloction[];
   location = absorbevent[[1]];
   direction = absorbevent[[2]];
   
   photonlives[[i]] = 
    Append[
     photonlives[[i]], {"Absorption", absorbevent[[1]], 
      absorbevent[[2]], lambda}];
   
   (*Absorption of photon by substrate*)
   
   If[RandomReal[] < (substrateabsorptionForLambda[
        lambda]/(substrateabsorptionForLambda[lambda] + 
         extinctionnum*concentration)), 
    photonlives[[i]] = 
     Append[
      photonlives[[i]], {"SubstrateAbs", location, {0, 0, 0}, lambda}];
    (*Continue to next photon*)
    Continue[];
    ];
   
   (*Quantum Yield Calculations,i.e.Non-radiative Decay (NRD),
   or emission wavelength,or other*)
   If[RandomReal[] > QuantumYield,
    (*True\[Rule]NRD Decay*)
    
    photonlives[[i]] = 
     Append[photonlives[[i]], {"NRD", location, {0, 0, 0}, lambda}];
    Continue[];,
    (*False\[Rule]Does some quantum magic*)
    
    direction = finddirection[];
    lambda = emissionwavelength[];
    photonlives[[i]] = 
     Append[
      photonlives[[i]], {"Chromophore", location, direction, 
       lambda}];
    Goto[afterabsorption];
    ];
   ];
(* Run Simulation for Lots of Photons *) 

simulation[n_, kernelnum_] := Module[{},
   NumberOfPhotons = n;
   plqe = {}; 
   (*Photon Tracking*)
   
   photonlives = ConstantArray[0, NumberOfPhotons];
   (*determine the shape's normals*)
   
   normals = regnormal[RegionUnion[##] & @@ shapes, {x, y, z}];
   
   For[i = 1, i <= NumberOfPhotons, i++,
    (*run the photons normally-
    give nothing because we must satisfy both variables when passing*)

        photonrun["normal", "nothing"];
    ];
   
   If[singletfission == True,
    (*count number of singlet fission events photons*)
    
    singletfissionevents = 
     Position[photonlives, "Chromophore"][[;; , {1, 2}]];
    currentnumberofphotons = 
     NumberOfPhotons + Length[singletfissionevents];
    
    (*create blanks*)
    
    photonlives = 
     Join[photonlives, ConstantArray[0, Length[singletfissionevents]]];
    sfnum = 1;
    (*deal with singlet fission photons*)
    (*i must remain global,
    as it is used to intert into the photon lives matrix*)
    
    For[i = NumberOfPhotons + 1, i <= currentnumberofphotons, i++,
     (*the photon which created the SF photon*)
     
     sfphotoninfo = 
      Extract[photonlives, singletfissionevents[[sfnum]]];
     location = sfphotoninfo[[2]];
     wavelength = sfphotoninfo[[4]];
     sfnum = sfnum + 1;
     photonrun["SF", {location, wavelength}];
     ];
    ];
   
   Return[{photonlives, plqe}];
   ];

(* PLQE and IQE Analysis *) 
(* PLQE is defined as total number of photons \[Rule] edge emitted \
photons *) 

plqecount[] := Module[{}, 
  plqe = Append[plqe, {i, index}]; 
  Return[]; 
  ]

(* IQE is defined as total number of **absorbed ** photons \[Rule] \
edge emitted photons *) 
(* For Changing Angle, Change Initial Photon Direction *) 
determinestartdirection[offsetxinput_, angle_] := 
  Module[{degree, radians, heightdifference, offsetforangle, result, 
    offsetnew}, 
   (*tan from from 0 to Pi*)
   degree = angle;
   radians = degree*Pi/180;
   offsetnew = N[offsetxinput - (height - effectivemax)/Tan[radians]]; 
   result = 
    Normalize[{N[Sin[Pi/2 - radians]], 0, -N[Cos[Pi/2 - radians]]}];
   
   Return[{result, offsetnew}];
   ];
(* IQE and PLQE *) 

iqeplqe[] := 
  Module[{plqeresult, numberofabsorbedphotons, iqeresult, 
    photonlivestemp}, 
   plqeresult = N[Length[plqe]/NumberOfPhotons];
   photonlivestemp = Select[photonlives, #[[1, 1]] === "Start" &];
   numberofabsorbedphotons = 
    Length[
     Select[photonlivestemp[[;; , 3]], #[[1]] == "Absorption" &]];
   iqeresult = N[Length[plqe]/numberofabsorbedphotons];
   
   Return[{{"plqe", plqeresult}, {"iqe", 
      iqeresult}, {"absorbed photons", 
      numberofabsorbedphotons}, {"number photons", 
      NumberOfPhotons}}];
   ];

(* Side Emission Analysis  *) 
sidestudy[] := Module[{}, 
   
   side2 = Select[plqe, #[[2, 1]] == 2 &];
   side3 = Select[plqe, #[[2, 1]] == 3 &];
   side4 = Select[plqe, #[[2, 1]] == 4 &];
   side5 = Select[plqe, #[[2, 1]] == 5 &];
   
   spectrumside2 = photonlives[[#, -1, -1]] & /@ side2[[;; , 1]];
   spectrumside3 = photonlives[[#, -1, -1]] & /@ side3[[;; , 1]];
   spectrumside4 = photonlives[[#, -1, -1]] & /@ side4[[;; , 1]];
   spectrumside5 = photonlives[[#, -1, -1]] & /@ side5[[;; , 1]];
   
   Return[{spectrumside2, spectrumside3, spectrumside4, 
     spectrumside5}];
   ];
(* Vary Simulation Conditions  for Multiple Kernels *) 

For[k = startangle, k < endangle, k = k + 1;,
  
  selectedwavelength = startwavelength;
  
  offsetx = offsetxstart;
  angleresults = determinestartdirection[offsetx, k];
  offsetx = angleresults[[2]];
  directionstart = angleresults[[1]];
  
  (*clean up*)
  Clear[parrallel];
  (*number of photons processed on each kernel*)
  
  divisionphotons = Round[NumberOfPhotons/numkernel];
  (*photons on the remainder kernel*)
  
  divisionmodphotons = 
   Round[NumberOfPhotons/numkernel] + 
    Mod[NumberOfPhotons, numkernel];
  (*put the first evaluation in,with the remainder*)
  
  parrallel = {Hold[
     ParallelSubmit[{simulation[divisionmodphotons, 1]}]]};
  
  (*for number of kernels,set up the parrallel stuff*)
  
  For[i = 2, i <= numkernel, i++,
   parrallel = 
    Append[parrallel, 
     Hold[ParallelSubmit[{simulation[divisionphotons, i]}]]];
   (*to this,so we can add i and do the monitoring better,
   have to be careful when expressions are evaluated,
   want to keep that for the parralel bit*)
   parrallel[[i]] = 
    StringReplace[ToString[parrallel[[i]]], 
     ", i]" -> ", " <> ToString[i] <> "]"];
   parrallel[[i]] = ToExpression[parrallel[[i]]];
   ];
  
  LaunchKernels[];
  (*distribute the required definitions around the kernels*)
  
  DistributeDefinitions[simulation, divisionphotons, 
   divisionmodphotons, height, effectivemax, constraints, constraint, 
   normals, plqecount, determinestartdirection, directionstart];
  (*execute the parralel process*)
  
  results = WaitAll[ReleaseHold[parrallel]];
  CloseKernels[];
  (*deal with the multiple core data*)
  
  photonlives = {results[[1]][[1]][[1]]};
  plqe = {results[[1]][[1]][[2]]};
  resultslengths = ConstantArray[0, numkernel];
  resultslengths[[1]] = Length[results[[1]][[1]][[1]]];
  
  For[i = 2, i <= numkernel, i++,
   photonlives = Append[photonlives, results[[i]][[1]][[1]]];
   resultslengthtotal = Total[resultslengths];
   resultslengths[[i]] = Length[results[[i]][[1]][[1]]];
   plqeresults = results[[i]][[1]][[2]]; 
   plqeresults[[;; , 1]] = 
    resultslengthtotal + plqeresults[[;; , 1]];
   plqe = Append[plqe, plqeresults];
   ];
  
  
  (*treatment for photonlives*)
  
  photonlives = Flatten[photonlives, 1];
  (*Export["./Results/photonlives_angle_"<>ToString[k]<>
  "_wavelength_"<>ToString[selectedwavelength]<>"_photons_"<>ToString[
  NumberOfPhotons]<>"_PLQE_"<>ToString[QuantumYield]<>"_conc_"<>
  ToString[concentration]<>".json",N[photonlives],"RawJSON"];*)
  
  
  plqe = Flatten[plqe, 1];
  (* calculate iqe & plqe *) 
  results = iqeplqe[];
  Export[
   "./Results_plqe/plqeiqe_angle_" <> ToString[k] <> "_wavelength_" <>
     ToString[selectedwavelength] <> "_photons_" <> 
    ToString[NumberOfPhotons] <> "_PLQE_" <> ToString[QuantumYield] <>
     "_conc_" <> ToString[concentration] <> ".csv", N[results]];
  
  
  CreateDirectory[
   "side_emission/" <> ToString[selectedwavelength] <> "/" <> 
    ToString[k]];
  results = sidestudy[];
  Export[
   "./side_emission/" <> ToString[selectedwavelength] <> "/" <> 
    ToString[k] <> "/side_1_" <> ToString[k] <> "_wavelength_" <> 
    ToString[selectedwavelength] <> "_photons_" <> 
    ToString[NumberOfPhotons] <> "_PLQE_" <> ToString[QuantumYield] <>
     "_conc_" <> ToString[N[concentration]] <> ".csv", 
   N[results[[1]]]];
  
  Export[
   "./side_emission/" <> ToString[selectedwavelength] <> "/" <> 
    ToString[k] <> "/side_2_" <> ToString[k] <> "_wavelength_" <> 
    ToString[selectedwavelength] <> "_photons_" <> 
    ToString[NumberOfPhotons] <> "_PLQE_" <> ToString[QuantumYield] <>
     "_conc_" <> ToString[N[concentration]] <> ".csv", 
   N[results[[2]]]];
  
  Export[
   "./side_emission/" <> ToString[selectedwavelength] <> "/" <> 
    ToString[k] <> "/side_3_" <> ToString[k] <> "_wavelength_" <> 
    ToString[selectedwavelength] <> "_photons_" <> 
    ToString[NumberOfPhotons] <> "_PLQE_" <> ToString[QuantumYield] <>
     "_conc_" <> ToString[N[concentration]] <> ".csv", 
   N[results[[3]]]];
  
  Export[
   "./side_emission/" <> ToString[selectedwavelength] <> "/" <> 
    ToString[k] <> "/side_4_" <> ToString[k] <> "_wavelength_" <> 
    ToString[selectedwavelength] <> "_photons_" <> 
    ToString[NumberOfPhotons] <> "_PLQE_" <> ToString[QuantumYield] <>
     "_conc_" <> ToString[N[concentration]] <> ".csv", 
   N[results[[4]]]];
  ]; 


(* Graphical Analysis - First 100 *) 
colorLine[
  entry_] := {ColorData["VisibleSpectrum", Last[#3]], 
    Line[#2]} & @@@ (Transpose[#] & /@ Partition[entry, 2, 1])

If[graphics === True, 
 
 photonlivesgraphics = photonlives;
 photonlivesgraphics[[;; , ;; , 3]] = "delete_this";
 photonlivesgraphics = 
  DeleteCases[photonlivesgraphics, "delete_this", 3];
 
 toplot = colorLine /@ photonlivesgraphics;
 
 (* plot general image *) 
 overall1 = 
  Graphics3D[{toplot[[1 ;; 100]], {Opacity[0.4], shapes}}, 
   PlotRange -> {{2, 18}, {2, 18}, {-3, 5}}, Axes -> True];
 
 ]
(* Graphical Analysis - First 100 Successful *) 


If[graphics === True, 
 (* plot general image *) 
 overall1 = 
  Graphics3D[{toplot[[#]] & /@ plqe[[1 ;; 100, 1]], {Opacity[0.4], 
     shapes}}, PlotRange -> {{2, 18}, {2, 18}, {-3, 5}}, 
   Axes -> True]
 ]
(* Side Emission Graphics *) 


If[graphics === True, 
 overall1 = 
  Graphics3D[{toplot[[#]] & /@ side2[[1 ;; 100, 1]], {Opacity[0.4], 
     shapes}}, PlotRange -> {{2, 18}, {2, 18}, {-3, 5}}, Axes -> True];
 
 Histogram[{spectrumside2, spectrumside3, spectrumside4, 
   spectrumside5}, 50];
 ]
In[1]:= 
(* Delete all output and quit kernl before running this *) 

nb = InputNotebook[];
fn = FileNameJoin[{"simulation_yb.wls"}];
FrontEndExecute[FrontEndToken[nb, "Save", {fn, "Text"}]]
