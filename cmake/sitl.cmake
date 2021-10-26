main_sources(SITL_COMMON_SRC_EXCLUDES
    drivers/adc.c
    drivers/bus_i2c.c
    drivers/bus_i2c_config.c
    drivers/bus_spi.c
    drivers/bus_spi_config.c
    drivers/bus_spi_pinconfig.c
    drivers/dma.c
    drivers/persistent.c
    drivers/pwm_mapping.c
    drivers/pwm_output.c
    drivers/time.c
    drivers/timer.c
    drivers/system.c
    drivers/rcc.c
    drivers/serial_escserial.c
    drivers/serial_pinconfig.c
    drivers/serial_uart.c
    drivers/serial_uart_init.c
    drivers/serial_uart_pinconfig.c
    drivers/rx/rx_xn297.c
    drivers/display_ug2864hsweg01.c
    io/displayport_oled.c
    io/vtx.c
)

set(SITL_INCLUDES
    "${MAIN_LIB_DIR}/main/dyad"
)

main_sources(SITL_TARGET_SRC
    drivers/accgyro/accgyro_fake.c
    drivers/barometer/barometer_fake.c
    drivers/compass/compass_fake.c
    drivers/serial_tcp.c
)

set(SITL_LIBRARY_SRC
    "${MAIN_LIB_DIR}/main/dyad/dyad.c"
)

set(SITL_DEFINITIONS
    SIMULATOR_BUILD
    MCU_FLASH_SIZE=2048
)

set(SITL_LIBRARIES
    m
    pthread
    c
)

function(target_sitl name)
    set(sitl_common_src "${COMMON_SRC}")
    list(REMOVE_ITEM sitl_common_src ${SITL_COMMON_SRC_EXCLUDES})

    set(elf_target SITL.elf)
    add_executable(${elf_target})
    set(target_sources ${SITL_LIBRARY_SRC} ${SITL_TARGET_SRC} ${sitl_common_src})
    file(GLOB target_c_sources "${CMAKE_CURRENT_SOURCE_DIR}/*.c")
    file(GLOB target_h_sources "${CMAKE_CURRENT_SOURCE_DIR}/*.h")
    list(APPEND target_sources ${target_c_sources} ${target_h_sources})
    target_sources(${elf_target} PRIVATE ${target_sources})
    target_include_directories(${elf_target} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR} ${SITL_INCLUDES})
    target_compile_definitions(${elf_target} PRIVATE ${SITL_DEFINITIONS} ${COMMON_COMPILE_DEFINITIONS})
    target_link_libraries(${elf_target} ${SITL_LIBRARIES})
    setup_executable(${elf_target} ${name})
    enable_settings(${elf_target} ${name} SETTINGS_CXX g++)
    set(script_path "${CMAKE_CURRENT_SOURCE_DIR}/pg.ld")
    set_target_properties(${elf_target} PROPERTIES LINK_DEPENDS ${script_path})
    target_link_options(${elf_target} PRIVATE -T${script_path})
endfunction()
