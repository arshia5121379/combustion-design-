# Gas-Turbine Combustor and Afterburner Preliminary Design Tool

A MATLAB-based preliminary design framework for annular gas-turbine main
combustors and afterburners. The program follows the design procedures
and empirical/semi-empirical relations presented in *Aircraft Engine
Design*, 2nd edition, Chapters 9.1--9.4.

The tool combines flow-path sizing, combustor air distribution, diffuser
design, swirler and jet-hole sizing, flameholder design, simplified
chemical kinetics, blowout estimation, and 2-D geometry generation. It
can design the main burner, the afterburner, or both at a common engine
design point.

> **Scope:** This is a preliminary engineering design and educational
> analysis tool. It is not a validated detailed combustor design system,
> reacting-flow CFD solver, or substitute for experimental validation.

## GitHub short description

Preliminary MATLAB design of annular gas-turbine main combustors and
afterburners, including air partitioning, swirlers, dilution jets,
diffuser and flameholder sizing, WSR kinetics, blowout estimation, and
2-D geometry export.

## 1. Features

### Main burner

-   Annular flow-path and casing geometry from specified areas and mean
    radii.
-   Alternative casing layouts and a custom outer-radius option.
-   Diffuser area ratio, efficiency, pressure-loss allocation, splitter
    count, and length estimation.
-   Global fuel-air equivalence ratio and primary-, secondary-,
    cooling-, and dilution-air partitioning.
-   Liner height and dome/liner sizing.
-   Primary-zone swirler sizing, swirl number, vane geometry, pitch,
    chord, solidity, and throat estimation.
-   Secondary and dilution jet penetration, hole diameter, and
    hole-count estimation.
-   Primary-zone micromixing and residence-time checks.
-   Optional primary-zone WSR kinetics and blowout residence-time
    calculation.
-   Main-burner meridional geometry and design plots.

### Afterburner

-   Core and bypass stream station calculations.
-   Diffuser design using an analytic method or a grid-search
    optimization over the specified design space.
-   Shear-layer growth and mixer-length estimate.
-   Vee-gutter flameholder sizing, including ring count, channel height,
    gutter width, and flame-spread length.
-   WSR kinetics, local equivalence ratio, and blowout residence-time
    calculation.
-   Wet and dry total-pressure-loss estimates.
-   Station-7 Mach number, static state, velocity, critical area, and
    stream-thrust estimate.
-   Optional alternate no-mix core/fan afterburner calculation.
-   Afterburner geometry and plots.

### Chemical kinetics

-   21 gas/fuel species and 30 forward reactions for the kerosene
    surrogate (C\_{12}H\_{23}).
-   Well-Stirred Reactor species equations integrated with MATLAB's
    stiff ODE solver `ode15s`.
-   Fuel-conversion-based temperature closure.
-   Residence-time sweep and blowout-time search.

## 2. Requirements

-   MATLAB with support for local functions in script/function files.
-   MATLAB functions used by the implementation include `ode15s`,
    `fzero`, plotting/graphics functions, and standard file I/O.
-   No external toolbox is explicitly required by the source code.

The program is run interactively from the MATLAB command window. It
prompts for inputs and accepts the displayed default whenever the user
presses **Enter**.

## 3. How to run

1.  Place `Combustor_Design.m` in the MATLAB working directory.
2.  Set that directory as MATLAB's current folder.
3.  Run:

``` matlab
Combustor_Design
```

4.  Select the design mode:

    Option Design
  -------- -----------------------------
       `1` Main burner only
       `2` Afterburner only
       `3` Main burner and afterburner

5.  Enter the requested design-point and geometry parameters. Press
    **Enter** to use the default value shown in each prompt.
6.  Review the command-window report, generated figures, and exported
    files.

When option `3` is selected, the afterburner reuses the main-burner
station-4 equivalence ratio, mass flow, and energy scale where
applicable. When the afterburner is run independently, those quantities
are requested from the user.

## 4. Input parameters

All interactive engineering inputs are entered in SI units unless the
prompt is dimensionless. The defaults are based on the AAF engine
example in the referenced textbook. The values shown below are the
defaults encoded in the source; they are not universal design
recommendations.

