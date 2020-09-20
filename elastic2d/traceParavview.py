# trace generated using paraview version 5.8.0
#
# To ensure correct image size when batch processing, please search 
# for and uncomment the line `# renderView*.ViewSize = [*,*]`

#### import the simple module from the paraview
from paraview.simple import *
#### disable automatic camera reset on 'Show'
paraview.simple._DisableFirstRenderCameraReset()


model = ExodusIIReader(FileName=['/Users/yanzhan/Documents/Project/project_moose/elastic2d/step5d_Ellipse_RZ_Gravity_Andy_out.e'])

POL = PlotOverLine(Input = model)

PA = PassArrays(Input = POL)

PA.PointDataArrays = ['disp_']

POL.Source.Point1 = [0,0,0]

POL.Source.Point2 = [1e4,0,0]

write = CreateWriter('/Users/yanzhan/Documents/Project/project_moose/elastic2d/data.csv')

write.UpdatePipeline()