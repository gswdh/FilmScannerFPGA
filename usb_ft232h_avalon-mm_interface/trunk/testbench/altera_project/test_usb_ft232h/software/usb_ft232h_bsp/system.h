/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'cpu' in SOPC Builder design 'sopc'
 * SOPC Builder design path: ../../sopc.sopcinfo
 *
 * Generated: Fri Apr 07 17:55:30 FET 2017
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_gen2"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x01000820
#define ALT_CPU_CPU_ARCH_NIOS2_R1
#define ALT_CPU_CPU_FREQ 100000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "tiny"
#define ALT_CPU_DATA_ADDR_WIDTH 0x19
#define ALT_CPU_DCACHE_LINE_SIZE 0
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_DCACHE_SIZE 0
#define ALT_CPU_EXCEPTION_ADDR 0x00800020
#define ALT_CPU_FLASH_ACCELERATOR_LINES 0
#define ALT_CPU_FLASH_ACCELERATOR_LINE_SIZE 0
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 100000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 0
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 0
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_ICACHE_SIZE 0
#define ALT_CPU_INST_ADDR_WIDTH 0x19
#define ALT_CPU_NAME "cpu"
#define ALT_CPU_OCI_VERSION 1
#define ALT_CPU_RESET_ADDR 0x00800000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x01000820
#define NIOS2_CPU_ARCH_NIOS2_R1
#define NIOS2_CPU_FREQ 100000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "tiny"
#define NIOS2_DATA_ADDR_WIDTH 0x19
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x00800020
#define NIOS2_FLASH_ACCELERATOR_LINES 0
#define NIOS2_FLASH_ACCELERATOR_LINE_SIZE 0
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 0
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE_LOG2 0
#define NIOS2_ICACHE_SIZE 0
#define NIOS2_INST_ADDR_WIDTH 0x19
#define NIOS2_OCI_VERSION 1
#define NIOS2_RESET_ADDR 0x00800000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_DMA
#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_NEW_SDRAM_CONTROLLER
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_NIOS2_GEN2
#define __USB_FT232H


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Cyclone IV E"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart"
#define ALT_STDERR_BASE 0x1001058
#define ALT_STDERR_DEV jtag_uart
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart"
#define ALT_STDIN_BASE 0x1001058
#define ALT_STDIN_DEV jtag_uart
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart"
#define ALT_STDOUT_BASE 0x1001058
#define ALT_STDOUT_DEV jtag_uart
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "sopc"


/*
 * dma_rx configuration
 *
 */

#define ALT_MODULE_CLASS_dma_rx altera_avalon_dma
#define DMA_RX_ALLOW_BYTE_TRANSACTIONS 1
#define DMA_RX_ALLOW_DOUBLEWORD_TRANSACTIONS 0
#define DMA_RX_ALLOW_HW_TRANSACTIONS 0
#define DMA_RX_ALLOW_QUADWORD_TRANSACTIONS 0
#define DMA_RX_ALLOW_WORD_TRANSACTIONS 0
#define DMA_RX_BASE 0x1001000
#define DMA_RX_IRQ 0
#define DMA_RX_IRQ_INTERRUPT_CONTROLLER_ID 0
#define DMA_RX_LENGTHWIDTH 13
#define DMA_RX_MAX_BURST_SIZE 128
#define DMA_RX_NAME "/dev/dma_rx"
#define DMA_RX_SPAN 32
#define DMA_RX_TYPE "altera_avalon_dma"


/*
 * dma_tx configuration
 *
 */

#define ALT_MODULE_CLASS_dma_tx altera_avalon_dma
#define DMA_TX_ALLOW_BYTE_TRANSACTIONS 1
#define DMA_TX_ALLOW_DOUBLEWORD_TRANSACTIONS 0
#define DMA_TX_ALLOW_HW_TRANSACTIONS 0
#define DMA_TX_ALLOW_QUADWORD_TRANSACTIONS 0
#define DMA_TX_ALLOW_WORD_TRANSACTIONS 0
#define DMA_TX_BASE 0x1001020
#define DMA_TX_IRQ 1
#define DMA_TX_IRQ_INTERRUPT_CONTROLLER_ID 0
#define DMA_TX_LENGTHWIDTH 13
#define DMA_TX_MAX_BURST_SIZE 128
#define DMA_TX_NAME "/dev/dma_tx"
#define DMA_TX_SPAN 32
#define DMA_TX_TYPE "altera_avalon_dma"