### 4.1 Global input

  -----------------------------------------------------------------------
  Input                   Meaning                 Unit / choices
  ----------------------- ----------------------- -----------------------
  `mode`                  Component selection     `1` main burner, `2`
                                                  afterburner, `3` both

  -----------------------------------------------------------------------

### 4.2 Main-burner inputs

#### A. Engine design-point and station data

  -------------------------------------------------------------------------
  MATLAB input    Description                     Unit              Default
  --------------- --------------- -------------------- --------------------
  `mdot31`        Air mass flow                   kg/s         104.24 lbm/s
                  at station 3.1                            converted to SI

  `mdotf`         Main-burner                     kg/s         2.7017 lbm/s
                  fuel mass flow                            converted to SI

  `Pt31`          Total pressure                    Pa          585.114 psi
                  at station 3.1                            converted to SI

  `Tt31`          Total                              K 1659.99 °R converted
                  temperature at                                       to K
                  station 3.1                          

  `P31`           Static pressure                   Pa          550.205 psi
                  at station 3.1                            converted to SI

  `A31`           Annulus area at                   m²  0.194 ft² converted
                  station 3.1                                         to SI

  `rm31`          Mean radius at                     m  9.0 in converted to
                  station 3.1                                            SI

  `Pt4`           Total pressure                    Pa          555.859 psi
                  at station 4                              converted to SI

  `Tt4`           Total                              K  3138.8 °R converted
                  temperature at                                       to K
                  station 4                            

  `mdot4`         Mass flow at                    kg/s         106.94 lbm/s
                  station 4                                 converted to SI

  `A4`            Annulus area at                   m²  0.144 ft² converted
                  station 4                                           to SI

  `rm4`           Mean radius at                     m  7.0 in converted to
                  station 4                                              SI

  `A32`           Reference                         m²  0.677 ft² converted
                  annulus area at                                     to SI
                  station 3.2                          

  `Pt32`          Total pressure                    Pa          579.263 psi
                  at station 3.2                            converted to SI

  `P32`           Static pressure                   Pa          576.537 psi
                  at station 3.2                            converted to SI

  `Tt32`          Total                              K 1659.99 °R converted
                  temperature at                                       to K
                  station 3.2                          

  `M32`           Mach number at                    --               0.0821
                  station 3.2                          
  -------------------------------------------------------------------------

#### B. Casing layout and diffuser

  ------------------------------------------------------------------------
  Input            Description      Unit / choices                 Default
  ---------------- ---------------- ---------------- ---------------------
  `lay`            Outer casing     `1` = Design A;                    `2`
                   layout           `2` = Design B;  
                                    `3` = custom     
                                    radius           

  `ro3.2`          Custom outer     m                      Station-4 outer
                   casing radius;                                   radius
                   requested for                     
                   layout 3                          

  `etaD`           Main-burner      --                                0.83
                   diffuser                          
                   efficiency                        

  `nsp`            Number of        0, 1, or 2                           1
                   splitter plates                   

  `thD`            Flat-wall        degrees                            4.5
                   diffuser                          
                   half-angle                        
  ------------------------------------------------------------------------

The diffuser area ratio is calculated from the station areas. The code
reports the efficiency required to match the specified
total-pressure-loss allocation.

#### C. Combustion, air partitioning, and liner

  --------------------------------------------------------------------------------
  Input            Description      Unit / choices                         Default
  ---------------- ---------------- ------------------------ ---------------------
  `phi_pz`         Primary-zone     --                                         0.8
                   equivalence                               
                   ratio                                     

  `eps_pz`         Target           --                                        0.70
                   primary-zone                              
                   combustion                                
                   efficiency                                

  `Tm`             Liner metal      K                                      1172.22
                   temperature                               

  `Tc`             Cooling-air      K                         1660 °R converted to
                   total                                                         K
                   temperature                               

  `coolType`       Liner cooling    `1` = film; `2` =                            2
                   model            transpiration/effusion   
  --------------------------------------------------------------------------------

