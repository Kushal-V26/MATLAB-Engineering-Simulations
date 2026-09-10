# MATLAB-Engineering Simulations
Numerical analysis, structural optimization, dynamic simulations, and signal processing in MATLAB
# 2D Static Truss Analysis

A generic MATLAB solver for analyzing 2D pin-jointed trusses, checking kinematic/static determinacy, and classifying internal member forces.

## Key Visualizations

### Truss Configurations & Force Analysis
| Truss 1 | Truss 2 |
| :---: | :---: |
| ![Truss 1](01-Static-Truss-Solver/Results/Truss%201.png) | ![Truss 2](01-Static-Truss-Solver/Results/Truss%202.png) |

| Truss 3 | Truss 4 |
| :---: | :---: |
| ![Truss 3](01-Static-Truss-Solver/Results/Truss%203.png) | ![Truss 4](01-Static-Truss-Solver/Results/Truss%204.png) |

## Methodology
- **Kinematic Determinacy:** Evaluates degrees of freedom $f = 2k - (a + s)$ where $k$ is nodes, $a$ is bearing constraints, and $s$ is structural bars.
- **Equilibrium Matrix Assembly:** Constructs the global equilibrium matrix $A$ using directional cosines between connected nodes.
- **Direct Solution:** Solves the linear system $r = A \backslash (-F)$ for internal bar forces and reaction loads.
- **Member Classification:** Automatically categorizes bars into **Tension** ($S_i > 0$, green), **Compression** ($S_i < 0$, red), and **Zero-Force** ($S_i = 0$, blue).
