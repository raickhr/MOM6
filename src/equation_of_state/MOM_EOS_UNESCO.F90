!> The equation of state using the Jackett and McDougall fits to the UNESCO EOS
module MOM_EOS_UNESCO

! This file is part of MOM6. See LICENSE.md for the license.

use MOM_EOS_base_type, only : EOS_base

implicit none ; private

public UNESCO_EOS

!>@{ Parameters in the UNESCO equation of state, as published in appendix A3 of Gill, 1982.
! The following constants are used to calculate rho0, the density of seawater at 1 atmosphere pressure.
! The notation is Rab for the contribution to rho0 from S^a*T^b, with 6 used for the 1.5 power.
real, parameter :: R00 = 999.842594   ! A coefficient in the fit for rho0 [kg m-3]
real, parameter :: R01 = 6.793952e-2  ! A coefficient in the fit for rho0 [kg m-3 degC-1]
real, parameter :: R02 = -9.095290e-3 ! A coefficient in the fit for rho0 [kg m-3 degC-2]
real, parameter :: R03 = 1.001685e-4  ! A coefficient in the fit for rho0 [kg m-3 degC-3]
real, parameter :: R04 = -1.120083e-6 ! A coefficient in the fit for rho0 [kg m-3 degC-4]
real, parameter :: R05 = 6.536332e-9  ! A coefficient in the fit for rho0 [kg m-3 degC-5]
real, parameter :: R10 = 0.824493     ! A coefficient in the fit for rho0 [kg m-3 PSU-1]
real, parameter :: R11 = -4.0899e-3   ! A coefficient in the fit for rho0 [kg m-3 degC-1 PSU-1]
real, parameter :: R12 = 7.6438e-5    ! A coefficient in the fit for rho0 [kg m-3 degC-2 PSU-1]
real, parameter :: R13 = -8.2467e-7   ! A coefficient in the fit for rho0 [kg m-3 degC-3 PSU-1]
real, parameter :: R14 = 5.3875e-9    ! A coefficient in the fit for rho0 [kg m-3 degC-4 PSU-1]
real, parameter :: R60 = -5.72466e-3  ! A coefficient in the fit for rho0 [kg m-3 PSU-1.5]
real, parameter :: R61 = 1.0227e-4    ! A coefficient in the fit for rho0 [kg m-3 degC-1 PSU-1.5]
real, parameter :: R62 = -1.6546e-6   ! A coefficient in the fit for rho0 [kg m-3 degC-2 PSU-1.5]
real, parameter :: R20 = 4.8314e-4    ! A coefficient in the fit for rho0 [kg m-3 PSU-2]

! The following constants are used to calculate the secant bulk modulus.
! The notation here is Sabc for terms proportional to S^a*T^b*P^c, with 6 used for the 1.5 power.
!   Note that these values differ from those in Appendix 3 of Gill (1982) because the expressions
! from Jackett and MacDougall (1995) use potential temperature, rather than in situ temperature.
real, parameter :: S000 = 1.965933e4   ! A coefficient in the secant bulk modulus fit [bar]
real, parameter :: S010 = 1.444304e2   ! A coefficient in the secant bulk modulus fit [bar degC-1]
real, parameter :: S020 = -1.706103    ! A coefficient in the secant bulk modulus fit [bar degC-2]
real, parameter :: S030 = 9.648704e-3  ! A coefficient in the secant bulk modulus fit [bar degC-3]
real, parameter :: S040 = -4.190253e-5 ! A coefficient in the secant bulk modulus fit [bar degC-4]
real, parameter :: S100 = 52.84855     ! A coefficient in the secant bulk modulus fit [bar PSU-1]
real, parameter :: S110 = -3.101089e-1 ! A coefficient in the secant bulk modulus fit [bar degC-1 PSU-1]
real, parameter :: S120 = 6.283263e-3  ! A coefficient in the secant bulk modulus fit [bar degC-2 PSU-1]
real, parameter :: S130 = -5.084188e-5 ! A coefficient in the secant bulk modulus fit [bar degC-3 PSU-1]
real, parameter :: S600 = 3.886640e-1  ! A coefficient in the secant bulk modulus fit [bar PSU-1.5]
real, parameter :: S610 = 9.085835e-3  ! A coefficient in the secant bulk modulus fit [bar degC-1 PSU-1.5]
real, parameter :: S620 = -4.619924e-4 ! A coefficient in the secant bulk modulus fit [bar degC-2 PSU-1.5]

real, parameter :: S001 = 3.186519     ! A coefficient in the secant bulk modulus fit [nondim]
real, parameter :: S011 = 2.212276e-2  ! A coefficient in the secant bulk modulus fit [degC-1]
real, parameter :: S021 = -2.984642e-4 ! A coefficient in the secant bulk modulus fit [degC-2]
real, parameter :: S031 = 1.956415e-6  ! A coefficient in the secant bulk modulus fit [degC-3]
real, parameter :: S101 = 6.704388e-3  ! A coefficient in the secant bulk modulus fit [PSU-1]
real, parameter :: S111 = -1.847318e-4 ! A coefficient in the secant bulk modulus fit [degC-1 PSU-1]
real, parameter :: S121 = 2.059331e-7  ! A coefficient in the secant bulk modulus fit [degC-2 PSU-1]
real, parameter :: S601 = 1.480266e-4  ! A coefficient in the secant bulk modulus fit [PSU-1.5]

real, parameter :: S002 = 2.102898e-4  ! A coefficient in the secant bulk modulus fit [bar-1]
real, parameter :: S012 = -1.202016e-5 ! A coefficient in the secant bulk modulus fit [bar-1 degC-1]
real, parameter :: S022 = 1.394680e-7  ! A coefficient in the secant bulk modulus fit [bar-1 degC-2]
real, parameter :: S102 = -2.040237e-6 ! A coefficient in the secant bulk modulus fit [bar-1 PSU-1]
real, parameter :: S112 = 6.128773e-8  ! A coefficient in the secant bulk modulus fit [bar-1 degC-1 PSU-1]
real, parameter :: S122 = 6.207323e-10 ! A coefficient in the secant bulk modulus fit [bar-1 degC-2 PSU-1]
!>@}