The global equivalence ratio, `phi4`, and the maximum temperature-rise
scale, `dTmax`, are calculated from the fuel flow and station data.

#### D. Primary-zone swirler

  -------------------------------------------------------------------------------
  Input            Description             Unit / choices                 Default
  ---------------- ----------------------- ---------------- ---------------------
  `rh`             Swirler hub radius      m                  0.5 in converted to
                                                                               SI

  `asw`            Swirler vane/flow       degrees                             45
                   turning angle from                       
                   axial direction                          

  `Nvane`          Number of vanes per     integer                             12
                   swirler                                  

  `sigma`          Vane solidity,          --                                 1.0
                   chord/circumferential                    
                   pitch                                    
  -------------------------------------------------------------------------------

The code uses a sharp-edged-hole discharge coefficient of `CD90 = 0.64`
internally.

#### E. Secondary and dilution jets

No independent jet-hole geometry inputs are requested. The code
calculates secondary- and dilution-hole dimensions and counts from the
air fractions, reference dynamic pressure, liner height, jet velocity,
density, discharge coefficient, and nozzle count.

#### F. Main-burner kinetics

  Input     Description                     Unit / choices          Default
  --------- ------------------------------- --------------------- ---------
  `doKin`   Run primary-zone WSR kinetics   `1` = yes; `0` = no           1

### 4.3 Afterburner inputs

#### A. Core, bypass, mixed-flow, and exit station data

  --------------------------------------------------------------------------------
  MATLAB input    Description                            Unit              Default
  --------------- ---------------------- -------------------- --------------------
  `mdot6`         Core-gas mass flow at                  kg/s         118.65 lbm/s
                  station 6                                        converted to SI

  `Pt6`           Core total pressure at                   Pa 78.129 psi converted
                  station 6                                                  to SI

  `Tt6`           Core total temperature                    K 1983.04 °R converted
                  at station 6                                                to K

  `M6`            Core Mach number at                      --               0.3702
                  station 6                                   

  `A6`            Core area at station 6                   m²  1.549 ft² converted
                                                                             to SI

  `ri6`           Inner radius of core                      m 11.9 in converted to
                  duct at station 6                                             SI

  `mdot16`        Bypass-air mass flow                   kg/s         109.98 lbm/s
                  at station 16                                    converted to SI

  `Pt16`          Bypass total pressure                    Pa 83.391 psi converted
                  at station 16                                              to SI

  `Tt16`          Bypass total                              K  893.29 °R converted
                  temperature at station                                      to K
                  16                                          

  `M16`           Bypass Mach number at                    --               0.4725
                  station 16                                  

  `A16`           Bypass area at station                   m²  0.719 ft² converted
                  16                                                         to SI

  `mdot6A`        Mixed-flow mass flow                   kg/s         228.63 lbm/s
                  at station 6A                                    converted to SI

  `Pt6A`          Mixed-flow total                         Pa 76.859 psi converted
                  pressure at station 6A                                     to SI

  `P6A`           Mixed-flow static                        Pa 68.248 psi converted
                  pressure at station 6A                                     to SI

  `Tt6A`          Mixed-flow total                          K 1513.71 °R converted
                  temperature at station                                      to K
                  6A                                          

  `A6A`           Mixed-flow area at                       m²  2.338 ft² converted
                  station 6A                                                 to SI

  `g6A`           Specific-heat ratio at                   --                1.336
                  station 6A                                  

  `mfAB`          Afterburner fuel mass                  kg/s         8.7033 lbm/s
                  flow                                             converted to SI

  `Pt7`           Target total pressure                    Pa 73.016 psi converted
                  at station 7                                               to SI

  `mdot7`         Mass flow at station 7                 kg/s         237.33 lbm/s
                                                                   converted to SI

  `A61`           Flameholder/diffuser                     m²  5.378 ft² converted
                  station 6.1 area                                           to SI

  `ro`            Maximum afterburner                       m 15.7 in converted to
                  outer radius                                                  SI
  --------------------------------------------------------------------------------

#### B. Composition and thermal closure

