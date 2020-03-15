###############################
Namespacing changes for FRUIT
###############################

Motivation
==========

Namespacing in Fortran is limited to type-bound procedures and module
objects (i.e., variables, types, procedures) with the `private`
attribute. If a module is accessible to another module or program via
an unqualified `use` statement (i.e., the qualifier `only` is not
used, and the association operator `=>` is not used to alias objects
in the "used module" to other names), all objects within that module
with the `public` attribute are accessible to the same scope as the
`use` statement. This behavior has the effect of making `public` module
objects behave like objects at program scope, and can cause name
collisions leading to compilation errors.

Obviously, modules must contain some `public` objects in order for the
module to be usable from other modules and programs. Approaches from C
can be used to minimize the possibility of name collisions between
objects in a module or program and objects in modules being used by
said module or program because C also has limited namespacing facilities.

There are two main approaches to namespacing objects in C, and thus
also Fortran:

1. Prefix names of public objects with the same string throughout a
   library.

2. Bind procedures to derived types. This second approach cannot be
   used with variables that use the `parameter` qualifier, nor can it
   be used with derived types. This approach can only be used with
   variables and procedures.

Due to its greater versatility, we opt for the first approach.

Renames
=======

`module fruit_util` (in `fruit.f90`)
---------------------------------------

equals     -> fruit_equals
to_s       -> fruit_to_s
strip      -> fruit_strip

`module fruit` (in `fruit.f90`)
---------------------------------------

init_fruit -> fruit_init
get_last_message -> fruit_get_last_message
is_last_passed -> fruit_is_last_passed
is_case_passed -> fruit_is_case_passed
add_success -> fruit_add_success
addSuccess -> fruit_addSuccess
set_unit_name -> fruit_set_unit_name
get_unit_name -> fruit_get_unit_name
set_case_name -> fruit_set_case_name
get_case_name -> fruit_get_case_name
failed_assert_action -> fruit_failed_assert_action
get_total_count -> fruit_get_total_count
getTotalCount -> fruit_getTotalCount
get_failed_count -> fruit_get_failed_count
getFailedCount -> fruit_getFailedCount
is_all_successful -> fruit_is_all_successful
isAllSuccessful -> fruit_isAllSuccessful
run_test_case -> fruit_run_test_case
runTestCase -> fruit_runTestCase
assert_equals -> fruit_assert_equals
assertEquals -> fruit_assertEquals
assert_not_equals -> fruit_assert_not_equals
assertNotEquals -> fruit_assertNotEquals
assert_true -> fruit_assert_true
assertTrue -> fruit_assertTrue
stash_test_suite -> fruit_stash_test_suite
restore_test_suite -> fruit_restore_test_suite
override_xml_work -> fruit_override_xml_work
end_override_xml_work -> fruit_end_override_xml_work
get_assert_and_case_count -> fruit_get_assert_and_case_count
initializeFruit -> fruit_initialize
getTestSummary -> fruit_getTestSummary
add_fail -> fruit_add_fail
addFail -> fruit_addFail
init_fruit_xml -> fruit_init_xml
case_passed_xml -> fruit_case_passed_xml
case_failed_xml -> fruit_case_failed_xml
override_stdout -> fruit_override_stdout
end_override_stdout -> fruit_end_override_stdout
override_xml_work -> fruit_override_xml_work
end_override_xml_work -> fruit_end_override_xml_work
get_xml_filename_work -> fruit_get_xml_filename_work
set_xml_filename_work -> fruit_set_xml_filename_work
get_message_index -> fruit_get_message_index
get_messages -> fruit_get_messages
get_message_array -> fruit_get_message_array
set_prefix -> fruit_set_prefix
get_prefix -> fruit_get_prefix

Files requiring replacements:
-----------------------------
`/fruit_processor_gem/lib/fruit_processor.rb`
Any file satisfying the globs `**/*.f90`, `**/*.f95`, `**/*.f03`, or `**/*.f08`

=======================================================
Building sandboxed versions of FRUIT & its preprocessor
=======================================================

Assumptions:
------------
- a Fortran compiler is installed, preferably `gfortran`
- a Ruby interpreter is installed
- the Ruby `gem` command is installed (true as of Ruby >= 1.9);
  otherwise a separate installation
- the `rake` Ruby gem is installed

Directions for installing any of the software packages above can be
found easily via web search and are out of scope of this document.

Opinionated preferences:
------------------------

These directions avoid installing anything system-wide because a user
may not have privileges to do so, undoing a user installation inside a
user directory such as `$HOME` is low risk, and any undesirable
outcomes should not affect root or admin accounts.

In contrast, the directions in the `README` assume a system-wide
installation. To change the directions to a user installation requires
a number of modifications that will be discussed below.

Installation guide modified for a user installation:
----------------------------------------------------

Follow the directions in the `README`, except:

- In step 4, replace `rake install` with `rake` (no additional
  arguments).
- After step 4, but before step 5, run `gem install --user-install
  fruit_processor_gem/pkg/fruit_processor-x.y.z.gem`, where `x.y.z`
  should be replaced by the FRUIT version (e.g., for this version,
  `x.y.z` should be `3.4.3`) and the gem path should of course be
  modified based on the user's current working directory (i.e., the
  command above assumes a user's current working directory is the
  FRUIT repository root)

Auxiliary scripts for making and testing namespace changes:
-----------------------------------------------------------

- `./rake_wrapper.sh` is an idempotent Bash script that automates all
  of the steps in the modified installation described above
- `./git_restore_everything.sh` is an idempotent Bash script that restores
  the state of all Ruby and Fortran source files in the event that
  unstaged changes need to be reverted
- `./namespace_fruit.sh` renames procedures as discussed above

The core of the `./namespace_fruit.sh` script is the `replace` function:

.. code-block:: bash

   replace()
   {
       find . -iname "fruit_f90_source.txt" -exec sed -i '' s/$1/$2/g {} +
       for suffix in "rb" "f90" "f95" "f03" "f08"; do
           find . -iname "*.${suffix}" -exec sed -i '' s/$1/$2/g {} +
       done
   }

This function replaces procedure names in the Fortran source file
template `fruit_f90_source.txt` before making corresponding changes in
all other Fortran and Ruby source files. If `fruit_f90_source.txt` is
*not* changed, then the generated `fruit.f90` source file will be
inconsistent with the other source files.
