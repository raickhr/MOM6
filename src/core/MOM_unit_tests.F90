!> Invokes unit tests in all modules that have them
module MOM_unit_tests

! This file is part of MOM6. See LICENSE.md for the license.

use MOM_error_handler,              only : MOM_error, FATAL, is_root_pe
use MOM_hor_bnd_diffusion,          only : near_boundary_unit_tests
use MOM_intrinsic_functions,        only : intrinsic_functions_unit_tests
use MOM_mixed_layer_restrat,        only : mixedlayer_restrat_unit_tests
use MOM_neutral_diffusion,          only : neutral_diffusion_unit_tests
use MOM_random,                     only : random_unit_tests
use MOM_remapping,                  only : remapping_unit_tests
use MOM_string_functions,           only : string_functions_unit_tests
use MOM_CFC_cap,                    only : CFC_cap_unit_tests
use MOM_EOS,                        only : EOS_unit_tests

implicit none ; private

public unit_tests

contains

!> Calls unit tests for other modules.
!! Note that if a unit test returns true, a FATAL error is triggered.
subroutine unit_tests(verbosity)
  ! Arguments
  integer, intent(in) :: verbosity !< The verbosity level
  ! Local variables
  logical :: verbose

  verbose = verbosity>=5

  if (is_root_pe()) then ! The following need only be tested on 1 PE
    if (string_functions_unit_tests(verbose)) call MOM_error(FATAL, &
       "MOM_unit_tests: string_functions_unit_tests FAILED")
    if (EOS_unit_tests(verbose)) call MOM_error(FATAL, &
       "MOM_unit_tests: EOS_unit_tests FAILED")
    if (remapping_unit_tests(verbose)) call MOM_error(FATAL, &
       "MOM_unit_tests: remapping_unit_tests FAILED")
    if (intrinsic_functions_unit_tests(verbose)) call MOM_error(FATAL, &
       "MOM_unit_tests: intrinsic_functions_unit_tests FAILED")
    if (neutral_diffusion_unit_tests(verbose)) call MOM_error(FATAL, &
       "MOM_unit_tests: neutralDiffusionUnitTests FAILED")
    if (random_unit_tests(verbose)) call MOM_error(FATAL, &
       "MOM_unit_tests: random_unit_tests FAILED")
    if (near_boundary_unit_tests(verbose)) call MOM_error(FATAL, &
       "MOM_unit_tests: near_boundary_unit_tests FAILED")
    if (CFC_cap_unit_tests(verbose)) call MOM_error(FATAL, &
       "MOM_unit_tests: CFC_cap_unit_tests FAILED")
    if (mixedlayer_restrat_unit_tests(verbose)) call MOM_error(FATAL, &
       "MOM_unit_tests: mixedlayer_restrat_unit_tests FAILED")
  endif

end subroutine unit_tests

end module MOM_unit_tests
