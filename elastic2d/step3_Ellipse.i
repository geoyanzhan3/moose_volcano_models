#Tensor Mechanics tutorial: the basics
#Step 1, part 1
#2D simulation of uniaxial tension with linear elasticity

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  dim = 2
  file = Ellip_A2d.msh 
[]

[Modules/TensorMechanics/Master]
  [./block1]
    strain = SMALL #Small linearized strain, automatically set to XY coordinates
    add_variables = true #Add the variables from the displacement string in GlobalParams
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 30e9
    poissons_ratio = 0.25
  [../]
  [./stress]
    type = ComputeLinearElasticStress
  [../]
[]


[BCs]
  [right]
    type = DirichletBC
    variable = disp_x
    boundary = 'right'
    value = 0.0
  []
  [bottom]
    type = DirichletBC
    variable = disp_y
    boundary = 'bottom'
    value = 0.0
  []
  [chamber]
    type = DirichletBC
    variable = disp_y
    boundary = 'chamber'
    value = 10
  []
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
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
[]