!> The EOS_base implementation of the UNESCO equation of state
type, extends (EOS_base) :: UNESCO_EOS

contains
  !> Implementation of the in-situ density as an elemental function [kg m-3]
  procedure :: density_elem => density_elem_UNESCO
  !> Implementation of the in-situ density anomaly as an elemental function [kg m-3]
  procedure :: density_anomaly_elem => density_anomaly_elem_UNESCO
  !> Implementation of the in-situ specific volume as an elemental function [m3 kg-1]
  procedure :: spec_vol_elem => spec_vol_elem_UNESCO
  !> Implementation of the in-situ specific volume anomaly as an elemental function [m3 kg-1]
  procedure :: spec_vol_anomaly_elem => spec_vol_anomaly_elem_UNESCO
  !> Implementation of the calculation of derivatives of density
  procedure :: calculate_density_derivs_elem => calculate_density_derivs_elem_UNESCO
  !> Implementation of the calculation of second derivatives of density
  procedure :: calculate_density_second_derivs_elem => calculate_density_second_derivs_elem_UNESCO
  !> Implementation of the calculation of derivatives of specific volume
  procedure :: calculate_specvol_derivs_elem => calculate_specvol_derivs_elem_UNESCO
  !> Implementation of the calculation of compressibility
  procedure :: calculate_compress_elem => calculate_compress_elem_UNESCO
  !> Implementation of the range query function
  procedure :: EOS_fit_range => EOS_fit_range_UNESCO

end type UNESCO_EOS

contains

!> In situ density as fit by Jackett and McDougall, 1995 [kg m-3]
!!
!! This is an elemental function that can be applied to any combination of scalar and array inputs.
real elemental function density_elem_UNESCO(this, T, S, pressure)
  class(UNESCO_EOS), intent(in) :: this     !< This EOS
  real,              intent(in) :: T        !< Potential temperature relative to the surface [degC]
  real,              intent(in) :: S        !< Salinity [PSU]
  real,              intent(in) :: pressure !< Pressure [Pa]

  ! Local variables
  real :: t1   ! A copy of the temperature at a point [degC]
  real :: s1   ! A copy of the salinity at a point [PSU]
  real :: p1   ! Pressure converted to bars [bar]
  real :: s12  ! The square root of salinity [PSU1/2]
  real :: rho0 ! Density at 1 bar pressure [kg m-3]
  real :: sig0 ! The anomaly of rho0 from R00 [kg m-3]
  real :: ks   ! The secant bulk modulus [bar]

  p1 = pressure*1.0e-5 ; t1 = T
  s1 = max(S, 0.0) ; s12 = sqrt(s1)

  ! Compute rho(s,theta,p=0) - (same as rho(s,t_insitu,p=0) ).
  sig0 = ( t1*(R01 + t1*(R02 + t1*(R03 + t1*(R04 + t1*R05)))) + &
           s1*((R10 + t1*(R11 + t1*(R12 + t1*(R13 + t1*R14)))) + &
               (s12*(R60 + t1*(R61 + t1*R62)) + s1*R20)) )
  rho0 = R00 + sig0

  ! Compute rho(s,theta,p), first calculating the secant bulk modulus.
  ks = (S000 + ( t1*(S010 + t1*(S020 + t1*(S030 + t1*S040))) + &
                 s1*((S100 + t1*(S110 + t1*(S120 + t1*S130))) + s12*(S600 + t1*(S610 + t1*S620))) )) + &
       p1*( (S001 + ( t1*(S011 + t1*(S021 + t1*S031)) + &
                      s1*((S101 + t1*(S111 + t1*S121)) + s12*S601) )) + &
            p1*(S002 + ( t1*(S012 + t1*S022) + s1*(S102 + t1*(S112 + t1*S122)) )) )

  density_elem_UNESCO = rho0*ks / (ks - p1)

end function density_elem_UNESCO

