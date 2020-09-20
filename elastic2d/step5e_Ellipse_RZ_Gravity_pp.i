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
  file = Ellip_A2d_coarse.msh 
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


[AuxVariables]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_max]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_mid]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_min]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]
  [./stress_xy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xy
    index_i = 0
    index_j = 1
  [../]
  [./stress_xz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xz
    index_i = 0
    index_j = 2
  [../]
  [./stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
  [../]
  [./stress_yz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yz
    index_i = 1
    index_j = 2
  [../]
  [./stress_zz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zz
    index_i = 2
    index_j = 2
  [../]
  [./stress_max]
    type = RankTwoScalarAux
    rank_two_tensor = stress
    variable = stress_max
    scalar_type = MaxPrincipal
  [../]
  [./stress_mid]
    type = RankTwoScalarAux
    rank_two_tensor = stress
    variable = stress_mid
    scalar_type = MidPrincipal
  [../]
  [./stress_min]
    type = RankTwoScalarAux
    rank_two_tensor = stress
    variable = stress_min
    scalar_type = MinPrincipal
  [../]
[]

[VectorPostprocessors]
  [./disp]
    type = LineValueSampler
    sort_by = x
    variable = 'disp_r disp_z'
    start_point = '0 0 0'
    end_point = '10000 0 0'
    num_points = 101
    execute_on = 'timestep_end'
  [../]
  [./sigma]
    type = LineValueSampler
    sort_by = y
    variable = 'stress_xx stress_yy stress_xy'
    start_point = '1e3 -10e3 0'
    end_point = '1e3 0 0'
    num_points = 101
    execute_on = 'timestep_end'
  [../]
  [./sigma_face]
    type = FaceValueSampler
    sort_by = 'x'
    variable = 'stress_xx'
    start_point_1 = '0 0 0'
    end_point_1 = '1e4 0 0'
    num_points_1 = 501
    start_point_2 = '0 0 0'
    end_point_2 = '0 -1e4 0'
    num_points_2 = 501
    execute_on = 'timestep_end'
  [../]
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
