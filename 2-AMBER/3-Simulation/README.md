# Molecular Dynamics Simulations

## (1) Minimization on the solvent

The first step involves minimization on the solvent atoms with added position restraints on the solute (e.g. protein) molecule.

```
&cntrl
  imin   = 1,      ! perform minimization
  maxcyc = 1000,   ! perform 1000 steps of minimization
  ncyc   = 500,    ! first 500 cycles use steepest descent, and the last 500 cycles use conjugate descent
  ntb    = 1,      ! NVT
  ntr    = 1,      ! turn on restraints
  cut    = 10.0    ! non-bonded cutoff of 10.0 Angstroms
 /
Hold the DNA fixed ! Title
500.0              ! Force constant value (kcal/mol*Ang^-2)
RES 1 81           ! modify for the residue IDs of the protein
END
END
```

## (2) Minimization on the whole system

The second step is a minimization of the whole system (protein + solvent). The key difference between this step and the previous step is the lack of position restraints on the protein.

## (3) Heating

This step involves gradually increasing the temperature of the system from 0 K to 100 K. We also introduce weak restraints on the protein.

```
A6DNA Heating from 0 K to 300 K
 &cntrl
  imin   = 0,      ! Not a minimization run
  irest  = 0,      ! New simulation, don't read velocities
  ntx    = 1,      ! Only read the coordinates
  ntb    = 1,      ! NVT
  cut    = 10.0,   ! non-bonded cutoff of 10.0 Angstroms
  ntr    = 1,      ! turn on restraints
  ntc    = 2,      ! SHAKE constraints for bonds with hydrogen
  ntf    = 2,      ! forces on bonds with H - atoms are not evaluated
  tempi  = 0.0,    ! initial temperature
  temp0  = 300.0,  ! final temperature
  ntt    = 3,      ! weak - coupling algorithm for the temperature
  gamma_ln = 1.0,  ! 1 ps collision frequency gamma
  nstlim = 10000, dt = 0.002           ! 10000 MD-steps, 2 fs time-step
  ntpr = 100, ntwx = 100, ntwr = 1000  ! Number of steps "mdout", "mdinfo", "mdcrd", and "restart"
 /
Keep DNA fixed with weak restraints
10.0
RES 1 81
END
END
```

## (4) Equilibration at constant pressure

We then relax the positions of all the atoms. We use an NPT ensemble to also relax the density of the solvent.

```
 &cntrl
  imin = 0,       ! Not a minimization run
  irest = 1,      ! continue simulation from rst file
  ntx = 7,        ! coordinates and velocities of rst file is used
  ntb = 2,        ! NPT
  pres0 = 1.0,    ! Use constant pressure periodic boundary with an average pressure of 1 atm
  ntp = 1,        ! Use isotropic position scaling
  taup = 2.0,     ! 1 ps pressure relaxation time
  cut = 10.0,     ! non-bonded cutoff of 10.0 Angstroms
  ntr = 0,        ! no restraints
  ntc = 2,        ! SHAKE constraints for bonds with hydrogen
  ntf = 2,        ! forces on bonds with H - atoms are not evaluated
  tempi = 300.0,  ! temperature
  temp0 = 300.0,  ! temperature
  ntt = 3,        ! Langevin dynamics for temperature regulation
  gamma_ln = 1.0, ! 1 ps collision frequency gamma
  nstlim = 1000000, dt = 0.002,          ! 1000000 MD-steps, 2 fs time-step
  ntpr = 100, ntwx = 100, ntwr = 1000    ! Number of steps "mdout", "mdinfo", "mdcrd", and "restart"
 /
```

## (5) Production run

In the final step, we then perform a long (50 ns) MD simulation of the equilibrated system. The key difference between this step and the previous step is the longer nstlim.