!> In situ density anomaly as fit by Jackett and McDougall, 1995 [kg m-3]
!!
!! This is an elemental function that can be applied to any combination of scalar and array inputs.
real elemental function density_anomaly_elem_UNESCO(this, T, S, pressure, rho_ref)
  class(UNESCO_EOS), intent(in) :: this     !< This EOS
  real,              intent(in) :: T        !< Potential temperature relative to the surface [degC]
  real,              intent(in) :: S        !< Salinity [PSU]
  real,              intent(in) :: pressure !< Pressure [Pa]
  real,              intent(in) :: rho_ref  !< A reference density [kg m-3]

  ! Local variables
  real :: t1   ! A copy of the temperature at a point [degC]
  real :: s1   ! A copy of the salinity at a point [PSU]
  real :: p1   ! Pressure converted to bars [bar]
  real :: s12  ! The square root of salinity [PSU1/2]
  real :: rho0 ! Density at 1 bar pressure [kg m-3]
  real :: sig0 ! The anomaly of rho0 from R00 [kg m-3]
  real :: ks   ! The secant bulk modulus [bar]

  p1 = pressure*1.0e-5 ; t1 = T
  s1 = max(S, 0.0) ; s12 = sqrt(s1)

  ! Compute rho(s,theta,p=0) - (same as rho(s,t_insitu,p=0) ).
  sig0 = ( t1*(R01 + t1*(R02 + t1*(R03 + t1*(R04 + t1*R05)))) + &
           s1*((R10 + t1*(R11 + t1*(R12 + t1*(R13 + t1*R14)))) + &
               (s12*(R60 + t1*(R61 + t1*R62)) + s1*R20)) )
  rho0 = R00 + sig0

  ! Compute rho(s,theta,p), first calculating the secant bulk modulus.
  ks = (S000 + ( t1*(S010 + t1*(S020 + t1*(S030 + t1*S040))) + &
                 s1*((S100 + t1*(S110 + t1*(S120 + t1*S130))) + s12*(S600 + t1*(S610 + t1*S620))) )) + &
       p1*( (S001 + ( t1*(S011 + t1*(S021 + t1*S031)) + &
                      s1*((S101 + t1*(S111 + t1*S121)) + s12*S601) )) + &
            p1*(S002 + ( t1*(S012 + t1*S022) + s1*(S102 + t1*(S112 + t1*S122)) )) )

  density_anomaly_elem_UNESCO = ((R00 - rho_ref)*ks + (sig0*ks + p1*rho_ref)) / (ks - p1)

end function density_anomaly_elem_UNESCO

!> In situ specific volume as fit by Jackett and McDougall, 1995 [m3 kg-1]
!!
!! This is an elemental function that can be applied to any combination of scalar and array inputs.
real elemental function spec_vol_elem_UNESCO(this, T, S, pressure)
  class(UNESCO_EOS), intent(in) :: this    !< This EOS
  real,           intent(in) :: T        !< Potential temperature relative to the surface [degC]
  real,           intent(in) :: S        !< Salinity [PSU]
  real,           intent(in) :: pressure !< Pressure [Pa]

  ! Local variables
  real :: t1   ! A copy of the temperature at a point [degC]
  real :: s1   ! A copy of the salinity at a point [PSU]
  real :: p1   ! Pressure converted to bars [bar]
  real :: s12  ! The square root of salinity [PSU1/2]l553
  real :: rho0 ! Density at 1 bar pressure [kg m-3]
  real :: ks   ! The secant bulk modulus [bar]

  p1 = pressure*1.0e-5 ; t1 = T
  s1 = max(S, 0.0) ; s12 = sqrt(s1)

  ! Compute rho(s,theta,p=0), which is the same as rho(s,t_insitu,p=0).
  rho0 = R00 + ( t1*(R01 + t1*(R02 + t1*(R03 + t1*(R04 + t1*R05)))) + &
                 s1*((R10 + t1*(R11 + t1*(R12 + t1*(R13 + t1*R14)))) + &
                     (s12*(R60 + t1*(R61 + t1*R62)) + s1*R20)) )

  ! Compute rho(s,theta,p), first calculating the secant bulk modulus.
  ks = (S000 + ( t1*(S010 + t1*(S020 + t1*(S030 + t1*S040))) + &
                 s1*((S100 + t1*(S110 + t1*(S120 + t1*S130))) + s12*(S600 + t1*(S610 + t1*S620))) )) + &
       p1*( (S001 + ( t1*(S011 + t1*(S021 + t1*S031)) + &
                      s1*((S101 + t1*(S111 + t1*S121)) + s12*S601) )) + &
            p1*(S002 + ( t1*(S012 + t1*S022) + s1*(S102 + t1*(S112 + t1*S122)) )) )

  spec_vol_elem_UNESCO = (ks - p1) / (rho0*ks)

end function spec_vol_elem_UNESCO

!> In situ specific volume anomaly as fit by Jackett and McDougall, 1995 [m3 kg-1]
!!
!! This is an elemental function that can be applied to any combination of scalar and array inputs.
real elemental function spec_vol_anomaly_elem_UNESCO(this, T, S, pressure, spv_ref)
  class(UNESCO_EOS), intent(in) :: this    !< This EOS
  real,           intent(in) :: T        !< Potential temperature relative to the surface [degC]
  real,           intent(in) :: S        !< Salinity [PSU]
  real,           intent(in) :: pressure !< Pressure [Pa]
  real,           intent(in) :: spv_ref  !< A reference specific volume [m3 kg-1]

  ! Local variables
  real :: t1   ! A copy of the temperature at a point [degC]
  real :: s1   ! A copy of the salinity at a point [PSU]
  real :: p1   ! Pressure converted to bars [bar]
  real :: s12  ! The square root of salinity [PSU1/2]
  real :: rho0 ! Density at 1 bar pressure [kg m-3]
  real :: ks   ! The secant bulk modulus [bar]

  p1 = pressure*1.0e-5 ; t1 = T
  s1 = max(S, 0.0) ; s12 = sqrt(s1)

  ! Compute rho(s,theta,p=0), which is the same as rho(s,t_insitu,p=0).
  rho0 = R00 + ( t1*(R01 + t1*(R02 + t1*(R03 + t1*(R04 + t1*R05)))) + &
                 s1*((R10 + t1*(R11 + t1*(R12 + t1*(R13 + t1*R14)))) + &
                     (s12*(R60 + t1*(R61 + t1*R62)) + s1*R20)) )

  ! Compute rho(s,theta,p), first calculating the secant bulk modulus.
  ks = (S000 + ( t1*(S010 + t1*(S020 + t1*(S030 + t1*S040))) + &
                 s1*((S100 + t1*(S110 + t1*(S120 + t1*S130))) + s12*(S600 + t1*(S610 + t1*S620))) )) + &
       p1*( (S001 + ( t1*(S011 + t1*(S021 + t1*S031)) + &
                      s1*((S101 + t1*(S111 + t1*S121)) + s12*S601) )) + &
            p1*(S002 + ( t1*(S012 + t1*S022) + s1*(S102 + t1*(S112 + t1*S122)) )) )

  spec_vol_anomaly_elem_UNESCO = (ks*(1.0 - (rho0*spv_ref)) - p1) / (rho0*ks)

