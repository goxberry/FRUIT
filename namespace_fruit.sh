#!/usr/bin/env bash

replace()
{
    find . -iname "fruit_f90_source.txt" -exec sed -i '' s/$1/$2/g {} +
    for suffix in "rb" "f90" "f95" "f03" "f08"; do
        find . -iname "*.${suffix}" -exec sed -i '' s/$1/$2/g {} +
    done
}

REPO_ROOT=$(git rev-parse --show-toplevel)

pushd ${REPO_ROOT}
replace init_fruit fruit_init
replace get_last_message fruit_get_last_message
replace is_last_passed fruit_is_last_passed
replace is_case_passed fruit_is_case_passed
replace add_success fruit_add_success
replace addSuccess fruit_addSuccess
replace set_unit_name fruit_set_unit_name
replace get_unit_name fruit_get_unit_name
replace set_case_name fruit_set_case_name
replace get_case_name fruit_get_case_name
replace failed_assert_action fruit_failed_assert_action
replace get_total_count fruit_get_total_count
replace getTotalCount fruit_getTotalCount
replace get_failed_count fruit_get_failed_count
replace getFailedCount fruit_getFailedCount
replace is_all_successful fruit_is_all_successful
replace isAllSuccessful fruit_isAllSuccessful
replace run_test_case fruit_run_test_case
replace runTestCase fruit_runTestCase
replace assert_equals fruit_assert_equals
replace assertEquals fruit_assertEquals
replace assert_not_equals fruit_assert_not_equals
replace assertNotEquals fruit_assertNotEquals
replace assert_true fruit_assert_true
replace assertTrue fruit_assertTrue
replace stash_test_suite fruit_stash_test_suite
replace restore_test_suite fruit_restore_test_suite
replace override_xml_work fruit_override_xml_work
replace end_override_xml_work fruit_end_override_xml_work
replace get_assert_and_case_count fruit_get_assert_and_case_count
replace initializeFruit fruit_initialize
replace getTestSummary fruit_getTestSummary
replace add_fail fruit_add_fail
replace addFail fruit_addFail
replace init_fruit_xml fruit_init_xml
replace case_passed_xml fruit_case_passed_xml
replace case_failed_xml fruit_case_failed_xml
replace override_stdout fruit_override_stdout
replace end_override_stdout fruit_end_override_stdout
replace override_xml_work fruit_override_xml_work
replace end_override_xml_work fruit_end_override_xml_work
replace get_xml_filename_work fruit_get_xml_filename_work
replace set_xml_filename_work fruit_set_xml_filename_work
replace get_message_index fruit_get_message_index
replace get_messages fruit_get_messages
replace get_message_array fruit_get_message_array
replace set_prefix fruit_set_prefix
replace get_prefix fruit_get_prefix
trap popd EXIT SIGINT SIGKILL