When the main burner is included in the same run, the afterburner
obtains the station-4 equivalence ratio, station-4 mass flow, and
`dTmax` from the main-burner calculation. Otherwise, the following
inputs are requested:

  ----------------------------------------------------------------------------
  Input           Description                        Unit              Default
  --------------- ------------------ -------------------- --------------------
  `phi4`          Equivalence ratio                    --               0.3784
                  at station 4                            

  `m4`            Station-4 products                 kg/s         106.94 lbm/s
                  mass flow                                    converted to SI

  `dTmax`         Temperature-rise                      K                 2172
                  scale, `fst*h/cp`                       
  ----------------------------------------------------------------------------

The afterburner exit total-temperature default is estimated from fuel
addition using the code's linear temperature-rise relation. The user can
override it:

  -----------------------------------------------------------------------
  Input             Description       Unit / choices    Default
  ----------------- ----------------- ----------------- -----------------
  `Tt7`             Afterburner exit  K                 Heat-addition
                    total temperature                   estimate

  `RR`              Flameholder       --                0.5
                    mixing-layer                        
                    recirculation                       
                    ratio                               
  -----------------------------------------------------------------------

The implementation requires `Tt7 > Tt6A`.

#### C. Diffuser and mixer

  ------------------------------------------------------------------------
  Input            Description      Unit / choices                 Default
  ---------------- ---------------- ---------------- ---------------------
  `etaM`           Flat-wall        --                                0.90
                   diffusion                         
                   efficiency                        

  `useGrid`        Select section-m `1` =                                1
                   area method      grid-search      
                                    optimum; `0` =   
                                    analytic Eq.     
                                    (9.103)          

  `Cdelta`         Shear-layer      --                                0.45
                   growth constant                   
  ------------------------------------------------------------------------

The diffuser grid search uses a 9-degree included angle and searches the
ranges `1.5 ≤ AR ≤ 4` and `4 ≤ L/H1 ≤ 20`. Outside the supported
area-ratio range, the analytic method is used.

The code calculates a mixer-length estimate but asks for the actual
geometry length later.

#### D. Flameholders and flame spread

  --------------------------------------------------------------------------
  Input           Description                      Unit              Default
  --------------- ---------------- -------------------- --------------------
  `WH`            Vee-gutter                         --                  0.4
                  wake-width                            
                  ratio, W/H                            

  `Nr`            Number of                     integer                    3
                  vee-gutter rings                      

  `thSp`          Flame-spread                  degrees                   17
                  included angle                        

  `tBO_user`      User-specified                      s                    0
                  blowout                               
                  residence time;                       
                  enter zero to                         
                  calculate it                          
                  from WSR                              
                  kinetics                              
  --------------------------------------------------------------------------

The alternate no-mix design, if selected, additionally requests:

  ------------------------------------------------------------------------
  Input            Description      Unit / choices                 Default
  ---------------- ---------------- ---------------- ---------------------
  No-mix           Run alternate    `1` = yes; `0` =                     1
  evaluation       no-mix           no               
                   afterburner                       

  No-mix `WH`      No-mix           --                                 0.5
                   wake-width ratio                  
  ------------------------------------------------------------------------

#### E. Axial geometry

  -------------------------------------------------------------------------
  Input           Description                     Unit              Default
  --------------- --------------- -------------------- --------------------
  `Lduct`         Upstream duct                      m   12 in converted to
                  length from                                            SI
                  stations 6/16                        
                  to 6A                                

  `Lmixer`        Mixer length                       m                    0
                  from 6A to                           
                  diffuser entry                       
  -------------------------------------------------------------------------

## 5. Design methodology and governing relations

The program is a sequential, equation-based preliminary sizing
procedure. It does not solve a global optimization problem for all
combustor dimensions. Instead, it uses station data and selected design
targets to calculate component dimensions and then checks selected
aerodynamic, combustion, and flameholding constraints.

### 5.1 Annular geometry

For an annulus with flow area (A) and mean radius (r_m), the annulus
height and hub/tip radii are obtained from:

\[ A = 2`\pi `{=tex}r_m H \]