end function spec_vol_anomaly_elem_UNESCO

!> Calculate the partial derivatives of density with potential temperature and salinity
!! using the UNESCO (1981) equation of state, as refit by Jackett and McDougall (1995).
elemental subroutine calculate_density_derivs_elem_UNESCO(this, T, S, pressure, drho_dT, drho_dS)
  class(UNESCO_EOS), intent(in)  :: this     !< This EOS
  real,              intent(in)  :: T        !< Potential temperature relative to the surface [degC]
  real,              intent(in)  :: S        !< Salinity [PSU]
  real,              intent(in)  :: pressure !< Pressure [Pa]
  real,              intent(out) :: drho_dT  !< The partial derivative of density with potential
                                             !! temperature [kg m-3 degC-1]
  real,              intent(out) :: drho_dS  !< The partial derivative of density with salinity,
                                             !! in [kg m-3 PSU-1]
  ! Local variables
  real :: t1       ! A copy of the temperature at a point [degC]
  real :: s1       ! A copy of the salinity at a point [PSU]
  real :: p1       ! Pressure converted to bars [bar]
  real :: s12      ! The square root of salinity [PSU1/2]
  real :: rho0     ! Density at 1 bar pressure [kg m-3]
  real :: ks       ! The secant bulk modulus [bar]
  real :: drho0_dT ! Derivative of rho0 with T [kg m-3 degC-1]
  real :: drho0_dS ! Derivative of rho0 with S [kg m-3 PSU-1]
  real :: dks_dT   ! Derivative of ks with T [bar degC-1]
  real :: dks_dS   ! Derivative of ks with S [bar psu-1]
  real :: I_denom  ! 1.0 / (ks - p1) [bar-1]

  p1 = pressure*1.0e-5 ; t1 = T
  s1 = max(S, 0.0) ; s12 = sqrt(s1)

  ! Compute rho(s,theta,p=0) and its derivatives with temperature and salinity
  rho0 = R00 + ( t1*(R01 + t1*(R02 + t1*(R03 + t1*(R04 + t1*R05)))) + &
                 s1*((R10 + t1*(R11 + t1*(R12 + t1*(R13 + t1*R14)))) + &
                     (s12*(R60 + t1*(R61 + t1*R62)) + s1*R20)) )
  drho0_dT = R01 + ( t1*(2.0*R02 + t1*(3.0*R03 + t1*(4.0*R04 + t1*(5.0*R05)))) + &
                     s1*(R11 + (t1*(2.0*R12 + t1*(3.0*R13 + t1*(4.0*R14))) + &
                                s12*(R61 + t1*(2.0*R62)) )) )
  drho0_dS = R10 + ( t1*(R11 + t1*(R12 + t1*(R13 + t1*R14))) + &
                     (1.5*(s12*(R60 + t1*(R61 + t1*R62))) + s1*(2.0*R20)) )

  ! Compute the secant bulk modulus and its derivatives with temperature and salinity
  ks = ( S000 + (t1*(S010 + t1*(S020 + t1*(S030 + t1*S040))) + &
                 s1*((S100 + t1*(S110 + t1*(S120 + t1*S130))) + s12*(S600 + t1*(S610 + t1*S620)))) ) + &
       p1*( (S001 + ( t1*(S011 + t1*(S021 + t1*S031)) + &
                      s1*((S101 + t1*(S111 + t1*S121)) + s12*S601) )) + &
            p1*(S002 + ( t1*(S012 + t1*S022) + s1*(S102 + t1*(S112 + t1*S122)) )) )
  dks_dT = ( S010 + (t1*(2.0*S020 + t1*(3.0*S030 + t1*(4.0*S040))) + &
                     s1*((S110 + t1*(2.0*S120 + t1*(3.0*S130))) + s12*(S610 + t1*(2.0*S620)))) ) + &
           p1*(((S011 + t1*(2.0*S021 + t1*(3.0*S031))) + s1*(S111 + t1*(2.0*S121)) ) + &
               p1*(S012 + t1*(2.0*S022) + s1*(S112 + t1*(2.0*S122))) )
  dks_dS = ( S100 + (t1*(S110 + t1*(S120 + t1*S130)) + 1.5*(s12*(S600 + t1*(S610 + t1*S620)))) ) + &
           p1*((S101 + t1*(S111 + t1*S121) + s12*(1.5*S601)) + &
               p1*(S102 + t1*(S112 + t1*S122)) )

  I_denom = 1.0 / (ks - p1)
  drho_dT = (ks*drho0_dT - dks_dT*((rho0*p1)*I_denom)) * I_denom
  drho_dS = (ks*drho0_dS - dks_dS*((rho0*p1)*I_denom)) * I_denom

end subroutine calculate_density_derivs_elem_UNESCO

