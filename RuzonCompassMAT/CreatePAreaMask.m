function PAmask=CreatePAreaMask(r,nWedges)
R=ceil(r);
nwedges=nWedges;
mask = zeros(R,R,nwedges);  
PI=3.14159265358979323846;
%CA=0, BA=0, AA=0, LA=0, BXC=0, BXL=0, BXH=0, TXC=0, TXL=0, TXH=0, LYC=0, LYL=0, LYH=0;
%RYC=0, RYL=0, RYH=0, AAC=0, BAC=0, AAN=0, BAN=0, XLC=0, YLC=0, XHC=0, YHC=0;
% Iterate over the lower left hand corner of each pixel
  for X=1:R
    for Y=1:R 
        x=Y-1;
        y=R-1-(X-1);
        % Start by computing the pixel's area in the circle
        if (x * x + y * y >= r * r) %Pixel entirely outside circle
            continue;
        end
        if ((x+1) * (x+1) + (y+1) * (y+1) <= r * r)  % Pixel entirely inside
            CA = 1.0;
            InCircle = 1;
            URC = 1; 
        else  % Tricky part; circle intersects pixel
            URC = 0;
            ULC = x * x + (y+1) * (y+1) <= r * r;
            LRC = (x+1) * (x+1) + y * y <= r * r;
            BXC = sqrt(r * r - y * y);
            TXC = sqrt(r * r - (y+1) * (y+1));
            if (~ULC && ~LRC)
                CA = CArea(BXC, x, y, r);
                else if (ULC && ~LRC)
                        CA = CArea(BXC, TXC, y, r) + TXC - x;
                    else if (~ULC && LRC)
                            CA = CArea(x + 1, x, y, r);
                        else % if (ULC && LRC) 
                            CA = CArea(x + 1, TXC, y, r) + TXC - x;
                            InCircle = 0; % Therefore, it must be on the border
                        end
                    end
                end                
        end
      %Check through each wedge 
      for i=0:nwedges-1 
          %Compute area above lower radial line of wedge 
          lowangle = i * PI / (2 * nwedges);
          mlow = tan(lowangle);
          TXL = (y+1)/mlow;
          BXL = y/mlow;
          if (TXL <= x)
              AA = 0.0;
          else if (i == 0 || BXL >= x+1)
                  AA = 1.0;
              else
                  LLL = BXL > x;
                  URL = TXL > x+1;
                  LYL = mlow * x;
                  RYL = mlow * (x + 1);
                  if (LLL && URL)
                      AA = 1 - 0.5 * (RYL-y) * (x+1-BXL);
                      else if (~LLL && URL)
                              AA = 0.5 * (2*(y+1)-LYL-RYL);
                          else if (LLL && ~URL)
                                  AA = 0.5 * (TXL+BXL-2*x);
                              else
                                  AA = 0.5 * (y+1-LYL) * (TXL-x);
                              end
                          end
                      end
              end
          end          
    LowLine = AA < 1.0 && AA > 0.0;      
	% Compute area below upper radial line of wedge
	% The cases are reversed from the lower line cases
    highangle = (i+1) * PI / (2 * nwedges);
	mhigh = tan(highangle);
	TXH = (y+1)/mhigh;
	BXH = y/mhigh;
	RYH = mhigh*(x+1);
	LYH = mhigh*x;
	if (i == nwedges-1 || TXH <= x)
	  BA = 1.0;
    else if (BXH >= x+1)
            BA = 0.0;	
        else
            LLH = BXH < x;
            URH = TXH < x+1;
            if (LLH && URH)
                BA = 1 - 0.5 * (y+1-LYH) * (TXH-x);
            else if (~LLH && URH)
                    BA = 1 - 0.5 * (BXH+TXH-2*x);
                else if (LLH && ~URH)
                        BA = 0.5 * (LYH+RYH-2*y);
                    else % if (~LLH && ~URH)
                        BA = 0.5 * (RYH-y) * (x+1-BXH);
                    end
                end
            end
        end
    end
    HighLine = BA < 1.0 && BA > 0.0;
	LA = BA + AA - 1.0;
	if (LA == 0.0) % Pixel not in wedge 
	  continue;
    end
	NoLine = LA == 1.0;

	% Finish the cases we know about so far 
	if (InCircle) 
	  mask(X,Y,i+1) = LA;
	  continue;       
     else if (NoLine) 
            mask(X,Y,i+1) = CA;
            continue;
         end
    end
	
	% We can now assert (~InCircle && (HighLine || LowLine)) 
	% But this does not ensure the circular arc intersects the line 
	LYC = sqrt(r * r - x * x);
	RYC = sqrt(r * r - (x+1) * (x+1));
	LowIntersect = LowLine &&...
	  ((~ULC &&~LRC && ((LLL && BXL < BXC) || (~LLL && LYL < LYC))) ||...
	   (~ULC && LRC) || (ULC && ~LRC) ||...
	   (ULC && LRC && ((~URL && TXL >= TXC) || (URL && RYL >= RYC))));

	HighIntersect = HighLine &&...
	  ((~ULC && ~LRC && ((~LLH && BXH < BXC) || (LLH && LYH < LYC))) ||...
	   (~ULC && LRC) || (ULC && ~LRC) ||...
	   (ULC && LRC && ((URH && TXH >= TXC) || (~URH && RYH >= RYC))));

	% Recompute BA and AA (now BAC and AAC) given the intersection 
	if (LowIntersect) 
	  XLC = cos(lowangle) * r;
	  YLC = sin(lowangle) * r;
	  if (~LRC && LLL)
          AAC = CA - 0.5 * (XLC - BXL) * (YLC - y) - CArea(BXC, XLC, y, r);
	  else if (~LRC && ~LLL)
              AAC = CA - 0.5 * (XLC - x) * (YLC + LYL - 2 * y) -CArea(BXC, XLC, y, r);
          else if (LRC && LLL)
                  AAC = CArea(XLC, x, y, r) - 0.5 * (YLC - y) * (XLC - BXL);
              else % if (LRC && ~LLL) 
                  AAC = CA - CArea(x+1, XLC, y, r) -  0.5 * (YLC + LYL - 2 * y) * (XLC - x);
              end
          end
      end
    end
	  
	if (HighIntersect) 
        XHC = cos(highangle) * r;
        YHC = sin(highangle) * r;
        if (~LRC && ~LLH)
            BAC = 0.5 * (XHC - BXH) * (YHC - y) + CArea(BXC, XHC, y, r);
        else if (~LRC && LLH)
                BAC = 0.5 * (XHC - x) * (YHC + LYH - 2 * y) + CArea(BXC, XHC, y, r);
            else if (LRC && LLH)
                    BAC = CArea(x+1, XHC, y, r) + 0.5 * (YHC + LYH - 2 * y) * (XHC - x);
                else %if (LRC && ~LLH) */
                    BAC = CArea(x+1, XHC, y, r) + 0.5 * (YHC - y) * (XHC - BXH);
                end
            end
        end
    end
                    
	% Compute area for a few more cases */
	if (LowIntersect && ~HighLine) 
        mask(X,Y,i+1) = AAC;
        continue;
    else if (HighIntersect && ~LowLine) 
            mask(X,Y,i+1)= BAC;
            continue;
        else if (HighIntersect && LowIntersect) 
                mask(X,Y,i+1) = AAC + BAC - CA;
                continue;
            end
        end
    end
		
	% Here we can assert (~InCircle && (HighLine || LowLine) &&
% 	  ~LowIntersect && !HighIntersect).  There are still many 
% 	  possible answers.  Start by computing BAN and AAN (N for No
% 	  Intersection)
if (LowLine && ~LowIntersect) 
    if (~ULC && ~LLL)
        AAN = 0;
    else if (~LRC && LLL)
            AAN = CA;
        else if (LRC && URL && LLL)
                AAN = CA - 0.5 * (RYL - y) * (x+1 - BXL);
            else if (ULC && URL && ~LLL)
                    AAN = CA - 0.5 * (RYL + LYL - 2 * y);
                else % if (ULC && ~URL) 
                    AAN = AA;
                end
            end
        end
    end
