# Combustor_Design — split into one file per function

The original `Combustor_Design.m` (2257 lines, 61 local functions in one
file) has been split into 61 separate `.m` files, one per function, all
placed in this single folder.

This is the only split that is guaranteed to work unmodified: in MATLAB,
when several functions live in one file, only the first (matching the
filename) is visible to other files — the rest become private
sub-functions. Since almost every function here (e.g. `ask`, `consts`,
`rl`) is called from many other functions, each had to get its own file
so every call still resolves correctly on the path.

## How to run
Put the whole folder on your MATLAB path (or just `cd` into it) and run:
```
Combustor_Design
```
exactly as before — behavior is unchanged, the code is just reorganized.

## File map (grouped by role, same as the original section headers)

- `Combustor_Design.m` — entry point / driver
- Utilities: `ask`, `consts`, `rl`, `annulus`, `cool_fraction`, `jet_holes`,
  `station_flow`, `ab_growth`
- Main burner: `design_main_burner`
- Afterburner: `design_afterburner`
- WSR kinetics (Table 9.3 mechanism): `kin_mechanism`, `parse_side`, `sidx`,
  `kin_fresh_comp`, `kin_burned_comp`, `kin_burnout`, `kin_hot_start`,
  `kin_ab_comp`, `kin_struct`, `kin_rhs`, `kin_steady`, `kin_lit`,
  `kin_blowout`, `kin_sweep`, `kin_design`
- Geometry helper: `mm_struct`
- Figure/report helpers: `newfig`, `savepng`, `prop_store`, `add_props_panel`,
  `restore_panel`, `prop_lines`, `flat_props`, `subax`, `arrow2d`, `dim_h`,
  `dim_v`, `zone_bracket`, `hole_circles`
- Plotting (figures): `plot_results`, `plot_main`, `plot_ab`,
  `draw_main_views`, `draw_ab_geometry`, `fig_air_partition`,
  `fig_swirlers`, `fig_jets`, `fig_main_side`, `fig_hole_layout`,
  `fig_ab_diffuser`, `fig_ab_endviews`, `fig_ab_rings`, `fig_ab_full`
- Export: `export_results`, `write_polys`
- Diffuser grid search: `diffuser_grid_search`, `fig_ab_diffuser_grid`
- Alternate no-mix afterburner: `nomix_ab`, `nm_phi`, `fig_ab_nomix`

Content is byte-for-byte identical to the original file (verified by
reconstructing and diffing); only a trailing newline was added to the
last file, which has no effect in MATLAB.
