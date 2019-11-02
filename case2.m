for i=1:150
    if i==91
       u_max=10;
       A=[0, 0.01, 0.02, 0.03, 0.04, 0.06, 0.08, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1];
       nAction=numel(A);
    end
    if sk==7 && i<91
        seq=[seq;x];
        ut_seq=[ut_seq;ut];
    elseif sk==1 && i>=91
       ut=0;
       fun=@(t,x)nonlinearFunction(t,x,ut);
       [t,xn]=ode45(fun,0:1:2,x);
       x=xn(2,:);
       seq=[seq;x];
       ut_seq=[ut_seq;ut];
    else
        ut=ak*u_max;

        fun=@(t,x)nonlinearFunction(t,x,ut);
        [t,xn]=ode45(fun,0:1:2,x);

        x=xn(2,:);
        
        et_1=x(2);
        
        sk_1=determineState(et_1,S);
        if et_1<et
            rk_1=(et-et_1)/et;
        else
            rk_1=0;
        end
        if(sk_1==7)
            bb=[bb,i];
        end
        [id_ak_1,ak_1]=chooseAction(Q,sk_1,A);
        Q(sk,id_ak)=Q(sk,id_ak)+eta_k*(rk_1+teta*Q(sk_1,id_ak_1)-Q(sk,id_ak));

        et=et_1;
        sk=sk_1;
        id_ak=id_ak_1;
        ak=ak_1;
        seq=[seq;x];
        ut_seq=[ut_seq;ut];
    end

end
