clc
clear
close all

x=[0.4 1 0.5 0.2];

settingProblem;

nState=size(S,1);
nAction=numel(A);
eta_k=0.2;
teta=0.7;
beta=0.9;

bb=[];
ut_seq=[];
seq=x;

Q=zeros(nState, nAction);

if nCase==1 || nCase==2
    et=x(2);
elseif nCase==3
    et=beta*x(2)+(1-beta)*(1-x(1));
end

sk=determineState(et,S);
[id_ak,ak]=chooseAction(Q,sk,A);
if(nCase==1)
    case1;
elseif(nCase==2)
    case2;
elseif(nCase==3)
    case3;
end

plot(ut_seq)
legend('u(t)')
figure
subplot(221)
plot(seq(:,1))
legend('x1')

subplot(222)
plot(seq(:,2))
legend('x2')

subplot(223)
plot(seq(:,3))
legend('x3')

subplot(224)
plot(seq(:,4))
legend('x4')


