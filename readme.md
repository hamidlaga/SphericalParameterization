# SphericalParameterization
## Spherical Parameterization of Genus-0 Mesh Surfaces

This code is a non-official implementation of the paper:        
> Emil Praun and [Hugues Hoppe](https://hhoppe.com/).
> [**Spherical parametrization and remeshing**](https://hhoppe.com/sphereparam.pdf).
> ACM Transactions on Graphics (TOG) 22.3 (2003): 340-349.

The algorithm is very efficient as it is able to spherically parameterize, with very low distrosion, complex 3D models even those with long extruding parts. It is, however, limited to genus-0 surfaces (as is the case with most of the spherical parameterization algorithms) and works only on manifold (clean) meshes.  

The code runs only on Windows and requires Matlab. It is standalone and does not require any setup (apart from having Matlab running on Windows).

This code was developed for research purposes and is not meant for commercial use. We expect that the code may have some bugs and issues. However, while we will be happy to answer some questions, we may not be able to provide support. 

## Citation
If you use this code, please make sure you cite: 
```bibtex
@inproceedings{kurtek2013landmark, 
title={Landmark-guided elastic shape analysis of spherically-parameterized surfaces}, 
author={Kurtek, Sebastian and Srivastava, Anuj and Klassen, Eric and Laga, Hamid}, 
booktitle={Computer graphics forum}, v
olume={32}, 
number={2pt4}, 
pages={429--438}, 
year={2013}, 
organization={Wiley Online Library}
}
```
and
```bibtex
@article{jermyn2017elastic, 
title={Elastic shape analysis of three-dimensional objects}, 
author={Jermyn, Ian H and Kurtek, Sebastian and Laga, Hamid and Srivastava, Anuj}, 
journal={Synthesis Lectures on Computer Vision}, 
volume={12}, 
number={1}, 
pages={1--185}, 
year={2017}, 
publisher={Morgan \& Claypool Publishers} 
}
```
We also highly recommend that you cite the original paper of Praun and Hoppe:
```bibtex
@article{praun2003spherical,
title={Spherical parametrization and remeshing},
author={Praun, Emil and Hoppe, Hugues},
journal={ACM Transactions on Graphics (TOG)},
volume={22},
number={3},
pages={340--349},
year={2003},
publisher={ACM New York, NY, USA}
}
```

## How to use the code:
Start with the script runAllScript.m. The script loops through the 3D models in the folder "sample_data" and generates their spherical parameterizations. Note that the four sample 3D models in the folder "sample_data" are from the [SHREC2017 Watertight Models](http://watertight.ge.imati.cnr.it/), which contains around 400 models in total. Thus, if you use them, make sure you acknowlegde and give credit to [SHREC2017 Watertight Models](http://watertight.ge.imati.cnr.it/). 

## Licence and Copyright
Copyright Hamid Laga Date: 2022/03/20.

This code uses some external libraries, which are included here but credit should be given to the original authors: 

- The kdtree library, developed by Andrea Tagliasacchi; see https://www.mathworks.com/matlabcentral/profile/authors/1058872

- Progressive mesh structure, which is part of OpenMesh (https://www.graphics.rwth-aachen.de/software/openmesh/). Please refer to www.openmesh.org and https://www.graphics.rwth-aachen.de/software/openmesh/license/ for the license and copyright.

## Contributors and Contact
Hamid Laga, Sebastian Kurtek, Eric Klassen, Anuj Srivastava.

For any questions, you can contact hamid.laga@gmail.com. 

Note that the code was developed for research purposes and is provided as it is. Thus, we may not be able to provide support on how to use it and fix potential bugs.

