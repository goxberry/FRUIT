!------------------------
! FORTRAN unit test utility
!
! Author: Andrew H. Chen meihome @at@ gmail.com
!------------------------
!
! Unit test framework for FORTRAN.  (FoRtran UnIT)
!
! This package is to perform unit test for FORTRAN subroutines
!
! The method used most is: call assertTrue (logical [, message])
!
!
!
module fruit
  use fruit_util

  integer, parameter :: MSG_LENGTH = 1500
  integer, parameter :: MSG_STACK_SIZE = 300000

  integer, private, save :: successful_assert_count = 0
  integer, private, save :: failed_assert_count = 0
  character (len = MSG_LENGTH), private, dimension (MSG_STACK_SIZE), save :: messageArray
  character (len = MSG_LENGTH), private, save :: msg = '[unit name not set from set_name]: '
  character (len = MSG_LENGTH), save :: unit_name  = '_not_set_'
  integer, private, save :: messageIndex = 1

  integer, private, save :: successful_case_count = 0
  integer, private, save :: failed_case_count = 0
  integer, private, save :: testCaseIndex = 1
  logical, private, save :: last_case_passed = .false.

  interface init_fruit
     module procedure init_fruit_
  end interface

  interface initializeFruit
     module procedure initializa_fruit_obsolete_
  end interface

  interface fruit_summary
     module procedure fruit_summary_
  end interface

  interface getTestSummary
     module procedure getTestSummary_obsolete_  
  end interface

  interface assertTrue
     module procedure assert_true_logical_
  end interface

  interface get_last_message
     module procedure get_last_message_
  end interface

  interface assertEquals
     module procedure assert_equals_int_
     module procedure assert_equals_double_
     module procedure assert_equals_real_
     module procedure assert_equals_logical_
     module procedure assert_equals_string_
     module procedure assert_equals_real_difference_
     module procedure assert_equals_double_difference_

     module procedure assert_equals_1darray_int_
     module procedure assert_equals_1darray_double_
     module procedure assert_equals_1d_array_real_
     module procedure assert_equals_1darray_string_
     module procedure assert_equals_1darray_complex_

     module procedure assert_equals_2d_array_int_
     module procedure assert_equals_2darray_double_
     module procedure assert_equals_2darray_real_
     module procedure assert_equals_2darray_complex_

     module procedure assert_equals_spArr_spArr_int_sp_
     module procedure assert_equals_dpArr_dpArr_int_dp_
  end interface

  interface assertNotEquals
     module procedure assert_not_equals_real_
     module procedure assert_not_equals_1d_array_real_
     module procedure assert_not_equals_double_
  end interface

  interface addSuccess
     module procedure add_success_
     module procedure add_success_unit_
  end interface

  interface addFail
     module procedure add_fail_
     module procedure add_fail_unit_
  end interface

  interface set_unit_name
     module procedure set_unit_name_
  end interface

  interface get_unit_name
     module procedure get_unit_name_
  end interface

  interface getTotalCount
     module procedure getTotalCount_obsolete_
  end interface

  interface get_total_count
     module procedure get_total_count_
  end interface

  interface getFailedCount
     module procedure getFailedCount_obsolete_
  end interface

  interface get_failed_count
     module procedure get_failed_count_
  end interface

  interface success_assert_action
     module procedure success_assert_action_
  end interface

  interface failed_assert_action
     module procedure failed_assert_action_
  end interface

  interface isAllSuccessful
     module procedure isAllSuccessful_
  end interface

  interface is_all_successful
     module procedure is_all_successful_
  end interface

  !  interface addTestCase
  !    module procedure addTestCase
  !  end interface

  !  interface addCaseResult
  !    module procedure addCaseResult
  !  end interface

  !  interface getTotalTestCount
  !    module procedure getTotalTestCount
  !  end interface

  !  interface getTotalFailedTestCount
  !    module procedure getTotalFailedTestCount
  !  end interface

  !  interface getTestCases
  !    module procedure getTestCases
  !  end interface

  !  interface getTestCaseResults
  !    module procedure getTestCaseResults
  !  end interface

  private :: &
       init_fruit_, initializa_fruit_obsolete_, &
       fruit_summary_, getTestSummary_obsolete_, &
       get_last_message_, obsolete_, &
       get_total_count_, getTotalCount_obsolete_,&
       get_failed_count_, getFailedCount_obsolete_, &
       assertTrue_single, assertTrue_result, &
       add_success, &
       add_fail_, add_fail_unit_, increase_message_stack_, &
       success_assert_action_, failed_assert_action_, success_mark_, failed_mark_, &
       assert_not_equals_real_, &
       assert_not_equals_double_, &
       assert_not_equals_1d_array_real_, &
       assert_equals_int_, &
       assert_equals_double_, &
       assert_equals_real_, &
       assert_equals_logical_, &
       assert_equals_string_, &
       assert_equals_real_difference_, &
       assert_equals_double_difference_, &
       assert_equals_1darray_int_, &
       assert_equals_1darray_double_, &
       assert_equals_1d_array_real_, &
       assert_equals_1darray_string_, &
       assert_equals_1darray_complex_, &
       assert_equals_2d_array_int_, &
       assert_equals_2darray_double_, &
       assert_equals_2darray_real_, &
       assert_equals_2darray_complex_, &
       assert_equals_spArr_spArr_int_sp_, &
       assert_equals_dpArr_dpArr_int_dp_, &
       add_success_, add_success_unit_,&
       is_all_successful_, isAllSuccessful_, &
       set_unit_name_, get_unit_name_ 

