% function [ c, m ] =projpd_lr( g, Kp, Kmax )
% Entradas:
% Kp = ganho Kp (escolhido para atender erro em regime ou tempo de
% estabelecimento)
% g = FT de MA = controlador PD
% Kmax = maximo K para fazer o LR (não precisa fornecer se não quiser)
%
% Saidas:
% c - controlador PD
% m = FT de MF
% Data: 04/5/2024
%
function [ c, m ] =projpd_lr( g, Kp, Kmax )
m=feedback(Kp*g,1);
den=m.denominator{1};
num=conv([1 0],g.Numerator{1});
gr=tf(num,den)
if nargin==3
    k=linspace(0,Kmax,5000);
    r=rlocus(gr,k);
else
[r,k]=rlocus(gr);
end;
rm=min(min(real(r')));
rlocus(gr,k);title('Escolha o ponto do LR');
line([0 rm],[0 rm],'Color','m');
line([0 rm],[0 -rm],'Color','m');
[x,y]=ginput(1);
s=x+sqrt(-1)*y;
d=abs(s-r);d=d';
[v,id]=min(d);
[~,ii]=min(v);
id=id(ii)
if isinf(k(id))
    id=id-1;
end
Kd=k(id);
c=tf([Kd Kp],1)
m=feedback(c*g,1);
hold on;
plot(pole(m),'x');
hold off

if nargout==0
    figure;
    m=feedback(c*g,1);
    step(m);
    S=stepinfo(m);
    ss=sprintf('Resposta ao degrau em MF: UP=%0.0f ts=%0.2fs',S.Overshoot,S.SettlingTime);
    title(ss);
end
end