/*
 * hal configuration
 *
 */

#define ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
#define ALT_MAX_FD 32
#define ALT_SYS_CLK none
#define ALT_TIMESTAMP_CLK none


/*
 * jtag_uart configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart altera_avalon_jtag_uart
#define JTAG_UART_BASE 0x1001058
#define JTAG_UART_IRQ 2
#define JTAG_UART_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_NAME "/dev/jtag_uart"
#define JTAG_UART_READ_DEPTH 64
#define JTAG_UART_READ_THRESHOLD 8
#define JTAG_UART_SPAN 8
#define JTAG_UART_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_WRITE_DEPTH 64
#define JTAG_UART_WRITE_THRESHOLD 8


/*
 * led configuration
 *
 */

#define ALT_MODULE_CLASS_led altera_avalon_pio
#define LED_BASE 0x0
#define LED_BIT_CLEARING_EDGE_REGISTER 0
#define LED_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED_CAPTURE 0
#define LED_DATA_WIDTH 1
#define LED_DO_TEST_BENCH_WIRING 0
#define LED_DRIVEN_SIM_VALUE 0
#define LED_EDGE_TYPE "NONE"
#define LED_FREQ 100000000
#define LED_HAS_IN 0
#define LED_HAS_OUT 1
#define LED_HAS_TRI 0
#define LED_IRQ -1
#define LED_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED_IRQ_TYPE "NONE"
#define LED_NAME "/dev/led"
#define LED_RESET_VALUE 0
#define LED_SPAN 16
#define LED_TYPE "altera_avalon_pio"


/*
 * sdram configuration
 *
 */

#define ALT_MODULE_CLASS_sdram altera_avalon_new_sdram_controller
#define SDRAM_BASE 0x800000
#define SDRAM_CAS_LATENCY 2
#define SDRAM_CONTENTS_INFO
#define SDRAM_INIT_NOP_DELAY 0.0
#define SDRAM_INIT_REFRESH_COMMANDS 2
#define SDRAM_IRQ -1
#define SDRAM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SDRAM_IS_INITIALIZED 1
#define SDRAM_NAME "/dev/sdram"
#define SDRAM_POWERUP_DELAY 100.0
#define SDRAM_REFRESH_PERIOD 15.625
#define SDRAM_REGISTER_DATA_IN 1
#define SDRAM_SDRAM_ADDR_WIDTH 0x17
#define SDRAM_SDRAM_BANK_WIDTH 2
#define SDRAM_SDRAM_COL_WIDTH 9
#define SDRAM_SDRAM_DATA_WIDTH 8
#define SDRAM_SDRAM_NUM_BANKS 4
#define SDRAM_SDRAM_NUM_CHIPSELECTS 1
#define SDRAM_SDRAM_ROW_WIDTH 12
#define SDRAM_SHARED_DATA 0
#define SDRAM_SIM_MODEL_BASE 0
#define SDRAM_SPAN 8388608
#define SDRAM_STARVATION_INDICATOR 0
#define SDRAM_TRISTATE_BRIDGE_SLAVE ""
#define SDRAM_TYPE "altera_avalon_new_sdram_controller"
#define SDRAM_T_AC 6.0
#define SDRAM_T_MRD 3
#define SDRAM_T_RCD 20.0
#define SDRAM_T_RFC 70.0
#define SDRAM_T_RP 20.0
#define SDRAM_T_WR 15.0


/*
 * sdram configuration as viewed by dma_rx_write_master
 *
 */

