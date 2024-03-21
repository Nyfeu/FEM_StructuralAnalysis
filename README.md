# Static Structural Analysis with Finite Elements Method (FEM)

The current project was developed focusing on the application of the Finite Element Method (FEM) in Static Structural Analysis. It was designed using the Object-Oriented Programming (OOP) paradigm and the AppDesigner tool provided by MATLAB.

## Overview
This project caters to the needs of mechanical engineering students by providing a comprehensive solution for static structural analysis. Utilizing MATLAB and AppDesigner, it offers a user-friendly interface and robust functionality.

## Key Features
- **Object-Oriented Design:** Utilizes OOP principles for efficient code organization and maintenance.
- **AppDesigner Interface:** Developed with MATLAB's AppDesigner tool for a user-friendly interface.
- **Static Structural Analysis:** Capable of performing **simple** static structural analysis using the FEM, including results as stress, strain and reaction forces.
- **Flexibility:** This project offers easy integration of both 2D and 3D elements, thanks to the OOP. This enables the utilization of various element types within the same problem, enhancing overall flexibility and adaptability.

## Installation and Usage
1. Ensure you have MATLAB installed on your system.
2. Clone the repository to your local machine.
```
git clone https://github.com/Nyfeu/MEF_AnaliseEstrutural.git
``` 
3. Open MATLAB and navigate to the cloned directory.
4. Open the main APP (application > controller > gui > MainView.mlapp) and press RUN (or F5) using MATLAB's AppDesigner.

## File Structure
- **application:** This directory contains all the program files.
- **controller:** This directory includes both UI (User Interface) and GUI (Graphical User Interface) scripts and views.
- **model:**
  - **entities:** This directory contains the definitions of each type of element and geometrical entities.
  - **services:** This directory contains the solver, settings, and error message definitions.

## Bibliography
- KATTAN, Peter I. MATLAB guide to finite elements: an interactive approach. Springer Science & Business Media, 2010.
- KWON, Young W.; BANG, Hyochoong. The finite element method using MATLAB. CRC press, 2018.
- LOGAN, Daryl L. A first course in the finite element method. Thomson, 2011.
