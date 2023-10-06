
(* Set Up Computer Options *) 
numkernel = 16;
Unprotect[$ProcessorCount];
$ProcessorCount = numkernel;
SetDirectory[NotebookDirectory[]];

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


(* ----- Command Line Running ----- *) 
cmddata = $ScriptCommandLine;
startwavelength = ToExpression[cmddata[[2]]];
startangle = ToExpression[cmddata[[3]]];
endangle = ToExpression[cmddata[[4]]];
NumberOfPhotons = ToExpression[cmddata[[5]]];
QuantumYield = ToExpression[cmddata[[6]]];
concentration = N[ToExpression[cmddata[[7]]]]; 

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
emissiondata = 
  Table[{N[CDF[NormalDistribution[1000, 30], x]], x}, {x, 700, 1200, 
    1}];
emissionint = Interpolation[emissiondata, InterpolationOrder -> 0];
(* Chromophore Absorption / Extinction Spectrum *) 
(* in M^-1 cm^-1 *)  
ExtinctionSpectra = Table[{x, 50000}, {x, 300, 500, 1}];
ExtinctionSpectra = Join[ExtinctionSpectra[[2 ;;]], {{501, 0}}];
ExtinctionSpectra = Join[ExtinctionSpectra[[2 ;;]], {{5000, 0}}];
ExtinctionSpectra = Join[ExtinctionSpectra[[2 ;;]], {{200, 50000}}];
ExtinctionSpectra = Join[ExtinctionSpectra[[2 ;;]], {{100, 50000}}];
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
   z = 0.1*Cos[zenithanglevalue];
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
fn = FileNameJoin[{"simulation_imagined_PMLSC.wls"}];
FrontEndExecute[FrontEndToken[nb, "Save", {fn, "Text"}]]