!> Calculate second derivatives of density with respect to temperature, salinity, and pressure,
!! using the UNESCO (1981) equation of state, as refit by Jackett and McDougall (1995)
elemental subroutine calculate_density_second_derivs_elem_UNESCO(this, T, S, pressure, &
                            drho_ds_ds, drho_ds_dt, drho_dt_dt, drho_ds_dp, drho_dt_dp)
  class(UNESCO_EOS), intent(in)    :: this !< This EOS
  real,              intent(in)    :: T !< Potential temperature referenced to 0 dbar [degC]
  real,              intent(in)    :: S !< Salinity [PSU]
  real,              intent(in)    :: pressure !< Pressure [Pa]
  real,              intent(inout) :: drho_ds_ds !< Partial derivative of beta with respect
                                                 !! to S [kg m-3 PSU-2]
  real,              intent(inout) :: drho_ds_dt !< Partial derivative of beta with respect
                                                 !! to T [kg m-3 PSU-1 degC-1]
  real,              intent(inout) :: drho_dt_dt !< Partial derivative of alpha with respect
                                                 !! to T [kg m-3 degC-2]
  real,              intent(inout) :: drho_ds_dp !< Partial derivative of beta with respect
                                                 !! to pressure [kg m-3 PSU-1 Pa-1] = [s2 m-2 PSU-1]
  real,              intent(inout) :: drho_dt_dp !< Partial derivative of alpha with respect
                                                 !! to pressure [kg m-3 degC-1 Pa-1] = [s2 m-2 degC-1]

  ! Local variables
  real :: t1          ! A copy of the temperature at a point [degC]
  real :: s1          ! A copy of the salinity at a point [PSU]
  real :: p1          ! Pressure converted to bars [bar]
  real :: s12         ! The square root of salinity [PSU1/2]
  real :: I_s12       ! The inverse of the square root of salinity [PSU-1/2]
  real :: rho0        ! Density at 1 bar pressure [kg m-3]
  real :: drho0_dT    ! Derivative of rho0 with T [kg m-3 degC-1]
  real :: drho0_dS    ! Derivative of rho0 with S [kg m-3 PSU-1]
  real :: d2rho0_dS2  ! Second derivative of rho0 with salinity [kg m-3 PSU-1]
  real :: d2rho0_dSdT ! Second derivative of rho0 with temperature and salinity [kg m-3 degC-1 PSU-1]
  real :: d2rho0_dT2  ! Second derivative of rho0 with temperature [kg m-3 degC-2]
  real :: ks          ! The secant bulk modulus [bar]
  real :: ks_0        ! The secant bulk modulus at zero pressure [bar]
  real :: ks_1        ! The linear pressure dependence of the secant bulk modulus at zero pressure [nondim]
  real :: ks_2        ! The quadratic pressure dependence of the secant bulk modulus at zero pressure [bar-1]
  real :: dks_dp      ! The derivative of the secant bulk modulus with pressure [nondim]
  real :: dks_dT      ! Derivative of the secant bulk modulus with temperature [bar degC-1]
  real :: dks_dS      ! Derivative of the secant bulk modulus with salinity [bar psu-1]
  real :: d2ks_dT2    ! Second derivative of the secant bulk modulus with temperature [bar degC-2]
  real :: d2ks_dSdT   ! Second derivative of the secant bulk modulus with salinity and temperature [bar psu-1 degC-1]
  real :: d2ks_dS2    ! Second derivative of the secant bulk modulus with salinity [bar psu-2]
  real :: d2ks_dSdp   ! Second derivative of the secant bulk modulus with salinity and pressure [psu-1]
  real :: d2ks_dTdp   ! Second derivative of the secant bulk modulus with temperature and pressure [degC-1]
  real :: I_denom     ! The inverse of the denominator of the expression for density [bar-1]

  p1 = pressure*1.0e-5 ; t1 = T
  s1 = max(S, 0.0) ; s12 = sqrt(s1)
  ! The UNESCO equation of state is a fit to density, but it chooses a form that exhibits a
  ! singularity in the second derivatives with salinity for fresh water.  To avoid this, the
  ! square root of salinity can be treated with a floor such that the contribution from the
  ! S**1.5 terms to both the surface density and the secant bulk modulus are lost to roundoff.
  ! This salinity is given by (~1e-16*S000/S600)**(2/3) ~= 3e-8 PSU, or S12 ~= 1.7e-4
  I_s12 = 1.0 / (max(s12, 1.0e-4))

  ! Calculate the density at sea level pressure and its derivatives
  rho0 = R00 + ( t1*(R01 + t1*(R02 + t1*(R03 + t1*(R04 + t1*R05)))) + &
                 s1*((R10 + t1*(R11 + t1*(R12 + t1*(R13 + t1*R14)))) + &
                     (s12*(R60 + t1*(R61 + t1*R62)) + s1*R20)) )
  drho0_dT = R01 + ( t1*(2.0*R02 + t1*(3.0*R03 + t1*(4.0*R04 + t1*(5.0*R05)))) + &
                     s1*(R11 + ( t1*(2.0*R12 + t1*(3.0*R13 + t1*(4.0*R14))) + &
                                 s12*(R61 + t1*(2.0*R62)) ) ) )
  drho0_dS = R10 + ( t1*(R11 + t1*(R12 + t1*(R13 + t1*R14))) + &
                     (1.5*(s12*(R60 + t1*(R61 + t1*R62))) + s1*(2.0*R20)) )
  d2rho0_dS2 = 0.75*(R60 + t1*(R61 + t1*R62))*I_s12 + 2.0*R20
  d2rho0_dSdT = R11 + ( t1*(2.0*R12 + t1*(3.0*R13 + t1*(4.0*R14))) + s12*(1.5*R61 + t1*(3.0*R62)) )
  d2rho0_dT2 = 2.0*R02 + ( t1*(6.0*R03 + t1*(12.0*R04 + t1*(20.0*R05))) + &
                           s1*((2.0*R12 + t1*(6.0*R13 + t1*(12.0*R14))) + s12*(2.0*R62)) )

  !  Calculate the secant bulk modulus and its derivatives
  ks_0 = S000 + ( t1*( S010 + t1*(S020 + t1*(S030 + t1*S040))) + &
                  s1*((S100 + t1*(S110 + t1*(S120 + t1*S130))) + s12*(S600 + t1*(S610 + t1*S620))) )
  ks_1 = S001 + ( t1*( S011 + t1*(S021 + t1*S031)) + &
                  s1*((S101 + t1*(S111 + t1*S121)) + s12*S601) )
  ks_2 = S002 + ( t1*( S012 + t1*S022) + s1*(S102 + t1*(S112 + t1*S122)) )

  ks = ks_0 + p1*(ks_1 + p1*ks_2)
  dks_dp = ks_1 + 2.0*p1*ks_2
  dks_dT = (S010 + ( t1*(2.0*S020 + t1*(3.0*S030 + t1*(4.0*S040))) + &
                     s1*((S110 + t1*(2.0*S120 + t1*(3.0*S130))) + s12*(S610 + t1*(2.0*S620))) )) + &
           p1*((S011 + t1*(2.0*S021 + t1*(3.0*S031)) + s1*(S111 + t1*(2.0*S121))) + &
               p1*(S012 + t1*(2.0*S022) + s1*(S112 + t1*(2.0*S122))))
  dks_dS = (S100 + ( t1*(S110 + t1*(S120 + t1*S130)) + 1.5*(s12*(S600 + t1*(S610 + t1*S620))) )) + &
           p1*((S101 + t1*(S111 + t1*S121) + s12*(1.5*S601)) + &
               p1*(S102 + t1*(S112 + t1*S122)))
  d2ks_dS2 = 0.75*((S600 + t1*(S610 + t1*S620)) + p1*S601)*I_s12
  d2ks_dSdT = (S110 + ( t1*(2.0*S120 + t1*(3.0*S130)) + s12*(1.5*S610 + t1*(3.0*S620)) )) + &
              p1*((S111 + t1*(2.0*S121)) +  p1*(S112 + t1*(2.0*S122)))
  d2ks_dT2 = 2.0*(S020 + ( t1*(3.0*S030 + t1*(6.0*S040)) + s1*((S120 + t1*(3.0*S130)) + s12*S620) )) + &
             2.0*p1*((S021 + (t1*(3.0*S031) + s1*S121)) + p1*(S022 + s1*S122))

  d2ks_dSdp = (S101 + (t1*(S111 + t1*S121) + s12*(1.5*S601))) + &
              2.0*p1*(S102 + t1*(S112 + t1*S122))
  d2ks_dTdp = (S011 + (t1*(2.0*S021 + t1*(3.0*S031)) + s1*(S111 + t1*(2.0*S121)))) + &
              2.0*p1*(S012 + t1*(2.0*S022) + s1*(S112 + t1*(2.0*S122)))
  I_denom = 1.0 / (ks - p1)

  ! Expressions for density and its first derivatives are copied here for reference:
  !   rho = rho0*ks * I_denom
  !   drho_dT = I_denom*(ks*drho0_dT - p1*rho0*I_denom*dks_dT)
  !   drho_dS = I_denom*(ks*drho0_dS - p1*rho0*I_denom*dks_dS)
  !   drho_dp = 1.0e-5 * (rho0 * I_denom**2) * (ks - dks_dp*p1)

  ! Finally calculate the second derivatives
  drho_dS_dS = I_denom * ( ks*d2rho0_dS2 - (p1*I_denom) * &
                    (2.0*drho0_dS*dks_dS + rho0*(d2ks_dS2 - 2.0*dks_dS**2*I_denom)) )
  drho_dS_dT = I_denom * (ks * d2rho0_dSdT - (p1*I_denom) * &
                      ((drho0_dT*dks_dS + drho0_dS*dks_dT) + &
                       rho0*(d2ks_dSdT - 2.0*(dks_dS*dks_dT)*I_denom)) )
  drho_dT_dT = I_denom * ( ks*d2rho0_dT2 - (p1*I_denom) * &
                    (2.0*drho0_dT*dks_dT + rho0*(d2ks_dT2 - 2.0*dks_dT**2*I_denom)) )

  ! The factor of 1.0e-5 is because pressure here is in bars, not Pa.
  drho_dS_dp = (1.0e-5 * I_denom**2) * ( (ks*drho0_dS - rho0*dks_dS) - &
                    p1*( (dks_dp*drho0_dS + rho0*d2ks_dSdp) - &
                         2.0*(rho0*dks_dS) * ((dks_dp - 1.0)*I_denom) ) )
  drho_dT_dp = (1.0e-5 * I_denom**2) * ( (ks*drho0_dT - rho0*dks_dT) - &
                    p1*( (dks_dp*drho0_dT + rho0*d2ks_dTdp) - &
                         2.0*(rho0*dks_dT) * ((dks_dp - 1.0)*I_denom) ) )

