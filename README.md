Parallel Ansys
==============

Run [Ansys](http://www.ansys.com/) in parallel batch mode from [Matlab](http://www.mathworks.com/products/matlab/)

__Codes:__ Ansys APDL, Matlab

See
-----
* example: parallel_ansys_test.m and /Ansys/frame_test
* Matlab/parallel_ansys/parallel_ansys.m help file/preamble


Working of the code
-------------------
  1. form blocks with 'n' number of jobs (to be run parallel), start with
     the first block
  2. create temporary folders in the main Ansys working folder for parallel jobs: /job1_tmp,
     /job2_tmp, ... ,/job'n'_tmp
  3. run 'n' jobs/analyses parallel and save the requested results to the
  corresponding folders
  4. collect and copy the requested results to the main Ansys working folder
  5. Delete the temporary job folders
  6. Go to step 1. and move to the next block if any
  
Acknowledgements
----------------

The scripts in this repo have been developed at [Department of Structural Engineering](http://www.epito.bme.hu/hidak-es-szerkezetek-tanszek), Budapest University of Technology and Economics.

  
My other Ansys related repos
----------------------------
* [run Ansys in parallel batch mode using Matlab](https://github.com/rozsasarpi/Parallel-Ansys)
* [dynamic load analysis for bridges](https://github.com/rozsasarpi/DLA-Ansys)
* [construction stage analysis](https://github.com/rozsasarpi/CSA-Ansys)
