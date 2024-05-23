clc;
clear all;
close all;

% Definir a função de transferência G4
num4 = [7];
den4 = [1 3 0 0];
G4 = tf(num4, den4);
G4

% Traçar o lugar das raízes inicial
figure;
rlocus(G4);
title(['Lugar das Raízes de G4(s) = ', poly2str(num4, 's'), ' / ', poly2str(den4, 's')]);

% rltool(G4);

% Definir a função de transferência Ec(s)
% num_ec = [7];
% den_ec = [1 3 0 7*Kd];
% Ec = tf(num_ec, den_ec);
% Ec

% Plota o lugar das raízes de Ec(s)
% figure;
% rlocus(Ec);
% title(['Lugar das Raízes de Ec(s) = ', poly2str(num_ec, 's'), ' / ', poly2str(den_ec, 's'), ' com Kd = ', num2str(Kd)]);

% rltool(Ec);

Kd = 0.45;

% Definição da primeira função de transferência G_Kp(s)
G_Kp = tf([7], [1, 3, 0, 7*Kd]);
G_Kp


% Plota o lugar das raízes de G_Kp(s)
figure;
rlocus(G_Kp);
title(['Lugar das Raízes de G_{Kp}(s) = ', poly2str([7], 's'), ' / ', poly2str([1, 3, 7*Kd], 's'), ' com Kd = ', num2str(Kd)]);
xlabel('Parte Real');
ylabel('Parte Imaginária');

% rltool(G_Kp);

Kp = 0.0015;

% Definição da segunda função de transferência G_Kd(s)
G_Kd = tf([7 0], [1, 3, 0, 7*Kp]);
G_Kd

% Plota o lugar das raízes de G_Kd(s)
figure;
rlocus(G_Kd);
title(['Lugar das Raízes de G_{Kd}(s) = ', poly2str([7 0], 's'), ' / ', poly2str([1, 3, 7*Kp], 's'), ' com Kp = ', num2str(Kp)]);
xlabel('Parte Real');
ylabel('Parte Imaginária');

%rltool(G_Kd);


% Definir o controlador C(s)
C = Kp * tf([Kd/Kp 1], [1]);
C

% Calcular o sistema de malha fechada
M_cl = feedback(G4 * C, 1);
M_cl

% Calcular a resposta ao degrau do sistema de malha fechada
[y, t] = step(M_cl);

% Calcular overshoot
OS = (max(y) - 1) * 100; % Onde 1 é o valor final desejado para o degrau unitário

% Calcular tempo de estabelecimento
% Vamos definir o tempo de estabelecimento como o tempo necessário para atingir 5% da resposta final
settling_time_idx = find(y >= 0.95, 1, 'last');
settling_time = t(settling_time_idx);

% Calcular o erro em regime
% Para um degrau unitário, o erro em regime é 1 - y(end)
steady_state_error = 1 - y(end);

fprintf('Overshoot: %.2f%%\n', OS);
fprintf('Tempo de estabelecimento: %.2f segundos\n', settling_time);
fprintf('Erro em regime: %.4f\n', steady_state_error);

% Traçar a resposta ao degrau do sistema de malha fechada
figure;
step(M_cl, 'b'); % Mudança da cor da curva para azul ('b')
hold on;

% Linha horizontal pontilhada em y = 0.95
yline(0.95, '--', 'Color', 'k');
text(0, 0.95, '0.95', 'HorizontalAlignment', 'right');

% Linha horizontal pontilhada em y = 1.05
yline(1.05, '--', 'Color', 'k');
text(0, 1.05, '1.05', 'HorizontalAlignment', 'right');

% Linha horizontal pontilhada em y = 1.15
% yline(1.067, '--', 'Color', 'k');
% text(0, 1.067, '1.067', 'HorizontalAlignment', 'right');

% Linha vertical azul em x = 1.25
% xline(1.75, '--b');
% line([1.75, 1.75], [0, 1.06], 'Color', 'b');
% text(1.75, -0.05, '1.75', 'HorizontalAlignment', 'center');

% Linha vertical azul em x = 4.25
% xline(3.5, '--b');
% line([3.5, 3.5], [0, 1], 'Color', 'b');
% text(3.5, -0.05, '3.5', 'HorizontalAlignment', 'center');

title('Resposta ao Degrau Unitário da Planta G4(s) com o PD C(s) = 0.25s + 0.0015');
ylabel('Amplitude');
xlabel('Tempo');