\[ H = `\frac{A}{2\pi r_m}`{=tex},`\qquad`{=tex} r_o =
r_m+`\frac{H}{2}`{=tex},`\qquad`{=tex} r_i = r_m-`\frac{H}{2}`{=tex} \]

For a specified outer radius and annulus area, the inner radius is
calculated as:

\[ r_i = `\sqrt{r_o^2-\frac{A}{\pi}}`{=tex} \]

### 5.2 Fuel-air equivalence ratio and temperature-rise scale

The fuel surrogate is (C\_{12}H\_{23}). Its stoichiometric fuel-air
ratio is calculated from the stoichiometric oxygen requirement:

\[ a=x+`\frac{y}{4}`{=tex},`\qquad `{=tex}C_xH_y \]

\[ f\_{st} = `\frac{M_F}`{=tex} {M_F + `\dfrac{a}{0.21}`{=tex}M\_{air}}
\]

The source implements the equivalent expression for the selected
surrogate. The global equivalence ratio is:

\[ `\phi`{=tex}\_4 = `\frac{\dot m_f}{f_{st}\dot m_{air}}`{=tex} \]

The maximum temperature-rise scale and the code's linear temperature
closure are:

\[ `\Delta `{=tex}T\_{max} = `\frac{T_{t4}-T_{t3.1}}{\phi_4}`{=tex} \]

\[ T_g =
T\_{t3.1}+`\phi`{=tex}*{pz}`\epsilon`{=tex}*{pz}`\Delta `{=tex}T\_{max}
\]

The temperature relation is an engineering closure used by the source,
not a full reacting-flow enthalpy solution.

### 5.3 Main-burner air partitioning

The total air is divided into primary-zone, secondary-zone,
liner-cooling, and dilution fractions:

\[ `\mu`{=tex}\_{pz}=`\frac{\phi_4}{\phi_{pz}}`{=tex} \]

\[ `\phi`{=tex}\_{sz}=`\frac{T_g-T_{t3.1}}{\Delta T_{max}}`{=tex} \]

\[ `\mu`{=tex}*{sz}=`\frac{\phi_4}{\phi_{sz}}`{=tex}-`\mu`{=tex}*{pz} \]

Cooling effectiveness is evaluated as:

\[ `\epsilon`{=tex}\_c=`\frac{T_g-T_m}{T_g-T_c}`{=tex} \]

The cooling-air fraction uses one of two implemented correlations:

\[ `\mu`{=tex}\_c =
```{=tex}
\begin{cases}
\dfrac{\epsilon_c}{6(1-\epsilon_c)}, & \text{film cooling}\\[6pt]
\dfrac{\epsilon_c}{25(1-\epsilon_c)}, & \text{transpiration/effusion}
\end{cases}
```
\]

The remaining dilution-air fraction is:

\[ `\mu`{=tex}*{dz}=1-`\mu`{=tex}*{pz}-`\mu`{=tex}\_{sz}-`\mu`{=tex}\_c
\]

A negative dilution fraction triggers a warning.

### 5.4 Liner height and primary-zone swirlers

The liner height is calculated using the optimum
liner-to-reference-height ratio:

\[ H_L=`\alpha `{=tex}H_r \]

where the source evaluates (`\alpha`{=tex}) using its implementation of
Eq. (9.109).

The primary-zone jet velocity is estimated from the reference velocity
and pressure-loss parameter:

\[ V_j=U_r`\sqrt{\left(\frac{\Delta P_t}{q_r}\right)}`{=tex} \]

The swirler flow area is calculated from the required primary air,
nozzle count, reference density, jet velocity, discharge coefficient,
and vane angle:

\[ A\_{sw} = `\frac{\dot m_{sw}}`{=tex} {N\_{noz}`\rho`{=tex}*r V_j
C*{D,90}`\cos`{=tex}`\alpha`{=tex}\_{sw}} \]

The swirl number is estimated using the annular swirler geometry:

\[ S_p = `\frac{2}{3}`{=tex}`\tan`{=tex}`\alpha`{=tex}\_{sw}
`\frac{1-(r_h/r_t)^3}{1-(r_h/r_t)^2}`{=tex} \]

