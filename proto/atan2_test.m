% Instituto Tecnológico de Costa Rica
% Centro Académico Alajuela
% Esuela de Ingeniería en Computación
% IC-3101 Arquitectura de Computadores
% II Semestre 2020
% Prof.-Ing. Daniel Kohkemper, M.Sc.
%
% atan2 test file
% File: atan2_test.m
% Brief: Tests implementation of atan2 function
%
% Grupo 08
% Eric Alpizar
% Jimmy Salas
% Rodrigo Espinach
%
clc
clear

% Open file for output data
fid = fopen('output.txt', 'w');
    
    for idx = 1 : 1 : 73
        angle   = (idx-1) * 5 * pi / 180;
        cos_val = round(cos(angle) * 8192);
        sin_val = round(sin(angle) * 8192);
        
        % Call ac_atan2 function
        [theta, octant] = ac_atan2(cos_val, sin_val);
        
%         Write output to prompt
        fprintf("Octant = %d; X = %5d ; Y = %5d; Angle: %3d;  theta = %7d\n", ...
            octant, cos_val, sin_val, (idx-1) * 5, theta);
        
%         fprintf("%d;%d\n", cos_val, sin_val);
        
        % Write output to file
        fprintf(fid, "Octant = %d; X = %5d ; Y = %5d; Angle: %3d;  theta = %7d\n", ...
            octant, cos_val, sin_val, (idx-1) * 5, theta);
    end
    
fclose(fid);
