function work= GrayEMD(dirt, hole)
global MAXCLUSTERS
work = 0.0;
leftoverdirt = 0.0;
leftoverhole = 0.0;
i = 0;
j = 0;
%We exit from inner loops, so this one must run forever
while (1)
%Compute the amount of mass in the lowest numbered bin that hasn't 
%been moved yet from the piles of dirt
if (leftoverdirt == 0)
    i=i+1;    
    while((dirt(i).weight== 0) & (i < MAXCLUSTERS))
        i=i+1; 
%         if(i==MAXCLUSTERS)
%             break;
%         end
    end
    if (i == MAXCLUSTERS)
        break;
    else
        dirtamt = dirt(i+1).weight;
    end
else
    dirtamt = leftoverdirt;
end
%Do the same for the holes
if (leftoverhole == 0)
    j=j+1;    
    while(((hole(j).weight) == 0) & (j < MAXCLUSTERS))
        j=j+1;
%         if(j==MAXCLUSTERS)
%             break;
%         end
    end
    if (j == MAXCLUSTERS)
        break;
    else
        holeamt = hole(j).weight;
    end
else
    holeamt = leftoverhole;
end
%Compute the work done moving the smaller amount of mass and decide
%how much is left over in each bin. */
massmoved = min(dirtamt, holeamt);
%work += massmoved * cost[(int)ROUND(2 * abs(hole[j].value - 
%dirt[i].value))];
GAMMA=14;
work = work +massmoved * (1 - exp(-abs(hole(j).value - dirt(i).value)/GAMMA));
leftoverdirt = dirtamt - massmoved;
leftoverhole = holeamt - massmoved;
end
