% function [ c, mf ] =projpd( g, f )
% f = frequencia (rad/s) onde se quer adicionar o zero do PD
% Caso f não seja fornecido, pode-se clicar sobre w no gráfico de Bode
% g = FT de MA
% Data: 6/6/2024
function [ c, mf ] =projpd( g, f )
leg={'G'};
estavel=isstable(feedback(g,1));
if nargin==1
    figure(1);bode(g);grid;
    f=ginput(1);
    f=f(1);
end
if length(f)==1
    c=tf([1/f 1],1);
    [~,mf]=margin(c*g);
    if nargout==0
        figure(1);bode(g,c*g);grid;
        figure(2);step(feedback(c*g,1));grid;
    end
else
    figure(1);bode(g);hold on;
    if estavel
        figure(2);step(feedback(g,1));hold on;
    else
        figure(2);hold on;
    end
    for i=1:length(f)
        c=tf([1/f(i) 1],1);
        figure(1);bode(c*g);
        figure(2);step(feedback(c*g,1));
        leg{i+1}=num2str(f(i));
        [~,mf(i,1)]=margin(c*g);
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

