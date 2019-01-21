function str=ComputeOutputParameters(work, nwedges, nori)
 strindex = 1;
 abindex = 1;
 maxEMD = 0.0;
 minEMD = 1.0;
 wedgesize = 90.0 / nwedges;
 maxangle = nori * wedgesize; % Always 180 or 360
 strength=0;
 maxEMDori=0;
  %Compute Minimum and Maximum EMD values
  for i=1: nori
    if (work(i) > maxEMD)
      maxEMD = work(i);
      strindex = i;
      maxEMDori = strindex * wedgesize;
    end
    if (work(i) < minEMD)
      minEMD = work(i);
      abindex = i;
    end
  end  

 %The strength and orientation of an edge (or a corner) lie not at the
 %maximum EMD value but rather at the vertex of the parabola that runs
 %through the maximum and the two points on either side.  The first
 %computation of orientation assumes the maximum is the y-intercept.  
 %After computing the strength, we adjust the orientation.
 a = work(strindex);
 if (strindex==1)
     b=work(nori);
 else
     b = work(mod(strindex+nori-1, nori));
 end
 if (strindex==nori-1)
     c=work(nori);
 else
     c = work(mod(strindex+nori+1, nori));
 end
  if (b + c ~= 2 * a) 
      orientation = (wedgesize / 2) * ((b - c) / (b + c - 2 * a));
      strength = a + ((c - b) / (2 * wedgesize)) * orientation +...
      ((b + c - 2 * a) / (2 * wedgesize * wedgesize)) * orientation^2;
      orientation = mod(maxEMDori + orientation + 360, maxangle);
  else %Uncertainty abounds
      strength = a;
      orientation = maxEMDori;  
  end

  % Assuming no compass plots, there is only one value for str and ab
  % User did not ask for compass plots 
  str= strength;  