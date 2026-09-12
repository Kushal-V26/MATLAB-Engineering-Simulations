# MATLAB Applied Engineering Simulations Lab

This repository contains my MATLAB scripts, numerical models, and simulation results completed for the **Laboratory Course MATLAB** at FAU Erlangen-Nürnberg. 

The project is split into four core engineering modules covering static equilibrium, structural optimization, multi-body crane dynamics, and vibration signal processing with uncertainty estimation.

---

## Project Structure

```text

MATLAB-Engineering-Simulations/
├── 01-Static-Truss-Solver/           # 2D truss equilibrium, nodal matrix formulation & member force solver
├── 02-Structural-Optimization/       # Sizing & stiffness optimization using fmincon (SQP)
├── 03-Crane-Dynamics-ODE/            # Nonlinear pendulum crane dynamics, ODE integration & girder stresses
└── 04-Vibration-Signal-Analysis/     # Sensor FFT spectral filtering, symbolic beam bending & Monte Carlo

---

```
## Modules Overview

### [01. Static Truss Solver (Experiment LTM)](01-Static-Truss-Solver/)
* Assembles the global linear system of equations A*r + f = 0 from nodal equilibrium conditions using the method of joints.
* Evaluates static determinacy criteria (f = 2k - (a + s) = 0) and flags kinematic mechanisms or overconstrained systems.
* Solves for reaction forces and categorizes member states into tension (green), compression (red), and zero-force bars (blue).

### [02. Structural Topology & Stiffness Optimization (Experiment KTmfk)](02-Structural-Optimization/)
* Minimizes vertical deflection at the loaded node to maximize global structural stiffness using Sequential Quadratic Programming (fmincon / SQP).
* Enforces scaling bounds (0.01*A0 <= A <= 5*A0), total axial stiffness/mass equality constraints (sum(EA) = 825 kN and 500 kN), and nonlinear bar stress limits (sigma <= 80 MPa).
* Applies the optimization pipeline to both standard benchmark trusses and high-DOF asymmetric crane structures.

### [03. Crane Dynamics & ODE Integration (Experiment LTD)](03-Crane-Dynamics-ODE/)
* Simulates the nonlinear 2nd-order equation of motion for a crane girder with a suspended payload under damping and harmonic forcing:
  m*l^2*dphi_dt2 + d*l^2*dphi_dt + m*g*l*sin(phi) = Fe(t)*l
* Converts the dynamics into a first-order state-space system integrated via ode45 and ode23.
* Computes time-domain kinematics, state-space phase portraits (phi vs dphi/dt), dynamic rod tension Z(t), and continuous cantilever bending normal stress distributions sigma(x, y, t).

### [04. Measurement Data Analysis & Uncertainty Quantification (Experiment FMT)](04-Vibration-Signal-Analysis/)
* Imports raw vibration sensor data (VibrationSensorData.xlsx) and verifies sampling interval consistency across floating-point precision[cite: 1].
* Performs Discrete/Fast Fourier Transform (FFT) to extract structural natural frequencies and reconstructs denoised time signals using inverse FFT (ifft).
* Derives analytical bending deflections for a linearly tapering beam (I_yy(x)) using the Symbolic Math Toolbox[cite: 1].
* Computes measurement uncertainty bounds via GUM Gaussian error propagation (u_F = 50 N, u_h = 1.5 mm) and validates the response with Monte Carlo simulations (N = 10^3 and N = 10^6 trials)[cite: 1].

---

Toolbox Requirements:
* Optimization Toolbox (Module 02)
* Symbolic Math Toolbox (Module 04)
* Signal Processing Toolbox (Module 04)
