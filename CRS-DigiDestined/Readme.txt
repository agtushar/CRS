DIGITAL LOGIC DESIGN LAB (CS 254, 2018-19 SPRING, IIT BOMBAY)

Team name: DigiDestined

SETTING UP

Open a new project, in Xilinx ISE, and add all the .vhd files, except tb_crs and tb_crs_144, present in this directory to the project. Add only one of tb_crs and tb_crs_144 - the latter is for a full 144-bit vectors, and would likely require you to use a 4k or 8k screen to view the vectors completely. For the purposes of demonstration, therefore, use tb_crs.

Set `CRS.vhd` as the top module.

Also, generate `fifo` of the required size, and modify the required variables in global variables.

The following global variables can be found in `globals.vhd`:

1. `N` - the number of input and output ports: there are N buffer input ports, N express input ports, and N output ports.
2. `dv_bit_interval` - if this is 4, then the 4th, 8th, 12th are the data valid bits.
3. `n_dv_bits` - if this is 3, then one data chunk contains 3 data valid bits.
4. `data_bus_size` - this is automatically initialised to the product of `dv_bit_interval` and `n_dv_bits`.