The primary-zone length is then:

\[ L\_{pz}=2S_p r_t \]

Vane chord, circumferential pitch, axial length, radial span, and
helical pitch are calculated from the vane count, solidity, radii, and
vane angle.

### 5.5 Secondary and dilution jets

The secondary- and dilution-hole design uses the jet-to-annulus
dynamic-pressure relationship and a jet-penetration correlation. The
code calculates:

-   Jet trajectory angle.
-   Maximum penetration ratio.
-   Vena-contracta jet diameter.
-   Physical hole diameter.
-   Total hole count and holes per nozzle.

The common calculation uses:

\[ `\sin`{=tex}`\theta `{=tex}= `\sqrt{1-\frac{q_A}{q_j}}`{=tex} \]

\[ `\frac{Y_{dJ}}{d_j}`{=tex}
=1.15`\sqrt{\frac{q_j}{q_L}}`{=tex}`\sin`{=tex}`\theta`{=tex} \]

\[ d_j = `\frac{H_L/k}{Y_{dJ}/d_j}`{=tex} \]

\[ A_j=`\frac{\pi d_j^2}{4}`{=tex},`\qquad`{=tex}
N\_{tot}=`\frac{\dot m_s}{\rho V_j A_j}`{=tex} \]

\[ d_h=`\frac{d_j}{\sqrt{C_D}\sin\theta}`{=tex} \]

Here, (k=4) is used for secondary jets and (k=3) for dilution jets in
the implementation.

### 5.6 Primary-zone micromixing checks

The code evaluates the ratio between liner characteristic area and total
primary-jet area, along with mixing and residence times. It compares the
calculated quantities against the criteria implemented from Eqs.
(9.75)--(9.79). These checks are reported as warnings rather than being
used in an automatic iterative redesign.

### 5.7 Afterburner diffuser and mixer

The afterburner diffuser is sized from the inlet and flameholder-station
areas, annulus geometry, and specified diffuser efficiency. The user can
select either:

-   A grid-search result over the implemented diffuser design space; or
-   The analytic relation from Eq. (9.103).

The mixer calculation first obtains core and bypass static properties
from total conditions and Mach numbers:

\[ T=`\frac{T_t}{1+\frac{\gamma-1}{2}M^2}`{=tex} \]

\[ P=`\frac{P_t}`{=tex}
{`\left`{=tex}(1+`\frac{\gamma-1}{2}`{=tex}M^2`\right`{=tex})^{`\gamma`{=tex}/(`\gamma-1`{=tex})}}
\]

\[ U=M`\sqrt{\gamma R T}`{=tex},`\qquad`{=tex}
`\rho`{=tex}=`\frac{P}{RT}`{=tex} \]

The velocity and density ratios are used in the implemented shear-layer
growth relation. The resulting growth rate provides a mixing-length
estimate:

\[ L\_{mix,est}=`\frac{H_{16}}{d\delta/dx}`{=tex} \]

The actual mixer length remains a user input.

### 5.8 Vee-gutter flameholders

The wake-width ratio determines the gutter geometry and loss parameters.
The code calculates recirculation length and residence time, then
compares the residence time with the WSR-derived blowout time.

The minimum channel height is calculated from the approach velocity,
blowout time, and wake-width-dependent factor:

\[ H\_{min}=`\frac{U_1t_{BO}}{N_s}`{=tex} \]

The code also estimates channel height, gutter width, maximum ring count
under its geometric margin rule, and flame-spread length.

### 5.9 Total-pressure loss and station-7 state

The wet afterburner loss coefficient is evaluated as:

\[ `\left`{=tex}(`\frac{\Delta P_t}{q}`{=tex}`\right`{=tex})*{wet}
=(`\tau`{=tex}*{AB}-1)+C_D B \]

\[ `\tau`{=tex}\_{AB}=`\frac{T_{t7}}{T_{t6A}}`{=tex} \]