#define DMA_RX_WRITE_MASTER_SDRAM_BASE 0x800000
#define DMA_RX_WRITE_MASTER_SDRAM_CAS_LATENCY 2
#define DMA_RX_WRITE_MASTER_SDRAM_CONTENTS_INFO
#define DMA_RX_WRITE_MASTER_SDRAM_INIT_NOP_DELAY 0.0
#define DMA_RX_WRITE_MASTER_SDRAM_INIT_REFRESH_COMMANDS 2
#define DMA_RX_WRITE_MASTER_SDRAM_IRQ -1
#define DMA_RX_WRITE_MASTER_SDRAM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define DMA_RX_WRITE_MASTER_SDRAM_IS_INITIALIZED 1
#define DMA_RX_WRITE_MASTER_SDRAM_NAME "/dev/sdram"
#define DMA_RX_WRITE_MASTER_SDRAM_POWERUP_DELAY 100.0
#define DMA_RX_WRITE_MASTER_SDRAM_REFRESH_PERIOD 15.625
#define DMA_RX_WRITE_MASTER_SDRAM_REGISTER_DATA_IN 1
#define DMA_RX_WRITE_MASTER_SDRAM_SDRAM_ADDR_WIDTH 0x17
#define DMA_RX_WRITE_MASTER_SDRAM_SDRAM_BANK_WIDTH 2
#define DMA_RX_WRITE_MASTER_SDRAM_SDRAM_COL_WIDTH 9
#define DMA_RX_WRITE_MASTER_SDRAM_SDRAM_DATA_WIDTH 8
#define DMA_RX_WRITE_MASTER_SDRAM_SDRAM_NUM_BANKS 4
#define DMA_RX_WRITE_MASTER_SDRAM_SDRAM_NUM_CHIPSELECTS 1
#define DMA_RX_WRITE_MASTER_SDRAM_SDRAM_ROW_WIDTH 12
#define DMA_RX_WRITE_MASTER_SDRAM_SHARED_DATA 0
#define DMA_RX_WRITE_MASTER_SDRAM_SIM_MODEL_BASE 0
#define DMA_RX_WRITE_MASTER_SDRAM_SPAN 8388608
#define DMA_RX_WRITE_MASTER_SDRAM_STARVATION_INDICATOR 0
#define DMA_RX_WRITE_MASTER_SDRAM_TRISTATE_BRIDGE_SLAVE ""
#define DMA_RX_WRITE_MASTER_SDRAM_TYPE "altera_avalon_new_sdram_controller"
#define DMA_RX_WRITE_MASTER_SDRAM_T_AC 6.0
#define DMA_RX_WRITE_MASTER_SDRAM_T_MRD 3
#define DMA_RX_WRITE_MASTER_SDRAM_T_RCD 20.0
#define DMA_RX_WRITE_MASTER_SDRAM_T_RFC 70.0
#define DMA_RX_WRITE_MASTER_SDRAM_T_RP 20.0
#define DMA_RX_WRITE_MASTER_SDRAM_T_WR 15.0


/*
 * sdram configuration as viewed by dma_tx_read_master
 *
 */