end

if (HighLine && ~HighIntersect) 
    if (~ULC && LLH)
        BAN = CA;
    else if (~LRC && ~LLH)
            BAN = 0;
        else if (LRC && ~URH && ~LLH)
                BAN = BA;
            else if (ULC && ~URH && LLH)
                    BAN = 0.5 * (RYL + LYL - 2 * y);
                else if (ULC && URH)
                        BAN = CA + BA - 1;
                    end
                end
            end
        end
    end
end

if (LowLine && ~LowIntersect && HighLine && ~HighIntersect) 
    mask(X,Y,i+1) = AAN + BAN - CA;
    continue;
else if (LowIntersect && HighLine && ~HighIntersect) 
        mask(X,Y,i+1) = AAC + BAN - CA;
        continue;
    else if (LowLine && ~LowIntersect && HighIntersect) 
            mask(X,Y,i+1) = AAN + BAC - CA;
            continue;
        else if (LowLine && ~LowIntersect) 
                mask(X,Y,i+1) = AAN;
                continue;
                 else if (HighLine && ~HighIntersect) 
                         mask(X,Y,i+1) = BAN;
                         continue;
                     else                         
                         mask(X,Y,i+1)= 0.0;
                     end
            end
        end
    end
end
      end%next wedge:area of pixel at (x,y) 
    end %next pixel
  end
PAmask=mask;
  	
   

