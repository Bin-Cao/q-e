###########################################################
# MBD
###########################################################
if(MBD_ROOT)
    add_library(qe_mbd INTERFACE)
    qe_install_targets(qe_mbd)
    target_link_libraries(qe_mbd INTERFACE "-L${MBD_ROOT}/lib;-lmbd")
    target_include_directories(qe_mbd INTERFACE ${MBD_ROOT}/include)
else()
    message(STATUS "Installing MBD via submodule")
    qe_git_submodule_update(external/mbd)
    if(NOT BUILD_SHARED_LIBS)
        set(BUILD_SHARED_LIBS OFF)
        set(FORCE_BUILD_STATIC_LIBS ON)
    endif()
    set(BUILD_TESTING OFF)
    add_subdirectory(mbd EXCLUDE_FROM_ALL)
    unset(BUILD_TESTING)
    if(FORCE_BUILD_STATIC_LIBS)
        unset(BUILD_SHARED_LIBS)
    endif()
    add_library(qe_mbd INTERFACE)
    target_link_libraries(qe_mbd INTERFACE Mbd)
    qe_fix_fortran_modules(Mbd)
    qe_install_targets(qe_mbd Mbd)
endif()