%function [ c, wg ] =projpi( g,M )
% m = modulo que se quer reduzir ou aumentar em dB 
% g =ft de M
% Data: 6/6/2024
function [ c, wg] =projpi( g, M)

estavel=isstable(feedback(g,1));
if length(M)==1
    kp=10^(M/20);
    [m,f,w]=bode(kp*g);
    for i=1:length(w)
        m1(i)=20*log10(m(:,:,i));
    end;
    ind=find(m1>0);
    i1=ind(end);
    wg=w(i1);
    ki=kp*wg/10;
    c=tf([kp ki],[1 0]);
    if nargout==0
        figure(1);bode(g,c*g);grid;
        figure(2);step(feedback(c*g,1));grid;
    end
else
    leg={'G'};
    figure(1);bode(g);hold on;
    if estavel
        figure(2);step(feedback(g,1));hold on;
    else
        figure(2);hold on;
    end
    for i=1:length(M)
        leg{i+1}=num2str(M(i));
        kp=10^(M(i)/20);
        [m,f,w]=bode(kp*g);
        for i=1:length(w)
            m1(i)=20*log10(m(:,:,i));
        end;
        ind=find(m1>0);
        i1=ind(end);
        wg=w(i1);
        ki=kp*wg/10;
        c=tf([kp ki],[1 0]);
        figure(1);bode(c*g);
        figure(2);step(feedback(c*g,1));hold on;
    end
    figure(1);legend(leg);grid;hold off;
    if estavel
        leg{1}='G/(1+G)';
    else
        leg=[];
        for i=1:length(f)
            leg{i}=num2str(f(i));
        end     
    end
    figure(2);legend(leg);grid;hold off;
end
end