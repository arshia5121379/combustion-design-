function C = consts()
% unit conversions (book uses US units; the code works in SI) and gas data
C.lbm = 0.45359237;  C.in = 0.0254;   C.ft = 0.3048;  C.ft2 = 0.09290304;
C.psi = 6894.757;    C.degR = 5/9;    C.btu = 2326.0; C.lbf = 4.4482216;
C.Ru = 8314.46;      C.Ra = 287.0;    C.Mair = 28.97; C.Mprod = 28.8;
C.Rp = C.Ru/C.Mprod;                  % products gas constant, J/kg/K
C.MF = 167.0;                         % C12H23 molecular weight (Table 9.2), kg/kmol
C.x = 12;  C.y = 23;                  % jet-fuel surrogate C12H23
C.fst = (36*C.x + 3*C.y)/(103*(4*C.x + C.y));   % Eq. (9.2), = 0.0685
C.hPR = 18400*C.btu;                  % fuel heating value, J/kg (Table 9.2)
C.deg = pi/180;
end

