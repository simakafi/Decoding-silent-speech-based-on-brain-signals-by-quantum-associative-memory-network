u_max=10;
for i=1:150
    if(sk==1)
        ut=0;
        fun=@(t,x)nonlinearFunction(t,x,ut);
        [t,xn]=ode45(fun,0:1:2,x);
        x=xn(2,:);
       
    else
        ut=ak*u_max;

        fun=@(t,x)nonlinearFunction(t,x,ut);
        [t,xn]=ode45(fun,0:1:2,x);

        x=xn(2,:);
        et_1=beta*x(2)+(501-beta)*(1-x(1));
      %  if(et_1<0.0009)
       %     et=0;
        %end
        sk_1=determineState(et_1,S);
        if et_1<et
            rk_1=(et-et_1)/et;
        else
            rk_1=0;
        end
        [id_ak_1,ak_1]=chooseAction(Q,sk_1,A);
        Q(sk,id_ak)=Q(sk,id_ak)+eta_k*(rk_1+teta*Q(sk_1,id_ak_1)-Q(sk,id_ak));
        et=et_1;
        sk=sk_1;
        id_ak=id_ak_1;
        ak=ak_1;
        bb=[bb,sk];
    end
    seq=[seq;x];
    ut_seq=[ut_seq; ut];
end