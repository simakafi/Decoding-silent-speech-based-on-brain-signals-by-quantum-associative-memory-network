function [id_ak, ak]=chooseAction(Q,sk,A)

v_max=max(Q(sk,:));
idx=find(Q(sk,:)==v_max);
if numel(idx)==1
    id_ak=idx;
else
    id_ak=randsample(idx,1);
end
ak=A(id_ak);