contains

  subroutine init_fruit_
    successful_assert_count = 0
    failed_assert_count = 0
    messageIndex = 1
    write (*,*)
    write (*,*) "Test module initialized"
    write (*,*)
    write (*,*) "   . : successful assert,   F : failed assert "
    write (*,*)
  end subroutine init_fruit_

  subroutine initializa_fruit_obsolete_
    call obsolete_ ("initializeFruit is OBSOLETE.  replaced by init_fruit")
    call init_fruit
  end subroutine initializa_fruit_obsolete_

  subroutine getTestSummary_obsolete_
    call obsolete_ ( "getTestSummary is OBSOLETE.  replaced by fruit_summary")
    call fruit_summary
  end subroutine getTestSummary_obsolete_

  subroutine fruit_summary_
    implicit none

    integer :: i

    write (*,*)
    write (*,*)
    write (*,*) '    Start of FRUIT summary: '
    write (*,*)

    if (failed_assert_count > 0) then
       write (*,*) 'Some tests failed!'
    else
       write (*,*) 'SUCCESSFUL!'
    end if

    write (*,*)
    if ( messageIndex > 1) then
       write (*,*) '  -- Failed assertion messages:'

       do i = 1, messageIndex - 1
          write (*,"(A)") trim(strip(messageArray(i)))
       end do

       write (*,*) '  -- end of failed assertion messages.'
       write (*,*)
    else
       write (*,*) '  No messages '
    end if

    if (successful_assert_count + failed_assert_count /= 0) then

       write (*,*) 'Total asserts :   ', successful_assert_count + failed_assert_count
       write (*,*) 'Successful    :   ', successful_assert_count
       write (*,*) 'Failed        :   ', failed_assert_count
       write (*,'("Successful rate:   ",f6.2,"%")')  real(successful_assert_count) * 100.0 / &
            real (successful_assert_count + failed_assert_count)
       write (*, *)
       write (*,*) 'Successful asserts / total asserts : [ ',&
            successful_assert_count, '/', successful_assert_count + failed_assert_count, ' ]'
       write (*,*) 'Successful cases    / total cases  : [ ', successful_case_count, '/', &
            successful_case_count + failed_case_count, ' ]'
       write (*, *) '  -- end of FRUIT summary'

    end if
  end subroutine fruit_summary_

  subroutine add_success_ (message)
    implicit none
    character (*), intent (in), optional :: message

    if (present(message)) then
       call increase_message_stack_(message)
    end if
    call success_assert_action_
  end subroutine add_success_

  subroutine add_success_unit_ (unitName, message)
    character (*), intent (in) :: unitName
    character (*), intent (in) :: message
    call add_success_ (strip(message) // "[in " //  unitName // "(ok)] ")
  end subroutine add_success_unit_

  subroutine add_fail_ (message)
    character (*), intent (in), optional :: message
    if (present(message)) then
       call increase_message_stack_(message)
    end if
    call failed_assert_action_
  end subroutine add_fail_

  subroutine add_fail_unit_ (unitName, message)
    character (*), intent (in) :: unitName
    character (*), intent (in) :: message

    call add_fail_ ("[in " //  unitName // "(fail)]: " //  message)
  end subroutine add_fail_unit_

  subroutine isAllSuccessful_(result)
    implicit none
    logical, intent(out) :: result
    call obsolete_ ('subroutine isAllSuccessful is changed to function is_all_successful.')
    result = (failed_assert_count .eq. 0 )
  end subroutine isAllSuccessful_

  subroutine is_all_successful_(result)
    implicit none
    logical, intent(out) :: result
    result= (failed_assert_count .eq. 0 )
  end subroutine is_all_successful_

  subroutine success_mark_
    write(*,"(A1)",ADVANCE='NO') '.'
  end subroutine success_mark_

  subroutine failed_mark_
    write(*,"(A1)",ADVANCE='NO') 'F'
  end subroutine failed_mark_

  subroutine increase_message_stack_ (message)
    character(*), intent (in) :: message

    if (messageIndex > MSG_STACK_SIZE ) then
       write (*, *) "Too many errors to put into stack"
       call getTestSummary ()
       stop 1
    end if

    messageArray (messageIndex) = strip(message)
    messageIndex = messageIndex + 1
  end subroutine increase_message_stack_

  function get_last_message_
    character(len=MSG_LENGTH) :: get_last_message_
    if (messageIndex > 1) then
       get_last_message_ = strip(messageArray(messageIndex-1))
    else
       get_last_message_ = ''
    end if
  end function get_last_message_

  subroutine getTotalCount_obsolete_ (count)
    implicit none
    integer, intent (out) :: count
    call obsolete_ (' getTotalCount subroutine is replaced by function get_total_count')
    call get_total_count_(count)
  end subroutine getTotalCount_obsolete_

  subroutine get_total_count_(count) 
    implicit none
    integer, intent(out) :: count

    count = successful_assert_count + failed_assert_count
  end subroutine get_total_count_

  subroutine getFailedCount_obsolete_ (count)
    implicit none
    integer, intent (out) :: count

    call obsolete_ (' getFailedCount subroutine is replaced by function get_failed_count')
    call get_failed_count_ (count)

  end subroutine getFailedCount_obsolete_

  subroutine get_failed_count_ (count)
    implicit none
    integer, intent(out) :: count
    count = failed_assert_count
  end subroutine get_failed_count_

  subroutine obsolete_ (message)
    character (*), intent (in), optional :: message
    write (*,*) "start: ---!!!--------WARNING from FRUIT------!!!----"
    write (*,*) message
    write (*,*) "--- old calls will be replaced in the next release ----"
    write (*,*) "end: ---!!!--------WARNING from FRUIT------!!!----"
  end subroutine obsolete_

  subroutine success_assert_action_
    successful_assert_count = successful_assert_count + 1
    last_case_passed = .true.
    call success_mark_  
  end subroutine success_assert_action_

  subroutine failed_assert_action_
    call set_unit_name_in_msg__
    failed_assert_count = failed_assert_count + 1
    last_case_passed = .false.
    call failed_mark_
  end subroutine failed_assert_action_

  subroutine set_unit_name_(value)
    character(*), intent(in) :: value
    unit_name = strip(value)
  end subroutine set_unit_name_

  subroutine get_unit_name_(value)
    character(*), intent(out) :: value
    value = strip(unit_name)
  end subroutine get_unit_name_

  subroutine set_unit_name_in_msg__
    msg = 'in [' // unit_name // ']: '
  end subroutine set_unit_name_in_msg__

  subroutine make_error_msg__ (var1, var2, message)
    character(*), intent(in) :: var1, var2
    character(*), intent(in), optional :: message
    if (present(message)) then
       msg = '[' // trim(strip(unit_name)) // ']: Expected [' // trim(strip(var1)) // '], Got [' // trim(strip(var2)) // ']; '// &
            ' User message: [' // message // ']'
    else
       msg = '[' // trim(strip(unit_name)) // ']: Expected [' // trim(strip(var1)) // '], Got [' // trim(strip(var2)) // ']; ' 
    endif
  end subroutine make_error_msg__

  !--------------------------------------------------------------------------------
  ! all assertions
  !--------------------------------------------------------------------------------
  subroutine assert_equals_int_ (var1, var2, message)
    implicit none
    integer, intent(in) :: var1, var2
    character (*), intent(in), optional :: message

    if ( var1 .eq. var2) then
       call success_assert_action_
    else
       call failed_assert_action_
       call make_error_msg__ (to_s(var1), to_s(var2), message)
       call increase_message_stack_(msg)
    end if
  end subroutine assert_equals_int_

  subroutine assert_true_logical_ (var1, message)
    implicit none
    logical, intent (in) :: var1
    character (*), intent (in), optional :: message

    if ( var1 .eqv. .true.) then
       call success_assert_action_
    else
       call failed_assert_action_
       write(msg, '(A, L1)') 'Expected T got ', .false.
       if (present(message)) then
          write (msg, '(A)') strip(message) // ' (' // strip(msg) // ')'
       endif
       call increase_message_stack_(strip(msg))
    end if
  end subroutine assert_true_logical_

  subroutine assert_equals_string_ (var1, var2, message)
    implicit none
    character(*), intent (in)  :: var1, var2
    character (*), intent (in), optional :: message

    if ( strip( var1) == strip( var2)) then
       call success_assert_action_
    else
       call failed_assert_action_
       if (present(message)) then
          call increase_message_stack_(strip(message) // ' (Expected ' // strip(var1) // ' got ' // strip(var2) // ')')
       else
          call increase_message_stack_(' (Expected ' // strip(var1) // ' got ' // strip(var2) // ')')
       end if
    end if
  end subroutine assert_equals_string_

  subroutine assert_equals_logical_ (var1, var2, message)
    implicit none
    logical, intent (in)  :: var1, var2
    character (*), intent (in), optional :: message

    if ( var1 .eqv. var2 ) then
       call success_assert_action_
    else
       call failed_assert_action_
       if (present(message)) then
          write(msg, '(A, L1, A, L1)') 'Expected ', var1, ' got ', var2
       endif
       call increase_message_stack_(strip(message) // ' (' // strip(msg) // ')')
    end if
  end subroutine assert_equals_logical_

  subroutine assert_equals_real_ (var1, var2, message)
    implicit none
    real, intent (in) :: var1, var2
    character (*), intent (in), optional :: message

    if ( var1 .eq. var2) then
       call success_assert_action_
    else
       if (present(message)) then
          call increase_message_stack_(message)
       end if
       call failed_assert_action_
    end if
  end subroutine assert_equals_real_

  subroutine assert_not_equals_real_ (var1, var2, message)
    implicit none
    real, intent (in) :: var1, var2
    character (*), intent (in), optional :: message

    if ( var1 .ne. var2) then
       call success_assert_action_
    else
       if (present(message)) then
          call increase_message_stack_(message)
       end if
       call failed_assert_action_
    end if
  end subroutine assert_not_equals_real_

  subroutine assert_not_equals_1d_array_real_ (var1, var2, n)
    implicit none
    integer, intent (in) :: n
    real, intent (in) :: var1(n), var2(n)

    integer count

    loop_dim1: do count = 1, n
       if ( var1(count) .ne. var2(count)) then
          call failed_assert_action_
          return
       end if
    end do loop_dim1

    call success_assert_action_

  end subroutine assert_not_equals_1d_array_real_

  subroutine assert_equals_2darray_real (var1, var2, n, m)
    implicit none
    integer, intent (in) :: n, m
    real, intent (in) :: var1(n,m), var2(n,m)

    integer count1, count2

    loop_dim2: do count2 = 1, m
       loop_dim1: do count1 = 1, n
          if ( var1(count1,count2) .ne. var2(count1,count2)) then
             call failed_assert_action
             return
          end if
       end do loop_dim1
    end do loop_dim2

    call success_assert_action_

  end subroutine assert_equals_2darray_real

  subroutine assert_equals_real_difference_(var1, var2, var3, message)
    implicit none
    real, intent (in) :: var1, var2, var3
    character(*), intent(in), optional :: message

    if ( abs( var1 - var2) .le. var3) then
       call success_assert_action_
    else
       call failed_assert_action
       if (present(message)) then
          call increase_message_stack_(message)
       end if
    end if

  end subroutine assert_equals_real_difference_

  subroutine assert_equals_spArr_spArr_int_sp_(var1, var2, n, var3, message)
    implicit none
    integer, intent(in) :: n
    real, intent (in) :: var1(n), var2(n), var3
    character(*), intent(in), optional :: message

    if ( maxval( abs( var1 - var2)) .le. var3) then
       call success_assert_action_
    else
       call failed_assert_action_
       if (present(message)) then
          call increase_message_stack_(message)
       end if
    end if
  end subroutine assert_equals_spArr_spArr_int_sp_

  subroutine assert_equals_dpArr_dpArr_int_dp_(var1, var2, n, var3, message)
    implicit none
    integer, intent(in) :: n
    double precision, intent (in) :: var1(n), var2(n), var3
    character(*), intent(in), optional :: message

    if ( maxval( abs( var1 - var2)) .le. var3) then
       call success_assert_action_
    else
       call failed_assert_action_
       if (present(message)) then
          call increase_message_stack_(message)
       end if
    end if
  end subroutine assert_equals_dpArr_dpArr_int_dp_

  subroutine assert_equals_double_difference_(var1, var2, var3, message)
    implicit none
    double precision, intent (in) :: var1, var2, var3
    character(*), intent(in), optional :: message

    if ( abs( var1 - var2) .le. var3) then
       call success_assert_action_
    else
       call failed_assert_action_
       if (present(message)) then
          call increase_message_stack_(message)
       end if
    end if
  end subroutine assert_equals_double_difference_

  subroutine assert_equals_double (var1, var2, message)
    implicit none
    double precision, intent (in) :: var1, var2
    character(*), intent(in), optional :: message

    if ( var1 .eq. var2) then
       call success_assert_action_
    else
       call failed_assert_action_
       if (present(message)) then
          call increase_message_stack_(message)
       end if
    end if
  end subroutine assert_equals_double

  subroutine assert_not_equals_double_ (var1, var2, message)
    implicit none
    double precision, intent (in) :: var1, var2
    character(*), intent(in), optional :: message

    if ( var1 .ne. var2) then
       call success_assert_action_
    else
       call failed_assert_action_
       if (present(message)) then
          call increase_message_stack_(message)
       end if
    end if
  end subroutine assert_not_equals_double_

  subroutine assert_equals_1darray_double (var1, var2, n)
    implicit none
    integer, intent (in) :: n
    double precision, intent (in) :: var1(n), var2(n)

    integer count

    loop_dim1: do count = 1, n
       if ( var1(count) .ne. var2(count)) then
          call failed_assert_action_
          return
       end if
    end do loop_dim1

    call success_assert_action_
  end subroutine assert_equals_1darray_double

  subroutine assert_equals_2darray_double (var1, var2, n, m)
    implicit none
    integer, intent (in) :: n, m
    double precision, intent (in) :: var1(n,m), var2(n,m)

    integer count1, count2

    loop_dim2: do count2 = 1, m
       loop_dim1: do count1 = 1, n
          if ( var1(count1,count2) .ne. var2(count1,count2)) then
             call failed_assert_action_
             return
          end if
       end do loop_dim1
    end do loop_dim2

    call success_assert_action_
  end subroutine assert_equals_2darray_double

  subroutine assert_equals_1darray_int_ (var1, var2, n, message)
    implicit none
    integer, intent (in) :: n
    integer, intent (in) :: var1(n), var2(n)
    character (*), intent (in), optional :: message

    integer count

    loop_dim1: do count = 1, n
       if ( var1(count) .ne. var2(count)) then
          call failed_assert_action_
          if (present(message)) then
             call increase_message_stack_(message)
          endif
          return
       end if
    end do loop_dim1

    call success_assert_action_
  end subroutine assert_equals_1darray_int_

  subroutine assert_equals_1darray_string_ (var1, var2, n, message)
    implicit none
    integer, intent (in) :: n
    character(*), intent (in) :: var1(n), var2(n)
    character (*), intent (in), optional :: message
    integer count

    loop_dim1: do count = 1, n
       if ( strip(var1(count)) .ne. strip(var2(count))) then
          if (present(message)) then
             call increase_message_stack_(message)
          end if

          write (msg,'(I5)') count
          msg = 'error at count: ' // strip(msg)  
          msg = msg // 'expected value: ' // strip(var1(count))
          msg = msg // 'got value: ' // strip(var2(count))

          call increase_message_stack_(msg)
          call failed_assert_action_
          return
       end if
    end do loop_dim1

    call success_assert_action_
  end subroutine assert_equals_1darray_string_

  subroutine assert_equals_2d_array_int_ (var1, var2, n, m, message)
    implicit none
    integer, intent (in) :: n, m
    integer, intent (in) :: var1(n,m), var2(n,m)
    character (*), intent (in), optional :: message

    integer count1, count2

    loop_dim2: do count2 = 1, m
       loop_dim1: do count1 = 1, n
          if ( var1(count1,count2) .ne. var2(count1,count2)) then
             if (present(message)) then
                call increase_message_stack_(message)
             end if
             call failed_assert_action_
             return
          end if
       end do loop_dim1
    end do loop_dim2

    call success_assert_action_
  end subroutine assert_equals_2d_array_int_

  subroutine assert_equals_1d_array_real_ (var1, var2, n, message)
    implicit none
    integer, intent (in) :: n
    real, intent (in) :: var1(n), var2(n)
    character (*), intent (in), optional :: message

    integer count

    loop_dim1: do count = 1, n
       if ( var1(count) .ne. var2(count)) then
          if (present(message)) then
             call increase_message_stack_(message)
          end if
          call failed_assert_action_
          return
       end if
    end do loop_dim1
    call success_assert_action_
  end subroutine assert_equals_1d_array_real_

  subroutine assert_equals_2darray_real_ (var1, var2, n, m, message)
    implicit none
    integer, intent (in) :: n, m
    real, intent (in) :: var1(n,m), var2(n,m)
    character (*), intent(in), optional :: message

    integer count1, count2

    loop_dim2: do count2 = 1, m
       loop_dim1: do count1 = 1, n
          if ( var1(count1,count2) .ne. var2(count1,count2)) then
             if (present(message)) then
                call increase_message_stack_(message)
             end if
             call failed_assert_action_
             return
          end if
       end do loop_dim1
    end do loop_dim2

    call success_assert_action_
  end subroutine assert_equals_2darray_real_

  subroutine assert_equals_double_ (var1, var2, message)
    implicit none
    double precision, intent (in) :: var1, var2
    character (*), intent (in) :: message

    if ( var1 .eq. var2) then
       call success_assert_action_
    else
       call failed_assert_action_
    end if
  end subroutine assert_equals_double_

  subroutine assert_equals_1darray_double_ (var1, var2, n, message)
    implicit none
    integer, intent (in) :: n
    double precision, intent (in) :: var1(n), var2(n)
    character (*), intent (in), optional :: message
    integer count

    loop_dim1: do count = 1, n
       if ( var1(count) .ne. var2(count)) then
          if (present(message)) then             
             call increase_message_stack_(message)
          end if
          call failed_assert_action_
          return
       end if
    end do loop_dim1

    call success_assert_action_
  end subroutine assert_equals_1darray_double_

  subroutine assert_equals_2darray_double_ (var1, var2, n, m, message)
    implicit none
    integer, intent (in) :: n, m
    double precision, intent (in) :: var1(n,m), var2(n,m)
    character (*), intent (in), optional :: message
    integer count1, count2

    loop_dim2: do count2 = 1, m
       loop_dim1: do count1 = 1, n
          if ( var1(count1,count2) .ne. var2(count1,count2)) then
             if (present(message)) then             
                call increase_message_stack_(message)
             end if
             call failed_assert_action_
             return
          end if
       end do loop_dim1
    end do loop_dim2

    call success_assert_action_
  end subroutine assert_equals_2darray_double_

  subroutine assert_equals_1darray_complex (var1, var2, n, message)
    implicit none
    integer,          intent(IN) :: n
    double complex,   intent(IN) :: var1(n), var2(n)
    character (*),    intent(IN), optional :: message
    integer count

    loop_dim1: do count = 1, n
       if ( var1(count) .ne. var2(count)) then
          if (present(message)) then             
             call increase_message_stack_(message)
          end if
          call failed_assert_action_
          return
       end if
    enddo loop_dim1

    call success_assert_action_
  end subroutine assert_equals_1darray_complex

  subroutine assert_equals_1darray_complex_ (var1, var2, n, message)
    implicit none
    integer,          intent(IN) :: n
    double complex,   intent(IN) :: var1(n), var2(n)
    character (*),    intent(IN), optional :: message
    integer count

    loop_dim1: do count = 1, n
       if ( var1(count) .ne. var2(count)) then
          if (present(message)) then             
             call increase_message_stack_(message)
          end if
          call failed_assert_action_
          return
       end if
    enddo loop_dim1

    call success_assert_action_
  end subroutine assert_equals_1darray_complex_

  subroutine assert_equals_2darray_complex (var1, var2, n, m, message)
    implicit none
    integer,        intent(IN) :: n, m
    double complex, intent(IN) :: var1(n,m), var2(n,m)
    character (*),    intent(IN), optional :: message
    integer count1, count2

    loop_dim2: do count2 = 1, m
       loop_dim1: do count1 = 1, n
          if ( var1(count1,count2) .ne. var2(count1,count2)) then
             if (present(message)) then             
                call increase_message_stack_(message)
             end if
             call failed_assert_action_
             return
          endif
       enddo loop_dim1
    enddo loop_dim2

    call success_assert_action_
  end subroutine assert_equals_2darray_complex

  subroutine assert_equals_2darray_complex_ (var1, var2, n, m, message)
    implicit none
    integer,          intent(IN) :: n, m
    double complex,   intent(IN) :: var1(n,m), var2(n,m)
    character (*),    intent(IN), optional :: message

    integer count1, count2

    loop_dim2: do count2 = 1, m
       loop_dim1: do count1 = 1, n
          if ( var1(count1,count2) .ne. var2(count1,count2)) then
             if (present(message)) then             
                call increase_message_stack_(message)
             end if
             call failed_assert_action_
             return
          endif
       enddo loop_dim1
    enddo loop_dim2

    call success_assert_action_
  end subroutine assert_equals_2darray_complex_
end module fruit
