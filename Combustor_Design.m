function Combustor_Design
%COMBUSTOR_DESIGN  Preliminary design of a main burner and/or afterburner.
%
%  Follows Aircraft Engine Design (2nd ed.):
%    Sec. 9.1  basic relations: jets, swirlers, diffusers, shear layers,
%              vee-gutter flameholders, pressure loss, chemical kinetics
%    Sec. 9.2  main-burner procedure: air partitioning, liner and dome,
%              primary swirlers, secondary/dilution holes, transition duct
%    Sec. 9.3  afterburner procedure: mixer, diffuser, flameholders, flame spread
%    Sec. 9.4  AAF engine example: used as the default input set
%  Kinetics: well-stirred-reactor (WSR) species equations, Eq. (9.19), solved
%  with the 30-reaction jet-fuel mechanism of Table 9.3 (Kollrack).
%
%  Usage:  Combustor_Design
%          then choose 1 (main burner), 2 (afterburner) or 3 (both).
%          Press ENTER at any prompt to accept the default (book example, SI).
%
%  Outputs: console report, figures, Combustor_Results.mat,
%           Combustor_Geometry.csv (x,r of every part, mm),
%           Combustor_Report.txt.
%
%  Limitations (also printed at the end of the run):
%   * Table 9.3 gives forward rates only, so reverse reactions are neglected.
%   * Gas temperature is closed with the book's linear relation, Eq. (9.23),
%     T = Ti + eps*phi*dTmax, not a full enthalpy balance.
%   * Eq. (9.56) is used exactly as printed; the book's worked growth value
%     (0.0150) is about half of what the printed equation gives.
%   * Diffusers with AR >= 4 and the mixer length are approximations.

clc; close all;
fprintf('======================================================================\n');
fprintf('  COMBUSTOR DESIGN TOOL  -  Aircraft Engine Design (2nd ed.)\n');
fprintf('======================================================================\n');
fprintf('  Select burner type:\n');
fprintf('     1 = main burner only\n');
fprintf('     2 = afterburner only\n');
fprintf('     3 = both (same design point)\n');
mode = ask('Mode [1/2/3]', 3);
if ~ismember(mode, [1 2 3])
    error('Mode must be 1, 2 or 3.');
end
R = struct('mode', mode);
if mode ~= 2
    R.main = design_main_burner();
end
if mode ~= 1
    R.ab = design_afterburner(R);
end
prop_store(R);
plot_results(R);
export_results(R);
fprintf('\nFinished. Figures drawn. Files: Combustor_Results.mat, ');
fprintf('Combustor_Geometry.csv, Combustor_Report.txt\n');
end

%% ======================================================================
%%  UTILITIES
%% ======================================================================