end subroutine calculate_density_second_derivs_elem_UNESCO

!> Calculate the partial derivatives of specific volume with temperature and salinity
!! using the UNESCO (1981) equation of state, as refit by Jackett and McDougall (1995).
elemental subroutine calculate_specvol_derivs_elem_UNESCO(this, T, S, pressure, dSV_dT, dSV_dS)
  class(UNESCO_EOS), intent(in)    :: this     !< This EOS
  real,              intent(in)    :: T        !< Potential temperature [degC]
  real,              intent(in)    :: S        !< Salinity [PSU]
  real,              intent(in)    :: pressure !< Pressure [Pa]
  real,              intent(inout) :: dSV_dT   !< The partial derivative of specific volume with
                                               !! potential temperature [m3 kg-1 degC-1]
  real,              intent(inout) :: dSV_dS   !< The partial derivative of specific volume with
                                               !! salinity [m3 kg-1 PSU-1]
  ! Local variables
  real :: t1       ! A copy of the temperature at a point [degC]
  real :: s1       ! A copy of the salinity at a point [PSU]
  real :: p1       ! Pressure converted to bars [bar]
  real :: s12      ! The square root of salinity [PSU1/2]
  real :: rho0     ! Density at 1 bar pressure [kg m-3]
  real :: ks       ! The secant bulk modulus [bar]
  real :: drho0_dT ! Derivative of rho0 with T [kg m-3 degC-1]
  real :: drho0_dS ! Derivative of rho0 with S [kg m-3 PSU-1]
  real :: dks_dT   ! Derivative of ks with T [bar degC-1]
  real :: dks_dS   ! Derivative of ks with S [bar psu-1]
  real :: I_denom2 ! 1.0 / (rho0*ks)**2 [m6 kg-2 bar-2]

  p1 = pressure*1.0e-5 ; t1 = T
  s1 = max(S, 0.0) ; s12 = sqrt(s1)

  ! Compute rho(s,theta,p=0) and its derivatives with temperature and salinity
  rho0 = R00 + ( t1*(R01 + t1*(R02 + t1*(R03 + t1*(R04 + t1*R05)))) + &
                 s1*((R10 + t1*(R11 + t1*(R12 + t1*(R13 + t1*R14)))) + &
                     (s12*(R60 + t1*(R61 + t1*R62)) + s1*R20)) )
  drho0_dT = R01 + ( t1*(2.0*R02 + t1*(3.0*R03 + t1*(4.0*R04 + t1*(5.0*R05)))) + &
                     s1*(R11 + (t1*(2.0*R12 + t1*(3.0*R13 + t1*(4.0*R14))) + &
                                s12*(R61 + t1*(2.0*R62)) )) )
  drho0_dS = R10 + ( t1*(R11 + t1*(R12 + t1*(R13 + t1*R14))) + &
                     (1.5*(s12*(R60 + t1*(R61 + t1*R62))) + s1*(2.0*R20)) )

  ! Compute the secant bulk modulus and its derivatives with temperature and salinity
  ks = ( S000 + (t1*(S010 + t1*(S020 + t1*(S030 + t1*S040))) + &
                 s1*((S100 + t1*(S110 + t1*(S120 + t1*S130))) + s12*(S600 + t1*(S610 + t1*S620)))) ) + &
       p1*( (S001 + ( t1*(S011 + t1*(S021 + t1*S031)) + &
                      s1*((S101 + t1*(S111 + t1*S121)) + s12*S601) )) + &
            p1*(S002 + ( t1*(S012 + t1*S022) + s1*(S102 + t1*(S112 + t1*S122)) )) )
  dks_dT = ( S010 + (t1*(2.0*S020 + t1*(3.0*S030 + t1*(4.0*S040))) + &
                     s1*((S110 + t1*(2.0*S120 + t1*(3.0*S130))) + s12*(S610 + t1*(2.0*S620)))) ) + &
           p1*(((S011 + t1*(2.0*S021 + t1*(3.0*S031))) + s1*(S111 + t1*(2.0*S121)) ) + &
               p1*(S012 + t1*(2.0*S022) + s1*(S112 + t1*(2.0*S122))) )
  dks_dS = ( S100 + (t1*(S110 + t1*(S120 + t1*S130)) + 1.5*(s12*(S600 + t1*(S610 + t1*S620)))) ) + &
           p1*((S101 + t1*(S111 + t1*S121) + s12*(1.5*S601)) + &
               p1*(S102 + t1*(S112 + t1*S122)) )

  ! specvol = (ks - p1) / (rho0*ks) = 1/rho0 - p1/(rho0*ks)
  I_denom2 = 1.0 / (rho0*ks)**2
  dSV_dT = ((p1*rho0)*dks_dT + ((p1 - ks)*ks)*drho0_dT) * I_denom2
  dSV_dS = ((p1*rho0)*dks_dS + ((p1 - ks)*ks)*drho0_dS) * I_denom2

