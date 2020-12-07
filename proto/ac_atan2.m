% Instituto Tecnológico de Costa Rica
% Centro Académico Alajuela
% Esuela de Ingeniería en Computación
% IC-3101 Arquitectura de Computadores
% II Semestre 2020
% Prof.-Ing. Daniel Kohkemper, M.Sc.
%
% atan2 implementation file
% File:   ac_atan2.m
% Brief:  Implementation of atan2 function
% Input:  x coordinate, y coordinate of complex number
% Output: theta: angle of vector
%
% Group 08
% Eric Alpizar
% Jimmy Salas
% Rodrigo Espinach



function [theta, octant] = ac_atan2(real_part, imag_part)
    
  octant = 0;
  theta  = 0;
  
  #The casting of the intager valriables is done in order to be treated as a 32 bit intagers
  
  real_part = cast(real_part, "int32")              
  
  imag_part = cast(imag_part, "int32")              
  
  
  # The code for defining the octant of a number is implemented here
  
  if (0 < imag_part && imag_part <= real_part)
    octant = 1
  elseif(0 < real_part && real_part < imag_part)
    octant = 2
  elseif(0 < -real_part && -real_part < imag_part)
    octant = 3
  elseif(0 < imag_part && imag_part <= -real_part)
    octant = 4
  elseif(0 < -imag_part && -imag_part <= -real_part)
    octant = 5
  elseif(0 < -real_part && -real_part < -imag_part)
    octant = 6
  elseif(0 < real_part && real_part < -imag_part)  
    octant = 7
  elseif(0 < -imag_part && -imag_part < real_part)
    octant = 8
  endif
  
  # Defining constants
            
  numerator = real_part * imag_part
  
  imag_square = imag_part * imag_part
  
  real_square = real_part * real_part
  
  real_two_right_bitshift = bitshift(real_square, -2)
  
  imag_two_right_bitshift = bitshift(imag_square , -2)
  
  real_five_right_bitshift = bitshift(real_square, -5)
  
  imag_five_right_bitshift = bitshift(imag_square, -5)
  
  half_pi = cast(51472, "int32")          #Half pi in fixed point Q bit representation using Q(m,n)     
  
  pi = cast(102944, "int32")              #pi number in fixed point Q bit representation using Q(m,n)
  
  alternate_denominator = imag_square + real_two_right_bitshift + real_five_right_bitshift    # denominator needed for octants 2, 3, 6 and 7
  
  denominator = real_square + imag_two_right_bitshift + imag_five_right_bitshift              # denominator needed for octants 1, 8, 4 and 5
  
  denominator = bitshift(denominator, -15)                                                    # Both denominators are shifted to the right in order
                                                                                              # to have a appropiate dynamic range
  alternate_denominator = bitshift(alternate_denominator, -15)
 
  if octant == 2 || octant == 3
    
    theta = half_pi - round(numerator / alternate_denominator)          # the result is half_pi minus the corresponding formula to octants 2 and 3
    
  elseif octant == 6 || octant == 7
    
    theta = - half_pi - round(numerator / alternate_denominator)        # the result is minus half_pi minus corresponding formula to octants 6 and 7
    
  else
    
    theta = round(numerator / denominator)                              # the result is the corresponding formula of the rest of the octants
    
    # Code for handling exceptions for specific angles is implemented here
    
    if (imag_part >= 0 && real_part < 0)
      theta = theta + pi
      
    elseif (imag_part < 0 && real_part < 0)
      theta = theta - pi
      
    elseif (imag_part > 0 && real_part == 0)
      theta = half_pi
      
    elseif (imag_part < 0 && real_part == 0)
      theta = - half_pi
      
    elseif (real_part == 0 && imag_part == 0)
      theta = NaN
      
    endif
    
  endif
      
    return;
end