The wet and dry total pressures are calculated from the diffuser-exit
state and dynamic pressure. The station-7 Mach number is obtained by
solving the implemented compressible mass-flow relation with `fzero`
over a subsonic interval. Static temperature, static pressure, velocity,
critical area, and stream thrust are then calculated.

### 5.10 WSR chemical kinetics and blowout

The chemical-kinetics module uses a 30-reaction forward-rate mechanism
and 21 species. The reaction-rate coefficient is evaluated in the form:

\[
k_j=10^{B_j}T^{N_j}`\exp`{=tex}`\left`{=tex}(-`\frac{T_{act,j}}{T}`{=tex}`\right`{=tex})
\]

The species equations are implemented as:

\[ `\frac{dn_i}{dt}`{=tex} =
`\frac{1}{\rho}`{=tex}`\sum`{=tex}*j`\nu`{=tex}*{ij}R_j
-`\frac{n_i-n_i^*}{\tau}`{=tex} \]

where the residence time is:

\[ `\tau`{=tex}=`\frac{\rho V}{\dot m}`{=tex} \]

Reaction rates use species concentrations and include a third-body
concentration factor for reactions marked as third-body reactions.

Fuel conversion and temperature are coupled through:

\[ `\epsilon=1`{=tex}-`\frac{n_f}{n_{f,in}}`{=tex} \]

\[ T=T\_{in}+`\epsilon`{=tex}`\phi`{=tex}`\Delta `{=tex}T\_{max} \]

The stiff species equations are integrated with `ode15s` toward a
stationary state. The blowout residence time is estimated by searching
in logarithmic residence-time space for the minimum residence time at
which the ignited solution exceeds the specified fuel-conversion
threshold.

## 6. Outputs

### 6.1 Command-window report

The program prints the selected design mode, intermediate calculations,
calculated component dimensions, pressure-loss estimates, combustion/air
fractions, kinetic results, and design warnings.

### 6.2 MATLAB figures

Figures are displayed during execution and saved as PNG files in:

``` text
Combustor_Figures/
```

The figures cover the generated main-burner and afterburner geometry,
air partitioning, swirlers, jet rows, diffuser behavior, flameholders,
WSR behavior, and related design checks. The exact set depends on the
selected design mode and whether optional calculations are enabled.

### 6.3 Exported files

  -----------------------------------------------------------------------
  File                                Contents
  ----------------------------------- -----------------------------------
  `Combustor_Results.mat`             MATLAB structure `R`, containing
                                      inputs, calculated results,
                                      geometry, kinetic results, and
                                      reports for the selected
                                      component(s).

  `Combustor_Geometry.csv`            Geometry points in millimetres,
                                      with columns `burner`, `part`,
                                      `x_mm`, and `r_mm`.

  `Combustor_Report.txt`              Text report containing component
                                      design summaries and scalar
                                      input/calculated properties.

  `Combustor_Figures/*.png`           Saved design figures, including
                                      figure-side panels with input and
                                      calculated properties.
  -----------------------------------------------------------------------

### 6.4 Main-burner calculated outputs

The main-burner result structure contains, among other fields:

-   Diffuser area ratio, efficiency, pressure-loss coefficient, and
    axial length.
-   Global and zone equivalence ratios and temperature-rise scale.
-   Primary, secondary, cooling, and dilution air fractions.
-   Optimum liner-height ratio, liner height, and liner radii.
-   Reference velocity, density, and jet velocity.
-   Swirler flow area, hub/tip/mean radii, swirl number, primary-zone
    length, vane count, solidity, pitch, chord, and axial length.
-   Secondary- and dilution-hole jet angles, penetration ratios,
    diameters, and counts.
-   Primary-zone micromixing and residence-time quantities.
-   Optional WSR conversion, temperature, species mole fractions, and
    blowout time.
-   Main-burner meridional geometry in millimetres.

### 6.5 Afterburner calculated outputs

The afterburner result structure contains, among other fields:

-   Diffuser grid-search and analytic results, section area, efficiency,
    and lengths.
-   Station-6.1 static/total state, Mach number, velocity, and
    density-related quantities.
-   Core/bypass velocity and density ratios, shear-layer growth rate,
    and mixer-length estimate.
