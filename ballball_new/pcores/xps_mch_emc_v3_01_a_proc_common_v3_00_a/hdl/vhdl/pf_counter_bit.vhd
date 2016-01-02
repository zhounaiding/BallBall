-------------------------------------------------------------------------------
-- $Id: pf_counter_bit.vhd,v 1.1.4.1 2010/09/14 22:35:46 dougt Exp $
-------------------------------------------------------------------------------
-- pf_counter_bit.vhd - entity/architecture pair
-------------------------------------------------------------------------------
--
-- *************************************************************************
-- **                                                                     **
-- ** DISCLAIMER OF LIABILITY                                             **
-- **                                                                     **
-- ** This text/file contains proprietary, confidential                   **
-- ** information of Xilinx, Inc., is distributed under                   **
-- ** license from Xilinx, Inc., and may be used, copied                  **
-- ** and/or disclosed only pursuant to the terms of a valid              **
-- ** license agreement with Xilinx, Inc. Xilinx hereby                   **
-- ** grants you a license to use this text/file solely for               **
-- ** design, simulation, implementation and creation of                  **
-- ** design files limited to Xilinx devices or technologies.             **
-- ** Use with non-Xilinx devices or technologies is expressly            **
-- ** prohibited and immediately terminates your license unless           **
-- ** covered by a separate agreement.                                    **
-- **                                                                     **
-- ** Xilinx is providing this design, code, or information               **
-- ** "as-is" solely for use in developing programs and                   **
-- ** solutions for Xilinx devices, with no obligation on the             **
-- ** part of Xilinx to provide support. By providing this design,        **
-- ** code, or information as one possible implementation of              **
-- ** this feature, application or standard, Xilinx is making no          **
-- ** representation that this implementation is free from any            **
-- ** claims of infringement. You are responsible for obtaining           **
-- ** any rights you may require for your implementation.                 **
-- ** Xilinx expressly disclaims any warranty whatsoever with             **
-- ** respect to the adequacy of the implementation, including            **
-- ** but not limited to any warranties or representations that this      **
-- ** implementation is free from claims of infringement, implied         **
-- ** warranties of merchantability or fitness for a particular           **
-- ** purpose.                                                            **
-- **                                                                     **
-- ** Xilinx products are not intended for use in life support            **
-- ** appliances, devices, or systems. Use in such applications is        **
-- ** expressly prohibited.                                               **
-- **                                                                     **
-- ** Any modifications that are made to the Source Code are              **
-- ** done at the user�s sole risk and will be unsupported.               **
-- ** The Xilinx Support Hotline does not have access to source           **
-- ** code and therefore cannot answer specific questions related         **
-- ** to source HDL. The Xilinx Hotline support of original source        **
-- ** code IP shall only address issues and questions related             **
-- ** to the standard Netlist version of the core (and thus               **
-- ** indirectly, the original core source).                              **
-- **                                                                     **
-- ** Copyright (c) 2001-2010 Xilinx, Inc. All rights reserved.           **
-- **                                                                     **
-- ** This copyright and support notice must be retained as part          **
-- ** of this text at all times.                                          **
-- **                                                                     **
-- *************************************************************************
--
-------------------------------------------------------------------------------
-- Filename:        pf_counter_bit.vhd
--
-- Description:     Implements 1 bit of the counter/timer
--                  
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:   
--                  pf_counter_bit.vhd
--
-------------------------------------------------------------------------------
-- Author:          B.L. Tise
-- Revision:        $Revision: 1.1.4.1 $
-- Date:            $Date: 2010/09/14 22:35:46 $
--
-- History:
--   D. Thorpe      2001-08-30    First Version
--                  - adapted from B Tise MicroBlaze counters
--
--   DET            2001-09-11   
--                  - Added the Rst input signal and connected it to the FDRE
--                    reset input.
--
--   DET            2002-02-24
--                  - Changed to call out proc_common_v1_00_b library.
--                  - Changed the use of MUXCY_L to MUXCY.
--
--
--     DET     3/25/2004     ipif to v1_00_f
-- ~~~~~~
--                  - Changed to call out proc_common v2_00_a library.
-- ^^^^^^
--
--     DET     1/17/2008     v3_00_a
-- ~~~~~~
--     - Changed proc_common library version to v3_00_a
--     - Incorporated new disclaimer header
-- ^^^^^^
--
--
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                               "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_com" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