end subroutine calculate_specvol_derivs_elem_UNESCO

!> Compute the in situ density of sea water (rho) and the compressibility (drho/dp == C_sound^-2)
!! at the given salinity, potential temperature and pressure using the UNESCO (1981)
!! equation of state, as refit by Jackett and McDougall (1995).
elemental subroutine calculate_compress_elem_UNESCO(this, T, S, pressure, rho, drho_dp)
  class(UNESCO_EOS), intent(in)  :: this     !< This EOS
  real,              intent(in)  :: T        !< Potential temperature relative to the surface [degC]
  real,              intent(in)  :: S        !< Salinity [PSU]
  real,              intent(in)  :: pressure !< Pressure [Pa]
  real,              intent(out) :: rho      !< In situ density [kg m-3]
  real,              intent(out) :: drho_dp  !< The partial derivative of density with pressure
                                             !! (also the inverse of the square of sound speed)
                                             !! [s2 m-2]
  ! Local variables
  real :: t1      ! A copy of the temperature at a point [degC]
  real :: s1      ! A copy of the salinity at a point [PSU]
  real :: p1      ! Pressure converted to bars [bar]
  real :: s12     ! The square root of salinity [PSU1/2]
  real :: rho0    ! Density at 1 bar pressure [kg m-3]
  real :: ks      ! The secant bulk modulus [bar]
  real :: ks_0    ! The secant bulk modulus at zero pressure [bar]
  real :: ks_1    ! The linear pressure dependence of the secant bulk modulus at zero pressure [nondim]
  real :: ks_2    ! The quadratic pressure dependence of the secant bulk modulus at zero pressure [bar-1]
  real :: dks_dp  ! The derivative of the secant bulk modulus with pressure [nondim]
  real :: I_denom  ! 1.0 / (ks - p1) [bar-1]

  p1 = pressure*1.0e-5 ; t1 = T
  s1 = max(S, 0.0) ; s12 = sqrt(s1)

  ! Compute rho(s,theta,p=0), which is the same as rho(s,t_insitu,p=0).

  rho0 = R00 + ( t1*(R01 + t1*(R02 + t1*(R03 + t1*(R04 + t1*R05)))) + &
                 s1*((R10 + t1*(R11 + t1*(R12 + t1*(R13 + t1*R14)))) + &
                     (s12*(R60 + t1*(R61 + t1*R62)) + s1*R20)) )

  ! Calculate the secant bulk modulus and its derivative with pressure.
  ks_0 = S000 + ( t1*( S010 + t1*(S020 + t1*(S030 + t1*S040))) + &
                  s1*((S100 + t1*(S110 + t1*(S120 + t1*S130))) + s12*(S600 + t1*(S610 + t1*S620))) )
  ks_1 = S001 + ( t1*( S011 + t1*(S021 + t1*S031)) + &
                  s1*((S101 + t1*(S111 + t1*S121)) + s12*S601) )
  ks_2 = S002 + ( t1*( S012 + t1*S022) + s1*(S102 + t1*(S112 + t1*S122)) )

  ks = ks_0 + p1*(ks_1 + p1*ks_2)
  dks_dp = ks_1 + 2.0*p1*ks_2
  I_denom = 1.0 / (ks - p1)

  ! Compute the in situ density, rho(s,theta,p), and its derivative with pressure.
  rho = rho0*ks * I_denom
  ! The factor of 1.0e-5 is because pressure here is in bars, not Pa.
  drho_dp = 1.0e-5 * ((rho0 * (ks - p1*dks_dp)) * I_denom**2)

