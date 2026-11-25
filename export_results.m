function export_results(R)
% geometry coordinates (mm), results (.mat) and text report
fid = fopen('Combustor_Geometry.csv', 'w');
fprintf(fid, 'burner,part,x_mm,r_mm\n');
if isfield(R, 'main')
    write_polys(fid, 'main', R.main.geo);
end
if isfield(R, 'ab')
    write_polys(fid, 'afterburner', R.ab.geo);
end
fclose(fid);
fid = fopen('Combustor_Report.txt', 'w');
fprintf(fid, 'COMBUSTOR DESIGN REPORT (Aircraft Engine Design)\n\n');
if isfield(R, 'main')
    fprintf(fid, '--- MAIN BURNER ---\n');
    for i = 1:numel(R.main.rep)
        fprintf(fid, '%s\n', R.main.rep{i});
    end
    fprintf(fid, '\n');
end
if isfield(R, 'ab')
    fprintf(fid, '--- AFTERBURNER ---\n');
    for i = 1:numel(R.ab.rep)
        fprintf(fid, '%s\n', R.ab.rep{i});
    end
    fprintf(fid, '\n--- ALL AFTERBURNER PROPERTIES ---\n');
    Lp = prop_lines(R, true);
    fprintf(fid, '%s\n', Lp{:});
end
if isfield(R, 'main')
    fprintf(fid, '\n--- ALL MAIN BURNER PROPERTIES ---\n');
    Lp = prop_lines(R, false);
    fprintf(fid, '%s\n', Lp{:});
end
fclose(fid);
save('Combustor_Results.mat', 'R');
fprintf('\n--- REPORT ---\n');
if isfield(R, 'main')
    for i = 1:numel(R.main.rep)
        fprintf('%s\n', R.main.rep{i});
    end
end
if isfield(R, 'ab')
    for i = 1:numel(R.ab.rep)
        fprintf('%s\n', R.ab.rep{i});
    end
end
fprintf('\nNotes: Table 9.3 gives forward rates only (reverse neglected). Gas temperature is\n');
fprintf('closed with the linear relation Eq. (9.23). Eq. (9.56) is used as printed; the book''s\n');
fprintf('worked growth value is about half of it. Mixer length and AR >= 4 diffusers are\n');
fprintf('approximations, as stated in the book.\n');
end