-   Vee-gutter wake ratio, geometry, channel dimensions, ring count,
    flame-spread length, and blowout checks.
-   Wet and dry pressure losses and station-7 Mach number, pressure,
    temperature, velocity, critical area, and stream thrust.
-   WSR conversion, temperature, species mole fractions, blowout time,
    and residence-time sweep.
-   Optional no-mix core/fan split, stream fuel requirements,
    flameholder dimensions, and related outputs.
-   Afterburner meridional geometry in millimetres.

## 7. MATLAB result structure

The saved MAT-file contains the top-level structure `R`.

``` matlab
load('Combustor_Results.mat');

R.mode       % selected design mode
R.main.in    % main-burner inputs, if calculated
R.main.res   % main-burner calculated scalar results
R.main.geo   % main-burner geometry in mm
R.main.kin   % main-burner kinetics, if enabled

R.ab.in      % afterburner inputs, if calculated
R.ab.res     % afterburner calculated scalar results
R.ab.geo     % afterburner geometry in mm
R.ab.kin     % afterburner kinetics
R.ab.grid    % diffuser grid-search results
R.ab.nomix   % alternate no-mix design, if enabled
R.ab.sweep   % WSR residence-time sweep
```

Fields are present only when the corresponding component or optional
calculation has been executed.

## 8. Assumptions and limitations

The following limitations are important when interpreting results:

1.  **Forward-only chemistry:** The tabulated mechanism provides forward
    reaction rates only. Reverse reactions are neglected.
2.  **Simplified energy closure:** Gas temperature is calculated using
    the linear relation
    (T=T\_{in}+`\epsilon`{=tex}`\phi`{=tex}`\Delta `{=tex}T\_{max}), not
    a full species-enthalpy conservation equation.
3.  **Kinetic mechanism scope:** The implementation uses the specified
    30-reaction jet-fuel surrogate mechanism. It should not be treated
    as a comprehensive modern kerosene oxidation mechanism.
4.  **Mixer length:** The shear-layer relation provides a mixing-length
    estimate, but the actual mixer length is supplied by the user.
5.  **Diffuser range:** The afterburner diffuser grid search is
    restricted to the coded area-ratio and length-ratio ranges.
    Diffusers with area ratio greater than or equal to 4 are
    approximations in the main-burner treatment.
6.  **Shear-layer correlation:** Eq. (9.56) is implemented as printed in
    the reference. The source notes that the worked growth value in the
    book is approximately half the value obtained from the printed
    equation.
7.  **Preliminary geometry:** The exported geometry is a 2-D meridional
    representation and schematic component layout. It is not a
    manufacturing-ready CAD model.
8.  **No reacting-flow CFD:** The code does not resolve turbulent
    reacting flow, spray atomization, detailed flame structure, wall
    heat transfer, emissions, or thermoacoustic instabilities.
9.  **Design checks:** Several constraints are reported as warnings. A
    warning does not automatically trigger a redesign or guarantee that
    the selected design is feasible.
10. **Input consistency:** The user must provide mutually consistent
    station conditions, mass flows, areas, and target
    pressures/temperatures. The program does not replace an engine-cycle
    calculation or validate all station data.

## 9. Reference

The design procedure is based on:

*Aircraft Engine Design*, 2nd edition, Chapter 9: - Section 9.1 ---
Basic combustor relations. - Section 9.2 --- Main-burner design
procedure. - Section 9.3 --- Afterburner design procedure. - Section 9.4
--- AAF engine design example.

The source code identifies the WSR species equations as Eq. (9.19) and
the 30-reaction jet-fuel mechanism as Table 9.3 (Kollrack).

## 10. Disclaimer

This software is intended for preliminary engineering studies,
educational use, and design-method exploration. Results should be
independently checked against the original references, thermodynamic
consistency, applicable design standards, CFD, and experimental data
before being used for hardware design or safety-critical decisions.

## 11. Repository contents

A minimal repository layout is:

``` text
.
├── Combustor_Design.m
├── README.md
└── Combustor_Figures/       # generated when the program is run
```