end subroutine calculate_compress_elem_UNESCO

!> Return the range of temperatures, salinities and pressures for which Jackett and McDougall (1995)
!! refit the UNESCO equation of state has been fitted to observations.  Care should be taken when
!! applying this equation of state outside of its fit range.
subroutine EoS_fit_range_UNESCO(this, T_min, T_max, S_min, S_max, p_min, p_max)
  class(UNESCO_EOS), intent(in) :: this !< This EOS
  real, optional, intent(out) :: T_min !< The minimum potential temperature over which this EoS is fitted [degC]
  real, optional, intent(out) :: T_max !< The maximum potential temperature over which this EoS is fitted [degC]
  real, optional, intent(out) :: S_min !< The minimum practical salinity over which this EoS is fitted [PSU]
  real, optional, intent(out) :: S_max !< The maximum practical salinity over which this EoS is fitted [PSU]
  real, optional, intent(out) :: p_min !< The minimum pressure over which this EoS is fitted [Pa]
  real, optional, intent(out) :: p_max !< The maximum pressure over which this EoS is fitted [Pa]

  if (present(T_min)) T_min = -2.5
  if (present(T_max)) T_max = 40.0
  if (present(S_min)) S_min =  0.0
  if (present(S_max)) S_max = 42.0
  if (present(p_min)) p_min = 0.0
  if (present(p_max)) p_max = 1.0e8

end subroutine EoS_fit_range_UNESCO

!> \namespace mom_eos_UNESCO
!!
!! \section section_EOS_UNESCO UNESCO (Jackett & McDougall) equation of state
!!
!! The UNESCO (1981) equation of state is an internationally defined standard fit valid over the
!! range of pressures up to 10000 dbar, temperatures between the freezing point and 40 degC, and
!! salinities between 0 and 42 PSU.  Unfortunately, these expressions used in situ temperatures,
!! whereas ocean models (including MOM6) effectively use potential temperatures as their state
!! variables.  To avoid needing multiple conversions, Jackett and McDougall (1995) refit the
!! UNESCO equation of state to take potential temperature as a state variable, over the same
!! valid range and functional form as the original UNESCO expressions.  It is this refit from
!! Jackett and McDougall (1995) that is coded up in this module.
!!
!! The functional form of the equation of state includes terms proportional to salinity to the
!! 3/2 power.  This introduces a singularity in the second derivative of density with salinity
!! at a salinity of 0, but this has been addressed here by setting a floor of 1e-8 PSU on the
!! salinity that is used in the denominator of these second derivative expressions.  This value
!! was chosen to imply a contribution that is smaller than numerical roundoff in the expression
!! for density, which is the field for which the UNESCO equation of state was originally derived.
!!
!! Originally coded in 1999 by J. Stephens, revised in 2023 to unambiguously specify the order
!! of arithmetic with parenthesis in every real sum of three or more terms.
!!
!! \subsection section_EOS_UNESCO_references References
!!
!! Gill, A. E., 1982: Atmosphere-Ocean Dynamics. Academic Press, 662 pp.
!!
!! Jackett, D. and T. McDougall, 1995: Minimal adjustment of hydrographic profiles to
!!     achieve static stability.  J. Atmos. Ocean. Tech., 12, 381-389.
!!
!! UNESCO, 1981: Tenth report of the joint panel on oceanographic tables and standards.
!!    UNESCO Technical Papers in Marine Sci. No. 36, UNESCO, Paris.

end module MOM_EOS_UNESCO