#define DMA_TX_READ_MASTER_SDRAM_BASE 0x800000
#define DMA_TX_READ_MASTER_SDRAM_CAS_LATENCY 2
#define DMA_TX_READ_MASTER_SDRAM_CONTENTS_INFO
#define DMA_TX_READ_MASTER_SDRAM_INIT_NOP_DELAY 0.0
#define DMA_TX_READ_MASTER_SDRAM_INIT_REFRESH_COMMANDS 2
#define DMA_TX_READ_MASTER_SDRAM_IRQ -1
#define DMA_TX_READ_MASTER_SDRAM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define DMA_TX_READ_MASTER_SDRAM_IS_INITIALIZED 1
#define DMA_TX_READ_MASTER_SDRAM_NAME "/dev/sdram"
#define DMA_TX_READ_MASTER_SDRAM_POWERUP_DELAY 100.0
#define DMA_TX_READ_MASTER_SDRAM_REFRESH_PERIOD 15.625
#define DMA_TX_READ_MASTER_SDRAM_REGISTER_DATA_IN 1
#define DMA_TX_READ_MASTER_SDRAM_SDRAM_ADDR_WIDTH 0x17
#define DMA_TX_READ_MASTER_SDRAM_SDRAM_BANK_WIDTH 2
#define DMA_TX_READ_MASTER_SDRAM_SDRAM_COL_WIDTH 9
#define DMA_TX_READ_MASTER_SDRAM_SDRAM_DATA_WIDTH 8
#define DMA_TX_READ_MASTER_SDRAM_SDRAM_NUM_BANKS 4
#define DMA_TX_READ_MASTER_SDRAM_SDRAM_NUM_CHIPSELECTS 1
#define DMA_TX_READ_MASTER_SDRAM_SDRAM_ROW_WIDTH 12
#define DMA_TX_READ_MASTER_SDRAM_SHARED_DATA 0
#define DMA_TX_READ_MASTER_SDRAM_SIM_MODEL_BASE 0
#define DMA_TX_READ_MASTER_SDRAM_SPAN 8388608
#define DMA_TX_READ_MASTER_SDRAM_STARVATION_INDICATOR 0
#define DMA_TX_READ_MASTER_SDRAM_TRISTATE_BRIDGE_SLAVE ""
#define DMA_TX_READ_MASTER_SDRAM_TYPE "altera_avalon_new_sdram_controller"
#define DMA_TX_READ_MASTER_SDRAM_T_AC 6.0
#define DMA_TX_READ_MASTER_SDRAM_T_MRD 3
#define DMA_TX_READ_MASTER_SDRAM_T_RCD 20.0
#define DMA_TX_READ_MASTER_SDRAM_T_RFC 70.0
#define DMA_TX_READ_MASTER_SDRAM_T_RP 20.0
#define DMA_TX_READ_MASTER_SDRAM_T_WR 15.0


/*
 * sysid configuration
 *
 */

#define ALT_MODULE_CLASS_sysid altera_avalon_sysid_qsys
#define SYSID_BASE 0x1001048
#define SYSID_ID 14303232
#define SYSID_IRQ -1
#define SYSID_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_NAME "/dev/sysid"
#define SYSID_SPAN 8
#define SYSID_TIMESTAMP 1491576696
#define SYSID_TYPE "altera_avalon_sysid_qsys"


/*
 * usb configuration
 *
 */

#define ALT_MODULE_CLASS_usb usb_ft232h
#define USB_BASE 0x1001050
#define USB_IRQ -1
#define USB_IRQ_INTERRUPT_CONTROLLER_ID -1
#define USB_NAME "/dev/usb"
#define USB_SPAN 8
#define USB_TYPE "usb_ft232h"


/*
 * usb configuration as viewed by dma_rx_read_master
 *
 */

#define DMA_RX_READ_MASTER_USB_BASE 0x1001050
#define DMA_RX_READ_MASTER_USB_IRQ -1
#define DMA_RX_READ_MASTER_USB_IRQ_INTERRUPT_CONTROLLER_ID -1
#define DMA_RX_READ_MASTER_USB_NAME "/dev/usb"
#define DMA_RX_READ_MASTER_USB_SPAN 8
#define DMA_RX_READ_MASTER_USB_TYPE "usb_ft232h"


/*
 * usb configuration as viewed by dma_tx_write_master
 *
 */

#define DMA_TX_WRITE_MASTER_USB_BASE 0x1001050
#define DMA_TX_WRITE_MASTER_USB_IRQ -1
#define DMA_TX_WRITE_MASTER_USB_IRQ_INTERRUPT_CONTROLLER_ID -1
#define DMA_TX_WRITE_MASTER_USB_NAME "/dev/usb"
#define DMA_TX_WRITE_MASTER_USB_SPAN 8
#define DMA_TX_WRITE_MASTER_USB_TYPE "usb_ft232h"

#endif /* __SYSTEM_H_ */
