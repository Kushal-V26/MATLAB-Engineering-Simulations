# Structural Topology & Stiffness Optimization

A computational structural optimization framework implemented in MATLAB using Sequential Quadratic Programming (SQP via `fmincon`) to minimize nodal deflections under mass, stress, and variable bounds.

## Key Visualizations

### Baseline vs. Single-Constraint Optimization
| Task 1: Initial Deformed Structure | Task 2: Optimized (Bounds Only) |
| :---: | :---: |
| ![Task 1 Initial](Results/Task1_Initial_Deformed.png) | ![Task 2 Bounds Only](Results/Task2_Bounds_Only.png) |

### Constrained Optimization & Topology Scaling
| Task 3: Linear Equality Constraint | Task 5: SQP Nonlinear Constrained |
| :---: | :---: |
| ![Task 3 Linear Eq](Results/Task3_Linear_Eq.png) | ![Task 5 SQP](Results/Task5_SQP.png) |

### Industrial Application
| Task 7: Optimized Crane Structure |
| :---: |
| ![Task 7 Crane](Results/Task7_Crane_Optimized.png) |

---

## Mathematical Formulation

### 1. Design Variables
The optimization modifies member cross-sectional area scaling factors $\mathbf{x} = [x_1, x_2, \dots, x_m]^T$, which directly scale axial stiffness $(EA)_i = x_i \cdot (EA)_0$.

### 2. Objective Function
Minimizes the vertical displacement magnitude at the point of load application to maximize global structural stiffness:
$$\min_{\mathbf{x}} f(\mathbf{x}) = |u_y(\mathbf{x})|$$

### 3. Constraints Hierarchy
- **Bound Constraints:** Lower and upper limits on member scaling factors ($0.01 \le x_i \le 5.0$).
- **Mass / Stiffness Conservation:** Linear equality constraint maintaining a constant total mass budget:
  $$\sum_{i=1}^m (EA)_i = \text{Target Stiffness}$$
- **Allowable Stress Limits:** Nonlinear inequality constraints ensuring bar stress remains within yield thresholds:
  $$\sigma_i(\mathbf{x}) = \frac{|S_i(\mathbf{x})|}{x_i A_0} \le \sigma_{\text{allowable}}$$

---

## Experimental Workflow
- **Task 1:** Baseline displacement evaluation under uniform cross-sectional area.
- **Task 2:** Optimization bounded only by scaling factor limits ($x \in [0.01, 5.0]$).
- **Task 3:** Optimization under total axial stiffness equality constraint ($A_{\text{eq}} \mathbf{x} = 825$).
- **Task 4 & 5:** Nonlinear Sequential Quadratic Programming (SQP) under combined stress and stiffness constraints.
- **Task 6:** Data export and numerical convergence logging.
- **Task 7:** Scaled structural optimization applied to a high-degree-of-freedom asymmetric crane truss.
