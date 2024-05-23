% function [ c, m ] =projpi_lr( g, zero, Kmax )
% Entradas:
% zero = zero do PI (valor maior que zero)
% g = FT de MA = controlador PD
% Kmax = maximo K para fazer o LR (não precisa fornecer se não quiser)
%
% Saidas:
% c - controlador PI
% m = FT de MF
% Data: 04/5/2024
%
function [ c, m ] =projpi_lr( g, zero, Kmax )
g0=tf([1 zero],[1 0]);
gr=g*g0;
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
id=id(ii);
Kp=k(id);
c=Kp*g0
m=feedback(c*g,1)
hold on;
plot(pole(m),'x');
hold off

if nargout==0
    figure;
    m=feedback(c*g,1);
    step(m);
    S=stepinfo(m);
    ss=sprintf('Resposta ao degrau em MF: UP=%0.0f ts=%0.2fs',S.Overshoot,S.SettlingTime);
    title(ss)
end
end