library unisim;
use unisim.all;

library xps_mch_emc_v3_01_a_proc_common_v3_00_a;
Use xps_mch_emc_v3_01_a_proc_common_v3_00_a.inferred_lut4;
                
-----------------------------------------------------------------------------
-- Entity section
-----------------------------------------------------------------------------

entity pf_counter_bit is
  
  port (
    Clk           : in  std_logic;
    Rst           : In  std_logic;
    Count_In      : in  std_logic;
    Load_In       : in  std_logic;
    Count_Load    : in  std_logic;
    Count_Down    : in  std_logic;
    Carry_In      : in  std_logic;
    Clock_Enable  : in  std_logic;
    Result        : out std_logic;
    Carry_Out     : out std_logic
    );

end pf_counter_bit;

-----------------------------------------------------------------------------
-- Architecture section
-----------------------------------------------------------------------------

architecture implementation of pf_counter_bit is
  
  --- xst wrk around  component LUT4 is
  --- xst wrk around    generic(
  --- xst wrk around    -- synthesis translate_off
  --- xst wrk around      Xon  : boolean;
  --- xst wrk around    -- synthesis translate_on    
  --- xst wrk around      INIT : bit_vector := X"0000"
  --- xst wrk around      );
  --- xst wrk around    port (
  --- xst wrk around      O  : out std_logic;
  --- xst wrk around      I0 : in  std_logic;
  --- xst wrk around      I1 : in  std_logic;
  --- xst wrk around      I2 : in  std_logic;
  --- xst wrk around      I3 : in  std_logic);
  --- xst wrk around  end component LUT4;

                                         
  component inferred_lut4 is 
   generic (INIT : bit_vector(15 downto 0)); 
   port ( 
     O  : out std_logic; 
     I0 : in std_logic; 
     I1 : in std_logic; 
     I2 : in std_logic; 
     I3 : in std_logic 
     );
  end component inferred_lut4;
  
  component MUXCY is
    port (
      DI : in  std_logic;
      CI : in  std_logic;
      S  : in  std_logic;
      O  : out std_logic);
  end component MUXCY;

  component XORCY is
    port (
      LI : in  std_logic;
      CI : in  std_logic;
      O  : out std_logic);
  end component XORCY;
  
  component FDRE is
    port (
      Q  : out std_logic;
      C  : in  std_logic;
      CE : in  std_logic;
      D  : in  std_logic;
      R  : in  std_logic
    );
  end component FDRE;
  
  signal    count_AddSub     : std_logic;
  signal    count_Result     : std_logic;
  signal    count_Result_Reg : std_logic;

  attribute INIT       : string;
  
begin  -- VHDL_RTL

  
  --- xst wrk around  I_ALU_LUT : LUT4
  --- xst wrk around    generic map(
  --- xst wrk around    -- synthesis translate_off
  --- xst wrk around      Xon  => false,
  --- xst wrk around    -- synthesis translate_on    
  --- xst wrk around      INIT => X"36C6"
  --- xst wrk around      )
  --- xst wrk around    port map (
  --- xst wrk around      O  => count_AddSub,               
  --- xst wrk around      I0 => Count_In,                   
  --- xst wrk around      I1 => Count_Down,                 
  --- xst wrk around      I2 => Count_Load,                 
  --- xst wrk around      I3 => Load_In);                   
  
  

  I_ALU_LUT : inferred_lut4              
    generic map(                
      INIT => X"36C6"           
      )                         
    port map (                  
      O  => count_AddSub,       
      I0 => Count_In,           
      I1 => Count_Down,         
      I2 => Count_Load,         
      I3 => Load_In);           
                                

  MUXCY_I : MUXCY
    port map (
      DI => Count_Down,
      CI => Carry_In,
      S  => count_AddSub,
      O  => Carry_Out);

  XOR_I : XORCY
    port map (
      LI => count_AddSub,
      CI => Carry_In,
      O  => count_Result);

  FDRE_I: FDRE
    port map (
      Q  => count_Result_Reg,           
      C  => Clk,                        
      CE => Clock_Enable,               
      D  => count_Result,               
      R  => Rst                         
    );      

  Result <= count_Result_Reg;
        
                             
                             
end implementation;


