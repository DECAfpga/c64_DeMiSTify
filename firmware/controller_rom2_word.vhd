library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller_rom2 is
generic	(
	ADDR_WIDTH : integer := 8; -- ROM's address width (words, not bytes)
	COL_WIDTH  : integer := 8;  -- Column width (8bit -> byte)
	NB_COL     : integer := 4  -- Number of columns in memory
	);
port (
	clk : in std_logic;
	reset_n : in std_logic := '1';
	addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
	q : out std_logic_vector(31 downto 0);
	-- Allow writes - defaults supplied to simplify projects that don't need to write.
	d : in std_logic_vector(31 downto 0) := X"00000000";
	we : in std_logic := '0';
	bytesel : in std_logic_vector(3 downto 0) := "1111"
);
end entity;

architecture arch of controller_rom2 is

-- type word_t is std_logic_vector(31 downto 0);
type ram_type is array (0 to 2 ** ADDR_WIDTH - 1) of std_logic_vector(NB_COL * COL_WIDTH - 1 downto 0);

signal ram : ram_type :=
(

     0 => x"7f404060",
     1 => x"7f7f003f",
     2 => x"63361c08",
     3 => x"7f000041",
     4 => x"4040407f",
     5 => x"7f7f0040",
     6 => x"7f060c06",
     7 => x"7f7f007f",
     8 => x"7f180c06",
     9 => x"3e00007f",
    10 => x"7f41417f",
    11 => x"7f00003e",
    12 => x"0f09097f",
    13 => x"7f3e0006",
    14 => x"7e7f6141",
    15 => x"7f000040",
    16 => x"7f19097f",
    17 => x"26000066",
    18 => x"7b594d6f",
    19 => x"01000032",
    20 => x"017f7f01",
    21 => x"3f000001",
    22 => x"7f40407f",
    23 => x"0f00003f",
    24 => x"3f70703f",
    25 => x"7f7f000f",
    26 => x"7f301830",
    27 => x"6341007f",
    28 => x"361c1c36",
    29 => x"03014163",
    30 => x"067c7c06",
    31 => x"71610103",
    32 => x"43474d59",
    33 => x"00000041",
    34 => x"41417f7f",
    35 => x"03010000",
    36 => x"30180c06",
    37 => x"00004060",
    38 => x"7f7f4141",
    39 => x"0c080000",
    40 => x"0c060306",
    41 => x"80800008",
    42 => x"80808080",
    43 => x"00000080",
    44 => x"04070300",
    45 => x"20000000",
    46 => x"7c545474",
    47 => x"7f000078",
    48 => x"7c44447f",
    49 => x"38000038",
    50 => x"4444447c",
    51 => x"38000000",
    52 => x"7f44447c",
    53 => x"3800007f",
    54 => x"5c54547c",
    55 => x"04000018",
    56 => x"05057f7e",
    57 => x"18000000",
    58 => x"fca4a4bc",
    59 => x"7f00007c",
    60 => x"7c04047f",
    61 => x"00000078",
    62 => x"407d3d00",
    63 => x"80000000",
    64 => x"7dfd8080",
    65 => x"7f000000",
    66 => x"6c38107f",
    67 => x"00000044",
    68 => x"407f3f00",
    69 => x"7c7c0000",
    70 => x"7c0c180c",
    71 => x"7c000078",
    72 => x"7c04047c",
    73 => x"38000078",
    74 => x"7c44447c",
    75 => x"fc000038",
    76 => x"3c2424fc",
    77 => x"18000018",
    78 => x"fc24243c",
    79 => x"7c0000fc",
    80 => x"0c04047c",
    81 => x"48000008",
    82 => x"7454545c",
    83 => x"04000020",
    84 => x"44447f3f",
    85 => x"3c000000",
    86 => x"7c40407c",
    87 => x"1c00007c",
    88 => x"3c60603c",
    89 => x"7c3c001c",
    90 => x"7c603060",
    91 => x"6c44003c",
    92 => x"6c381038",
    93 => x"1c000044",
    94 => x"3c60e0bc",
    95 => x"4400001c",
    96 => x"4c5c7464",
    97 => x"08000044",
    98 => x"41773e08",
    99 => x"00000041",
   100 => x"007f7f00",
   101 => x"41000000",
   102 => x"083e7741",
   103 => x"01020008",
   104 => x"02020301",
   105 => x"7f7f0001",
   106 => x"7f7f7f7f",
   107 => x"0808007f",
   108 => x"3e3e1c1c",
   109 => x"7f7f7f7f",
   110 => x"1c1c3e3e",
   111 => x"10000808",
   112 => x"187c7c18",
   113 => x"10000010",
   114 => x"307c7c30",
   115 => x"30100010",
   116 => x"1e786060",
   117 => x"66420006",
   118 => x"663c183c",
   119 => x"38780042",
   120 => x"6cc6c26a",
   121 => x"00600038",
   122 => x"00006000",
   123 => x"5e0e0060",
   124 => x"0e5d5c5b",
   125 => x"c24c711e",
   126 => x"4dbfd1f1",
   127 => x"1ec04bc0",
   128 => x"c702ab74",
   129 => x"48a6c487",
   130 => x"87c578c0",
   131 => x"c148a6c4",
   132 => x"1e66c478",
   133 => x"dfee4973",
   134 => x"c086c887",
   135 => x"efef49e0",
   136 => x"4aa5c487",
   137 => x"f0f0496a",
   138 => x"87c6f187",
   139 => x"83c185cb",
   140 => x"04abb7c8",
   141 => x"2687c7ff",
   142 => x"4c264d26",
   143 => x"4f264b26",
   144 => x"c24a711e",
   145 => x"c25ad5f1",
   146 => x"c748d5f1",
   147 => x"ddfe4978",
   148 => x"1e4f2687",
   149 => x"4a711e73",
   150 => x"03aab7c0",
   151 => x"d6c287d3",
   152 => x"c405bfed",
   153 => x"c24bc187",
   154 => x"c24bc087",
   155 => x"c45bf1d6",
   156 => x"f1d6c287",
   157 => x"edd6c25a",
   158 => x"9ac14abf",
   159 => x"49a2c0c1",
   160 => x"fc87e8ec",
   161 => x"edd6c248",
   162 => x"effe78bf",
   163 => x"4a711e87",
   164 => x"721e66c4",
   165 => x"87e2e649",
   166 => x"1e4f2626",
   167 => x"bfedd6c2",
   168 => x"87c4e349",
   169 => x"48c9f1c2",
   170 => x"c278bfe8",
   171 => x"ec48c5f1",
   172 => x"f1c278bf",
   173 => x"494abfc9",
   174 => x"c899ffc3",
   175 => x"48722ab7",
   176 => x"f1c2b071",
   177 => x"4f2658d1",
   178 => x"5c5b5e0e",
   179 => x"4b710e5d",
   180 => x"c287c8ff",
   181 => x"c048c4f1",
   182 => x"e2497350",
   183 => x"497087ea",
   184 => x"cb9cc24c",
   185 => x"cccb49ee",
   186 => x"4d497087",
   187 => x"97c4f1c2",
   188 => x"e2c105bf",
   189 => x"4966d087",
   190 => x"bfcdf1c2",
   191 => x"87d60599",
   192 => x"c24966d4",
   193 => x"99bfc5f1",
   194 => x"7387cb05",
   195 => x"87f8e149",
   196 => x"c1029870",
   197 => x"4cc187c1",
   198 => x"7587c0fe",
   199 => x"87e1ca49",
   200 => x"c6029870",
   201 => x"c4f1c287",
   202 => x"c250c148",
   203 => x"bf97c4f1",
   204 => x"87e3c005",
   205 => x"bfcdf1c2",
   206 => x"9966d049",
   207 => x"87d6ff05",
   208 => x"bfc5f1c2",
   209 => x"9966d449",
   210 => x"87caff05",
   211 => x"f7e04973",
   212 => x"05987087",
   213 => x"7487fffe",
   214 => x"87dcfb48",
   215 => x"5c5b5e0e",
   216 => x"86f40e5d",
   217 => x"ec4c4dc0",
   218 => x"a6c47ebf",
   219 => x"d1f1c248",
   220 => x"1ec178bf",
   221 => x"49c71ec0",
   222 => x"c887cdfd",
   223 => x"02987086",
   224 => x"49ff87ce",
   225 => x"c187ccfb",
   226 => x"dfff49da",
   227 => x"4dc187fa",
   228 => x"97c4f1c2",
   229 => x"87c302bf",
   230 => x"c287c4d0",
   231 => x"4bbfc9f1",
   232 => x"bfedd6c2",
   233 => x"87ebc005",
   234 => x"ff49fdc3",
   235 => x"c387d9df",
   236 => x"dfff49fa",
   237 => x"497387d2",
   238 => x"7199ffc3",
   239 => x"fb49c01e",
   240 => x"497387cb",
   241 => x"7129b7c8",
   242 => x"fa49c11e",
   243 => x"86c887ff",
   244 => x"c287c0c6",
   245 => x"4bbfcdf1",
   246 => x"87dd029b",
   247 => x"bfe9d6c2",
   248 => x"87ddc749",
   249 => x"c4059870",
   250 => x"d24bc087",
   251 => x"49e0c287",
   252 => x"c287c2c7",
   253 => x"c658edd6",
   254 => x"e9d6c287",
   255 => x"7378c048",
   256 => x"0599c249",
   257 => x"ebc387ce",
   258 => x"fbddff49",
   259 => x"c2497087",
   260 => x"87c20299",
   261 => x"49734cfb",
   262 => x"ce0599c1",
   263 => x"49f4c387",
   264 => x"87e4ddff",
   265 => x"99c24970",
   266 => x"fa87c202",
   267 => x"c849734c",
   268 => x"87ce0599",
   269 => x"ff49f5c3",
   270 => x"7087cddd",
   271 => x"0299c249",
   272 => x"f1c287d5",
   273 => x"ca02bfd5",
   274 => x"88c14887",
   275 => x"58d9f1c2",
   276 => x"ff87c2c0",
   277 => x"734dc14c",
   278 => x"0599c449",
   279 => x"f2c387ce",
   280 => x"e3dcff49",
   281 => x"c2497087",
   282 => x"87dc0299",
   283 => x"bfd5f1c2",
   284 => x"b7c7487e",
   285 => x"cbc003a8",
   286 => x"c1486e87",
   287 => x"d9f1c280",
   288 => x"87c2c058",
   289 => x"4dc14cfe",
   290 => x"ff49fdc3",
   291 => x"7087f9db",
   292 => x"0299c249",
   293 => x"f1c287d5",
   294 => x"c002bfd5",
   295 => x"f1c287c9",
   296 => x"78c048d5",
   297 => x"fd87c2c0",
   298 => x"c34dc14c",
   299 => x"dbff49fa",
   300 => x"497087d6",
   301 => x"c00299c2",
   302 => x"f1c287d9",
   303 => x"c748bfd5",
   304 => x"c003a8b7",
   305 => x"f1c287c9",
   306 => x"78c748d5",
   307 => x"fc87c2c0",
   308 => x"c04dc14c",
   309 => x"c003acb7",
   310 => x"66c487d1",
   311 => x"82d8c14a",
   312 => x"c6c0026a",
   313 => x"744b6a87",
   314 => x"c00f7349",
   315 => x"1ef0c31e",
   316 => x"f749dac1",
   317 => x"86c887d2",
   318 => x"c0029870",
   319 => x"a6c887e2",
   320 => x"d5f1c248",
   321 => x"66c878bf",
   322 => x"c491cb49",
   323 => x"80714866",
   324 => x"bf6e7e70",
   325 => x"87c8c002",
   326 => x"c84bbf6e",
   327 => x"0f734966",
   328 => x"c0029d75",
   329 => x"f1c287c8",
   330 => x"f349bfd5",
   331 => x"d6c287c0",
   332 => x"c002bff1",
   333 => x"c24987dd",
   334 => x"987087c7",
   335 => x"87d3c002",
   336 => x"bfd5f1c2",
   337 => x"87e6f249",
   338 => x"c6f449c0",
   339 => x"f1d6c287",
   340 => x"f478c048",
   341 => x"87e0f38e",
   342 => x"5c5b5e0e",
   343 => x"711e0e5d",
   344 => x"d1f1c24c",
   345 => x"cdc149bf",
   346 => x"d1c14da1",
   347 => x"747e6981",
   348 => x"87cf029c",
   349 => x"744ba5c4",
   350 => x"d1f1c27b",
   351 => x"fff249bf",
   352 => x"747b6e87",
   353 => x"87c4059c",
   354 => x"87c24bc0",
   355 => x"49734bc1",
   356 => x"d487c0f3",
   357 => x"87c70266",
   358 => x"7087da49",
   359 => x"c087c24a",
   360 => x"f5d6c24a",
   361 => x"cff2265a",
   362 => x"00000087",
   363 => x"00000000",
   364 => x"00000000",
   365 => x"4a711e00",
   366 => x"49bfc8ff",
   367 => x"2648a172",
   368 => x"c8ff1e4f",
   369 => x"c0fe89bf",
   370 => x"c0c0c0c0",
   371 => x"87c401a9",
   372 => x"87c24ac0",
   373 => x"48724ac1",
   374 => x"5e0e4f26",
   375 => x"0e5d5c5b",
   376 => x"d4ff4b71",
   377 => x"4866d04c",
   378 => x"49d678c0",
   379 => x"87d0d8ff",
   380 => x"6c7cffc3",
   381 => x"99ffc349",
   382 => x"c3494d71",
   383 => x"e0c199f0",
   384 => x"87cb05a9",
   385 => x"6c7cffc3",
   386 => x"d098c348",
   387 => x"c3780866",
   388 => x"4a6c7cff",
   389 => x"c331c849",
   390 => x"4a6c7cff",
   391 => x"4972b271",
   392 => x"ffc331c8",
   393 => x"714a6c7c",
   394 => x"c84972b2",
   395 => x"7cffc331",
   396 => x"b2714a6c",
   397 => x"c048d0ff",
   398 => x"9b7378e0",
   399 => x"7287c202",
   400 => x"2648757b",
   401 => x"264c264d",
   402 => x"1e4f264b",
   403 => x"5e0e4f26",
   404 => x"f80e5c5b",
   405 => x"c81e7686",
   406 => x"fdfd49a6",
   407 => x"7086c487",
   408 => x"c2486e4b",
   409 => x"f0c203a8",
   410 => x"c34a7387",
   411 => x"d0c19af0",
   412 => x"87c702aa",
   413 => x"05aae0c1",
   414 => x"7387dec2",
   415 => x"0299c849",
   416 => x"c6ff87c3",
   417 => x"c34c7387",
   418 => x"05acc29c",
   419 => x"c487c2c1",
   420 => x"31c94966",
   421 => x"66c41e71",
   422 => x"c292d44a",
   423 => x"7249d9f1",
   424 => x"edccfe81",
   425 => x"ff49d887",
   426 => x"c887d5d5",
   427 => x"dfc21ec0",
   428 => x"e8fd49f2",
   429 => x"d0ff87e9",
   430 => x"78e0c048",
   431 => x"1ef2dfc2",
   432 => x"d44a66cc",
   433 => x"d9f1c292",
   434 => x"fe817249",
   435 => x"cc87f4ca",
   436 => x"05acc186",
   437 => x"c487c2c1",
   438 => x"31c94966",
   439 => x"66c41e71",
   440 => x"c292d44a",
   441 => x"7249d9f1",
   442 => x"e5cbfe81",
   443 => x"f2dfc287",
   444 => x"4a66c81e",
   445 => x"f1c292d4",
   446 => x"817249d9",
   447 => x"87f4c8fe",
   448 => x"d3ff49d7",
   449 => x"c0c887fa",
   450 => x"f2dfc21e",
   451 => x"e7e6fd49",
   452 => x"ff86cc87",
   453 => x"e0c048d0",
   454 => x"fc8ef878",
   455 => x"5e0e87e7",
   456 => x"0e5d5c5b",
   457 => x"ff4d711e",
   458 => x"66d44cd4",
   459 => x"b7c3487e",
   460 => x"87c506a8",
   461 => x"e2c148c0",
   462 => x"fe497587",
   463 => x"7587f8d9",
   464 => x"4b66c41e",
   465 => x"f1c293d4",
   466 => x"497383d9",
   467 => x"87f1c2fe",
   468 => x"4b6b83c8",
   469 => x"c848d0ff",
   470 => x"7cdd78e1",
   471 => x"ffc34973",
   472 => x"737c7199",
   473 => x"29b7c849",
   474 => x"7199ffc3",
   475 => x"d049737c",
   476 => x"ffc329b7",
   477 => x"737c7199",
   478 => x"29b7d849",
   479 => x"7cc07c71",
   480 => x"7c7c7c7c",
   481 => x"7c7c7c7c",
   482 => x"c07c7c7c",
   483 => x"66c478e0",
   484 => x"ff49dc1e",
   485 => x"c887ced2",
   486 => x"26487386",
   487 => x"1e87e4fa",
   488 => x"bfc8dfc2",
   489 => x"c2b9c149",
   490 => x"ff59ccdf",
   491 => x"ffc348d4",
   492 => x"48d0ff78",
   493 => x"ff78e1c0",
   494 => x"78c148d4",
   495 => x"787131c4",
   496 => x"c048d0ff",
   497 => x"4f2678e0",
   498 => x"00000000",
  others => ( x"00000000")
);

-- Xilinx Vivado attributes
attribute ram_style: string;
attribute ram_style of ram: signal is "block";

signal q_local : std_logic_vector((NB_COL * COL_WIDTH)-1 downto 0);

signal wea : std_logic_vector(NB_COL - 1 downto 0);

begin

	output:
	for i in 0 to NB_COL - 1 generate
		q((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH) <= q_local((i+1) * COL_WIDTH - 1 downto i * COL_WIDTH);
	end generate;
    
    -- Generate write enable signals
    -- The Block ram generator doesn't like it when the compare is done in the if statement it self.
    wea <= bytesel when we = '1' else (others => '0');

    process(clk)
    begin
        if rising_edge(clk) then
            q_local <= ram(to_integer(unsigned(addr)));
            for i in 0 to NB_COL - 1 loop
                if (wea(NB_COL-i-1) = '1') then
                    ram(to_integer(unsigned(addr)))((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH) <= d((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH);
                end if;
            end loop;
        end if;
    end process;

end arch;
