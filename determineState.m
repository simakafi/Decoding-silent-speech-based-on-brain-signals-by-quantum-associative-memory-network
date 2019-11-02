function sk=determineState(et,S)
if et==0
    sk=1;
else
    idx=S(:,2)<et & et<=S(:,3);
    sk=find(idx==1);
end