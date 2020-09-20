#ensodisplacementsr Mechanics tutorial: the basics
#Step 1, part 1
#2D simulation of uniaxial tension with linear elasticity

[GlobalParams]
  displacements = 'disp_r disp_z'
[]

[Problem]
  coord_type = RZ
[]

[Mesh]
  file = Ellip_A2d.msh 
[]

[Modules/TensorMechanics/Master]
  [./all]
    strain = SMALL
    add_variables = true
    eigenstrain_names = ini_stress
  [../]
[]

[Kernels]
  [./weight]
    type = BodyForce
    variable = disp_z
    value = '-25497.42' # this is density*gravity
  [../]
[]

[Functions]
  [./rhogh]
    type = ParsedFunction
    value = '25497.42*y' # initial stress that should result from the weight force
  [../]
  [./boundary_pressure]
    type = ParsedFunction
    value = '-25497.42*y+10e6'
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 30e9
    poissons_ratio = 0.25
  [../]
  [./strain_from_initial_stress]
    type = ComputeEigenstrainFromInitialStress
    initial_stress = 'rhogh 0 0  0 rhogh 0  0 0 rhogh'
    eigenstrain_name = ini_stress
  [../]
  [./stress]
    type = ComputeLinearElasticStress
  [../]
[]

[BCs]
  [right]
    type = DirichletBC
    variable = disp_r
    boundary = 'right'
    value = 0.0
  []
  [bottom]
    type = DirichletBC
    variable = disp_z
    boundary = 'bottom'
    value = 0.0
  []
  [Pressure]
    [chamber]
      displacements = 'disp_r disp_z'
      boundary = 'chamber'
      function = boundary_pressure
      #factor = 1e6
    [] 
  []
[]


[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Steady

  solve_type = 'NEWTON'

  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-pc_type -sub_pc_type -pc_asm_overlap -ksp_gmres_restart'
  petsc_options_value = 'asm lu 1 101'
[]

[Outputs]
  exodus = true
  perf_graph = true
  csv = true
[]
