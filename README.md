# DAKOTA-coupled-VIC-framework
<div style="text-align: center;">
<img src="https://github.com/1iuyu/DAKOTA-coupled-VIC-framework/assets/145678619/2495253d-0f75-497d-a670-ddd0e3472502" alt="Image" width="314" height="218">
</div>
Software architecture of the coupled VIC-DAKOTA capability, for parameter calibration and model optimization, including the Routing of streamflow model.

## Files
`dakota_mogatest.in`:dakota's input file.<br />
`matlab_wrapper.m`:The file used to pass parameters between the VIC model and DAKOTA. Data pre-processing and Data post-processing in the figure.<br />
`set_up_parallel.m`:Create global_param.txt and soil_param.txt files for parallel computation of VIC-5 classic or VIC-4.2.d (prior versions)  input files.<br />
`cv_params.txt`:The address needed to run the `set_up_parallel.m`.<br />
`myKGE.m`,`myNSE.m`,`myRMSE.m`:metrics files<br />
`shell_script.sh`:runs VIC model in parallel.<br />
`simulator.bat`,`strsplit_spec.m`,`write_soils.m`:Other Files<br />



References
----------
More information on an upcomming paper.
