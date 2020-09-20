#Tensodisplacementsr Mechanics tutorial: the basics
#Step 1, part 1
#2D simulation of uniaxial tension with linear elasticity

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  xmin = 0
  xmax = 10e3
  ymin = -10e3
  ymax = 0
[]

[GlobalParams]
  displacements = 'disp_r disp_z'
[]

[Problem]
  coord_type = RZ
[]


[Variables]
  [./disp_r]
  [../]
  [./disp_z]
  [../]
[]

[Kernels]
  [./TensorMechanics]
    displacements = 'disp_r disp_z'
  [../]
  [./weight]
    type = BodyForce
    variable = disp_z
    value = -2.6e4 # this is density*gravity
  [../]
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
[]

[Functions]
  [./rhogh]
    type = ParsedFunction
    value = '2.6e4*y' # initial stress that should result from the weight force
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 30e9
    poissons_ratio = 0.25
  [../]
  [./strain]
    type = ComputeSmallStrain
    eigenstrain_names = ini_stress
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
[]

[Preconditioning]
  [./andy]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  end_time = 1.0
  dt = 1.0
  solve_type = NEWTON
  type = Transient

  nl_abs_tol = 10
  nl_rel_tol = 1E-12
  l_tol = 1E-3
  l_max_its = 200
  nl_max_its = 400

  petsc_options_iname = '-pc_type -pc_asm_overlap -sub_pc_type -ksp_type -ksp_gmres_restart'
  petsc_options_value = ' asm      2              lu            gmres     200'
[]


[Outputs]
  exodus = true
  perf_graph = true
[]
